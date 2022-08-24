; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Symboltabellen.
if .p
			t "opt.GDOSl10n.ext"
			t "SymbTab_GDOS"
			t "SymbTab_GEXT"
			t "SymbTab_1"
			t "SymbTab_GTYP"
			t "SymbTab_MMAP"
			t "SymbTab_CHAR"
			t "MacTab"

;--- Externe Labels.
			t "s.GD3_KERNAL.ext"
			t "e.Register.ext"
			t "s.GDC.Config.ext"
			t "s.GDC.E.TASK.ext"
endif

;*** GEOS-Header.
			n "obj.GDC.TaskMan"
			c "GDC.TASKMAN V1.0"
			t "opt.Author"
			f SYSTEM
			z $80 ;nur GEOS64

			o BASE_CONFIG_TOOL

			i
<MISSING_IMAGE_DATA>

if LANG = LANG_DE
			h "TaskManager konfigurieren"
endif
if LANG = LANG_EN
			h "Configure TaskManager"
endif

;******************************************************************************
;*** Sprungtabelle.
;******************************************************************************
:MainInit		jmp	InitMenu
:SaveData		jmp	SaveConfig
:CheckData		ldx	#$00
			rts
;******************************************************************************
;*** Systemkennung.
;******************************************************************************
			b "GDCONF10"
;******************************************************************************

;*** Variablen.
;BootTaskStart beinhaltet den System-
;wert, StartTaskMamMse den invertierten
;Wert für das Register-Menü.
:StartTaskManMse	b $00				;$FF = TaskMan über Maustasten starten.

;*** Menü initialisieren.
:InitMenu		bit	Copy_firstBoot		;GEOS-BootUp - Menüauswahl ?
			bpl	DoAppStart		; => Ja, keine Parameterübernahme.

;--- Erststart initialisieren.
			jsr	GetTaskInstalled	;Anzahl installierter Tasks
			sty	BootTaskSize		;einlesen und speichern.

			jsr	SaveConfig		;Konfiguration übernehmen.

;*** Menü starten.
:DoAppStart		ldx	#$00
			lda	#%11011011
			cmp	TaskManKey2 +1
			beq	:1
			dex
::1			stx	BootTaskStart
			txa
			eor	#$ff
			sta	StartTaskManMse

			jsr	e_InitTaskData		;Externe Routinen initialisieren.

			jsr	e_InitTaskMan		;TaskManager installieren.

			jsr	SetADDR_Register	;Register-Routine einlesen.
			jsr	FetchRAM

			LoadW	r0,RegisterTab		;Register-Menü installieren.
			jmp	DoRegister

;*** Aktuelle Konfiguration speichern.
:SaveConfig		lda	BootTaskMan		;TaskManager-Status festlegen.
			sta	Copy_BootTaskMan

			ldx	#$00
			lda	#%11011011
			cmp	TaskManKey2 +1
			beq	:1
			dex
::1			stx	BootTaskStart

			ldx	#NO_ERROR		;Flag: "Kein Fehler!"
			rts

;*** TaskManager de-/aktivieren.
:Swap_TaskAktiv		bit	BootTaskMan		;TaskManager installiert ?
			bmi	:2			; => Nein, Ende...

			lda	BootTaskSize		;Anzahl Tasks > 0 ?
			bne	:1			; => Ja, weiter...

			inc	BootTaskSize		;Mind. 1 Task installieren.
::1			jmp	e_InitTaskMan		;TaskManager installieren.

::2			jsr	e_ResetTaskMan		;TaskManager-Daten löschen.
			jsr	e_ResetSpooler		;Druckerspooler neu installieren.
			jmp	e_ReloadSpooler

;*** Neue Größe SpoolerRAM berechnen.
:Swap_TaskSize		ldy	BootTaskSize

			lda	mouseYPos
			sec
			sbc	#$48
			cmp	#$04			;Mehr/Weniger ?
			bcs	:1			; => Weniger, weiter...

			cpy	#MAX_TASK_ACTIV		;Max. Anzahl Tasks erreicht ?
			beq	:3			; => Ja, Ende...

			iny				;Anzahl Tasks +1.
			lda	#%00000000		;TaskManager aktivieren.
			sta	BootTaskMan
			jmp	:2			;Anzahl Tasks aktualisieren.

::1			tya				;Anzahl Tasks = 0 ?
			beq	:3			; => Ja, Ende...
			dey				;Anzahl Tasks -1.
			bne	:2
			lda	#%10000000		;TaskManager deaktivieren.
			sta	BootTaskMan

::2			sty	BootTaskSize		;Anzahl Tasks aktualisieren.
			jmp	e_InitTaskMan
::3			rts

;*** Anzahl verfügbarer Tasks im aktuellen TaskManager ermitteln.
:GetTaskInstalled	bit	BootTaskMan		;TaskManager aktiv ?
			bpl	:2			; => Ja, weiter...

::off			lda	#$00			;TaskManager-Daten löschen.
			sta	Flag_TaskBank

			ldx	#MAX_TASK_ACTIV -1
::1			sta	e_BankTaskAdr ,x
			sta	e_BankTaskOpen,x
			dex
			bpl	:1

			ldy	#$00
			rts

;--- Variablen aus TaskManager einlesen.
::2			LoadW	r0,e_BankTaskAdr
			LoadW	r1,RTA_TASKMAN +3
			LoadW	r2,2*9 +1
			lda	Flag_TaskBank
			beq	:off
			sta	r3L
			jsr	FetchRAM

;--- Anzahl Tasks ermitteln.
			ldx	#MAX_TASK_ACTIV -1
			ldy	#$00
::3			lda	e_BankTaskAdr,x
			beq	:4
			iny
::4			dex
			bpl	:3
			rts

;*** Startart wechseln.
:SwapTaskMode1		lda	StartTaskManMse
			eor	#$ff
			sta	BootTaskStart
			jmp	SwapTaskMode

:SwapTaskMode2		lda	BootTaskStart
			eor	#$ff
			sta	StartTaskManMse

:SwapTaskMode		jsr	e_InitTManKey

			lda	BootTaskStart
			eor	#$ff
			sta	StartTaskManMse

			LoadW	r15,RegTMenu2a		;Registerkarte aktualisieren.
			jsr	RegisterUpdate
			LoadW	r15,RegTMenu2b		;Registerkarte aktualisieren.
			jmp	RegisterUpdate

;*** Register-Menü.
:RegisterTab		b $30,$bf
			w $0038,$0137

			b 2				;Anzahl Einträge.

			w RegTName1			;Register: "TaskManager".
			w RegTMenu1

			w RegTName2			;Register: "Einstellungen".
			w RegTMenu2

:RegTName1		w Icon_20
			b RegCardIconX_1,$28,Icon_20x,Icon_20y

:RegTName2		w Icon_21
			b RegCardIconX_2,$28,Icon_21x,Icon_21y

;*** System-Icons.
:RIcon_Swap		w Icon_11
			b $00,$00,Icon_11x,Icon_11y
			b USE_COLOR_INPUT

;*** Daten für Register "TASKMANAGER".
:RegTMenu1		b 2

			b BOX_FRAME
				w RegTText1_01
				w $0000
				b $40,$af
				w $0040,$012f
:RegTMenu1a		b BOX_OPTION
				w RegTText1_02
				w Swap_TaskAktiv
				b $50
				w $0048
				w BootTaskMan
				b %10000000

;*** Texte für Register "TASKMANAGER".
if LANG = LANG_DE
:RegTText1_01		b	 "TASKMANAGER",0
:RegTText1_02		b	$58,$00,$56, "TaskManager nicht installieren",0
endif
if LANG = LANG_EN
:RegTText1_01		b	 "TASKMANAGER",0
:RegTText1_02		b	$58,$00,$56, "Do not install the TaskManager",0
endif

;*** Daten für Register "EINSTELLUNGEN".
:RegTMenu2		b 7

			b BOX_FRAME
				w RegTText2_01
				w $0000
				b $40,$5f
				w $0040,$012f
::u01			b BOX_NUMERIC_VIEW
				w RegTText2_02
				w $0000
				b $48
				w $0108
				w BootTaskSize
				b 2!NUMERIC_RIGHT!NUMERIC_BYTE
			b BOX_FRAME
				w $0000
				w $0000
				b $47,$50
				w $0118,$0120
			b BOX_ICON
				w $0000
				w Swap_TaskSize
				b $48
				w $0118
				w RIcon_Swap
				b (:u01 - RegTMenu2 -1)/11 +1

			b BOX_FRAME
				w RegTText2_03
				w $0000
				b $70,$af
				w $0040,$012f
:RegTMenu2a		b BOX_OPTION
				w RegTText2_04
				w SwapTaskMode1
				b $78
				w $0048
				w StartTaskManMse
				b %11111111
:RegTMenu2b		b BOX_OPTION
				w RegTText2_05
				w SwapTaskMode2
				b $90
				w $0048
				w BootTaskStart
				b %11111111

;*** Texte für Register "EINSTELLUNGEN".
if LANG = LANG_DE
:RegTText2_01		b	 "ANWENDUNGEN",0
:RegTText2_02		b	$48,$00,$4e, "Max. gleichzeitig verfügbare"
			b GOTOXY,$48,$00,$56, "Anwendungen im TaskManager:",0
:RegTText2_03		b	 "AKTIVIEREN",0
:RegTText2_04		b	$58,$00,$7e, "TaskManager über Tastatur mit"
			b GOTOXY,$58,$00,$86, "<CBM> + <CTRL> starten",0
:RegTText2_05		b	$58,$00,$96, "TaskManager über linke und"
			b GOTOXY,$58,$00,$9e, "rechte Maustaste starten",0
endif
if LANG = LANG_EN
:RegTText2_01		b	 "APPLICATIONS",0
:RegTText2_02		b	$48,$00,$4e, "Select a maximum of"
			b GOTOXY,$48,$00,$56, "available applications:",0
:RegTText2_03		b	 "ACTIVATE",0
:RegTText2_04		b	$58,$00,$7e, "Activate TaskManager by using"
			b GOTOXY,$58,$00,$86, "<CBM> + <CTRL>-keys",0
:RegTText2_05		b	$58,$00,$96, "Activate TaskManager by using"
			b GOTOXY,$58,$00,$9e, "left and right mouse-button",0
endif

;*** Icons.
:Icon_11
<MISSING_IMAGE_DATA>
:Icon_11x		= .x
:Icon_11y		= .y

:Icon_20
<MISSING_IMAGE_DATA>
:Icon_20x		= .x
:Icon_20y		= .y

if LANG = LANG_DE
:Icon_21
<MISSING_IMAGE_DATA>
:Icon_21x		= .x
:Icon_21y		= .y
endif

if LANG = LANG_EN
:Icon_21
<MISSING_IMAGE_DATA>
:Icon_21x		= .x
:Icon_21y		= .y
endif

;*** X-Koordinate der Register-Icons.
:RegCardIconX_1		= $07
:RegCardIconX_2		= RegCardIconX_1 + Icon_20x

;******************************************************************************
;*** Endadresse testen.
;******************************************************************************
			g LOAD_REGISTER
;******************************************************************************
