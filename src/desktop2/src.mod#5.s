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

			n "obj.mod#5"
			o vlirModBase

:l5b46			jmp	l5b4f
:l5b49			jmp	l5fc8
:l5b4c			jmp	l6049
:l5b4f			jsr	MouseOff
			php
			sei
			jsr	$5680
			lda	$84a4
			sta	l5f44
			lda	keyVector
			sta	l5f43
			lda	#$5b
			sta	$84a4
			lda	#$94
			sta	keyVector
			lda	#$ff
			sta	l5f4a
			jsr	l5b7c
			lda	#$ff
			sta	$0250
			plp
			rts
:l5b7c			lda	#$00
			sta	l5f46
			lda	#$f5
			sta	l5f45
			lda	#$00
			sta	l5f47
			lda	$1942
			sta	l5f48
			jmp	l5e2a
:l5b94			lda	keyData
			cmp	#$0d
			bne	l5b9e
:l5b9b			jmp	l5e68
:l5b9e			cmp	#$20
			bne	l5ba5
:l5ba2			jmp	l5d95
:l5ba5			cmp	#$1d
			bne	l5bac
:l5ba9			jmp	l5e01
:l5bac			cmp	#$1e
			bne	l5bb3
:l5bb0			jmp	l5d95
:l5bb3			cmp	#$08
			bne	l5bba
:l5bb7			jmp	l5e01
:l5bba			sta	l5f42
			sec
			sbc	#$30
			bmi	l5bc9
:l5bc2			cmp	#$0a
			bpl	l5bc9
:l5bc6			jmp	l5bca
:l5bc9			rts
:l5bca			lda	#$5b
			sta	r0H
			lda	#$e7
			sta	r0L
			lda	l5f47
			asl
			asl
			sta	r1L
			lda	r1L
			clc
			adc	r0L
			sta	r0L
			bcc	l5be4
:l5be2			inc	r0H
:l5be4			jmp	($0002)
:l5be7			jmp	l5c89
:l5bea			nop
			jmp	l5cd7
:l5bee			nop
			jmp	l5c22
:l5bf2			nop
			jmp	l5c2f
:l5bf6			nop
			jmp	l5c68
:l5bfa			nop
			jmp	l5c22
:l5bfe			nop
			jmp	l5d1c
:l5c02			nop
			jmp	l5d28
:l5c06			nop
			jmp	l5c22
:l5c0a			nop
			jmp	l5c22
:l5c0e			nop
			jmp	l5d34
:l5c12			nop
			jmp	l5d5e
:l5c16			nop
			jmp	l5c22
:l5c1a			nop
			jmp	l5d78
:l5c1e			nop
			jmp	l5d89
:l5c22			rts
:l5c23			jsr	l5e2a
			jmp	$575b
:l5c29			jsr	l5e2a
			jmp	$577b
:l5c2f			lda	l5f42
			tax
			cpx	#$31
			beq	l5c47
:l5c37			cpx	#$30
			bne	l5c67
:l5c3b			cpx	$1946
			bne	l5c47
:l5c40			pha
			lda	#$31
			sta	$1946
			pla
:l5c47			sta	$1945
			jsr	l5c29
			jsr	l5d98
			lda	$1945
			cmp	#$30
			beq	l5c67
:l5c57			lda	#$32
			cmp	$1946
			bcs	l5c67
:l5c5e			sta	$1946
			jsr	l5c29
			jmp	l5e2a
:l5c67			rts
:l5c68			lda	$1945
			cmp	#$30
			beq	l5c78
:l5c6f			lda	l5f42
			cmp	#$33
			bcs	l5c88
:l5c76			bcc	l5c7f
:l5c78			lda	l5f42
			cmp	#$30
			beq	l5c88
:l5c7f			sta	$1946
			jsr	l5c29
			jmp	l5d98
:l5c88			rts
:l5c89			lda	#$30
			cmp	l5f42
			bne	l5c9a
:l5c90			cmp	$1943
			bne	l5c9a
:l5c95			lda	#$31
			sta	$1943
:l5c9a			lda	$1946
			ldx	$1945
			jsr	l5f08
			tax
			dex
			lda	l5ccb,x
			cmp	l5f42
			bmi	l5cca
:l5cad			beq	l5cb1
:l5caf			bcs	l5cbe
:l5cb1			lda	l5d10,x
			cmp	$1943
			bpl	l5cbe
:l5cb9			lda	#$30
			sta	$1943
:l5cbe			lda	l5f42
			sta	$1942
			jsr	l5c29
			jmp	l5d98
:l5cca			rts
:l5ccb			b $33,$32,$33
			b $33,$33,$33
			b $33,$33,$33
			b $33,$33,$33
:l5cd7			lda	$1946
			ldx	$1945
			jsr	l5f08
			tax
			dex
			lda	l5ccb,x
			cmp	$1942
			bne	l5cf5
:l5cea			lda	l5d10,x
			cmp	l5f42
			bmi	l5d0f
:l5cf2			jmp	l5d03
:l5cf5			lda	$1942
			cmp	#$30
			bne	l5d03
:l5cfc			lda	l5f42
			cmp	#$30
			beq	l5d0f
:l5d03			lda	l5f42
			sta	$1943

			jsr	l5c29
			jmp	l5d98
:l5d0f			rts
:l5d10			b $31,$39
			b $31,$30
			b $31,$30
			b $31,$31
			b $30,$31
:l5d1a			b $30,$31
:l5d1c			lda	l5f42
			sta	$1948
			jsr	l5c29
			jmp	l5d98
:l5d28			lda	l5f42
			sta	$1949
			jsr	l5c29
			jmp	l5d98
:l5d34			lda	l5f42
			cmp	#$33
			bpl	l5d5d
:l5d3b			sta	$194c
			jsr	l5c23
			jsr	l5d98
			lda	$194c
			cmp	#$32
			bne	l5d5d
:l5d4b			lda	$194d
:l5d4e			cmp	#$34
			bcc	l5d5d
:l5d52			lda	#$30
			sta	$194d
			jsr	l5c23
			jmp	l5e2a
:l5d5d			rts
:l5d5e			lda	$194c
			cmp	#$32
			php
			lda	l5f42
			plp
			bne	l5d6e
:l5d6a			cmp	#$34
			bcs	l5d77
:l5d6e			sta	$194d
			jsr	l5c23
			jmp	l5d98
:l5d77			rts
:l5d78			lda	l5f42
			cmp	#$36
			bpl	l5d88
:l5d7f			sta	$194f
			jsr	l5c23
			jmp	l5d98
:l5d88			rts
:l5d89			lda	l5f42
			sta	$1950
			jsr	l5c23
			jmp	l5d98
:l5d95			jsr	l5e2a
:l5d98			ldx	l5f47
			lda	l5ddf,x
			bpl	l5da6
:l5da0			jsr	l5b7c
			clv
			bvc	l5dde
:l5da6			tay
:l5da7			tya
			pha
			lda	$1942,x
			jsr	GetCharWidth
			clc
			adc	l5f45
			sta	l5f45
			bcc	l5dbb
:l5db8			inc	l5f46
:l5dbb			inx
			pla
			tay
			dey
			bne	l5da7
:l5dc1			stx	l5f47
			cpx	#$0a
			bne	l5dd2
:l5dc8			lda	#$01
			sta	l5f46
			lda	#$26
			sta	l5f45
:l5dd2			ldx	l5f47
			lda	$1942,x
			sta	l5f48
			jmp	l5e2a
:l5dde			rts
:l5ddf			b $01,$02,$01
			b $01,$02,$01
			b $01,$03,$02
			b $01,$01,$02
			b $01,$01,$f2
			b $f1
:l5def			b $f0
:l5df0			b $0e
			b $ff,$ff,$fe
			b $ff,$ff,$fe
			b $ff,$ff,$fe
			b $fd,$ff,$ff
			b $fe,$ff
:l5dff			b $ff
			b $fe
:l5e01			jsr	l5e2a
			lda	l5f47
			tax
			clc
			adc	l5df0,x
			sta	l5f49
			lda	#$00
			sta	l5f4a
			jsr	l5b7c
:l5e17			jsr	l5d98
:l5e1a			lda	l5f47
			cmp	l5f49
			bne	l5e17
:l5e22			lda	#$ff
			sta	l5f4a
			jmp	l5e2a
:l5e2a			lda	l5f4a
			beq	l5e67
:l5e2f			php
			sei
			lda	$01
			pha
			lda	#$30
			sta	$01
			lda	#$02
			sta	r2L
			lda	#$0a
			sta	r2H
			lda	l5f45
			sta	r3L
			sta	r4L
			lda	l5f46
			sta	r3H
			sta	r4H
			ldx	l5f47
			lda	l5f48
			jsr	GetCharWidth
			clc
			adc	r4L
			sta	r4L
			bcc	l5e60
:l5e5e			inc	r4H
:l5e60			jsr	InvertRectangle
			pla
			sta	$01
			plp
:l5e67			rts
:l5e68			php
			sei
			lda	$01
			pha
			lda	#$35
			sta	$01
			lda	$dc0f
			and	#$7f
			sta	$dc0f
			jsr	l5ef1
			lda	r1L
			cmp	#$13
			bcc	l5e89
:l5e82			sed
			sec
			sbc	#$12
			cld
			ora	#$80
:l5e89			sta	$dc0b
			lda	r1L
			jsr	l5f2e
			sta	hour
			lda	r1H
			sta	$dc0a
			jsr	l5f2e
			sta	minutes
			lda	#$00
			sta	$dc09
			sta	seconds
			sta	$dc08
			pla
			sta	$01
			ldy	#$00
			ldx	$1945
			lda	$1946
			jsr	l5f08
			sta	month
			iny
			ldx	$1942
			lda	$1943
			jsr	l5f08
			sta	day
			iny
			ldx	$1948
			lda	$1949
			jsr	l5f08
			sta	year
			jsr	l5e2a
			lda	l5f44

			sta	$84a4
			lda	l5f43
			sta	keyVector
			lda	#$00
			sta	$0250
			jsr	$5671
			jsr	MouseUp
			plp
			rts
:l5ef1			ldx	$194c
			lda	$194d
			jsr	l5f1e
			sta	r1L
			ldx	$194f
			lda	$1950
			jsr	l5f1e
			sta	r1H
			rts
:l5f08			pha
			txa
			sec
			sbc	#$30
			tax
			pla
			sec
			sbc	#$30
:l5f12			dex
			bmi	l5f1a
:l5f15			clc
			adc	#$0a
			bne	l5f12
:l5f1a			rts
:l5f1b			jsr	$57b0
:l5f1e			sec
			sbc	#$30
			sta	r2H
			txa
			sec
			sbc	#$30
			asl
			asl
			asl
			asl
			ora	r2H
			rts
:l5f2e			pha
			and	#$f0
			lsr
			lsr
			lsr
			lsr
			tay
			pla
			and	#$0f
			clc
:l5f3a			dey
			bmi	l5f41
:l5f3d			adc	#$0a
			bne	l5f3a
:l5f41			rts
:l5f42			b $00
:l5f43			b $00
:l5f44			b $00
:l5f45			b $00
:l5f46			b $00
:l5f47			b $00
:l5f48			b $00
:l5f49			b $00
:l5f4a			b $00
			b $18,$64,$65
			b $73,$6b,$54
			b $6f
:l5f52			b $70,$20
:l5f54			b $56,$32
			b $2e,$30,$20
			b $6c,$7b,$75
			b $66,$74,$20
			b $6e,$75,$72
			b $20,$61,$75
			b $66,$00,$47
			b $45,$4f,$53
			b $2d,$4b,$65
			b $72,$6e,$61
:l5f71			b $6c,$73,$20
:l5f74			b $61,$62
			b $20,$56,$32
			b $2e,$30,$2e
			b $20,$20,$44
			b $69,$73
			b $6b,$20,$6d
			b $69,$74,$00
			b $64,$65,$73
			b $6b,$54,$6f
:l5f8d			b $70,$20
:l5f8f			b $56,$31
			b $2e,$33,$20
			b $65,$69
			b $6e,$6c,$65
			b $67,$65,$6e
			b $2c,$20,$6f
			b $64,$65,$72
			b $20,$65,$72
			b $6e,$65,$75
			b $74,$00,$62
			b $6f,$6f,$74
			b $65
:l5faf			b $6e,$20,$28
			b $61,$62
			b $65,$72
			b $20,$6d,$69
			b $74,$20,$47
			b $45,$4f,$53
:l5fbf			b $20,$56
:l5fc1			b $32
			b $2e,$30,$29
			b $2e,$00,$00
:l5fc8			jsr	l5fdc
			jsr	$2518
			lda	#$80
			sta	$2f
			ldx	#$60
			lda	#$2b
			jsr	$2483
			jmp	$23d6
:l5fdc			jsr	$3296
			jsr	$3a60
			jsr	$59ca
			lda	#$00
			sta	r0L
			sta	$0256
			sta	r9H
			sta	r3L
			lda	#$0a
			sta	r1H
			lda	#$62
			sta	r1L
			lda	#$6d
			sta	r2H
:l5ffc			ldy	#$00
			sty	r2L
			lda	(r2L),y
			pha
:l6003			jsr	$3985
			clc
			lda	#$20
			adc	r2L
:l600b			sta	r2L
			bcc	l6011
:l600f			inc	r2H
:l6011			lda	r2L
			bne	l6003
:l6015			pla
			bne	l5ffc
:l6018			lda	isGEOS
			beq	l6028
:l601d			lda	#$7f
			cmp	r2H
			bcc	l6028
:l6023			sta	r2H
			clv
			bvc	l5ffc
:l6028			jmp	$326f
			b $81,$0b,$05
:l602e			b $10,$4b
			b $5f,$0b,$05
			b $20,$67,$5f
			b $0b,$05
:l6038			b $30,$87
			b $5f,$0b,$05
			b $40,$aa,$5f
			b $0b,$05
:l6042			b $50,$c7
			b $5f,$01,$11
			b $48,$00
:l6049			jsr	$26fd
			lda	#$60
			sta	r0H
			lda	#$5a
			sta	r0L
			jsr	DoDlgBox
			jmp	$51a8
:l605a			b $01,$10,$be
			b $08,$00,$30
			b $01,$0e
:l6062			b $0b
:l6063			b $10,$0b
:l6065			b $ae,$60,$0b
			b $10,$16
			b $c5,$60,$0b
			b $1a
:l606e			b $21,$dd
:l6070			b $60
			b $0b,$1a,$2c
			b $09
:l6075			b $61,$0b
			b $10,$37
:l6079			b $40
			b $61
:l607b			b $0b,$1a
			b $42,$65,$61
:l6080			b $0b,$1a,$4d
			b $9e

:l6084			b $61,$0b
			b $10,$58
			b $d4,$61,$0b
			b $1a,$63,$03
			b $62,$0b,$1a
			b $6e,$2b,$62
			b $0b
:l6095			b $10,$79
:l6097			b $56,$62
			b $0b,$1a,$84
			b $86,$62,$0b
			b $1a,$8f,$b5
			b $62,$0b,$1a
			b $9a,$df,$62
			b $0b,$1a,$a5
			b $f7,$62,$00
			b $18,$57
:l60b0			b $45,$49
			b $54,$45,$52
			b $45,$20,$54
			b $41,$53,$54
			b $45,$4e,$4b
			b $5d,$52,$5a
			b $45
:l60c2			b $4c,$3a,$00
			b $0e
:l60c6			b $18,$4c,$61,$75
			b $66,$77,$65
			b $72,$6b,$73
			b $62,$65,$68
			b $61,$6e,$64
:l60d6			b $6c,$75,$6e
			b $67,$3a,$0f
			b $00,$18,$43
			b $3d
:l60e0			b $20,$41,$1b
			b $20,$75,$6e
			b $64,$20,$18
			b $43,$3d,$20
			b $42,$1b,$20
			b $7c,$66,$66
			b $6e,$65,$74
			b $20
:l60f6			b $4c,$61,$75
			b $66,$77,$65
			b $72,$6b,$20
			b $41,$20,$62
			b $7a,$77,$2e
			b $20,$42,$2e
			b $00,$18,$43
			b $3d,$20,$53
			b $68,$69
:l6110			b $66,$74
			b $20,$41,$1b
			b $20,$75,$6e
			b $64,$20,$18
			b $43,$3d,$20
			b $53,$68
:l6120			b $69
			b $66,$74,$20
			b $42,$1b,$20
			b $74
:l6128			b $61,$75
			b $73,$63,$68
			b $65,$6e,$20
			b $6d,$69,$74
			b $20
:l6134			b $4c,$61,$75
			b $66,$77,$65
			b $72,$6b,$20
			b $43,$2e,$00
			b $0e,$18,$44
			b $61,$74,$65
			b $69,$2d,$41
			b $75,$73,$77
:l614c			b $61,$68
			b $6c,$20,$28
:l6151			b $50,$69
			b $6b,$74,$6f
			b $67,$72,$61
			b $6d,$6d,$2d
			b $4d,$6f,$64
			b $75,$73,$29
			b $3a,$0f,$00
			b $18,$43,$3d
			b $20,$31,$1b
			b $20,$62,$69
			b $73,$20,$18
			b $43,$3d,$20
:l6174			b $38,$1b,$20
			b $7a,$75,$72
			b $20,$44,$61
			b $74,$65,$69
			b $2d,$41,$75
			b $73,$77
:l6185			b $61,$68
			b $6c,$20,$61
			b $75,$66,$20
			b $61,$6b,$74
:l6190			b $75,$65
			b $6c,$6c,$65
			b $72,$20,$53
			b $65,$69,$74
			b $65,$2e,$00
			b $18,$43,$3d
			b $20,$53,$68
			b $69,$66,$74
			b $20,$31,$1b
			b $20,$62,$69
			b $73,$20,$18
			b $43,$3d,$20
			b $53,$68,$69
			b $66,$74,$20
			b $38,$1b,$20
:l61bc			b $44,$61,$74
			b $65,$69,$2d
			b $41,$75,$73
			b $77
:l61c6			b $61,$68
			b $6c,$20,$61
			b $75,$66,$20
			b $52,$61,$6e
			b $64,$2e,$00
			b $0e,$18,$4d
			b $65,$68,$72
			b $64,$61,$74
			b $65
:l61de			b $69,$65
			b $6e,$2d,$4f
			b $70,$65
			b $72,$61,$74
			b $69,$6f,$6e
			b $65
:l61ec			b $6e,$20
			b $28,$50,$69
			b $6b,$74,$6f
			b $67,$72,$61
			b $6d,$6d,$2d
			b $4d,$6f,$64
			b $75,$73,$29
			b $3a,$0f,$00
			b $18,$52,$55
			b $4e,$2f,$53
			b $54,$4f
:l620b			b $50,$1b
:l620d			b $20,$7a,$75
			b $6d,$20,$41
			b $62,$62,$72
:l6216			b $75,$63
			b $68
			b $20,$76,$6f
			b $6e,$20,$4f
			b $70,$65
			b $72,$61,$74
			b $69,$6f,$6e
			b $65
:l6228			b $6e,$2e
			b $00,$18,$43
			b $3d,$20,$47
			b $1b,$2c,$20
			b $75,$6d,$20
			b $65,$72,$73
			b $74,$65,$20
			b $44,$61,$74
			b $65,$69,$20
			b $61,$75,$73
			b $20
:l6246			b $4c,$69,$73
			b $74
:l624a			b $65,$20
			b $7a,$75,$20
			b $73,$65,$68
			b $65,$6e,$2e
			b $00,$0e,$18
			b $42,$65
:l625a			b $77
			b $65,$67,$75
			b $6e,$67,$20
			b $69,$6e,$20
			b $41,$72,$62
			b $65,$69,$74
			b $73,$62
:l626c			b $6c,$61,$74
			b $74,$20
:l6271			b $28,$50,$69
			b $6b,$74,$6f
			b $67,$72,$61
			b $6d,$6d,$2d
			b $4d,$6f,$64
			b $75,$73,$29
			b $3a,$0f,$00
:l6286			b $18,$76,$1b
			b $20,$75,$6e
			b $64,$20,$18
			b $5e,$1b,$20
			b $28,$43,$52
			b $53,$52,$2d
			b $54,$61,$73
			b $74,$65,$29
			b $20,$66,$7d
			b $72,$20,$53
			b $65,$69,$74

			b $65,$20,$76
			b $6f,$72,$2f
			b $7a,$75,$72
			b $7d,$63,$6b
			b $2e,$00,$18
			b $31,$1b,$20
			b $62,$69,$73
			b $20,$18,$39
			b $1b,$20,$66
			b $7d,$68,$72
			b $74,$20,$61
			b $75,$66,$20
			b $64,$69,$65
			b $20,$53,$65
			b $69,$74,$65
			b $6e,$20,$31
			b $20,$62,$69
			b $73,$20
:l62dc			b $39
:l62dd			b $2e,$00
:l62df			b $18,$30,$1b
			b $20,$66,$7d
			b $68,$72,$74
			b $20,$61,$75
			b $66,$20,$53
			b $65,$69,$74
			b $65,$20,$31
:l62f4			b $30,$2e
			b $00,$18,$53
			b $68,$69
:l62fb			b $66,$74
:l62fd			b $20,$31,$1b
			b $20,$62,$69
			b $73,$20,$18
			b $53,$68,$69
			b $66,$74,$20
			b $38,$1b,$20
			b $66,$7d,$68
			b $72,$74,$20
			b $61,$75,$66
			b $20,$64
:l631a			b $69,$65
			b $20,$53,$65
			b $69,$74
			b $65,$6e
			b $20
:l6324			b $31,$31
			b $20,$62,$69
			b $73,$20,$31
			b $38,$2e,$00

;Endadresse VLIR-Modul testen:
			g vlirModEnd
