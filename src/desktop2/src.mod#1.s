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

			n "obj.mod#1"
			o vlirModBase

:l5b46			jmp	l5b71
:l5b49			jmp	l5b6d
:l5b4c			jmp	l6130
:l5b4f			jmp	l6126
:l5b52			jmp	l5bad
:l5b55			jmp	l5bcf
:l5b58			jmp	l5beb
:l5b5b			jmp	l620d
:l5b5e			jmp	l6273
:l5b61			jmp	l6375
:l5b64			jmp	l63dd
:l5b67			jmp	l6416
:l5b6a			jmp	l6413
:l5b6d			bit	a2H
			bvc	l5bac
:l5b71			jsr	$237e
			jsr	$4183
			bit	a2H
			bpl	l5bac
:l5b7b			lda	a6L
			beq	l5b82
:l5b7f			jmp	$563e
:l5b82			jsr	$3f0c
			lda	a4L
			bne	l5b8f
:l5b89			jsr	$5129
			jmp	$3ffd
:l5b8f			lda	a5H
			sta	r9H
			lda	a5L
			sta	r9L
			ldy	#$16
			lda	(r9L),y
			cmp	#$07
			beq	l5ba7
:l5b9f			ldy	#$05
			jsr	$246b
			jmp	$3ffd
:l5ba7			lda	#$40
			jmp	$3da8
:l5bac			rts
:l5bad			lda	diskOpenFlg
			beq	l5bce
:l5bb2			jsr	$4086
			jsr	OpenDisk
			jsr	$253e
:l5bbb			jsr	$5078
			cmp	#$04
			bcs	l5bce
:l5bc2			sta	$0520
			jsr	l5c8c
			jsr	$59ca
			jmp	$51a8
:l5bce			rts
:l5bcf			jsr	$4086
			jsr	$59e7
			bmi	l5bea
:l5bd7			jsr	$367d
			jsr	l5bfc
			cpx	#$0c
			beq	l5bea
:l5be1			txa
			beq	l5be7
:l5be4			jsr	$259d
:l5be7			jmp	$51a8
:l5bea			rts
:l5beb			jsr	$3337
			lda	a2L
			jsr	$1af1
			jsr	$4819
			jsr	$4839
			jsr	$369a
:l5bfc			lda	curDrive
			clc
			adc	#$39
			sta	$2dee
			lda	#$00
			sta	$8b80
			jsr	$255c
			ldx	#$5c
			lda	#$78
			jsr	$2483
			cmp	#$02
			beq	l5c31
:l5c18			lda	$8b80
			beq	l5c5d
:l5c1d			jsr	NewDisk
			txa
			bne	l5c34
:l5c23			jsr	GetDirHead
			txa
			bne	l5c34
:l5c29			lda	$82bd
			beq	l5c34
:l5c2e			jsr	$5112
:l5c31			ldx	#$0c
			rts
:l5c34			ldy	curDrive
			lda	driveType -8,y
			and	#$0f
			sta	$0521
			cmp	#$02
:l5c41			bne	l5c57
:l5c43			ldx	#$5c
			lda	#$5e
			jsr	$2483
			cmp	#$02
			beq	l5c31
:l5c4e			cmp	#$03
			beq	l5c57
:l5c52			lda	#$01
			sta	$0521
:l5c57			jsr	$59ee
			jmp	l5e9c
:l5c5d			rts
:l5c5e			b $81,$0b
			b $08
			b $10,$de
			b $5f,$0b,$08
			b $20,$00,$60
			b $0b
:l5c6a			b $08
			b $30,$1f
:l5c6d			b $60
			b $03,$01,$48
			b $04,$09,$48
			b $02,$11,$48
			b $00,$81,$0b
			b $08,$20
:l5c7c			b $d8,$2d,$0b
			b $08,$30,$01
			b $2e,$0d,$08
:l5c85			b $40
			b $0c
:l5c87			b $10,$02
:l5c89			b $11,$48
:l5c8b			b $00
:l5c8c			lda	#$00
			sta	r5H
			jsr	NewDisk
			jsr	$253e
			jsr	GetDirHead
			jsr	$253e
			jsr	$1df4
			lda	$0523
			sta	r1L
			lda	#$00
			sta	r1H
			jsr	l5e3b
			jsr	$253e
			lda	$0520
			cmp	#$03
			bne	l5cc4
:l5cb5			lda	$0523
			sta	r1L
			lda	#$01
			sta	r1H
			jsr	l5e3b
			jsr	$253e
:l5cc4			jsr	l5d08
			lda	r1L
			beq	l5cd1
:l5ccb			jsr	l5e3b
			jsr	$253e
:l5cd1			jsr	$361e
			jsr	$253e
			lda	$0523
			sta	r1L
			lda	$0524
			sta	r1H
:l5ce1			jsr	l5d13
			jsr	$253e
			lda	$8a81
			sta	r1H
			lda	$8a80
			sta	r1L
			lda	r1L
			bne	l5ce1
:l5cf5			jsr	l5d08
			lda	r1L
			beq	l5d02
:l5cfc			jsr	l5d13
			jsr	$253e
:l5d02			sta	r5H
			jsr	PutDirHead

			rts
:l5d08			lda	$82ac
			sta	r1H
			lda	$82ab
			sta	r1L
			rts
:l5d13			lda	#$00
			sta	r5H
			jsr	$5a1d
			jsr	GetBlock
			jsr	$253e
			lda	#$8a
			sta	r5H
			lda	#$82
			sta	r5L
			lda	#$08
			sta	r10L
			lda	r1H
			pha
			lda	r1L
			pha
:l5d32			jsr	l5d56
			txa
			bne	l5d53
:l5d38			clc
			lda	#$20
			adc	r5L
			sta	r5L
			bcc	l5d43
:l5d41			inc	r5H
:l5d43			dec	r10L
			bne	l5d32
:l5d47			pla
			sta	r1L
			pla
			sta	r1H
			jsr	$5a1d
			jmp	PutBlock
:l5d53			pla
			pla
			rts
:l5d56			ldx	#$00
			ldy	#$00
			sty	r9H
			sty	r9L
			lda	(r5L),y
			beq	l5d97
:l5d62			bmi	l5d6a
:l5d64			tya
			sta	(r5L),y
			tax
			beq	l5d97
:l5d6a			and	#$0f
			cmp	#$05
			beq	l5da7
:l5d70			jsr	l5df6
			txa
			bne	l5d97
:l5d76			ldy	#$01
			lda	(r5L),y
			sta	r1L
			iny
			lda	(r5L),y
			sta	r1H
			jsr	l5e3b
			txa
			bne	l5d97
:l5d87			ldy	#$13
			lda	(r5L),y
			beq	l5d97
:l5d8d			sta	r1L
			iny
			lda	(r5L),y
			sta	r1H
			jsr	l5e3b
:l5d97			cpx	#$00
			bne	l5da6
:l5d9b			ldy	#$1c
			lda	r9L
			sta	(r5L),y
			iny
			lda	r9H
			sta	(r5L),y
:l5da6			rts
:l5da7			lda	$0520
			cmp	#$03
			beq	l5db1
:l5dae			ldx	#$00
			rts
:l5db1			ldy	#$01
			lda	(r5L),y
			sta	r1L
			iny
			lda	(r5L),y
			sec
			sbc	#$01
			sta	r1H
			ldy	#$1c
			lda	(r5L),y
			sta	r12L
			iny
			lda	(r5L),y
			sta	r12H
:l5dca			ldx	#$00
			lda	r12H
			ora	r12L
			beq	l5df5
:l5dd2			inc	r1H
			lda	r1H
			cmp	#$28
			bcc	l5de0
:l5dda			lda	#$00
			sta	r1H
			inc	r1L
:l5de0			ldx	#$02
			lda	r1L
			beq	l5df5
:l5de6			cmp	#$51
			bcs	l5df5
:l5dea			jsr	$3649
			ldx	#$1a
			jsr	Ddec
			clv
			bvc	l5dca
:l5df5			rts
:l5df6			ldx	#$00
			ldy	#$15
			lda	(r5L),y
			cmp	#$01
			bne	l5e3a
:l5e00			ldy	#$01
			lda	(r5L),y
			sta	r1L
			iny
			lda	(r5L),y
			sta	r1H
			lda	#$81
			sta	r4H
			lda	#$00
			sta	r4L
			jsr	GetBlock
			jsr	$253e
			ldy	#$02
:l5e1b			tya
			pha
			lda	$8100,y
			sta	r1L
			iny
			lda	$8100,y
			sta	r1H
			ldx	#$00
			lda	r1L
			beq	l5e31
:l5e2e			jsr	l5e3b
:l5e31			pla
			tay
			jsr	$253e
			iny
			iny
			bne	l5e1b
:l5e3a			rts
:l5e3b			jsr	EnterTurbo
			txa
			bne	l5e79
:l5e41			jsr	InitForIO
:l5e44			lda	#$80
			sta	r4H
			lda	#$00
			sta	r4L
			lda	$0520
			cmp	#$02
			bcc	l5e59
:l5e53			jsr	ReadLink
			clv
			bvc	l5e5c
:l5e59			jsr	ReadBlock
:l5e5c			txa
			bne	l5e79
:l5e5f			inc	r9L
			bne	l5e65
:l5e63			inc	r9H
:l5e65			jsr	$3649
			txa
			bne	l5e79
:l5e6b			lda	$8001
			sta	r1H
			lda	diskBlkBuf
			sta	r1L
			bne	l5e44
:l5e77			ldx	#$00
:l5e79			jmp	DoneWithIO
:l5e7c			b $00,$00,$00
:l5e7f			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$00
			b $00,$00

:l5e9c			ldy	curDrive
			lda	driveType -8,y
			and	#$0f
			pha
			cmp	#$01
			beq	l5eab
:l5ea9			bcs	l5eb6
:l5eab			lda	#$23
			sta	r1L
			lda	#$00
			sta	r1H
			jsr	$1de3
:l5eb6			ldy	#$00
			lda	#$4e
			sta	l5e7c,y
			iny
			lda	#$30
			sta	l5e7c,y
			iny
			lda	#$3a
			sta	l5e7c,y
			ldy	#$00
:l5ecb			lda	(r0L),y
			sta	l5e7f,y
			beq	l5ed5
:l5ed2			iny
			bne	l5ecb
:l5ed5			lda	#$2c
			sta	l5e7f,y
			iny
			lda	minutes
			and	#$0f
			adc	#$41
			sta	l5e7f,y
			iny
			lda	seconds
			and	#$0f
			adc	#$41
			sta	l5e7f,y
			iny
			lda	#$ff
			sta	l5e7f,y
			jsr	PurgeTurbo
			jsr	InitForIO
			pla
			sta	r4L
			cmp	#$02
			bne	l5f16
:l5f03			lda	$0521
			clc
			adc	#$2f
			sta	l5f47
			ldy	#$5f
			lda	#$43
			jsr	l5f51
			txa
			bne	l5f33
:l5f16			lda	r4L
			cmp	#$03
			bcs	l5f26
:l5f1c			ldy	#$5f
			lda	#$49
			jsr	l5f51
			txa
			bne	l5f33
:l5f26			ldy	#$5e
			lda	#$7c
			jsr	l5f51
			txa
			bne	l5f33
:l5f30			jsr	l5f94
:l5f33			jsr	DoneWithIO
			txa
			bne	l5f42
:l5f39			jsr	NewDisk
			txa
			bne	l5f42
:l5f3f			jsr	SetGEOSDisk
:l5f42			rts
			b $55
:l5f44			b $30,$3e,$4d
:l5f47			b $31,$ff,$4d
			b $2d,$57,$22
			b $00,$01,$00
			b $ff
:l5f51			sty	r0H
			sta	r0L
			lda	#$00
			sta	$90
			lda	curDrive
			jsr	LISTEN
			bit	$90
			bmi	l5f8e
:l5f63			lda	#$ff
			jsr	SECOND
			bit	$90
			bmi	l5f8e
:l5f6c			ldy	#$00
:l5f6e			lda	(r0L),y
			cmp	#$ff
			beq	l5f7a
:l5f74			jsr	CIOUT
			iny
			bne	l5f6e
:l5f7a			jsr	UNLSN
			lda	curDrive
			jsr	LISTEN
:l5f83			lda	#$ef
			jsr	SECOND
			jsr	UNLSN
			ldx	#$00
			rts
:l5f8e			jsr	UNLSN
			ldx	#$0d
			rts
:l5f94			lda	#$00
			sta	$90
			lda	curDrive
			jsr	TALK
			bit	$90
			bmi	l5fd7
:l5fa2			lda	#$ff
			jsr	TKSA
			bit	$90
			bmi	l5fd7
:l5fab			jsr	ACPTR
			and	#$0f
			asl
			asl
			asl
			asl
			sta	l5fdd
			jsr	ACPTR
			and	#$0f
			ora	l5fdd
			sta	l5fdd
			jsr	UNTALK
			lda	curDrive
			jsr	LISTEN
			lda	#$ef
			jsr	SECOND
			jsr	UNLSN
			ldx	l5fdd
			rts
:l5fd7			jsr	UNTALK
			ldx	#$0d
			rts
:l5fdd			b $00,$18,$53
			b $6f
:l5fe1			b $6c,$6c,$65
			b $6e,$20,$62
			b $65,$69,$64
			b $65,$20,$53
			b $65,$69,$74
			b $65,$6e,$20
			b $64,$65,$72
			b $20,$44,$69
			b $73,$6b,$65
			b $74,$74
:l5ffe			b $65,$00
:l6000			b $66,$6f
			b $72,$6d,$61
			b $74,$69,$65
			b $72,$74,$20
			b $77,$65,$72
			b $64,$65,$6e
			b $3f,$20,$20
			b $56,$6f,$72
			b $73,$69,$63
			b $68,$74,$3a
			b $20,$00,$44
			b $61,$74,$65
			b $6e,$20,$61
			b $75,$66,$20
			b $64,$65,$72
			b $20,$52,$7d
			b $63,$6b,$73
			b $65,$69,$74
			b $65,$16,$48
			b $00,$60,$67
			b $65,$68,$65
			b $6e,$20,$68
			b $69,$65,$72
			b $62,$65,$69
			b $20,$76
:l6049			b $65,$72
			b $6c,$6f,$72
			b $65,$6e,$2e
			b $00,$18,$49
			b $6d,$20,$4d
			b $6f,$6d,$65
			b $6e,$74,$20
			b $6b,$65,$69
			b $6e,$65,$20
			b $77,$69,$65
			b $64,$65,$72
			b $68,$65,$72
			b $2d,$00,$73
			b $74
:l6070			b $65,$6c
			b $6c,$62,$61
			b $72,$65,$20

			b $44,$61,$74
			b $65,$69,$20
			b $76,$6f,$72
			b $68,$61,$6e
			b $64,$65,$6e
			b $2e,$1b,$00
			b $18,$42,$69
			b $74,$74,$65
			b $20,$44,$69
			b $73,$6b,$65
			b $74,$74,$65
			b $20,$7a,$75
			b $6d,$20
:l609e			b $4c,$7c,$73
			b $63,$68,$65
			b $6e,$00,$69
			b $6e,$20
:l60a9			b $4c,$61,$75
			b $66,$77,$65
			b $72,$6b,$20
:l60b2			b $00,$20,$65
:l60b5			b $69,$6e
			b $6c,$65,$67
			b $65,$6e,$2e
			b $00,$18,$49
:l60c0			b $6e,$68,$61
			b $6c,$74,$20
			b $64,$65,$72
			b $20,$52,$41
			b $4d,$2d,$44
			b $69,$73,$6b
			b $20
:l60d3			b $6c,$7c,$73
			b $63,$68,$65
			b $6e,$3f,$00
			b $18,$41,$75
			b $73,$67,$65
			b $77,$7b
:l60e4			b $68
			b $6c,$74,$65
			b $20,$44,$61
			b $74,$65,$69
			b $65,$6e,$20
:l60f1			b $6c,$7c,$73
			b $63,$68,$65
			b $6e,$3f,$00
			b $18,$44,$61
			b $74,$65,$69
			b $20,$73,$63
			b $68,$72,$65
			b $69,$62,$67
			b $65,$73,$63
			b $68,$7d,$74
			b $7a,$74,$20
			b $75,$6e,$64
			b $00,$6e,$69
			b $63,$68,$74
			b $20
:l611c			b $6c,$7c,$73
			b $63,$68,$62
			b $61,$72,$2e
			b $00
:l6126			jsr	$237e
			bit	a2H
			bvs	l6138
:l612d			jmp	$54e0
:l6130			jsr	$237e
			bit	a2H
			bmi	l6138
:l6137			rts
:l6138			lda	a2H
			and	#$20
			bne	l6149
:l613e			lda	$82bd
			beq	l6149
:l6143			jsr	$5112
			jmp	$4086
:l6149			lda	a6L
			beq	l615b
:l614d			ldx	#$61
			lda	#$e8
			jsr	$2483
			cmp	#$02
			bne	l615b
:l6158			jmp	$4086
:l615b			ldx	#$61
			lda	#$62
			jmp	$55af
:l6162			lda	a3L
:l6164			sta	a3H
			jsr	$5122
			lda	a3H
			ldx	#$14
			jsr	$467e
			ldy	#$00
			lda	(r9L),y
			and	#$40
			beq	l6193
:l6178			jsr	l61df
			clc
			lda	#$03
			adc	r0L
			sta	r0L
			bcc	l6186
:l6184			inc	r0H
:l6186			jsr	$583c
			ldx	#$61
			lda	#$f5
			jsr	$2483
			jmp	$3ffd
:l6193			ldy	#$00
			lda	(r9L),y
			and	#$0f
			cmp	#$05
			beq	l61cc
:l619d			lda	r9H
			pha
			lda	r9L
:l61a2			pha
			lda	#$ff
			sta	a8H
			lda	r9H
			sta	r4H
			lda	r9L
			sta	r4L
			lda	#$18
			sta	r5H
			lda	#$94
			sta	r5L
			jsr	$4526
			jsr	$5984
			jsr	l61df
			jsr	$595f
			pla
			sta	r9L
			pla
			sta	r9H
			jsr	FreeFile
:l61cc			lda	a3H
			jsr	$4618
			lda	a3H
			jsr	$3afc
			jsr	$59ca
			jsr	$4003
			jmp	$31d1
:l61df			lda	r9H
			sta	r0H
			lda	r9L
			sta	r0L
			rts
:l61e8			b $81,$0b
			b $10,$20
			b $dc,$60,$01
			b $01,$48,$02
			b $11,$48,$00
:l61f5			b $81,$0b
			b $10,$10
			b $a9
:l61fa			b $2d,$0c,$2e,$10,$0e
			b $0b
:l6200			b $10,$20
			b $fa,$60,$0b
:l6205			b $10,$30
:l6207			b $16,$61
:l6209			b $01,$11
			b $48
:l620c			b $00
:l620d			lda	diskOpenFlg
			beq	l6272
:l6212			jsr	$5954
			bcc	l6272
:l6217			jsr	$237e
			jsr	$59d8
			jsr	$4086
			lda	a8H
:l6222			bne	l6237
:l6224			lda	#$60
			sta	r5H
			lda	#$52
			sta	r5L
			lda	#$60
			sta	r6H
			lda	#$6e
			sta	r6L
			jmp	$247f
:l6237			lda	#$00
			sta	a8H
			jsr	$5984
			lda	a0L
			sta	r10L
			jsr	GetFreeDirBlk
			jsr	$59ca
			tya
			clc
			adc	#$00
			sta	r5L
			lda	r10L
			adc	#$6d
			sta	r5H
			lda	#$18
			sta	r4H
			lda	#$94

			sta	r4L
			jsr	$4526
			jsr	l5d56
			jsr	PutDirHead
			jsr	$59ca
			lda	r10L
			sta	a0L
			jsr	$42b2
			jmp	$3228
:l6272			rts
:l6273			jsr	$367d
			jsr	$59e7
			bpl	l6289
:l627b			ldx	#$63
			lda	#$28
			jsr	$2483
			cmp	#$02
			bne	l629e
:l6286			jmp	$31ec
:l6289			lda	curDrive
			clc
			adc	#$39
			sta	l60b2
			ldx	#$63
			lda	#$16
			jsr	$2483
			cmp	#$02
			bne	l629e
:l629d			rts
:l629e			jsr	OpenDisk
			jsr	$59ca
			lda	$82bd
			beq	l62ac
:l62a9			jmp	$5112
:l62ac			lda	#$00
			sta	a0L
			jsr	$58d4
			lda	r0H
			sta	r4H
			lda	r0L
			sta	r4L
			ldy	#$00
			tya
			sta	(r0L),y
			iny
			lda	#$ff
			sta	(r0L),y
			jsr	l62e8
			jsr	$3aac
			sty	r1H
			jsr	PutBlock
			jsr	$59ca
			lda	#$7f
			sta	r0H
			lda	#$00
			sta	r0L
			jsr	l62e8
			jsr	$3b00
			lda	#$00
			sta	a1L
			jmp	l5bbb
:l62e8			clc
			lda	#$02
			adc	r0L
			sta	r0L
			bcc	l62f3
:l62f1			inc	r0H
:l62f3			ldy	#$00
			ldx	#$07
:l62f7			lda	#$00
			sta	(r0L),y
			clc
			lda	#$20
			adc	r0L
			sta	r0L
			bcc	l6306
:l6304			inc	r0H
:l6306			dex
			bpl	l62f7
:l6309			rts
:l630a			jsr	FindBAMBit
			lda	$8200,x
			eor	r8H
			sta	$8200,x
			rts
:l6316			b $81,$0b
			b $10,$20
:l631a			b $8a,$60
			b $0b
:l631d			b $10,$30
:l631f			b $a6,$60
			b $01,$01
			b $48
			b $02,$11,$48
			b $00
:l6328			b $81,$0b
			b $10,$20
			b $be,$60,$01
			b $01,$48,$02
			b $11,$48,$00
:l6335			tay
			lda	$45f0,y
			sta	r2L
:l633b			clc
			adc	#$15
			sta	r2H
			lda	$45e8,y
			sta	r3L
			lda	#$00
			sta	r3H
			ldx	#$03
:l634b			clc
:l634c			rol	r3L
			rol	r3H
:l6350			dex
			bne	l634b
:l6353			lda	r3L
			clc
			adc	#$18
			sta	r4L
			lda	r3H
			adc	#$00
			sta	r4H
			rts
:l6361			lda	#$07
:l6363			pha
			jsr	l6335
			jsr	IsMseInRegion
			bne	l6373
:l636c			pla
			sec
			sbc	#$01
			bpl	l6363
:l6372			rts
:l6373			pla
			rts
:l6375			jsr	l6361
			bmi	l63da
:l637a			sta	r4L
			lda	a6L
			bne	l63da
:l6380			lda	r4L
			cmp	a3L
			beq	l63da
:l6386			jsr	$477b
			cmp	#$0c
			bne	l6390
:l638d			jmp	$5139
:l6390			lda	r4L
			ldx	#$0a
			jsr	$467e
			ldy	#$16
			lda	(r4L),y
			cmp	#$0c
			beq	l638d
:l639f			lda	#$04
			sta	r5H
			lda	#$06
			sta	r5L
			jsr	$4526
			lda	r4H
			sta	r5H
			lda	r4L
			sta	r5L
			jsr	$58cb
			jsr	$4526
			lda	#$04
			sta	r4H
			lda	#$06
			sta	r4L
			lda	a5H
			sta	r5H
			lda	a5L
			sta	r5L
			jsr	$4526
			jsr	$42b2
			txa
			bne	l63da
:l63d1			jsr	$4003
			jsr	$3bdf
			ldx	#$00
			rts
:l63da			ldx	#$ff
			rts
:l63dd			lda	diskOpenFlg
			beq	l63fc
:l63e2			jsr	$4183
			jsr	$5954
			bcc	l63fc
:l63ea			lda	#$00
:l63ec			pha
			jsr	$4b16
			jsr	l6416
			txa
			bne	l63fb
:l63f6			jsr	$59ac
			bne	l63fd
:l63fb			pla
:l63fc			rts
:l63fd			pla
			clc

			adc	#$01
			cmp	a1L
			bcc	l63ec
:l6405			beq	l63ec
:l6407			bit	a2H
			bpl	l640e
:l640b			jmp	$41b5
:l640e			lda	#$00
			jmp	$4b16
:l6413			lda	#$08
			b $2c
:l6416			lda	#$00
			pha
			jsr	$4183
			pla
			tay
			lda	diskOpenFlg
			beq	l6450
:l6423			jsr	$5954
			bcc	l6450
:l6428			tya
			pha
			clc
			adc	#$07
			sta	l6451
			pla
:l6431			pha
			jsr	$4890
			beq	l6443
:l6437			pla
			pha
			jsr	$405d
			bne	l6443
:l643e			sta	r0L
			jsr	$5350
:l6443			pla
			clc
			adc	#$01
			cmp	l6451
			bcc	l6431
:l644c			beq	l6431
:l644e			ldx	#$00
:l6450			rts
:l6451			b $00

;Endadresse VLIR-Modul testen:
			g vlirModEnd
