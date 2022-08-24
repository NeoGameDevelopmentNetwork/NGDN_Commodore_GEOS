; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;--- Modul-Information:
;* Arbeitsplatz-Menü.

;*** Symboltabellen.
if .p
			t "opt.GDOSl10n.ext"
			t "SymbTab_GDOS"
			t "SymbTab_1"
			t "SymbTab_GTYP"
			t "SymbTab_DTYP"
			t "SymbTab_APPS"
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
			n "obj.GD32"
			f DATA

			o BASE_GDMENU

;*** Sprungtabelle.
;:MAININIT		jmp	OpenMyComp

;*** PopUp/Arbeitsplatz
:OpenMyComp		ldx	MyCompEntry +0
if MAXENTRY16BIT = TRUE
			ldy	MyCompEntry +1
			bne	:exit
endif

			cpx	#$04			;Rechtsklick auf Drucker?
			beq	:print			; => Ja, weiter...
			cpx	#$05			;Rechtsklick auf Eingabegerät?
			beq	:input			; => Ja, weiter...
			bcs	:exit			; => Rechtsklick ungültig.

			lda	driveType,x		;Existiert Laufwerk?
			beq	:exit			; => Rechtsklick ungültig.
			lda	RealDrvMode,x		;Laufwerksmodus einlesen.
			and	#SET_MODE_PARTITION!SET_MODE_SD2IEC
			bne	:part			; => Nein, weiter...

::drive			LoadW	r0,menuComp_Drive
			LoadB	r5H,widthComp_Drive
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

::part			LoadW	r0,menuComp_SDCMD
			LoadB	r5H,widthComp_SDCMD
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

::print			LoadW	r0,menuComp_Prnt
			LoadB	r5H,widthComp_Prnt
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

::input			LoadW	r0,menuComp_Inpt
			LoadB	r5H,widthComp_Inpt
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

::exit			rts

;*** MyComputer/Laufwerk CMD/SD2IEC
if LANG = LANG_DE
:widthComp_SDCMD = $5f
endif
if LANG = LANG_EN
:widthComp_SDCMD = $57
endif

:menuComp_SDCMD		b $00,$00
			w $0000,$0000

			b 7!VERTICAL

			w :t1				;Neue Ansicht.
			b MENU_ACTION
			w :m1

			w :t2				;Laufwerk öffnen.
			b MENU_ACTION
			w :m2

			w :t3				;Validate.
			b MENU_ACTION
			w :m3

			w :t4				;Disk-Info.
			b MENU_ACTION
			w :m4

			w :t5				;Partition/DiskImage wechseln.
			b MENU_ACTION
			w :m5

			w :t6				;Diskette löschen.
			b MENU_ACTION
			w :m6

			w :t7				;Diskette formatieren.
			b MENU_ACTION
			w :m7

if LANG = LANG_DE
::t1			b "Neue Ansicht",NULL
::t2			b "Laufwerk öffnen",NULL
::t3			b "Überprüfen",NULL
::t4			b "Eigenschaften",NULL
::t5			b "Partition wechseln",NULL
::t6			b "Löschen",NULL
::t7			b "Formatieren",NULL
endif

if LANG = LANG_EN
::t1			b "New view",NULL
::t2			b "Open drive",NULL
::t3			b "Validate",NULL
::t4			b "Properties",NULL
::t5			b "Switch partition",NULL
::t6			b "Clear drive",NULL
::t7			b "Format disk",NULL
endif

::m1			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MYCOMP_NEWVIEW		;Neue Ansicht.

::m2			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MYCOMP_OPENDRV		;Laufwerk öffnen.

::m3			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MYCOMP_VALIDATE		;Validate.

::m4			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MYCOMP_DISKINFO		;Disk-Info.

::m5			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MYCOMP_PART		;Partition/DiskImage wechseln.

::m6			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MYCOMP_CLRDRV		;Diskette löschen.

::m7			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MYCOMP_FRMTDRV		;Diskette formatieren.

;*** MyComputer/Laufwerk
if LANG = LANG_DE
:widthComp_Drive = $57
endif
if LANG = LANG_EN
:widthComp_Drive = $4f
endif

:menuComp_Drive		b $00,$00
			w $0000,$0000

			b 6!VERTICAL

			w :t1				;Neue Ansicht.
			b MENU_ACTION
			w :m1

			w :t2				;Laufwerk öffnen.
			b MENU_ACTION
			w :m2

			w :t3				;Validate.
			b MENU_ACTION
			w :m3

			w :t4				;DiskInfo.
			b MENU_ACTION
			w :m4

			w :t5				;Diskette löschen.
			b MENU_ACTION
			w :m5

			w :t6				;Diskette formatieren.
			b MENU_ACTION
			w :m6

if LANG = LANG_DE
::t1			b "Neue Ansicht",NULL
::t2			b "Laufwerk öffnen",NULL
::t3			b "Überprüfen",NULL
::t4			b "Eigenschaften",NULL
::t5			b "Löschen",NULL
::t6			b "Formatieren",NULL
endif

if LANG = LANG_EN
::t1			b "New view",NULL
::t2			b "Open drive",NULL
::t3			b "Validate",NULL
::t4			b "Properties",NULL
::t5			b "Clear drive",NULL
::t6			b "Format disk",NULL
endif

::m1			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MYCOMP_NEWVIEW		;Neue Ansicht.

::m2			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MYCOMP_OPENDRV		;Laufwerk öffnen.

::m3			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MYCOMP_VALIDATE		;Validate.

::m4			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MYCOMP_DISKINFO		;DiskInfo.

::m5			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MYCOMP_CLRDRV		;Diskette löschen.

::m6			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MYCOMP_FRMTDRV		;Diskette formatieren.

;*** MyComputer/Drucker
if LANG = LANG_DE
:widthComp_Prnt = $67
endif
if LANG = LANG_EN
:widthComp_Prnt = $4f
endif

:menuComp_Prnt		b $00,$00
			w $0000,$0000

			b 2!VERTICAL

			w :t1				;Drucker auswählen.
			b MENU_ACTION
			w :m1

			w PrntFileName			;Druckername anzeigen/auswählen.
			b MENU_ACTION
			w :m1

if LANG = LANG_DE
::t1			b BOLDON
			b "Drucker"
			b PLAINTEXT,NULL
endif

if LANG = LANG_EN
::t1			b BOLDON
			b "Printer"
			b PLAINTEXT,NULL
endif

::m1			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	AL_SWAP_PRINTER

;*** MyComputer/Eingabe
if LANG = LANG_DE
:widthComp_Inpt = $67
endif
if LANG = LANG_EN
:widthComp_Inpt = $4f
endif

:menuComp_Inpt		b $00,$00
			w $0000,$0000

			b 2!VERTICAL

			w :t1
			b MENU_ACTION
			w :m1

			w inputDevName
			b MENU_ACTION
			w :m1

if LANG = LANG_DE
::t1			b BOLDON
			b "Eingabegerät"
			b PLAINTEXT,NULL
endif

if LANG = LANG_EN
::t1			b BOLDON
			b "Input device"
			b PLAINTEXT,NULL
endif

::m1			jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	AL_OPEN_INPUT

;******************************************************************************
;Sicherstellen das genügend Speicher
;für Menü-Daten verfügbar ist.
			g BASE_GDMENU +SIZE_GDMENU -1
;******************************************************************************
