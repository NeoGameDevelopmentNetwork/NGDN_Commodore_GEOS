; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

			n "mod.MDD_#114"
			t "G3_SymMacExt"

if Flag64_128 = TRUE_C64
			t "G3_V.Cl.64.Disk"
endif
if Flag64_128 = TRUE_C128
			t "G3_V.Cl.128.Disk"
endif

			t "-DD_JumpTab"
			t "-DD_InitSD2IEC"

;*** Prüfen ob Laufwerk installiert werden kann.
;    Übergabe:		AKKU = Laufwerkmodus.
;			xReg = Laufwerksadresse.
;    Rückgabe:		xReg = $00, Laufwerk kann installiert werden.
:xTestDriveMode		ldx	#NO_ERROR
			txa
			tay
			rts

;*** Laufwerk installieren.
;    Übergabe:		AKKU = Laufwerkmodus.
;			xReg = Laufwerksadresse.
;    Rückgabe:		xReg = $00, Laufwerk installiert.
;			     = $0D, Laufwerkstyp nicht verfügbar.
:xInstallDrive		sta	DriveMode		;Laufwerksdaten speichern.
			stx	DriveAdr

			jsr	PrepareDskDrv		;Treiber temporär installieren.

;--- Angeschlossenes Laufwerk testen.
::51			lda	DriveAdr		;Aktuelles Laufwerk feststellen.
			jsr	TestDriveType
			cpx	#$00			;Installationsfehler ?
			bne	:51a			; => Ja, Abbruch...
			cpy	#Drv1581		;1581-Laufwerk installieren ?
			beq	:54			; => Ja, weiter...

;--- Ergänzung: 15.12.18/M.Kanet
;Auf SD2IEC-Laufwerk testen. Falls Ja, dann Laufwerks-DOS wechseln.
::51a			jsr	TestSD2IEC		;Aktuelles Laufwerk SD2IEC?
			cpx	#$ff			;SD2IEC ?
			bne	:52			; => Nein, weiter...

			lda	#"8"
			ldx	#"1"
			jsr	LoadDriveROM		;DOS1581.BIN laden.
			jmp	:54			; => Weiter...

;--- Kompatibles Laufwerk suchen.
::52			lda	#Drv1581
			ldy	DriveAdr
			jsr	FindDrive		;1581-Laufwerk suchen.
			cpx	#$00			;Laufwerk gefunden ?
			beq	:54			; => Ja, weiter...

			lda	DriveAdr
			jsr	TurnOnNewDrive		;Dialogbox ausgeben.
			txa				;Lauafwerk eingeschaltet ?
			beq	:52			; => Ja, Laufwerk suchen...

;--- Kein passendes Laufwerk gefunden.
::53			ldx	#DEV_NOT_FOUND
			rts

;--- Laufwerk installieren.
::54			jsr	PrepareDskDrv		;Treiber installieren.

;--- SD2IEC-Kennung speichern.
			jsr	TestSD2IEC		;Aktuelles Laufwerk SD2IEC?
			cpx	#$ff			;SD2IEC ?
			bne	:55			; => Nein, weiter...

			ldx	DriveAdr		;Laufwerksdaten setzen.
			lda	#SET_MODE_SD2IEC
			sta	Flag_SD2IEC
			ora	RealDrvMode -8,x
			sta	RealDrvMode -8,x	;SD2IEC-Flag in RealDrvMode setzen.

;--- Laufwerkstreiber speichern.
::55			jsr	InitForDskDvJob		;Laufwerkstreiber in REU
			jsr	StashRAM		;kopieren.
			jsr	DoneWithDskDvJob

			lda	#$00
			sta	curDevice
			lda	DriveAdr
			jsr	SetDevice

;--- Ende, kein Fehler...
			ldx	#NO_ERROR
			rts

;*** Laufwerkstreiber vorbereiten.
:PrepareDskDrv		lda	#$00			;Aktuelles Laufwerk zurücksetzen.
			sta	curDevice

			lda	DriveAdr		;GEOS-Laufwerk aktivieren.
			jsr	SetDevice

			ldx	DriveAdr		;Laufwerksdaten setzen.
;			stx	curDrive		;Durch ":SetDevice" gesetzt.
			lda	DriveMode
			sta	RealDrvType -8,x
			sta	BASE_DDRV_DATA + (DiskDrvType - DISK_BASE)
			bmi	:ram_drive		;RAM-Laufwerk ? => Ja, weiter...
::disk_drive		and	#%01000111		;Shadow-Bit und Format isolieren.
			bne	:set_drive_type
::ram_drive		and	#%10000111		;RAM-Bit und Format isolieren.
::set_drive_type	sta	driveType   -8,x	;GEOS-Laufwerkstyp speichern.
			sta	curType
			lda	#$00
			sta	RealDrvMode -8,x

;--- Treiber installieren.
			jsr	i_MoveData		;Laufwerkstreiber aktivieren.
			w	BASE_DDRV_DATA
			w	DISK_BASE
			w	SIZE_DDRV_DATA
			rts

;*** Laufwerk deinstallieren.
:xDeInstallDrive	lda	#$00
			sta	ramBase     -8,x
			sta	driveType   -8,x
			sta	driveData   -8,x
			sta	turboFlags  -8,x
			sta	RealDrvType -8,x
			sta	RealDrvMode -8,x
			tax
			rts

;*** Systemvariablen.
:DriveMode		b $00
:DriveAdr		b $00

;******************************************************************************
;*** Endadresse testen.
;******************************************************************************
:END_INIT		g BASE_DDRV_INIT + SIZE_DDRV_INIT
:DSK_INIT_SIZE		= END_INIT - BASE_DDRV_INIT
;******************************************************************************
