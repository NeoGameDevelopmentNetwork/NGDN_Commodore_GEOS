; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;******************************************************************************
::tmp0 = Flag64_128!RL_NM!RL_81!RL_71!RL_41
if :tmp0 = TRUE_C64!TRUE
;******************************************************************************
;*** Einsprungtabelle RAM-Funktionen.
;    Übergabe:		r0	= Startadresse C64-RAM.
;			r1	= Startadresse REU.
;			r2	= Anzahl Bytes.
;			r3L	= Speicherbank.
;    Rückgabe:		-
;    Geändert:		AKKU,xReg,yReg
:xDsk_VerifyRAM		ldy	#%10010011		;RAM-Bereich Vergleichen.
			b $2c
:xDsk_StashRAM		ldy	#%10010000		;RAM-Bereich speichern.
			b $2c
:xDsk_SwapRAM		ldy	#%10010010		;RAM-Bereich tauschen.
			b $2c
:xDsk_FetchRAM		ldy	#%10010001		;RAM-Bereich laden.
:xDsk_DoRAMOp		php				;IRQ-Status zwischenspeichern und
			sei				;IRQs sperren.
			lda	CPU_DATA		;CPU Register einlesen und
			pha				;zwischenspeichern.
			lda	#$36			;I/O-Bereich und Kernal für
			sta	CPU_DATA		;RAMLink-Transfer aktivieren.

			tya
			pha
			jsr	EN_SET_REC		;RL-Hardware aktivieren.
			pla	 			;Transferdaten setzen.
			sta	EXP_BASE2 + 1
			lda	r0L
			sta	EXP_BASE2 + 2
			lda	r0H
			sta	EXP_BASE2 + 3
			lda	r1L
			sta	EXP_BASE2 + 4
			lda	r1H
			sta	EXP_BASE2 + 5
			lda	r3L
			sta	EXP_BASE2 + 6
			lda	r2L
			sta	EXP_BASE2 + 7
			lda	r2H
			sta	EXP_BASE2 + 8
			lda	#$00
			sta	EXP_BASE2 +14

			jsr	EXEC_REC_REU		;Job ausführen und
			jsr	RL_HW_DIS2		;RL-Hardware abschalten.

			pla
			sta	CPU_DATA		;CPU-Register zurücksetzen.
			plp				;IRQ-Status zurücksetzen.
			lda	#%01000000
			ldx	#NO_ERROR
::51			rts
endif

;******************************************************************************
::tmp1 = Flag64_128!RL_NM!RL_81!RL_71!RL_41
if :tmp1 = TRUE_C128!TRUE
;******************************************************************************
;*** Einsprungtabelle RAM-Funktionen.
;    Übergabe:		r0	= Startadresse C128-RAM.
;			r1	= Startadresse REU.
;			r2	= Anzahl Bytes.
;			r3L	= Speicherbank.
;    Rückgabe:		-
;    Geändert:		AKKU,xReg,yReg
:xDsk_VerifyRAM		ldy	#%10010011		;RAM-Bereich Vergleichen.
			b $2c
:xDsk_StashRAM		ldy	#%10010000		;RAM-Bereich speichern.
			b $2c
:xDsk_SwapRAM		ldy	#%10010010		;RAM-Bereich tauschen.
			b $2c
:xDsk_FetchRAM		ldy	#%10010001		;RAM-Bereich laden.
:xDsk_DoRAMOp		php				;IRQ-Status zwischenspeichern und
			jsr	InitRLKonfig		;RL-Konfiguration einschalten

			pha
			jsr	EN_SET_REC		;RL-Hardware aktivieren.
			pla	 			;Transferdaten setzen.
			sta	EXP_BASE2 + 1
			lda	r0L
			sta	EXP_BASE2 + 2
			lda	r0H
			sta	EXP_BASE2 + 3
			lda	r1L
			sta	EXP_BASE2 + 4
			lda	r1H
			sta	EXP_BASE2 + 5
			lda	r3L
			sta	EXP_BASE2 + 6
			lda	r2L
			sta	EXP_BASE2 + 7
			lda	r2H
			sta	EXP_BASE2 + 8
			ldy	#$00
			sty	EXP_BASE2 +14
			iny				;C128 Bank 1
			sty	EXP_BASE2 +16

			jsr	EXEC_REC_REU		;Job ausführen und

			jsr	ExitRLKonfig		;Konfiguration zurücksetzen.
			plp				;IRQ-Status zurücksetzen.
			lda	#%01000000
			ldx	#NO_ERROR
::51			rts
endif

;******************************************************************************
if RD_NM_SCPU = TRUE
;******************************************************************************
;*** Einsprungtabelle RAM-Funktionen.
;    Übergabe:		r0	= Startadresse C128-RAM.
;			r1	= Startadresse REU.
;			r2	= Anzahl Bytes.
;			r3L	= Speicherbank.
;    Rückgabe:		-
;    Geändert:		AKKU,xReg,yReg
:DoVerify		ldy	#%10010011		;RAM-Bereich vergleichen.
			b $2c
:DoStash		ldy	#%10010000		;RAM-Bereich speichern.
			b $2c
:DoSwap			ldy	#%10010010		;RAM-Bereich tauschen.
			b $2c
:DoFetch		ldy	#%10010001		;RAM-Bereich laden.
:xDoRAMOp		php				;IRQ sperren.
			sei
endif

if Flag64_128!RD_NM_SCPU = TRUE_C64!TRUE
			lda	CPU_DATA		;I/O-Bereich aktivieren.
			pha
			lda	#$35
			sta	CPU_DATA
endif
if Flag64_128!RD_NM_SCPU = TRUE_C128!TRUE
			lda	MMU
			pha
			lda	#$7e
			sta	MMU
endif

if RD_NM_SCPU = TRUE
			jsr	DoRAMOp_SRAM		;Job ausführen.
			tay
endif

if Flag64_128!RD_NM_SCPU = TRUE_C64!TRUE
			pla
			sta	CPU_DATA
endif
if Flag64_128!RD_NM_SCPU = TRUE_C128!TRUE
			pla
			sta	MMU
endif

if RD_NM_SCPU = TRUE
			plp				;IRQ-Status zurücksetzen.
			tya
;			ldx	#NO_ERROR
			rts

;*** DoRAMOp-Routine für RAMCard.
			t "-R3_DoDSKOpSRAM"
			t "-R3_SRAM16Bit"
endif

;******************************************************************************
if RD_NM_CREU = TRUE
;******************************************************************************
;*** Einsprungtabelle RAM-Funktionen.
;    Übergabe:		r0	= Startadresse C128-RAM.
;			r1	= Startadresse REU.
;			r2	= Anzahl Bytes.
;			r3L	= Speicherbank.
;    Rückgabe:		-
;    Geändert:		AKKU,xReg,yReg
:DoVerify		ldy	#%10010011		;RAM-Bereich vergleichen.
			b $2c
:DoStash		ldy	#%10010000		;RAM-Bereich speichern.
			b $2c
:DoSwap			ldy	#%10010010		;RAM-Bereich tauschen.
			b $2c
:DoFetch		ldy	#%10010001		;RAM-Bereich laden.
:xDoRAMOp		php				;IRQ sperren.
			sei
endif

if Flag64_128!RD_NM_CREU = TRUE_C64!TRUE
			lda	CPU_DATA		;I/O-Bereich aktivieren.
			pha
			lda	#$35
			sta	CPU_DATA
endif
if Flag64_128!RD_NM_CREU = TRUE_C128!TRUE
			lda	MMU
			pha
			lda	#$7e
			sta	MMU
			lda	CLKRATE
			pha
			lda	#$00
			sta	CLKRATE
endif

if RD_NM_CREU = TRUE
			jsr	DoRAMOp_CREU		;Job ausführen.
			tay
endif

if Flag64_128!RD_NM_CREU = TRUE_C64!TRUE
			pla
			sta	CPU_DATA
endif
if Flag64_128!RD_NM_CREU = TRUE_C128!TRUE
			pla
			sta	CLKRATE
			pla
			sta	MMU
endif

if RD_NM_CREU = TRUE
			plp				;IRQ-Status zurücksetzen.
			tya
;			ldx	#NO_ERROR
			rts

;*** DoRAMOp-Routine für C=REU.
			t "-R3_DoRAMOpCREU"
endif

;******************************************************************************
if RD_NM_GRAM = TRUE
;******************************************************************************
;*** Einsprungtabelle RAM-Funktionen.
;    Übergabe:		r0	= Startadresse C128-RAM.
;			r1	= Startadresse REU.
;			r2	= Anzahl Bytes.
;			r3L	= Speicherbank.
;    Rückgabe:		-
;    Geändert:		AKKU,xReg,yReg
:DoVerify		ldy	#%10010011		;RAM-Bereich vergleichen.
			b $2c
:DoStash		ldy	#%10010000		;RAM-Bereich speichern.
			b $2c
:DoSwap			ldy	#%10010010		;RAM-Bereich tauschen.
			b $2c
:DoFetch		ldy	#%10010001		;RAM-Bereich laden.
:xDoRAMOp		php				;IRQ sperren.
			sei
endif

if Flag64_128!RD_NM_GRAM = TRUE_C64!TRUE
			lda	CPU_DATA		;I/O-Bereich aktivieren.
			pha
			lda	#$35
			sta	CPU_DATA
endif
if Flag64_128!RD_NM_GRAM = TRUE_C128!TRUE
			lda	MMU
			pha
			lda	#$7e
			sta	MMU
endif

if RD_NM_GRAM = TRUE
			lda	GeoRAMBSize		;Bank-Größentyp einlesen.
			jsr	DoRAMOp_GRAM		;Job ausführen.
			tay
endif

if Flag64_128!RD_NM_GRAM = TRUE_C64!TRUE
			pla
			sta	CPU_DATA
endif
if Flag64_128!RD_NM_GRAM = TRUE_C128!TRUE
			pla
			sta	MMU
endif

if RD_NM_GRAM = TRUE
			plp
			tya				;IRQ-Status zurücksetzen.
;			ldx	#NO_ERROR		;Flag für "Kein Fehler".
			rts

;*** DoRAMOp-Routine für GeoRAM.
			t "-R3_DoRAMOpGRAM"
endif
