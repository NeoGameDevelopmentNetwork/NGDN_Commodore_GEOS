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

			n "obj.mod#2"
			o vlirModBase

:l5b46			jmp	l5b49
:l5b49			jsr	$237e
			ldx	#$5b
			lda	#$53
			jmp	$55af
:l5b53			ldx	#$20
			jsr	$4dd6
			lda	#$5b
			sta	r0H
			lda	#$9d
			sta	r0L
			jsr	$2665
			lda	#$5b
			sta	r0H
			lda	#$9c
			sta	r0L
			jsr	DoDlgBox
			lda	a5H
			pha
			lda	a5L
			pha
			jsr	$3ffd
			pla
			sta	a5L
			pla
			sta	a5H
			jsr	$237e
			jsr	$59ca
			jsr	$5163
			ldx	#$00
			ldy	#$00
			lda	$0406,y
			cmp	(r9L),y
			beq	l5b9b
:l5b91			sta	(r7L),y
			sta	(r9L),y
			jsr	$3b0e
			jsr	$3b00
:l5b9b			rts
			b $00,$28,$b5
			b $48,$00,$ef
			b $00,$0f,$a3
			b $5d,$12,$12
			b $01,$b2,$5b
			b $11,$72,$5d
			b $13,$e4,$5b
			b $00,$7f,$29
			b $00,$00,$02
			b $0b,$ba,$5b
:l5bba			lda	$041c
			beq	l5be0
:l5bbf			lda	a4L
			beq	l5be0
:l5bc3			lda	l65fe
			beq	l5be0
:l5bc8			jsr	l5f29
			bit	l5dbe
			bpl	l5be0
:l5bd0			lda	$041a
			sta	r1H
			lda	$0419
			sta	r1L
			jsr	$5a1d
			jsr	PutBlock
:l5be0			jmp	RstrFrmDialogue
:l5be3			b $00
:l5be4			jsr	$58c3
			jsr	$4526
			jsr	$5a1d
			lda	a4L
			bne	l5bf9
:l5bf1			lda	#$ff
			sta	l5be3
			clv
			bvc	l5c0a
:l5bf9			ldy	#$13
			lda	(r5L),y
			sta	r1L
			iny
			lda	(r5L),y
			sta	r1H
			jsr	GetBlock
			stx	l5be3
:l5c0a			lda	$8a82
			cmp	#$03
			bne	l5c18
:l5c11			lda	$8a83
			cmp	#$15
			beq	l5c1b
:l5c18			sta	l5be3
:l5c1b			ldx	#$04
			lda	#$09
			jsr	$57bd
			jsr	$59ee
			lda	#$00
			sta	r11H
			lda	#$9b
			sta	r11L
			lda	#$30
			sta	r1H
			jsr	$5805
			ldx	#$00
			stx	r11H
			lda	#$77
			sta	r11L
			lda	#$3e
			sta	r1H
:l5c40			lda	l5d91,x
			sta	r0L
			lda	l5d98,x
			sta	r0H
			txa
			pha
			jsr	$57ff
			pla
			tax
			lda	r1H
			clc
			adc	#$0b
			sta	r1H
			inx
			cpx	#$06
			bcc	l5c40
:l5c5d			beq	l5c61
:l5c5f			bcs	l5c70
:l5c61			lda	$041c
			cmp	#$0f
			bcs	l5c83
:l5c68			tay
			lda	l5d2e,y
			bne	l5c40
:l5c6e			beq	l5c83
:l5c70			lda	#$40
			sta	$2e
			jsr	l5d4a
			lda	l5be3
			bne	l5c83
:l5c7c			ldx	#$8a
			lda	#$e1
			jsr	$58ad
:l5c83			lda	#$40
			sta	$2e
			jsr	l5d4a
			lda	$041c
			beq	l5c92
:l5c8f			jsr	l6511
:l5c92			jsr	l5d4a
			jsr	l657f
			jsr	l5d4a
			lda	$041b
			tax
			lda	l5d9f,x
			pha
			lda	l5da1,x
			tax
			pla
			jsr	$58ad
			jsr	l5d4a
			lda	l5be3
			bne	l5cbf
:l5cb3			lda	$041c
			beq	l5cbf
:l5cb8			ldx	#$8a
			lda	#$cd
			jsr	$58ad
:l5cbf			jsr	l5d4a
			jsr	l6481
			jsr	l5d4a
			lda	a3L
			ldx	#$0a
			jsr	$4742
			jsr	$59ee
			ldx	#$0a
			ldy	#$02
			jsr	$2416
			jsr	PutString
			jsr	l5d60
			lda	#$ff
			jsr	FrameRectangle
			lda	$0406
			and	#$40
			beq	l5cf1
:l5ceb			jsr	l5d60
			jsr	InvertRectangle
:l5cf1			lda	#$00
			sta	r11H
			lda	#$7d
			sta	r11L
			lda	#$8b
			sta	r1H
			ldx	#$65
			lda	#$a3

			jsr	$58ad
			lda	#$00
			sta	l65fe
			lda	a4L
			beq	l5d12
:l5d0d			lda	l5be3
			bne	l5d17
:l5d12			lda	$041c
			bne	l5d18
:l5d17			rts
:l5d18			lda	a4L
			bne	l5d26
:l5d1c			jsr	l5d3d
			ldx	#$2e
			lda	#$84
			jmp	$58ad
:l5d26			lda	#$ff
			sta	l65fe
			jmp	l5dd3
:l5d2e				b $00,$ff,$ff
			b $00,$00,$ff
			b $ff,$00,$00
			b $ff,$ff,$ff
			b $ff,$00,$ff
:l5d3d			lda	#$00
			sta	r11H
			lda	#$58
			sta	r11L
			lda	#$a2
			sta	r1H
			rts
:l5d4a			sec
			lda	r1H
			sbc	#$0b
			sta	r1H
			lda	r2L
			sbc	#$00
			sta	r2L
			lda	#$00
			sta	r11H
			lda	#$7d
			sta	r11L
			rts
:l5d60			ldy	#$05
:l5d62			lda	l5d6c,y
			sta	$0006,y
			dey
			bpl	l5d62
:l5d6b			rts
:l5d6c			b $84,$8b
			b $70,$00
:l5d70			b $77,$00
:l5d72			bit	mouseData
			bmi	l5d90
:l5d77			jsr	$4718
			txa
			beq	l5d90
:l5d7d			jsr	l5d60
			jsr	IsMseInRegion
			beq	l5d90
:l5d85			lda	$0406
			eor	#$40
			sta	$0406
			jsr	InvertRectangle
:l5d90			rts
:l5d91			b $b4,$be,$c3
			b $cb,$d5,$dc
			b $e6
:l5d98			b $65,$65
			b $65,$65,$65
			b $65,$65
:l5d9f			b $ed
			b $f9
:l5da1			b $65,$65
			b $05,$09,$01
			b $49,$00,$29
			b $03,$ee,$00
:l5dac			b $35,$01
			b $4c,$00,$8f
			b $07,$eb,$00
			b $b1,$00,$20
			b $8b,$5f,$00
			b $00,$00,$00
			b $00
:l5dbe			b $00,$00
			b $00
:l5dc1			b $90,$b0
:l5dc3			b $4e,$00,$e9
			b $00,$40,$00
			b $00,$00,$00
:l5dcc			b $00
:l5dcd			b $00
:l5dce			b $00
:l5dcf			b $00
:l5dd0			b $00
:l5dd1			b $00
:l5dd2			b $00
:l5dd3			lda	#$5d
			sta	r0H
			lda	#$b6
			sta	r0L
			lda	r0H
			sta	$25
			lda	r0L
			sta	$24
			jsr	l6416
			jsr	l6235
			jsr	l63ac
			lda	#$00
			sta	l5dd2
			jsr	l619e
			bcc	l5e09
:l5df6			ldy	#$80
:l5df8			sty	r2L
			ldy	#$09
			lda	($24),y
			pha
			iny
			lda	($24),y
			tax
			pla
			ldy	r2L
			jmp	CallRoutine
:l5e09			jsr	l5f19
			lda	$84aa
			sta	l5dcd
			lda	otherPressVec
			sta	l5dcc
			lda	$84a4
			sta	l5dcf
			lda	keyVector
			sta	l5dce
			lda	#$5f
			sta	$84aa
			lda	#$56
			sta	otherPressVec
			lda	#$5f
			sta	$84a4
			lda	#$7b
			sta	keyVector
			jsr	l63ac
			jsr	l635a
			pha
			jsr	l5f19
			pla
			jsr	InitTextPrompt
			jsr	l6416
			lda	r4H
			sta	r7H
			lda	r4L
			sta	r7L
			lda	r2H
			sta	r8L
:l5e55			jsr	l63ac
			jsr	l6416
:l5e5b			jsr	l635a
			sec
			adc	r2L
			cmp	r8L
			beq	l5e67
:l5e65			bcs	l5e95
:l5e67			sta	r6L
			lda	r0H
			sta	r9H
			lda	r0L
			sta	r9L
:l5e71			ldy	#$00
			lda	(r0L),y
			beq	l5e85
:l5e77			php
			jsr	l630c
			plp
			bpl	l5e71
:l5e7e			lda	r6L
			sta	r2L
			clv
			bvc	l5e5b
:l5e85			lda	r9H
			sta	r0H
			lda	r9L
			sta	r0L
			lda	#$27
			sta	r7H
			lda	#$0f
			sta	r7L
:l5e95			ldy	#$00
			lda	(r0L),y
			beq	l5ee7
:l5e9b			and	#$7f
			cmp	#$0d
			beq	l5ee7
:l5ea1			ldx	$2e
			jsr	GetRealSize
			tya
			sta	r6L
			clc
			adc	r3L
			sta	r3L
			bcc	l5eb2
:l5eb0			inc	r3H
:l5eb2			ldy	#$00
			lda	(r0L),y

			jsr	l630c
			cmp	#$00
			bmi	l5ee7
:l5ebd			lda	r3H
			cmp	r7H
			bne	l5ec7
:l5ec3			lda	r3L
			cmp	r7L
:l5ec7			bcc	l5e95
:l5ec9			lda	r7H
			cmp	#$27
			beq	l5ee7
:l5ecf			lda	r3L
			sec
			sbc	r7L
			asl
			cmp	r6L
			bcc	l5ee7
:l5ed9			jsr	l6466
			lda	r3L
			sec
			sbc	r6L
			sta	r3L
			bcs	l5ee7
:l5ee5			dec	r3H
:l5ee7			ldy	#$04
			lda	r0L
			sta	($24),y
			iny
			lda	r0H
			sta	($24),y
			ldy	#$06
			lda	r0L
			sta	($24),y
			iny
			lda	r0H
			sta	($24),y
			lda	r3H
			sta	$84bf
			lda	r3L
			sta	stringX
			ldy	#$0c
			lda	($24),y
			cmp	r2L
			bcs	l5f11
:l5f0f			sta	r2L
:l5f11			lda	r2L
			sta	stringY
			jsr	PromptOn
:l5f19			ldx	#$08
:l5f1b			lda	$850b,x
			sta	$25,x
			dex
			bne	l5f1b
:l5f23			lda	$8514
			sta	$2e
			rts
:l5f29			jsr	l63ac
			jsr	l63f5
			jsr	l5f19
			jsr	PromptOff
			lda	#$7f
			and	alphaFlag
			sta	alphaFlag
			lda	l5dcd
			sta	$84aa
			lda	l5dcc
			sta	otherPressVec
			lda	l5dcf
			sta	$84a4
			lda	l5dce
			sta	keyVector
			rts
:l5f56			lda	mouseData
			bmi	l5f72
:l5f5b			jsr	l6416
			jsr	l6425
			bcc	l5f72
:l5f63			lda	$3b
			sta	r7H
			lda	$3a
			sta	r7L
			lda	$3c
			sta	r8L
			jmp	l5e55
:l5f72			lda	l5dcc
			ldx	l5dcd
			jmp	CallRoutine
:l5f7b			lda	keyData
			bmi	l5f9b
:l5f80			cmp	#$08
			beq	l5f9c
:l5f84			cmp	#$1d
			beq	l5f9c
:l5f88			cmp	#$1c
			beq	l5f9c
:l5f8c			cmp	#$1e
:l5f8e			beq	l5f9c
			cmp	#$0d
			beq	l5f98
:l5f94			cmp	#$20
			bcc	l5f9b
:l5f98			jmp	l5fe2
:l5f9b			rts
:l5f9c			jsr	l63ac
			jsr	l6132
			lda	r0H
			cmp	r4H
			bne	l5fac
:l5fa8			lda	r0L
			cmp	r4L
:l5fac			beq	l5fdf
:l5fae			jsr	l6478
			lda	r4L
			ldy	#$04
			sta	($24),y
			ldy	#$06
			sta	($24),y
			lda	r4H
			ldy	#$05
			sta	($24),y
			ldy	#$07
			sta	($24),y
			ldy	#$00
:l5fc7			iny
			lda	(r4L),y
			dey
			sta	(r4L),y
			jsr	l645f
			cmp	#$00
			bne	l5fc7
:l5fd4			jsr	l6195
			lda	#$ff
			sta	l5dd2
			jmp	l60f1
:l5fdf			jmp	l5f19
:l5fe2			cmp	#$0d
			bne	l5ff6
:l5fe6			pha
			ldy	#$08
			lda	($24),y
			and	#$40
			beq	l5ff5
:l5fef			pla
			ldy	#$20
			jmp	l5df8
:l5ff5			pla
:l5ff6			pha
			jsr	l63ac
			jsr	l6132
			jsr	l6170
			ldy	#$02
			lda	r2L
			cmp	($24),y
			bne	l6018
:l6008			iny
			lda	r2H
			cmp	($24),y
			bne	l6018
:l600f			pla
			jsr	l5f19
			ldy	#$40
			jmp	l5df8
:l6018			lda	r4L
			clc
			adc	#$01
			ldy	#$04
			sta	($24),y
			ldy	#$06
			sta	($24),y
			lda	r4H
			bcc	l602c
:l6029			clc
			adc	#$01
:l602c			ldy	#$05
			sta	($24),y
			ldy	#$07
			sta	($24),y
			pla
			pha
			tax
			ldy	#$00
			lda	(r4L),y
			sta	r2L
:l603d			lda	(r4L),y
			pha
			txa
			sta	(r4L),y
			jsr	l645f
			pla
			tax
			bne	l603d
:l604a			sta	(r4L),y
			jsr	l6195
			lda	#$00
			sta	l5dd2
			pla
			cmp	#$0d
			beq	l6061
:l6059			jsr	l6065
			bcc	l6064
:l605e			jmp	l60f1

:l6061			jmp	l6124
:l6064			rts
:l6065			sta	r5L
			lda	r2L
			and	#$7f
			beq	l6073
:l606d			cmp	#$0d
			beq	l6073
:l6071			sec
			rts
:l6073			lda	r5L
			ldx	$2e
			jsr	GetRealSize
			tya
			clc
			adc	stringX
			sta	r4L
			lda	#$00
			adc	$84bf
			sta	r4H
			ldy	#$10
			lda	($24),y
			cmp	r4H
			bne	l6095
:l6090			dey
			lda	($24),y
			cmp	r4L
:l6095			bcc	l6071
:l6097			beq	l6071
:l6099			lda	$34
			pha
			ldy	#$0c
			lda	($24),y
			sta	$34
			lda	$84bf
			sta	r11H
			lda	stringX
			sta	r11L
			lda	stringY
			sta	r1H
			lda	r5L
			jsr	l632a
			pla
			sta	$34
			ldy	#$08
			lda	($24),y
			and	#$10
			beq	l60e9
:l60c1			jsr	l6416
			lda	r1H
			sta	r2L
			sta	r2H
			cmp	$34
			beq	l60d0
:l60ce			bcs	l60e9
:l60d0			lda	$84bf
			sta	r3H
			lda	stringX
			sta	r3L
			jsr	l6456
			jsr	l644b
			jsr	l6478
			jsr	l6240
			clv
			bvc	l60ec
:l60e9			jsr	l644b
:l60ec			jsr	l611e
			clc
			rts
:l60f1			lda	$84bf
			cmp	r11H
			bne	l60fd
:l60f8			lda	stringX
			cmp	r11L
:l60fd			beq	l6124
:l60ff			lda	r3H
			pha
			lda	r3L
			pha
			jsr	PromptOff
			jsr	l6162
			pla
			sta	r0L
			pla
			sta	r0H
			lda	stringY
			sta	r1H
:l6116			jsr	l619e
			bcc	l611e
:l611b			jmp	l5df6
:l611e			jsr	PromptOn
			jmp	l5f19
:l6124			lda	#$ff
			sta	l5dd2
			jsr	PromptOff
			jsr	l6162
			jmp	l6116
:l6132			lda	r4H
			sta	r3H
			lda	r4L
			sta	r3L
			jsr	l646f
			ldy	#$00
:l613f			lda	r3H
			cmp	r0H
			bne	l6149
:l6145			lda	r3L
			cmp	r0L
:l6149			beq	l6155
:l614b			jsr	l646f
			lda	(r3L),y
			bpl	l613f
:l6152			jsr	l615b
:l6155			lda	(r3L),y
			cmp	#$0d
			bne	l6161
:l615b			inc	r3L
			bne	l6161
:l615f			inc	r3H
:l6161			rts
:l6162			ldy	#$04
			lda	($24),y
			sta	l5dd0
			iny
			lda	($24),y
			sta	l5dd1
			rts
:l6170			lda	r0H
			sta	r2H
			lda	r0L
			sta	r2L
			ldy	#$00
:l617a			lda	(r2L),y
			beq	l6187
:l617e			inc	r2L
			bne	l6184
:l6182			inc	r2H
:l6184			clv
			bvc	l617a
:l6187			lda	r2L
			sec
			sbc	r0L
			sta	r2L
			lda	r2H
			sbc	r0H
			sta	r2H
			rts
:l6195			ldy	#$08
			lda	($24),y
			ora	#$80
			sta	($24),y
			rts
:l619e			lda	$34
			pha
			ldy	#$0c
			lda	($24),y
			sta	$34
			jsr	l644b
			lda	r1H
			sta	stringY
:l61af			jsr	l6277
:l61b2			jsr	l62dc
			ldy	#$00
			lda	(r0L),y
			and	#$7f
			beq	l620e
:l61bd			cmp	#$0d
			beq	l61e0
:l61c1			jsr	l6363
			bcs	l61e0
:l61c6			jsr	l62dc
			ldy	#$00
			lda	(r0L),y
			and	#$7f
			sta	(r0L),y
			cmp	#$0d
			beq	l61e0
:l61d5			jsr	l6313
			beq	l620e
:l61da			cmp	#$20
			bne	l61c6
:l61de			beq	l61b2
:l61e0			jsr	l6253
			jsr	l62f3
			jsr	l6346
			jsr	l635a
			clc
			adc	r1H
			cmp	$34
			bcc	l6200
:l61f3			ldy	#$08
			lda	($24),y
			and	#$20
			beq	l6200
:l61fb			pla
			sta	$34
			sec
			rts
:l6200			ldy	#$0d
			lda	($24),y
			sta	r11L
			iny

			lda	($24),y
			sta	r11H
			clv
			bvc	l61af
:l620e			bit	l5dd2
			bpl	l6220
:l6213			jsr	l6346
			jsr	l6416
			lda	r1H
			sta	r2L
			jsr	l6225
:l6220			pla
			sta	$34
			clc
			rts
:l6225			lda	r2L
			cmp	r2H
			beq	l622d
:l622b			bcs	l6252
:l622d			lda	$34
			cmp	r2H
			bcs	l6235
:l6233			sta	r2H
:l6235			ldy	#$08
			lda	($24),y
			and	#$10
			beq	l6240
:l623d			jmp	RecoverRectangle
:l6240			lda	$23
			pha
			lda	$22
			pha
			jsr	$2447
			jsr	Rectangle
			pla
			sta	$22
			pla
			sta	$23
:l6252			rts
:l6253			sty	r4L
			ldy	#$0d
			lda	($24),y
			cmp	r11L
			bne	l6276
:l625d			iny
			lda	($24),y
			cmp	r11H
			bne	l6276
:l6264			lda	r4L
			beq	l6276
:l6268			pha
			jsr	l62dc
			jsr	l6313
			pla
			sta	r4L
			dec	r4L
			bne	l6264
:l6276			rts
:l6277			jsr	l6416
			lda	r11H
			sta	r3H
			lda	r11L
			sta	r3L
			lda	r1H
			sta	r2L
			lda	r2L
			cmp	$34
			beq	l628e
:l628c			bcs	l62a5
:l628e			jsr	l635a
			sec
			adc	r2L
			sta	r2H
			lda	r11H
			pha
			lda	r11L
			pha
			jsr	l6225
			pla
			sta	r11L
			pla
			sta	r11H
:l62a5			rts
:l62a6			ldy	#$08
			lda	($24),y
			and	#$10
			beq	l62db
:l62ae			jsr	l6416
			lda	r1H
			sta	r2L
			sta	r2H
			cmp	$34
			beq	l62bd
:l62bb			bcs	l62db
:l62bd			lda	r11H
			cmp	r3H
			bne	l62c7
:l62c3			lda	r11L
			cmp	r3L
:l62c7			beq	l62db
:l62c9			jsr	l6456
			lda	r11H
			pha
			lda	r11L
			pha
			jsr	l6240
			pla
			sta	r11L
			pla
			sta	r11H
:l62db			rts
:l62dc			lda	l5dd1
			cmp	r0H
			bne	l62e8
:l62e3			lda	l5dd0
			cmp	r0L
:l62e8			bne	l62f2
:l62ea			jsr	l644b
			lda	r1H
			sta	stringY
:l62f2			rts
:l62f3			ldy	#$00
			lda	(r0L),y
			and	#$7f
			cmp	#$0d
			bne	l6303
:l62fd			jsr	l62dc
			clv
			bvc	l6306
:l6303			jsr	l6466
:l6306			lda	(r0L),y
			ora	#$80
			sta	(r0L),y
:l630c			inc	r0L
			bne	l6312
:l6310			inc	r0H
:l6312			rts
:l6313			ldy	#$00
			lda	(r0L),y
			and	#$7f
			sta	(r0L),y
			beq	l6329
:l631d			jsr	l632a
			ldy	#$00
			lda	(r0L),y
			jsr	l630c
			cmp	#$00
:l6329			rts
:l632a			tax
			lda	r1H
			pha
			txa
			pha
			ldx	$2e
			lda	#$41
			jsr	GetRealSize
			sec
			adc	r1H
			sta	r1H
			pla
			jsr	PutChar
			pla
			sta	r1H
			jmp	l62a6
:l6346			jsr	l635a
			sec
			adc	r1H
			cmp	$34
			bcc	l6357
:l6350			beq	l6357
:l6352			lda	$34
			clc
			adc	#$01
:l6357			sta	r1H
			rts
:l635a			ldx	$2e
			lda	#$41
			jsr	GetRealSize
			txa
			rts
:l6363			lda	r11H
			sta	r2H
			lda	r11L
			sta	r2L
			ldy	#$0f
			lda	($24),y
			sta	r3L
			iny
			lda	($24),y
			sta	r3H
			ldy	#$00
:l6378			lda	(r0L),y
			and	#$7f
			beq	l63aa
:l637e			sta	r4L
			cmp	#$0d
			beq	l63aa
:l6384			sty	r4H
			ldx	$2e
			jsr	GetRealSize
			tya
			ldy	r4H

			clc
			adc	r2L
			sta	r2L
			bcc	l6397
:l6395			inc	r2H
:l6397			lda	r2H
			cmp	r3H
			bne	l63a1
:l639d			lda	r2L
			cmp	r3L
:l63a1			bcs	l63ab
:l63a3			iny
			lda	r4L
			cmp	#$20
			bne	l6378
:l63aa			clc
:l63ab			rts
:l63ac			jsr	l6406
			ldy	#$12
			lda	($24),y
			sta	r0L
			iny
			lda	($24),y
			sta	r0H
			ora	r0L
			bne	l63c4
:l63be			jsr	UseSystemFont
			clv
			bvc	l63c7
:l63c4			jsr	LoadCharSet
:l63c7			ldy	#$11
			lda	($24),y
			sta	$2e
			ldy	#$0d
			lda	($24),y
			sta	r11L
			iny
			lda	($24),y
			sta	r11H
			ldy	#$0b
			lda	($24),y
			sta	r1H
			ldy	#$00
			lda	($24),y
			sta	r0L
			iny
			lda	($24),y
			sta	r0H
			ldy	#$04
			lda	($24),y
			sta	r4L
			iny
			lda	($24),y
			sta	r4H
			rts
:l63f5			ldy	#$00
:l63f7			lda	(r0L),y
			and	#$7f
			sta	(r0L),y
			beq	l6405
:l63ff			jsr	l630c
			clv
			bvc	l63f7
:l6405			rts
:l6406			ldx	#$08
:l6408			lda	$25,x
			sta	$850b,x
			dex
			bne	l6408
:l6410			lda	$2e
			sta	$8514
			rts
:l6416			ldy	#$0b
			ldx	#$00
:l641a			lda	($24),y
			sta	$06,x
			iny
			inx
			cpx	#$06
			bne	l641a
:l6424			rts
:l6425			lda	$3c
			cmp	r2L
			bcc	l6449
:l642b			cmp	r2H
			beq	l6431
:l642f			bcs	l6449
:l6431			lda	$3a
			ldx	$3b
			cpx	r3H
			bne	l643b
:l6439			cmp	r3L
:l643b			bcc	l6449
:l643d			cpx	r4H
			bne	l6443
:l6441			cmp	r4L
:l6443			beq	l6447
:l6445			bcs	l6449
:l6447			sec
			rts
:l6449			clc
			rts
:l644b			lda	r11H
			sta	$84bf
			lda	r11L
			sta	stringX
			rts
:l6456			lda	r11H
			sta	r4H
			lda	r11L
			sta	r4L
			rts
:l645f			inc	r4L
			bne	l6465
:l6463			inc	r4H
:l6465			rts
:l6466			lda	r0L
			bne	l646c
:l646a			dec	r0H
:l646c			dec	r0L
			rts
:l646f			lda	r3L
			bne	l6475
:l6473			dec	r3H
:l6475			dec	r3L
			rts
:l6478			lda	r4L
			bne	l647e
:l647c			dec	r4H
:l647e			dec	r4L
			rts
:l6481			lda	$041c
			bne	l6498
:l6486			lda	$0406
			sec
			sbc	#$01
			and	#$0f
			cmp	#$05
			bcs	l64b9
:l6492			clc
			adc	#$0f
			clv
			bvc	l649c
:l6498			cmp	#$0f
			bcs	l64b9
:l649c			tax
			lda	$0406
			pha
			lda	l64ba,x
			pha
			lda	l64ce,x
			tax
			pla
			jsr	$58ad
			pla
			and	#$40
			beq	l64b9
:l64b2			ldx	#$65
			lda	#$0a
			jsr	$58ad
:l64b9			rts
:l64ba			b $0a,$15,$20
			b $2e,$3f,$4b
			b $55,$61,$6a
			b $75,$95,$a4
			b $b4,$be,$c7
			b $e2,$ea,$f2
			b $fa,$02
:l64ce			b $2c
			b $2c,$2c,$2c
			b $2c,$2c,$2c
			b $2c,$2c,$2c
			b $2c,$2c,$2c
			b $2c,$2c,$64
			b $64,$64,$64
			b $65,$1b,$80
			b $18,$20,$53
			b $45,$51,$00
			b $1b,$80,$18
			b $20
:l64ee			b $50,$52
			b $47,$00,$1b
			b $80,$18,$20
			b $55,$53,$52
			b $00,$1b,$80
:l64fc			b $18
			b $20,$52,$45
			b $4c,$00,$1b
			b $80
:l6504			b $18
			b $20,$43,$42
			b $4d,$00,$14
			b $fe,$00,$12
			b $20,$13,$00
:l6511			lda	$041c
			beq	l653f
:l6516			lda	r11H
			pha
			lda	r11L
			pha
			lda	$041f
			sec

			jsr	l6540
			lda	$041e
			sec
			jsr	l6540
			lda	$041d
			clc
			jsr	l6540
			pla
			clc
			adc	#$35
			sta	r11L
			pla
			adc	#$00
			sta	r11H
			jsr	l654d
:l653f			rts
:l6540			php
			jsr	l6570
			plp
			bcc	l654c
:l6547			lda	#$2f
			jsr	PutChar
:l654c			rts
:l654d			lda	$0420
			bne	l6554
:l6552			lda	#$0c
:l6554			sta	r0L
			lda	#$4c
			jsr	l6574
			lda	#$2e
			jsr	PutChar
			lda	$0421
			pha
			cmp	#$09
			beq	l656a
:l6568			bcs	l656f
:l656a			lda	#$30
			jsr	PutChar
:l656f			pla
:l6570			sta	r0L
			lda	#$d0
:l6574			ldy	#$00
			sty	r0H
			jmp	PutDecimal
:l657b			lda	#$52
			bne	l6581
:l657f			lda	#$c0
:l6581			pha
			lda	$0422
			sta	r0L
			lda	$0423
			lsr
			ror	r0L
			lsr
			ror	r0L
			sta	r0H
			ora	r0L
			bne	l659a
:l6596			lda	#$01
			sta	r0L
:l659a			pla
			jsr	PutDecimal
			lda	#$4b
			jmp	PutChar
			b $73,$63,$68
			b $72,$65,$69
:l65a9			b $62,$67,$65
			b $73,$63,$68
			b $7d,$74,$7a
			b $74,$00,$44
			b $69,$73,$6b
			b $65,$74,$74
			b $65,$3a,$00
			b $54,$79
:l65c0			b $70,$3a
			b $00,$4b
:l65c4			b $6c,$61,$73
			b $73,$65,$3a
			b $00,$53,$74
			b $72,$75,$6b
			b $74,$75,$72
			b $3a,$00,$47
			b $72,$7c,$7e
			b $65,$3a,$00
			b $67,$65,$7b
			b $6e,$64,$65
			b $72,$74,$3a
			b $00,$41,$75
			b $74,$6f,$72
			b $3a,$00,$53
:l65ee			b $45,$51
			b $55,$45
			b $4e,$54,$49
			b $45,$4c
			b $4c,$00,$56
:l65fa			b $4c,$49,$52
			b $00
:l65fe			b $00

;Endadresse VLIR-Modul testen:
			g vlirModEnd
