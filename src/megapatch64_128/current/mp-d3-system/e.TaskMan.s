; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

			n "obj.TaskSwitch"
			t "G3_SymMacExt"
			t "e.Register.ext"

if Flag64_128 = TRUE_C64
			t "G3_V.Cl.64.Data"
endif
if Flag64_128 = TRUE_C128
			t "G3_V.Cl.128.Data"
endif

			o LD_ADDR_TASKMAN

if .p
;*** Startadresse Zwischenspeicher für ScreenShot-Routine.
:ScrShot_Data1		= BACK_SCR_BASE
:ScrShot_Data2		= ScrShot_Data1 + 1280 + 8 + 160
endif

;******************************************************************************
;*** Systmvariablen.
;******************************************************************************
:JumpTable		jmp	MainInit

;*** Bank-Adressen für Tasks (C128 = Bank 1)
;    Feste Adresse, da der MegaEditor
;    auf diese Adresse direkt zugreift!
:TaskBank00		b $00
:TaskBank01		b $00
:TaskBank02		b $00
:TaskBank03		b $00
:TaskBank04		b $00
:TaskBank05		b $00
:TaskBank06		b $00
:TaskBank07		b $00
:TaskBank08		b $00

;*** Flags für "Bank belegt".
:BankInUse00		b $00
:BankInUse01		b $00
:BankInUse02		b $00
:BankInUse03		b $00
:BankInUse04		b $00
:BankInUse05		b $00
:BankInUse06		b $00
:BankInUse07		b $00
:BankInUse08		b $00

;*** Max. verfügbare Tasks.
:MaxTaskInstalled	b MAX_TASK_ACTIV

if Flag64_128 = TRUE_C128
;*** Bank-Adressen für Tasks VDC Verwaltung
;    Feste Adresse, da der MegaEditor
;    auf diese Adresse direkt zugreift!
:TaskVDCBank00		b $00
:TaskVDCBank01		b $00
:TaskVDCBank02		b $00
:TaskVDCBank03		b $00
:TaskVDCBank04		b $00
:TaskVDCBank05		b $00
:TaskVDCBank06		b $00
:TaskVDCBank07		b $00
:TaskVDCBank08		b $00

;*** Bank-Adressen für Bank 0 Verwaltung
:Task0Bank00		b $00
:Task0Bank01		b $00
:Task0Bank02		b $00
:Task0Bank03		b $00
:Task0Bank04		b $00
:Task0Bank05		b $00
:Task0Bank06		b $00
:Task0Bank07		b $00
:Task0Bank08		b $00
endif

;*** Task-Namen.
;--- Ergänzung: 01.07.18/M.Kanet
;Systemtask-Name "MegaPatch-System" bei GEOS MP 3.0/2000
;Systemtask-Name "MP3-System-Task" bei GEOS MP 3.01/2003
;ACHTUNG!
;Alle Tasknamen sind 16+NULL Byte groß, in der Version
;von 2003 wurde der System-Task-Name auf 15+NULL Byte
;reduziert!
;:TaskName00		b "MegaPatch-System",NULL
;:TaskName00		b "<GEOS-MegaPatch>",NULL
:TaskName00		b "MP3-System-Task",NULL
:TaskName01		s 17
:TaskName02		s 17
:TaskName03		s 17
:TaskName04		s 17
:TaskName05		s 17
:TaskName06		s 17
:TaskName07		s 17
:TaskName08		s 17

;*** Systemveriablen.
:SelectedTask		b $00				;Markierter Task in Liste.
:CurTaskNr		b $00				;Aktueller Task.
:CurTaskBank		b $00				;Akt. Bank.
:CurDkDrvConfig		s $04				;Installierte Treiber.
:DkDrvTypeBuf		b $00				;Puffer für Laufwerkstyp Treiber im RAM.
:Flag_LoadDA		b $00				;Flag für Hilfsmittel.

if Flag64_128 = TRUE_C128
:CurTaskBank0		b $00				;Akt. Bank für Bank 0
:CurTaskBankVDC		b $00				;Akt. Bank für VDC
endif

;*** Speicher für Werte des aktuellen Tasks.
:CurTaskVar
:RetAdr			w $0000
:StackPointer		b $00
:AkkuBuf		b $00
:xRegBuf		b $00
:yRegBuf		b $00
:SaveD000		s 48
:SvCurDrive		b $00
:CurTurboA		b $00
:CurTurboB		b $00
:CurTurboC		b $00
:CurTurboD		b $00
:EndCurTaskVar

;*** System-Variablen.
;    Enthält Status des Spoolers vor Aufruf des TaskManagers und wird beim
;    Verlassen der Applikation wieder zurückgeschrieben. Soll der Spooler aus
;    dem Drucker-Menü des TaskManagers gestartet
;    werden, so verändert der TaskManager diesen Wert: Beim verlassen des
;    TaskManagers wird dann beim nächsten Aufruf der MainLoop der Spooler
;    gestartet.
:Flag_SpoolCopy		b $00

;******************************************************************************
;*** Ende der Systemvariablen.
;******************************************************************************

;*** Systemeinsprung für TaskManager.
:MainInit		sta	AkkuBuf			;Register speichern.
			stx	xRegBuf
			sty	yRegBuf

if Flag64_128 = TRUE_C128
			ldy	#$01			;40Zeichen Farbe
			ldx	#$0f
			bit	graphMode
			bpl	:40
			ldy	#$0f			;80Zeichen Farbe
			ldx	#$0e
::40			stx	COLORa
			sty	COLOR1
			sty	COLOR2
			sty	COLOR3
			sty	COLOR4
			sty	COLOR5
			sty	COLOR6
			sty	COLOR7
			sty	COLOR8
			ldx	vdcClrMode		;VDC-Modus für Screenshot sichern
			stx	oldVDCMode+1
endif
			tax				;Modus testen.
			beq	SaveCurTask		; => Task-Menü starten.
			bmi	CloseCurTask		; => Aktuellen Task schließen.
			jmp	BackToCurTask		; => Zum aktuellen Task zurück.

;*** Aktuellen Task beenden.
;    Aufruf erfolgt über ":EnterDeskTop".
:CloseCurTask		ldy	#%10010000		;Bereich retten: $6000-$CFFF
			jsr	SetRAM_MP_VAR

			ldx	CurTaskNr		;Zeiger auf aktuellen Task und
			jsr	FreeCurTask		;Task in Tabelle freigeben.
			jmp	OpenTask		;Letzten belegten Task öffnen.

;*** Alle Tasks löschen.
;    Aufruf erfolgt über Menü ":Reset".
:CloseAllTask		ldx	MaxTaskInstalled
			dex
			beq	:52			;wenn nur 1 Task installiert, dann
							;nicht freigeben sonst Absturz!
			lda	#$00
::51			sta	BankInUse00,x		;Task-Speicherbank freigeben.
			dex				;Zeiger auf nächste Bank.
			bne	:51			;Fertig = => Nein, weiter...
::52			jmp	OpenTask		;System-Task (xReg=$00!) öffnen.

;*** Warten bis keine Taste gedrückt.
:waitNoMseKey		bit	mouseOn			;Maus aktiv ?
			bpl	:nomse			; => Nein, weiter...

			php
			cli				;IRQ für Mausabfrage freigeben.
::wait			lda	mouseData		;Maustaste gedrückt ?
			bpl	:wait			; => Ja, warten...
			ClrB	pressFlag		;Tastenstatus löschen.
			plp				;IRQ-Status zurücksetzen.

::nomse			rts

;*** Aktuellen Task speichern.
:SaveCurTask		pla				;Rücksprungadresse merken.
			sta	RetAdr +0
			pla
			sta	RetAdr +1

			tsx				;Stackpointer merken
			stx	StackPointer

			ldx	#$1f			;Register ":r0" bis ":r15" retten.
::51			lda	r0L,x
			pha
			dex
			bpl	:51

			jsr	GetCurBank		;Neue Bank für Task ermitteln.

;*** Speicherbereiche in REU verschieben.
:MoveRAM_RExp		ldy	#%10010000		;Bereich retten: $0400-$3FFF
			jsr	SetRAM_Area1
			ldy	#%10010000		;Bereich retten: $6000-$CFFF
			jsr	SetRAM_Area2
			ldy	#%10010000		;Bereich retten: MP-Variablen.
			jsr	SetRAM_MP_VAR

			ldx	#$00			;Register ":r0" bis ":r15"
::51			pla				;wieder zurückschreiben.
			sta	r0L,x
			inx
			cpx	#$20
			bne	:51

			ldy	#$00			;ZeroPage-Bereich $0000-$03FF
::52			lda	zpage   +$0000,y	;nach ":APP_RAM" = $0400 kopieren.
			sta	APP_RAM +$0000,y	;Notwendig, da die Daten über
			lda	zpage   +$0100,y	;":StashRAM" kopiertwerden und die
			sta	APP_RAM +$0100,y	;Routine die ZeroPage verändert.
			lda	zpage   +$0200,y
			sta	APP_RAM +$0200,y
			lda	zpage   +$0300,y
			sta	APP_RAM +$0300,y
			iny
			bne	:52

			ldy	#%10010000		;Bereich retten: $0000-$03FF.
			jsr	SetRAM_ZPage		;(Kopie ab ":APP_RAM" verwendet!)

;*** Speicher im Bereich des TaskManagers $4000-$5FFF aus System-Bank einlesen
;    und in neue Task-Bank übertragen. Damit befindet sich in der aktuellen
;    64K-Bank der Speicherbereich von $0000-$DFFF!
			ldy	#%10010001		;Bereich retten: $4000-$5FFF <= REU.
			jsr	SetRAM_TaskSys
			ldy	#%10010000		;Bereich retten: $4000-$5FFF => REU.
			jsr	SetRAM_TaskBuf

;*** I/O-Register des aktuellen Tasks einlesen.
if Flag64_128 = TRUE_C128
			ldy	#%10010000		;Bereich retten: Bank 0
			jsr	SetRAM_Area4
			bit	graphMode
			bpl	:40
			lda	#$00			;Orginal Mauspfeil setzen
			sta	r0L			;(wegen GeoPaint)
			sta	r0H
			jsr	SetMsePic
			jsr	SaveVDC			;VDC Inhalt sichern
::40			ldx	MMU
			lda	#$7e
			sta	MMU
endif

if Flag64_128 = TRUE_C64
			ldx	CPU_DATA
			lda	#$35			;I/O-Bereich einblenden.
			sta	CPU_DATA
endif
			ldy	#$00
::53			lda	$d000,y			;I/O-Register auslesen und in
			sta	SaveD000,y		;Zwischenspeicher kopieren.
			iny
			cpy	#$30
			bcc	:53

if Flag64_128 = TRUE_C128
			stx	MMU
endif

if Flag64_128 = TRUE_C64
			stx	CPU_DATA
endif

;--- Ergänzung: 04.09.21/M.Kanet
;GeoWrite verändert ZeroPage-Adressen
;im Bereich von $0080-$00FF. Einige der
;Kernal-Routinen verursachen Probleme,
;wenn hier ungültige Werte vorliegen:
;Innerhalb von GeoWrite wird ab $0094
;ein Zeiger auf die aktuelle Cursor-
;Position innerhalb der Seite abgelegt.
;In Verbindung nur mit einer RAMLink
;(ohne SuperCPU) führt dann ein Aufruf
;von ":LISTEN"=$FFB1 zum Absturz.
;Ursache ist die Adresse $0094 die hier
;ausgelesen wird und in Abhängigkeit
;des Wertes <$80 oder >=$80 das ROM der
;RAMLink umgeschaltet wird. Bei einem
;Wert >=$80 führt das zum Absturz bei
;$ED2D: JMP $(DE34)
			lda	#$00			;ZeroPage-Adressen
			sta	STATUS			;initialisieren.
			sta	C3PO
			sta	BSOUR

;*** Angaben zum aktuellen Laufwerk zwischenspeichern.
			lda	curDrive		;Aktuelles Laufwerk speichern.
			sta	SvCurDrive
			sta	SelectedDrive

			jsr	GetCurDrvConfig		;Laufwerkskonfiguration speichern.

			ldy	#%10010000		;TaskManager-Variablen updaten.
			jsr	SetRAM_TaskVar

			lda	#<TaskMan_QuitJob	;":EnterDeskTop" verbiegen auf
			sta	EnterDeskTop +1		;"Task beenden"-Routine.
			lda	#>TaskMan_QuitJob
			sta	EnterDeskTop +2

			lda	Flag_Spooler
			sta	Flag_SpoolCopy
			lda	#%10000000		;Menü-Flag setzen und Ende.
			sta	Flag_Spooler

;--- Hinweis:
;Hier wurde bisher die BAM im Speicher
;für das System-Laufwerk aktualisiert.
;
;An dieser Stelle kann nicht geprüft
;werden, ob die BAM im Speicher auch zu
;der Diskette im Laufwerk gehört.
;
;Beispiel: A:DISK#1, C:DISK#1
;GeoDesk64: Fenster A: und C: geöffnet,
;dann von Laufwerk C: auf A: wechseln.
;Nun ist zwar Laufwerk A: aktiv, aber
;die BAM im Speicher gehört zu Laufwerk
;C:, da Diskette nicht geöffnet wurde.
;
;Daher kann die BAM hier nicht auf
;Disk gespeichert werden!

;--- Menü initialisieren.
;Hinweis:
;Vor dem Aufruf von ":waitNoMseKey"
;müssen die GEOS-Vektoren für die IRQ-
;Routine zurückgesetzt werden.
;Sollte ":intBotVector" oder auch die
;Standard-IRQ-Routine ":intTopVector"
;verändert worden sein, dann kann GEOS
;bei Freigabe des IRQ hier abstürzen.
;Zu diesem Zeitpunkt ist das APP_RAM
;bereits überschrieben worden und die
;IRQ-Routinen laufen ggf. ins leere.
;Zum Beispiel mit GeoPaint128.
:InitTaskMenu		jsr	GEOS_InitSystem		;GEOS-Variablen zurücksetzen.

			jsr	UpdateMouse		;Mausstatus aktualisieren.
			jsr	waitNoMseKey		;Warten bis keine Taste gedrückt.

			lda	CurTaskNr		;Aktuellen Task als
			sta	SelectedTask		;neuen Task setzen.

			jsr	SetWarning		;Warnung für Dialogbox/Hilfsmittel.

if Flag64_128 = TRUE_C128
;--- Ergänzung: 11.09.18/M.Kanet
;Unter GEOS128v2 wird beim Umschalten mit DESKTOPv2 von 40Z auf 80Z das
;DB_DblBit nicht passend zu graphMode gesetzt. Dadurch werden Icons in
;Dialogboxen nicht automatisch an den 80Z-Modus angepasst.
			lda	graphMode		;Grafikmodus einlesen.
			beq	:40			; ->40 Zeichen.
			lda	#%10000000		; ->80 Zeichen.
::40			sta	DB_DblBit		;DoubleBit setzen.
endif

			lda	MaxTaskInstalled	;Größe der Taskliste anpassen.
			asl				;Dabei wird die Höhe des Anzeige-
			asl				;fensters auf die max. verfügbare
			asl				;Anzahl Tasks gesetzt.
			sec
			sbc	#$01
			clc
			adc	RegMenu01_01
			sta	RegMenu01_01 +1
			sta	RegMenu01_02 +1

			jsr	SetADDR_Register	;Register-Routine einlesen.
			jsr	FetchRAM

			jsr	PrintTaskMenu		;Menü-Bildschirm zeichnen.

			LoadW	r0,RegisterTab		;Register-Menü aktivieren.
			jsr	DoRegister

			jmp	MainLoop		;MainLoop weiter bearbeiten.

;*** Aktives Register-Menü erneut auf Bildschirm darstellen.
:ReDrawTaskMenu		jsr	PrintTaskMenu		;Menü-Bildschirm zeichnen und
			jmp	RegisterInitMenu	;Register-Menü darstellen.

;*** Menügrafik aufbauen.
:PrintTaskMenu		jsr	RegisterSetFont		;Register-Font aktivieren.
			lda	#ST_WR_FORE		;Grafik nur im Vordergrund.
			sta	dispBufferOn

			lda	#$00			;Fenster für Hauptmenü zeichnen.
			jsr	SetPattern
			jsr	i_Rectangle
			b	$00,$c7
			w	$0000 ! DOUBLE_W,$013f ! DOUBLE_W ! ADD1_W
			lda	#%11111111
			jsr	FrameRectangle
if Flag64_128 = TRUE_C128
			lda	#$0e
			bit	graphMode
			bpl	:40
			b	$2c
::40
endif
			lda	#$0f
			jsr	DirectColor

			jsr	i_Rectangle		;Titelzeile für Menüfenster.
			b	$00,$07
			w	$0000 ! DOUBLE_W,$013f ! DOUBLE_W ! ADD1_W
if Flag64_128 = TRUE_C128
			lda	#$f0
			bit	graphMode
			bpl	:40a
			b	$2c
::40a
endif
			lda	#$10
			jsr	DirectColor

			LoadW	r0,MenuText00		;Titelzeile ausgeben.
			jsr	PutString

if Flag64_128 = TRUE_C128
			bit	graphMode
			bpl	:40b
			jsr	i_ColorBox
			b	$00 ! DOUBLE_B,$01,$0a ! DOUBLE_B,$03,$05
			jmp	:80
::40b
endif
			jsr	i_ColorBox
			b	$00,$01,$0a,$03,$0d
::80			LoadW	r0,Icon_Tab
			jmp	DoIcons			;Icon-Menü aktivieren.

;******************************************************************************
; Dialogbox-Routine.
; Erklärung:
; Beim Aufruf einer Dialogbox wird der Bildschirm-Bereich unter der DlgBox
; in der REU zwischengespeichert. War beim Aufruf des TaskManagers eine DlgBox
; geöffnet, dann ist dieser Bereich nun belegt. Soll nun innerhalb des Menüs
; eine weitere DlgBox geöffnet werden, so muß der Zwischenspeicher für die
; Bildschirmgrafik unter der geöffneten DlgBox ausgelesen werden, bevor eine
; neue DlgBox geöffnet werden kann. Nach Abschluß der neuen DlgBox wird der
; ausgelesene Zwischenspeicher wieder in die REU zurückkopiert.
;******************************************************************************
:DoSysDlgBox		lda	Flag_ExtRAMinUse	;Systemflag zwischenspeichern.
			pha
			tya				;Zeiger auf Definitionstabelle für
			pha				;Dialogboxtabelle zwischenspeichern.
			txa
			pha
if Flag64_128 = TRUE_C128
			bit	graphMode
			bpl	:40
			PushW	r5
			jsr	SaveDlgVDC
			PopW	r5
			jmp	:80
::40
endif
			jsr	SetDlgBoxGrfx		;Grafik-/Farbspeicher unter einer
			jsr	FetchRAM		;evtl. geöffneten Dialogbox retten.
			jsr	SetDlgBoxCols
			jsr	FetchRAM
::80			pla				;Zeiger auf Dialogboxtabelle.
			sta	r0L
			pla
			sta	r0H
			jsr	DoDlgBox		;Dialogbox ausführen.
if Flag64_128 = TRUE_C128
			bit	graphMode
			bpl	:40a
			PushW	r5
			jsr	LoadDlgVDC
			PopW	r5
endif
			jsr	SetDlgBoxCols		;Grafik-/Farbspeicher unter einer
			jsr	StashRAM		;evtl. geöffneten Dialogbox wieder
			jsr	SetDlgBoxGrfx		;zurückschreiben.
			jsr	StashRAM
::40a			pla
			sta	Flag_ExtRAMinUse	;Systemflag zurücksetzen.
			rts

;*** Zeiger auf Grafikspeicher richten.
:SetDlgBoxGrfx		LoadW	r0 ,$2000
			LoadW	r1 ,R2_ADDR_DB_GRAFX
			LoadW	r2 ,R2_SIZE_DB_GRAFX
			lda	MP3_64K_SYSTEM
			sta	r3L
			rts

;*** Zeiger auf Farbspeicher richten.
:SetDlgBoxCols		LoadW	r0 ,$1c00
			LoadW	r1 ,R2_ADDR_DB_COLOR
			LoadW	r2 ,R2_SIZE_DB_COLOR
			lda	MP3_64K_SYSTEM
			sta	r3L
			rts

;--- Zum aktuellen Task zurück.
:BackToCurTask		jsr	waitNoMseKey		;Warten bis keine Taste gedrückt.

			sei				;IRQ sperren.

if Flag64_128 = TRUE_C128
			lda	graphMode
			bpl	:40a
			lda	scr80colors		;wenn 80 Zeichen-Modus aktiv war
			jsr	i_UserColor		;dann Farbe auf VDC löschen
			b	0,0,80,25
			LoadB	graphMode,$00		;auf 40 Zeichen schalten (Probleme
			jsr	SetNewMode		;beim Wechsel von 80 auf 40 Zeichen)
::40a
endif

			ldx	CurTaskNr		;Zeiger auf aktuellen Task und
			lda	BankInUse00,x		;Bank-Status einlesen. Belegt ?
			bne	:51			; => Ja, weiter...
			jsr	FindLastTask		;Letzten belegten Task suchen und
			stx	CurTaskNr		;als aktuellen Task speichern.

::51			lda	TaskBank00,x		;Zeiger auf 64K-Speicherbank
			sta	CurTaskBank		;berechnen.

if Flag64_128 = TRUE_C128
			lda	TaskVDCBank00,x		;Bank-Adresse VDC setzen
			sta	CurTaskBankVDC
			lda	Task0Bank00,x		;Bank-Adresse Bank 0 setzen
			sta	CurTaskBank0
endif

			ldy	#%10010001		;I/O-Register einlesen.
			jsr	SetRAM_TaskVar

;--- Ergänzung: 04.09.21/M.Kanet
;ZeroPage initialisieren um Probleme
;mit dem RAMLink-Kernal und GeoWrite
;zu umgehen.
;Wird auch benötigt falls der letzte
;Task geschlossen und zum vorherigen
;Task zurückgekert werden soll.
			lda	#$00			;ZeroPage-Adressen
			sta	STATUS			;initialisieren.
			sta	C3PO
			sta	BSOUR

;--- TurboDOS abschalten.
			lda	SvCurDrive
			jsr	SetDevice		;Laufwerk aktivieren.
			jsr	PurgeTurbo		;TurboDOS deaktivieren.

if Flag64_128 = TRUE_C128
			ldx	MMU
			lda	#$7e
			sta	MMU
endif

if Flag64_128 = TRUE_C64
			ldx	CPU_DATA
			lda	#$35
			sta	CPU_DATA
endif

			ldy	#$2f
::52			lda	SaveD000,y		;I/O-Register zurücksetzen.
			sta	$d000   ,y
			dey
			bpl	:52

if Flag64_128 = TRUE_C128
			stx	MMU
			ldy	#%10010001		;Bereich lesen: Bank 0
			jsr	SetRAM_Area4
endif

if Flag64_128 = TRUE_C64
			stx	CPU_DATA
endif

;--- Speicherbereiche wieder herstellen.
			ldy	#%10010001		;Bereich lesen: $4000-$5FFF <= REU.
			jsr	SetRAM_TaskBuf
			ldy	#%10010000		;Bereich lesen: $4000-$5FFF => REU.
			jsr	SetRAM_TaskSys
			ldy	#%10010001		;Bereich lesen: $6000-$CFFF
			jsr	SetRAM_Area2
			ldy	#%10010001		;Bereich lesen: $6000-$CFFF
			jsr	SetRAM_MP_VAR
			ldy	#%10010001		;Bereich lesen: $0000-$03FF.
			jsr	SetRAM_ZPage		;(Als Kopie ab ":APP_RAM" ablegen!)

;--- TurboFlags löschen.
			ldy	#$03			;Turbo-Flags zurücksetzen.
			lda	#$00
::54			sta	turboFlags,y
			dey
			bpl	:54

			lda	SvCurDrive
			jsr	SetDevice		;Laufwerk aktivieren.
			jsr	GetDirHead		;Aktuelle BAM einlesen.

			ldy	#$00			;Kopie für ZeroPage-Bereich ab
::55			lda	APP_RAM +$0000,y	;":APP_RAM" = $0400 nach ":zpage".
			sta	zpage   +$0000,y	;Notwendig, da die Daten über
			lda	APP_RAM +$0100,y	;":StashRAM" kopiert werden und die
			sta	zpage   +$0100,y	;Routine die ZeroPage verändert.
			lda	APP_RAM +$0200,y
			sta	zpage   +$0200,y
			lda	APP_RAM +$0300,y
			sta	zpage   +$0300,y
			iny
			bne	:55

			ldx	#$1f			;Register ":r0" bis ":r15" retten.
::56			lda	r0L,x
			pha
			dex
			bpl	:56

			ldy	#%10010001		;Bereich lesen: $0400-$3FFF
			jsr	SetRAM_Area1

if Flag64_128 = TRUE_C128
			lda	graphMode
			jsr	SetNewMode
			bit	graphMode
			bpl	:40
			jsr	LoadVDC			;VDC Inhalt wiederherstellen
::40
endif

			ldx	#$00			;Register ":r0" bis ":r15"
::57			pla				;wieder zurückschreiben.
			sta	r0L,x
			inx
			cpx	#$20
			bne	:57

			ClrB	Flag_TaskAktiv		;TaskManager wieder freigeben.

			lda	Flag_SpoolCopy		;Spoolermenü-Flag setzen.
			sta	Flag_Spooler

			ldx	StackPointer		;Stackpointer zurücksetzen.
			txs
			lda	RetAdr +1		;Rücksprungadresse einlesen.
			pha
			lda	RetAdr +0
			pha

			bit	Flag_LoadDA		;Hilfsmittel starten ?
			bpl	:59			; => Nein, weiter...

			lda	SelectedDrive		;Hilfsmittel-Laufwerk öffnen.
			jsr	SetDevice

			ldy	#$00
			sty	Flag_LoadDA		;Hilfsmittel-Flag löschen und
::58			lda	InstDA,y		;DA-Loader nach ":fileTrScTab"
			sta	fileTrScTab,y		;kopieren. Dort wird das RAM wieder
			iny				;hergestellt und das Hilfsmittel
			bne	:58			;gestartet. Danach Rückkehr zur
			jmp	fileTrScTab +17		;Applikation.

;--- Hinweis:
;Hier kann aktuell keine Taste mehr
;gedrückt sein => Status löschen.
::59			ldx	#$00			;Tastenstatus löschen.
			stx	pressFlag
			stx	keyData
			dex
			stx	mouseData

			ldy	yRegBuf			;Register einlesen.
			ldx	xRegBuf
			lda	AkkuBuf
			rts				;Zum aktuellen Task zurück.

;*** Nächste freie RAM-Bank belegen.
:GetFreeBank		ldx	#$01
::51			lda	BankInUse00,x		;Bank-Status einlesen.
			beq	:52			;Bank frei ? => Ja, weiter...
			inx
			cpx	MaxTaskInstalled
			bne	:51
			rts

::52			stx	CurTaskNr		;Neuen Task speichern.

;*** Zeiger auf aktuelle Bank einlesen.
:GetCurBank		ldx	CurTaskNr		;Zeiger auf aktuellen Task.
			lda	#$ff			;Speicherbank als "Belegt" in
			sta	BankInUse01 -1,x	;Tabelle markieren.
			lda	TaskBank00,x		;Bank-Adresse einlesen und
			sta	CurTaskBank		;zwischenspeichern.

if Flag64_128 = TRUE_C128
			lda	TaskVDCBank00,x		;Bank-Adresse VDC einlesen und
			sta	CurTaskBankVDC		;zwischenspeichern.
			lda	Task0Bank00,x		;Bank-Adresse 0 einlesen und
			sta	CurTaskBank0		;zwischenspeichern.
endif

			rts

;*** Prüfen ob weitere 64K-Bank für neuen Task frei ist.
:IsTaskBankFree		ldx	MaxTaskInstalled	;Zeiger auf letzten Task.
			dex				;Weitere Task möglich ?
			beq	:53			; => Nein, Abbruch...
::51			ldy	TaskBank00 ,x		;Ist Task verfügbar ?
			beq	:52			; => Nein, weiter...
			lda	BankInUse00,x		;Ist Task bereits belegt ?
			beq	:54			; => Nein, Ende...
::52			dex
			bne	:51			;Weitersuchen.
::53			sec				; => Kein weitere Task möglich.
			rts
::54			clc				; => Weiterer Task möglich.
			rts

;*** Task als "Frei" markieren und letzten belegten
;    Task in Liste suchen.
:FreeCurTask		lda	#$00			;Task-Icon löschen.
			sta	BankInUse00   ,x	;Task-Bank wieder freigeben.

;*** Letzten geöffneten Task suchen.
:FindLastTask		ldx	MaxTaskInstalled	;Letzten belegten Task in Tabelle
			dex				;suchen und aktivieren.
			beq	:52			;Ist kein Task aktiv (sollte nicht
::51			lda	BankInUse00,x		;passieren) wird der erste Task
			bne	:52			;(gleich Systemtask) geöffnet.
			dex
			bpl	:51
			inx
::52			lda	#$ff
			sta	BankInUse00,x
			rts

;*** Programmstart initialisieren.
:PrepareExit		jsr	PurgeTurbo		;TurboDOS abschalten.
;			jsr	InitForIO		;Nur falls es Probleme mit
;			jsr	CLALL			;echten Laufwerken gibt, diese
;			jsr	DoneWithIO		;Befehle wieder einfügen.

			jsr	UpdateMenuFlags		;TaskManager aktualisieren.
			ClrB	Flag_TaskAktiv		;TaskManager-Menü deaktivieren.
			jsr	GEOS_InitSystem		;GEOS-Reset #1.
			jsr	UseSystemFont		;Standardzeichensatz.
			jsr	xResetScreen		;Bildschirm löschen.

;*** ZeroPage löschen.
;    Wichtig für GetFile! Einige Programme starten sonst nicht korrekt!
:InitZeroPage		ldx	#r15H
			lda	#$00
::51			sta	zpage,x
			dex
			cpx	#r0L
			bcs	:51
			rts

;*** Speicherbereiche speichern/zurückschreiben.
;    Übergabe:		yReg = Befehlsbyte für DoRAMOp.
;--- Bereich: $0000-$03FF.
:SetRAM_ZPage		lda	#< APP_RAM		;C64 : ":APP_RAM"
			sta	r0L			;(Kopie von $0000-$03FF)
			lda	#> APP_RAM
			sta	r0H
			lda	#$00			;REU : $0000
			sta	r1L
			sta	r1H
			sta	r2L			;BYTE: $0400
			ldx	#$04
			stx	r2H
			jmp	SetRAM_Bank

;--- Bereich: $0400-$3CFF.
:SetRAM_Area1		lda	#$00			;C64 : $0400
			sta	r0L
			ldx	#$04
			stx	r0H
			sta	r1L			;REU : $0400
			stx	r1H
			sta	r2L			;BYTE: $3C00
			ldx	#$3c
			stx	r2H
			jmp	SetRAM_Bank

;--- Bereich: $6000-$CFFF.
:SetRAM_Area2		lda	#$00			;C64 : $6000
			sta	r0L
			ldx	#$60
			stx	r0H
			sta	r1L			;REU : $6000
			stx	r1H
			sta	r2L			;BYTE: $7000
			ldx	#$70
			stx	r2H
			jmp	SetRAM_Bank

;--- Bereich: $8000-$9FFF.
:SetRAM_Area3		lda	#$00			;C64 : $8000
			sta	r0L
			ldx	#$80
			stx	r0H
			sta	r1L			;REU : $8000
			stx	r1H
			sta	r2L			;BYTE: $2000
			ldx	#$20
			stx	r2H
			jmp	SetRAM_Bank

;--- Bereich: TaskManager-Speicher.
:SetRAM_TaskSys		lda	#$00			;C64 : $6000
			sta	r0L
			ldx	#$60
			stx	r0H
			sta	r1L			;REU : $4000
			ldx	#$40
			stx	r1H
			sta	r2L			;BYTE: $2000
			ldx	#$20
			stx	r2H
			jmp	SetRAM_TaskBank

;--- Bereich: TaskManager-Systemspeicher.
:SetRAM_TaskBuf		lda	#$00			;C64 : $6000
			sta	r0L
			ldx	#$60
			stx	r0H
			sta	r1L			;REU : $E000
			ldx	#$e0
			stx	r1H
			sta	r2L			;BYTE: $2000
			ldx	#$20
			stx	r2H
			jmp	SetRAM_Bank

;--- Bereich: MP-Variablen.
:SetRAM_MP_VAR		lda	#<OS_VAR_MP		;C64 : OS_VAR_MP
			sta	r0L
			sta	r1L
			lda	#>OS_VAR_MP		;REU: OS_VAR_MP
			sta	r0H
			sta	r1H
			lda	#<R3_SIZE_MPVARBUF
			sta	r2L			;BYTE: R3_SIZE_MPVARBUF
			lda	#>R3_SIZE_MPVARBUF
			sta	r2H
			jmp	SetRAM_TaskBank

;*** Speicherbereiche speichern/zurückschreiben.
;    Übergabe:		yReg = Befehlsbyte für DoRAMOp.
;--- Bereich: TaskManager-Variablen.
:SetRAM_TaskVar		lda	#< CurTaskVar		;C64 : ":CurTaskVar"
			sta	r0L
			lda	#> CurTaskVar
			sta	r0H
			lda	#< $d000		;REU : $D000
			sta	r1L
			lda	#> $d000
			sta	r1H
			lda	#< (EndCurTaskVar-CurTaskVar)
			sta	r2L
			lda	#> (EndCurTaskVar-CurTaskVar)
			sta	r2H

;--- Zeiger auf Task-Bank.
:SetRAM_Bank		lda	CurTaskBank
			sta	r3L
			jmp	DoRAMOp

;--- Bereich: TaskManager-Menü speichern.
:UpdateMenuFlags	jsr	SetADDR_TaskMan
			jmp	StashRAM

;--- Zeiger auf SystemTask-Bank.
:SetRAM_TaskBank	lda	TaskBank00
			sta	r3L
			jmp	DoRAMOp

;*** Speicherbereiche speichern/zurückschreiben.
;    Übergabe:		yReg = Befehlsbyte für DoRAMOp.
if Flag64_128 = TRUE_C128
:SetRAM_Area4		php
			sei
			sty	:1+1
			tya
			and	#%00000001
			beq	:3
			jmp	:4
::3			lda	#$20			;$2000 bis $3fff
			sta	r0H
			sta	r2H			;r0 = $2000
			lda	#$00			;r1 = $0400
			sta	r0L			;r2 = $2000
			sta	r1L
			sta	r2L
			lda	#$04
			sta	r1H
			jsr	:2

			lda	#$00
			sta	r0L
			sta	r1L
			sta	r2L
			LoadB	r0H,$40			;$4000 bis $6fff
			LoadB	r1H,$04
			LoadB	r2H,$30
			jsr	:2

			lda	#$00
			sta	r0L
			sta	r1L
			LoadB	r0H,$70			;$7000 bis $9fff
			LoadB	r1H,$04
			jsr	:2

			lda	#$00
			sta	r0L
			sta	r1L
			LoadB	r0H,$a0			;$a000 bis $cfff
			LoadB	r1H,$04
			jsr	:2

			lda	#$00
			sta	r0L
			sta	r1L
			sta	r2L
			LoadB	r0H,$e0			;$e000 bis $fbff
			LoadB	r1H,$04
			LoadB	r2H,$1c
			jsr	:2
			plp
			rts

::2			ldx	#0
			stx	r3L
			inx
			stx	r3H
			jsr	MoveBData

			ldx	r1H
			ldy	r1L
			MoveW	r0,r1
			stx	r0H
			sty	r0L
::1			ldy	#0
			lda	CurTaskBank0
			sta	r3L
			jmp	DoRAMOp

::5			ldx	#0
			stx	r3H
			inx
			stx	r3L
			jmp	MoveBData

;*** Speicherbereiche speichern/zurückschreiben.
;    (Fortsetzung C128).
::4			lda	#$20
			sta	r1H
			sta	r2H
			lda	#$00
			sta	r0L
			sta	r1L
			sta	r2L
			LoadB	r0H,$04			;$2000 bis $3fff
			jsr	:1
			jsr	:5

			lda	#$00
			sta	r1L
			sta	r2L
			LoadB	r1H,$40			;$4000 bis $6fff
			LoadB	r2H,$30
			jsr	:1
			jsr	:5

			LoadW	r1,$7000		;$7000 bis $9fff
			jsr	:1
			jsr	:5

			LoadW	r1,$a000		;$a000 bis $cfff
			jsr	:1
			jsr	:5

			lda	#$00
			sta	r1L
			sta	r2L
			LoadB	r1H,$e0			;$e000 bis $fbff
			LoadB	r2H,$1c
			jsr	:1
			jsr	:5
			plp
			rts
endif

;*** Signal-Meldung in Register-Tabelle definieren.
;    Wenn Dialogbox/Hilfsmittel geöffnet ist, kann Applikation
;    nicht gewechselt werden!
;    Anzeige des Textes erfolgt über das hinzufügen des entsprechenden
;    Befehls in die Registertabelle.
:SetWarning		lda	#$05			; => Hinweis nicht anzeigen.
			bit	Flag_ExtRAMinUse	;Speicherstatus testen.
			bmi	:51			;Hilfsmittel aktiv ?
			bvc	:52			;Dialogbox aktiv ?
::51			lda	#$06			; => Hinweis anzeigen.
::52			sta	RegMenu01
			rts

;*** Warnhinweis ausgeben:
;    Wenn Dialogbox/Hilfsmittel geöffnet ist, kann Applikation
;    nicht gewechselt werden!
:DoSignal		bit	Flag_ExtRAMinUse	;Ext. Speicher testen.
			bmi	:51			;Hilfsmittel aktiv? => Ja, weiter...
			bvs	:51			;Dialogbox aktiv  ? => Ja, weiter...

			jsr	SetWarning		;Hinweis abschalten.

			lda	#$00			;Hinweisanzeige auf Bildschirm
			jsr	SetPattern		;löschen.
			jsr	Rectangle
			jsr	RegClrOptFrame
			lda	C_RegisterBack
			jmp	DirectColor

::51			lda	RegMenu01_05
			sta	:52 +1
			lsr
			lsr
			lsr
			sta	:53 +1
			clc
			adc	#$01
			sta	:54 +1

			jsr	i_BitmapUp		;Warndreieck zeichnen.
			w	Icon_23
::52			b	$04 ! DOUBLE_B
			b	$80
			b	Icon_23x ! DOUBLE_B
			b	Icon_23y

			lda	C_InputField

if Flag64_128 = TRUE_C128
			bit	graphMode
			bpl	:40
			ldx	#$d0
			stx	:54a
			and	#%00001111
			ora	#$d0
			jmp	:80
::40
endif
			and	#%00001111
			ora	#$70
::80			jsr	i_UserColor
::53			b	$04 ! DOUBLE_B
			b	$10
			b	Icon_23x ! DOUBLE_B
			b	Icon_23y/8
			jsr	i_ColorBox
::54			b	$05 ! DOUBLE_B
			b	$11
			b	$01 ! DOUBLE_B
			b	$01
::54a			b	$70

			lda	#<RegTText1_1_07
			ldx	#>RegTText1_1_07
			bit	Flag_ExtRAMinUse	;Ext. Speicher testen.
			bmi	:55			; => Hilfsmittel aktiv.

			lda	#<RegTText1_1_06
			ldx	#>RegTText1_1_06

;--- Ergänzung: 01.07.18/M.Kanet
;In der Version von 2003 wurde diese Abfrage entfernt.
;Der bit-Befehl ist auch nicht erforderlich da an dieser
;Stelle das Flag ":Flag_ExtRAMinUse entweder das Bit #7
;für die Dialogbox oder Bit #6 für ein Hilfsmittel
;verwendet. Ist also Bit #7 nicht gesetzt muss ein
;Hilfsmittel aktiv sein.
;			bit	Flag_ExtRAMinUse	;Ext. Speicher testen.
;			bvc	:56			; => Dialogbox aktiv.

::55			sta	r0L
			stx	r0H
			jsr	PutString

::56			LoadW	r0,RegTText1_1_08	;Warnhinweis ausgeben.
			jmp	PutString

;*** Dateiauswahlbox.
;    Übergabe:		Akku = Dateityp.
:DoFileBox		sta	TypeOfFiles		;Dateityp zwischenspeichern.

;--- RAM-Laufwerk suchen.
::52			ldy	SelectedDrive		;War letztes Laufwerk ein
			lda	driveType -8,y		;RAM-Laufwerk ?
			bmi	:56			; => Ja, Laufwerk als Vorgabe.

			ldy	#8
::53			lda	driveType -8,y
			bmi	:56
			iny
			cpy	#12
			bcc	:53

;--- Kein RAM-Laufwerk installiert, erstes Laufwerk suchen.
::54			ldy	#8
::55			lda	driveType -8,y
			bne	:56
			iny
			cpy	#12
			bcc	:55

			ldy	#$08			;Vorgabewert.
::56			sty	SelectedDrive		;Erstes Laufwerk zwischenspeichern.

;*** Auswahlbox starten.
:DoFileBoxJob		lda	SelectedDrive
::51			jsr	SetDevice		;Neues Laufwerk aktivieren.
::52			jsr	OpenDisk		;Diskette öffnen.

::53			lda	TypeOfFiles		;Dateityp festlegen.
			sta	r7L

			LoadW	r5 ,NameOfFile		;Zeiger auf Dateiname.
			LoadW	r10,NameOfClass		;Zeiger auf Datei-Klasse.
			ldx	#< Dlg_SlctFile
			ldy	#> Dlg_SlctFile
			jsr	DoSysDlgBox		;Dateiauswahlbox aufrufen.

			lda	sysDBData		;Dialogbox-Flag einlesen.
			bpl	:54			;Laufwerkswechsel = Nein, weiter...

;--- Neues Laufwerk.
			and	#%00001111		;Laufwerksadresse isolieren und
			sta	SelectedDrive		;neues Laufwerk aktivieren.
			jmp	:51

;--- Datei öffnen.
::54			cmp	#OPEN			;Datei öffnen ?
			bne	:55			; => Nein, weiter...
			clc
			rts

;--- Abbruch/Disk.
::55			cmp	#CANCEL			;Abbruch ?
			beq	:56			; => Ja, Ende...
			cmp	#DISK			;Diskette wechseln ?
			beq	:52			; => Ja, weiter...
::56			sec
			rts

;*** Datei auswählen und Dateieintrag suchen.
;    Übergabe:		Akku = Dateityp.
:SelectFile1		bit	Flag_ExtRAMinUse	;Ext. Speicher testen.
			bmi	:51			; => Hilfsmittel aktiv ?
			bvs	:51			; => Dialogbox aktiv ?

			pha
			jsr	IsTaskBankFree		;Weiterer Task möglich ?
			pla
			bcs	:51			; => Nein, Abbruch...

			jsr	SelectFile2		;Datei auswählen.
			bcs	:51			;Abbruch = => Ja, Ende...

;--- Hinweis:
;Neuen Task erst anlegen, bevor die
;neue Anwendung geöffnet wird!
;Wird der Vorgang abgebrochen, dann
;existiert ein Task in der Tabelle,
;aber ohne gültigen Inhalt!
;Ein Wechsel führt dann zum Absturz.
;			jsr	SaveTaskName		;Dateiname in Tabelle eintragen.
			clc
			rts

::51			sec
			rts

;*** Applikation/Drucker auswählen.
:SelectFile2		ldx	#NULL
			stx	NameOfClass
			beq	SelectFile

;*** Dokument öffnen.
:SelectFile3		bit	Flag_ExtRAMinUse	;Ext. Speicher testen.
			bmi	:51			; => Hilfsmittel aktiv ?
			bvs	:51			; => Dialogbox aktiv ?

			pha
			jsr	IsTaskBankFree		;Weiterer Task möglich ?
			pla
			bcs	:51			; => Nein, Abbruch...

			jsr	SelectFile		;Datei auswählen.
			bcs	:51			;Abbruch = => Ja, Ende...

;--- Hinweis:
;Neuen Task erst anlegen, bevor die
;neue Anwendung geöffnet wird!
;Wird der Vorgang abgebrochen, dann
;existiert ein Task in der Tabelle,
;aber ohne gültigen Inhalt!
;Ein Wechsel führt dann zum Absturz.
;			jsr	SaveTaskName		;Dateiname in Tabelle eintragen.
			clc
			rts

::51			sec
			rts

;*** Datei auswählen:
;    Übergabe: AKKU = Dateityp (APPL_DATA)
:SelectFile		jsr	DoFileBox		;Datei auswählen.
			bcc	:52			; => OK, weiter...
::51			sec
			rts

::52			LoadW	r6,NameOfFile
			jsr	FindFile		;Datei auf Diskette suchen.
			txa				;Diskettenfehler ?
			bne	:51			; => Ja, Abbruch...
			clc
			rts

;*** Liste mit geöffneten Tasks zeichnen.
:PrintAllTEntry		lda	#$00			;Zeiger auf ersten Task.
::51			jsr	PrintCurTEntry		;Aktuellen Task ausgeben.
			clc				;Zeiger auf nächsten Task.
			adc	#$01
			cmp	MaxTaskInstalled	;Alle Tasks ausgegeben ?
			bcc	:51			; => Nein, weiter...
			rts

;*** Aktuellen Task invertieren.
;    Übergabe:		AKKU = Task-Nr. in Liste.
:PrintCurTEntry		pha
			cmp	SelectedTask		;Aktuellen Task ausgeben ?
			bne	:51			; => Nein, weiter...
			lda	#$01			;Parameter für "Aktueller Task".
			ldx	#SET_REVERSE
			bne	:52

::51			lda	#$00			;Parameter für "Task".
			ldx	#SET_PLAINTEXT

::52			stx	currentMode		;Textmodus definieren.
			jsr	SetPattern		;Füllmuster definieren.
			pla

			pha				;Grenzen für Eintrag in Task-Liste
			asl				;berechnen.
			asl
			asl
			clc
			adc	RegMenu01_01
			sta	r2L
			clc
			adc	#$07
			sta	r2H
			LoadW	r3 ,$0020 ! DOUBLE_W
			LoadW	r4 ,$00e7 ! DOUBLE_W
			jsr	Rectangle		;Rechteck-Bereich löschen.
			pla

			pha				;Koordinaten für Text-Ausgabe
			tax				;definieren.
			asl
			asl
			asl
			clc
			adc	RegMenu01_01
			clc
			adc	#$06
			sta	r1H
			LoadW	r11,$0028 ! DOUBLE_W

			lda	BankInUse00,x		;Ist Bank belegt ?
			bne	:53			; => Ja, weiter...
			LoadW	r0 ,Text_NotUsed
			jsr	PutString		;Text "Task frei" ausgeben.
			jmp	:54

::53			txa
			ldx	#r0L
			jsr	SetNameVec		;Zeiger auf TaskName berechnen und
			jsr	PutString		;TaskName ausgeben.

::54			pla				;Ende.
			rts

;*** Tastaturabfrage installieren/löschen.
:InstallKeyCheck	LoadW	keyVector,SelectTaskKeyB
			rts

:SelectTaskKeyB		ldx	RegisterAktiv
			dex
			beq	:52
::51			rts

::52			lda	keyData
			beq	:51
			cmp	#17
			beq	NextTask
			cmp	#16
			beq	LastTask
			cmp	#13
			bne	:51
			jmp	OpenSlctTask

:NextTask		ldx	SelectedTask
			inx
			cpx	MaxTaskInstalled
			beq	NoOtherTask
			txa
			jmp	PrintNewTask

:LastTask		ldx	SelectedTask
			beq	NoOtherTask
			dex
			txa
			jmp	PrintNewTask
:NoOtherTask		rts

;*** Neuen Task auswählen.
:SlctNewTask		lda	r1L			;Register-Aufruf "Anzeige" ?
			beq	:53			; => Ja, Ende...

			bit	Flag_ExtRAMinUse	;Speicher-Flag testen.
			bmi	:53			; => Hilfsmittel aktiv, Abbruch.
			bvs	:53			; => Dialogbox aktiv, Abbruch.

			lda	dblClickCount		;Ist Doppelklick aktiv ?
			beq	:51			; => Nein, weiter...

			jsr	GetSlctEntry		;Gewählten Task berechnen.
			cmp	MaxTaskInstalled	;Task gültig ?
			bcs	:53			; => Nein, Abbruch...
			cmp	SelectedTask		;Doppelklick auf Task ?
			beq	OpenSlctTask		; => Ja, öffnen.
			ldx	#$00			;Doppelklick deaktivieren und
			stx	dblClickCount		;neuen Task auswählen.
			beq	:52

::51			jsr	GetSlctEntry		;Gewählten Task berechnen.
			cmp	MaxTaskInstalled	;Task gültig ?
			bcs	:53			; => Nein, Abbruch...
::52			jsr	PrintNewTask
			jsr	DoMenuSleep		;Doppelklick aktivieren.
::53			rts

;*** Neuen Task auswählen und anzeigen.
;    Übergabe:		AKKU = Neuer Task.
:PrintNewTask		ldx	SelectedTask		;Neuen Task anzeigen.
			sta	SelectedTask
			txa
			jsr	PrintCurTEntry
			lda	SelectedTask
			jmp	PrintCurTEntry

;*** Gewählten Task löschen.
:CloseSlctTask		ldx	SelectedTask		;Systemtask gewählt ?
			beq	DoNotOpenTask		; => Ja, Abbruch...
			jsr	FreeCurTask		;Task freigeben.
			lda	SelectedTask		;Neuen Task anzeigen.
			stx	SelectedTask
			jsr	PrintCurTEntry
			lda	SelectedTask
			jsr	PrintCurTEntry
			lda	Flag_ExtRAMinUse	;Speicher für Hilfsmittel und
			and	#%00111111		;Dialogboxen freigeben.
			sta	Flag_ExtRAMinUse
:DoNotOpenTask		rts

;*** Gewählten Task öffnen.
:OpenSlctTask		ldx	SelectedTask		;Zeiger auf aktuellen Task.
			lda	BankInUse00   ,x	;Ist TaskBank belegt ?
			beq	DoNotOpenTask		; => Nein, Abbruch...

			jsr	ChkCurDrvConfig		;Aktuelle Konfiguration testen.
			txa				;Konfiguration geändert ?
			bne	DoNotOpenTask		; => Ja, Ende...

			ldx	SelectedTask		;Zeiger auf aktuellen Task.

;*** Neuen Task öffnen.
;    Übergabe:		xReg = Task-Nr.
:OpenTask		stx	CurTaskNr		;Neuen Task speichern.
			jsr	UpdateMenuFlags		;TaskManager-Variablen sichern.
			jmp	BackToCurTask

;*** Auf Doppelklick testen.
:DoMenuSleep		lda	#$1e			;Zähler für Doppelklick-Pause
			sta	dblClickCount		;festlegen.
			lda	selectionFlash
			sta	r0L
			lda	#$00
			sta	r0H
			jmp	Sleep			;Pause ausführen.

;*** Gewählten Eintrag ermitteln.
:GetSlctEntry		lda	mouseYPos
			sec
			sbc	RegMenu01_01
			lsr
			lsr
			lsr
			rts

;*** Icon in TaskMenü installieren.
:SaveTaskName		jsr	GetFreeBank		;Freie Bank suchen.

			lda	CurTaskNr		;TaskName kopieren.
			ldx	#r0L
			jsr	SetNameVec

			ldy	#$0f
::51			lda	NameOfFile,y
			sta	(r0L)     ,y
			dey
			bpl	:51
			rts

;*** Laufwerkskonfiguration einlesen.
:GetCurDrvConfig	ldy	#$00
			ldx	#$00			;Installierte Tasks zählen.
::51			lda	BankInUse00,y		;Die aktuelle Konfiguration wird
			beq	:52			;nur dann gespeichert, wenn keine
			inx				;zusätzlichen Tasks geöffnet sind.
::52			iny
			cpy	#MAX_TASK_ACTIV
			bne	:51

			dex				;Mehr als ein Task geöffnet ?
			bne	:55			; => Ja, Ende...

;--- Ergänzung: 08.07.18/M.Kanet
;In der Version von 2003 wurde das direkte setzen der FetchRAM-Adressen
;durch eine Subroutine ersetzt.
			jsr	SetFRData		;Daten für FetchRAM zum einlesen
							;des Lauafwertyp-Kennbytes
							;festlegen.

			ldx	#8			;Aktuelle Konfiguration auslesen und
::53			lda	driveType -8,x		;zwischenspeichern.
			beq	:54
;--- Ergänzung: 08.07.18/M.Kanet
;In der Version von 2003 wurde das direkte setzen der Laufwerke
;durch eine Subroutine ersetzt.
			jsr	GetDType
::54			sta	CurDkDrvConfig -8,x
			inx
			cpx	#12
			bcc	:53

::55			jmp	UpdateMenuFlags		;TaskMan aktualisieren.

;*** Wurden Lauafwerke getauscht ?
:ChkCurDrvConfig	lda	CurTaskNr		;Soll der aktuelle Task
			cmp	SelectedTask		;wieder geöffnet werden ?
			beq	:53			; => Ja, weiter...

;--- Ergänzung: 08.07.18/M.Kanet
;In der Version von 2003 wurde das direkte setzen der FetchRAM-Adressen
;durch eine Subroutine ersetzt.
			jsr	SetFRData		;Daten für FetchRAM zum einlesen
							;des Lauafwertyp-Kennbytes
							;festlegen.

			ldx	#8			;Aktuelle Konfiguration mit der
::51			lda	driveType -8,x		;Konfiguration des ersten (System-)
			beq	:52			;Tasks vergleichen. Bei Änderung
;--- Ergänzung: 08.07.18/M.Kanet
;In der Version von 2003 wurde das direkte setzen der Laufwerke
;durch eine Subroutine ersetzt.
			jsr	GetDType		;Meldung ausgeben.
::52			cmp	CurDkDrvConfig -8,x
			bne	:54
			inx
			cpx	#12
			bcc	:51
::53			ldx	#$00
			rts

;*** Konfiguration geändert, Dialogbox ausgeben und Ende...
::54			ldx	#< Dlg_ConfigError
			ldy	#> Dlg_ConfigError
			jsr	DoSysDlgBox
			ldx	#$0d
			rts

;--- Ergänzung: 01.07.18/M.Kanet
;Die Routinen ":GetDType" und ":SetFRData" wurden mehrfach verwendet und
;in der Version von 2003 in eigene Subroutinen ausgelagert.
;*** Laufwerkstyp-Kennbyte einlesen.
:GetDType		txa
			pha

			lda	DskDrvBaseL -8,x
			clc
			adc	#< (DiskDrvType - DISK_BASE)
			sta	r1L
			lda	DskDrvBaseH -8,x
			adc	#> (DiskDrvType - DISK_BASE)
			sta	r1H

			jsr	FetchRAM

			pla
			tax

;--- Ergänzung: 26.10.18/M.Kanet
;Wird für das einlesen des Laufwerkstyp-Kennbytes über FetchRAM eine
;Ziel-Adresse in der ZeroPage verwendet scheint das auslesen und speichern
;des Kennbytes nicht zuverlässig zu funktionieren. Evtl. ein Problem mit
;dem Bank-Management des C128.
;Als Ziel-Adresse wird jetzt :DkDrvTypeBuf verwendet.
;Siehe auch :SetFRData.
			lda	DkDrvTypeBuf
			rts

;*** Daten für FetchRAM zum einlesen des Laufwerkstyp-Kennbytes festlegen.
:SetFRData		lda	#<DkDrvTypeBuf
			sta	r0L
			lda	#>DkDrvTypeBuf
			sta	r0H
			ldx	#$01
			stx	r2L
			dex
			stx	r2H
			stx	r3L
			rts

;*** Anwendungen laden.
:OPEN_Application	lda	#APPLICATION
			b $2c
:OPEN_AutoExec		lda	#AUTO_EXEC
			ldy	r1L
			beq	:51

			jsr	SelectFile1		;Datei auswählen.
			bcs	:51			; => Abbruch...

			jsr	SaveTaskName		;Dateiname in Tabelle eintragen.

			jsr	PrepareExit		;Programmstart initialisieren.

			LoadW	r6,NameOfFile
			jmp	NewGetFile		;Applikation starten.
::51			rts

;*** Hilfsmittel laden.
:OPEN_DeskAcc		ldy	r1L
			beq	:53

;--- Ergänzung: 08.07.18/M.Kanet
;In der Version von 2003 wurde das laden/starten eines weiteren Hilfsmittels
;unterbunden. Dies würde sonst das SwapFile im RAM des bereits aktiven
;Hilfsmittels überschreiben.
			bit	Flag_ExtRAMinUse	;Speicher-Flag testen.
			bmi	:53			; => Hilfsmittel aktiv, Abbruch.

			lda	#DESK_ACC
			jsr	SelectFile2		;Hilfsmittel auswählen.
			bcs	:52			; => Abbruch, zurück zum Menü.

			ldy	#15			;Dateiname in Zwischenspeicher
::51			lda	NameOfFile,y		;kopieren.
			sta	InstDA    ,y
			dey
			bpl	:51

			lda	#$ff			;Hilfsmittel-Flag setzen.
			sta	Flag_LoadDA
			jmp	BackToCurTask		;Zurück zur Anwendung, DA starten.
::52			jmp	ReDrawTaskMenu		;Zurück zum Hauptmenü.
::53			rts

;*** Dokument öffnen.
:OPEN_Document		ldy	r1L
			bne	:51
			rts

::51			lda	#NULL
			sta	NameOfClass
			beq	OPEN_ApplData

;*** Write-Dokument öffnen.
:OPEN_WriteImage	ldy	r1L
			bne	:51
			rts

::51			jsr	i_MoveData
			w	WriteClass
			w	NameOfClass
			w	13
			jmp	OPEN_ApplData

;*** Paint-Dokument öffnen.
:OPEN_PaintImage	ldy	r1L
			bne	:51
			rts

::51			jsr	i_MoveData
			w	PaintClass
			w	NameOfClass
			w	13

;*** Beliebiges Dokument öffnen.
;    Übergabe:		NameOfClass = Datei-Klasse.
:OPEN_ApplData		lda	#APPL_DATA
			jsr	SelectFile3		;Datei auswählen.
			bcc	:52			; => Abbruch...
::51			rts

::52			ldx	#r0L			;Diskettenname für Dokument
			jsr	GetPtrCurDkNm		;zwischenspeichern.

			ldy	#$0f
::53			lda	(r0L)        ,y
			sta	NameOfDokDisk,y
			dey
			bpl	:53

			LoadW	r9,dirEntryBuf
			jsr	GetFHdrInfo		;Infoblock einlesen.
			txa				;Diskettenfehler ?
			bne	:51			; => Nein, Abbruch...

			ldy	#11
::54			lda	fileHeader +$75,y
			sta	FileClass      ,y
			dey
			bpl	:54

			jsr	IsApplOnDsk		;Applikation suchen.
			txa				;Gefunden ?
			bne	:51			; => Nein, Abbruch...

			ldy	#$0f			;Disketten-/Dateiname für
::55			lda	NameOfDokDisk,y		;GetFile bereitstellen.
			sta	dataDiskName ,y
			lda	NameOfFile   ,y
			sta	dataFileName ,y
			dey
			bpl	:55

			jsr	SaveTaskName		;Dateiname in Tabelle eintragen.

			jsr	PrepareExit		;Programmstart initialisieren.

			LoadB	r0L,%10000000
			LoadW	r2 ,dataDiskName	;Zeiger auf Diskettennamen.
			LoadW	r3 ,dataFileName	;Zeiger auf Dateiname.
			LoadW	r6 ,NameOfAppl		;Name der Applikation.

;*** Anwendung/Dokument laden.
;    Bei einem Fehler wird "EnterDeskTop" ausgeführt.
:NewGetFile		lda	#> EnterDeskTop-1	;Rücksprungadresse setzen, falls
			pha				;Diskettenfehler beim laden des
			lda	#< EnterDeskTop-1	;Programms auftritt.
			pha

;--- Ergänzung: 27.01.18/M.Kanet
;Am C128 Modus-Flag testen und auf 40/80Z umschalten.
if Flag64_128 = TRUE_C128
			jsr	ChkFlag_40_80Z		;40/80Z testen.
			txa				;Fehler?
			bne	:51			; -> Ja, Abbruch (Nur GEOS64).
endif

			jmp	GetFile			;Dokument öffnen.
::51			rts				;Zurück zum letzten Task.

;--- Ergänzung: 27.01.18/M.Kanet
;Die Anwendung auf 40/80Z testen und Bildschirm-Modus setzen.
;Damit lässt sich auch geoWrite64 aus dem 80Z-Modus des C128 starten.
if Flag64_128 = TRUE_C128
;*** C128: 40/80Z-Modus testen.
:ChkFlag_40_80Z		PushB	r0L
			PushW	r6			;Zeiger auf Dateiname sichern.
			jsr	FindFile		;Datei auf Diskette suchen.
			txa				;Diskettenfehler ?
			bne	:52			; => Ja, Abbruch...

			LoadW	r9,dirEntryBuf		;Infoblock einlesen.
			jsr	GetFHdrInfo
			txa				;Info-Block gefunden ?
			bne	:52			; => Nein, BASIC-File, Abbruch...

			lda	fileHeader+$60		;40/80Z-Flag einlesen.
			beq	:set_40Z		;Nur 40Z -> 40Z-Modus setzen.
			cmp	#%11000000		;Nur 80Z ?
			beq	:set_80Z		;Ja -> 80Z-Modus setzen.
			cmp	#%01000000		;40/80Z ?
			beq	:set_80Z		;Ja -> 80Z-Modus setzen.
			ldx	#INCOMPATIBLE		; -> Nur GEOS64, Abbruch.
			bne	:52
::set_80Z		lda	#%10000000		;80Z-Modus setzen.
			b $2c
::set_40Z		lda	#%00000000		;40Z-Modus setzen.
			cmp	graphMode		;Neuer Modus bereits aktiv?
			beq	:51			; -> Ja, weiter...
			sta	graphMode
			jsr	SetNewMode		;Neuen Modus aktivieren.

::51			lda	#%00000000		;Verdopplung abschalten.
			sta	DB_DblBit

			ldx	#NO_ERROR
::52			PopW	r6
			PopB	r0L
			rts
endif

;*** Applikation für Dokument suchen.
:IsApplOnDsk		lda	#%10000000		;Applikation auf RAM-
			jsr	FindAppl		;Laufwerken suchen...
			bcc	:51
			lda	#%00000000		;Applikation auf Nicht-RAM-
			jsr	FindAppl		;Laufwerken suchen...
			bcc	:51
			ldx	#$05			;"Applikation nicht gefunden".
			rts
::51			ldx	#$00
			rts

;*** DeskTop-Datei suchen.
:FindAppl		sta	:52 +1			;Laufwerkstyp merken.

			ldx	#$08
::51			stx	:53 +1			;Zeiger auf Laufwerk speichern.

			lda	driveType -8,x		;Laufwerk verfügbar ?
			beq	:53			; => Nein, weiter...
			and	#%10000000
::52			cmp	#$ff			;Laufwerkstyp korrekt ?
			bne	:53			; => Nein, weiter...
			txa
			jsr	LookForAppl		;Applikation auf Diskette ?
			bcc	:54			; => Ja, weiter...

::53			ldx	#$ff
			inx
			cpx	#$0c			;Alle Laufwerke getestet ?
			bne	:51			; => Nein, weiter...
			sec
::54			rts

;*** Neue DeskTop-Diskette öffnen.
:LookForAppl		jsr	SetDevice		;Laufwerk aktivieren.
			txa				;Diskettenfehler ?
			bne	:51			; => Ja, Abbruch...

			jsr	OpenDisk		;Diskette öffnen.
			txa				;Diskettenfehler ?
			bne	:51			; => Ja, Abbruch...

			LoadW	r6 ,NameOfAppl
			LoadB	r7L,APPLICATION
			LoadB	r7H,1
			LoadW	r10,FileClass
			jsr	FindFTypes		;Applikation auf Diskette suchen.
			txa				;Diskettenfehler ?
			bne	:51			; => Ja, Abbruch...

			lda	r7H			;Applikation gefunden ?
			bne	:51			; => Nein, weitersuchen...
			clc
			rts
::51			sec
			rts

;*** Zeiger auf Task-Name berechnen.
:SetNameVec		sta	:51 +1
			asl
			asl
			asl
			asl
			clc
::51			adc	#$ff
			clc
			adc	#<TaskName00
			sta	zpage       +0,x
			lda	#$00
			adc	#>TaskName00
			sta	zpage       +1,x
			rts

;*** Druckertreiber laden.
:OPEN_Printer		lda	#PRINTER
			jsr	SelectFile2		;Datei auswählen.
			bcs	:54			; => Abbruch...

			LoadB	r0L,%00000001		;Druckertreiber laden.
			LoadW	r6 ,NameOfFile		;(Dadurch wird beim C64 der Treiber
			LoadW	r7 ,PRINTBASE		; ins ext.RAM geladen!)
			jsr	GetFile
			txa				;Diskettenfehler ?
			bne	:54			; => Ja, Abbruch...

			ldy	#$0f			;Druckername kopieren.
::51			lda	NameOfFile  ,y		;Druckertreiber wird bei GetFile
			sta	PrntFileName,y		;automatisch in das RAM des C64
			dey				;geladen, Name ab "PrntFileNameRAM"
			bpl	:51			;wird dabei automatisch angepasst.

;*** Name des Druckertreibers in allen aktiven Tasks
;    durch neuen Druckertreiber-Namen ersetzen.
;    Notwendig, da nur ein Treiber für alle Tasks im RAM zur Verfügung
;    steht und der Name des Druckertreibers im gespeicherten RAM
;    aller offenen Anwendungen gespeichert ist!
if Flag64_128 = TRUE_C128
			LoadW	r0,PrntFileName
endif

if Flag64_128 = TRUE_C64
			LoadW	r0,PrntFileNameRAM
endif

			LoadW	r2,17

			ldx	#$00
::52			stx	r15H
			lda	BankInUse00 ,x		;Task geöffnet ?
			beq	:53			; => Nein, weiter...
			lda	TaskBank00  ,x		;Zeiger auf Task-Bank setzen und
			sta	r3L			;Druckertreiber-Name speichern.

if Flag64_128 = TRUE_C64
			LoadW	r1,PrntFileNameRAM
			jsr	StashRAM
endif

			LoadW	r1,PrntFileName
			jsr	StashRAM
::53			ldx	r15H
			inx
			cpx	MaxTaskInstalled
			bcc	:52
::54			rts

;*** Druckerspooler-Menü aktivieren.
:OPEN_Spooler		lda	#%11000000		;Menü-Flag setzen und TaskManager
			sta	Flag_SpoolCopy		;beenden. Beim nächsten Aufruf von
			jmp	BackToCurTask		;":MainLoop" wird Menü gestartet.

;*** Dateiname für ScreenShot-Datei definieren.
:DefNameScrShot		ldy	#$07			;Dateiname für ScreenShot-Datei
			lda	hour			;definieren.
			jsr	HEXtoASCII
			lda	minutes
			jsr	HEXtoASCII
			lda	seconds
			jsr	HEXtoASCII

			ldx	#$0f			;Dateiname in Zwischenspeicher
::51			lda	ScrnShotName,x		;kopieren. Damit bleibt der Ori-
			sta	GP_FileName ,x		;ginal-Dateiname für den nächsten
			dex				;Aufruf unverändert.
			bpl	:51
			rts

;*** DEZIMAL nach ASCII wandeln.
:HEXtoASCII		ldx	#$30
::101			cmp	#10
			bcc	:102
			inx
			sbc	#10
			bcs	:101
::102			adc	#$30
			pha
			txa
			sta	ScrnShotName,y
			iny
			pla
			sta	ScrnShotName,y
			iny
			iny
			rts

;*** Ziel-Laufwerk wechseln.
:SelectDriveA		ldx	#$08
			b $2c
:SelectDriveB		ldx	#$09
			b $2c
:SelectDriveC		ldx	#$0a
			b $2c
:SelectDriveD		ldx	#$0b
			lda	driveType -8,x		;Laufwerk verfügbar ?
			beq	:51			; => Nein, Abbruch...
			txa
			sta	SelectedDrive
			jmp	SetDevice		;Laufwerk aktivieren.
::51			rts

;*** Ziel-Laufwerk ausgeben.
:PrintTargetDrive	lda	SelectedDrive		;Laufwerks-Adr. kopieren.
			clc
			adc	#$39
			sta	Text_TDrive2

			jsr	OpenDisk		;Diskette öffnen.
			txa				;Diskettenfehler ?
			beq	:51			; => Nein, weiter...

			LoadW	r0,Text_TDrive5		;"Keine Diskette".
			jmp	:52			; => Weiter...

::51			ldx	#r0L			;Zeiger auf Diskettenname berechnen.
			jsr	GetPtrCurDkNm

::52			ldy	#$00			;Diskettenanem kopieren.
::53			lda	(r0L),y			;(GEOS-ASCII beachten, nur Zeichen
			beq	:54			; von $20-$7F zulassen!)
			cmp	#$a0
			beq	:55
::54			cmp	#$80
			bcc	:56
			sec
			sbc	#$20
			jmp	:54

::55			lda	#$20
::56			sta	Text_TDrive3,y
			iny
			cpy	#$10
			bcc	:53

			LoadW	r5,curDirHead		;Freien Speicher berechnen.
			jsr	CalcBlksFree

			lsr	r4H			;Blocks in KBytes umrechnen.
			ror	r4L
			lsr	r4H
			ror	r4L
			PushW	r4

			LoadW	r0,Text_TDrive1
			jsr	PutString
			PopW	r0
			lda	#%11000000
			jsr	PutDecimal

			LoadW	r0,Text_TDrive4
			jmp	PutString

;*** Bildschirm des aktuellen Tasks einlesen.
;    Wird innerhalb der ScreenShot-Routine benötigt um den korrekten
;    Bildschirm-Inhalt herzustellen.
:GetCurTaskScrn		php
			sei

if Flag64_128 = TRUE_C64
			ldx	CPU_DATA		;Rahmenfarbe zurücksetzen.
			lda	#$35
			sta	CPU_DATA
			lda	SaveD000 +$20
			sta	$d020
			stx	CPU_DATA
endif

if Flag64_128 = TRUE_C128
			bit	graphMode
			bpl	VIC40
:oldVDCMode		lda	#0
			cmp	#3			;Farbauflösung höher als 8x8 Pixel?
			bcc	:ok			;>nein

			ldx	#< VDCColBox		;>ja
			ldy	#> VDCColBox
			jsr	DoSysDlgBox		;Fehlermeldung ausgeben
			jsr	LoadVDC			;VDC Inhalt wiederherstellen

			lda	scr80colors		;Bildschirmfarbe setzen
			jsr	i_UserColor
			b	0,0,80,25
			plp
			rts

::ok			jsr	LoadVDC			;VDC Inhalt wiederherstellen
			plp
			rts
:VIC40
endif

			MoveB	CurTaskBank,r3L		;Bank-Adresse setzen.

			lda	#< COLOR_MATRIX		;Bildschirm-Farben einlesen.
			ldx	#> COLOR_MATRIX
			sta	r0L
			stx	r0H
			sta	r1L
			stx	r1H
			LoadW	r2,40*25
			jsr	FetchRAM

			lda	#< SCREEN_BASE		;Bildschirm-Grafik einlesen.
			ldx	#> SCREEN_BASE
			sta	r0L
			stx	r0H
			sta	r1L
			stx	r1H
			LoadW	r2,40*25*8
			jsr	FetchRAM

			plp
			rts

;*** ScreenShot erzeugen.
:ScreenShot		jsr	GetCurTaskScrn		;Programm-Bildschirm einlesen.

			jsr	CreateGP_File		;GeoPaint-Datei erstellen.
			txa				;Diskettenfehler ?
			bne	:51			; => Ja, Abbruch...

			LoadW	r0,GP_FileName
			jsr	OpenRecordFile		;GeoPaint-Datei öffnen.
			jsr	WriteGP_File		;ScreenShot erstellen.
			jsr	UpdateRecordFile	;VLIR-Datei aktualisieren und
			jsr	CloseRecordFile		;schließen.
::51			jmp	ReDrawTaskMenu		;Zurück zum Hauptmenü.

;*** GeoPaint-Dokument erstellen.
:CreateGP_File		lda	SelectedDrive
			jsr	SetDevice
			jsr	OpenDisk		;Diskette öffnen.
			txa				;Diskettenfehler ?
			bne	:52			; => Ja, Abbruch...

			LoadW	r0,GP_FileName		;Vorhandene Datei löschen.
			jsr	DeleteFile

			LoadW	r9  ,HdrGP_Dok
			LoadB	r10L,$00
			jsr	SaveFile		;Leeres Dokument speichern.
			txa				;Diskettenfehler ?
			bne	:52			; => Ja, Abbruch...

			LoadW	r0,GP_FileName
			jsr	OpenRecordFile		;Neues Dokument öffnen.
			txa				;Diskettenfehler ?
			bne	:52			; => Ja, Abbruch...

			lda	#0
::51			pha
			jsr	AppendRecord		;Datensatz einfügen.
			pla
			cpx	#$00 			;Diskettenfehler ?
			bne	:52			; => Ja, Abbruch...
			clc
			adc	#$01
			cmp	#45			;45 Datensätze = 90 Cards Bildgröße.
			bcc	:51

			jsr	UpdateRecordFile	;VLIR-Datei aktualisieren und
			jmp	CloseRecordFile		;schließen.
::52			rts

;*** Bildschirm-Daten in GeoPaint-Datei kopieren.
:WriteGP_File		LoadW	a0,SCREEN_BASE		;Startadresse Grafikdaten.
			LoadW	a2,COLOR_MATRIX		;Startadresse Farbdaten.

if Flag64_128 = TRUE_C128
			lda	graphMode
			bpl	:40
			LoadW	a0,$0000		;Startadresse Grafikdaten im VDC
			LoadW	a2,$4000		;Startadresse Farbdaten im VDC
::40
endif

			lda	#$00			;Zeiger auf ersten Datensatz.
			jsr	PointRecord

			lda	#00			;Zeiger auf ersten VLIR-Datensatz.
::51			sta	r12H

			jsr	CopyScrnData2Buf	;Bildschirmdaten einlesen.
							;(2*640 Grafik, 2*80 Farbe).
			jsr	PackScreenData		;Bildschirmdaten packen.

			LoadW	r7,ScrShot_Data2	;Zeiger auf Zwischenspeicher.
			jsr	WriteRecord		;Datensatz auf Diskette schreiben.
			jsr	NextRecord		;Zeiger auf nächsten Datensatz.

			inc	r12H			;Zähler korrigieren.
			CmpBI	r12H,13			;Alle Daten kopiert ?
			bcc	:51			; => Nein, weiter...

			rts

;*** Bildschirm-Daten in Zwischenspeicher kopieren.
;    Die Daten werden aus dem Bildschirmspeicher zuerst ungepackt in den
;    Zwischenspeicher kopiert:
;    320 Byte (Grafik-Zeile #1) + 320 Leerbytes
;  + 320 Byte (Grafik-Zeile #2) + 320 Leerbytes
;  +   8 Byte (reserviert)
;  +  40 Byte (Farben-Zeile #1) +  40 Leerbytes
;  +  40 Byte (Farben-Zeile #2) +  40 Leerbytes
:CopyScrnData2Buf	jsr	i_FillRam		;Zwischenspeicher für Grafikdaten
			w	1288			;löschen (incl. 8 Füllbytes).
			w	ScrShot_Data1 +   0
			b	$00

			jsr	i_FillRam		;Zwischenspeicher für Farbdaten
			w	160			;mit Vorgabewert füllen.
			w	ScrShot_Data1 +1288
			b	$bf

			LoadW	a1,ScrShot_Data1 +   0
			LoadW	a3,ScrShot_Data1 +1288

			CmpBI	r12H,12			;Letzte Doppelzeile schreiben ?
			beq	:51			; => Ja, nur eine Zeile kopieren.

			jsr	GetGrfxData		;Grafikdaten in Zwischenspeicher.
			jsr	GetColsData		;Farbdaten   in Zwischenspeicher.

::51			jsr	GetGrfxData		;Grafikdaten in Zwischenspeicher.
			jmp	GetColsData		;Farbdaten   in Zwischenspeicher.

;*** Bildschirmdaten packen.
;    a0  = Zeiger auf Zwischenspeicher für Grafikdaten.
;    a1  = Zeiger auf VLIR-Speicher    für Grafikdaten.
;    a2  = Zeiger auf Zwischenspeicher für Farbdaten.
;    a3  = Zeiger auf VLIR-Speicher    für Farbdaten.
;    a6  = Anzahl der noch zu bearbeitenden Bytes.
;    a7  = Zwischenspeicher.
;    a8H = Anzahl ungepackter Bytes.
;    a9H = Anzahl gleicher 8-Byte-Blocks.
:PackScreenData		LoadW	r0,ScrShot_Data1	;Zeiger auf Bildschirmdaten.
			LoadW	r1,ScrShot_Data2	;Zeiger auf VLIR-Speicher.

			LoadW	a6,80*2*8 + 8 + 80*2

			lda	#$00
			sta	a9L
			sta	a9H

;*** Bytes aus Zwischenspeicher einlesen, packen und in Speicher für
;    GeoPaint-Datensatz kopieren.
:ContinuePackData	jsr	GetEqualBytes		;Nach gleichen Bytes suchen.
			cmp	#$08			;Mehr als 8 gleiche Bytes ?
			bcs	:51			; => Ja, weiter...

			jsr	GetEqualBlocks		;Gleichen 8-Byte-Blöcke suchen.
			cmp	#$02			;Mehr als 1 gleicher Block ?
			bcc	:51			; => Nein, weiter...

			jsr	Multi8BytePack		;8-Byte-Blöcke packen.
			jmp	:53

;*** Aufeinanderfolgende, gleiche Einzelbytes packen.
::51			lda	a9L			;Anzahl zu packender Bytes.
			cmp	#$04			;Mehr als vier Bytes ?
							;(Weniger ist nicht effektiv)
			bcc	:52			; => Nein, Daten nicht packen.

			jsr	SingleBytePack		;$8x=Einzelbyte (max. 127x) packen.
			jmp	:53			;Weiter mit den nächsten Daten.

::52			jsr	NoCompression		;Daten ungepackt kopieren.

;*** Prüfen ob alle Daten gepackt ?
::53			lda	a6L
			ora	a6H			;Alle Bytes gepackt ?
			bne	ContinuePackData	; => Nein, weiter...

			lda	#$00			;Abschlußbyte.
			tay
			sta	(r1L),y
			inc	r1L
			bne	:54
			inc	r1H

::54			lda	r1L			;Anzahl Bytes berechnen.
			sec
			sbc	#< ScrShot_Data2
			sta	r2L
			lda	r1H
			sbc	#> ScrShot_Data2
			sta	r2H
			rts

;*** Gleiche 8-Byte Blöcke suchen.
:GetEqualBlocks		lda	a9H			;Sind noch gleiche 8-Byte-Blöcke
			bne	:51			;im Speicher ? Nein, Daten noch
							;nicht komplett gepackt, nächsten
							;8-Byte-Block packen.

			lda	a6L			;Anzahl noch zu packender Bytes
			sta	a8L			;einlesen und durch 8 teilen.
			lda	a6H			;Dadurch noch verbleibende 8-Byte-
			lsr				;blöcke berechnen.
			ror	a8L
			lsr
			ror	a8L
			lsr
			ror	a8L
			lda	a8L
			cmp	#$02			;Mehr als 2x 8-Byte-Block übrig ?
			bcs	:52			; => Ja, weiter...
			lda	#$00			;Packen nicht effektiv, da zu
::51			rts				;wenig Bytes zum packen übrig.

::52			cmp	#$3f +1			;Mehr als 63x 8-Byte-Block übrig ?
			bcc	:53			; => Weniger als 63, weiter...
			lda	#$3f			;Max.-Wert 63 für 8-Byte-Blöcke
			sta	a8L			;in einen Packdurchgang setzen.

::53			lda	r0L			;Zeiger auf den folgenden 8-Byte-
			clc				;Block berechnen.
			adc	#$08
			sta	a7L
			lda	r0H
			adc	#$00
			sta	a7H

			ldx	#$01			;Zähler für gleiche Blöcke.
::54			ldy	#$07
::55			lda	(r0L),y			;Bytes in nächstem 8-Byte-Block
			cmp	(a7L),y			;gleich wie aktueller 8-Byte-Block ?
			bne	:56			; => 8-Byte-Block nicht gleich.
			dey
			bpl	:55			; => Ja, weitertesten.

			AddVBW	8,a7			;Zeiger auf nächsten 8-Byte-Block.

			inx				;Max. Wert für gleiche Blöcke
			cpx	a8L			;erreicht (max. $3f) ?
			bcc	:54			; => Nein, weiter...

::56			txa				;Anzahl gleicher 8-Byte-Blocks
			sta	a9H			;zwischenspeichern.
			rts

;*** Gleiche, aufeinanderfolgende Einzelbytes suchen.
:GetEqualBytes		lda	a9L			;Sind noch gleiche Einzelbytes
			bne	:54			;im Speicher ? Nein, Daten noch
							;nicht komplett gepackt, nächste
							;Einzelbytes packen.

			ldy	#$00			;Zeiger auf aktuelles Byte.
			lda	(r0L),y			;Aktuelles Byte einlesen.
			iny				;Zeiger auf nächstes Byte.
::51			cmp	(r0L),y			;Byte identisch mit aktuellem Byte ?
			bne	:52			; => Nein, weiter...
			iny				;Zähler für gleiche Byte erhöhen.
			cpy	#$7f			;Max. 127 gleiche Bytes erreicht ?
			bcc	:51			; => Nein, weiter...

::52			lda	a6H			;Anzahl gleiche Bytes mit Anzahl
			bne	:53			;der noch zu packenden Bytes
			cpy	a6L			;vergleichen.
			bcc	:53
			beq	:53
			ldy	a6L			;Anzahl Bytes auf Restbytes setzen.
::53			tya				;Anzahl gleicher Einzelbytes
			sta	a9L			;zwischenspeichern.
::54			rts

;*** Gleiche 8-Byte-Blöcke packen.
:Multi8BytePack		lda	a9H			;Anzahl 8-Byte-Blocks einlesen.
			ora	#$40			;Kompressions-Flag setzen.

			ldy	#$00			;Zeiger auf VLIR-Speicher.
			sta	(r1L),y			;Kompressionsbyte setzen.
			inc	r1L
			bne	:51
			inc	r1H

::51			ldy	#$07			;8-Byte-Block in VLIR-Speicher
			jsr	CopyBytes_yReg		;übertragen.

			lda	a9H			;Anzahl 8-Byte-Blocks einlesen und
			sta	a7L			;in Einzelbytes umrechnen.
			lda	#$00
			asl	a7L
			rol
			asl	a7L
			rol
			asl	a7L
			rol
			sta	a7H

			lda	a7L			;Zeiger auf Grafikdaten um Anzahl
			clc				;gepackter 8-Byte-Blocks erhöhen.
			adc	r0L
			sta	r0L
			lda	a7H
			adc	r0H
			sta	r0H

			AddVBW	8,r1			;Zeiger für VLIR-Speicher auf
							;nächstes Byte setzen.
			lda	a6L			;Anzahl noch zu packender Bytes
			sec				;korrigieren.
			sbc	a7L			;(In :a7 steht die Anzahl der
			sta	a6L			; gepackten 8-Byte-Blöcke, umge-
			lda	a6H			; rechnet in Einzelbytes)
			sbc	a7H
			sta	a6H
			jmp	ClrByteFlags		;8-Byte/Einzelbyte-Flag löschen.

;*** Gleiche Einzelbytes packen.
:SingleBytePack		lda	a9L			;Anzahl Einzelbytes einlesen.
			ora	#$80			;Kompressions-Flag setzen.

			ldy	#$00			;Zeiger auf VLIR-Speicher.
			sta	(r1L),y			;Kompressionsbyte setzen.
			lda	(r0L),y			;Zu packendes Byte einlesen.
			iny				;Zeiger auf VLIR-Speicher setzen.
			sta	(r1L),y			;Packbyte in VLIR-Speicher kopieren.

			AddVBW	2,r1			;Zeiger für VLIR-Speicher auf
							;nächstes Byte setzen.
			lda	a9L			;Zeiger auf Grafikdaten um Anzahl
			clc				;gepackter Einzelbytes erhöhen.
			adc	r0L
			sta	r0L
			bcc	:51
			inc	r0H

::51			lda	a6L			;Anzahl noch zu packender Bytes
			sec				;korrigieren.
			sbc	a9L			;(In :a9L steht die Anzahl der
			sta	a6L			; gepackten Einzelbytes)
			bcs	ClrByteFlags
			dec	a6H

;*** Flags für 8-Byte-Blöcke/Einzelbytes löschen.
:ClrByteFlags		lda	#$00
			sta	a9L
			sta	a9H
			rts

;*** Daten ungepackt in VLIR-Speicher kopieren.
:NoCompression		jsr	CountBytes		;Ungepackte Bytes zählen.

			lda	a8H			;Anzahl ungepackter Bytes.
			ldy	#$00			;Zeiger auf VLIR-Speicher.
			sta	(r1L),y			;Kompressionsbyte setzen.
			inc	r1L
			bne	:51
			inc	r1H

::51			ldy	a8H			;Anzahl ungepackter Bytes in
			dey				;VLIR-Speicher kopieren.
			jsr	CopyBytes_yReg

			lda	a8H			;Zeiger auf Grafikdaten um Anzahl
			clc				;ungepackter Bytes erhöhen.
			adc	r0L
			sta	r0L
			bcc	:52
			inc	r0H

::52			lda	a8H			;Zeiger für VLIR-Speicher auf
			clc				;nächstes Byte setzen.
			adc	r1L
			sta	r1L
			bcc	:53
			inc	r1H

::53			lda	a6L			;Anzahl noch zu packender Bytes
			sec				;korrigieren.
			sbc	a8H			;(In :a8H steht die Anzahl der
			sta	a6L			; ungepackten Einzelbytes)
			bcs	:54
			dec	a6H
::54			rts

;*** Anzahl ungepackter Daten berechnen.
:CountBytes		lda	#$01			;Max. Anzahl ungepackter Bytes auf
			sta	a8H			;Startwert setzen.

			PushW	r0			;Zeiger auf Grafikdaten retten.
			PushW	a6			;Anzahl zu packender Bytes retten.

			jsr	Pos2NextByte		;Zeiger auf nächstes Byte setzen.

::51			lda	a6L			;Weitere Bytes in Grafikspeicher
			ora	a6H			;zum packen vorhanden ?
			beq	:52			; => Nein, Ende...

			jsr	ClrByteFlags		;8-Byte/Einzelbyte-Flags löschen.
			jsr	GetEqualBytes		;Gleiche Einzelbytes suchen.
			cmp	#$04			;Mehr als vier gleiche Bytes ?
			bcs	:52			; => Ja, Abbruch. Ab hier ist das
							;packen über Anzahl gleicher Bytes
							;wieder effektiver !!!
			jsr	GetEqualBlocks		;Nach gleichen 8-Byte-Blocks suchen.
			cmp	#$02			;Mehr als zwei 8-Byte-Blocks ?
			bcs	:52			; => Ja, Abbruch. Ab hier ist das
							;packen über Anzahl gleicher 8-Byte-
							;Blocks wieder effektiver !!!
			jsr	Pos2NextByte		;Zeiger auf nächstes Byte.

			inc	a8H			;Anzahl ungepackter Bytes +1.
			CmpBI	a8H,$3f			;Max. $3f Bytes gefunden ?
			bcc	:51			;Nein weiter...

			jsr	ClrByteFlags		;8-Byte/Einzelbyte-Flags löschen.
::52			PopW	a6			;Anzahl noch zu packender Bytes
			PopW	r0			;und Zeiger auf Grafikdaten wieder
			rts				;zurücksetzen.

;*** Zeiger auf nächstes Byte in Grafikspeicher setzen.
;    Aufruf über ":CountBytes" zum ermitteln der ungepackten Bytes.
:Pos2NextByte		inc	r0L			;Zeiger auf nächstes Byte der
			bne	:51			;Grafikdaten setzen.
			inc	r0H
::51			lda	a6L			;Aznahl noch zu packender Bytes
			bne	:52			;korrigieren.
			dec	a6H
::52			dec	a6L
			rts

;*** Anzahl Bytes aus Grafikspeicher in VLIR-Speicher kopieren.
;    Übergabe:		yReg = Anzahl Bytes -1, max. 128 Bytes!
:CopyBytes_yReg		lda	(r0L),y			;Byte einlesen und in
			sta	(r1L),y			;VLIR-Speicher kopieren.
			dey				;Alle Bytes kopiert ?
			bpl	CopyBytes_yReg		; => Nein, weiter...
			rts

;******************************************************************************
;*** Grafikdaten einlesen.
;******************************************************************************
if Flag64_128 = TRUE_C64
:GetGrfxData		MoveW	a0 ,r0			;320 Grafikbytes kopieren.
			MoveW	a1 ,r1
			LoadW	r2 ,320
			AddVW	320,a0			;Zeiger auf nächste Grafikzeile.
			AddVW	640,a1			;Zeiger auf Speicher korrigieren.
			jmp	MoveData

;*** Farbdaten einlesen.
:GetColsData		MoveW	a2 ,r0			; 80 Farbbytes kopieren.
			MoveW	a3 ,r1
			LoadW	r2 ,40
			AddVBW	40 ,a2			;Zeiger auf nächste Farbzeile.
			AddVBW	80 ,a3			;Zeiger auf Speicher korrigieren.
			jmp	MoveData
endif

;*** Grafikdaten einlesen.
if Flag64_128 = TRUE_C128
:GetGrfxData		lda	graphMode
			bpl	GetGrfxData40

:GetGrfxData80		MoveW	a1 ,r1
			lda	#8
			sta	r2H
			lda	a0H
			ldx	#18
			jsr	SetVDC
			lda	a0L
			inx
			jsr	SetVDC
			ldx	#31
			ldy	#0
::3			lda	#80
			sta	r2L
			PushW	r1
::1			jsr	GetVDC
			sta	(r1),y
			AddVW	8,r1
			dec	r2L
			bne	:1
			PopW	r1
			inc	r1L
			bne	:2
			inc	r1H
::2			dec	r2H
			bne	:3

			AddVW	640,a1			;Zeiger auf Speicher korr.
			AddVW	640,a0			;Zeiger auf Speicher korr.
			rts

:GetGrfxData40		MoveW	a0 ,r0
			MoveW	a1 ,r1
			LoadW	r2 ,320			;320 Grafikbytes kopieren.
			AddVW	320,a0			;Zeiger auf nächste Grafikzeile
			AddVW	640,a1			;Zeiger auf Speicher korr.
			jmp	MoveData
endif

;******************************************************************************
;*** Farbdaten einlesen.
;******************************************************************************
if Flag64_128 = TRUE_C128
:GetColsData		lda	graphMode
			bpl	GetColsData40		;> 40 Zeichen

:GetColsData80		MoveW	a3,r1
			lda	a2H
			ldx	#18
			jsr	SetVDC
			lda	a2L
			inx
			jsr	SetVDC
			ldy	#0
::2			ldx	#31
			jsr	GetVDC
			pha
			and	#%00001111
			tax
			lda	VICFarbe,x
			sta	(r1),y
			pla
			lsr
			lsr
			lsr
			lsr
			tax
			lda	VICFarbe,x
			asl
			asl
			asl
			asl
			ora	(r1),y
			sta	(r1),y
			iny
			cpy	#80
			bne	:2
			ldy	vdcClrMode
			dey
			dey
			dey
			bmi	:3
			AddVW	80,a2			;Zeiger auf Speicher korr.
			dey
			bmi	:3
			AddVW	80,a2			;Zeiger auf Speicher korr.
::3			AddVW	80,a2			;Zeiger auf Speicher korr.
			AddVW	80,a3			;Zeiger auf Speicher korr.
			rts

;*** Farbdaten einlesen.
:GetColsData40		MoveW	a2 ,r0			; 80 Farbbytes kopieren.
			MoveW	a3 ,r1
			LoadW	r2 ,40
			AddVBW	40 ,a2			;Zeiger auf nächste Farbzeile.
			AddVBW	80 ,a3			;Zeiger auf Speicher korrigieren.
			jmp	MoveData

:VICFarbe		b	0			;schwarz (0)
			b	11			;grau 1 dunkelgrau (1)
			b	6			;blau (2)
			b	14			;hellblau (3)
			b	5			;grün (4)
			b	13			;hellgrün (5)
			b	12			;grau 2 mittelgrau (6)
			b	3			;türkis (7)
			b	2			;rot (8)
			b	10			;hellrot (9)
			b	8			;orange (10)
			b	4			;violett (11)
			b	9			;braun (12)
			b	7			;gelb (13)
			b	15			;grau 3 hellgrau (14)
			b	1			;weiß (15)
endif

;******************************************************************************
;*** Externe Routine:
;*** Um ein DA zu starten muß zuvor der komplette Speicher zurückgesetzt
;*** werden. Dies kann nicht direkt vom TaskMan aus erfolgen, da dieser
;*** sich sonst selbst überschreiben würde. Deshalb wird diese Routine
;*** nach $8300 = ":fileTrScTab" kopiert und ausgeführt.
;******************************************************************************

;*** Hilfsmittel starten.
:InstDA			s 17				;Speicher für Dateiname des Hilfsmittels.

:InitLoadDA		pla				;Rücksprung in TaskManager-Init-
			pla				;Routine im Kernel löschen.
			lda	#> TaskMan_Quit_DA -1
			pha
			lda	#< TaskMan_Quit_DA -1
			pha				;Speicher im Bereich des
			jsr	SwapRAM			;TaskManagers zurücksetzen.

			jsr	GEOS_InitSystem		;GEOS-Variablen zurücksetzen.
			jsr	UseSystemFont		;Standardzeichensatz.

			lda	#$00
			sta	r0L
			sta	r2L
			sta	r2H
			sta	r3L
			sta	r3H
			sta	r10L
			LoadW	r6,fileTrScTab
			jmp	GetFile			;Hilfsmittel laden/starten.

;******************************************************************************

;******************************************************************************
;*** 80 Zeichen Bildschirm sichern/wiederherstellen:
;*** Hierzu wird eine Bank des TaskManager benötigt
;******************************************************************************
;*** Sicherungsinhalt innerhalb des VDC von $6000 - $bfff bei geöffneter
;    Dialogbox in REU sichern/wiederh.

if Flag64_128 = TRUE_C128
:LoadDlgVDC		lda	#1
			b	$2c
:SaveDlgVDC		lda	#0
			sta	SvLdFlag+1
			LoadW	r5,$6000		;Startadresse VDC und REU
			jmp	SaveLoadVDC

;*** Bildinhalt innerhalb des VDC von $0000 - $5fff in REU
;    sichern/wiederherstellen
:LoadVDC		lda	#1
			b	$2c
:SaveVDC		lda	#0
			sta	SvLdFlag+1
			LoadW	r5,$0000		;Startadresse VDC und REU

:SaveLoadVDC		php
			sei
			PushB	MMU
			LoadB	MMU,$7e
			jsr	TempHideMouse

			ldx	#18			;Startadresse VDC setzen
			lda	r5H
			jsr	SetVDC
			lda	r5L
			inx
			jsr	SetVDC

			jsr	SwapVDC1
			jsr	SvLdVDC
			jsr	SwapVDC1
			jsr	SwapVDC2
			jsr	SvLdVDC
			jsr	SwapVDC2
			PopB	MMU
			plp
			rts

:SvLdVDC		ldy	#0
			ldx	#31			;Data-Register
:SvLdFlag		lda	#$00
			bne	:load

::save			jsr	GetVDC			;Byte von VDC holen
			sta	(r0),y			;und speichern
			inc	r0L			;Zeiger auf Ablagespeicher erhöhen
			bne	:save
			inc	r0H
			lda	r0H
			cmp	#$40			;alle Bytes gesichert?
			bne	:save			;>nein dann weiter...
			rts

::load			lda	(r0),y
			jsr	SetVDC
			inc	r0L			;Zeiger auf Ablagespeicher erhöhen
			bne	:load
			inc	r0H
			lda	r0H
			cmp	#$40			;alle Bytes geladen?
			bne	:load			;>nein dann weiter...
			rts

:SwapVDC1		MoveW	r5,r1			;r1 = r5
			jmp	SwapVDC			;Erster Teil des Screen sichern

:SwapVDC2		lda	r5L			;r1 = r5 + $3000
			sta	r1L			;Zweiter Teil des Screen sichern
			lda	r5H
			clc
			adc	#$30
			sta	r1H

:SwapVDC		LoadW	r0,$1000		;Startbereich im Rechner
			LoadW	r2,$3000		;Anzahl zu verschiebender Bytes
			ldy	CurTaskBankVDC		;aktuelle Bank in REU
			sty	r3L
			jmp	SwapRAM			; Tauschen
endif

;*** Variablen zum starten einer Anwendung/eines Dokuments.
:SelectedDrive		b $08				;Laufwerk für "NEUER TASK" / "DRUCKER"
:FileClass		s 17				;Datei-Klasse.
:TypeOfFiles		b $00				;Datei-Typ.
:NameOfFile		s 17				;Datei-Name.
:NameOfAppl		s 17				;Applikations-Name.
:NameOfDokDisk		s 17				;Name der Dokumenten-Diskette.
:NameOfClass		s 13				;Klasse der Applikation.
:WriteClass		b "Write Image ",NULL
:PaintClass		b "Paint Image ",NULL

;*** Infotexte.
:MenuText00		b PLAINTEXT
			b GOTOXY
			w $0008 ! DOUBLE_W
			b $06
			b "TaskManager",NULL

;*** Daten für Dateiauswahlbox.
:Dlg_SlctFile		b %10000001
			b DBGETFILES!DBSETDRVICON ,$03,$03
			b OPEN                    ,$11,$08
			b DISK                    ,$11,$38
			b CANCEL                  ,$11,$4c
			b NULL

;*** Header für ScreenShot-Datei.
:HdrGP_Dok		w GP_FileName
			b $03,$15
			j
<MISSING_IMAGE_DATA>
:HdrGP_068		b $83
:HdrGP_069		b APPL_DATA
:HdrGP_070		b VLIR
:HdrGP_071		w $0000,$ffff,$0000
:HdrGP_077		b "Paint Image V"		;Klasse.
:HdrGP_090		b "1.1"				;Version.
:HdrGP_093		b $00,$00,$00,$00		;Reserviert.
:HdrGP_097		b "MegaPatch"			;Autor.
:HdrGP_106		s 11				;Reserviert.
:HdrGP_117		b "geoPaint    V"		;Application.
:HdrGP_130		b "2.0",$00			;Version.
:HdrGP_134		b $01				;Flag für "Farbe an".
:HdrGP_135		s 25				;Reserviert.
:HdrGP_160		b NULL

:GP_FileName		s 17

;*** Vorgabe für ScreenShot-Dateiname.
:ScrnShotName		b "SCREEN 00:00.00",NULL

;*** Dialogbox: Konfiguration wurde geändert.
:Dlg_ConfigError	b %01100001
			b $30,$97
			w $0040 ! DOUBLE_W,$00ff ! DOUBLE_W ! ADD1_W

			b DB_USR_ROUT
			w Dlg_DrawTitel
			b DBTXTSTR   ,$0c,$0b
			w :51
			b DBTXTSTR   ,$0c,$20
			w :52
			b DBTXTSTR   ,$0c,$2a
			w :53
			b DBTXTSTR   ,$0c,$34
			w :54
			b DBTXTSTR   ,$0c,$3e
			w :55
			b OK         ,$01,$50
			b NULL

if Sprache = Deutsch
::51			b PLAINTEXT,BOLDON
			b "Fehlermeldung!",NULL
::52			b "Die Laufwerks - Konfiguration",NULL
::53			b "wurde geändert! Bitte vor dem",NULL
::54			b "wechseln der Applikation die",NULL
::55			b "Konfiguration zurücksetzen!",NULL
endif

if Sprache = Englisch
::51			b PLAINTEXT,BOLDON
			b "Systemerror!",NULL
::52			b "Drive-configuration has been",NULL
::53			b "changed! Please set back the",NULL
::54			b "current configuration before",NULL
::55			b "you change the application!",NULL
endif

;*** Titelzeile in Dialogbox löschen.
:Dlg_DrawTitel		lda	#$00
			jsr	SetPattern
			jsr	i_Rectangle
			b	$30,$3f
			w	$0040 ! DOUBLE_W,$00ff ! DOUBLE_W ! ADD1_W
			lda	C_DBoxTitel
			jsr	DirectColor
			jmp	UseSystemFont

if Flag64_128 = TRUE_C128
:VDCColBox		b %01100001
			b $30,$97
			w $0040 ! DOUBLE_W,$00ff ! DOUBLE_W ! ADD1_W

			b DB_USR_ROUT
			w Dlg_DrawTitel
			b DBTXTSTR   ,$0c,$0b
			w :51
			b DBTXTSTR   ,$0c,$20
			w :52
			b DBTXTSTR   ,$0c,$2a
			w :53
			b DBTXTSTR   ,$0c,$34
			w :54
			b OK         ,$01,$50
			b NULL
endif

if Sprache ! Flag64_128 = Deutsch ! TRUE_C128
::51			b PLAINTEXT,BOLDON
			b "Achtung!",NULL
::52			b "Die Farbauflösung des zu sichernden",NULL
::53			b "Bildschirminhalts ist höher als 8*8 Pixel.",NULL
::54			b "Der Screenshot wird ohne Farbe erstellt.",NULL
endif

if Sprache ! Flag64_128 = Englisch ! TRUE_C128
::51			b PLAINTEXT,BOLDON
			b "Attention!",NULL
::52			b "The color solution of the screen you",NULL
::53			b "want to save is higher than 8*8 pixel.",NULL
::54			b "The screenshot will be created without colors.",NULL
endif

;*** Icon-Tabelle.
:Icon_Tab		b $02
			w $0000
			b $00

			w Icon_20
			b $00 ! DOUBLE_B,$08,Icon_20x ! DOUBLE_B,Icon_20y
			w BackToCurTask

			w Icon_21
			b $05 ! DOUBLE_B,$08,Icon_21x ! DOUBLE_B,Icon_21y
			w CloseAllTask

;*** Register-Definition.
:RegisterTab		b $30,$bf
			w $0008 ! DOUBLE_W,$0137 ! DOUBLE_W ! ADD1_W

			b 4				;Anzahl Registerkarten.

			w RegName01			;Zeiger auf Name  von Register #1.
			w RegMenu01			;Zeiger auf Daten von Register #1.

			w RegName02			;Zeiger auf Name  von Register #2.
			w RegMenu02			;Zeiger auf Daten von Register #2.

			w RegName03			;Zeiger auf Name  von Register #2.
			w RegMenu03			;Zeiger auf Daten von Register #2.

			w RegName04			;Zeiger auf Name  von Register #2.
			w RegMenu04			;Zeiger auf Daten von Register #2.

:RegName01		w Icon_00
			b RegCardIconX_1 ! DOUBLE_B,$28,Icon_00x ! DOUBLE_B,Icon_00y

:RegName02		w Icon_03
			b RegCardIconX_2 ! DOUBLE_B,$28,Icon_03x ! DOUBLE_B,Icon_03y

:RegName03		w Icon_01
			b RegCardIconX_3 ! DOUBLE_B,$28,Icon_01x ! DOUBLE_B,Icon_01y

:RegName04		w Icon_02
			b RegCardIconX_4 ! DOUBLE_B,$28,Icon_02x ! DOUBLE_B,Icon_02y

;*** Register-Karte: "ANWENDUNGEN".
:RegMenu01		b 5
			b BOX_FRAME			;----------------------------------------
				w RegTText1_1_01
				w InstallKeyCheck
				b $40,$b7
				w $0018 ! DOUBLE_W,$0127 ! DOUBLE_W ! ADD1_W
			b BOX_USEROPT_VIEW		;----------------------------------------
				w $0000
				w PrintAllTEntry
:RegMenu01_01			b $48  ,$48 + (MAX_TASK_ACTIV*8) -1
				w $0020 ! DOUBLE_W,$00e7 ! DOUBLE_W ! ADD1_W
			b BOX_USER			;----------------------------------------
				w RegTText1_1_01
				w SlctNewTask
:RegMenu01_02			b $48  ,$48 + (MAX_TASK_ACTIV*8) -1
				w $0020 ! DOUBLE_W,$00e7 ! DOUBLE_W ! ADD1_W

			b BOX_ICON			;----------------------------------------
				w $0000
				w OpenSlctTask
				b $48
				w $00f0 ! DOUBLE_W
				w RegTIcon1_1_09
				b $00
			b BOX_ICON			;----------------------------------------
				w $0000
				w CloseSlctTask
				b $60
				w $00f0 ! DOUBLE_W
				w RegTIcon1_1_10
				b $02
			b BOX_USEROPT_VIEW		;----------------------------------------
				w $0000
				w DoSignal
:RegMenu01_05			b $98  ,$af
				w $0020 ! DOUBLE_W,$011f ! DOUBLE_W ! ADD1_W

;*** Register-Karte: "NEUER TASK".
:RegMenu02		b 15
			b BOX_FRAME			;----------------------------------------
				w RegTText1_2_01
				w $0000
				b $40,$77
				w $0018 ! DOUBLE_W,$0097 ! DOUBLE_W ! ADD1_W
			b BOX_STRING_VIEW		;----------------------------------------
				w $0000
				w $0000
				b $48
				w $0020 ! DOUBLE_W
				w RegTText1_2_02
				b 14
			b BOX_USER			;----------------------------------------
				w $0000
				w OPEN_Application
				b $48  ,$4f
				w $0020 ! DOUBLE_W,$008f ! DOUBLE_W ! ADD1_W
			b BOX_STRING_VIEW		;----------------------------------------
				w $0000
				w $0000
				b $58
				w $0020 ! DOUBLE_W
				w RegTText1_2_03
				b 14
			b BOX_USER			;----------------------------------------
				w $0000
				w OPEN_AutoExec
				b $58  ,$5f
				w $0020 ! DOUBLE_W,$008f ! DOUBLE_W ! ADD1_W

			b BOX_FRAME			;----------------------------------------
				w RegTText1_2_04
				w $0000
				b $40,$77
				w $00a8 ! DOUBLE_W,$0127 ! DOUBLE_W ! ADD1_W
			b BOX_STRING_VIEW		;----------------------------------------
				w $0000
				w $0000
				b $48
				w $00b0 ! DOUBLE_W
				w RegTText1_2_05
				b 14
			b BOX_USER			;----------------------------------------
				w $0000
				w OPEN_Document
				b $48  ,$4f
				w $00b0 ! DOUBLE_W,$011f ! DOUBLE_W ! ADD1_W
			b BOX_STRING_VIEW		;----------------------------------------
				w $0000
				w $0000
				b $58
				w $00b0 ! DOUBLE_W
				w RegTText1_2_06
				b 14
			b BOX_USER			;----------------------------------------
				w $0000
				w OPEN_WriteImage
				b $58  ,$5f
				w $00b0 ! DOUBLE_W,$011f ! DOUBLE_W ! ADD1_W
			b BOX_STRING_VIEW		;----------------------------------------
				w $0000
				w $0000
				b $68
				w $00b0 ! DOUBLE_W
				w RegTText1_2_07
				b 14
			b BOX_USER			;----------------------------------------
				w $0000
				w OPEN_PaintImage
				b $68  ,$6f
				w $00b0 ! DOUBLE_W,$011f ! DOUBLE_W ! ADD1_W

			b BOX_FRAME			;----------------------------------------
				w RegTText1_2_08
				w $0000
				b $88,$af
				w $0018 ! DOUBLE_W,$0127 ! DOUBLE_W ! ADD1_W
			b BOX_STRING_VIEW		;----------------------------------------
				w RegTText1_2_09
				w $0000
				b $a0
				w $0020 ! DOUBLE_W
				w RegTText1_2_10
				b 14
			b BOX_USER			;----------------------------------------
				w $0000
				w OPEN_DeskAcc
				b $a0  ,$a7
				w $0020 ! DOUBLE_W,$008f ! DOUBLE_W ! ADD1_W

;*** Register-Karte: "DRUCKER".
:RegMenu03		b 5
			b BOX_FRAME			;----------------------------------------
				w RegTText1_3_01
				w $0000
				b $40,$6f
				w $0018 ! DOUBLE_W,$0127 ! DOUBLE_W ! ADD1_W
			b BOX_STRING_VIEW		;----------------------------------------
				w RegTText1_3_02
				w $0000
				b $48
				w $0048 ! DOUBLE_W
				w PrntFileName
				b 16
			b BOX_ICON			;----------------------------------------
				w RegTText1_3_03
				w OPEN_Printer
				b $48
				w $00c8 ! DOUBLE_W
				w RegTIcon1_3_01
				b $02
			b BOX_FRAME			;----------------------------------------
				w RegTText1_3_04
				w $0000
				b $80,$af
				w $0018 ! DOUBLE_W,$0127 ! DOUBLE_W ! ADD1_W
			b BOX_ICON			;----------------------------------------
				w RegTText1_3_05
				w OPEN_Spooler
				b $98
				w $00e8 ! DOUBLE_W
				w RegTIcon1_3_02
				b $00

;*** Register-Karte: "BILDSCHIRM".
:RegMenu04		b 9
			b BOX_FRAME			;----------------------------------------
				w RegTText1_4_01
				w DefNameScrShot
				b $40,$6f
				w $0018 ! DOUBLE_W,$0127 ! DOUBLE_W ! ADD1_W
			b BOX_STRING			;----------------------------------------
				w RegTText1_4_02
				w $0000
				b $48
				w $0048 ! DOUBLE_W
				w GP_FileName
				b 16
			b BOX_ICON			;----------------------------------------
				w RegTText1_4_03
				w ScreenShot
				b $58
				w $00e8 ! DOUBLE_W
				w RegTIcon1_4_01
				b $00
			b BOX_FRAME			;----------------------------------------
				w RegTText1_4_04
				w $0000
				b $80,$af
				w $0018 ! DOUBLE_W,$0127 ! DOUBLE_W ! ADD1_W
			b BOX_USEROPT_VIEW		;----------------------------------------
				w RegTText1_4_05
				w PrintTargetDrive
				b $98  ,$a7
				w $0020 ! DOUBLE_W,$00c7 ! DOUBLE_W ! ADD1_W
			b BOX_ICON			;----------------------------------------
				w $0000
				w SelectDriveA
				b $98
				w $00d8 ! DOUBLE_W
				w RegTIcon1_4_03
				b $05
			b BOX_ICON			;----------------------------------------
				w $0000
				w SelectDriveB
				b $98
				w $00e8 ! DOUBLE_W
				w RegTIcon1_4_04
				b $05
			b BOX_ICON			;----------------------------------------
				w $0000
				w SelectDriveC
				b $98
				w $00f8 ! DOUBLE_W
				w RegTIcon1_4_05
				b $05
			b BOX_ICON			;----------------------------------------
				w $0000
				w SelectDriveD
				b $98
				w $0108 ! DOUBLE_W
				w RegTIcon1_4_06
				b $05

;*** Texte für Register-Karte: "ANWENDUNGEN".
if Sprache = Deutsch
:RegTText1_1_01		b "ANWENDUNGEN:",NULL

:RegTText1_1_06		b GOTOXY
			w $0040 ! DOUBLE_W
			b $a1
			b "ACHTUNG! Dialogbox geöffnet!",NULL

:RegTText1_1_07		b GOTOXY
			w $0040 ! DOUBLE_W
			b $a1
			b "ACHTUNG! Hilfsmittel geöffnet!",NULL

:RegTText1_1_08		b GOTOXY
			w $0040 ! DOUBLE_W
			b $a9
;--- Ergänzung: 01.07.18/M.Kanet
;Die Version von 2003 verwendet hier einen anderen Hinweistext.
;			b "Wechsel der Anwendung nicht möglich!"
			b "Es ist nicht möglich den Task zu wechseln!"
			b NULL
endif

if Sprache = Englisch
:RegTText1_1_01		b "APPLICATIONS:",NULL

:RegTText1_1_06		b GOTOXY
			w $0040 ! DOUBLE_W
			b $a1
			b "WARNING! A dialogbox is active!",NULL

:RegTText1_1_07		b GOTOXY
			w $0040 ! DOUBLE_W
			b $a1
			b "WARNING! A DeskAccessory is active!",NULL

:RegTText1_1_08		b GOTOXY
			w $0040 ! DOUBLE_W
			b $a9
			b "It's not possible to swap the task!"
			b NULL
endif

;*** Icons für Register-Karte: "ANWENDUNGEN".
:RegTIcon1_1_10		w Icon_25
			b $10 ! DOUBLE_B,$a0,Icon_25x ! DOUBLE_B,Icon_25y
:COLOR1			b $01
:RegTIcon1_1_09		w Icon_OPEN
			b $17 ! DOUBLE_B,$a0,$06 ! DOUBLE_B,$10
:COLOR2			b $01

;*** Texte für Register-Karte: "NEUER TASK".
if Sprache = Deutsch
:RegTText1_2_01		b "Anwendungen:",NULL
:RegTText1_2_02		b "Anwendungen",NULL
:RegTText1_2_03		b "Autostart",NULL
:RegTText1_2_04		b "Dokumente:",NULL
:RegTText1_2_05		b "Allgemein",NULL
:RegTText1_2_06		b "GeoWrite",NULL
:RegTText1_2_07		b "GeoPaint",NULL
:RegTText1_2_08		b "Hilfsmittel:",NULL
:RegTText1_2_09		w $0020 ! DOUBLE_W
			b $92
			b "Das Hilfsmittel wird innerhalb der"
			b GOTOXY
			w $0020 ! DOUBLE_W
			b $9a
			b "aktiven Applikation geöffnet!",NULL
:RegTText1_2_10		b "Hilfsmittel",NULL
endif

if Sprache = Englisch
:RegTText1_2_01		b "NEW TASK:",NULL
:RegTText1_2_02		b "Applications",NULL
:RegTText1_2_03		b "Autoboot",NULL
:RegTText1_2_04		b "Documents:",NULL
:RegTText1_2_05		b "All files",NULL
:RegTText1_2_06		b "GeoWrite",NULL
:RegTText1_2_07		b "GeoPaint",NULL
:RegTText1_2_08		b "DeskAccessory:",NULL
:RegTText1_2_09		w $0020 ! DOUBLE_W
			b $92
			b "The DeskAccessory will be opened"
			b GOTOXY
			w $0020 ! DOUBLE_W
			b $9a
			b "in the current application!",NULL
:RegTText1_2_10		b "DeskAccessory",NULL
endif

;*** Texte für Register-Karte: "DRUCKER".
if Sprache = Deutsch
:RegTText1_3_01		b "AKTUELLER DRUCKER:",NULL

:RegTText1_3_02		w $0020 ! DOUBLE_W
			b $4e
			b "Name:"
			b NULL

:RegTText1_3_03		w $0020 ! DOUBLE_W
			b $5e
			b "Dieser Druckertreiber wird in allen"
			b GOTOXY
			w $0020 ! DOUBLE_W
			b $66
			b "geöffneten Anwendungen verwendet."
			b NULL

:RegTText1_3_04		b "DRUCKERSPOOLER:",NULL

:RegTText1_3_05		w $0020 ! DOUBLE_W
			b $8e
			b "Drucker-Spooler aktivieren um"
			b GOTOXY
			w $0020 ! DOUBLE_W
			b $96
			b "die gespeicherten Daten an den"
			b GOTOXY
			w $0020 ! DOUBLE_W
			b $9e
			b "Drucker zu senden..."
			b NULL
endif

if Sprache = Englisch
:RegTText1_3_01		b "CURRENT PRINTER:",NULL

:RegTText1_3_02		w $0020 ! DOUBLE_W
			b $4e
			b "Name:"
			b NULL

:RegTText1_3_03		w $0020 ! DOUBLE_W
			b $5e
			b "This printerdriver would be used in"
			b GOTOXY
			w $0020 ! DOUBLE_W
			b $66
			b "all opened applications."
			b NULL

:RegTText1_3_04		b "PRINTSPOOLER:",NULL

:RegTText1_3_05		w $0020 ! DOUBLE_W
			b $8e
			b "Start printspooler to send"
			b GOTOXY
			w $0020 ! DOUBLE_W
			b $96
			b "all saved data to the printer."
			b NULL
endif

;*** Icons für Register-Karte: "DRUCKER".
:RegTIcon1_3_01		w Icon_10
			b $1d ! DOUBLE_B,$48,Icon_10x ! DOUBLE_B,Icon_10y
:COLORa			b $0f
:RegTIcon1_3_02		w Icon_OPEN
			b $1d ! DOUBLE_B,$80,$06 ! DOUBLE_B,$10
:COLOR3			b $01

;*** Texte für Register-Karte: "Bildschirm".
if Sprache = Deutsch
:RegTText1_4_01		b "BILDSCHIRM:",NULL

:RegTText1_4_02		w $0020 ! DOUBLE_W
			b $4e
			b "Name:"
			b NULL

:RegTText1_4_03		w $0020 ! DOUBLE_W
			b $5e
			b "Erzeugt eine Kopie des aktuellen"
			b GOTOXY
			w $0020 ! DOUBLE_W
			b $66
			b "Bildschirms als GeoPaint-Datei."
			b NULL

:RegTText1_4_04		b "ZIEL-LAUFWERK:",NULL

:RegTText1_4_05		w $0020 ! DOUBLE_W
			b $8a
			b "Das GeoPaint-Dokument wird auf dem"
			b GOTOXY
			w $0020 ! DOUBLE_W
			b $92
			b "folgenden Laufwerk gespeichert:"
			b NULL

:Text_TDrive1		b PLAINTEXT
			b GOTOXY
			w $0024 ! DOUBLE_W
			b $9e
:Text_TDrive2		b "x:"
:Text_TDrive3		s 16
			b GOTOXY
			w $0024 ! DOUBLE_W
			b $a6
			b NULL
:Text_TDrive4		b " Kb frei",NULL
:Text_TDrive5		b " (Keine Disk)   "
:Text_NotUsed		b "<Frei>",NULL
endif

if Sprache = Englisch
:RegTText1_4_01		b "SCREEN:",NULL

:RegTText1_4_02		w $0020 ! DOUBLE_W
			b $4e
			b "Name:"
			b NULL

:RegTText1_4_03		w $0020 ! DOUBLE_W
			b $5e
			b "Creates a copy of the current"
			b GOTOXY
			w $0020 ! DOUBLE_W
			b $66
			b "screen as a GeoPaint-file."
			b NULL

:RegTText1_4_04		b "TARGET-DRIVE:",NULL

:RegTText1_4_05		w $0020 ! DOUBLE_W
			b $8a
			b "The GeoPaint-document will be"
			b GOTOXY
			w $0020 ! DOUBLE_W
			b $92
			b "saved to the following drive:"
			b NULL

:Text_TDrive1		b PLAINTEXT
			b GOTOXY
			w $0024 ! DOUBLE_W
			b $9e
:Text_TDrive2		b "x:"
:Text_TDrive3		s 16
			b GOTOXY
			w $0024 ! DOUBLE_W
			b $a6
			b NULL
:Text_TDrive4		b " Kb free",NULL
:Text_TDrive5		b " (No disk)      "
:Text_NotUsed		b "<Free>",NULL
endif

;*** Icons für Register-Karte: "Bildschirm".
:RegTIcon1_4_01		w Icon_OK
			b $1d ! DOUBLE_B,$48,$06 ! DOUBLE_B     ,$10
:COLOR4			b $01
:RegTIcon1_4_03		w Icon_DRIVE_A
			b $1b ! DOUBLE_B,$78,$02 ! DOUBLE_B     ,$10
:COLOR5			b $01
:RegTIcon1_4_04		w Icon_DRIVE_B
			b $1d ! DOUBLE_B,$78,$02 ! DOUBLE_B     ,$10
:COLOR6			b $01
:RegTIcon1_4_05		w Icon_DRIVE_C
			b $1f ! DOUBLE_B,$78,$02 ! DOUBLE_B     ,$10
:COLOR7			b $01
:RegTIcon1_4_06		w Icon_DRIVE_D
			b $21 ! DOUBLE_B,$78,$02 ! DOUBLE_B     ,$10
:COLOR8			b $01

;*** Icons.
if Sprache = Deutsch
:Icon_00
<MISSING_IMAGE_DATA>
:Icon_00x		= .x
:Icon_00y		= .y

:Icon_01
<MISSING_IMAGE_DATA>
:Icon_01x		= .x
:Icon_01y		= .y

:Icon_02
<MISSING_IMAGE_DATA>
:Icon_02x		= .x
:Icon_02y		= .y

:Icon_03
<MISSING_IMAGE_DATA>
:Icon_03x		= .x
:Icon_03y		= .y
endif

if Sprache = Englisch
:Icon_00
<MISSING_IMAGE_DATA>
:Icon_00x		= .x
:Icon_00y		= .y

:Icon_01
<MISSING_IMAGE_DATA>
:Icon_01x		= .x
:Icon_01y		= .y

:Icon_02
<MISSING_IMAGE_DATA>
:Icon_02x		= .x
:Icon_02y		= .y

:Icon_03
<MISSING_IMAGE_DATA>
:Icon_03x		= .x
:Icon_03y		= .y
endif

;*** X-Koordinate der Register-Icons.
:RegCardIconX_1		= $02 ! DOUBLE_B
:RegCardIconX_2		= (RegCardIconX_1 + Icon_00x) ! DOUBLE_B
:RegCardIconX_3		= (RegCardIconX_2 + Icon_03x) ! DOUBLE_B
:RegCardIconX_4		= (RegCardIconX_3 + Icon_01x) ! DOUBLE_B

;*** Auswahl-Icons.
:Icon_10
<MISSING_IMAGE_DATA>
:Icon_10x		= .x
:Icon_10y		= .y

if Sprache = Deutsch
:Icon_20
<MISSING_IMAGE_DATA>
:Icon_20x		= .x
:Icon_20y		= .y
endif

if Sprache = Englisch
:Icon_20
<MISSING_IMAGE_DATA>
:Icon_20x		= .x
:Icon_20y		= .y
endif

:Icon_21
<MISSING_IMAGE_DATA>
:Icon_21x		= .x
:Icon_21y		= .y

if Sprache = Deutsch
:Icon_25
<MISSING_IMAGE_DATA>
:Icon_25x		= .x
:Icon_25y		= .y
endif

if Sprache = Englisch
:Icon_25
<MISSING_IMAGE_DATA>
:Icon_25x		= .x
:Icon_25y		= .y
endif

:Icon_23
<MISSING_IMAGE_DATA>
:Icon_23x		= .x
:Icon_23y		= .y

;******************************************************************************
;*** Endadresse testen.
;******************************************************************************
			g LD_ADDR_TASKMAN + R2_SIZE_TASKMAN -1
;******************************************************************************
