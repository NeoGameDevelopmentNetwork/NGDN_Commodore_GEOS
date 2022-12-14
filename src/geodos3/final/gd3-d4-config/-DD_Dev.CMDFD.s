; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Laufwerkstreiber installieren.
;Übergabe: DrvAdrGEOS = GEOS-Laufwerk A-D/8-11.
;          DrvMode    = Laufwerksmodus $01=1541, $33=RL81...
;Rückgabe: xReg = $00, Laufwerk installiert.
:InstallDriver		lda	DrvMode			;Laufwerksmodus einlesen.
			ldx	DrvAdrGEOS		;GEOS-Laufwerksadresse einlesen.
			jsr	DskDev_Prepare		;Treiber installieren.

;--- RealDrvMode definieren:
;SET_MODE_...
; -> PARTITION/SUBDIR/FASTDISK/SD2IEC
; -> SRAM/CREU/GRAM
			ldx	DrvAdrGEOS		;Laufwerksmodi festlegen.
			lda	#SET_MODE_PARTITION
			ora	RealDrvMode -8,x
			sta	RealDrvMode -8,x

			lda	driveType   -8,x	;Bei NativeMode auch
			and	#%00000111		;Unterverzeichnisse erlauben.
			cmp	#DrvNative
			bne	:1
			lda	#SET_MODE_SUBDIR
			ora	RealDrvMode -8,x
			sta	RealDrvMode -8,x

;--- Laufwerkstreiber in REU speichern.
::1			lda	DrvAdrGEOS		;Aktuelles Laufwerk festlegen.
			sta	curDevice		;Adresse wird für die Routine
			sta	curDrive		;":InitForDskDvJob" benötigt.

			jsr	InitForDskDvJob		;Laufwerkstreiber in GEOS-Speicher
			jsr	StashRAM		;kopieren.
			jsr	DoneWithDskDvJob

			ldx	#NO_ERROR
::error			rts				;Ende.
