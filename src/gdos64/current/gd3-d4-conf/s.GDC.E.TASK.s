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
			t "SymbTab_1"
			t "SymbTab_GERR"
			t "SymbTab_GTYP"
			t "SymbTab_DTYP"
			t "SymbTab_MMAP"
			t "MacTab"

;--- Externe Labels.
			t "s.GD3_KERNAL.ext"
			t "s.GDC.Config.ext"
endif

;*** GEOS-Header.
			n "obj.CFG.TASK"
			f DATA

			o BASE_GCFG_BOOT

;******************************************************************************
;*** Sprungtabelle.
;******************************************************************************
:MainInit		jmp	BOOT_GDC_TASKMAN
;******************************************************************************

;*** Daten für Taskmanager.
			t "-G3_TaskManData"

.e_BankTaskAdr		= BankTaskAdr
.e_BankTaskOpen		= BankTaskActive

;*** AutoBoot: GD.CONF.TASKMAN.
:BOOT_GDC_TASKMAN	jsr	e_InitTaskData		;Externe Routinen initialisieren.
			txa				;Fehler ?
			bne	:exit			; => Nein, weiter...

			jsr	e_InitTaskMan		;TaskManager installieren.

::exit			lda	Copy_BootTaskMan	;TaskManager-Status speichern.
			sta	BootTaskMan

			rts

;*** Zeiger auf externe Routinen einlesen.
.e_InitTaskData		lda	#CFG_MOD_TASK
			jsr	LoadVlirHdr
			txa
			bne	:err

			lda	fileHeader +4
			sta	vlirTaskMan +0
			lda	fileHeader +5
			sta	vlirTaskMan +1

::err			rts

;*** Startart für TaskManager definieren.
.e_InitTManKey		lda	#%01111111		;CBM/CTRL.
			sta	TaskManKey1 +1
			lda	#%11011011
			sta	TaskManKey2 +1

			lda	BootTaskStart
			beq	:1

			lda	#%01111111		;Linke/rechte Maustaste.
			sta	TaskManKey1 +1
			lda	#%11101110
			sta	TaskManKey2 +1

::1			rts

;*** TaskManager installieren.
.e_InitTaskMan		lda	BootTaskSize		;TaskManager aktivieren ?
			beq	:6			; => Nein, weiter...

::1			jsr	e_ResetTaskMan		;TaskManager-Bänke freigeben.
			jsr	e_ResetSpooler		;Spooler-RAM freigeben.

			lda	#$00
			sta	r2L
::2			jsr	GetFreeBankL		;Speicherbank suchen.
			cpx	#NO_ERROR		;Bank gefunden ?
			bne	:5			; => Nein, weiter...

			ldy	r2L			;Bank in Tabelle eintragen.
			sta	BankTaskAdr ,y
			tax
			cpy	#$00			;TaskManager-Suystembank ?
			bne	:3			; => Nein, weiter...
			lda	#$ff			;Systembank als "Belegt" markieren.
			sta	BankTaskActive,y

::3			txa
			ldx	#%11000000		;Speicherbank reservieren.
			jsr	AllocateBank

::4			inc	r2L
			lda	r2L
			cmp	BootTaskSize		;Alle Tasks definiert ?
			bne	:2			; => Nein, weiter...

::5			lda	r2L
			sta	BootTaskSize		;TaskManager installiert ?
			bne	:7			; => Ja, weiter...

::6			lda	#%10000000		;TaskManager deaktivieren.
			b $2c
::7			lda	#%00000000		;TaskManager aktivieren.
;			sta	BootTaskMan
			sta	Copy_BootTaskMan

			tax				;TaskManager installieren ?
			bne	:9			; => Nein, weiter...

			bit	firstBoot		;GEOS-BootUp ?
			bpl	:load			; => Ja, von Disk installieren.

			lda	BankTaskAdr		;Lage von Systemspeicherbank
			sta	r3L			;geändert ?
			cmp	Flag_TaskBank
			beq	:8			; => Nein, weiter...

;--- TaskManager-Menü nachladen.
::load			jsr	swapRAM_TaskMan		;RAM-Bereich TaskManager sichern.

			jsr	loadTaskMenu		;TaskManager nachladen.
			txa				;Fehlerstatus zwischenspeichern.
			pha

			jsr	swapRAM_TaskMan		;TaskManager in DACC speichern.

			pla				;Diskettenfehler?
			bne	:6			; => Ja, TaskManager deaktivieren.

			lda	BankTaskAdr
			sta	Flag_TaskBank

;--- TaskManager-Variablen festlegen.
::8			lda	BootTaskSize
			sta	MaxTaskInstalled

			LoadW	r0,BankTaskAdr		;Konfiguration für TaskManager
			LoadW	r1,RTA_TASKMAN +3	;aktualisieren.
			LoadW	r2,2*9 +1
			lda	BankTaskAdr
			sta	r3L
			jsr	StashRAM

			jsr	e_InitTManKey

::9			jmp	e_ReloadSpooler

;*** Speicher für TaskManager laden/speichern.
:swapRAM_TaskMan	LoadW	r0,LOAD_TASKMAN		;TaskManager.
			LoadW	r1,RTA_TASKMAN
			LoadW	r2,RTS_TASKMAN
			lda	BankTaskAdr
			sta	r3L
			jmp	SwapRAM

;*** TaskManager nachladen.
:loadTaskMenu		lda	vlirTaskMan +0		;TaskManager-Daten verfügbar?
			beq	:err			; => Nein, TaskManager abschalten.
			sta	r1L
			lda	vlirTaskMan +1
			sta	r1H
			LoadW	r7,LOAD_TASKMAN
			LoadW	r2,RTS_TASKMAN
			jsr	ReadFile		;TaskManager-Daten einlesen.
;			txa				;Fehler?
;			bne	:err			; => Ja, TaskManager deaktivieren.

::err			rts

;*** TaskManager-Speicherbänke freigeben.
.e_ResetTaskMan		ldy	#$00
::1			sty	r2L
			lda	#$00
			sta	BankTaskActive ,y

			ldx	BankTaskAdr  ,y
			beq	:2
			lda	#$00
			sta	BankTaskAdr  ,y
			txa
			jsr	FreeBank

::2			ldy	r2L
			iny
			cpy	#MAX_TASK_ACTIV
			bcc	:1
			rts

;*** TaskManager-RAM freigeben.
.e_ResetSpooler		lda	Flag_Spooler		;Spooler aktiviert ?
			bpl	:1			; => Nein, weiter...
			lda	Flag_SpoolMinB		;SpoolerRAM belegt ?
			ora	Flag_SpoolMaxB
			beq	:1			; => Nein, weiter...

			lda	Flag_SpoolMaxB		;Größe SpoolerRAM berechnen.
			sec
			sbc	Flag_SpoolMinB
			clc
			adc	#$01
			tay
			lda	Flag_SpoolMinB
			jsr	FreeBankTab		;Speicher freigeben.
::1			rts

;*** SpoolerRAM reservieren.
.e_ReloadSpooler	lda	Flag_Spooler		;Spooler aktiviert ?
			bpl	:3			; => Nein, weiter...
			lda	Flag_SpoolMinB		;SpoolerRAM belegt ?
			ora	Flag_SpoolMaxB
			beq	:3			; => Nein, weiter...

			lda	Flag_SpoolMaxB		;Größe SpoolerRAM berechnen.
			sec
			sbc	Flag_SpoolMinB
			clc
			adc	#$01
			sta	BootSpoolSize		;Speicher für Spooler suchen.

::1			ldy	BootSpoolSize		;Speicher für Spooler suchen.
			jsr	GetFreeBankLTab
			cpx	#NO_ERROR		;Speicher frei ?
			beq	:2			; => Ja, weiter...
			dec	BootSpoolSize		;SpoolerRAM -64K
			bne	:1			; => weitersuchen.

			lda	#$00			;Kein Speicher für Spooler frei.
			sta	Flag_SpoolMinB
			sta	Flag_SpoolMaxB
			sta	Flag_Spooler
			sta	BootSpooler
			rts

::2			ldx	#$00
			stx	Flag_SpoolADDR +0
			stx	Flag_SpoolADDR +1
			sta	Flag_SpoolMinB
			sta	Flag_SpoolADDR +2
			ldx	#%11000000
			jsr	AllocateBankTab		;SpoolerRAM belegen.

			ldy	BootSpoolSize
			dey
			tya
			clc
			adc	Flag_SpoolMinB
			sta	Flag_SpoolMaxB
::3			rts

;*** Startadressen VLIR-Daten.
:vlirTaskMan		b $00,$00

;******************************************************************************
;*** Endadresse testen.
;******************************************************************************
			g BASE_DDRV_INFO
;******************************************************************************
