; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;--- Modul-Information:
;* Dateifenster/Disk-Menü.

;*** Symboltabellen.
if .p
			t "opt.GDOSl10n.ext"
			t "SymbTab_CROM"
			t "SymbTab_CXIO"
			t "SymbTab_GDOS"
			t "SymbTab_1"
			t "SymbTab_GTYP"
			t "SymbTab_APPS"
			t "SymbTab_DISK"
			t "SymbTab_CHAR"
			t "MacTab"

;--- Labels für GeoDesk64.
			t "TopSym.GD"

;--- Externe Labels.
			t "s.GD.10.Core.ext"
			t "s.GD.20.WM.ext"
			t "s.GD.21.Desk.ext"
endif

;*** GEOS-Header.
			n "obj.GD35"
			f DATA

			o BASE_GDMENU

;*** Sprungtabelle.
;:MAININIT		jmp	OpenDiskMenu

;*** PopUp/Dateifenster.
:OpenDiskMenu		php				;Tastaturabfrage:
			sei				;CBM + Rechter Mausklick?
			ldx	CPU_DATA
			lda	#$35
			sta	CPU_DATA
			lda	#%01111111
			sta	cia1base +0
			lda	cia1base +1
			stx	CPU_DATA
			plp

			and	#%00100000		;Rechter Mausklick = CBM-Menü?
			bne	:disk_menu		; => Nein, Disk-Menü anzeigen...

::cbm_menu		lda	#1!VERTICAL		;Laufwerksliste initialisieren.
			sta	menuCDIRnum

			LoadW	menuCDIR_1 +0,t40
			LoadW	menuCDIR_1 +3,m40

			ldx	#GMOD_CBMDISK
			ldy	GD_DACC_ADDR_B,x	;CBMDISK-Modul installiert?
			beq	:no_cbmutil		; => Nein, weiter...
::cbmutil		lda	#PLAINTEXT
			b $2c
::no_cbmutil		lda	#ITALICON
			sta	t31
			sta	t32

			cmp	#ITALICON		;Modul installiert?
			beq	:init_cbmutil		; => Nein, weiter...

			jsr	InitDrvMenu		;Laufwerksliste aktualisieren.

::init_cbmutil		LoadW	r0,menuSub_CBM		; -> CBM-Disk.
			LoadB	r5H,widthSub_CBM
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

::disk_menu		lda	#2!VERTICAL		;Anzahl Menüeinträge zurücksetzen.
			sta	menuSub_Other +6

			jsr	GetBorderBlock		;Adresse Borderblock ermitteln.
			txa				;Diskettenfehler?
			bne	:init_disk		; => Ja, kein Borderblock-Menü.
			tya				;Keine GEOS-Diskette?
			bne	:init_disk		; => Ja, kein Borderblock-Menü.

			lda	#3!VERTICAL		;GEOS-Diskette -> Borderblock.
			sta	menuSub_Other +6

::init_disk		ldx	WM_WCODE		;Fenster-Nr. einlesen.

			ldy	#" "			;Anzeige: Größe in KByte/Blocks.
			lda	WMODE_VSIZE,x
			bpl	:1
			ldy	#"*"
::1			sty	t11 +1			;Extra Byte "BOLDON" überspringen!

			ldy	#" "			;Anzeige: Icons/Text.
			lda	WMODE_VICON,x
			bpl	:2
			ldy	#"*"
::2			sty	t12 +1

			ldy	#" "			;Anzeige: Details anzeigen.
			lda	WMODE_VINFO,x
			bpl	:3
			ldy	#"*"
::3			sty	t13 +1

			ldy	#" "			;Anzeige: Ausgabe bremsen.
			lda	GD_SLOWSCR
			bpl	:4
			ldy	#"*"
::4			sty	t14 +1

			ldy	#" "			;Anzeige: Dateifilter.
			lda	WMODE_FILTER,x
			beq	:5
			ldy	#"*"
::5			sty	t04 +1

;			ldx	WM_WCODE		;Fenster-Nr. einlesen.
			lda	WIN_DATAMODE,x		;Partitionsauswahl aktiv?
			and	#%11000000
			beq	:disk			; => Ja, weiter...

;--- PopUp/Partitionsauswahl.
::part			LoadW	r0,menuSub_View		; -> Anzeige.
			LoadB	r5H,widthSub_View
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

;--- PopUp/Dateifenster.
::disk			ldx	#GMOD_GPSHOW
			ldy	GD_DACC_ADDR_B,x	;GPShow-Modul installiert?
			beq	:no_gpshow		; => Nein, weiter...
::gpshow		lda	#PLAINTEXT
			b $2c
::no_gpshow		lda	#ITALICON
			sta	t27

			ldx	#GMOD_DIRSORT
			ldy	GD_DACC_ADDR_B,x	;DirSort-Modul installiert?
			beq	:no_dirsort		; => Nein, weiter...
::dirsort		lda	#PLAINTEXT
			b $2c
::no_dirsort		lda	#ITALICON
			sta	t23

			LoadW	r0,menuDisk		; -> Disk.
			LoadB	r5H,widthDiskMenu
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

;*** Laufwerksmenü initialisieren.
:InitDrvMenu		php				;Intrerrupt sperren.
			sei

			lda	curDevice		;Aktuelles Laufwerk
			pha				;zwischenspeichern.

			jsr	ExitTurbo		;TurboDOS abschalten.
			jsr	InitForIO		;I/O-Bereich einblenden.

			lda	#$00			;Anzahl Laufwerke.
			sta	r0L
			lda	#$08			;Startadresse Laufwerke ser.Bus.
			sta	r0H

			LoadW	r1,menuCDIR_1		;Zeiger auf Menütabelle.

::loop			lda	#$00
			sta	STATUS
;			ldx	#< fname
;			ldy	#> fname
			jsr	SETNAM			;Kein Dateiname.

			lda	#5
			tay
			ldx	r0H
			jsr	SETLFS			;Daten für Laufwerk.

			jsr	OPENCHN			;Laufwerk öffnen.

			lda	#5			;Laufwerk schließen.
			jsr	CLOSE

			lda	STATUS			;Laufwerk vorhanden?
			bne	:next			; => Nein, weiter...

			ldx	r0L			;Eintrag in Laufwerksliste
			lda	r0H			;erstellen.
			sta	menuCDIRdrv,x
			txa
			asl
			asl
			tax
			ldy	#$00
			lda	menuCDIRtab,x
			sta	(r1L),y
			sta	r2L
			inx
			iny
			lda	menuCDIRtab,x
			sta	(r1L),y
			sta	r2H
			inx
			iny
			iny
			lda	menuCDIRtab,x
			sta	(r1L),y
			inx
			iny
			lda	menuCDIRtab,x
			sta	(r1L),y

			lda	r0H			;Geräteadresse in
			jsr	DEZ2ASCII		;Menüeintrag kopieren.
			cpx	#"0"
			bne	:1
			tax
			lda	#NULL

::1			ldy	#menuCDIRpos
			sta	(r2L),y
			txa
			dey
			sta	(r2L),y

			inc	r0L
			lda	r0L
			cmp	#8 +1			;Max. 8 Laufwerke gefunden?
			bcs	:end			; => Ja, Ende...
			ora	#VERTICAL
			sta	menuCDIRnum		;Anzahl Menüeinträge korrigieren.

			AddVBW	5,r1			;Zeiger auf nächsten Menüeintrag.

::next			inc	r0H
			lda	r0H
			cmp	#29 +1			;Alle Laufwerke getestet?
			bcs	:end			; => Ja, Ende...
			jmp	:loop			; => Weiter mit nächstem Laufwerk...

::end			jsr	DoneWithIO		;I/O-Bereich ausblenden.

			pla
			sta	curDevice		;Aktuelles Laufwerk zurücksetzen.

			plp				;Interrupt zurücksetzen.
			rts

;*** PopUp/Dateifenster.
if LANG = LANG_DE
:widthDiskMenu = $4f
endif
if LANG = LANG_EN
:widthDiskMenu = $4f
endif

:menuDisk		b $00,$00
			w $0000,$0000

			b 8!VERTICAL

			w t01				;Verzeichnis neu laden.
			b MENU_ACTION
			w :m1

			w t02				;Neue Ansicht öffnen.
			b MENU_ACTION
			w :m2

			w t03				;>> Auswahl.
			b DYN_SUB_MENU
			w :m3

			w t04				;>> Dateifilter.
			b DYN_SUB_MENU
			w :m4

			w t05				;>> Sortieren.
			b DYN_SUB_MENU
			w :m5

			w t06				;>> Anzeige.
			b DYN_SUB_MENU
			w :m6

			w t07				;>> Diskette.
			b DYN_SUB_MENU
			w :m7

			w t08				;Applink erstellen.
			b MENU_ACTION
			w :m8

::m1			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_RELOAD_DISK		;Verzeichnis neu laden.

::m2			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_NEW_VIEW		;Neue Ansicht öffnen.

::m3			LoadW	r0,menuSub_Slct		; -> Auswahl.
			LoadB	r5H,widthSub_Slct
			jsr	MENU_SET_SIZE
			jmp	MENU_SETINT_r0

::m4			LoadW	r0,menuSub_Filter	; -> Dateifilter.
			LoadB	r5H,widthSub_Filter
			jsr	MENU_SET_SIZE
			jmp	MENU_SETINT_r0

::m5			LoadW	r0,menuSub_Sort		; -> Sortieren.
			LoadB	r5H,widthSub_Sort
			jsr	MENU_SET_SIZE
			jmp	MENU_SETINT_r0

::m6			LoadW	r0,menuSub_View		; -> Anzeige.
			LoadB	r5H,widthSub_View
			jsr	MENU_SET_SIZE
			jmp	MENU_SETINT_r0

::m7			LoadW	r0,menuSub_Disk		; -> Diskette.
			LoadB	r5H,widthSub_Disk
			jsr	MENU_SET_SIZE
			jmp	MENU_SETINT_r0

::m8			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_CREATE_AL		;AppLink erstellen.

if LANG = LANG_DE
:t01			b "Neu laden",NULL
:t02			b "Neue Ansicht",NULL
:t03			b ">> Auswahl",NULL
:t04			b "( ) Dateifilter",NULL
:t05			b ">> Sortieren",NULL
:t06			b ">> Anzeige",NULL
:t07			b ">> Laufwerk",NULL
:t08			b "AppLink erstellen",NULL
endif

if LANG = LANG_EN
:t01			b "Reload files",NULL
:t02			b "New view",NULL
:t03			b ">> Select files",NULL
:t04			b "( ) Filter",NULL
:t05			b ">> Sort mode",NULL
:t06			b ">> View mode",NULL
:t07			b ">> Disk/Drive",NULL
:t08			b "Create AppLink",NULL
endif

;*** PopUp/Dateifenster -> Auswahl.
if LANG = LANG_DE
:widthSub_Slct = $57
endif
if LANG = LANG_EN
:widthSub_Slct = $3f
endif

:menuSub_Slct		b $00,$00
			w $0000,$0000

			b 2!VERTICAL

			w :t1				;Auswahl: Alle auswählen.
			b MENU_ACTION
			w :m1

			w :t2				;Auswahl: Keine auswählen.
			b MENU_ACTION
			w :m2

::m1			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_SELECT_ALL		;Alle Dateien auswählen.

::m2			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_SELECT_NONE		;Dateiauswahl aufheben.

if LANG = LANG_DE
::t1			b "Alle auswählen",NULL
::t2			b "Auswahl aufheben",NULL
endif

if LANG = LANG_EN
::t1			b "Select all",NULL
::t2			b "Unselect all",NULL
endif

;*** PopUp/Dateifenster -> Dateifilter.
if LANG = LANG_DE
:widthSub_Filter = $57
endif
if LANG = LANG_EN
:widthSub_Filter = $4f
endif

:menuSub_Filter		b $00,$00
			w $0000,$0000

			b 8!VERTICAL

			w :t1				;Filter: Alle Dateien.
			b MENU_ACTION
			w :m1

			w :t2				;Filter: Anwendungen.
			b MENU_ACTION
			w :m2

			w :t3				;Filter: AutoStart-Programme.
			b MENU_ACTION
			w :m3

			w :t4				;Filter: Dokumente.
			b MENU_ACTION
			w :m4

			w :t5				;Filter: Hilfsmittel.
			b MENU_ACTION
			w :m5

			w :t6				;Filter: Zeichensätze.
			b MENU_ACTION
			w :m6

			w :t7				;Menü: Systemdateien.
			b DYN_SUB_MENU
			w :m7

			w :t8				;Menü: Andere Dateien.
			b DYN_SUB_MENU
			w :m8

::m1			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FILTER_ALL		;Filter: Alle Dateien.

::m2			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FILTER_APPS		;Filter: Anwendungen.

::m3			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FILTER_EXEC		;Filter: AutoStart-Programme.

::m4			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FILTER_DOCS		;Filter: Dokumente.

::m5			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FILTER_DA		;Filter: Hilfsmittel.

::m6			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FILTER_FONT		;Filter: Zeichensätze.

::m7			LoadW	r0,menuSub_Device	; -> Gerätetreiber.
			LoadB	r5H,widthSub_Device
			jsr	MENU_SET_SIZE
			jmp	MENU_SETINT_r0

::m8			LoadW	r0,menuSub_Other	; -> Andere Dateien.
			LoadB	r5H,widthSub_Other
			jsr	MENU_SET_SIZE
			jmp	MENU_SETINT_r0

if LANG = LANG_DE
::t1			b "Alle Dateien",NULL
::t2			b "Anwendungen",NULL
::t3			b "Autostart",NULL
::t4			b "Dokumente",NULL
::t5			b "Hilfsmittel",NULL
::t6			b "Zeichensatz",NULL
::t7			b ">> Systemdateien",NULL
::t8			b ">> Andere Dateien",NULL
endif

if LANG = LANG_EN
::t1			b "All files",NULL
::t2			b "Applications",NULL
::t3			b "Autoexec files",NULL
::t4			b "Documents",NULL
::t5			b "DeskAccessories",NULL
::t6			b "Fonts",NULL
::t7			b ">> System files",NULL
::t8			b ">> Other files",NULL
endif

;*** PopUp/Dateifenster -> Filter -> Systemdateien.
if LANG = LANG_DE
:widthSub_Device = $4f
endif
if LANG = LANG_EN
:widthSub_Device = $47
endif

:menuSub_Device		b $00,$00
			w $0000,$0000

			b 4!VERTICAL

			w :t1				;Filter: Systemdateien.
			b MENU_ACTION
			w :m1

			w :t2				;Filter: Druckertreiber.
			b MENU_ACTION
			w :m2

			w :t3				;Filter: Eingabetreiber.
			b MENU_ACTION
			w :m3

			w :t4				;Filter: Laufwerkstreiber.
			b MENU_ACTION
			w :m4

::m1			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FILTER_SYS		;Filter: Systemdateien.

::m2			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FILTER_PRNT		;Filter: Druckertreiber.

::m3			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FILTER_INPT		;Filter: Eingabetreiber.

::m4			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FILTER_DISK		;Filter: Laufwerkstreiber.

if LANG = LANG_DE
::t1			b "Systemdateien",NULL
::t2			b "Druckertreiber",NULL
::t3			b "Eingabetreiber",NULL
::t4			b "Laufwerkstreiber",NULL
endif

if LANG = LANG_EN
::t1			b "System files",NULL
::t2			b "Printer device",NULL
::t3			b "Input device",NULL
::t4			b "Disk device",NULL
endif

;*** PopUp/Dateifenster -> Filter -> Andere...
if LANG = LANG_DE
:widthSub_Other = $57
endif
if LANG = LANG_EN
:widthSub_Other = $4f
endif

:menuSub_Other		b $00,$00
			w $0000,$0000

			b 3!VERTICAL

			w :t1				;Filter: BASIC-Programme.
			b MENU_ACTION
			w :m1

			w :t2				;Filter: Gelöschte Dateien.
			b MENU_ACTION
			w :m2

			w :t3				;Filter: Borderblock.
			b MENU_ACTION
			w :m3

::m1			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FILTER_BASIC		;Filter: BASIC-Programme.

::m2			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FILTER_DEL		;Filter: Gelöschte Dateien.

::m3			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FILTER_BORDER	;Filter: Borderblock.

if LANG = LANG_DE
::t1			b "BASIC-Programme",NULL
::t2			b "Gelöschte Dateien",NULL
::t3			b "Borderblock",NULL
endif

if LANG = LANG_EN
::t1			b "BASIC programs",NULL
::t2			b "Deleted files",NULL
::t3			b "Borderblock",NULL
endif

;*** PopUp/Dateifenster -> Sortieren.
if LANG = LANG_DE
:widthSub_Sort = $4f
endif
if LANG = LANG_EN
:widthSub_Sort = $4f
endif

:menuSub_Sort		b $00,$00
			w $0000,$0000

			b 7!VERTICAL

			w :t1				;Sortieren: Name.
			b MENU_ACTION
			w :m1

			w :t2				;Sortieren: Dateigröße.
			b MENU_ACTION
			w :m2

			w :t3				;Sortieren: Datum Alt->Neu.
			b MENU_ACTION
			w :m3

			w :t4				;Sortieren: Datum Neu->Alt.
			b MENU_ACTION
			w :m4

			w :t5				;Sortieren: CBM-Dateityp.
			b MENU_ACTION
			w :m5

			w :t6				;Sortieren: GEOS-Dateityp.
			b MENU_ACTION
			w :m6

			w :t7				;Sortieren: Unsortiert.
			b MENU_ACTION
			w :m7

::m1			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_SORT_NAME		;Sortieren: Name.

::m2			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_SORT_SIZE		;Sortieren: Dateigröße.

::m3			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_SORT_DATE_OLD	;Sortieren: Datum Alt->Neu.

::m4			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_SORT_DATE_NEW	;Sortieren: Datum Neu->Alt.

::m5			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_SORT_TYPE		;Sortieren: CBM-Dateityp.

::m6			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_SORT_GEOS		;Sortieren: GEOS-Dateityp.

::m7			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_SORT_NONE		;Sortieren: Unsortiert.

if LANG = LANG_DE
::t1			b "Dateiname",NULL
::t2			b "Dateigröße",NULL
::t3			b "Datum Alt->Neu",NULL
::t4			b "Datum Neu->Alt",NULL
::t5			b "Dateityp",NULL
::t6			b "GEOS-Dateityp",NULL
::t7			b "Unsortiert",NULL
endif

if LANG = LANG_EN
::t1			b "Filename",NULL
::t2			b "Silesize",NULL
::t3			b "Date Old->New",NULL
::t4			b "Date New->Old",NULL
::t5			b "Filetype",NULL
::t6			b "GEOS-Filetype",NULL
::t7			b "Unsorted",NULL
endif

;*** PopUp/Dateifenster -> Anzeige.
if LANG = LANG_DE
:widthSub_View = $67
endif
if LANG = LANG_EN
:widthSub_View = $6f
endif

:menuSub_View		b $00,$00
			w $0000,$0000

			b 4!VERTICAL

			w t11				;Größe in KByte/Blocks.
			b MENU_ACTION
			w :m1

			w t12				;Textmodus.
			b MENU_ACTION
			w :m2

			w t13				;Details zeigen.
			b MENU_ACTION
			w :m3

			w t14				;Anzeige bremsen.
			b MENU_ACTION
			w :m4

::m1			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_VIEW_SIZE		;Größe in KByte/Blocks.

::m2			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_VIEW_ICONS		;Textmodus.

::m3			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_VIEW_DETAILS		;Details zeigen.

::m4			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_VIEW_SLOWMOVE	;Anzeige bremsen.

if LANG = LANG_DE
:t11			b "( ) Größe in KByte",NULL
:t12			b "( ) Textmodus",NULL
:t13			b "( ) Details zeigen",NULL
:t14			b "( ) Anzeige bremsen",NULL
endif

if LANG = LANG_EN
:t11			b "( ) Size in KBytes",NULL
:t12			b "( ) Textmode",NULL
:t13			b "( ) Show details",NULL
:t14			b "( ) Slow down output",NULL
endif

;*** PopUp/Dateifenster -> Diskette.
if LANG = LANG_DE
:widthSub_Disk = $4f
endif
if LANG = LANG_EN
:widthSub_Disk = $4f
endif

:menuSub_Disk		b $00,$00
			w $0000,$0000

			b 7!VERTICAL

			w t21				;Eigenschaften.
			b MENU_ACTION
			w :m1

			w t22				;Validate.
			b MENU_ACTION
			w :m2

			w t23				;Dateien ordnen.
			b MENU_ACTION
			w :m3

			w t24				;Disk löschen.
			b MENU_ACTION
			w :m4

			w t25				;Diskette bereinigen.
			b MENU_ACTION
			w :m5

			w t26				;Disk formatieren.
			b MENU_ACTION
			w :m6

			w t27				;Diashow.
			b MENU_ACTION
			w :m7

::m1			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MOD_DISKINFO		;Eigenschaften.

::m2			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MOD_VALIDATE		;Validate.

::m3			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MOD_DIRSORT		;Dateien ordnen.

::m4			lda	#%01000000		;Andere Fenster schließen.
			sta	drvUpdFlag
			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MOD_CLRDISK		;Disk löschen.

::m5			lda	#%01000000		;Andere Fenster schließen.
			sta	drvUpdFlag
			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MOD_PURGEDISK		;Diskette bereinigen.

::m6			lda	#%01000000		;Andere Fenster schließen.
			sta	drvUpdFlag
			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_FORMAT_DISK		;Disk formatieren.

::m7			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MOD_GPSHOW		;Diashow.

if LANG = LANG_DE
:t21			b "Eigenschaften",NULL
:t22			b "Überprüfen",NULL
:t23			b PLAINTEXT
			b "Dateien ordnen"
			b PLAINTEXT,NULL
:t24			b "Löschen",NULL
:t25			b "Bereinigen",NULL
:t26			b "Formatieren",NULL
:t27			b PLAINTEXT
			b "DiaShow"
			b PLAINTEXT,NULL
endif

if LANG = LANG_EN
:t21			b "Properties",NULL
:t22			b "Validate",NULL
:t23			b PLAINTEXT
			b "Organize files"
			b PLAINTEXT,NULL
:t24			b "Clear drive",NULL
:t25			b "Purge data",NULL
:t26			b "Format disk",NULL
:t27			b PLAINTEXT
			b "Slide show"
			b PLAINTEXT,NULL
endif

;*** PopUp/Dateifenster -> CBM/Disk.
if LANG = LANG_DE
:widthSub_CBM = $4f
endif
if LANG = LANG_EN
:widthSub_CBM = $4f
endif

:menuSub_CBM		b $00,$00
			w $0000,$0000

			b 2!VERTICAL

:menuCBM_1		w t31				;>> Verzeichnis.
			b DYN_SUB_MENU
			w m31

			w t32				;Auswahl: Keine auswählen.
			b MENU_ACTION
			w m32

:m31			LoadW	r0,menuSub_CDIR		; -> Laufwerke anzeigen.
			LoadB	r5H,widthSub_CDIR
			jsr	MENU_SET_SIZE
			jmp	MENU_SETINT_r0

:m32			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MOD_CBM_COM		;Befehl senden.

if LANG = LANG_DE
:t31			b PLAINTEXT
			b ">> Verzeichnis",NULL
:t32			b PLAINTEXT
			b "Befehl senden",NULL
endif

if LANG = LANG_EN
:t31			b PLAINTEXT
			b ">> Directory",NULL
:t32			b PLAINTEXT
			b "Send command",NULL
endif

;*** PopUp/Dateifenster -> Laufwerke.
if LANG = LANG_DE
:widthSub_CDIR = $47
endif
if LANG = LANG_EN
:widthSub_CDIR = $3f
endif

:menuSub_CDIR		b $00,$00
			w $0000,$0000

:menuCDIRnum		b 8!VERTICAL

:menuCDIR_1		w t41				;Laufwerk#1.
			b MENU_ACTION
			w m41

			w t42				;Laufwerk#2.
			b MENU_ACTION
			w m42

			w t43				;Laufwerk#3.
			b MENU_ACTION
			w m43

			w t44				;Laufwerk#4.
			b MENU_ACTION
			w m44

			w t45				;Laufwerk#5.
			b MENU_ACTION
			w m45

			w t46				;Laufwerk#6.
			b MENU_ACTION
			w m46

			w t47				;Laufwerk#7.
			b MENU_ACTION
			w m47

			w t48				;Laufwerk#8.
			b MENU_ACTION
			w m48

:m40			jmp	EXIT_POPUP_MENU		;PopUp-Menü beenden.

:m41			ldx	#0
			b $2c
:m42			ldx	#1
			b $2c
:m43			ldx	#2
			b $2c
:m44			ldx	#3
			b $2c
:m45			ldx	#4
			b $2c
:m46			ldx	#5
			b $2c
:m47			ldx	#6
			b $2c
:m48			ldx	#7
			lda	menuCDIRdrv,x
			sta	getFileDrv		;Laufwerk setzen.

			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MOD_CBM_DIR		;Verzeichnis anzeigen.

if LANG = LANG_DE
:t40			b PLAINTEXT,ITALICON
			b "Unbekannt..."
			b PLAINTEXT,NULL
:t41			b "Laufwerk #00",NULL
:t42			b "Laufwerk #00",NULL
:t43			b "Laufwerk #00",NULL
:t44			b "Laufwerk #00",NULL
:t45			b "Laufwerk #00",NULL
:t46			b "Laufwerk #00",NULL
:t47			b "Laufwerk #00",NULL
:t48			b "Laufwerk #00",NULL
:menuCDIRpos		= 10 +1
endif

if LANG = LANG_EN
:t40			b PLAINTEXT,ITALICON
			b "Unknown..."
			b PLAINTEXT,NULL
:t41			b "Drive #00",NULL
:t42			b "Drive #00",NULL
:t43			b "Drive #00",NULL
:t44			b "Drive #00",NULL
:t45			b "Drive #00",NULL
:t46			b "Drive #00",NULL
:t47			b "Drive #00",NULL
:t48			b "Drive #00",NULL
:menuCDIRpos		= 7 +1
endif

:menuCDIRtab		w t41,m41
			w t42,m42
			w t43,m43
			w t44,m44
			w t45,m45
			w t46,m46
			w t47,m47
			w t48,m48

:menuCDIRdrv		s $08

;******************************************************************************
;Sicherstellen das genügend Speicher
;für Menü-Daten verfügbar ist.
			g BASE_GDMENU +SIZE_GDMENU -1
;******************************************************************************
