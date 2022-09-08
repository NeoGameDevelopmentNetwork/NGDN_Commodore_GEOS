; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

; Source code for DESK TOP
;
; Reassembled (w)2020 by Markus Kanet
; Original authors:
;   Brian Dougherty
;   Doug Fults
;   Jim Defrisco
;   Tony Requist
; (c)1986,1988 Berkeley Softworks
;
; Revision V0.1
; Date: 20/07/04
;
; History:
; V0.1 - Initial reassembled code.
;

if .p
			t "TopSym"
			t "TopMac"
			t "SymTab.ext"
			t "src.DeskTop.ext"
endif

			n "obj.mod#4"
			o vlirModBase

:l5b46			jmp	l5b83
:l5b49			jmp	l5b92
:l5b4c			jmp	l5b79
:l5b4f			jmp	l5b6a
:l5b52			jmp	l5e62
:l5b55			jmp	l5ff2
:l5b58			jmp	l6061
:l5b5b			jmp	l6206
:l5b5e			jmp	l6224
:l5b61			jmp	l6304
:l5b64			jmp	l6376
:l5b67			jmp	l6437
:l5b6a			lda	#$03
			sta	r5H
			lda	#$10
			sta	r6L
			lda	#$00
			sta	r6H
			jmp	l5b9c
:l5b79			lda	#$17
			sta	r5H
			lda	#$05
			sta	r6L
			bne	l5b8b
:l5b83			lda	#$1c
			sta	r5H
			lda	#$02
			sta	r6L
:l5b8b			lda	#$01
			sta	r6H
			jmp	l5b9c
:l5b92			lda	#$16
			sta	r5H
			lda	#$01
			sta	r6L
			bne	l5b8b
:l5b9c			lda	a7H
			bne	l5ba1
:l5ba0			rts
:l5ba1			jsr	l5d20
			lda	#$08
			sta	r4H
			lda	#$46
			sta	r4L
			lda	a8L
			beq	l5ba0
:l5bb0			lda	a8L
			sta	r5L
			jsr	l5d69
			lda	#$00
			sta	$0aee
			sta	$0aef
			jsr	$58b4
			lda	#$08
			sta	r14L
			cmp	a8L
			bcc	l5bd0
:l5bca			beq	l5bd0
:l5bcc			lda	a8L
			sta	r14L
:l5bd0			ldy	#$00
			sty	r12L
			sty	r12H
:l5bd6			jsr	l5be4
			inc	r12L
			dec	r14L
			bne	l5bd6
:l5bdf			lda	#$00
			sta	$2e
			rts
:l5be4			lda	$0aee
			clc
			adc	#$46
			sta	r4L
			lda	$0aef
			adc	#$08
			sta	r4H
			lda	#$40
			sta	$2e
			ldy	r12H
			lda	(r4L),y
			sta	r15L
			clc
			adc	#$03
			sta	r0L
			iny
			lda	(r4L),y
			sta	r15H
			adc	#$00
			sta	r0H
			iny
			sty	r12H
			ldx	#$00
			jsr	$57dd
			ldx	r1L
			inx
			lda	#$00
			sta	$8b80,x
			jsr	$59ee
			lda	#$00
			sta	r11H
			lda	#$0c
			sta	r11L
			ldx	r12L
			lda	l5c64,x
			sta	r1H
			lda	r4H
			pha
			lda	r4L
			pha
			lda	r12H
			pha
			lda	r12L
			pha
			lda	#$00
			sta	$38
			lda	#$78
			sta	$37
			jsr	PutString
			lda	#$01
			sta	$38
			lda	#$3f
			sta	$37
			ldy	a7L
			lda	l5c6b,y
			ldx	l5c6f,y
			jsr	CallRoutine
			pla
			sta	r12L
			pla
			sta	r12H
:l5c5d			pla
			sta	r4L
			pla
			sta	r4H
			rts
:l5c64			b $30,$3a
			b $44
:l5c67			b $4e,$58,$62
			b $6c
:l5c6b			b $76,$12
			b $12,$ff
:l5c6f			b $12
:l5c70			b $5d,$5d,$5c
			b $5d
:l5c74			lda	#$33
			sta	r7L
			lda	#$29
			sta	r7H
			lda	#$01
			jsr	l5cb1
			jsr	i_Rectangle
			b $70,$7b
			b $09,$00
:l5c86			b $06,$01
			lda	#$07
			bne	l5ca6
:l5c8e			lda	#$6f
			sta	r7L
			lda	#$79
			sta	r7H
			lda	#$ff
			jsr	l5cb1
			jsr	i_Rectangle
			and	#$33
:l5ca0			ora	#$00
			asl	$01
			lda	#$00
:l5ca6			sta	r12L
			asl
			sta	r12H
			jsr	l5be4
			jmp	l5bdf
:l5cb1			sta	r8L
			lda	#$46
			sta	r8H
:l5cb7			ldx	r7L
			txa
			clc
			adc	r8L
			sta	r7L
			jsr	GetScanLine
			lda	r5H
			sta	r0H
			lda	r5L
			sta	r0L
			ldx	r7H
			txa
			clc
			adc	r8L
			sta	r7H
			jsr	GetScanLine

			ldx	#$20
			bne	l5cdf
:l5cd9			ldy	#$00
			lda	(r0L),y
			sta	(r5L),y
:l5cdf			clc
			lda	#$08
			adc	r0L
			sta	r0L
			bcc	l5cea
:l5ce8			inc	r0H
:l5cea			clc
			lda	#$08
			adc	r5L
			sta	r5L
			bcc	l5cf5
:l5cf3			inc	r5H
:l5cf5			dex
			bpl	l5cd9
:l5cf8			dec	r8H
			bne	l5cb7
:l5cfc			jmp	$2447
:l5cff			jsr	l5fc1
			lda	#$00
			sta	r11H
			lda	#$a0
			sta	r11L
			jsr	l5f53
			lda	#$40
			sta	$2e
			rts
:l5d12			jsr	l5fc1
			lda	#$00
			sta	r11H
			lda	#$96
			sta	r11L
			jmp	l5ec0
:l5d20			lda	#$08
			sta	r3H
			lda	#$46
			sta	r3L
			lda	#$02
			sta	r4L
			lda	#$6d
			sta	r4H
			clc
			adc	a1L
			sta	r8L
			lda	#$00
			sta	a8L
:l5d39			ldy	#$00
			lda	(r4L),y
			beq	l5d55
:l5d3f			lda	r4L
			sta	(r3L),y
			iny
			lda	r4H
			sta	(r3L),y
			clc
			lda	#$02
			adc	r3L
			sta	r3L
			bcc	l5d53
:l5d51			inc	r3H
:l5d53			inc	a8L
:l5d55			lda	#$20
			clc
			adc	r4L
			sta	r4L
			lda	r4H
			adc	#$00
			sta	r4H
			cmp	r8L
			bcc	l5d39
:l5d66			beq	l5d39
:l5d68			rts
:l5d69			lda	r4H
			sta	r0H
			lda	r4L
			sta	r0L
			lda	r5L
			beq	l5d79
:l5d75			dec	r5L
			bne	l5d7a
:l5d79			rts
:l5d7a			lda	r0L
			clc
			adc	#$02
			sta	r0L
			sta	r1L
			lda	r0H
			adc	#$00
			sta	r0H
			sta	r1H
			ldy	#$00
			lda	(r0L),y
			sta	r7L
			clc
			adc	r5H
			sta	r2L
			iny
			lda	(r0L),y
			sta	r7H
			adc	#$00
			sta	r2H
:l5d9f			sec
			lda	r1L
			sbc	#$02
			sta	r1L
			lda	r1H
			sbc	#$00
			sta	r1H
			lda	r1H
			cmp	r4H
			bne	l5db6
:l5db2			lda	r1L
			cmp	r4L
:l5db6			bcc	l5de6
:l5db8			ldy	#$00
			lda	(r1L),y
			clc
			adc	r5H
			sta	r3L
			iny
			lda	(r1L),y
			adc	#$00
			sta	r3H
			jsr	l5e40
			ldx	#$06
			ldy	#$08
			lda	r6L
			jsr	CmpFString
			php
			jsr	l5e40
			lda	r6H
			beq	l5de3
:l5ddc			plp
			beq	l5de6
:l5ddf			bcs	l5d9f
:l5de1			bcc	l5de6
:l5de3			plp
			bcc	l5d9f
:l5de6			lda	r0L
			sta	r2L
			sta	r3L
			lda	r0H
			sta	r2H
			sta	r3H
			ldy	#$00
:l5df4			lda	r2L
			sec
			sbc	#$02
			sta	r2L
			lda	r2H
			sbc	#$00
			sta	r2H
			cmp	r1H
			bne	l5e0b
:l5e05			lda	r2L
			cmp	r1L
			beq	l5e24
:l5e0b			lda	(r2L),y
			sta	(r3L),y
			iny
			lda	(r2L),y
			sta	(r3L),y
			dey
			lda	r3L
			sec
			sbc	#$02
			sta	r3L
			lda	r3H
			sbc	#$00
			sta	r3H
			bne	l5df4
:l5e24			clc
			lda	#$02
			adc	r1L
			sta	r1L
			bcc	l5e2f
:l5e2d			inc	r1H
:l5e2f			lda	r7L
			sta	(r1L),y
			lda	r7H
			iny
			sta	(r1L),y
			dec	r5L
			beq	l5e3f
:l5e3c			jmp	l5d7a
:l5e3f			rts
:l5e40			ldy	#$1c
			cpy	r5H
			bne	l5e61
:l5e46			ldy	#$00
			lda	(r2L),y
			pha
			lda	(r3L),y
			tax
			iny
			lda	(r2L),y
			pha

			lda	(r3L),y
			dey
			sta	(r3L),y
			pla
			sta	(r2L),y
			iny
			txa
			sta	(r3L),y
			pla
			sta	(r2L),y
:l5e61			rts
:l5e62			lda	a8L
			cmp	#$09
			bcc	l5ebf
:l5e68			lda	$3c
			cmp	#$85
			beq	l5e70
:l5e6e			bcs	l5e8f
:l5e70			lda	$0aee
			ora	$0aef
			beq	l5eaf
:l5e78			sec
			lda	$0aee
			sbc	#$02
			sta	$0aee
			lda	$0aef
			sbc	#$00
			sta	$0aef
			jsr	l5c8e
			clv
			bvc	l5eaf
:l5e8f			lda	$0aef
			lsr
			lda	$0aee
			ror
			clc
			adc	#$08
			cmp	a8L
			bcs	l5eaf
:l5e9e			clc
			lda	#$02
			adc	$0aee
			sta	$0aee
			bcc	l5eac
:l5ea9			inc	$0aef
:l5eac			jsr	l5c74
:l5eaf			jsr	$586c
			b $7c,$8b,$80
			b $00
:l5eb6			bcc	l5eb8
:l5eb8			beq	l5ebf
:l5eba			lda	mouseData
			beq	l5e62
:l5ebf			rts
:l5ec0			ldy	#$16
			lda	(r15L),y
			bne	l5ed9
:l5ec6			ldy	#$00
			lda	(r15L),y
			sec
			sbc	#$01
			and	#$0f
			cmp	#$05
			bcs	l5efb
:l5ed3			clc
			adc	#$0f
			clv
			bvc	l5edd
:l5ed9			cmp	#$0f
			bcs	l5efb
:l5edd			tax
			ldy	#$00
			lda	(r15L),y
			pha
			lda	l5efc,x
			pha
			lda	l5f10,x
			tax
			pla
			jsr	$58ad
			pla
			and	#$40
			beq	l5efb
:l5ef4			ldx	#$5f
			lda	#$4c
			jmp	$58ad
:l5efb			rts
:l5efc			b $0a,$15,$20
			b $2e,$3f,$4b
			b $55,$61,$6a
			b $75,$95,$a4
			b $b4,$be,$c7
			b $24,$2c,$34
			b $3c,$44
:l5f10			b $2c
			b $2c,$2c,$2c
			b $2c,$2c,$2c
			b $2c,$2c,$2c
			b $2c,$2c,$2c
			b $2c,$2c,$5f
			b $5f,$5f,$5f
			b $5f,$1b,$80
			b $18,$20,$53
			b $45,$51,$00
			b $1b,$80,$18
			b $20
:l5f30			b $50,$52
			b $47,$00,$1b
			b $80,$18,$20
			b $55,$53,$52
			b $00,$1b,$80
:l5f3e			b $18,$20,$52
			b $45,$4c,$00
			b $1b,$80
:l5f46			b $18,$20,$43
			b $42,$4d,$00
			b $14,$fe,$00
			b $12,$20,$13
			b $00
:l5f53			ldy	#$16
			lda	(r15L),y
			beq	l5f85
:l5f59			lda	r11H
			pha
			lda	r11L
			pha
			ldy	#$19
			lda	(r15L),y
			sec
			jsr	l5f86
			ldy	#$18
			lda	(r15L),y
			sec
			jsr	l5f86
			ldy	#$17
			lda	(r15L),y
			clc
			jsr	l5f86
			pla
			clc
			adc	#$35
			sta	r11L
			pla
			adc	#$00
			sta	r11H
			jmp	l5f93
:l5f85			rts
:l5f86			php
			jsr	l5fb6
			plp
			bcc	l5f92
:l5f8d			lda	#$2f
			jmp	PutChar
:l5f92			rts
:l5f93			ldy	#$1a
			lda	(r15L),y
			bne	l5f9b
:l5f99			lda	#$0c
:l5f9b			sta	r0L
			lda	#$4c
			jsr	l5fba
			lda	#$2e
			jsr	PutChar
			ldy	#$1b
			lda	(r15L),y
			pha
			cmp	#$0a
			bcs	l5fb5
:l5fb0			lda	#$30
			jsr	PutChar
:l5fb5			pla
:l5fb6			sta	r0L
			lda	#$d0
:l5fba			ldy	#$00
			sty	r0H
			jmp	PutDecimal
:l5fc1			lda	#$00
			sta	r11H
			lda	#$78
			sta	r11L
			lda	#$52
			bne	l5fcf
:l5fcd			lda	#$c0
:l5fcf			pha
			ldy	#$1c
			lda	(r15L),y
			sta	r0L
			iny
			lda	(r15L),y
			lsr
			ror	r0L
			lsr
			ror	r0L
			sta	r0H
			ora	r0L
			bne	l5fe9
:l5fe5			lda	#$01
			sta	r0L
:l5fe9			pla
			jsr	PutDecimal
			lda	#$4b
			jmp	PutChar

:l5ff2			lda	numDrives
			cmp	#$02
			bcc	l6039
:l5ff9			jsr	$1aec
			jsr	NewDisk
			txa
			bne	l6036
:l6002			jsr	PurgeTurbo
			jsr	InitForIO
			lda	curDrive
			jsr	LISTEN
			lda	#$ff
			jsr	SECOND
			lda	#$49
			jsr	CIOUT
			lda	#$3a
			jsr	CIOUT
			lda	#$30
			jsr	CIOUT
			jsr	UNLSN
			lda	curDrive
			jsr	LISTEN
			lda	#$ef
			jsr	SECOND
			jsr	UNLSN
			jsr	DoneWithIO
:l6036			jsr	$1aec
:l6039			jmp	l603c
:l603c			jsr	l604b
			lda	#$60
			sta	r0H
			lda	#$4a
			sta	r0L
			jmp	ToBasic
			b $00
:l604b			ldy	#$00
			tya
:l604e			sta	$0800,y
			iny
			bne	l604e
:l6054			sta	r5L
			sta	r5H
			lda	#$08
			sta	r7H
			lda	#$03
			sta	r7L
			rts
:l6061			jsr	$477b
			ldy	#$1d
:l6066			lda	(a5L),y
			sta	$8400,y
			dey
			bpl	l6066
:l606e			lda	#$84
			sta	r5H
			lda	#$00
			sta	r5L
			ldy	#$01
			jsr	$1dda
			jsr	$253e
			ldx	#$0a
			ldy	#$16
			lda	(r5L),y
			cmp	#$03
			bcs	l6092
:l6088			cmp	#$02
			bne	l608f
:l608c			jmp	l60e2
:l608f			jmp	l6093
:l6092			rts
:l6093			lda	$8003
			cmp	#$04
			bcs	l609d
:l609a			jmp	l60cd
:l609d			ldx	#$0a
			cmp	#$08
			bne	l60cc
:l60a3			lda	$8002
			cmp	#$01
			bne	l60cc
:l60aa			ldx	#$0b
			ldy	#$1d
			lda	(r5L),y
			bne	l60cc
:l60b2			dey
			lda	(r5L),y
			cmp	#$79
			bcs	l60cc
:l60b9			lda	#$60
			sta	r0H
			lda	#$de
			sta	r0L
			lda	#$08
			sta	r7H
			lda	#$01
			sta	r7L
			jmp	ToBasic
:l60cc			rts
:l60cd			jsr	l61b3
			jsr	l604b
			lda	#$61
			sta	r0H
			lda	#$84
			sta	r0L
			jmp	ToBasic
			b $52,$55,$4e
			b $00
:l60e2			lda	$8003
			cmp	#$04
			bcs	l60ec
:l60e9			jmp	l60cd
:l60ec			sta	r7H
			ldx	#$0a
			cmp	#$08
			bcc	l6132
:l60f4			lda	$8002
			sta	r7L
			ldy	#$13
			jsr	$1dda
			jsr	$253e
			jsr	l613f
			lda	$804a
			cmp	#$80
			bcs	l6116
:l610b			lda	#$61
			sta	r0H
			lda	#$34
			sta	r0L
			jmp	ToBasic
:l6116			jsr	l61b3
			jsr	l604b
			lda	#$61
			sta	r0H
			lda	#$33
			sta	r0L
			jsr	l61ee
			lda	#$61
			sta	r0H
			lda	#$84
			sta	r0L
			jmp	ToBasic
:l6132			rts
			b $3a,$53,$59
			b $53,$28
:l6138			b $20
:l6139			b $20,$20,$20
			b $20,$29,$00
:l613f			lda	$804c
			sta	r0H
:l6144			lda	$804b
			sta	r0L
			ldx	#$04
			lda	#$00
			sta	r2L
:l614f			ldy	#$00
:l6151			lda	r0L
			sec
:l6154			sbc	l617a,x
			sta	r0L
			lda	r0H
			sbc	l617f,x
			bcc	l6165
:l6160			sta	r0H
			iny
			bne	l6151
:l6165			lda	r0L
			adc	l617a,x
			sta	r0L
			tya
			ora	#$30
			ldy	r2L
			sta	l6138,y
			inc	r2L
			dex
			bpl	l614f
:l6179			rts
:l617a			b $01,$0a,$64
:l617d			b $e8,$10
:l617f			b $00
:l6180			b $00,$00,$03
			b $27
:l6184			b $4c,$4f,$41
:l6187			b $44,$20,$22
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$22
:l61ad			b $2c
:l61ae			b $20
:l61af			b $20
			b $2c,$31,$00
:l61b3			ldy	#$03
:l61b5			cpy	#$13
			beq	l61c5
:l61b9			lda	(r5L),y
			cmp	#$a0

			beq	l61c5
:l61bf			sta	l6187,y
			iny
			bne	l61b5
:l61c5			lda	#$00
			sta	l6187,y
			lda	#$20
			sta	l61ae
			lda	curDrive
			cmp	#$0a
			bcc	l61e1
:l61d6			lda	#$31
			sta	l61ae
			lda	curDrive
			sec
			sbc	#$0a
:l61e1			ora	#$30
			sta	l61af
			lda	#$61
			sta	r0H
			lda	#$ac
:l61ec			sta	r0L
:l61ee			ldx	#$00
:l61f0			lda	l6184,x
			beq	l61f8
:l61f5			inx
			bne	l61f0
:l61f8			ldy	#$00
:l61fa			lda	(r0L),y
			sta	l6184,x
			beq	l6205
:l6201			iny
			inx
			bne	l61fa
:l6205			rts
:l6206			ldx	#$62
			lda	#$0d
:l620a			jmp	$2483
			b $81,$0b,$2a
			b $18,$47,$62
			b $0b
:l6214			b $10,$28
			b $5a,$62,$0b
:l6219			b $10,$38
:l621b			b $76,$62
			b $0b,$06
:l621f			b $50,$91
			b $62,$0e,$00
:l6224			ldx	#$62
			lda	#$2b
			jmp	$2483
:l622b			b $81,$0b
			b $2a,$10,$bb
			b $62,$0b
:l6232			b $10,$20
			b $5a,$62,$0b
			b $1a
:l6238			b $30,$cf
			b $62,$0b
:l623c			b $10,$40
:l623e			b $e8
			b $62,$0b,$06
:l6242			b $50,$91
			b $62,$0e,$00
			b $1a,$47,$45
			b $4f,$53,$1b
			b $18,$20,$4b
:l6250			b $65,$72
			b $6e,$61,$6c
:l6255			b $20,$76,$6f
:l6258			b $6e,$00,$42
			b $72,$69,$61
			b $6e,$20,$44
			b $6f,$75,$67
			b $68,$65,$72
			b $74,$79,$20
:l626a			b $20,$44,$6f
			b $75,$67,$20
			b $46,$75
			b $6c,$74,$73
			b $00
:l6276			b $4a
			b $69,$6d
			b $20,$44,$65
			b $66,$72
:l627e			b $69,$73
			b $63,$6f,$20
			b $20,$54,$6f
			b $6e,$79,$20
			b $52,$65,$71
			b $75,$69,$73
			b $74,$00,$1b
			b $43,$6f
:l6294			b $70,$79
			b $72,$69,$67
			b $68,$74,$20
			b $31,$39,$38
			b $36,$2c,$20
			b $31,$39,$38
			b $38,$2c,$20
			b $42,$65,$72
			b $6b,$65
:l62ad			b $6c,$65,$79
			b $20,$53,$6f
			b $66,$74,$77
			b $6f,$72,$6b
			b $73,$00,$1a
			b $47,$45,$4f
			b $53,$1b,$18
			b $20,$64,$65
			b $73,$6b,$54
			b $6f
:l62c9			b $70,$20
:l62cb			b $76,$6f
			b $6e,$00,$45
			b $72,$77,$65
			b $69,$74,$65
			b $72,$75
:l62d8			b $6e,$67
			b $20,$61
			b $75,$66
			b $20,$56
			b $32,$2e,$30
			b $20,$76,$6f
			b $6e,$00
			b $47,$69,$61
:l62eb			b $20,$46,$65
			b $72,$72,$79
			b $20,$75,$6e
			b $64,$20,$43
			b $68,$65
:l62f9			b $6e,$67,$2d
			b $59,$65,$77
			b $20,$54,$61
			b $6e,$00
:l6304			b $20
:l6305			stx	$40
			lda	diskOpenFlg
			beq	l634e
:l630c			jsr	$237e
:l630f			jsr	$59ca
:l6312			ldx	#$0a
			jsr	$38e4
			lda	#$8b
			sta	r6H
			lda	#$d0
			sta	r6L
			ldx	#$0a
			ldy	#$0e
			jsr	$2416
			ldx	#$63
			lda	#$67
			jsr	$2483
			lda	r0L
			cmp	#$02
			beq	l634e
:l6333			lda	$8bd0
			beq	l6312
:l6338			jsr	$3c7c
			jsr	$4819
			jsr	$4839
			ldx	#$8b
			lda	#$d0
			jsr	l634f
			jsr	$59ca
			jmp	$3228
:l634e			rts
:l634f			stx	r6H
			sta	r6L
			lda	#$82
			sta	r7H
			sta	r9H
			lda	#$90
			sta	r7L
			sta	r9L
			ldx	#$12
			jsr	l654e
			jmp	PutDirHead
:l6367			b $81,$0b
			b $10,$20
			b $f4
:l636c			b $2d,$0d,$10
			b $30,$0e
:l6371			b $10,$02
			b $11,$48
:l6375			b $00
:l6376			jsr	$237e
			ldx	#$63
			lda	#$80
			jmp	$55af
			b $20,$00,$51
:l6383			jsr	$5122
			jsr	l63a4
			jsr	$59ca
:l638c			tya
:l638d			beq	l6395
:l638f			jsr	l6408
			jsr	$59ca
:l6395			jsr	$4003
			jsr	$3912
			jsr	$3bdf
			jsr	$3c40

			ldx	#$00
			rts
:l63a4			jsr	l64b3
			jsr	$2559
			ldx	#$14
			ldy	#$0e
			jsr	$2416
			ldx	#$14
			ldy	#$0c
			jsr	$2416
			lda	#$65
			sta	r7H
			lda	#$7b
			sta	r7L
			ldx	#$63
			lda	#$fa
			jsr	$2483
			jsr	$2559
			lda	r0L
			cmp	#$02
			beq	l63eb
:l63d0			ldy	#$00
			lda	(r6L),y
			beq	l63a4
:l63d6			jsr	l63f0
			beq	l63eb
:l63db			jsr	l64c1
			jsr	$2559
			ldy	#$ff
			cpx	#$ff
			beq	l63a4
:l63e7			cpx	#$0c
			bne	l63ef
:l63eb			ldx	#$00
			ldy	#$00
:l63ef			rts
:l63f0			jsr	$2559
			ldx	#$0e
			ldy	#$0c
			jmp	CmpString
:l63fa			b $81,$0c
			b $10,$20
:l63fe			b $10,$0d
:l6400			b $10,$30
			b $0e,$10,$02
			b $11,$48,$00
:l6408			lda	r6H
			pha
			lda	r6L
:l640d			pha
			jsr	$5163
			clc
			lda	#$03
			adc	r7L
			sta	r7L
			bcc	l641c
:l641a			inc	r7H
:l641c			clc
			lda	#$03
			adc	r9L
			sta	r9L
			bcc	l6427
:l6425			inc	r9H
:l6427			pla
			sta	r6L
			pla
			sta	r6H
			ldx	#$10
			jsr	l654e
:l6432			lda	a3L
			jmp	$3afc
:l6437			jsr	$237e
			bit	a2H
			bpl	l6445
:l643e			ldx	#$64
			lda	#$46
			jmp	$55af
:l6445			rts
:l6446			jsr	$5100
			jsr	$5122
			jsr	l63a4
			txa
			bne	l6496
:l6452			tya
			beq	l64ad
:l6455			jsr	l64b3
			jsr	l6528
			ldx	#$14
			ldy	#$0c
			jsr	$2416
			lda	#$02
			sta	$03f7
			sta	$03f9
			lda	#$00
			sta	$03f6
			sta	$03f8
			lda	#$8b
			sta	$03fb
			lda	#$d0
			sta	$03fa
			lda	#$8b
			sta	$03fd
			lda	#$e4
			sta	$03fc
			lda	curDrive
			sta	a1H
			sta	a2L
			lda	a0L
			sta	a0H
			lda	#$ff
			jsr	$19ab
:l6496			jsr	$59d8
			lda	#$00
			sta	a8H
			jsr	$4003
			lda	a0H
			sta	a0L
			cmp	a1L
			bcc	l64ad
:l64a8			sta	a1L
			clv
			bvc	l64b0
:l64ad			jsr	$4003
:l64b0			jmp	$31d1
:l64b3			lda	a5L
			clc
			adc	#$03
			sta	r9L
			lda	a5H
			adc	#$00
			sta	r9H
			rts
:l64c1			jsr	FindFile
			jsr	$2559
			cpx	#$05
			bne	l64d2
:l64cb			jsr	l6519
			beq	l6516
:l64d0			bne	l6512
:l64d2			jsr	$253e
			jsr	l6528
			ldx	#$0e
			ldy	#$0c
			jsr	CopyString
			jsr	$2559
			ldx	#$0c
			ldy	#$0e
			jsr	CopyString
			jsr	l6528
			ldx	#$65
			lda	#$31
			jsr	$2483
			jsr	$2559
			ldx	#$0c
			lda	r0L
			cmp	#$02
			beq	l6518
:l64fe			ldy	#$00
			lda	(r6L),y
			beq	l6516
:l6504			jsr	l6519
			beq	l6516
:l6509			jsr	l63f0
			bne	l64c1
:l650e			ldx	#$0c
			bne	l6518
:l6512			ldx	#$00
			beq	l6518
:l6516			ldx	#$ff
:l6518			rts
:l6519			lda	#$2e
			sta	r5H
			lda	#$fa
			sta	r5L
			ldx	#$0e
			ldy	#$0c
			jmp	CmpString
:l6528			lda	#$8b
			sta	r5H
			lda	#$d0
			sta	r5L
			rts
:l6531			b $81,$0b
			b $10,$10
			b $a9
:l6536			b $2d,$0c
			b $2e,$10,$0c
			b $0b
:l653c			b $10,$20
:l653e			b $69,$65
			b $0b
:l6541			b $10
:l6542			b $30
			b $7c
:l6544			b $65
:l6545			b $0d
:l6546			b $10
:l6547			b $40
:l6548			b $0e,$10,$02
:l654b			b $11,$48
			b $00
:l654e			ldy	#$00

:l6550			lda	(r6L),y
:l6552			beq	l655e
:l6554			sta	(r9L),y
			sta	(r7L),y
			iny
			dex
			bne	l6550
:l655c			beq	l6568
:l655e			lda	#$a0
:l6560			sta	(r9L),y
			sta	(r7L),y
:l6564			iny
			dex
			bne	l6560
:l6568			rts
			b $18,$65,$78
			b $69,$73,$74
			b $69,$65,$72
			b $74
:l6573			b $20,$73
			b $63,$68,$6f
			b $6e,$2e,$00
			b $18,$4e,$65
:l657e			b $75,$65
			b $6e,$20,$44
			b $61,$74
			b $65,$69
			b $6e
:l6588			b $61,$6d
			b $65,$6e,$20
			b $65,$69,$6e
			b $67,$65,$62
			b $65,$6e
			b $3a,$1b,$00

;Endadresse VLIR-Modul testen:
			g vlirModEnd
