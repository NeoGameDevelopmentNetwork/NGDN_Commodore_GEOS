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
			t "src.DeskTop.ext"
endif

			n "obj.mod#3"
			o vlirModBase

:l5b46			jmp	l5b52
:l5b49			jmp	l5d81
:l5b4c			jmp	l61cc
:l5b4f			jmp	l625f
:l5b52			lda	diskOpenFlg
			bne	l5b58
:l5b57			rts
:l5b58			jsr	$237e
			jsr	$59ca
			jsr	$4086
			lda	#$ff
			sta	l6182
			lda	#$11
			jsr	$48bd
			jsr	$590e
			lda	a0L
			pha
			lda	#$09
			sta	r9L
			jsr	l5caa
			txa
			beq	l5b86
:l5b7b			lda	#$00
			sta	l6182
			pla
			sta	a0L
			clv
			bvc	l5ba5
:l5b86			jsr	l6132
			lda	a0L
			bne	l5b93
:l5b8d			jsr	l5cff
			clv
			bvc	l5b96
:l5b93			jsr	l5d0b
:l5b96			pla
			sta	a0L
			jsr	l6177
			jsr	l613b
			jsr	l615a
			jsr	l5d1a
:l5ba5			lda	#$0c
			jsr	$4a06
			lda	#$2f
			sta	r8H
			lda	#$03
			sta	r8L
			lda	#$2f
			sta	r9H
			lda	#$0d
			sta	r9L
			lda	#$84
			sta	r5H
			lda	#$65
			sta	r5L
			lda	#$09
			sta	r7L
			jsr	l5e6a
			jsr	$3b2f
			lda	l6182
			beq	l5bea
:l5bd1			lda	$03e6
			sta	r6L
			lda	$03e7
			sta	r6H
			jsr	FindFile
			jsr	$59ca
			jsr	l616e
			jsr	$464a
			txa
			bne	l5c0f
:l5bea			lda	#$8b
			sta	r6H
			lda	#$d0
			sta	r6L
			lda	#$09
			sta	r7L
			lda	#$01
			sta	r7H
			lda	#$00
			sta	r10L
			sta	r10H
			jsr	FindFTypes
			lda	r7H
			bne	l5c4e
:l5c07			ldy	#$03
			jsr	l63f6
			clv
			bvc	l5c4e
:l5c0f			jsr	l6146
			jsr	l5c56
			jsr	l5c8f
			jsr	l6165
			jsr	l611c
			lda	r5H
			cmp	r4H
			bne	l5c28
:l5c24			lda	r5L
			cmp	r4L
:l5c28			beq	l5c4e
:l5c2a			jsr	$4526
			jsr	l5d28
			jsr	l6111
			lda	l6186
			sta	r4H
			lda	l6185
			sta	r4L
			jsr	$59ca
			jsr	PutBlock
			jsr	$59ca
			lda	#$0c
			jsr	$4a06
			jmp	l5d4e
:l5c4e			lda	#$0c
			jsr	$4a06
			jmp	$3228
:l5c56			lda	a0L
			pha
			lda	#$00
			sta	a0L
			jsr	$3ac3
			tya
			beq	l5c6a
:l5c63			lda	r1H
			cmp	#$03
			clv
			bvc	l5c6e
:l5c6a			lda	r1H
			cmp	#$01
:l5c6e			beq	l5c88
:l5c70			jsr	$58d4
			jsr	l63c1
			lda	r1H
			cmp	r3H
			bne	l5c80
:l5c7c			lda	r1L
			cmp	r3L
:l5c80			beq	l5c86
:l5c82			inc	a0L
			bne	l5c6e
:l5c86			inc	a0L
:l5c88			jsr	$58d4
			pla
			sta	a0L
			rts
:l5c8f			lda	r5L
			sec
			sbc	#$00
			sta	r5L
			lda	r5H
			sbc	#$80
			sta	r5H
			lda	r0L
			clc
			adc	r5L
			sta	r5L
			lda	r0H
			adc	r5H
			sta	r5H
			rts
:l5caa			ldy	a1L
			iny
			sty	a0L
			jsr	$58d4
			lda	r0H
			sta	r8H
			lda	#$00
			sta	a0L
			jsr	$58d4
			lda	#$6d
			sta	r5H
			lda	#$02
			sta	r5L
			lda	#$08
			sta	r7L
:l5cc9			ldy	#$00
			lda	(r5L),y
			beq	l5cd7
:l5ccf			ldy	#$16
			lda	(r5L),y
			cmp	r9L
			beq	l5cfc
:l5cd7			dec	r7L
			beq	l5cdd
:l5cdb			bne	l5ce6
:l5cdd			inc	a0L
			jsr	$58d4
			lda	#$08
			sta	r7L
:l5ce6			clc
			lda	#$20
			adc	r5L

			sta	r5L
			bcc	l5cf1
:l5cef			inc	r5H
:l5cf1			lda	r5H
			cmp	r8H
			bcc	l5cc9
:l5cf7			ldx	#$05
			clv
			bvc	l5cfe
:l5cfc			ldx	#$00
:l5cfe			rts
:l5cff			jsr	l63c1
			jsr	l614f
			jsr	$3aac
			sty	r1H
			rts
:l5d0b			jsr	l63c1
			jsr	l614f
			dec	a0L
			jsr	$58d4
			jsr	l63c1
			rts
:l5d1a			jsr	l6165
			lda	#$04
			sta	r5H
			lda	#$06
			sta	r5L
			jmp	$4526
:l5d28			lda	r4H
			sta	r5H
			lda	r4L
			sta	r5L
			lda	#$04
			sta	r4H
			lda	#$06
			sta	r4L
			jsr	$4526
			lda	r0H
			sta	r4H
			lda	r0L
			sta	r4L
			lda	r3H
			sta	r1H
			lda	r3L
			sta	r1L
			jmp	PutBlock
:l5d4e			jsr	$58d4
			jsr	l63c1
			lda	r1H
			cmp	$8001
			bne	l5d60
:l5d5b			lda	r1L
			cmp	diskBlkBuf
:l5d60			beq	l5d70
:l5d62			lda	r1H
			cmp	l618a
			bne	l5d6e
:l5d69			lda	r1L
			cmp	l6189
:l5d6e			bne	l5d7e
:l5d70			jsr	$34a2
			txa
			beq	l5d7e
:l5d76			lda	#$ff
			sta	l6182
			jmp	$31ce
:l5d7e			jmp	$3228
:l5d81			lda	diskOpenFlg
			bne	l5d87
:l5d86			rts
:l5d87			jsr	$237e
			jsr	$59ca
			jsr	$4086
			lda	#$ff
			sta	l6182
			lda	a0L
			pha
			lda	#$0a
			sta	r9L
			jsr	l5caa
			txa
			beq	l5dad
:l5da2			lda	#$00
			sta	l6182
			pla
			sta	a0L
			clv
			bvc	l5dcc
:l5dad			jsr	l6132
			lda	a0L
			bne	l5dba
:l5db4			jsr	l5cff
			clv
			bvc	l5dbd
:l5dba			jsr	l5d0b
:l5dbd			pla
			sta	a0L
			jsr	l6177
			jsr	l613b
			jsr	l615a
			jsr	l5d1a
:l5dcc			lda	#$2f
			sta	r8H
			lda	#$15
			sta	r8L
			lda	#$2f
			sta	r9H
			lda	#$1e
			sta	r9L
			lda	#$88
			sta	r5H
			lda	#$cb
			sta	r5L
			lda	#$0a
			sta	r7L
			jsr	l5e6a
			jsr	$3b6c
			bne	l5e67
:l5df0			lda	l6182
			beq	l5e0c
:l5df5			ldy	#$cb
			ldx	#$88
			sty	r6L
			stx	r6H
			jsr	FindFile
			jsr	$59ca
			jsr	l616e
			jsr	$464a
			txa
			bne	l5e31
:l5e0c			lda	#$8b
			sta	r6H
			lda	#$d0
			sta	r6L
			lda	#$0a
			sta	r7L
			lda	#$01
			sta	r7H
			lda	#$00
			sta	r10L
			sta	r10H
			jsr	FindFTypes
			lda	r7H
			bne	l5e64
:l5e29			ldy	#$03
			jsr	l63f6
			clv
			bvc	l5e64
:l5e31			jsr	l6146
			jsr	l5c56
			jsr	l5c8f
			jsr	l6165
			jsr	l611c
			lda	r5H
			cmp	r4H
			bne	l5e4a
:l5e46			lda	r5L
			cmp	r4L
:l5e4a			beq	l5e64
:l5e4c			jsr	$4526
			jsr	l5d28
			jsr	$59ca
			jsr	l6111
			jsr	l6127
			jsr	PutBlock
			jsr	$59ca
			jmp	l5d4e
:l5e64			jmp	$3228
:l5e67			jmp	$31ce
:l5e6a			lda	r5H
			sta	l5eb1
			lda	r5L
			sta	l5eb0
			lda	#$00
			sta	r10L
			sta	r10H
			lda	#$5e
			sta	r7H
			lda	#$66
			sta	r6H
			lda	#$00
			sta	r6L
			jsr	FindFTypes
			lda	#$5e
			sec
			sbc	r7H
			clc
			adc	#$01
			sta	l5ead
			jsr	$22c5
			lda	#$00
			sta	$3b
			lda	#$50
			sta	$3a
			lda	#$2d
			sta	$3c
			ldx	#$5e
			lda	#$b2
			jsr	$2483
			jmp	$22dc
:l5ead			b $00
:l5eae			b $00

:l5eaf			b $00
:l5eb0			b $00
:l5eb1			b $00,$81
			b $0b,$84
:l5eb5			b $30,$05
			b $2f,$0c,$84
:l5eba			b $10,$12
:l5ebc			b $0c,$84,$20
			b $14,$01,$11
			b $4b,$12,$07
			b $53,$d4,$5e
			b $12,$09,$53
			b $dc,$5e,$11
:l5ece			b $55,$5f,$13
			b $cb,$5f,$00
			b $e4,$5e,$00
			b $00,$02,$08
			b $06,$5f,$f5
			b $5e,$00,$00
			b $02,$08,$2c
			b $5f,$8a,$ff
			b $ff,$81,$81
			b $83,$c1,$87
			b $e1,$8f,$f1
			b $04,$81,$84
			b $ff,$ff,$bf
			b $82,$ff,$ff
			b $04,$81,$8c
			b $8f,$f1,$87
			b $e1,$83,$c1
			b $81,$81,$ff
			b $ff,$bf
:l5f06			lda	l5ead
			cmp	#$08
			bcc	l5f2b
:l5f0d			ldx	l5eaf
			beq	l5f26
:l5f12			dec	l5eaf
			lda	l5eaf
			clc
			adc	#$03
			cmp	l5eae
			bcs	l5f23
:l5f20			sta	l5eae
:l5f23			jsr	l5fd9
:l5f26			lda	mouseData
			bpl	l5f06
:l5f2b			rts
:l5f2c			lda	l5ead
			cmp	#$08
			bcc	l5f54
:l5f33			lda	l5ead
			sec
			sbc	#$08
			cmp	l5eaf
			bcc	l5f54
:l5f3e			inc	l5eaf
			lda	l5eae
			cmp	l5eaf
			bcs	l5f4c
:l5f49			inc	l5eae
:l5f4c			jsr	l5fd9
			lda	mouseData
			bpl	l5f2c
:l5f54			rts
:l5f55			bit	mouseData
			bmi	l5fc9
:l5f5a			lda	#$00
			sta	r3H
			lda	#$4a
			sta	r3L
			lda	#$00
			sta	r4H
			lda	#$c0
			sta	r4L
			lda	#$73
			sta	r2H
			lda	#$67
			sta	r2L
			ldx	#$05
:l5f74			jsr	IsMseInRegion
			bne	l5f8c
:l5f79			sec
			lda	r2L
			sbc	#$0c
			sta	r2L
			sec
			lda	r2H
			sbc	#$0c
			sta	r2H
			dex
			bpl	l5f74
:l5f8a			bmi	l5fc4
:l5f8c			txa
			clc
			adc	#$01
			cmp	l5ead
			bcs	l5fc4
:l5f95			txa
			clc
			adc	l5eaf
			pha
			ldx	l5eae
			jsr	l6057
			pla
			sta	l5eae
			pha
			tax
			jsr	l6057
			jsr	l600a
			pla
			ldy	dblClickCount
			beq	l5fbb
:l5fb3			cmp	l5fca
			bne	l5fbb
:l5fb8			jmp	l60a1
:l5fbb			sta	l5fca
			lda	#$1e
			sta	dblClickCount
			rts
:l5fc4			lda	#$00
			sta	dblClickCount
:l5fc9			rts
:l5fca				b $00
:l5fcb			jsr	l6106
			lda	#$00
			sta	l5eae
			sta	l5eaf
			jsr	l608a
:l5fd9			jsr	l6080
			lda	l5eaf
			clc
			adc	#$07
			cmp	l5ead
			bmi	l5fea
:l5fe7			lda	l5ead
:l5fea			sta	r15L
			ldx	l5eaf
			inx
:l5ff0			txa
			pha
			jsr	l60a9
			pla
			pha
			jsr	l6023
			pla
			tax
			inx
			cpx	r15L
			bcc	l5ff0
:l6001			ldx	l5eae
			jsr	l6057
			jmp	l600a
:l600a			ldx	l5eae
			inx
			txa
			jsr	l60a9
			lda	l5eb1
			sta	r1H
			lda	l5eb0
			sta	r1L
			ldx	#$02
			ldy	#$04
			jmp	CopyString
:l6023			pha
			sec
			sbc	l5eaf
			tax
			dex
			lda	l6051,x
			sta	r1H
			lda	#$00
			sta	$38
			lda	#$bf
			sta	$37
			lda	#$00
			sta	r11H
			lda	#$4e
			sta	r11L
			lda	#$40
			sta	$2e
			pla
			tax
			jsr	PutString
			lda	#$01
			sta	$38
			lda	#$3f
			sta	$37
			rts
:l6051			b $32,$3e
:l6053			b $4a,$56
			b $62,$6e
:l6057			txa
:l6058			sec
			sbc	l5eaf
			tax
			lda	l607a,x
			sta	r2L
			clc
			adc	#$0c
			sta	r2H
			lda	#$00

			sta	r3H
			lda	#$4b
			sta	r3L
			lda	#$00
			sta	r4H
			lda	#$bf
			sta	r4L
			jmp	InvertRectangle
:l607a			b $2a,$36,$42
			b $4e,$5a,$66
:l6080			jsr	i_Rectangle
			b $2a
			b $72,$4b,$00
			b $bf,$00
			rts
:l608a			jsr	i_FrameRectangle
			b $29,$73
			b $4a
			b $00,$c0,$00
			b $ff
			rts
:l6095			lda	l5eb0
			sta	$00,x
			inx
			lda	l5eb1
			sta	$00,x
			rts
:l60a1			lda	#$01
			sta	sysDBData
			jmp	RstrFrmDialogue
:l60a9			tay
			lda	#$00
			sta	r0L
			lda	#$66
			sta	r0H
:l60b2			dey
			beq	l60c3
:l60b5			lda	r0L
			clc
			adc	#$11
			sta	r0L
			bcc	l60b2
:l60be			inc	r0H
			clv
			bvc	l60b2
:l60c3			rts
:l60c4			ldy	keyData
			lda	#$f6
			ldx	#$ff
			cpy	#$08
			beq	l60f6
:l60cf			lda	#$0a
			ldx	#$00
			cpy	#$1e
			beq	l60f6
:l60d7			lda	#$f8
			cpy	#$10
			beq	l6101
:l60dd			lda	#$08
			cpy	#$11
			beq	l6101
:l60e3			cpy	#$0d
			bne	l60f5
:l60e7			lda	mouseData
			and	#$7f
			sta	mouseData
			lda	$39
			ora	#$20
			sta	$39
:l60f5			rts
:l60f6			clc
			adc	$3a
			sta	$3a
			txa
			adc	$3b
			sta	$3b
			rts
:l6101			clc
			adc	$3c
			sta	$3c
:l6106			lda	#$60
			sta	$84a4
			lda	#$c4
			sta	keyVector
			rts
:l6111			lda	l6188
			sta	r1H
			lda	l6187
			sta	r1L
			rts
:l611c			lda	l6184
			sta	r5H
			lda	l6183
			sta	r5L
			rts
:l6127			lda	l6186
			sta	r4H
			lda	l6185
			sta	r4L
			rts
:l6132			lda	r0H
			sta	r8H
			lda	r0L
			sta	r8L
			rts
:l613b			lda	r1H
			sta	l6188
			lda	r1L
			sta	l6187
:l6145			rts
:l6146			lda	r1H
			sta	r3H
			lda	r1L
			sta	r3L
			rts
:l614f			lda	r1H
			sta	l618a
:l6154			lda	r1L
			sta	l6189
			rts
:l615a			lda	r5H
			sta	l6184
			lda	r5L
			sta	l6183
			rts
:l6165			lda	r5H
			sta	r4H
			lda	r5L
			sta	r4L
			rts
:l616e			lda	r5H
			sta	r6H
			lda	r5L
			sta	r6L
			rts
:l6177			lda	r8H
			sta	l6186
			lda	r8L
			sta	l6185
			rts
:l6182			b $00
:l6183			b $00
:l6184			b $00
:l6185			b $00
:l6186			b $00
:l6187			b $00
:l6188			b $00
:l6189			b $00
:l618a			b $00
			b $18,$44,$65
			b $72,$20,$54
			b $72,$65,$69
			b $62,$65,$72
			b $20
:l6198			b $6c,$69,$65
			b $67,$74,$20
			b $61,$6d,$20
			b $52,$61,$6e
			b $64,$00,$75
			b $6e,$64,$20
			b $77,$69,$72
			b $64,$20,$6e
			b $69,$63,$68
			b $74,$20,$7a
			b $75,$72,$16
:l61b9			b $50,$00
:l61bb			b $60
			b $56,$6f,$72
:l61bf			b $65,$69
			b $6e,$73,$74
			b $65,$6c
			b $6c,$75,$6e
			b $67
:l61ca			b $2e,$00
:l61cc			lda	$848a
			beq	l624e
			jsr	$5954
			bcc	l624e
			jsr	$237e
			php
			sei
			jsr	$4086
			ldy	a0L
			cpy	#$11
			bcs	l6248
:l61e4			sty	r6L
			jsr	$3aac
			sty	r1H
:l61eb			ldy	#$01
			jsr	l624f
			txa
			bne	l624a
:l61f3			dec	r6L
			bmi	l6204
:l61f7			lda	diskBlkBuf
			sta	r1L
			lda	$8001
			sta	r1H
			clv
			bvc	l61eb
:l6204			lda	diskBlkBuf
			beq	l622d

:l6209			sta	r9L
			lda	$8001
			sta	r9H
			ldy	#$00
			jsr	l624f
			txa
			bne	l624a
:l6218			lda	r9H
			sta	$8001
			lda	r9L
			sta	diskBlkBuf
			ldy	#$02
			jsr	l624f
			txa
			bne	l624a
:l622a			clv
			bvc	l6235
:l622d			ldy	#$00
			jsr	l624f
			txa
			bne	l624a
:l6235			inc	a0L
			inc	a1L
			jsr	PutDirHead
			txa
			bne	l624a
:l623f			jsr	$3228
			txa
			bne	l624a
:l6245			clv
			bvc	l624d
:l6248			ldx	#$04
:l624a			jsr	$31ce
:l624d			plp
:l624e			rts
:l624f			lda	l625c,y
			ldx	l6259,y
			jsr	CallRoutine
			rts
:l6259			b $90,$90
:l625b			b $90
:l625c			b $39
			b $3c,$3f
:l625f			lda	diskOpenFlg
			beq	l62c9
:l6264			jsr	$5954
			bcc	l62c9
:l6269			jsr	$237e
			jsr	$4086
			lda	a0L
			bne	l6276
:l6273			jmp	l6323
:l6276			lda	#$00
			sta	l6434
			lda	#$07
:l627d			sta	a3H
			jsr	$4890
			beq	l62b2
:l6284			sta	l6434
			lda	a3H
			ldx	#$14
			jsr	$467e
			lda	$82bd
			beq	l6296
:l6293			jmp	$5112
:l6296			ldy	#$00
			lda	(r9L),y
			and	#$40
			beq	l62a3
:l629e			ldy	#$00
			jmp	l63f6
:l62a3			ldy	#$00
			lda	(r9L),y
			and	#$0f
			cmp	#$05
			bne	l62b2
:l62ad			ldy	#$01
			jmp	l63f6
:l62b2			lda	a3H
			sec
			sbc	#$01
			bpl	l627d
:l62b9			lda	l6434
			beq	l62ca
:l62be			ldx	#$63
			lda	#$e4
			jsr	$2483
			cmp	#$02
			bne	l62ca
:l62c9			rts
:l62ca			dec	a0L
			jsr	$58d4
			jsr	l63c1
			ldy	#$01
			jsr	l624f
			txa
			beq	l62dd
:l62da			jmp	l6360
:l62dd			lda	diskBlkBuf
			sta	r9L
			lda	$8001
			sta	r9H
			jsr	l6372
			txa
			bne	l6360
:l62ed			lda	r6H
			pha
			lda	r6L
			pha
			lda	diskBlkBuf
			beq	l6328
:l62f8			lda	a0L
			beq	l6358
:l62fc			dec	r0H
			jsr	l63c1
			inc	r0H
:l6303			jsr	l63cd
			txa
			bne	l6360
:l6309			pla
			sta	r1L
			pla
			sta	r1H
			inc	a0L
			jsr	$58d4
			dec	a0L
			lda	r0H
			sta	r4H
			lda	r0L
			sta	r4L
			jsr	PutBlock
			beq	l6363
:l6323			ldy	#$02
			jmp	l63f6
:l6328			lda	a0L
			bne	l6333
:l632c			jsr	$3aac
			sty	r1H
			bne	l6338
:l6333			dec	r0H
			jsr	l63c1
:l6338			jsr	l63cd
			txa
			bne	l6360
:l633e			pla
			sta	r1L
			pla
			sta	r1H
			inc	a0L
			jsr	$58d4
			dec	a0L
			lda	r0H
			sta	r4H
			lda	r0L
			sta	r4L
			jsr	PutBlock
			beq	l6363
:l6358			jsr	$3aac
			sty	r1H
			clv
			bvc	l6303
:l6360			jmp	$31ce
:l6363			dec	a1L
			jsr	PutDirHead
			txa
:l6369			bne	l6360
:l636b			jsr	$3228
			txa
			bne	l6360
:l6371			rts
:l6372			lda	r1H
			pha
			lda	r1L
			pha
			lda	r0H
			pha
			lda	r0L
			pha
			lda	r9H
			pha
			lda	r9L
			pha
			inc	a0L
			lda	#$07
:l6388			sta	a3H
			jsr	$4890
			beq	l63a2
:l638f			lda	a3H
			ldx	#$14
			jsr	$467e
			jsr	FreeFile
			lda	a3H
			jsr	$4618
			lda	#$00
			sta	a8H
:l63a2			lda	a3H
			sec
			sbc	#$01
			bpl	l6388
:l63a9			dec	a0L
			pla
			sta	r9L

			pla
			sta	r9H
			pla
			sta	r0L
			pla
			sta	r0H
			pla
			sta	r6L
			pla
			sta	r6H
			jsr	FreeBlock
			rts
:l63c1			ldy	#$00
			lda	(r0L),y
			sta	r1L
			iny
			lda	(r0L),y
			sta	r1H
			rts
:l63cd			ldy	#$01
			jsr	l624f
			jsr	$253e
			lda	r9H
			sta	$8001
			lda	r9L
			sta	diskBlkBuf
			ldy	#$02
			jmp	l624f
:l63e4			b $81,$0b
			b $10,$20
			b $35,$64,$0b
:l63eb			b $10,$30
:l63ed			b $50,$64
			b $01,$01,$48
			b $02,$11,$48
			b $00
:l63f6			lda	l6419,y
			sta	l6429
			lda	l6415,y
			sta	l642a
			lda	l6421,y
			sta	l642e
:l6408			lda	l641d,y
			sta	l642f
			ldx	#$64
			lda	#$25
			jmp	$2483
:l6415			b $64,$64,$64
:l6418			b $61
:l6419			b $60,$60
			b $ad,$8b
:l641d			b $64
			b $64,$64,$61
:l6421			b $7f,$9a,$c7
			b $a6
:l6425			b $81,$0b
			b $10,$20
:l6429			b $00
:l642a			b $00,$0b
:l642c			b $10,$30
:l642e			b $00
:l642f			b $00,$01
			b $11,$48,$00
:l6434			b $00
:l6435			b $18,$41,$6c
			b $6c,$65,$20
			b $44
:l643c			b $61,$74,$65
			b $69,$65,$6e
			b $20,$64,$69
			b $65,$73,$65
			b $72
:l6449			b $20,$53,$65
			b $69,$74,$65
			b $00
			b $67
:l6451			b $65,$68
:l6453			b $65,$6e
			b $20,$76,$65
			b $72
:l6459			b $6c,$6f,$72
:l645c			b $65,$6e
:l645e			b $2e,$00,$18
			b $4e,$69,$63
			b $68,$74,$20
:l6467			b $6c,$7c,$73
			b $63,$68,$62
			b $61,$72,$3a
			b $20,$53,$65
			b $69,$74,$65
			b $20,$65,$6e
			b $74,$68,$7b
:l647c			b $6c,$74,$00
			b $73,$63,$68
			b $72,$65,$69
			b $62,$67,$65
			b $73,$63,$68
			b $7d,$74,$7a
			b $74,$65,$20
			b $44,$61,$74
			b $65,$69,$65
			b $6e,$2e,$00
			b $4e,$69,$63
			b $68,$74,$2d
			b $47,$45,$4f
			b $53,$2d,$44
			b $61,$74,$65
			b $69,$65,$6e
			b $00,$18,$4b
			b $61,$6e,$6e
			b $20,$53,$65
			b $69,$74,$65
			b $20,$31,$20
			b $64,$65,$73
			b $20,$64,$65
			b $73,$6b,$54
			b $6f
:l64c5			b $70,$00
:l64c7			b $6e,$69,$63
			b $68
			b $74,$20
:l64cd			b $6c,$7c,$73
			b $63,$68,$65
			b $6e,$2e,$00

;Endadresse VLIR-Modul testen:
			g vlirModEnd
