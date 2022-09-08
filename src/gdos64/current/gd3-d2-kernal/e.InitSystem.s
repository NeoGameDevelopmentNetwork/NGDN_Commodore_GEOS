; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Symboltabellen.
if .p
			t "SymbTab_1"
			t "SymbTab_GDOS"
			t "SymbTab_CSYS"
			t "SymbTab_GEXT"
			t "SymbTab_GTYP"
			t "SymbTab_MMAP"
;			t "MacTab"

;--- Externe Labels.
			t "s.GD3_KERNAL.ext"
endif

;*** GEOS-Header.
			n "obj.InitSystem"
			f DATA

			o LOAD_INIT_SYS

;*** Kernal-Variablen initialisieren.
:xInitGEOS		lda	#$2f
			sta	zpage
			lda	#KRNL_IO_IN
			sta	CPU_DATA

			ldx	#$07
			lda	#$ff
::1			sta	KB_MultipleKey,x
			sta	KB_LastKeyTab ,x
			dex
			bpl	:1

			stx	keyMode
			stx	$dc02
			inx
			stx	keyBufPointer
			stx	MaxKeyInBuf
			stx	$dc03
			stx	$dc0f
			stx	$dd0f

			lda	PAL_NTSC		;PAL/NTSC-Flag auslesen.
			lsr				;Bit#0: PAL = %0, NTSC = %1
			txa
			ror
			sta	$dc0e			;Uhrzeit-Flag für PAL/NTSC
			sta	$dd0e			;korrigieren. SCPU64-V1-Bug!!!

			lda	$dd00
			and	#$30
			ora	#$05
			sta	$dd00
			lda	#$3f
			sta	$dd02
			lda	#$7f
			sta	$dc0d
			sta	$dd0d

			ldy	#$00
::3			lda	InitVICdata,y		;Neuen Wert für VIC-Register
			cmp	#$aa			;einlesen. Code $AA ?
			beq	:4			;Ja, übergehen.
			sta	$d000      ,y		;Neuen VIC-Wert schreiben.
::4			iny
			cpy	#$1e
			bne	:3

			jsr	SetKernalVec		;IO-Vektoren initialisieren.

			lda	#$30
			sta	CPU_DATA

			jsr	SetMseFullWin		;Mausgrenzen zurücksetzen.
			jsr	SCPU_SetOpt		;GEOS-Optimierung festlegen.

			jsr	SetADDR_InitSys
			jmp	SwapRAM

;******************************************************************************
;*** Endadresse testen.
;******************************************************************************
			g LOAD_INIT_SYS + R2S_INIT_SYS -1
;******************************************************************************
