; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;--- Modul-Information:
;* Datei öffnen.
;* Config öffnen.
;* Drucker wechseln.
;* Eingabegerät wechseln.
;* Dialog: Fehler Drucker-Installation.
;* Dialog: Drucker-Installation OK.
;* Anwendung wählen.
;* AutoExec wählen.
;* Dokumente wählen.
;* geoWrite-Dokument wählen.
;* geoPaint-Dokument wählen.
;* Nach GEOS beenden.
;* Nach BASIC beenden.
;* BASIC-Programm starten.
;* GEOS-Hilfsmittel starten.
;* AppLink-Datei auf anderen Laufwerken suchen.
;* Druckertreiber laden.
;* Eingabetreiber laden.

;*** Symboltabellen.
if .p
			t "opt.GDOSl10n.ext"
			t "SymbTab_GDOS"
			t "SymbTab_GEXT"
			t "SymbTab_1"
			t "SymbTab_GERR"
			t "SymbTab_GTYP"
			t "SymbTab_DTYP"
			t "SymbTab_APPS"
			t "SymbTab_MMAP"
			t "SymbTab_GRFX"
			t "SymbTab_GSPR"
			t "SymbTab_DBOX"
			t "SymbTab_CHAR"
			t "MacTab"

;--- Labels für GeoDesk64.
			t "TopSym.GD"

;--- Externe Labels.
			t "o.DiskCore.ext"
			t "s.GD.10.Core.ext"
			t "s.GD.20.WM.ext"
endif

;*** GEOS-Header.
			n "obj.GD42"
			f DATA

			o VLIR_BASE

;*** Sprungtabelle.
:VlirJumpTable		jmp	StartFile_a0
			jmp	OpenConfig
			jmp	ChangePrinter
			jmp	ChangeInput
			jmp	OpenPrntError
			jmp	OpenPrntOK
			jmp	SelectAppl
			jmp	SelectAuto
			jmp	SelectDocument
			jmp	SelectDocWrite
			jmp	SelectDocPaint
			jmp	ExitGEOS
			jmp	ExitBASIC
			jmp	ExitBAppl
			jmp	SelectDA
			jmp	StartApplink_a0
			jmp	OpenPrinter
			jmp	OpenInput

;*** Speicherverwaltung.
			t "-DA_FreeBank"		;Speicherbank freigeben.

;*** Anwendung starten auf die ":a0" zeigt.
:StartFile_a0		LoadW	r6,fileName
			ldx	#a0L 			;Dateiname aus Verzeichnis-Eintrag
			ldy	#r6L			;in Puffer kopieren.
			jsr	SysCopyFName

			ldy	#15
::1			lda	fileName,y		;Dateiname als Vorgabe für
			sta	AppFName,y		;Anwendungsname kopieren.
			dey
			bpl	:1

			ldy	#$18			;Dateityp auswerten.
			lda	(a0L),y
			beq	:start_basic		; => BASIC-Programm.
			cmp	#APPLICATION		;Anwendung ?
			beq	:start_appl		; => Ja, weiter...
			cmp	#AUTO_EXEC		;AutoExec ?
			beq	:start_appl		; => Ja, weiter...
			cmp	#APPL_DATA		;Dokument ?
			beq	:start_doc		; => Ja, weiter...
			cmp	#DESK_ACC		;Hilfsmittel ?
			beq	:start_da		; => Ja, weiter...
			cmp	#SYSTEM			;System-Datei (GeoDesk-Farben) ?
			beq	:start_system		; => Ja, weiter...
			cmp	#DISK_DEVICE		;Laufwerkstreiber ?
			beq	:start_dskdrv		; => Ja, weiter...

			jmp	OpenFTypError		; => Keine gültige Datei.

::start_appl		jmp	OpenAppl
::start_doc		jmp	OpenDoc
::start_auto		jmp	OpenAppl
::start_da		jmp	OpenDA
::start_basic		jmp	OpenBASIC
::start_system		jmp	OpenSystem
::start_dskdrv		jmp	OpenDskDrv

;*** Unbekannter Dateityp.
:OpenFTypError		ldx	#$82			;"UNKNOWN_FTYPE"
			b $2c

;*** Allgemeiner Dateifehler.
:OpenFNamError		ldx	#$83			;"FILENAME_ERROR"
			b $2c

;*** AppLink nicht gefunden.
:OpenALnkError		ldx	#$85			;"ALNK_NOT_FOUND"
			lda	#< fileName
			ldy	#> fileName
			bne	OpenError

;*** Anwendung für Dokument nicht gefunden.
:OpenFAppError		ldx	#$84			;"APPL_NOT_FOUND"
			lda	#< AppClass
			ldy	#> AppClass
			bne	OpenError

;*** Nicht mit GEOS64 kompatibel.
:OpenG64Error		ldx	#INCOMPATIBLE		;"INCOMPATIBLE"
			lda	#< AppFName
			ldy	#> AppFName
			bne	OpenError

;*** Allgemeiner Laufwerksfehler.
:OpenDiskError		MoveB	r1L,errDrvInfoT		;Track/Sektor für Laufwerksfehler
			MoveB	r1H,errDrvInfoS		;zwischenspeichern.

			ldy	curDrive		;Partition für Laufwerksfehler
			lda	RealDrvMode -8,y	;zwischenspeichern.
			and	#SET_MODE_PARTITION
			beq	:1
			lda	drivePartData -8,y
::1			sta	errDrvInfoP

			lda	#$00			;Kein Dateiname.
			ldy	#$00
;			beq	OpenError

;*** Fehlermeldung ausgeben und zurück zum DeskTop.
:OpenError		stx	errDrvCode		;Fehlercode speichern.

			sta	r0L			;Zeiger auf Dateiname
			sty	r0H			;zwischenspeichern.
			ora	r0H			;Dateiname vorhanden?
			beq	:1			; => Nein, weiter...

			LoadW	r6,dataFileName		;Dateiname in Zwischenspeicher.
			ldx	#r0L			;Muss an eine freie Stelle im RAM
			ldy	#r6L			;kopiert werden, da Sub-Modul
			jsr	CopyString		;sonst evtl. den Namen überschreibt.

			lda	#< dataFileName
			ldy	#> dataFileName
::1			sta	errDrvInfoF +0
			sty	errDrvInfoF +1

			jsr	SUB_STATMSG		;Fehlermeldung ausgeben.

			jmp	MOD_RESTART		;Menü/FensterManager neu starten.

;*** Datei laden vorbereiten.
:PrepGetFile		jsr	ResetScreen		;Bildschirm löschen.

:PrepGetFileDA		jsr	UseSystemFont		;Standardzeichensatz.

			jsr	i_FillRam		;dlgBoxRamBuf löschen.
			w	417
			w	dlgBoxRamBuf
			b	$00

			ldx	#r15H			;ZeroPage löschen.
			lda	#$00
::loop			sta	$0000,x
			dex
			cpx	#r0L
			bcs	:loop
			rts

;*** Name der Anwendung die gestartet werden soll.
;Hinweis:
;Steht für Sub-Module nicht zur
;Verfügfung! ":dataFileName" nutzen.
:fileName		s 17
:AppFName		s 17
:AppClass		s 17
:DocDName		s 17

;*** Applink auf anderen Laufwerken suchen.
;    Übrgabe: a0 = Zeiger auf Dateiname.
:StartApplink_a0	ldy	#0			;Dateiname kopieren.
::1			lda	(a0L),y
			sta	fileName,y
			beq	:2
			iny
			cpy	#16
			bcc	:1

::2			jsr	IsFileOnDsk		;Datei auf allen Laufwerken suchen.
			txa				;Fehler?
			bne	:error			; => Ja, Abbruch...

			LoadW	a0,dirEntryBuf -2
			jmp	StartFile_a0		;Datei öffnen.

::error			jmp	OpenALnkError		;Fehlermeldung anzeigen.

;*** Datei auf allen Laufwerken suchen.
:IsFileOnDsk		lda	#%10000000		;Anwendung auf
			jsr	FindFileAllDrv		;RAM-Laufwerken suchen.
			txa				;Gefunden?
			beq	:1			; => Ja, Ende...
			lda	#%00000000		;Anwendung auf
			jsr	FindFileAllDrv		;Disk-Laufwerken suchen.
::1			rts

;*** Datei auf den Laufwerken A: bis D: suchen.
;Dabei wird auch das 40/80-Flag für
;GEOS128-Anwendungen überprüft.
;
;--- Hinweis:
;Die Suche nach einer bestimmten Datei
;wird auch hier verwendet:
; -105_OpenConfig -> ":FindConfig"
; -105_OpenFile   -> ":FindAppFile"
; -105_OpenFile   -> ":StartApplink_a0"
;
:FindFileAllDrv		sta	:2 +1			;Laufwerkstyp speichern.

			ldx	curDrive
			stx	r15L
::1			stx	r15H
			lda	driveType -8,x		;Laufwerk verfügbar?
			beq	:3			; => Nein, weiter...
			and	#%10000000
::2			cmp	#$ff			;Gesuchter Laufwerkstyp?
			bne	:3			; => Nein, weiter...
			txa
			jsr	SetDevice		;Laufwerk aktivieren.

			jsr	OpenDisk		;Diskette öffnen.
			txa				;Disk-Fehler?
			bne	:3			; => Ja, weiter...

			LoadW	r6,fileName
			jsr	FindFile		;Datei suchen.
			txa				;Fehler?
			bne	:3			; => Ja, Abbruch...

			LoadW	r6,fileName		;Datei-Modus testen.
			jsr	ChkFlag_40_80		;Gefundene Anwendung für GEOS64?
			txa				;DiskFehler/Inkompatibel?
			beq	:5			; => Nein, Ende...

::3			ldx	r15H			;Zeiger auf nächstes Laufwerk.
			inx
			cpx	#12			;Laufwerk > 11?
			bcc	:6			; => Nein, weiter...
			ldx	#$08
::6			cpx	r15L			;Alle Laufwerke durchsucht?
			bne	:1			;Auf nächstem Laufwerk weitersuchen.

::4			ldx	#$ff			;Nicht gefunden.

;--- Falls Anwendung nicht gefunden, Laufwerk zurücksetzen.
::5			txa				;Fehler?
			beq	:7			; => Nein, weiter...
			pha
			lda	r15L 			;Vorheriges Laufwerk wieder
			jsr	SetDevice		;aktivieren.
			pla
			tax
::7			rts

;*** Anwendung oder AutoExec starten.
:OpenAppl		jsr	ChkFlag_40_80		;40/80Z-Flag testen.
			cpx	#INCOMPATIBLE		;Inkompatibel mit GEOS64?
			beq	:error_40_80		; => Ja, Abbruch...
			txa				;Laufwerksfehler?
			bne	:error			; => Ja, Abbruch...

			jsr	setHelpApp		;Dateiname für Hilfesystem setzen.

			sei				;GEOS-Reset #0.
			cld
			ldx	#$ff
			txs

			jsr	GEOS_InitSystem		;GEOS-Reset #1.
			jsr	PrepGetFile

			lda	#> EnterDeskTop-1	;Bei Fehler zurück zum
			pha				;DeskTop.
			lda	#< EnterDeskTop-1
			pha

;			LoadB	r0L,$00			;Wird durch ":PrepGetFile" gelöscht.
			LoadW	r6,AppFName
			jmp	GetFile			;Datei laden/starten.
::error			jmp	OpenFNamError		;Dateifehler => Abbruch.
::error_40_80		jmp	OpenG64Error		;Inkompatibel => Abbruch.

;*** Dokument starten.
:OpenDoc		ldx	#r14L			;Zeiger auf Aktuelle Diskette.
			jsr	GetPtrCurDkNm

			ldy	#16 -1
::0			lda	(r14L),y		;Diskname kopieren.
			sta	DocDName,y
			dey
			bpl	:0

;			LoadW	r6,fileName		;Zeiger auf Dateiname bereits in r6.
			LoadW	r0,AppFName
			ldx	#r6L
			ldy	#r0L
			jsr	CopyString

;			LoadW	r6,fileName		;Zeiger auf Dateiname bereits in r6.
			jsr	LoadDokInfos		;Dokument-Daten einlesen.
			txa				;Fehler?
			beq	:1			; => Nein, weiter...
::error			jmp	OpenFNamError		;Dateifehler => Abbruch.
::error_app		jmp	OpenFAppError		;Anwendung fehlt => Abbruch.
::error_40_80		jmp	OpenG64Error		;Inkompatibel => Abbruch.

::1			jsr	IsApplOnDsk		;Anwendung suchen.
			cpx	#INCOMPATIBLE
			beq	:error_40_80
			txa				;Gefunden?
			bne	:error_app		; => Nein, Abbruch...

			ldy	#16 -1			;Dokument- und Diskname
::2			lda	DocDName,y		;in Systemspeicher kopieren.
			sta	dataDiskName,y
			lda	fileName,y
			sta	dataFileName,y
			dey
			bpl	:2

			sei				;GEOS-Reset #0.
			cld
			ldx	#$ff
			txs

			jsr	GEOS_InitSystem		;GEOS-Reset #1.
			jsr	PrepGetFile

			lda	#> EnterDeskTop-1	;Bei Fehler zurück zum
			pha				;DeskTop.
			lda	#< EnterDeskTop-1
			pha

			LoadW	r2,dataDiskName
			LoadW	r3,dataFileName
			LoadW	r6,AppFName
			LoadB	r0L,%10000000
			jmp	GetFile			;Anwendung+Dokument starten.

;*** Hilfsmittel laden.
:OpenDA			jsr	ChkFlag_40_80		;40/80Z-Flag testen.
			cpx	#INCOMPATIBLE		;Inkompatibel mit GEOS64?
			beq	:error_40_80		; => Ja, Abbruch...
			txa				;Laufwerksfehler?
			bne	:error			; => Ja, Abbruch...

			jsr	setHelpApp		;Dateiname für Hilfesystem setzen.

			jsr	sys_SvBackScrn		;Bildschirm speichern.

			bit	GD_DA_BACKSCRN		;Hintergrund löschen ?
			bmi	:1			; => Nein, weiter...
			jsr	ResetScreen		;Bildschirm löschen.

::1			jsr	PrepGetFileDA		;":dlgBoxRamBuf" löschen.

			LoadW	r6,AppFName		;Zeiger auf Dateiname.
			LoadB	r0L,%00000000
;			LoadB	r10L,$00		;Wird durch ":PrepGetFile" gelöscht.
			jsr	GetFile			;DA laden.
			txa
			pha
			jsr	sys_LdBackScrn		;Bildschirm zurücksetzen.
			pla				;Fehler ?
			bne	:error			; => Ja, Abbruch...

			lda	GD_DA_UPD_DIR		;Fenster-Modus einlesen.
			beq	:no_reload		; => Nichts aktualisieren.
			bmi	:all_update		; => Alles aktualisieren.

::top_update		jsr	SET_LOAD_DISK		;Optional: Oberstes Fenster von Disk
			jmp	MOD_UPDATE		;neu laden... -> Langsam...
::all_update		jmp	MOD_REBOOT		;Optional: Alle Fenster neu.
;::no_reload		jmp	MOD_INITWM		;Menü/FensterManager neu starten.
::no_reload		jmp	MOD_RESTART		;Menü/FensterManager neu starten.
::error			jmp	OpenFNamError		;Dateifehler => Abbruch.
::error_40_80		jmp	OpenG64Error		;Inkompatibel => Abbruch.

;*** BASIC-Anwendung starten.
:OpenBASIC		LoadW	r0,Dlg_ExitBASIC
			jsr	DoDlgBox

			lda	sysDBData		;Abbruch ?
			cmp	#CANCEL
			beq	:exit			; => Nein, weiter...

			LoadW	r6,AppFName		;Zeiger auf Dateiname.
			jmp	ExitBApplRUN		;BASIC-Datei laden/starten.
::exit			jmp	MOD_RESTART		;Menü/FensterManager neu starten.

;*** Dialogboxen.
:Dlg_ExitBASIC		b %01100001
			b $30,$97
			w $0040,$00ff

			b DB_USR_ROUT
			w Dlg_DrawTitel
			b DBTXTSTR   ,$0c,$0b
			w Dlg_Titel_Info
			b DBTXTSTR   ,$0c,$20
			w :2
			b DBTXTSTR   ,$10,$2e
			w fileName
			b DBTXTSTR   ,$0c,$3c
			w :3
			b YES        ,$01,$50
			b CANCEL     ,$11,$50
			b NULL

if LANG = LANG_DE
::2			b PLAINTEXT
			b "GEOS beenden und die BASIC-Datei"
			b BOLDON,NULL
::3			b PLAINTEXT
			b "laden und starten?",NULL
endif
if LANG = LANG_EN
::2			b PLAINTEXT
			b "Quit GEOS and load the BASIC file"
			b BOLDON,NULL
::3			b PLAINTEXT
			b "and then run the file?",NULL
endif

;*** Systemdatei öffnen.
;An dieser Stelle werden nur die
;geoDesk-Farbdateien geladen.
:OpenSystem		;LoadW	r6,fileName		;Zeiger auf Dateiname bereits in r6.
			jsr	FindFileHeader		;Datei suchen und Header einlesen.
			txa				;Fehler?
			bne	:error			; => Nein, weiter...

			LoadW	r0,fileHeader +77
			LoadW	r1,:colConfigClass
			ldx	#r0L
			ldy	#r1L
			jsr	CmpString		;GeoDesk-Farbdatei?
			bne	:exit			; => Nein, Ende...

			jsr	loadColConfig		;Farbdaten einlesen.

			jmp	MOD_REBOOT		;Desktop neu zeichnen.
::exit			jmp	MOD_RESTART		;Ohne Update zurück zum DeskTop...
::error			jmp	OpenFNamError		; => Abbruch.

::colConfigClass	b "geoDeskCol  V1.0",NULL

;*** Konfiguration laden.
:loadColConfig		LoadW	r6,fileName		;Zeiger auf Dateiname.
			jsr	FindFile		;Datei auf Disk suchen.
			txa				;Gefunden?
			bne	:exit			; => Nein, Abbruch...

			LoadB	r0L,%00000001
			LoadW	r6,fileName		;Zeiger auf Dateiname.
			LoadW	r7,GD_PROFILE		;Startadresse Farb-/Musterdaten.
			jsr	GetFile			;Datei einlesen.
			txa				;Fehler?
			bne	:exit			; => Ja, Abbruch...

			jsr	SUB_SAVECOL		;Farbprofil in DACC speichern.

			ldx	#NO_ERROR		;Kein Fehler.
::exit			rts

;*** Laufwerkstreiber starten.
:OpenDskDrv		sei				;GEOS-Reset #0.
			cld
			ldx	#$ff
			txs

			jsr	GEOS_InitSystem		;GEOS-Reset #1.
			jsr	PrepGetFile

;--- Hinweis:
;Laufwerkstreiber werden als Anwendung
;geladen und installiert. In diesem
;Modus kehrt der Laufwerkstreiber über
;die Routine ":EnterDeskTop" zurück.
			lda	#> EnterDeskTop-1	;Bei Fehler zurück zum
			pha				;DeskTop.
			lda	#< EnterDeskTop-1
			pha

;--- Hinweis:
;":GetFile" startet nur Anwendungen.
;Für Laufwerkstreiber die Startadresse
;auf dem Stack ablegen.
			lda	#> DKDRV_LOAD_ADDR -1
			pha
			lda	#< DKDRV_LOAD_ADDR -1
			pha

;--- Hinweis:
;Nachteil: Bei einem Disk-Fehler wird
;trotzdem die Startadresse aufgerufen.
;Zur Sicherheit wird daher zuvor auch
;":EnterDeskTop" auf den Stack gelegt.
;			LoadB	r0L,$00			;Wird durch ":PrepGetFile" gelöscht.
			LoadW	r6,AppFName
			jmp	GetFile			;Datei laden/starten.
::error			jmp	OpenFNamError		;Dateifehler => Abbruch.

;*** Dokument-Infos einlesen.
;    Übergabe: r6 = Zeiger auf Dateiname.
:LoadDokInfos		;LoadW	r6,fileName		;Zeiger auf Dateiname bereits in r6.
			jsr	FindFileHeader		;Datei suchen und Header einlesen.
			txa				;Fehler ?
			bne	:2			; => Ja, Abbruch...

			ldx	#FILE_NOT_FOUND
			lda	fileHeader+$75		;Keine Anwendung definiert?
			beq	:2			; => Ja, Abbruch...

			ldy	#11			;"Class" der Application einlesen.
::1			lda	fileHeader+$75,y
			sta	AppClass,y
			dey
			bpl	:1

			jsr	setHelpDoc		;Dateiname für Hilfesystem setzen.

			ldx	#NO_ERROR		;Kein Fehler...
::2			rts				;Ende.

;*** Applikation suchen.
:IsApplOnDsk		lda	#%10000000		;Anwendung auf
			jsr	FindApplFile		;RAM-Laufwerken suchen.
			txa				;Gefunden?
			beq	:1			; => Ja, Ende...
			lda	#%00000000		;Anwendung auf
			jsr	FindApplFile		;Disk-Laufwerken suchen.
::1			rts

;*** Anwendung auf den Laufwerken A: bis D: suchen.
:FindApplFile		sta	:2 +1			;Laufwerkstyp speichern.

;--- Hinweis:
;Die Suche nach einer bestimmten Datei
;wird auch hier vrwendet:
; -105_OpenEditor -> ":FindEditor"
; -105_OpenFile   -> ":FindAppFile"
; -105_OpenFile   -> ":StartApplink_a0"

			ldx	curDrive
			stx	r15L
::1			stx	r15H
			lda	driveType -8,x		;Laufwerk verfügbar?
			beq	:3			; => Nein, weiter...
			and	#%10000000
::2			cmp	#$ff			;Gesuchter Laufwerkstyp?
			bne	:3			; => Nein, weiter...
			txa
			jsr	SetDevice		;Laufwerk aktivieren.

			jsr	OpenDisk		;Diskette öffnen.
			txa				;Disk-Fehler?
			bne	:3			; => Ja, weiter...

			LoadW	r6,AppFName		;Anwendung  suchen.
			LoadB	r7L,APPLICATION
			LoadB	r7H,1
			LoadW	r10,AppClass
			jsr	FindFTypes
			txa				;Fehler?
			bne	:3			; => Ja, Abbruch...
			lda	r7H			;Datei gefunden?
			bne	:3			; => Nein, weiter suchen...

			LoadW	r6,AppFName		;Datei-Modus testen.
			jsr	ChkFlag_40_80		;Gefundene Anwendung für GEOS64?
			txa
			beq	:5			; => Ja, Ende...

::3			ldx	r15H			;Zeiger auf nächstes Laufwerk.
			inx
			cpx	#12			;Laufwerk > 11=
			bcc	:6			; => Nein, weiter...
			ldx	#$08
::6			cpx	r15L			;Alle Laufwerke durchsucht?
			bne	:1			;Auf nächstem Laufwerk weitersuchen.

::4			ldx	#$ff			;Nicht gefunden.

;--- Falls Anwendung nicht gefunden, Laufwerk zurücksetzen.
::5			txa				;Fehler?
			beq	:7			; => Nein, weiter...
			pha
			lda	r15L 			;Vorheriges Laufwerk wieder
			jsr	SetDevice		;aktivieren.
			pla
			tax
::7			rts

;*** C128/40/80Z-Modus testen.
;    Übergabe: r6 = Zeiger auf Dateiname.
:ChkFlag_40_80		;LoadW	r6,AppFName		;Zeiger auf Dateiname bereits in r6.
			jsr	FindFileHeader		;Datei suchen und Header einlesen.
			txa				;Info-Block gefunden ?
			bne	:4			; => Nein, BASIC-File, Abbruch...

;--- Hinweis:
;Unter GEOS gibt es kein Flag für "Nur GEOS128". Eine Anwendung die für den
;40+80Z-Modus entwickelt wurde kann auch für GEOS64 existieren. Es kann aber
;auch eine reine GEOS128-Anwendung sein.
;Unter GEOS64 werden daher GEOS64, 40ZOnly und 40/80Z akzeptiert.
			lda	fileHeader+$60		;40/80Z-Flag einlesen.
			cmp	#$c0			;Nur 80Z?
			bne	:2			; => Nein, weiter...
::1			ldx	#INCOMPATIBLE		; => Nur GEOS128, Abbruch.
			b $2c
::2			ldx	#NO_ERROR		; => Anwendung OK.
::4			rts

;*** Datei suchen und Header einlesen.
;Übergabe: r6 = Zeiger auf Dateiname.
:FindFileHeader		jsr	FindFile		;Dateieintrag suchen.
			txa				;Fehler ?
			bne	:err			; => Ja, Abbruch...

			LoadW	r9,dirEntryBuf
			jsr	GetFHdrInfo		;Infoblock einlesen.
;			txa				;Fehler ?
;			bne	:err			; => Ja, Abbruch...

;::ok			ldx	#NO_ERROR		;Kein Fehler.
::err			rts				;Ende.

;*** Dokument für Hilfesystem setzen.
:setHelpApp		ldx	#$4d			;Zeiger auf GEOS-Klasse / Datei.
			b $2c
:setHelpDoc		ldx	#$75			;Zeiger auf GEOS-Klasse / Dokument.

			ldy	#$00
			sty	HelpSystemPage		;Erste Seite öffnen.

;			ldy	#0
::1			lda	fileHeader,x		;GEOS-Klasse als erstes Dokument
			sta	HelpSystemFile,y	;für Hilfesystem festlegen.
			inx
			iny
			cpy	#12
			bcc	:1

			rts

;*** Anwendung wählen.
:SelectAppl		lda	#APPLICATION		;GEOS-Anwednungen.
			b $2c
:SelectAuto		lda	#AUTO_EXEC		;GEOS-Autostart.
			b $2c
:SelectDA		lda	#DESK_ACC		;GEOS-Hilfsmittel.
			sta	r7L

			lda	#$00			;GEOS-Klasse löschen.
			sta	r10L
			sta	r10H

;*** Anwendung/Dokument wählen.
:SelectAnyFile		jsr	OpenFile		;Datei auswählen.
			txa				;Diskettenfehler ?
			beq	:openfile
::exit			jmp	MOD_RESTART		;Menü/FensterManager neu starten.

::openfile		LoadW	r6,dataFileName
			jsr	FindFile		;Datei suchen.
			txa				;Fehler?
			bne	:exit			; => Ja, Abbruch...

			LoadW	a0,dirEntryBuf -2	;Datei öffnen.
			jmp	StartFile_a0

;*** Dokument wählen.
:SelectDocument		ldx	#0			;Alle Dokumente.
			b $2c
:SelectDocWrite		ldx	#2			;GeoWrite-Dokumente.
			b $2c
:SelectDocPaint		ldx	#4			;GeoPaint-Dokumente.
			lda	ApplClass +0,x		;GEOS-Klasse fürr Dokumente setzen.
			sta	r10L
			lda	ApplClass +1,x
			sta	r10H
			LoadB	r7L,APPL_DATA		;GEOS-Dokumente.
			jmp	SelectAnyFile		;Datei auswählen.

;*** Liste der Anwendungsklassen.
:ApplClass		w $0000
			w AppClassWrite
			w AppClassPaint
:AppClassWrite		b "Write Image ",NULL
:AppClassPaint		b "Paint Image ",NULL

;*** GD.CONFIG starten.
:OpenConfig		jsr	FindConfig		;GD.CONFIG suchen.
			txa				;Fehler?
			bne	:error			; => Ja, Abbruch...

			LoadW	a0,dirEntryBuf -2	;Zeiger auf Verzeichnis-Eintrag.
			jmp	StartFile_a0		;Anwendung starten.

::error			jmp	OpenFNamError		;Fehler ausgeben => Desktop.

;*** GD.CONFIG auf Disk suchen.
:FindConfig		LoadW	r0,FNameGCfg64		;Name für "GD.CONFIG".
			LoadW	r6,fileName

			ldx	#r0L			;Dateiname für Fehlermeldung
			ldy	#r6L			;kopieren.
			jsr	CopyString

			lda	#%10000000		;GD.CONFIG auf
			jsr	FindConfigFile		;RAM-Laufwerken suchen.
			txa
			beq	:1

			lda	#%00000000		;GD.CONFIG auf
			jsr	FindConfigFile		;Disk-Laufwerken suchen.

::1			rts

;*** Datei auf den Laufwerken A: bis D: suchen.
;Dabei wird ds 40/80-Zeichen-Flag für
;GEOS128 nicht ausgewertet!
;
;--- Hinweis:
;Die Suche nach einer bestimmten Datei
;wird auch hier vrwendet:
; -105_OpenConfig -> ":FindConfig"
; -105_OpenFile   -> ":FindAppFile"
; -105_OpenFile   -> ":StartApplink_a0"
;
:FindConfigFile		sta	:2 +1

			ldx	curDrive
			stx	r15L
::1			stx	r15H
			lda	driveType -8,x		;Laufwerk verfügbar?
			beq	:3			; => Nein, weiter...
			and	#%10000000
::2			cmp	#$ff			;Gesuchter Laufwerkstyp?
			bne	:3			; => Nein, weiter...
			txa
			jsr	SetDevice		;Laufwerk aktivieren.

			jsr	OpenDisk		;Diskette öffnen.
			txa				;Disk-Fehler?
			bne	:3			; => Ja, weiter...

			LoadW	r6,fileName
			jsr	FindFile		;Datei suchen.
			txa				;Gefunden?
			beq	:5			; => Ja, Ende...

::3			ldx	r15H			;Zeiger auf nächstes Laufwerk.
			inx
			cpx	#12			;Laufwerk > 11?
			bcc	:6			; => Nein, weiter...
			ldx	#$08			;Auf Laufwerk #8 zurücksetzen.
::6			cpx	r15L			;Alle Laufwerke durchsucht?
			bne	:1			;Auf nächstem Laufwerk weitersuchen.

::4			ldx	#$ff			;Nicht gefunden.

;--- Falls Editor nicht gefunden, Laufwerk zurücksetzen.
::5			txa
			beq	:7
			pha
			lda	r15L 			;Vorheriges Laufwerk wieder
			jsr	SetDevice		;aktivieren.
			pla
			tax
::7			rts

:FNameGCfg64		b "GD.CONFIG",NULL

;*** Neuen Druckertreiber laden.
:ChangePrinter		LoadB	r7L,PRINTER		;Dateityp festlegen.
			LoadW	r10,$0000		;Keine GEOS-Klasse.
			jsr	OpenFile		;Druckertreiber auswählen.
			txa				;Datei ausgewählt?
			bne	exitOpenPrnt		; => Nein, Abbruch..

:OpenPrinter		lda	#< dataFileName		;Druckertreiber suchen.
			sta	r6L
			sta	errDrvInfoF +0
			lda	#> dataFileName
			sta	r6H
			sta	errDrvInfoF +1
			jsr	FindFile
			txa				;Datei gefunden?
			bne	OpenPrntError		; => Nein, weiter...

			LoadW	r0,dataFileName
			LoadW	r6,PrntFileName
			ldx	#r0L
			ldy	#r6L
			jsr	CopyString		;Druckername kopieren.

			LoadW	r7 ,PRINTBASE
			LoadB	r0L,%00000001
			jsr	GetFile			;Druckertreiber einlesen.
			txa				;Fehler?
			bne	OpenPrntError		; => Ja, Abbruch...
			jsr	OpenPrntOK		; => Nein, OK ausgeben.
:exitOpenPrnt		rts

;*** Info: Drucker installiert.
:OpenPrntOK		LoadW	r6,PrntFileName
			lda	#$c0			;"PRNT_UPDATED"
			bne	OpenDevError

;*** Fehler: Drucker konnte nicht installiert werden.
:OpenPrntError		lda	#$80			;"PRNT_NOT_UPDATED"
			bne	OpenDevError

;*** Info: Eingabegerät installiert.
:OpenInptOK		LoadW	r6,inputDevName
			lda	#$c1			;"INPT_UPDATED"
			bne	OpenDevError

;*** Fehler: Eingabegerät konnte nicht installiert werden.
:OpenInptError		lda	#$81			;"INPT_NOT_UPDATED"
;			bne	OpenDevError

:OpenDevError		sta	errDrvCode		;Fehlernummer zwischenspeichern.

			jsr	SUB_STATMSG		;Statusmeldung ausgeben.

			ldx	#NO_ERROR
			bit	errDrvCode		;Fehler?
			bvs	:exit			; => Nein, weiter...
			ldx	#CANCEL_ERR		; => Ja, Abbruch...
::exit			rts

;*** Neuen Eingabetreiber laden.
:ChangeInput		LoadB	r7L,INPUT_DEVICE	;Dateityp festlegen.
			LoadW	r10,$0000		;Keine GEOS-Klasse.
			jsr	OpenFile		;Datei auswählen.
			txa				;Datei ausgewählt?
			bne	exitOpenInpt		; => Nein, Abbruch..

:OpenInput		LoadW	r6,dataFileName		;Name Eingabetreiber kopieren.
			MoveW	r6,errDrvInfoF
			jsr	FindFile
			txa
			bne	OpenInptError		; => Nein, weiter...

			LoadW	r0,dataFileName		;Name Eingabetreiber kopieren.
			LoadW	r6,inputDevName
			ldx	#r0L
			ldy	#r6L
			jsr	CopyString		;Name Eingabetreiber kopieren.

			LoadW	r7 ,MOUSE_BASE
			LoadB	r0L,%00000001
			jsr	GetFile			;Eingabetreiber einlesen.
			txa
			bne	OpenInptError
			jsr	InitMouse		;Initialisieren.
			jsr	OpenInptOK
:exitOpenInpt		rts

;*** Datei auswählen.
;    Übergabe:		r7L  = Datei-Typ.
;			r10  = Datei-Klasse.
;    Rückgabe:		In ":dataFileName" steht der Dateiname.
;			xReg = $00, Datei wurde ausgewählt.
:OpenFile		MoveB	r7L,:OpenFile_Type
			MoveW	r10,:OpenFile_Class

::1			ldx	curDrive
			lda	driveType -8,x		;Aktuelles Laufwerk gültig?
			bne	:3			; => Ja, weiter...

			ldx	#8			;Gültiges Laufwerk suchen.
::2			lda	driveType -8,x
			bne	:3
			inx
			cpx	#12
			bcc	:2
			ldx	#$ff
			rts

::3			txa				;Laufwerk aktivieren.
			jsr	SetDevice

;--- Dateiauswahlbox.
::4			MoveB	:OpenFile_Type ,r7L
			MoveW	:OpenFile_Class,r10
			LoadW	r5 ,dataFileName
			LoadB	r7H,255
			LoadW	r0,:Dlg_SlctFile
			jsr	DoDlgBox		;Datei auswählen.

			lda	sysDBData		;Laufwerk wechseln ?
			bpl	:5			; => Nein, weiter...

			and	#%00001111
			jsr	SetDevice		;Neues Laufwerk aktivieren.
			txa				;Laufwerksfehler ?
			beq	:4			; => Nein, weiter...
			bne	:1			; => Ja, gültiges Laufwerk suchen.

::5			cmp	#DISK			;Partition wechseln ?
			beq	:4			; => Ja, weiter...
			ldx	#$ff
			cmp	#CANCEL			;Abbruch gewählt ?
			beq	:6			; => Ja, Abbruch...
			inx
::6			rts

::OpenFile_Type		b $00
::OpenFile_Class	w $0000

::Dlg_SlctFile		b $81
			b DBGETFILES!DBSETDRVICON ,$00,$00
			b CANCEL                  ,$00,$00
			b DISK                    ,$00,$00
			b OK,0,0
			b NULL

;*** Nach GEOS beenden.
:ExitGEOS		jsr	WM_CLOSE_ALL_WIN	;Alle Fenster schließen.

			jsr	SetADDR_EnterDT		;Original EnterDeskTop-Routine
			lda	#$00			;aus dem Speicher holen und
			sta	r1L			;wieder im System installieren.
			sta	r1H
			lda	GD_RAM_GDESK1		;Zeiger auf GeoDesk-Speicherbank #1.
			sta	r3L
			jsr	FetchRAM
			jsr	SetADDR_EnterDT
			jsr	StashRAM

			lda	GD_SCRN_STACK		;Reservierten Speicher freiegeben.
			jsr	DACC_FREE_BANK
			lda	GD_SYSDATA_BUF
			jsr	DACC_FREE_BANK

			lda	GD_RAM_GDESK1		;GeoDesk/Speicherbank #1 belegt?
			beq	:1			; => Nein, weiter...
			jsr	DACC_FREE_BANK		;Speicher freigeben.

::1			lda	GD_RAM_GDESK2		;GeoDesk/Speicherbank #2 belegt?
			beq	:2			; => Nein, weiter...
			jsr	DACC_FREE_BANK		;Speicher freigeben.

::2			lda	GD_ICONDATA_BUF		;Icon-Cache aktiv?
			beq	:3			; => Nein, weiter...
			jsr	DACC_FREE_BANK		;Speicher freigeben.

::3			jmp	EnterDeskTop		;Zurück zu GEOS.

;*** Nach BASIC beenden.
:NoBASIC		b NULL
:ExitBASIC		LoadW	r0,Dlg_ExitBasic
			jsr	DoDlgBox

			lda	sysDBData		;GEOS wirklich beenden?
			cmp	#YES			;"Ja" ?
			beq	:exit			; => Nein, Abbruch...
			jmp	MOD_RESTART		;Menü/FensterManager neu starten.

::exit			LoadW	r0,NoBASIC

;*** Nach BASIC verlassen und Befehl ausführen.
;    Übergabe: r0 = Zeiger auf Befehl.
:ExitBASIC_NoLoad	lda	#$00			;Kein Programm laden.
			sta	r5L
			sta	r5H

			sta	$0800			;Kein Programm starten.
			sta	$0801
			sta	$0802
			sta	$0803
			LoadW	r7,$0803

			jmp	ToBasic			;Nach BASIC beenden.

;*** Dialogboxen.
:Dlg_ExitBasic		b %01100001
			b $30,$97
			w $0040,$00ff

			b DB_USR_ROUT
			w Dlg_DrawTitel
			b DBTXTSTR   ,$0c,$0b
			w Dlg_Titel_Info
			b DBTXTSTR   ,$0c,$20
			w :2
			b DBTXTSTR   ,$0c,$2c
			w :3
			b YES        ,$01,$50
			b CANCEL     ,$11,$50
			b NULL

if LANG = LANG_DE
::2			b PLAINTEXT
			b "GEOS wirklich beenden und",NULL
::3			b "den BASIC-Modus starten?",NULL
endif
if LANG = LANG_EN
::2			b PLAINTEXT
			b "Do you really want to quit",NULL
::3			b "GEOS and start BASIC mode?",NULL
endif

;*** BASIC-Programm starten.
:ExitBAppl		lda	#NOT_GEOS		;Dateityp "BASIC/Nicht GEOS".
			sta	r7L

			lda	#$00			;Keine GEOS-Klasse.
			sta	r10L
			sta	r10H

			jsr	OpenFile		;Datei auswählen.
			txa				;Diskettenfehler ?
			beq	:openfile
::exit			jmp	MOD_RESTART		;Menü/FensterManager neu starten.

::openfile		LoadW	r6,dataFileName
:ExitBApplRUN		jsr	FindFile		;Datei suchen.
			txa				;Fehler?
			bne	:exit			; => Ja, Abbruch...

;--- Ladeadresse prüfen.
			lda	dirEntryBuf+1		;Zeiger auf ersten Datenblock.
			sta	r1L
			lda	dirEntryBuf+2
			sta	r1H
			LoadW	r4,diskBlkBuf		;Zeiger auf Zwischenspeicher.
			jsr	GetBlock		;Ersten Datenblock einlesen.
			txa				;Fehler?
			bne	:exit			; => Ja, Abbruch...

			lda	diskBlkBuf+2		;Laeadresse = $0801?
			cmp	#$01
			bne	:ask_load_abs		; => Nein, Absolut laden?
			lda	diskBlkBuf+3
			cmp	#$08
			beq	:load_std		; => Ja, weiter...

::ask_load_abs		ldx	curDrive		;Bei RAM-Laufwerk kein absolutes
			lda	RealDrvType -8,x	;laden mit ",dev,1" möglich.
			bpl	:0			; => Kein RAM-Laufwerk, weiter.

			LoadW	r0,Dlg_LoadAbsRAM	;Fragen ob von RAM normal geladen
			jsr	DoDlgBox		;werden soll...

			lda	sysDBData
			cmp	#YES			;"Ja" ?
			beq	:load_std		; => Normal laden.
			bne	:cancel			;Abbruch.

::0			LoadW	r0,Dlg_LoadAbs		;Fragen ob Absolut geladen
			jsr	DoDlgBox		;werden soll...

			lda	sysDBData
			cmp	#NO
			beq	:load_std		; => Nein, normal laden/starten.
			cmp	#YES
			beq	:load_abs		; => Ja, absolut laden.
::cancel		jmp	MOD_RESTART		;Menü/FensterManager neu starten.

;--- Programm normal laden/starten.
::load_std		LoadW	r0,:RunBASIC		;"RUN"-Befehl.
			LoadW	r5,dirEntryBuf		;Zeiger auf Verzeichnis-Eintrag.
			LoadW	r7,$0801		;Ladeadresse.

			jmp	ToBasic			;Nach BASIC beenden.

::exit			lda	#< dataFileName		;Zeiger auf Dateiname für
			sta	errDrvInfoF +0		;"FILE_NOT_FOUND"-Fehler.
			lda	#> dataFileName
			sta	errDrvInfoF +1
			jmp	OpenDiskError		;Fehlermeldung ausgeben.

;--- Programm absolut laden/manuell starten.
::load_abs		LoadW	r0,dirEntryBuf -2	;Dateiname in LOAD-Befehl kopieren.
			LoadW	r1,:FileNameBuf
			ldx	#r0L
			ldy	#r1L
			jsr	SysCopyFName

			ldy	#$00
::2			lda	(r1L),y			;Ende Dateiname suchen.
			beq	:3
			iny
			cpy	#$10
			bne	:2

::3			lda	#$22			;",dev,1" an den Dateinamen
			sta	(r1L),y			;anhängen.
			iny
			lda	#$2c			;","
			sta	(r1L),y
			iny

			ldx	curDrive		;Laufwerk 8,9,10,11 in
			lda	:driveAdr1 -8,x		;Befehl eintragen.
			beq	:4
			sta	(r1L),y
			iny
::4			lda	:driveAdr2 -8,x
			sta	(r1L),y
			iny

			lda	#$2c			;","
			sta	(r1L),y
			iny
			lda	#"1"			;"1"
			sta	(r1L),y
			iny
			lda	#NULL			;Befehlsende.
			sta	(r1L),y

			LoadW	r0,:LoadBASIC		;"LOAD"-Befehl.
			jmp	ExitBASIC_NoLoad	;Nach BASIC beenden.

::RunBASIC		b "RUN",NULL
::LoadBASIC		b "LOAD",$22
::FileNameBuf		s 17
			b $22,",8,1",NULL
::driveAdr1		b NULL,NULL,"1","1"
::driveAdr2		b "8" ,"9" ,"0","1"

;*** Dialogboxen.
:Dlg_LoadAbs		b %01100001
			b $30,$97
			w $0040,$00ff

			b DB_USR_ROUT
			w Dlg_DrawTitel
			b DBTXTSTR   ,$0c,$0b
			w Dlg_Titel_Info
			b DBTXTSTR   ,$0c,$20
			w :2
			b DBTXTSTR   ,$0c,$2c
			w :3
			b DBTXTSTR   ,$0c,$3c
			w :4
			b YES        ,$01,$50
			b NO         ,$08,$50
			b CANCEL     ,$11,$50
			b NULL

if LANG = LANG_DE
::2			b PLAINTEXT
			b "Das Programm verwendet nicht",NULL
::3			b "die Standard-Ladeadresse.",NULL
::4			b "Absolut mit `,x,1` laden?",NULL
endif
if LANG = LANG_EN
::2			b PLAINTEXT
			b "The program does not use the",NULL
::3			b "default load address.",NULL
::4			b "Load absolut with `,x,1` ?",NULL
endif

;*** Dialogboxen.
:Dlg_LoadAbsRAM		b %01100001
			b $30,$97
			w $0040,$00ff

			b DB_USR_ROUT
			w Dlg_DrawTitel
			b DBTXTSTR   ,$0c,$0b
			w Dlg_Titel_Info
			b DBTXTSTR   ,$0c,$1c
			w :2
			b DBTXTSTR   ,$0c,$28
			w :3
			b DBTXTSTR   ,$0c,$38
			w :4
			b DBTXTSTR   ,$0c,$44
			w :5
			b YES        ,$01,$50
			b CANCEL     ,$11,$50
			b NULL

if LANG = LANG_DE
::2			b PLAINTEXT
			b "Das Programm verwendet nicht",NULL
::3			b "die Standard-Ladeadresse.",NULL
::4			b "Absolutes Laden nicht unterstützt.",NULL
::5			b "Von RAM-Laufwerk laden/starten?",NULL
endif
if LANG = LANG_EN
::2			b PLAINTEXT
			b "The program does not use the",NULL
::3			b "default load address.",NULL
::4			b "Absolute loading is not supported.",NULL
::5			b "Load and run from RAM drive?",NULL
endif

;******************************************************************************
			g BASE_DIRDATA
;******************************************************************************
