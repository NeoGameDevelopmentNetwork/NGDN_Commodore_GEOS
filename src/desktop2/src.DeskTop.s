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
endif

;			n "DESK TOP"
			n "obj.DeskTop"
			c "deskTop  GE V2.0",NULL
			a "Brian Dougherty",NULL
			o $1956
			p MainInit
			z $40
			f SYSTEM

			h "deskTop verwaltet Ihre Disketten und Dateien."

:l1956			lda	#$00
			sta	$04ee
			ldy	a1H
			lda	driveType -8,y
			bmi	l1968
:l1962			and	#$0f
			cmp	#$02
			bne	l197a
:l1968			ldy	a2L
			lda	driveType -8,y
			bmi	l1975
:l196f			and	#$0f
			cmp	#$02
			bne	l197a
:l1975			lda	#$07
			sta	l1da0
:l197a			jsr	l231e
			jsr	l1a04
			txa
			bne	l19a3
:l1983			jsr	l1a12
			clc
			lda	#$00
			adc	$03f4
			sta	$03f4
			lda	#$03
			adc	$03f5
			sta	$03f5
			jsr	l22c5
			jsr	l1b7c
			jsr	l1a04
			jsr	l1a6b
:l19a3			lda	#$08
			sta	l1da0
			clv
			bvc	l19fe
:l19ab			sta	$04ee
			jsr	l1a12
			ldx	#$00
			ldy	a2L
			jsr	l243f
			cmp	#$04
			bcs	l19fb
:l19bc			jsr	l22f3
			txa
			bne	l19fb
:l19c2			lda	$03fb
			sta	r6H
			lda	$03fa
			sta	r6L
			jsr	FindFile
			txa
			bne	l19fb
:l19d2			ldx	#$0c
			lda	dirEntryBuf
			and	#$0f
			cmp	#$04
			beq	l19fb
:l19dd			lda	$841d
			bne	l19ec
:l19e2			lda	$841c
			cmp	#$18
			bcs	l19ec
:l19e9			jsr	l1a4f
:l19ec			jsr	l22c5
			jsr	l1e8a
			jsr	l1a04
			jsr	l1a6b
			clv
			bvc	l19fe
:l19fb			jsr	l1a04
:l19fe			lda	#$00
			sta	$04ed
			rts
:l1a04			txa
			beq	l1a11
:l1a07			cmp	#$0c
			beq	l1a11
:l1a0b			pha
			jsr	l259d
			pla
			tax
:l1a11			rts
:l1a12			lda	#$ff
			sta	$04ed
			jsr	l1a4f
			lda	a1H
			cmp	a2L
			bne	l1a49
:l1a20			lda	$04ee
			bne	l1a49
:l1a25			sta	$04ed
			sta	$04ec
			sta	$024d
			lda	#$28
			sta	$03f3
			lda	#$06
			sta	$03f2
			lda	#$54
			sta	$03f5
			lda	#$fa
			sta	$03f4
			lda	#$00
			sta	a9L
			jsr	l5680
:l1a49			lda	#$00
			sta	$04eb
			rts
:l1a4f			lda	#$ff
			sta	$04ec
			lda	#$66
			sta	$03f3
			lda	#$00
			sta	$03f2
			lda	#$17
			sta	$03f5
			lda	#$00
			sta	$03f4
			jmp	l5677
:l1a6b			txa
			pha
			lda	$04ec
			bne	l1a80
:l1a72			jsr	l1a8e
			txa
			beq	l1a80
:l1a78			ldy	#$00
			jsr	l246b
			clv
			bvc	l1a72
:l1a80			jsr	l22dc
			jsr	l5671
			lda	#$ff
			sta	$04ec
			pla
			tax
			rts
:l1a8e			jsr	OpenDisk
			jsr	l253e
			jsr	l1aae
			jsr	l253e
			lda	r7H
			beq	l1aa2
:l1a9e			ldx	#$05
			bne	l1aad
:l1aa2			lda	r5H
			sta	r9H
			lda	r5L
			sta	r9L
			jsr	l1ac2
:l1aad			rts
:l1aae			jsr	l2577
			lda	#$04
			sta	r7L
:l1ab5			jsr	OpenDisk
			lda	#$01
			sta	r7H
			jsr	l256e
			jmp	FindFTypes
:l1ac2			jsr	GetFHdrInfo
			jsr	l253e
			ldy	#$01
			lda	(r9L),y
			sta	r1L
			iny
			lda	(r9L),y
			sta	r1H
			jsr	l1de3
			jsr	l253e
			lda	$8002
			sta	r1L
			lda	$8003
			sta	r1H
			lda	#$ff
			sta	r2L
			sta	r2H
			jmp	ReadFile
:l1aec			lda	curDrive
			eor	#$01
:l1af1			pha
			jsr	SetDevice
			pla
			cmp	#$08
			bcc	l1b0a
:l1afa			cmp	$0af1
			beq	l1b0a
:l1aff			sta	$0af1

			lda	$0af0
			beq	l1b0a
:l1b07			jsr	l1b1c
:l1b0a			ldy	curDrive
			lda	driveType -8,y
			sta	$88c6
			ldx	#$00
			rts
:l1b16			jsr	l1af1
			jmp	OpenDisk
:l1b1c			jsr	l1b22
			jsr	l1b3c
:l1b22			ldy	#$05
:l1b24			lda	$0002,y
			tax
			lda	l1b36,y
:l1b2b			sta	$0002,y
			txa
			sta	l1b36,y
			dey
			bpl	l1b24
:l1b35			rts
:l1b36			b $00
:l1b37			b $90,$f2
:l1b39			b $0a
			b $80,$0d
:l1b3c			lda	r0H
			pha
			lda	r1H
			pha
			lda	r2H
			pha
			ldy	#$00
:l1b47			lda	r2H
			beq	l1b61
:l1b4b			lda	(r0L),y
			tax
			lda	(r1L),y
			sta	(r0L),y
			txa
			sta	(r1L),y
			iny
			bne	l1b4b
:l1b58			inc	r0H
			inc	r1H
			dec	r2H
			clv
			bvc	l1b47
:l1b61			cpy	r2L
			beq	l1b72
:l1b65			lda	(r0L),y
			tax
			lda	(r1L),y
			sta	(r0L),y
			txa
			sta	(r1L),y
			iny
			bne	l1b61
:l1b72			pla
			sta	r2H
			pla
			sta	r1H
			pla
			sta	r0H
			rts
:l1b7c			jsr	l1bc4
			lda	#$ff
			jsr	l1cfd
:l1b84			jsr	l1bf8
			jsr	l253e
			jsr	l232c
			jsr	l253e
			jsr	l1c63
			jsr	l253e
			lda	$04f4
			cmp	$0522
			beq	l1ba0
:l1b9e			bcs	l1ba7
:l1ba0			jsr	l231e
			txa
			beq	l1b84
:l1ba6			rts
:l1ba7			lda	$0520
			cmp	#$01
			bne	l1ba6
:l1bae			lda	$0521
			cmp	#$02
			bne	l1ba6
:l1bb5			sta	$0520
			jsr	GetDirHead
			jsr	l253e
			jsr	l1df0
			jmp	PutDirHead
:l1bc4			lda	$03f5
			sta	r3H
			lda	$03f4
			sta	r3L
			lda	#$01
			sta	r0H
			lda	#$02
			sta	r0L
			ldx	#$08
			ldy	#$02
			jsr	Ddiv
			lda	r3L
			sta	$04f1
			asl	r3L
			rol	r3H
			lda	$03f2
			clc
			adc	r3L
			sta	$04ef
			lda	$03f3
			adc	r3H
			sta	$04f0
			rts
:l1bf8			jsr	EnterTurbo
			jsr	l253e
			jsr	InitForIO
			jsr	l1c4e
			lda	#$00
			sta	$04f2
:l1c09			lda	$04f4
:l1c0c			sta	r1L
			cmp	$0522
			beq	l1c15
:l1c13			bcs	l1c49
:l1c15			lda	$04f3
			sta	r1H
			jsr	l1cc0
			jsr	ReadBlock
			txa
			bne	l1c4b
:l1c23			ldy	#$00
			lda	r1L
			sta	(r10L),y
			iny
			lda	r1H
			sta	(r10L),y
			inc	$04f2
			jsr	l2544
			inc	r11H
			lda	#$30
			sta	$01
			jsr	l1d21
			lda	#$36
			sta	$01
			lda	$04f2
			cmp	$04f1
			bcc	l1c09
:l1c49			ldx	#$00
:l1c4b			jmp	DoneWithIO
:l1c4e			lda	$03f3
			sta	r10H
			lda	$03f2
			sta	r10L
			lda	$04f0
			sta	r11H
			lda	$04ef
			sta	r11L
			rts
:l1c63			jsr	EnterTurbo
			jsr	l253e
			stx	$04f6
			jsr	InitForIO
			lda	$04f2
			pha
			jsr	l1c86
			pla
			sta	$04f2
			txa
			bne	l1c83
:l1c7d			dec	$04f6
			jsr	l1c86
:l1c83			jmp	DoneWithIO
:l1c86			jsr	l1c4e
:l1c89			lda	$04f2
			beq	l1cbd
:l1c8e			ldy	#$00
			lda	(r10L),y
			sta	r1L
			iny
			lda	(r10L),y
			sta	r1H
			jsr	l1cc9
			jsr	l253e
			jsr	l1cc0
			lda	$04f6
			bne	l1cad
:l1ca7			jsr	WriteBlock
			clv
			bvc	l1cb0
:l1cad			jsr	VerWriteBlock
:l1cb0			jsr	l253e
			jsr	l2544
			inc	r11H
			dec	$04f2
			bne	l1c89
:l1cbd			ldx	#$00
			rts
:l1cc0			lda	r11H

			sta	r4H
			lda	r11L
			sta	r4L
			rts
:l1cc9			lda	r1L
			cmp	$0523
			bne	l1cf9
:l1cd0			lda	r1H
			ora	$04f6
			bne	l1cf9
:l1cd7			jsr	l2550
			jsr	ReadBlock
			jsr	l253e
			ldy	#$90
			ldx	#$13
:l1ce4			lda	$8000,y
			sta	(r11L),y
			iny
			dex
			bpl	l1ce4
:l1ced			ldy	#$bd
			lda	#$00
			sta	(r11L),y
			iny
			sta	(r11L),y
			iny
			sta	(r11L),y
:l1cf9			ldx	#$00
			rts
:l1cfc				b $00
:l1cfd			sta	l1cfc
			ldy	$0520
			lda	l1d34,y
			sta	$0522
			lda	l1d38,y
			sta	$0523
			lda	l1d3c,y
			sta	$0524
			ldy	#$01
			sty	$04f4
			dey
			sty	$04f3
:l1d1e			jsr	l1d40
:l1d21			jsr	l1da1
			bcc	l1d33
:l1d26			inc	$04f4
			lda	$04f4
			cmp	$0522
			bcc	l1d1e
:l1d31			beq	l1d1e
:l1d33			rts
:l1d34			b $23,$23,$46,$50
:l1d38			b $12,$12,$12
:l1d3b			b $28
:l1d3c			b $01,$01,$01,$03
:l1d40			ldy	#$27
			lda	#$00
:l1d44			sta	$04f7,y
			dey
			bpl	l1d44
			lda	$0520
:l1d4d			cmp	#$03
			bne	l1d58
:l1d51			lda	#$28
			sta	$04f5
			bne	l1d78
:l1d58			lda	$04f4
			cmp	#$24
			bcc	l1d62
:l1d5f			sec
			sbc	#$23
:l1d62			jsr	l1e7b
			lda	l1d9c,x
			sta	$04f5
			tay
:l1d6c			cpy	#$15
			beq	l1d78
:l1d70			lda	#$ff
			sta	$04f7,y
			iny
			bne	l1d6c
:l1d78			lda	l1cfc
			beq	l1d9b
:l1d7d			lda	$04f4
			sta	r6L
			lda	#$00
			sta	r6H
:l1d86			jsr	FindBAMBit
			beq	l1d92
:l1d8b			ldy	r6H
			lda	#$ff
			sta	$04f7,y
:l1d92			inc	r6H
			lda	r6H
			cmp	$04f5
			bcc	l1d86
:l1d9b			rts
:l1d9c			b $15,$13,$12,$11
:l1da0			b $08
:l1da1			lda	l1da0
			clc
			adc	$04f3
			cmp	$04f5
			bcc	l1db1
:l1dad			sec
			sbc	$04f5
:l1db1			tay
			lda	$04f7,y
			beq	l1dd0
:l1db7			ldx	$04f5
:l1dba			iny
			cpy	$04f5
			bcc	l1dc6
:l1dc0			tya
			sec
			sbc	$04f5
			tay
:l1dc6			lda	$04f7,y
			beq	l1dd0
:l1dcb			dex
			bpl	l1dba
:l1dce			sec
			rts
:l1dd0			sty	$04f3
			lda	#$ff
			sta	$04f7,y
			clc
			rts
:l1dda			lda	(r5L),y
			sta	r1L
			iny
			lda	(r5L),y
			sta	r1H
:l1de3			jsr	l2550
			jmp	GetBlock
:l1de9			jsr	l2550
			jmp	PutBlock
:l1def			b $00
:l1df0			lda	#$24
			bne	l1e02
:l1df4			ldy	#$04
			lda	#$00
:l1df8			sta	curDirHead,y
			iny
			cpy	#$90
			bne	l1df8
:l1e00			lda	#$01
:l1e02			sta	l1def
			ldy	#$dd
			lda	#$00
:l1e09			sta	curDirHead,y
			iny
			bne	l1e09
:l1e0f			ldy	$0520
			cpy	#$02
			bcc	l1e2d
:l1e16			bne	l1e22
:l1e18			ldy	#$00
:l1e1a			sta	$8900,y
			iny
			bne	l1e1a
:l1e20			beq	l1e2d
:l1e22			ldy	#$10
:l1e24			sta	$8900,y
			sta	$9c80,y
			iny
			bne	l1e24
:l1e2d			lda	#$00
			jsr	l1cfd
:l1e32			lda	$04f3
			sta	r6H
			lda	$04f4
			sta	r6L
			cmp	$0522
			beq	l1e43
:l1e41			bcs	l1e4c
:l1e43			jsr	l1e4d
			jsr	l1d21
			clv
			bvc	l1e32
:l1e4c			rts
:l1e4d			lda	$0520
			cmp	#$02
			bcc	l1e6a
:l1e54			bne	l1e67
:l1e56			lda	r6L
			cmp	l1def
			bcc	l1e66
:l1e5d			cmp	#$35
			bne	l1e67
:l1e61			lda	#$80
			sta	$8203
:l1e66			rts
:l1e67			jmp	FreeBlock
:l1e6a			jsr	FindBAMBit
			lda	r8H
			eor	curDirHead,x
			sta	curDirHead,x
			ldx	r7H
			inc	curDirHead,x
			rts
:l1e7b			ldx	#$00

:l1e7d			cmp	l1e86,x
			bcc	l1e85
:l1e82			inx
			bne	l1e7d
:l1e85			rts
:l1e86			b $12
:l1e87			b $19,$1f,$24
:l1e8a			jsr	l2268
			jsr	l206d
			jsr	l2097
			jsr	l253e
			jsr	l232c
			jsr	l253e
			lda	#$82
			sta	r5H
			lda	#$00
			sta	r5L
			jsr	CalcBlksFree
			ldx	#$03
			lda	$1893
			cmp	r4H
			bne	l1eb5
:l1eb0			lda	$1892
			cmp	r4L
:l1eb5			beq	l1eb9
:l1eb7			bcs	l1f00
:l1eb9			lda	a0H
			sta	r10L
			jsr	GetFreeDirBlk
			jsr	l253e
			lda	r10L
			sta	a0H
			sty	$04e0
			lda	r1H
			sta	$04e2
			lda	r1L
			sta	$04e1
			jsr	PutDirHead
			jsr	l253e
:l1eda			jsr	l1f01
			jsr	l253e
			tya
			bne	l1ef7
:l1ee3			jsr	l22f3
			jsr	l253e
			jsr	l2097
			jsr	l253e
			jsr	l2350
			jsr	l253e
			beq	l1eda
:l1ef7			jsr	l2244
			jsr	l253e
			jsr	PutDirHead
:l1f00			rts
:l1f01			php
			sei
			lda	$03f3
			sta	r8H
			lda	$03f2
			sta	r8L
:l1f0d			jsr	l22af
			lda	(r10L),y
			and	#$80
			bne	l1f1c
:l1f16			jsr	l1fdb
			clv
			bvc	l1f1f
:l1f1c			jsr	l1f42
:l1f1f			txa
			bne	l1f40
:l1f22			ldy	#$02
			lda	(r10L),y
			sta	r8L
			iny
			lda	(r10L),y
			sta	r8H
			ldy	#$00
			lda	(r10L),y
			and	#$30
			beq	l1f0d
:l1f35			ldx	#$00
			and	#$10
			beq	l1f40
:l1f3b			jsr	l1f5e
			ldy	#$ff
:l1f40			plp
			rts
:l1f42			ldy	#$00
			lda	(r10L),y
			and	#$03
			tay
			lda	l1f56,y
			sta	r0H
			lda	l1f5a,y
			sta	r0L
			jmp	($0002)
:l1f56			 w l1f1f
			w l1f1f
:l1f5a				b $7b,$b5
:l1f5c			cmp	$41
:l1f5e			lda	$041b
			cmp	#$01
			bne	l1f7a
:l1f65			lda	$0408
			sta	r1H
			lda	$0407
			sta	r1L
			lda	#$7d
			sta	r4H
			lda	#$00
			sta	r4L
			jsr	PutBlock
:l1f7a			rts
:l1f7b			jsr	l1fdb
			txa
			bne	l1faa
:l1f81			lda	$04ea
			sta	$041a
			lda	$04e9
			sta	$0419
			lda	$041b
			cmp	#$01
			bne	l1faa
:l1f94			jsr	l22ba
			jsr	SetNextFree
			lda	r3L
			sta	$04e7
			sta	$0407
			lda	r3H
			sta	$04e8
			sta	$0408
:l1faa			lda	l2096
			beq	l1fb4
:l1faf			lda	#$23
			sta	$04e7
:l1fb4			rts
:l1fb5			jsr	l1fdb
			lda	$04ea
			sta	$0408
			lda	$04e9
			sta	$0407
			rts
:l1fc5			jsr	l1fdb
			ldy	#$01
			lda	(r10L),y
			asl
			tay
			lda	$04e9
			sta	$7d02,y
			lda	$04ea
			sta	$7d03,y
			rts
:l1fdb			lda	r8L
			clc
			adc	#$04
			sta	r7L
			lda	r8H
			adc	#$00
			sta	r7H
			ldy	#$02
			lda	(r10L),y
			sta	r2L
			iny
			lda	(r10L),y
			sta	r2H
			lda	r2L
			sec
			sbc	r7L
			sta	r2L
			lda	r2H
			sbc	r7H
			sta	r2H
			jsr	l22ba
			jsr	l2064
			lda	r7H
			pha
			lda	r7L
			pha
			jsr	NxtBlkAlloc
			pla
			sta	r7L
			pla
			sta	r7H
			jsr	l253e
			ldy	#$00
			lda	(r10L),y
			and	#$80
			beq	l202f
:l2020			lda	$8301
			sta	$04ea
			lda	fileTrScTab
			sta	$04e9
			clv
			bvc	l2054
:l202f			lda	$04e8
			sta	r1H
			lda	$04e7
			sta	r1L
			jsr	l2550
			jsr	GetBlock
			jsr	l253e
:l2042			lda	$8301

			sta	$8001
			lda	fileTrScTab
:l204b			sta	diskBlkBuf
			jsr	PutBlock
			jsr	l253e
:l2054			lda	r3H
			sta	$04e8
			lda	r3L
			sta	$04e7
			jsr	l2064
			jmp	WriteFile
:l2064			lda	#$83
:l2066			sta	r6H
			lda	#$00
			sta	r6L
			rts
:l206d			lda	#$40
			sta	$04e3
			lda	#$00
:l2074			sta	l2096
			ldy	a2L
			lda	driveType -8,y
			cmp	#$03
			bne	l2087
:l2080			sta	l2096
			lda	#$27
			bne	l2089
:l2087			lda	#$01
:l2089			sta	$04e7
			lda	#$00
			sta	$04e8
			sta	l2095
			rts
:l2095			b $00
:l2096			b $00
:l2097			php
			sei
			lda	$03f3
			sta	r8H
			lda	$03f2
			sta	r8L
			lda	$03f5
			sta	r9H
			lda	$03f4
			sta	r9L
			lda	#$04
			sta	r10H
			lda	#$e3
			sta	r10L
:l20b5			lda	r9H
			beq	l20ea
:l20b9			cmp	#$01
			bne	l20c3
:l20bd			lda	r9L
			cmp	#$04
			bcc	l20ea
:l20c3			ldy	#$00
			lda	(r10L),y
			and	#$40
			bne	l20d1
:l20cb			jsr	l2153
			clv
			bvc	l20d4
:l20d1			jsr	l20f9
:l20d4			txa
			bne	l20f7
:l20d7			ldy	#$00
			lda	(r10L),y
			and	#$40
			beq	l20ea
:l20df			lda	l2095
			cmp	#$04
			bne	l20b5
:l20e6			lda	#$30
			bne	l20ec
:l20ea			lda	#$20
:l20ec			ldy	#$00
			ora	(r10L),y
			sta	(r10L),y
			sta	$04e3
			ldx	#$00
:l20f7			plp
			rts
:l20f9			ldy	l2095
			lda	l2109,y
			sta	r0H
			lda	l210d,y
			sta	r0L
			jmp	(r0)
:l2109			b $21
:l210a			b $21,$21,$21
:l210d			b $11
			b $39,$6d,$8d
			lda	$1889
			beq	l2139
:l2116			jsr	l22af
			lda	#$80
			sta	(r10L),y
			lda	$188a
			sta	r1H
			lda	$1889
			sta	r1L
			jsr	l21df
			ldy	#$01
			lda	$188b
			cmp	#$01
			bne	l2135
:l2133			ldy	#$02
:l2135			sty	l2095
			rts
:l2139			jsr	l22af
			lda	#$81
			sta	(r10L),y
			lda	$1878
			sta	r1H
			lda	$1877
			sta	r1L
			jsr	l21df
			lda	#$04
			sta	l2095
			rts
:l2153			ldy	#$00
			lda	(r10L),y
			pha
			jsr	l22af
			pla
			and	#$0f
			sta	(r10L),y
			lda	$04e6
			sta	r1H
			lda	$04e5
			sta	r1L
			jmp	l21df
:l216d			lda	#$ff
			sta	$04e4
			lda	$1878
			sta	r1H
			lda	$1877
			sta	r1L
			lda	#$7d
			sta	r4H
			lda	#$00
			sta	r4L
			jsr	GetBlock
			lda	#$03
			sta	l2095
			rts
:l218d			lda	$04e4
			sta	r0L
			jsr	l21c6
			lda	l2095
			cmp	#$04
			beq	l21c5
:l219c			jsr	l22af
			lda	r0L
			sta	$04e4
			asl
			tax
			lda	$7d02,x
			sta	r1L
			lda	$7d03,x
			sta	r1H
			lda	#$82
			sta	(r10L),y
			iny
			lda	r0L
			sta	(r10L),y
			lda	r0L
			pha
			jsr	l21df
			pla
			sta	r0L
			txa
			beq	l21c6
:l21c5			rts
:l21c6			inc	r0L
			lda	r0L
			cmp	#$7f
			bcs	l21d7
:l21ce			asl
			tax
			lda	$7d02,x
			beq	l21c6
:l21d5			bne	l21dc
:l21d7			lda	#$04
			sta	l2095
:l21dc			ldx	#$00
			rts
:l21df			lda	r10L
			clc
			adc	#$04
			sta	r7L
			lda	r10H
			adc	#$00
			sta	r7H
			sec
			lda	r9L
			sbc	#$04
			sta	r2L
			lda	r9H
			sbc	#$00
			sta	r2H
			jsr	ReadFile
			cpx	#$0b

			bne	l220e
:l2200			lda	r1H
			sta	$04e6
			lda	r1L
			sta	$04e5
			ldx	#$00
			beq	l2216
:l220e			ldy	#$00
			lda	(r10L),y
			ora	#$40
			sta	(r10L),y
:l2216			lda	r7H
			sta	r8H
			lda	r7L
			sta	r8L
			lda	r8L
			sec
			sbc	r10L
			sta	r0L
			lda	r8H
			sbc	r10H
			sta	r0H
			lda	r9L
			sec
			sbc	r0L
			sta	r9L
			lda	r9H
			sbc	r0H
			sta	r9H
			lda	r8L
			ldy	#$02
			sta	(r10L),y
			lda	r8H
			iny
			sta	(r10L),y
			rts
:l2244			lda	$04e2
			sta	r1H
			lda	$04e1
			sta	r1L
			jsr	l1de3
			jsr	l253e
			ldy	$04e0
			ldx	#$00
:l2259			lda	$0406,x
			sta	$8000,y
			inx
			iny
			cpx	#$1e
			bne	l2259
:l2265			jmp	l1de9
:l2268			ldy	#$1d
:l226a			lda	(r5L),y
			sta	$1876,y
			sta	$0406,y
			dey
			bpl	l226a
:l2275			lda	$03fd
			sta	r3H
			lda	$03fc
			sta	r3L
			lda	#$ff
			sta	r1H
			ldx	#$03
			ldy	#$00
:l2287			lda	(r3L),y
			bne	l2291
:l228b			lda	#$00
			sta	r1H
:l228f			lda	#$a0
:l2291			sta	$0406,x
			inx
			iny
			cpy	#$10
			beq	l22a0
:l229a			lda	r1H
			bne	l2287
:l229e			beq	l228f
:l22a0			lda	#$00
			sta	$0407
			sta	$0408
			sta	$0419
			sta	$041a
			rts
:l22af			lda	r8H
			sta	r10H
			lda	r8L
			sta	r10L
			ldy	#$00
			rts
:l22ba			lda	$04e8
			sta	r3H
			lda	$04e7
			sta	r3L
			rts
:l22c5			lda	$84b2
			sta	$03ff
			lda	RecoverVector
			sta	$03fe
			lda	#$22
			sta	$84b2
			lda	#$e9
			sta	RecoverVector
			rts
:l22dc			lda	$03ff
			sta	$84b2
			lda	$03fe
			sta	RecoverVector
			rts
:l22e9			lda	#$80
			sta	$2f
			jsr	l2447
			jmp	Rectangle
:l22f3			ldy	#$00
:l22f5			lda	curDirHead,y
			sta	$8a80,y
			lda	$8900,y
			sta	$7e00,y
			iny
			bne	l22f5
:l2304			ldy	a2L
			lda	driveType -8,y
			and	#$0f
			cmp	#$03
			bne	l231e
:l230f			tya
			jsr	l1af1
			ldy	#$00
:l2315			lda	$9c80,y
			sta	$7f00,y
			iny
			bne	l2315
:l231e			lda	$03f7
			sta	r1H
			lda	$03f6
			sta	r1L
			lda	a1H
			bne	l2338
:l232c			lda	$03f9
			sta	r1H
			lda	$03f8
			sta	r1L
			lda	a2L
:l2338			jsr	l1af1
			lda	$04ed
			beq	l234d
:l2340			lda	$04eb
			cmp	#$02
			bcc	l234a
:l2347			ldx	#$00
			rts
:l234a			inc	$04eb
:l234d			jmp	l2383
:l2350			jsr	l232c
			ldy	#$00
:l2355			lda	$8a80,y
			sta	curDirHead,y
			lda	$7e00,y
			sta	$8900,y
			iny
			bne	l2355
:l2364			ldy	a2L
			lda	driveType -8,y
			and	#$0f
			cmp	#$03
			bne	l237a
:l236f			ldy	#$00
:l2371			lda	$7f00,y
			sta	$9c80,y
			iny
			bne	l2371
:l237a			rts
:l237b			jsr	l1af1
:l237e			jsr	l3906
			beq	l237a
:l2383			jsr	l23e4
			php
			ldx	#$00
			plp
			bne	l2392
:l238c			ldy	#$ff
			sty	$024d
			rts
:l2392			jsr	l255c
			ldx	#$04
			ldy	#$0c
			lda	#$12
			jsr	l2418
			lda	curDrive
			clc
			adc	#$39
			sta	l2763
			lda	r1H
			pha
			lda	r1L
			pha
			ldx	#$23
			lda	#$ff
			jsr	l2483
			pla
			sta	r1L
			pla

			sta	r1H
			ldx	#$0c
			lda	r0L
			cmp	#$02
			bne	l2383
:l23c2			lda	$04ec
			beq	l23d6
:l23c7			lda	#$51
			sta	r7H
			lda	#$a8
			sta	r7L
			lda	#$00
			sta	r0L
			jmp	StartAppl
:l23d6			jsr	l2518
			jmp	EnterDeskTop
:l23dc			lda	a6H
			jmp	l1af1
:l23e1			jsr	l3906
:l23e4			lda	r1H
			pha
			lda	r1L
			pha
			jsr	OpenDisk
			pla
			sta	r1L
			pla
			sta	r1H
			jsr	l253e
			ldx	#$0c
			ldy	#$04
			lda	#$12
			jmp	CmpFString
:l23ff			b $81,$0b
:l2401			b $10,$10
			b $65,$27,$0b
:l2406			b $10,$20
			b $80,$8b,$0b
:l240b			b $10,$30
			b $54,$27,$01
			b $01,$48,$02
:l2413			b $11,$48
			b $00
:l2416			lda	#$10
:l2418			stx	l2425 +1
			sty	l2427 +1
			sty	l2439 +1
			sta	r15L
			ldy	#$00
:l2425			lda	($00),y
:l2427			sta	($00),y
			cmp	#$a0
			beq	l242f
:l242d			sty	r15H
:l242f			iny
			dec	r15L
			bne	l2425
:l2434			ldy	r15H
			iny
			lda	#$00
:l2439			sta	($00),y
			rts
:l243c			ldy	curDrive
:l243f			lda	driveType -8,y
			and	#$07
			cmp	#$02
			rts
:l2447			lda	#$00
			b $2c
:l244a			lda	#$02
			jmp	SetPattern
:l244f			b $27,$2c,$2d
			b $31,$31
			b $2d,$2d
:l2456			b $3b,$d8,$32
			b $91,$5e,$03
			b $5f

:l245d			b $27,$2c
:l245f			b $2d,$31,$31
			b $2d,$2d
:l2464			b $2a
			b $f6,$49
			b $a4,$7c,$19,$7e
:l246b			lda	l2456,y
			sta	r5L
			lda	l244f,y
			sta	r5H
			lda	l2464,y
			sta	r6L
			lda	l245d,y
			sta	r6H
			ldx	#$25
			lda	#$07
:l2483			stx	r0H
			sta	r0L
			lda	r5H
			pha
			lda	r5L
			pha
			lda	r6H
			pha
			lda	r6L
			pha
			lda	r7H
			pha
			lda	r7L
			pha
			jsr	l24f3
			beq	l24a3
:l249e			ldx	#$00
			jsr	l4dd6
:l24a3			lda	$8e88
			pha
			lda	$8cc0
			pha
			lda	#$00
			sta	r3H
			lda	#$08
			sta	r3L
			lda	#$00
			sta	r4H
			lda	#$20
			sta	r4L
			lda	#$04
			sta	r2L
			lda	#$10
			sta	r2H
			lda	screencolors
			sta	r6L
			jsr	l268a
			pla
			sta	$8cc0
			pla
			sta	$8e88
			pla
			sta	r7L
			pla
			sta	r7H
			pla
			sta	r6L
			pla
			sta	r6H
			pla
			sta	r5L
			pla
			sta	r5H
			jsr	DoDlgBox
			jsr	l24f3
			bne	l24f0
:l24ed			jsr	l26f7
:l24f0			lda	r0L
			rts
:l24f3			ldx	#$ff
			lda	RecoverVector
			cmp	#$a9
			bne	l2503
:l24fc			lda	$84b2
			cmp	#$4d
			beq	l2505
:l2503			ldx	#$00
:l2505			txa
			rts
:l2507			sta	($0c,x)
			bpl	l252b
			b $0c,$0c
:l250d			bpl	l253f
:l250f			asl	$1101
			pha
			b $00
:l2514			lda	#$c0
			sta	$2f
:l2518			lda	r9H
			pha
			lda	r9L
			pha
			jsr	l26fd
			jsr	i_GraphicsString
			b $05,$02,$01,$00
			b $00,$00,$03
:l252b			b $3f,$01,$c7
			b $00
:l252f			pla
			sta	r9L
			pla
			sta	r9H
			rts
:l2536			pha
			lda	version
			cmp	#$20
			pla
			rts
:l253e			txa
:l253f			beq	l2543
:l2541			pla
			pla
:l2543			rts
:l2544			clc
			lda	#$02
			adc	r10L
			sta	r10L
			bcc	l254f
:l254d			inc	r10H
:l254f			rts

:l2550			lda	#$80
			sta	r4H
			lda	#$00
			sta	r4L
			rts
:l2559			jsr	l2565
:l255c			lda	#$8b
			sta	r5H
			lda	#$80
			sta	r5L
			rts
:l2565			lda	#$8b
			sta	r6H
			lda	#$e4
			sta	r6L
			rts
:l256e			lda	#$8b
			sta	r6H
			lda	#$80
			sta	r6L
			rts
:l2577			lda	#$27
			sta	r10H
			lda	#$2a
			sta	r10L
			rts
:l2580			lda	r5H
			beq	l259d
:l2584			txa
			pha
			lda	r5L
			clc
			adc	#$03
			sta	r5L
			bcc	l2591
:l258f			inc	r5H
:l2591			ldx	#$0c
			ldy	#$0c
			jsr	l2416
			pla
			tax
			clv
			bvc	l25a5
:l259d			lda	#$25
			sta	r5H
			lda	#$f1
			sta	r5L
:l25a5			lda	#$00
			sta	a8H
			cpx	#$ff
			beq	l25d8
:l25ad			cpx	#$0c
			beq	l25d8
:l25b1			txa
			beq	l25d8
:l25b4			jsr	l25f2
			txa
			sta	l2662
			ldy	#$00
:l25bd			cmp	l2653,y
			beq	l25c7
:l25c2			iny
			iny
			iny
			bne	l25bd
:l25c7			lda	l2654,y
			sta	r6L
			lda	l2655,y
			sta	r6H
			ldx	#$25
			lda	#$db
			jsr	l2483
:l25d8			ldx	#$00
			rts
			b $81,$0b,$0c
			b $16,$7b,$27
			b $0b,$0c,$26
			b $8e,$27,$0c
			b $0c,$36,$0e
			b $0c,$0c,$46
			b $0c,$01,$11
			b $48,$00
:l25f2			txa
			ldy	#$02
			jsr	l260c
			lda	curDrive
			clc
			adc	#$39
			sta	l2638
			lda	r1L
			ldy	#$15
			jsr	l260c
			lda	r1H
			ldy	#$1f
:l260c			pha
			jsr	l261b
			sta	l262b,y
			pla
			jsr	l261f
			sta	l262c,y
			rts
:l261b			lsr
			lsr
			lsr
			lsr
:l261f			and	#$0f
			ora	#$30
			cmp	#$3a
			bcc	l262a
:l2627			clc
			adc	#$07
:l262a			rts
:l262b			b $49
:l262c			b $3a,$32
			b $33
:l262f			b $20,$20,$1b
			b $4c,$66,$77
			b $6b,$2e,$20
:l2638			b $41,$20,$74
			b $72,$61,$63
			b $6b,$20
:l2640			b $30,$32
			b $20,$73,$65
			b $63,$74,$6f
			b $72,$20
:l264a			b $30,$36
			b $20,$28,$68
			b $65,$78,$29
			b $00
:l2653			b $03
:l2654			b $9a
:l2655			b $27,$04,$a7
			b $27,$21,$b8
			b $27,$26,$d5
			b $27,$80,$ec
			b $27
:l2662			b $00,$2b
			b $26
:l2665			ldy	#$00
:l2667			lda	(r0L),y
			sta	$0006,y
			iny
			cpy	#$06
			bne	l2667
:l2671			lda	$8c27
:l2674			sta	r6L
			ldx	#$06
			jsr	l26d4
			ldx	#$07
			jsr	l26d4
			ldx	#$08
:l2682			jsr	l26d4
			ldx	#$0a
			jsr	l26d4
:l268a			lda	r4L
			sec
			sbc	r3L
			sta	r4L
			lda	r2H
			sec
			sbc	r2L
			sta	r2H
			lda	r2L
			sta	r5L
			lda	#$00
			sta	r5H
			jsr	l26dc
			clc
			lda	#$00
			adc	r5L
			sta	r5L
			lda	#$8c
			adc	r5H
			sta	r5H
			lda	r3L
			clc
			adc	r5L
			sta	r5L
			bcc	l26bb
:l26b9			inc	r5H
:l26bb			ldy	r4L
:l26bd			lda	r6L
			sta	(r5L),y
			dey
			bpl	l26bd
:l26c4			clc
			lda	#$28
			adc	r5L
			sta	r5L
			bcc	l26cf
:l26cd			inc	r5H
:l26cf			dec	r2H
			bpl	l26bb
:l26d3			rts
:l26d4			lda	$00,x
			lsr
			lsr
			lsr
			sta	$00,x
			rts
:l26dc			lda	r5L
			asl

			rol	r5H
			asl
			rol	r5H
			clc
			adc	r5L
			bcc	l26eb
:l26e9			inc	r5H
:l26eb			asl
			rol	r5H
			asl
			rol	r5H
			asl
			rol	r5H
			sta	r5L
			rts
:l26f7			lda	$8ff0
			clv
			bvc	l2700
:l26fd			lda	screencolors
:l2700			jsr	l2536
			bcc	l2729
:l2705			tay
			lda	r0L
			pha
			lda	#$02
			sta	r2L
			lda	#$11
			sta	r2H
			lda	#$00
			sta	r3H
			lda	#$01
			sta	r3L
			lda	#$00
			sta	r4H
			lda	#$20
			sta	r4L
			sty	r6L
			jsr	l268a
			pla
			sta	r0L
:l2729			rts
			b $64,$65,$73,$6b
			b $54,$6f
:l2730			b $70,$20
:l2732			b $20,$47,$45
			b $20,$56,$32
			b $2e,$30,$00
			b $18
			b $42,$69,$74
			b $74,$65,$20
			b $44,$69,$73
			b $6b,$20,$65
:l2748			b $69,$6e,$6c
			b $65,$67
			b $65,$6e,$20
			b $6d,$69
:l2742			b $74
			b $00,$18,$49
			b $6e,$20
:l2758			b $4c,$61,$75
			b $66,$77,$65
			b $72,$6b,$3a
			b $20,$20
:l2763			b $41
			b $00,$18,$42
			b $69,$74,$74
			b $65,$20,$44
			b $69,$73,$6b
			b $20,$65
:l2772			b $69,$6e,$6c,$65,$67
			b $65,$6e,$3a
			b $00,$18,$41
			b $62,$67,$65
			b $62,$72,$6f
			b $63,$68,$65
			b $6e,$20,$77
			b $65,$67,$65
			b $6e,$00,$44
			b $69,$73,$6b
:l2792			b $66,$65,$68,$6c,$65,$72
			b $3a,$00,$44
			b $69,$73,$6b
:l279e			b $20,$7a,$75,$20,$76,$6f
			b $6c,$6c,$00
			b $56,$65,$72
			b $7a,$65
:l27ac			b $69,$63,$68,$6e
			b $69,$73,$20,$76
			b $6f,$6c,$6c,$00
:l27b8			b $46,$65,$68,$6c
			b $74,$20
			b $6f,$64,$65
			b $72,$20,$75
			b $6e,$66,$6f
			b $72,$6d,$61
			b $74,$69,$65
			b $72,$74,$20
			b $44,$69,$73
			b $6b,$00,$73
			b $63,$68,$72
			b $65,$69,$62
			b $73,$63,$68
			b $75,$74,$7a
			b $20,$61,$75
			b $66,$20,$44
			b $69,$73,$6b
			b $00,$44,$6f
:l27ee			b $70,$70
:l27f0			b $65,$6c
			b $73,$65,$69
			b $74,$67,$2e
			b $20,$44,$69
			b $73,$6b,$20
			b $69,$6e,$20
			b $31,$35,$34
			b $31,$00,$c2
			b $55,$ff,$d5
			b $be,$21,$7e
			b $e4,$51,$13
			b $be,$4a,$7d
			b $c1,$ff,$83
:l2816			b $c0,$00,$45
			b $a2,$10,$45
			b $a2,$10,$ab
			b $a5,$28,$ab
			b $95,$29,$11
			b $98,$c5,$11
			b $88,$c6,$11
			b $48,$82,$2b
			b $d8,$c2,$2a
			b $54,$c6,$27
			b $e5,$45,$46
			b $65,$29,$43
			b $c2,$28,$82
			b $72,$10,$8d
			b $ae
:l2841			b $10,$7a
			b $55,$ff,$d5
			b $aa,$aa,$aa
			b $b3,$ab,$ff
			b $aa,$55,$00
			b $55,$aa,$bc
			b $2a,$55,$80
			b $35,$ab,$1c
			b $6a,$56,$00
			b $ff,$ae,$3c
			b $a3,$59
:l2860			b $00
:l2861			b $75,$b3,$ff
			b $e9,$67,$ff
			b $9d,$c0,$00
			b $3d,$ff,$ff
			b $df,$80,$00
			b $5e,$9f,$c0
			b $5d,$80,$06
			b $5a,$80,$00
			b $75,$ff,$ff
			b $ea,$bf,$ff
			b $ff,$ff,$80
			b $00,$01,$80
			b $00,$01,$80
			b $00,$01,$80
			b $00,$03,$80
			b $3c,$02,$80
			b $66,$03,$80
			b $c3,$01,$80
			b $c3,$01,$80
			b $66,$01,$80
			b $3c,$c1,$80
			b $00,$c1,$80
			b $00,$01,$80
			b $00,$01,$80
			b $18,$01,$80
			b $18,$01,$80
			b $18,$01,$80
			b $18,$01,$80
			b $18,$01,$80
			b $00,$01,$ff
			b $ff,$ff
:l28bd			b $bf
			b $ff,$ff,$ff
			b $80,$00,$01
			b $80,$00,$01
			b $80,$00,$01
			b $80,$78,$07
			b $80,$fc,$04
			b $81,$86,$07
			b $81,$86,$01
			b $80,$0e,$01
			b $80,$1c
:l28db			b $01
			b $80,$38,$01
			b $80,$30,$01
			b $80,$30,$01
			b $80,$00,$01
			b $80,$30,$01
			b $80,$30,$01
			b $80,$00,$01
			b $80,$00,$01
			b $80,$00,$01
			b $80,$00,$01
			b $ff,$ff,$ff

			b $bf,$00,$00
			b $fc,$00,$01
			b $02,$ff,$fe
			b $01,$80,$00
			b $01,$80,$fc
			b $01,$81,$fc
			b $01,$83,$83
			b $e1,$83,$83
			b $c1,$83,$80
			b $01,$83,$83
			b $c1,$83,$83
			b $e1,$81,$fc
			b $01,$80,$fc
			b $01,$80,$00
			b $01,$81,$c1
			b $01,$82,$03
			b $01,$83,$c5
			b $01,$82,$2f
			b $81,$81,$c1
			b $01,$80,$00
			b $01,$ff,$ff
			b $ff,$a0,$ff
			b $ff,$81,$02
			b $83,$82,$87
			b $c2,$8f,$e2
			b $9f,$f2,$83
			b $82,$80,$02
			b $80,$02,$83
			b $82,$9f,$f2
			b $8f,$e2,$87
			b $c2,$83,$82
			b $81,$02,$ff
			b $ff,$a0,$ff
			b $ff
:l2961			b $c0,$01,$a0,$01
			b $90,$01
:l2967			b $88
:l2968			b $01,$84
			b $01,$82
			b $01,$81
			b $01,$80
			b $81,$80
			b $41,$80
			b $21,$80
			b $11,$80
			b $09,$80
			b $05,$80
			b $03,$80,$01
			b $96,$ff,$ff
			b $80,$01,$80
			b $01,$80,$01
			b $87,$e1,$87
			b $e1,$87,$e1
			b $80,$01,$80
			b $01,$80,$01
			b $ff,$ff,$04
			b $32,$00,$06
			b $08,$00,$ca
			b $00,$00,$00
			b $03,$00,$05
			b $00,$09,$00
			b $0f,$00,$13
			b $00,$19,$00
			b $1f,$00,$21
			b $00,$24,$00
			b $27,$00,$2d
			b $00,$31,$00
			b $34
			b $00,$38
			b $00,$3a
			b $00,$3f
			b $00,$43
			b $00,$46
			b $00,$4a,$00
			b $4e,$00,$52
			b $00,$56
			b $00,$5a
			b $00,$5e,$00
			b $62,$00,$66
			b $00,$68,$00
			b $6b,$00,$6e
			b $00,$72,$00
			b $75,$00,$79
			b $00,$7e,$00
			b $83,$00,$88
			b $00,$8c,$00
			b $91,$00,$95
			b $00,$99,$00
			b $9e,$00,$a3
			b $00,$a5,$00
			b $a8,$00,$ad
			b $00,$b1,$00
			b $b7,$00,$bc
			b $00,$c1,$00
			b $c6,$00,$cb
			b $00
:l2a04			b $d0,$00
:l2a06			b $d4,$00,$d8
			b $00,$dd,$00
			b $e3,$00,$e9
			b $00,$ed,$00
			b $f1,$00,$f5
			b $00,$fa,$00
			b $ff,$00,$03
			b $01,$07,$01
			b $0e,$01,$11
			b $01,$15,$01
			b $19,$01,$1c
			b $01,$20
			b $01,$24
			b $01,$27
:l2a2d			b $01
			b $2b,$01,$2f
			b $01,$31,$01
			b $34,$01,$38
			b $01,$3a,$01
			b $40,$01,$44
			b $01,$48,$01
:l2a40			b $4c,$01,$50
			b $01,$53,$01
			b $57,$01,$5a
			b $01,$5e,$01
			b $62,$01,$68
			b $01
:l2a50			b $6c,$01,$70
			b $01,$74,$01
			b $78,$01,$7d
			b $01,$81,$01
			b $86,$01,$8d
			b $01,$0a,$94
:l2a62			b $4c,$90,$94
			b $a8,$00,$00
			b $45,$98,$5c
			b $9c,$88,$00
			b $03,$38,$ce
			b $37,$3b,$9d
			b $29,$4a,$22
			b $93,$38,$ce
			b $37,$4a,$2a
			b $aa,$bb,$94
			b $a0,$01,$02
			b $01,$02,$08
			b $94,$40,$00
			b $00,$00,$80
			b $00,$00,$05
			b $52,$b8,$00
			b $0a,$be,$6d
			b $24,$a2,$71
			b $00,$02,$ac
			b $44,$d1,$05
			b $54,$05,$d0
			b $c1,$29,$44
			b $a2,$21,$29
			b $52,$36,$d4
			b $a5,$29,$42
			b $4a,$2a,$aa
			b $8a,$48,$00
			b $00,$9b,$13
			b $26
:l2ab7			b $6c,$05,$5a
			b $62,$63,$26
			b $d5,$55,$55
			b $73,$20,$24
			b $00,$08,$14
			b $c2,$1e,$22
			b $fb,$87,$04
			b $a4,$89,$59
			b $88,$8d,$28
			b $09,$79,$2e
			b $44,$bb,$a1
			b $e9,$62,$2a
			b $b4,$a5,$29
			b $22,$4a,$2a
			b $92,$92,$54
:l2ae4			b $a4,$00,$2a,$a5
			b $54,$aa,$96,$55
			b $55,$55,$4c,$95
			b $55,$25,$25,$52
			b $b8,$00,$00
			b $3e,$65,$a4
			b $22,$71,$00
			b $08,$a5,$05
			b $c5,$49,$44
			b $05
:l2b04			b $d0,$79
:l2b06			b $e9,$44
			b $a2,$25,$29
			b $52,$22,$94
			b $b9,$2e,$12
			b $49,$4a,$a9
			b $23,$d4,$aa
			b $00,$2a,$a5
			b $64,$aa,$96
			b $55,$55,$55
			b $46
			b $95,$55
			b $25,$45
			b $52,$a4,$00
			b $08,$14,$c9
			b $9c,$22
:l2b2d			b $a8,$10,$50
			b $45,$d8,$58

			b $88,$89,$20
			b $01,$09,$2e
			b $37,$3a,$1d
			b $2a,$4b,$a2
			b $93,$20,$c9
			b $62,$30,$85
:l2b45			b $29,$3a,$48,$60
			b $00,$1b,$13
			b $34,$6a,$95
			b $55,$52,$63
:l2b52			b $4c,$4c,$8a
			b $53,$73,$21
			b $b8,$00,$00
			b $00,$40,$00
			b $14,$00,$20
			b $00,$00,$00
			b $00,$00,$00
			b $40,$00
:l2b69			b $70,$00
:l2b6b			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$40
			b $00,$00,$00
			b $00,$00,$00
			b $01,$f8,$00
			b $00,$00
:l2b7f			b $40
:l2b80			b $20,$00,$00
			b $41,$00
			b $00,$00,$02
			b $00,$00,$00
			b $00,$18,$44
			b $69,$73,$6b
			b $65,$74,$74
			b $65,$20,$69
			b $73,$74,$20
			b $65,$69,$6e
			b $65,$20,$4e
			b $69,$63,$68
			b $74,$2d,$47
			b $45,$4f,$53
			b $2d,$44,$69
			b $73,$6b,$00
			b $4b,$6f,$6e
			b $76,$65,$72
			b $74,$69,$65
			b $72,$65,$6e
			b $3f,$00,$20
			b $4b
:l2bbf			b $20,$62,$65
			b $6c,$65,$67
			b $74,$00,$20
			b $4b,$20,$66
			b $72,$65
:l2bcd			b $69,$00,$50,$72
			b $65,$66,$65
			b $72,$65,$6e
			b $63
:l2bd8			b $65,$73,$a0,$a0
			b $a0,$a0,$a0,$50
:l2be0			b $61,$64,$20,$43
			b $6f,$6c,$6f,$72
:l2be8			b $20,$50,$72,$65
			b $66,$a0,$a0
			b $4c,$66,$77
			b $65,$72,$6b
:l2bf5			b $20,$41,$00
			b $4c,$66,$77
			b $65,$72,$6b
:l2bfe			b $20,$42,$00
			b $4c,$66,$77
			b $65,$72,$6b
			b $20,$43,$00
			b $6e,$69,$63
			b $68
			b $74,$20
			b $47,$45
			b $4f,$53,$00
			b $42,$41,$53
			b $49,$43,$2d
:l2c1b			b $50,$72
			b $67,$2e,$00
			b $41,$73,$73
			b $65
:l2c24			b $6d,$62,$6c
			b $65,$72,$70,$72
			b $67,$2e,$00
			b $72,$65,$69
			b $6e,$65,$20
			b $44,$61,$74
			b $65,$6e,$00
			b $65,$69,$6e
			b $65,$20,$53
:l2c40			b $79,$73,$74
:l2c43			b $65,$6d
			b $64,$61,$74
			b $65
:l2c49			b $69,$00,$48,$69
			b $6c,$66,$73,$70,$72
			b $67
:l2c53			b $2e,$00,$41,$70,$70
:l2c58			b $6c,$69,$6b
			b $61,$74,$69
			b $6f,$6e,$00
			b $44,$6f,$6b
			b $75,$6d,$65
			b $6e,$74,$00
			b $53,$63,$68
			b $72,$69,$66
			b $74,$61,$72
			b $74,$00,$44
			b $72,$75,$63
			b $6b,$65,$72
			b $74,$72,$65
			b $69,$62,$65
			b $72,$00,$20
			b $4e,$49,$43
			b $48
			b $54,$20
			b $41,$55
			b $46,$20,$44
			b $49,$53
			b $4b,$20
			b $00,$43
			b $36,$34,$20
			b $45,$69,$6e
			b $67
:l2c9d			b $61,$62
			b $65,$74
			b $72,$2e,$00
			b $44,$69,$73
			b $6b,$74,$72
			b $65,$69,$62
			b $65,$72,$00
			b $65,$69,$6e
			b $20,$53,$74
			b $61,$72,$74
:l2cb9			b $70,$72
			b $67
:l2cbc			b $2e,$00,$54
			b $65,$6d
			b $70,$6f
			b $72,$7b,$72
			b $00,$73
:l2cc8			b $65,$6c
			b $62,$73,$74
			b $61,$75,$73
			b $66,$7d,$68
			b $72,$65,$6e
			b $64,$00,$18
			b $4e,$75,$72
			b $20,$38,$20
			b $44,$61,$74
			b $65,$69,$65
			b $6e,$20,$64
			b $7d,$72,$66
			b $65,$6e,$20
			b $61,$75,$66
			b $20,$64,$65
			b $6d,$00,$52
			b $61
:l2cf8			b $6e,$64,$20
			b $6c,$69,$65
			b $67,$65,$6e
			b $2e,$00,$18
			b $44,$61,$74
			b $65,$69,$20
			b $6b,$61,$6e
			b $6e,$20,$6e
			b $69,$63,$68
			b $74,$20,$76
			b $6f,$6e,$00
			b $64,$65,$73
			b $6b,$54,$6f
:l2d1f			b $70,$20
			b $67,$65,$64
			b $72,$75,$63
			b $6b,$74,$20
			b $77,$65,$72
:l2d2d			b $64,$65,$6e
			b $2e,$00,$18
			b $44,$69,$65
			b $73,$65,$20
			b $44,$61,$74
			b $65,$69,$20
			b $6e,$69,$63
			b $68,$74,$20
			b $76,$6f,$6e
			b $00,$64,$65
			b $73,$6b,$54
			b $6f
:l2d4f			b $70,$20
			b $7a,$75,$20
			b $7c,$66,$66
			b $6e,$65,$6e
			b $2e,$00,$69
			b $6e,$00,$18
			b $4e,$69,$63
			b $68,$74,$20
:l2d66			b $6d,$7c,$67
			b $6c,$69,$63
:l2d6c			b $68,$2c,$20

			b $64,$61,$20
:l2d72			b $41,$70,$70
			b $6c
			b $69,$6b,$61
			b $74,$69,$6f
			b $6e,$00,$61
			b $75,$66,$20
			b $61,$6e,$64
			b $65,$72,$65
			b $72,$20,$44
			b $69,$73,$6b
			b $2e,$00,$18
			b $69,$73,$74
			b $20,$65,$72
			b $73,$74,$20
			b $7a
:l2d9b			b $75,$20
			b $6c,$7c,$73
			b $63,$68,$65
			b $6e,$20,$76
			b $6f,$6e,$00
			b $18,$44,$61
			b $74,$65,$69
			b $1b,$00,$18
			b $42,$69,$74
			b $74,$65,$20
			b $5a
:l2db9			b $69,$65
			b $6c,$64,$69
			b $73,$6b,$20
			b $69,$6e,$20
:l2dc4			b $4c,$61,$75
			b $66,$77,$65
			b $72,$6b,$20
:l2dcd			b $41,$00,$65
:l2dd0			b $69,$6e
			b $6c,$65,$67
			b $65
:l2dd6			b $6e,$00,$18
			b $4c,$65,$65
			b $72,$64,$69
			b $73,$6b
			b $20
:l2de2			b $69,$6e
			b $20,$4c,$61
			b $75,$66
			b $77,$65,$72
			b $6b,$20,$41
			b $20,$75,$6e
			b $64,$00,$18
			b $42,$69,$74
			b $74,$65,$20
			b $6e,$65,$75
			b $65,$6e,$20
			b $44,$69,$73
			b $6b,$6e,$61
			b $6d,$65,$6e
			b $20,$65
:l2e0c			b $69
			b $6e,$67,$65
			b $62,$65,$6e
			b $3a,$1b,$00
			b $18,$45,$72
			b $73,$65,$74
			b $7a,$65
:l2e1e			b $6e,$20,$49
			b $6e,$68,$61
			b $6c,$74,$20
			b $76,$6f,$6e
			b $00,$64,$75
			b $72,$63,$68
			b $20,$49
:l2e32			b $6e,$68,$61
			b $6c,$74,$20
			b $76,$6f,$6e
			b $00,$18,$44
			b $69,$65,$73
			b $65,$72,$20
			b $41,$72,$62
			b $65,$69,$74
			b $73,$67,$61
			b $6e,$67,$00
			b $64,$61,$72
			b $66,$20,$6e
			b $69,$63,$68
			b $74,$20,$61
			b $75,$66,$00
			b $64,$69,$65
			b $20,$53,$74
			b $61,$72,$74
			b $64,$69,$73
			b $6b,$65,$74
			b $74
:l2e6f			b $65,$00
			b $65,$69
			b $6e,$65,$20
			b $48
			b $61,$75
			b $70,$74
			b $64,$69,$73
			b $6b,$65,$74
			b $74,$65,$00
			b $44,$61,$74
			b $65,$69,$65
			b $6e,$20,$65
			b $69,$6e,$65
			b $72,$20,$61
			b $6e,$64,$65
			b $72,$65,$6e
			b $20,$44,$69
			b $73,$6b,$00
			b $61,$6e,$67
			b $65,$77,$65
			b $6e,$64,$65
			b $74,$20,$77
			b $65,$72,$64
			b $65,$6e,$2e
			b $00,$20,$44
			b $61,$74,$65
			b $69,$65,$6e
			b $00,$20,$67
			b $65,$77,$7b
:l2ec0			b $68
			b $6c,$74,$00
			b $18,$69,$73
			b $74,$20,$76
			b $6f,$72,$68
			b $61,$6e,$64
			b $65,$6e,$00
			b $44,$61,$74
			b $65,$69,$20
			b $61,$75,$66
			b $20,$64,$65
			b $72,$20,$5a
:l2ee2			b $69,$65
			b $6c,$64,$69
			b $73,$6b,$2e
			b $00,$5d,$62
			b $65,$72
:l2eef			b $73
			b $63,$68,$72
			b $65,$69,$62
			b $65,$6e,$3f
			b $00,$44,$45
			b $53,$4b
:l2efe			b $20,$54,$4f
			b $50,$00
:l2f03			b $20,$00,$18
			b $77,$7b
:l2f08			b $68
			b $6c,$65,$6e
			b $00,$44,$72
			b $75,$63,$6b
			b $65,$72,$00
			b $45,$69,$6e
			b $67,$61,$62
			b $65,$2d,$00
			b $67,$65,$72
			b $7b,$74,$00
			b $67,$65,$6f
			b $73,$00,$44
			b $61,$74,$65
			b $69,$00
:l2f2f			b $41
			b $6e,$7a,$65
			b $69,$67,$65
			b $00
:l2f37			b $57
:l2f38			b $61,$68
			b $6c,$00,$53
			b $65,$69,$74
			b $65,$00,$44
			b $69,$73,$6b
			b $65,$74,$74
			b $65,$00
:l2f4b			b $4f
:l2f4c			b $70,$74
			b $00,$47,$45
			b $4f,$53,$2d
			b $49,$6e,$66
			b $6f,$00,$64
			b $65,$73,$6b
			b $54,$6f
:l2f5f			b $70,$2d
:l2f61			b $49,$6e
			b $66,$6f
			b $00,$49,$6e
			b $66,$6f,$14
			b $5e,$00,$80
			b $18,$51,$1b
			b $00,$44,$72
			b $75,$63,$6b
:l2f77			b $65,$72
			b $20,$77,$7b
			b $68
			b $6c,$65,$6e
			b $00,$45,$69
			b $6e,$67,$61
			b $62,$65
:l2f88			b $20,$77,$7b
			b $68
			b $6c,$65,$6e

			b $14,$4c,$00
			b $80,$18,$49
			b $1b,$00,$5c
			b $66,$66,$6e
			b $65,$6e,$14
			b $5e,$00,$80
			b $18,$5a,$1b
			b $00,$75,$6d
			b $62,$65,$6e
			b $65,$6e,$6e
			b $65,$6e,$14
			b $5e,$00,$80
			b $18,$4d,$1b
			b $00,$64
:l2fb8			b $75,$70
			b $6c,$69,$7a
			b $69,$65,$72
			b $65,$6e
:l2fc2			b $14
			b $5e,$00,$80
			b $18,$48,$1b
			b $00,$64,$72
			b $75,$63,$6b
			b $65,$6e,$14
:l2fd2			b $5e,$00,$80
			b $18
			b $50,$1b
			b $00
:l2fd9			b $6c,$7c,$73
			b $63,$68,$65
			b $6e,$14,$5e
			b $00,$80,$18
			b $44,$1b,$00
			b $44,$61,$74
			b $65,$69,$20
			b $72,$65,$74
			b $74,$65
:l2ff3			b $6e
			b $14,$5e,$00
			b $80,$18,$55
			b $1b,$00
:l2ffc			b $50,$69
			b $6b,$74,$6f
			b $67,$72,$61
			b $6d,$6d,$65
			b $00,$6e,$61
			b $63,$68,$20
			b $4e,$61,$6d
			b $65,$6e,$00
			b $6e,$61,$63
			b $68,$20,$44
			b $61,$74,$75
			b $6d,$00,$6e
			b $61,$63,$68
			b $20,$47,$72
			b $7c
:l3026			b $7e,$65,$00
			b $6e,$61,$63
			b $68
			b $20,$54,$79
			b $70,$00
:l3032			b $5c,$66,$66
			b $6e,$65,$6e
			b $14,$9d,$00
			b $80,$18,$4f
			b $1b,$00,$53
			b $63
:l3042			b $68
			b $6c,$69,$65
			b $7e,$65,$6e
			b $14,$9d,$00
			b $80,$18,$43
			b $1b,$00,$55
			b $6d,$62,$65
			b $6e,$65,$6e
			b $6e,$65,$6e
			b $14,$9d,$00
			b $80,$18,$4e
			b $1b,$00,$4b
			b $6f
:l3065			b $70,$69
:l3067			b $65,$72
			b $65,$6e
			b $14,$9d,$00
			b $80,$18
			b $4b,$1b
			b $00,$41
			b $75,$66,$72
			b $7b,$75,$6d
			b $65,$6e,$14
			b $9d,$00,$80
			b $18,$56,$1b
			b $00
:l3084			b $6c,$7c,$73
			b $63,$68,$65
			b $6e,$14,$9d
			b $00,$80,$18
			b $45,$1b,$00
			b $46,$6f,$72
			b $6d,$61,$74
			b $69,$65,$72
			b $65,$6e,$14
			b $9d,$00,$80
			b $18,$46,$1b
			b $00,$61,$6e
			b $68,$7b,$6e
			b $67,$65,$6e
			b $14,$da,$00
			b $80,$18,$53
			b $1b,$00,$65
			b $6e,$74,$66
			b $65,$72,$6e
			b $65,$6e,$14
			b $da,$00,$80
			b $18,$54,$1b
			b $00
:l30c7			b $61,$6c
			b $6c,$65,$20
			b $53,$65
:l30ce			b $69,$74
:l30d0			b $65,$6e
			b $14,$e0,$00
			b $80,$18,$57
			b $1b,$00,$64
			b $69,$65,$73
			b $65,$20,$53
			b $65,$69,$74
			b $65,$14,$e0
			b $00,$80,$18
			b $58,$1b,$00
			b $44,$61,$74
			b $65,$69,$65
			b $6e,$20,$76
			b $6f,$6d,$20
			b $52,$61,$6e
			b $64,$14,$e0
			b $00,$80,$18
			b $59,$1b,$00
			b $55,$68,$72
			b $20,$73,$65
			b $74,$7a,$65
			b $6e,$00,$42
			b $41,$53,$49
			b $43,$00,$52
			b $45,$53,$45
			b $54,$14,$e8
			b $00,$80,$18
			b $52,$1b,$00
			b $54,$61,$73
			b $74,$65,$6e
			b $6b,$7d,$72
			b $7a,$65
			b $6c,$00
:l3130			b $18
:l3131			b $44,$69,$73
			b $6b,$20,$65
			b $6e,$74,$68
			b $7b
:l313b			b $6c,$74,$20
			b $6b,$65,$69
			b $6e,$65,$20
			b $44,$61,$74
			b $65,$69,$2e
			b $00
:l314b			b $4c,$65,$65
			b $72,$64,$69
			b $73,$6b
:l3153			b $20,$6b,$6f
			b $70,$69
			b $65,$72,$65
			b $6e,$3f,$00
			b $18,$4b,$65
			b $69,$6e,$65
			b $20,$4d,$65
			b $68,$72,$64
			b $61,$74,$65
			b $69,$65,$6e
			b $2d,$42,$65
			b $68,$61,$6e
			b $64
:l3177			b $6c,$75,$6e
			b $67,$00,$66
			b $7d,$72,$20
			b $64,$69,$65
			b $73,$65,$20
			b $4f
:l3187			b $70,$65
			b $72,$61,$74
			b $69,$6f,$6e
			b $2e,$00,$18
			b $4b,$65,$69
			b $6e,$65,$20
			b $67,$61,$6e
			b $7a,$73,$65
			b $69,$74,$69
			b $67,$65,$00
			b $4b,$6f
:l31a6			b $70,$69
:l31a8			b $65,$20
			b $7a,$77,$69
			b $73,$63,$68
			b $65,$6e,$20

			b $64,$69,$63
			b $73,$65,$6e
			b $16
:l31ba			b $50,$00
:l31bc			b $60
			b $62,$65
:l31bf			b $69,$64
:l31c1			b $65,$6e
			b $20,$46,$6f
			b $72,$6d,$61
			b $74,$65
:l31cb			b $6e,$2e,$00
:l31ce			jsr	l259d
:l31d1			lda	diskOpenFlg
			beq	l31e2
:l31d6			jsr	l237e
			jsr	l4819
			jsr	l4839
			jsr	l3228
:l31e2			txa
			beq	l31eb
:l31e5			jsr	l259d
			jsr	l367d
:l31eb			rts
:l31ec			jsr	l40ac
			jsr	l3296
			jsr	l253e
			sta	a0L
			lda	#$00
			sta	a8H
			lda	isGEOS
			bne	l322e
:l3200			ldx	#$32
			lda	#$c5
			jsr	l2483
			cmp	#$03
			bne	l322e
:l320b			jsr	GetDirHead
			jsr	l253e
:l3211			jsr	l361e
			cpx	#$06
			beq	l3221
:l3218			jsr	l253e
			jsr	PutDirHead
			jsr	l253e
:l3221			jsr	SetGEOSDisk
			txa
			beq	l31ec
:l3227			rts
:l3228			jsr	l3296
			txa
			bne	l326e
:l322e			jsr	l4183
:l3231			jsr	l32d7
			jsr	l32ff
			txa
			bne	l3269
:l323a			jsr	l34f3
			jsr	l3bcf
			lda	PrntFileName
			bne	l3261
:l3245			ldx	$0258
			beq	l3261
:l324a			lda	#$11
			jsr	l48bd
			ldx	$0258
			ldy	$0257
			lda	#$84
:l3257			sta	r3H
:l3259			lda	#$65
:l325b			jsr	l3289
			jsr	l3b2f
:l3261			jsr	l326f
			jsr	l5677
			ldx	#$00
:l3269			lda	#$ff
			sta	diskOpenFlg
:l326e			rts
:l326f			lda	$88cb
			bne	l3288
:l3274			ldx	$0256
			beq	l3288
:l3279			ldy	$0255
			lda	#$88
:l327e			sta	r3H
			lda	#$cb
			jsr	l3289
			jsr	l3b6c
:l3288			rts
:l3289			sta	r3L
			stx	r2H
			sty	r2L
			ldx	#$06
			ldy	#$08
			jmp	l2416
:l3296			jsr	l329c
			jmp	OpenDisk
:l329c			lda	#$04
:l329e			sta	r0L
			ora	#$80
			sta	l4c59
			lda	#$0e
			sta	r1L
			ldy	#$02
			ldx	#$04
			jsr	BBMult
			clc
			adc	#$0c
			clc
			adc	#$07
			and	#$f8
			sec
			sbc	#$01
			sta	l4c54
			clc
			adc	#$02
			sta	l4ed8
			rts
			b $81,$0b,$0c
			b $20,$8c,$2b
			b $0b,$0c
:l32cd			b $30,$af
			b $2b,$03,$01
			b $48,$04,$11
			b $48,$00
:l32d7			lda	$82bd
			cmp	#$50
			beq	l32df
:l32de			rts
:l32df			lda	$82be
			ora	$82bf
			bne	l32de
:l32e7			jsr	GetSerialNumber
			lda	r0L
			asl
			rol	r0H
			adc	#$00
			sta	$82be
			lda	r0H
			sta	$82bf
			jsr	PutDirHead
			jmp	GetDirHead
:l32ff			jsr	l3337
			jsr	l3a60
			jsr	l253e
			ldy	curDrive
			lda	driveType -8,y
			and	#$0f
			cmp	#$01
			bne	l331b
:l3314			ldx	#$80
			bit	$8203
			bmi	l3336
:l331b			jsr	l3912
			lda	r9H
			beq	l3328
:l3322			jsr	l3a49
			clv
			bvc	l331b
:l3328			jsr	l3376
			jsr	l34a2
			jsr	l253e
			jsr	l3394
			ldx	#$00
:l3336			rts
:l3337			jsr	i_GraphicsString
:l333a			b $05,$00,$01,$08
			b $00,$10,$03,$07
			b $01,$8f,$07,$08
			b $00,$10,$01,$08
:l334a			b $00,$1c,$02,$07
			b $01,$1c,$01,$08
			b $00,$28,$02,$07
			b $01,$28,$01,$08
:l335a			b $00,$8b,$02,$07
			b $01,$8b,$01,$08
			b $00,$8d,$02,$07
			b $01,$8d,$05,$09
:l336a			b $01,$09,$00,$11
			b $03,$06,$01,$1b
			b $00
:l3373			jmp	l26f7
:l3376			lda	#$82
			sta	r0H
			lda	#$90
			sta	r0L
			ldx	#$04
			jsr	l38e4
			jsr	l338b
			ldx	#$04
			jsr	l38be
:l338b			ldx	#$02
			ldy	#$04
			lda	#$12
			jmp	CopyFString
:l3394			jsr	l2447
			jsr	i_Rectangle
			b $1d,$27
			b $09,$00,$06,$01
			ldx	#$82
			lda	#$90
			jsr	l57bd

			jsr	l59ee
			lda	#$00
			sta	r11H
			lda	#$88
			sta	r11L
			lda	#$18
			sta	r1H
			jsr	l5805
			jsr	l3428
			jsr	l340a
			ldy	#$02
			ldx	#$02
			jsr	DShiftRight
			lda	#$00
			sta	r11H
			lda	#$8a
			sta	r11L
			jsr	l3423
			ldx	#$2b
			lda	#$bd
			jsr	l58ad
			jsr	l340a
			lda	r4H
			lsr
			ror	r4L
			lsr
			ror	r4L
			sta	r0H
			lda	r4L
			sta	r0L
			lda	#$00
			sta	r11H
			lda	#$cf
			sta	r11L
			jsr	l3423
			ldx	#$2b
			lda	#$c7
			jsr	l58ad
			ldx	#$02
			jsr	l38be
			jsr	l4819
			ldx	#$c0
			stx	r1L
			jmp	l36e0
:l340a			lda	#$82
			sta	r5H
			lda	#$00
			sta	r5L
			jsr	CalcBlksFree
			lda	r3L
			sec
			sbc	r4L
			sta	r0L
			lda	r3H
			sbc	r4H
			sta	r0H
			rts
:l3423			lda	#$c0
			jmp	PutDecimal
:l3428			jsr	l3912
			lda	r0L
			pha
			pla
			sta	r0L
			sta	a7H
			lda	#$00
			sta	r0H
			lda	#$00
			sta	r11H
			lda	#$10
			sta	r11L
			lda	#$24
			sta	r1H
			jsr	l3423
			ldx	#$2e
			lda	#$b2
			jsr	l58ad
			lda	#$00
			sta	r11H
			lda	#$56
			sta	r11L
			ldx	#$2e
			lda	#$bb
			jsr	l58ad
:l345c			lda	r0H
			pha
			lda	r0L
			pha
			lda	r1L
			pha
			lda	#$00
			sta	r11H
			lda	#$49
			sta	r11L
			lda	#$24
			sta	r1H
			jsr	l349d
			jsr	l349d
			lda	#$00
			sta	r11H
			lda	#$32
			sta	r11L
			lda	a6L
			bit	a2H
			bpl	l3488
:l3485			clc
			adc	#$01
:l3488			sta	r0L
			lda	#$00
			sta	r0H
			lda	#$64
			jsr	PutDecimal
			pla
			sta	r1L
			pla
			sta	r0L
			pla
			sta	r0H
			rts
:l349d			lda	#$20
			jmp	PutChar
:l34a2			lda	#$02
			sta	r5L
			lda	#$6d
			clc
			adc	a0L
			sta	r5H
			lda	#$08
			sta	r8L
			lda	#$08
			sta	r13H
			lda	#$46
			sta	r13L
:l34b9			ldy	#$00
			lda	(r5L),y
			beq	l34d6
:l34bf			ldy	#$16
			lda	(r5L),y
			beq	l34d6
:l34c5			ldy	#$13
			jsr	l1dda
			jsr	l253e
			ldx	#$0a
			ldy	#$1c
			lda	#$44
			jsr	CopyFString
:l34d6			clc
			lda	#$44
			adc	r13L
			sta	r13L
			bcc	l34e1
:l34df			inc	r13H
:l34e1			clc
			lda	#$20
			adc	r5L
			sta	r5L
			bcc	l34ec
:l34ea			inc	r5H
:l34ec			dec	r8L
			bne	l34b9
:l34f0			ldx	#$00
			rts
:l34f3			lda	$0251
			beq	l3552
:l34f8			sta	r1L
			lda	$0252
			sta	r1H
			jsr	l1de3
			jsr	l253e
			lda	$8002
			sta	maxMouseSpeed
			lda	$8003
			sta	minMouseSpeed
			lda	$8004
			sta	mouseAccel
			lda	$8005
			ora	$8006
			cmp	screencolors
			beq	l3530
			sta	$851e
			sta	l352f
			jsr	i_FillRam
			b $e8,$03
			b $00,$8c
:l352f			b $00
:l3530			ldy	$01
			lda	#$35
			sta	$01
			lda	$8007
			sta	mob0clr
			sta	mob1clr
			lda	$8047
			sta	extclr
			sty	$01
			ldy	#$3e
:l3549			lda	$8008,y
			sta	$84c1,y
			dey
			bpl	l3549
:l3552			lda	$0253
			beq	l3572
:l3557			sta	r1L

			lda	$0254
			sta	r1H
			jsr	l1de3
			jsr	l253e
			ldx	#$08
:l3566			lda	$8002,x
			sta	$8fe8,x
			dex
			bpl	l3566
:l356f			jsr	l26f7
:l3572			rts
:l3573			lda	#$03
			and	random
			bne	l35be
:l357a			lda	$82bd
			cmp	#$42
			bne	l35be
:l3581			ldy	#$09
:l3583			lda	$6d25,y
			cmp	l4d4c,y
			bne	l3590
:l358b			dey
			bpl	l3583
:l358e			bmi	l3598
:l3590			lda	$6d38
			cmp	#$0c
			beq	l35bf
:l3597			rts
:l3598			ldx	$6d04
			lda	$6d03
			jsr	l35ce
			bne	l35be
:l35a3			cpy	#$19
			bne	l35bf
:l35a7			cmp	#$fa
			bne	l35bf
:l35ab			ldx	$6d24
			lda	$6d23
			jsr	l35ce
			bne	l35be
:l35b6			cpy	#$4a
			bne	l35bf
:l35ba			cmp	#$e7
			bne	l35bf
:l35be			rts
:l35bf			lda	#$00
			ldy	#$02
:l35c3			sta	$6d00,y
			iny
			cpy	#$60
			bne	l35c3
:l35cb			jmp	l3b10
:l35ce			stx	r1H
			sta	r1L
			lda	#$8a
			sta	r0H
			lda	#$80
			sta	r0L
			ldy	#$00
			tya
:l35dd			sta	(r0L),y
			iny
			bne	l35dd
:l35e2			jsr	l1de3
			jsr	l253e
			ldy	$8001
			sty	r1H
			iny
			lda	#$00
			ldx	diskBlkBuf
			stx	r1L
			beq	l35fa
:l35f7			tay
			lda	#$02
:l35fa			sta	r2L
			clc
:l35fd			dey
			lda	$8000,y
			adc	(r0L),y
			sta	(r0L),y
			cpy	r2L
			bne	l35fd
:l3609			lda	r1L
			bne	l35e2
:l360d			ldy	#$00
			sty	r1L
			iny
			sty	r1H
			jsr	CRC
			ldy	r2H
			lda	r2L
			ldx	#$00
			rts
:l361e			jsr	l3627
			bne	l3626
:l3623			jsr	l3649
:l3626			rts
:l3627			ldy	#$01
			sty	r1L
			dey
			sty	r1H
			jsr	l1de3
			jsr	l253e
:l3634			ldy	#$00
			lda	(r4L),y
			cmp	#$43
			bne	l3648
:l363c			iny
			lda	(r4L),y
			cmp	#$42
			bne	l3648
:l3643			iny
			lda	(r4L),y
			cmp	#$4d
:l3648			rts
:l3649			lda	r1H
			sta	r6H
			lda	r1L
			sta	r6L
			lda	$0520
			cmp	#$02
			bcc	l365b
:l3658			jmp	AllocateBlock
:l365b			jsr	FindBAMBit
			beq	l3672
:l3660			lda	r8H
			eor	#$ff
			and	curDirHead,x
			sta	curDirHead,x
			ldx	r7H
			dec	curDirHead,x
			ldx	#$00
			rts
:l3672			ldx	#$06
			rts
:l3675			jsr	DoPreviousMenu
			lda	diskOpenFlg
			beq	l36c0
:l367d			jsr	l4086
			lda	#$02
			sta	r12L
			lda	#$12
			jsr	l485e
			jsr	l3337
			jsr	l4819
			jsr	l4839
			lda	#$00
			sta	$0200
			jsr	l329c
:l369a			ldx	#$04
			jsr	l38be
			lda	#$00
			tay
			sta	(r1L),y
			ldy	curDrive
			ldx	#$02
			jsr	l3bb6
			lda	#$00
			sta	r1L
			jsr	l4819
			jsr	l36e0
			jsr	l5984
			ldx	#$00
			stx	a8H
			stx	diskOpenFlg
:l36c0			rts
:l36c1			b $37,$37,$37
:l36c4			b $7c
:l36c5			sty	$8c
:l36c7			ldx	#$04
			jsr	l38be
			ldy	#$04
			jsr	l5a09
			lda	#$12
			jsr	CopyFString
			jsr	l599f
			jsr	l4819
			ldx	#$40
			stx	r1L
:l36e0			tay
			lda	r1L
			sta	l3e37
			lda	r0H
			pha
			lda	r0L
			pha
			tya
			jsr	l4839
			tay
			pla
			sta	r0L
			pla
			sta	r0H
			tya
			jsr	l4829
			pha
			sec
			sbc	#$14
			tay
			lda	l36c1,y
			sta	r0H
			lda	l36c4,y

			sta	r0L
			pla
			pha
			jsr	l49e0
			pla
			tay
			lda	l3e37
			and	#$40
			bne	l372c
:l3718			tya
			pha
			ldx	#$0c
			jsr	l49c7
			lda	#$bd
			ldy	#$00
			sta	(r5L),y
			iny
			lda	#$28
			sta	(r5L),y
			pla
			tay
:l372c			lda	#$01
			sta	$36
			lda	#$08
			sta	$35
			tya
			pha
			jsr	l4a06
			lda	l3e37
			and	#$40
			beq	l376c
:l3740			pla
			pha
			cmp	#$14
			bne	l3757
:l3746			lda	#$28
			sta	r1H
			lda	#$01
			sta	r11H
			lda	#$1a
			sta	r11L
			lda	#$41
			clv
			bvc	l3769
:l3757			cmp	#$15
			bne	l376c
:l375b			lda	#$4c
			sta	r1H
			lda	#$01
			sta	r11H
			lda	#$1a
			sta	r11L
			lda	#$42
:l3769			jsr	PutChar
:l376c			pla
			ldx	l3e37
			bpl	l3775
:l3772			jsr	l487a
:l3775			lda	#$00
			sta	$35
			sta	$36
			rts
			b $7d,$28,$23
			b $18,$03,$15
			b $94,$37,$7d
			b $28,$23,$3c
			b $03,$15,$94
			b $37,$7d,$28
			b $23,$68,$03
:l3791			b $15,$06
			sec
			lda	curDrive
			sta	a6H
			bit	a2H
			bvc	l37e6
:l379d			ldx	#$37
			lda	#$ad
			jsr	l55af
			jsr	l4718
			bne	l37ac
:l37a9			jmp	l3228
:l37ac			rts
:l37ad			jsr	l477b
			cmp	#$0c
			bne	l37b7
:l37b4			jmp	l5139
:l37b7			jsr	l384f
			jsr	l59d8
			jsr	l3f08
			lda	a2L
			cmp	curDrive
			bne	l37cd
:l37c7			jsr	l4003
			jmp	l31d1
:l37cd			jsr	l23e1
			beq	l37da
:l37d2			lda	#$00
			sta	$024d
			jsr	l237e
:l37da			jsr	l3a60
			jsr	l4a5f
			jsr	l59ca
			jmp	l3ffd
:l37e6			lda	r0L
:l37e8			jsr	l4839
			jsr	l4822
			sta	a6H
			ldx	diskOpenFlg
			beq	l3800
:l37f5			cmp	curDrive
			beq	l3800
:l37fa			jsr	l4819
			jsr	l487a
:l3800			jsr	l23dc
			jmp	l4f56
:l3806			lda	$024c
			beq	l380e
:l380b			jmp	l4190
:l380e			bit	a2H
			bvc	l3815
:l3812			jmp	l4086
:l3815			jsr	l4086
			lda	#$16
			jsr	l40de
			lda	#$01
			sta	$84bb
			lda	#$08
			sta	mouseLeft
			lda	#$8b
			sta	mouseBottom
			lda	#$0d
			sta	mouseTop
			lda	#$ff
			sta	$024c
			rts
:l3837			lda	#$08
			bne	l3844
:l383b			ldy	numDrives
			dey
			bne	l3842
:l3841			rts
:l3842			lda	#$09
:l3844			pha
			jsr	l4086
			pla
			jsr	l481c
			jmp	l37e8
:l384f			lda	curDrive
			sta	a6H
			lda	a3L
			sta	a3H
			lda	r0L
			jsr	l4822
			sta	a2L
			tay
			ldx	#$04
			jsr	l38c1
			lda	numDrives
			cmp	#$02
			bcc	l3870
:l386c			tya
			eor	#$01
			tay
:l3870			sty	a1H
			ldy	#$00
			lda	(r1L),y
			beq	l38b4
:l3878			lda	a3L
			ldx	#$06
			jsr	l4742
			ldy	#$04
			lda	#$12
			jsr	CmpFString
			beq	l38b4
:l3888			lda	r2H
			sta	$03f7
			lda	r2L
			sta	$03f6
			lda	r1H
			sta	$03f9
			lda	r1L
			sta	$03f8
			jsr	l2350
			txa
			bne	l38b6
:l38a2			jsr	l4339
			txa
			bne	l38b6
:l38a8			sta	a0H
			jsr	l19ab
			txa
			bne	l38b6
:l38b0			ldx	#$00
			beq	l38b6
:l38b4			ldx	#$ff
:l38b6			txa
			pha
			jsr	l23dc
			pla
			tax
			rts
:l38be			lda	curDrive

:l38c1			cmp	#$08
			beq	l38db
:l38c5			cmp	#$09
			beq	l38d2
:l38c9			lda	#$36
			sta	$00,x
			lda	#$02
			sta	$01,x
			rts
:l38d2			lda	#$24
			sta	$00,x
			lda	#$02
			sta	$01,x
			rts
:l38db			lda	#$12
			sta	$00,x
			lda	#$02
			sta	$01,x
			rts
:l38e4			lda	#$00
			sta	$00,x
			lda	#$02
			sta	$01,x
			rts
:l38ed			lda	numDrives
			cmp	#$02
			bcc	l3902
:l38f4			jsr	l1aec
			jsr	l237e
			txa
			pha
			jsr	l1aec
			pla
			bne	l3905
:l3902			jsr	l237e
:l3905			rts
:l3906			ldx	#$04
			jsr	l38be
			ldx	#$00
			ldy	#$00
			lda	(r1L),y
			rts
:l3912			lda	#$00
			sta	r0L
			sta	$0251
			sta	$0253
			sta	$0256
			sta	$0258
			sta	r9H
			sta	r3L
			lda	#$0a
			sta	r1H
			lda	#$62
			sta	r1L
			lda	#$6d
			sta	r2H
:l3932			ldy	#$00
			sty	r2L
			lda	(r2L),y
			pha
:l3939			jsr	l3985
			clc
			lda	#$20
			adc	r2L
			sta	r2L
			bcc	l3947
:l3945			inc	r2H
:l3947			lda	r2L
			bne	l3939
:l394b			pla
			bne	l3932
:l394e			lda	isGEOS
			beq	l395e
:l3953			lda	#$7f
			cmp	r2H
			bcc	l395e
:l3959			sta	r2H
			clv
			bvc	l3932
:l395e			lda	r0L
			pha
			lda	r3L
			clc
			adc	#$04
			jsr	l329e
			lda	r9H
			pha
			lda	r9L
			pha
			jsr	l58f4
			pla
			sta	r9L
			pla
			sta	r9H
			lda	#$ff
			sta	$024d
			pla
			sta	r0L
			lda	#$00
			sta	r0H
			rts
:l3985			ldy	#$02
			lda	(r2L),y
			bne	l398c
:l398b			rts
:l398c			inc	r0L
			ldy	#$18
			lda	(r2L),y
			cmp	#$05
			bne	l39bd
:l3996			lda	r3L
			cmp	#$08
			bcs	l39bd
:l399c			ldy	#$15
			bne	l39a6
:l39a0			lda	(r2L),y
			cmp	#$a0
			bne	l39a8
:l39a6			lda	#$00
:l39a8			dey
			sta	(r1L),y
			cpy	#$05
			bcs	l39a0
:l39af			clc
			lda	#$11
			adc	r1L
			sta	r1L
			bcc	l39ba
:l39b8			inc	r1H
:l39ba			inc	r3L
			rts
:l39bd			cmp	#$0a
			bne	l39d6
:l39c1			lda	$0256
			bne	l39d6
:l39c6			lda	r2L
			clc
			adc	#$05
			sta	$0255
			lda	r2H
			adc	#$00
			sta	$0256
			rts
:l39d6			cmp	#$09
			bne	l39ef
:l39da			lda	$0258
			bne	l39ef
:l39df			lda	r2L
			clc
			adc	#$05
			sta	$0257
			lda	r2H
			adc	#$00
			sta	$0258
			rts
:l39ef			cmp	#$04
			bne	l3a29
:l39f3			lda	#$2b
			sta	r5H
			lda	#$ca
			sta	r5L
			jsr	l3a3b
			bne	l3a0e
:l3a00			ldy	#$03
			lda	(r2L),y
			sta	$0251
			iny
			lda	(r2L),y
			sta	$0252
			rts
:l3a0e			lda	#$2b
			sta	r5H
			lda	#$da
			sta	r5L
			jsr	l3a3b
			bne	l3a3a
:l3a1b			ldy	#$03
			lda	(r2L),y
			sta	$0253
			iny
			lda	(r2L),y
			sta	$0254
			rts
:l3a29			cmp	#$0d
			bne	l3a3a
:l3a2d			lda	r2L
			clc
			adc	#$02
			sta	r9L
			lda	r2H
			adc	#$00
			sta	r9H
:l3a3a			rts
:l3a3b			ldy	#$05
:l3a3d			lda	(r2L),y
			cmp	(r5L),y
			bne	l3a48
:l3a43			iny
			cpy	#$15
			bcc	l3a3d
:l3a48			rts
:l3a49			jsr	FreeFile

			ldy	#$00
			tya
			sta	(r9L),y
			lda	r9H
			cmp	#$7f
			bne	l3a5a
:l3a57			jmp	l3b00
:l3a5a			sec
			sbc	#$6d
			jmp	l3b10
:l3a60			ldx	#$ff
			lda	#$00
:l3a64			sta	$7eff,x
			dex
			bne	l3a64
:l3a6a			lda	#$6d
			sta	r4H
			lda	#$00
			sta	r4L
			jsr	l3aac
			sty	r1H
			lda	#$12
			sta	r2L
			jsr	l3ad5
			jsr	l253e
			lda	#$11
			sec
			sbc	r2L
			sta	a1L
			ldx	#$00
			cmp	#$0a
			bcc	l3a8e
:l3a8e			lda	isGEOS
			beq	l3aab
:l3a93			jsr	l3a99
			jmp	GetBlock
:l3a99			lda	#$7f
			sta	r4H
			lda	#$00
			sta	r4L
			lda	$82ac
			sta	r1H
			lda	$82ab
			sta	r1L
:l3aab			rts
:l3aac			lda	#$00
			sta	r1H
			jsr	l3ac3
			bne	l3abc
:l3ab5			lda	#$12
			sta	r1L
			ldy	#$01
			rts
:l3abc			lda	#$28
			sta	r1L
			ldy	#$03
			rts
:l3ac3			ldy	curDrive
			lda	driveType -8,y
			and	#$0f
			cmp	#$03
			beq	l3ad2
:l3acf			ldy	#$00
			rts
:l3ad2			ldy	#$ff
			rts
:l3ad5			jsr	EnterTurbo
			txa
			bne	l3af9
:l3adb			jsr	InitForIO
:l3ade			jsr	ReadBlock
			txa
			bne	l3af9
:l3ae4			dec	r2L
			beq	l3af9
:l3ae8			ldy	#$00
			lda	(r4L),y
			beq	l3af9
:l3aee			sta	r1L
			iny
			lda	(r4L),y
			sta	r1H
			inc	r4H
			bne	l3ade
:l3af9			jmp	DoneWithIO
:l3afc			cmp	#$08
			bcc	l3b0e
:l3b00			ldx	#$00
			lda	isGEOS
			beq	l3b0d
:l3b07			jsr	l3a99
			jsr	PutBlock
:l3b0d			rts
:l3b0e			lda	a0L
:l3b10			pha
			clc
			adc	#$6c
			sta	r4H
			ldy	#$00
			sty	r4L
			iny
			jsr	l3aac
			pla
			bne	l3b24
:l3b21			tya
			bne	l3b28
:l3b24			ldy	#$01
			lda	(r4L),y
:l3b28			sta	r1H
			inc	r4H
			jmp	PutBlock
:l3b2f			jsr	l46d3
			jsr	l58f4
			ldx	#$0c
			jsr	l38e4
			lda	#$84
			sta	r6H
			lda	#$76
			sta	r6L
			ldx	#$0c
			ldy	#$0e
			lda	#$12
			jsr	l2418
:l3b4b			txa
			pha
			lda	$88c4
			and	#$20
			beq	l3b62
:l3b54			ldy	#$06
:l3b56			lda	l3b65,y
			sta	$0002,y
			dey
			bpl	l3b56
:l3b5f			jsr	StashRAM
:l3b62			pla
			tax
			rts
:l3b65			b $00,$84,$00
			b $79,$00
:l3b6a			b $05,$00
:l3b6c			lda	#$00
			sta	r0L
			lda	#$88
			sta	r6H
			lda	#$cb
			sta	r6L
			jsr	GetFile
			txa
			bne	l3ba1
:l3b7e			lda	version
			cmp	#$13
			bcc	l3b9a
:l3b85			lda	$88c4
			and	#$20
			beq	l3b9a
:l3b8c			ldy	#$06
:l3b8e			lda	l3ba8,y
			sta	$0002,y
			dey
			bpl	l3b8e
:l3b97			jsr	StashRAM
:l3b9a			jsr	$fe80
:l3b9d			ldx	#$00
			beq	l3ba5
:l3ba1			cpx	#$05
			beq	l3b9d
:l3ba5			jmp	l3b4b
:l3ba8			b $80,$fe,$c0
			b $fa,$7a
:l3bad			b $01,$00
			lda	curDrive
			eor	#$01
			tay
			rts
:l3bb6			tya
			pha
			sec
			sbc	#$08
			tay
			lda	l3bc9,y
			sta	$01,x
			lda	l3bcc,y
			sta	$00,x
			pla
			tay
			rts
:l3bc9			b $2b,$2b
:l3bcb			b $2c
:l3bcc			b $ef,$f8,$01
:l3bcf			lda	$7d
			bne	l3bd6
:l3bd3			jsr	l5984
:l3bd6			jsr	l3bdf
			jsr	l4bd8
			jmp	l3c40
:l3bdf			jsr	l58b4
			jsr	l5954
			bcs	l3bfa
:l3be7			lda	#$ff
			sta	a9H
			jsr	l5420

			beq	l3bfa
:l3bf0			lda	#$00
			sta	a7L
			jsr	l589a
			jsr	l4bd8
:l3bfa			ldy	a7L
			lda	l3c05,y
			ldx	l3c0a,y
			jmp	CallRoutine
:l3c05			b $0f,$40,$43,$46,$49
:l3c0a			b $3c,$55,$55,$55,$55
:l3c0f			lda	#$00
:l3c11			jsr	l4552
			clc
			adc	#$01
			cmp	#$08
			bcc	l3c11
:l3c1b			sec
			sbc	#$01
:l3c1e			jsr	l4a06
			sec
			sbc	#$01
			bpl	l3c1e
:l3c26			lda	#$00
			sta	r11H
			lda	#$88
			sta	r11L
			lda	#$7f
			sta	r1H
			lda	#$00
			sta	r0H
			ldx	a0L
			inx
			stx	r0L
			lda	#$c0
			jmp	PutDecimal
:l3c40			bit	a2H
			bmi	l3c66
:l3c44			jsr	l3c7c
			lda	#$7f
			sta	r14H
			lda	#$02
			sta	r14L
:l3c4f			jsr	l44d7
			jsr	l59ca
			clc
			lda	#$20
			adc	r14L
			sta	r14L
			bcc	l3c60
:l3c5e			inc	r14H
:l3c60			lda	r14H
			cmp	#$80
			bcc	l3c4f
:l3c66			jsr	l46c7
			jsr	l46a8
			lda	a8H
			beq	l3c7b
:l3c70			lda	#$18
			sta	r0H
			lda	#$94
			sta	r0L
			jsr	l595f
:l3c7b			rts
:l3c7c			ldx	#$1e
			jsr	l38e4
			lda	#$03
			sta	r15H
			lda	#$34
			sta	r15L
			lda	#$08
			sta	a4H
:l3c8d			ldx	#$20
			ldy	#$1e
			lda	#$12
			jsr	CmpFString
			bne	l3cae
:l3c98			lda	#$00
			tay
			sta	(r15L),y
			lda	a4H
			ldx	#$0c
			jsr	l467e
			lda	#$00
			tay
			sta	(r5L),y
			lda	a4H
			jsr	l485a
:l3cae			clc
			lda	#$12
			adc	r15L
			sta	r15L
			bcc	l3cb9
:l3cb7			inc	r15H
:l3cb9			inc	a4H
			lda	a4H
			cmp	#$10
			bcc	l3c8d
:l3cc1			rts
:l3cc2			jsr	DoPreviousMenu
:l3cc5			lda	curDrive
			sta	a6H
			bit	a2H
			bpl	l3d16
:l3cce			lda	a6L
			beq	l3cd5
:l3cd2			jmp	l563e
:l3cd5			jsr	l3f0c
			lda	a4L
			bne	l3ce2
:l3cdc			jsr	l5129
			jmp	l3ffd
:l3ce2			jsr	l38ed
			lda	#$ff
			sta	l3d17
			lda	numDrives
			pha
			lda	$0af0
			beq	l3d01
:l3cf3			jsr	l1aec
			jsr	PurgeTurbo
			jsr	l1aec
			lda	#$01
			sta	numDrives
:l3d01			jsr	l477b
			jsr	l3d18
			pla
			sta	numDrives
			lda	l3d17
			beq	l3d16
:l3d10			jsr	l38ed
			jsr	l59ca
:l3d16			rts
:l3d17			b $00
:l3d18			pha
			ldy	#$1d
:l3d1b			lda	(a5L),y
			sta	$8400,y
			dey
			bpl	l3d1b
:l3d23			jsr	l5a2f
			pla
			cmp	#$03
			bcc	l3d51
:l3d2b			cmp	#$05
			bne	l3d32
:l3d2f			jmp	l4f16
:l3d32			cmp	#$06
			beq	l3d3a
:l3d36			cmp	#$0e
			bne	l3d3d
:l3d3a			jmp	l3d65
:l3d3d			cmp	#$07
			bne	l3d44
:l3d41			jmp	l3da6
:l3d44			lda	#$00
			sta	l3d17
			ldy	#$02
			jsr	l246b
			jmp	l3ffd
:l3d51			ldy	#$00
			lda	(r9L),y
			and	#$0f
			cmp	#$02
			bne	l3d44
:l3d5b			jsr	l555e
			cpx	#$0a
			beq	l3d44
:l3d62			jmp	l259d
:l3d65			lda	#$c2
			pha
			lda	#$2b
			pha
			jsr	l2514
			jsr	l3d80
			lda	#$00
			sta	r0L
			jmp	LdApplic
:l3d78			b $04,$3e
:l3d7a			b $06,$38
:l3d7c			b $39,$41
:l3d7e			b $68,$c8
:l3d80			lda	r2L
			pha
			ldx	#$01
:l3d85			lda	l3d78,x
			sta	r1H
			lda	l3d7a,x
			sta	r1L
			lda	l3d7c,x
			sta	r0H
			lda	l3d7e,x
			sta	r0L
			jsr	ClearRam
			dex
			bpl	l3d85
:l3d9f			pla
			sta	r2L
			stx	l3e20 +2
			rts
:l3da6			lda	#$80
			sta	l3e37

			lda	r9L
			clc
			adc	#$03
			sta	r4L
			lda	r9H
			adc	#$00
			sta	r4H
			jsr	l5a14
			ldx	#$0a
			ldy	#$08
			jsr	l2416
			jsr	l5a00
			ldx	#$0a
			jsr	l38e4
			ldx	#$0a
			ldy	#$06
			lda	#$12
			jsr	CopyFString
			ldy	#$13
			lda	(r9L),y
			sta	r1L
			iny
			lda	(r9L),y
			sta	r1H
			jsr	l1de3
			txa
			beq	l3dea
:l3de4			jsr	l259d
:l3de7			jmp	l5060
:l3dea			lda	$8075
			bne	l3df2
:l3def			jmp	l3d44
:l3df2			lda	#$80
			sta	r1H
			lda	#$75
			sta	r1L
			lda	#$8b
			sta	r10H
			lda	#$e4
			sta	r10L
			ldx	#$04
			ldy	#$16
			lda	#$0c
			jsr	l2418
			jsr	l3e3b
			cpx	#$0c
			beq	l3de7
:l3e12			txa
			bne	l3de4
:l3e15			lda	$8b80
			beq	l3de7
:l3e1a			jsr	l2514
			jsr	l5a00
:l3e20			jsr	l5a14
			jsr	l256e
			jsr	l3d80
			lda	l3e37
			sta	r0L
			lda	#$c2
			pha
			lda	#$2b
			pha
			jmp	GetFile
:l3e37			b $00
:l3e38			lda	#$04
			b $2c
:l3e3b			lda	#$06
			sta	r7L
			jsr	l1ab5
			txa
			bne	l3e4a
:l3e45			lda	$8b80
			bne	l3ea8
:l3e4a			jsr	l3eae
			txa
			bne	l3e74
:l3e50			ldy	numDrives
			dey
			beq	l3e64
:l3e56			jsr	l1aec
:l3e59			jsr	l1ab5
			txa
			bne	l3e64
:l3e5f			lda	$8b80
			bne	l3ea8
:l3e64			lda	$0249
			bne	l3ea6
:l3e69			jsr	l59e7
			bpl	l3e7f
:l3e6e			lda	r7L
			cmp	#$04
			beq	l3e7c
:l3e74			ldy	#$06
			jsr	l246b
			clv
			bvc	l3ea6
:l3e7c			jsr	l1aec
:l3e7f			ldy	curDrive
			ldx	#$0c
			jsr	l3bb6
			lda	r7L
			pha
			lda	r10H
			pha
			lda	r10L
			pha
			ldx	#$3e
			lda	#$cb
			jsr	l2483
			pla
			sta	r10L
			pla
			sta	r10H
			pla
			sta	r7L
			lda	r0L
			cmp	#$01
			beq	l3e59
:l3ea6			ldx	#$0c
:l3ea8			ldy	#$00
			sty	$0249
			rts
:l3eae			ldx	#$00
			lda	r7L
			cmp	#$04
			beq	l3eca
:l3eb6			lda	$88c3
			bne	l3eca
:l3ebb			ldy	numDrives
			dey
			beq	l3ec9
:l3ec1			lda	driveType
			cmp	$848f
			beq	l3eca
:l3ec9			dex
:l3eca			rts
:l3ecb			b $81,$0b,$10,$10
			b $3b,$27,$0c
:l3ed2			b $10,$20
:l3ed4			b $16,$0b
			b $10,$30,$5c
:l3ed9			b $2d,$0c,$1c
			b $30,$0c
			b $01,$01,$48
			b $02,$11,$48
			b $00
:l3ee5			asl
			asl
			asl
			asl
			asl
:l3eea			bcc	l3ef0
:l3eec			ora	#$1f
			bne	l3ef2
:l3ef0			ora	a0L
:l3ef2			rts
:l3ef3			b $bd
:l3ef4			b $b2,$18
:l3ef6			pha
			and	#$1f
			tay
			pla
			lsr
			lsr
			lsr
			lsr
			lsr
			cpy	#$1f
			bne	l3f07
:l3f04			clc
			adc	#$08
:l3f07			rts
:l3f08			ldx	$024b
			b $2c
:l3f0c			ldx	$78
:l3f0e			lda	r0H
			pha
			lda	r0L
			pha
			txa
			pha
			jsr	l3ef3
			sta	a3L
			cmp	#$08
			bcs	l3f2a
:l3f1f			tya
			jsr	l4b16
			cpx	#$ff
			bne	l3f2a
:l3f27			jmp	l23c2
:l3f2a			lda	a3L
			jsr	l4724
			stx	a4L
			ldx	#$08
			jsr	l467e
			lda	r3H
			sta	a5H
			lda	r3L
			sta	a5L
			pla
			tax
			pla

			sta	r0L
			pla
			sta	r0H
			rts
:l3f47			jsr	l5954
			bcc	l3f99
:l3f4c			lda	diskOpenFlg
			beq	l3f99
:l3f51			bit	a2H
			bpl	l3f70
:l3f55			bvc	l3f5a
:l3f57			jmp	l4156
:l3f5a			lda	r0L
			jsr	l4065
			cpx	#$ff
			bne	l3f73
:l3f63			jsr	l3f9a
			beq	l3f70
:l3f68			jsr	l59a8
			beq	l3f70
:l3f6d			jsr	l3fa4
:l3f70			jmp	l3fbf
:l3f73			lda	a3L
			pha
			jsr	l3f0e
			pla
			sec
			sbc	a3L
			sta	r14L
			jsr	l59a8
			bne	l3f87
:l3f84			jmp	l3ffd
:l3f87			ldx	r0H
			beq	l3f96
:l3f8b			ldx	a6L
			bne	l3f96
:l3f8f			lda	r14L
			bne	l3f84
:l3f93			jmp	l3cc5
:l3f96			jmp	l40be
:l3f99			rts
:l3f9a			cmp	#$08
			bcs	l3fb6
:l3f9e			lda	a2H
			and	#$20
			beq	l3fbc
:l3fa4			lda	a0L
			pha
			lda	a3L
			pha
			jsr	l4086
			pla
			sta	a3L
			pla
			sta	a0L
			ldx	#$00
			rts
:l3fb6			lda	a2H
			and	#$20
			beq	l3fa4
:l3fbc			ldx	#$ff
			rts
:l3fbf			lda	a2H
			ldx	r0L
			cpx	#$08
			bcc	l3fcb
:l3fc7			ora	#$20
			bne	l3fcd
:l3fcb			and	#$df
:l3fcd			sta	a2H
			jsr	l4183
			bit	a2H
			bpl	l3fd8
:l3fd6			inc	a6L
:l3fd8			lda	#$80
			ora	a2H
			sta	a2H
			ldx	a6L
			lda	r0L
			jsr	l3ee5
			sta	$18b2,x
			jsr	l3f0e
			lda	r0L
			jsr	l487a
			lda	a3L
			jsr	l4724
			stx	a4L
			jsr	l345c
			ldx	#$00
			rts
:l3ffd			lda	#$ff
			sta	r3H
			bne	l4007
:l4003			lda	#$00
			sta	r3H
:l4007			lda	r0H
			pha
			lda	r0L
			pha
			lda	r1H
			pha
			lda	r1L
			pha
			lda	a3L
			jsr	l405d
			beq	l4027
:l401a			jsr	l4183
			lda	r3H
			beq	l4024
:l4021			jsr	l4878
:l4024			jsr	l4036
:l4027			pla
			sta	r1L
			pla
			sta	r1H
			pla
			sta	r0L
			pla
			sta	r0H
			ldx	#$00
			rts
:l4036			ldx	a6L
			stx	r0H
			jsr	l4063
:l403d			lda	r0H
			beq	l4057
:l4041			lda	$18b3,x
			sta	$18b2,x
			inx
			cpx	r0H
			bcc	l403d
:l404c			dec	$024b
			dec	a6L
			lda	a6L
			cmp	#$ff
			bne	l405a
:l4057			jsr	l40ac
:l405a			jmp	l345c
:l405d			jsr	l4065
			cpx	#$ff
			rts
:l4063			lda	a3L
:l4065			pha
			bit	a2H
			bpl	l4082
:l406a			sta	r3L
			ldx	a6L
:l406e			jsr	l3ef3
			cmp	#$08
			bcs	l4079
:l4075			cpy	a0L
			bne	l407d
:l4079			cmp	r3L
			beq	l4084
:l407d			dex
			cpx	#$ff
			bne	l406e
:l4082			ldx	#$ff
:l4084			pla
			rts
:l4086			lda	diskOpenFlg
			beq	l40a9
:l408b			lda	r0L
			pha
			lda	#$0f
:l4090			pha
			jsr	l405d
			beq	l4099
:l4096			jsr	l487a
:l4099			pla
			sec
			sbc	#$01
			bpl	l4090
:l409f			jsr	l40a9
			jsr	l345c
			pla
			sta	r0L
			rts
:l40a9			jsr	l4183
:l40ac			lda	#$00
			sta	a2H
			sta	a6L
			sta	$024b
			sta	a4L
			sta	a3L
			sta	a5L
			sta	a5H
			rts
:l40be			lda	a2H
			ora	#$40
			sta	a2H
			lda	#$0d
			sta	mouseTop
			ldx	a6L
			beq	l40d8
:l40cd			lda	#$16
			sta	r4L
			lda	#$41
			sta	r4H
			clv
			bvc	l40f5
:l40d8			lda	$18b2

			jsr	l3ef6
:l40de			ldx	#$0c
			jsr	l49c7
			ldy	#$00
			lda	(r5L),y
			clc
			adc	#$01
			sta	r4L
			iny
			lda	(r5L),y
			sta	r4H
			bcc	l40f5
:l40f3			inc	r4H
:l40f5			lda	#$01
			sta	r3L
			jsr	DrawSprite
			lda	#$35
			sta	$01
:l4100			lda	mob0clr
			sta	mob1clr
			lda	#$30
			sta	$01
			lda	#$01
			sta	$0525
			lda	#$01
			sta	r3L
			jmp	EnablSprite
:l4116			b $ff,$ff,$ff
			b $80,$00,$01
			b $80,$00,$01
			b $a2,$0c,$89
			b $b6,$04,$81
			b $aa,$95,$e9
			b $a2,$94,$89
			b $a2,$94,$89
			b $a2,$74,$69
			b $80,$00,$01
			b $80,$00,$01
			b $8f,$58,$01
			b $88,$09,$c1
			b $8e,$4a,$21
			b $88,$4b,$e1
			b $88,$4a,$01
			b $88,$49,$e1
			b $80,$00,$01
			b $80,$00,$01
			b $80,$00,$01
			b $ff,$ff,$ff
			b $00
:l4156			bit	mouseData
			bmi	l4182
			jsr	l586c
			b $00,$0c
			b $ef,$00
			b $3f,$01
:l4164			beq	l4169
:l4166			jmp	l5594
:l4169			bit	a2H
			bmi	l4175
:l416d			lda	$024c
			beq	l417f
:l4172			jmp	l4190
:l4175			bvc	l417a
:l4177			jmp	l41bf
:l417a			jsr	l59a8
			beq	l4182
:l417f			jsr	l4086
:l4182			rts
:l4183			bit	a2H
			bvc	l4190
:l4187			jsr	l41a5
			lda	a2H
			and	#$bf
			sta	a2H
:l4190			jsr	l41a5
			sta	$024c
			sta	mouseLeft
			sta	$84bb
			sta	mouseTop
			lda	#$c7
			sta	mouseBottom
			rts
:l41a5			lda	#$01
			sta	r3L
			jsr	DisablSprite
			lda	#$00
			sta	$0525
			sta	mouseTop
			rts
:l41b5			bit	a2H
			bpl	l41be
:l41b9			ldx	#$00
			jsr	l3f0e
:l41be			rts
:l41bf			lda	#$ff
			sta	$1872
			ldx	#$41
			lda	#$d1
			jsr	l55af
			lda	#$00
			sta	$1872
			rts
:l41d1			jsr	l38ed
			lda	a3L
			cmp	#$08
			bcs	l41ed
:l41da			jsr	l5858
			beq	l41fc
:l41df			lda	isGEOS
			bne	l41ea
:l41e4			jsr	l510c
			clv
			bvc	l41ff
:l41ea			jmp	l4202
:l41ed			jsr	l5862
			beq	l41ff
:l41f2			lda	a4L
			beq	l41f9
:l41f6			jmp	l425c
:l41f9			jmp	l42c4
:l41fc			jmp	l54f2
:l41ff			jmp	l4086
:l4202			jsr	l477b
			cmp	#$0c
			bne	l420c
:l4209			jmp	l5139
:l420c			jsr	l44b4
			bcc	l4219
:l4211			ldy	#$01
			jsr	l246b
			ldx	#$ff
			rts
:l4219			lda	r5H
			pha
			lda	r5L
			pha
			lda	a5H
			pha
			lda	a5L
			pha
			lda	a3L
			jsr	l485a
			pla
			sta	r4L
			pla
			sta	r4H
			pla
			sta	r5L
			pla
			sta	r5H
			jsr	l452a
			jsr	l3b0e
			jsr	l59ca
			jsr	l3b00
			jsr	l59ca
			lda	a5H
			sta	r14H
			lda	a5L
			sta	r14L
			jsr	l44d7
			jsr	l59ca
			jsr	l4003
			jsr	l3c44
			ldx	#$00
			rts
:l425c			jsr	l3573
			lda	a0L
			sta	r10L
			sta	$024e
			jsr	GetFreeDirBlk
			jsr	l59ca
			tya
			pha
			lda	r10L
			cmp	a1L
			bcc	l4288
:l4274			beq	l4288
:l4276			pha
			jsr	PutDirHead
			txa
			bne	l4280
:l427d			jsr	l3a60
:l4280			pla
			cpx	#$00
			beq	l4288
:l4285			jmp	l31ce
:l4288			sta	a0L
			pla
			clc
			adc	#$00
			sta	r5L
			lda	a0L
			adc	#$6d
			sta	r5H
			jsr	l58cb
			jsr	l4526
			lda	a3L
			pha
			jsr	l3ffd
			pla
			jsr	l4618
			jsr	l42b2

			jsr	l3bdf
			jsr	l3c40
			ldx	#$00
			rts
:l42b2			jsr	l3b0e
			jsr	l59ca
			jsr	l3b00
			jsr	l59ca
			jsr	l34a2
			jmp	l59ca
:l42c4			jsr	l3573
			lda	numDrives
			cmp	#$01
			bne	l42d5
:l42ce			lda	a6L
			beq	l42d5
:l42d2			jmp	l563e
:l42d5			lda	#$00
			sta	a8H
			lda	curDrive
			sta	a6H
			lda	a3L
			sta	a3H
			lda	#$ff
			jsr	l4339
			txa
			bne	l4330
:l42ea			lda	#$02
			sta	$03f9
			lda	#$00
			sta	$03f8
			lda	a3H
			ldx	#$06
			jsr	l4742
			lda	r2H
			sta	$03f7
:l4300			lda	r2L
			sta	$03f6
			lda	curDrive
			sta	a2L
			ldy	numDrives
			cpy	#$02
			bcc	l4313
:l4311			eor	#$01
:l4313			sta	a1H
			lda	a0L
			sta	a0H
			lda	#$00
			jsr	l19ab
			txa
			bne	l4330
:l4321			lda	a0H
			sta	a0L
			cmp	a1L
			bcc	l432b
:l4329			sta	a1L
:l432b			lda	a3H
			jsr	l4618
:l4330			jsr	l3ffd
			jsr	l23dc
			jmp	l31d1
:l4339			sta	$024a
			lda	a5L
			clc
			adc	#$03
			sta	r0L
			lda	a5H
			adc	#$00
			sta	r0H
			lda	#$8b
			sta	r1H
			lda	#$d0
			sta	r1L
			ldx	#$02
			ldy	#$04
			jsr	l2416
			jsr	l2565
			ldx	#$02
			ldy	#$0e
			jsr	l2416
			jsr	FindFile
			cpx	#$05
			beq	l43db
:l4369			jsr	l253e
			jsr	GetDirHead
			lda	$82bd
			beq	l4377
:l4374			jmp	l5112
:l4377			lda	$024a
			beq	l43a9
:l437c			lda	#$84
			sta	r6H
			lda	#$00
			sta	r6L
			jsr	l464a
			txa
			beq	l4391
:l438a			lda	#$00
			sta	$024a
			beq	l43a9
:l4391			jsr	l43f2
			cpx	#$ff
			beq	l43a6
:l4398			jsr	l5a26
			ldx	#$44
			lda	#$45
			jsr	l2483
			ldx	#$0c
			bne	l43f1
:l43a6			sta	$024a
:l43a9			jsr	l5a26
			ldx	#$44
			lda	#$2a
			jsr	l2483
			ldx	#$0c
			cmp	#$04
			beq	l43f1
:l43b9			jsr	GetDirHead
			txa
			bne	l43f1
:l43bf			lda	#$8b
			sta	r0H
			lda	#$e4
			sta	r0L
			jsr	DeleteFile
			txa
			bne	l43f1
:l43cd			lda	$024a
			beq	l43d5
:l43d2			jsr	l4618
:l43d5			jsr	PutDirHead
			txa
			bne	l43f1
:l43db			lda	#$8b
			sta	$03fb
			lda	#$d0
			sta	$03fa
			lda	#$8b
			sta	$03fd
			lda	#$e4
			sta	$03fc
			ldx	#$00
:l43f1			rts
:l43f2			lda	#$08
			sta	r10L
			lda	r7H
			sta	r11H
			lda	r7L
			sta	r11L
:l43fe			lda	r10L
			jsr	l4890
			beq	l4421
:l4405			lda	r10L
			jsr	l4724
			beq	l4421
:l440c			ldx	#$04
			jsr	l467e
			ldx	#$04
			ldy	#$18
			lda	#$1e
			jsr	CmpFString
			bne	l4421
:l441c			lda	r10L
			jmp	l4065
:l4421			inc	r10L
			lda	r10L
			cmp	#$10
			bne	l43fe
			b $00
:l442a			b $81,$0c,$10,$10
			b $0c,$0b,$10,$20
			b $c4,$2e,$0b,$10
			b $30,$d3,$2e,$0b
			b $10,$40,$eb,$2e
			b $03,$01,$48,$04
			b $11,$48,$00
:l4445			b $81,$0b,$10,$10
			b $a9,$2d,$0c,$2e
			b $10,$0c,$0b,$10
			b $20,$90,$2d,$0b
			b $10,$30,$e1,$2e
			b $01,$11,$48,$00
:l445d			jsr	l59f7
			ldy	#$00
			lda	#$08
			sta	a4H
:l4466			lda	(r1L),y
			beq	l4490
:l446a			inc	a4H
			jsr	l449a
			bcc	l4466
:l4471			ldx	#$02
			jsr	l38e4
			jsr	l59f7
			lda	#$08
			sta	a4H
:l447d			ldx	#$02
			ldy	#$04
:l4481			lda	#$12
			jsr	CmpFString
			bne	l4490
:l4488			inc	a4H

			jsr	l449a
			bcc	l447d
			b $00
:l4490			lda	a4H
			ldx	#$0c
			jsr	l467e
			ldx	#$00
			rts
:l449a			lda	r1L
			clc
			adc	#$12
			sta	r1L
			tax
			bcc	l44a6
:l44a4			inc	r1H
:l44a6			cmp	#$03
			bcc	l44b2
:l44aa			cpx	#$b2
			bcc	l44b2
:l44ae			beq	l44b2
:l44b0			sec
			rts
:l44b2			clc
			rts
:l44b4			ldy	#$02
			lda	#$7f
			sta	r5H
			lda	#$00
			sta	r5L
:l44be			lda	(r5L),y
			beq	l44cb
:l44c2			tya
			clc
			adc	#$20
			tay
			bcc	l44be
:l44c9			bcs	l44d6
:l44cb			tya
			clc
			adc	r5L
			sta	r5L
			bcc	l44d5
:l44d3			inc	r5H
:l44d5			clc
:l44d6			rts
:l44d7			ldy	#$00
			lda	(r14L),y
			beq	l4523
:l44dd			jsr	l445d
			ldx	#$1e
			ldy	#$0c
			lda	#$1e
			jsr	CopyFString
			ldx	#$02
			jsr	l38e4
			ldx	#$02
			ldy	#$04
			lda	#$12
			jsr	CopyFString
			ldy	#$16
			lda	(r14L),y
			beq	l451e
:l44fd			ldy	#$13
			lda	(r14L),y
			sta	r1L
			iny
			lda	(r14L),y
			sta	r1H
			jsr	l1de3
			txa
			bne	l4525
:l450e			lda	a4H
			ldx	#$0c
			jsr	l46db
			ldx	#$0a
			ldy	#$0c
			lda	#$44
			jsr	CopyFString
:l451e			lda	a4H
			jsr	l4552
:l4523			ldx	#$00
:l4525			rts
:l4526			lda	#$00
			beq	l4530
:l452a			lda	#$80
			bne	l4530
:l452e			lda	#$40
:l4530			sta	r2L
			ldy	#$00
:l4534			lda	(r4L),y
			tax
			lda	(r5L),y
			bit	r2L
			bpl	l4543
:l453d			lda	#$00
			sta	(r4L),y
			beq	l4549
:l4543			bit	r2L
			bvc	l4549
:l4547			sta	(r4L),y
:l4549			txa
			sta	(r5L),y
			iny
			cpy	#$1e
			bne	l4534
:l4551			rts
:l4552			pha
			ldx	#$0a
			jsr	l46db
			ldx	#$06
			jsr	l49c7
			ldx	#$08
			jsr	l467e
			ldy	#$00
			tya
			sta	(r2L),y
			iny
			sta	(r2L),y
			ldy	#$00
			lda	(r3L),y
			beq	l4596
:l4570			ldy	#$16
			lda	(r3L),y
			bne	l457e
:l4576			pla
			pha
			jsr	l49d8
			clv
			bvc	l4581
:l457e			jsr	l4598
:l4581			lda	r3L
			clc
			adc	#$03
			sta	r0L
			lda	r3H
			adc	#$00
			sta	r0H
			pla
			pha
			jsr	l4829
			jsr	l45bd
:l4596			pla
			rts
:l4598			ldy	#$00
			lda	r4L
			clc
			adc	#$04
			sta	(r2L),y
			tya
			adc	r4H
			iny
			sta	(r2L),y
			lda	#$03
			ldy	#$04
			sta	(r2L),y
			lda	#$15
			iny
			sta	(r2L),y
			iny
			lda	#$47
			sta	(r2L),y
			iny
			lda	#$3f
			sta	(r2L),y
			rts
:l45bd			pha
			ldx	#$0c
			jsr	l49c7
			ldy	#$02
			cmp	#$08
			bcs	l45d7
:l45c9			tax
			lda	l45e8,x
			sta	(r5L),y
			iny
			lda	l45f0,x
			sta	(r5L),y
			bne	l45e6
:l45d7			sec
			sbc	#$08
			tax
			lda	l45f8,x
			sta	(r5L),y
			iny
			lda	l4600,x
			sta	(r5L),y
:l45e6			pla
			rts
:l45e8			b $05,$0c,$13
			b $1a,$05,$0c
			b $13,$1a
:l45f0			b $30,$30
:l45f2			b $30,$30
			b $58,$58,$58,$58
:l45f8			b $0b,$11,$17
			b $1d,$08,$0e
			b $14,$1a
:l4600			b $98
			b $98,$98,$98
			b $a4,$a4,$a4
			b $a4
:l4608			b $8c,$8c

			b $8d,$8d,$8d
			b $8d,$8d,$8d
:l4610			b $f5,$fc,$03
			b $0a,$bd,$c4
			b $cb,$d2
:l4618			pha
			jsr	l485a
			ldx	#$0e
			jsr	l467e
			cmp	#$08
			bcs	l462c
:l4625			ldx	#$0e
			jsr	l4675
			pla
			rts
:l462c			jsr	l4724
			beq	l4639
:l4631			jsr	l464a
			ldx	#$10
			jsr	l4675
:l4639			ldx	#$0e
			jsr	l4675
			ldy	#$00
			tya
:l4641			sta	(r0L),y
			iny
			cpy	#$12
			bne	l4641
:l4648			pla
			rts
:l464a			lda	#$7f
			sta	r7H
			lda	#$02
			sta	r7L
:l4652			ldx	#$0e
			ldy	#$10
			lda	#$1e
			jsr	CmpFString
			beq	l4672
:l465d			clc
			lda	#$20
			adc	r7L
			sta	r7L
			bcc	l4668
:l4666			inc	r7H
:l4668			lda	r7H
			cmp	#$7f
			beq	l4652
:l466e			ldx	#$05
			bne	l4674
:l4672			ldx	#$00
:l4674			rts
:l4675			stx	l467b +1
			ldy	#$00
			tya
:l467b			sta	(r0L),y
			rts
:l467e			pha
			cmp	#$08
			bcs	l468b
:l4683			pha
			jsr	l476f
			pla
			clv
			bvc	l4698
:l468b			sec
			sbc	#$08
			pha
			lda	#$26
			sta	$00,x
			lda	#$05
:l4695			sta	$01,x
:l4697			pla
:l4698			asl
			asl
			asl
			asl
			asl
			clc
			adc	$00,x
			sta	$00,x
			bcc	l46a6
:l46a4			inc	$01,x
:l46a6			pla
			rts
:l46a8			lda	#$01
			sta	$38
			lda	#$0e
			sta	$37
			lda	#$08
			sta	r13L
			lda	#$08
			jsr	l4a0a
			lda	#$10
			jsr	l4a06
			lda	#$01
			sta	$38
			lda	#$3f
			sta	$37
			rts
:l46c7			jsr	l244a
			jsr	i_Rectangle
			b $90,$c7
:l46cf			b $40,$00,$0e,$01
:l46d3			jsr	l58e0
			lda	#$11
			jmp	l47d8
:l46db			pha
			txa
			tay
			iny
			iny
			pla
			pha
			cmp	#$08
			bcc	l46e9
:l46e6			sec
			sbc	#$08
:l46e9			sta	$00,x
			lda	#$44
			sta	$0000,y
			jsr	BBMult
			pla
			pha
			cmp	#$08
			bcs	l4709
:l46f9			lda	#$46
			clc
			adc	$00,x
			sta	$00,x
			lda	#$08
			adc	$01,x
			sta	$01,x
			clv
			bvc	l4716
:l4709			lda	#$26
			clc
			adc	$00,x
			sta	$00,x
			lda	#$06
			adc	$01,x
			sta	$01,x
:l4716			pla
			rts
:l4718			lda	a5H
			cmp	#$6d
			bcc	l4722
:l471e			cmp	#$7f
			bcc	l473f
:l4722			lda	a3L
:l4724			pha
			ldx	#$02
			jsr	l4742
			ldx	#$04
			jsr	l38e4
			ldx	#$02
			ldy	#$04
			lda	#$12
			jsr	CmpFString
			beq	l473e
:l473a			pla
			ldx	#$00
			rts
:l473e			pla
:l473f			ldx	#$ff
			rts
:l4742			pha
			cmp	#$08
			bcs	l474c
:l4747			jsr	l38e4
			pla
			rts
:l474c			sec
			sbc	#$08
			sta	r14L
			lda	#$12
			sta	r15L
			txa
			pha
			ldy	#$1e
			ldx	#$20
			jsr	BBMult
			pla
			tax
			lda	#$34
			clc
			adc	r15L
			sta	$00,x
			lda	#$03
			adc	#$00
			sta	$01,x
			pla
			rts
:l476f			lda	#$02
			sta	$00,x
			lda	#$6d
			clc
			adc	a0L
			sta	$01,x
			rts
:l477b			ldy	#$16
			lda	(a5L),y

			rts
:l4780			ldx	#$bc
			lda	#$00
:l4784			sta	$0423,x
			dex
			bne	l4784
:l478a			ldx	#$2e
			lda	#$00
:l478e			sta	$03c3,x
			dex
			bne	l478e
:l4794			lda	#$17
			sta	$0424
			jsr	l47b7
			lda	#$04
			sta	r0H
			lda	#$24
			sta	r0L
			jsr	DoIcons
			jsr	l58e0
			lda	#$00
:l47ac			jsr	l47d8
			clc
			adc	#$01
			cmp	#$17
			bcc	l47ac
:l47b6			rts
:l47b7			lda	#$47
			sta	r0H
			lda	#$c8
			sta	r0L
			lda	#$02
			sta	r13L
			lda	#$10
			jmp	l49e4
			b $06,$28,$23
			b $99,$03,$15
			b $b9,$54,$49
			b $28,$03,$9c
			b $03,$11,$aa
			b $54
:l47d8			pha
			jsr	l49b9
			ora	r0L
			beq	l480c
:l47e0			jsr	l57c1
			pla
			pha
			jsr	l496c
			clc
			adc	r3L
			sta	r3L
			bcc	l47f1
:l47ef			inc	r3H
:l47f1			lda	r3H
			sta	r11H
			lda	r3L
			sta	r11L
			clc
			lda	r2H
			adc	#$08
			sta	r1H
			jsr	l480e
			jsr	l59ee
			jsr	l5805
			jsr	UseSystemFont
:l480c			pla
			rts
:l480e			lda	#$29
			sta	r0H
			lda	#$96
			sta	r0L
			jmp	LoadCharSet
:l4819			lda	curDrive
:l481c			and	#$03
			clc
			adc	#$14
			rts
:l4822			sec
			sbc	#$14
			clc
			adc	#$08
			rts
:l4829			pha
			asl
			tax
			lda	r0L
			sta	$03c4,x
			inx
			lda	r0H
			sta	$03c4,x
			pla
			rts
:l4839			pha
			jsr	l4890
			beq	l4858
:l483f			pla
			jsr	l489c
			pha
			jsr	l496c
			jsr	Rectangle
			pla
			pha
			jsr	l48bd
			pla
			pha
			cmp	#$08
			bcs	l4858
:l4855			jsr	l4a9b
:l4858			pla
			rts
:l485a			ldx	#$01
			stx	r12L
:l485e			jsr	l4839
			ldx	#$0c
			jsr	l49c7
			tax
			lda	#$00
			tay
			sta	(r5L),y
			iny
			sta	(r5L),y
			inx
			txa
			dec	r12L
			bne	l485e
:l4875			dex
			txa
			rts
:l4878			lda	a3L
:l487a			tay
			jsr	l4890
			beq	l488f
:l4880			tya
			pha
			jsr	l496c
			jsr	InvertRectangle
			pla
			jsr	l48da
			jsr	InvertRectangle
:l488f			rts
:l4890			asl
			asl
			asl
			tax
			lda	$0428,x
			inx
			ora	$0428,x
			rts
:l489c			pha
			tay
			lda	l48a6,y
			jsr	SetPattern
			pla
			rts
:l48a6			b $00,$00,$00
			b $00,$00,$00
			b $00,$00,$02
			b $02,$02,$02
			b $02,$02,$02
			b $02,$02,$02
			b $00,$09,$02
			b $02,$02
:l48bd			jsr	l489c
			pha
			jsr	l48d0
			beq	l48ce
:l48c6			pla
			pha
			jsr	l48da
			jsr	Rectangle
:l48ce			pla
			rts
:l48d0			asl
			tax
			lda	$03c4,x
			inx
			ora	$03c4,x
			rts
:l48da			pha
			jsr	l480e
			pla
			pha
			jsr	l496c
			clc
			adc	r3L
			sta	r3L
			bcc	l48ec
:l48ea			inc	r3H
:l48ec			pla
			pha
			jsr	l49b9
			jsr	l57c1
			jsr	l59ee
			jsr	l581c
			lda	r4L
			lsr
			sta	r13L
			lda	r3L
			sec
			sbc	r13L
			sta	r3L

			lda	r3H
			sbc	#$00
			sta	r3H
			bpl	l4914
:l490e			lda	#$00
			sta	r3L
			sta	r3H
:l4914			jsr	l49ab
			lda	#$01
			sta	r13H
			lda	#$3f
			sta	r13L
			jsr	l495b
			lda	r2H
			sta	r2L
			lda	r2L
			clc
			adc	#$04
			sta	r2L
			lda	$29
			clc
			adc	r2L
			sec
			sbc	#$01
			sta	r2H
			pla
			cmp	#$14
			bcc	l4947
:l493c			lda	#$01
			sta	r13H
			lda	#$08
			sta	r13L
:l4944			jsr	l494a
:l4947			jmp	UseSystemFont
:l494a			ldx	r13H
			lda	r13L
:l494e			cpx	r3H
			bne	l4954
:l4952			cmp	r3L
:l4954			bcc	l495a
:l4956			stx	r3H
			sta	r3L
:l495a			rts
:l495b			ldx	r13H
			lda	r13L
			cpx	r4H
			bne	l4965
:l4963			cmp	r4L
:l4965			bcs	l496b
:l4967			stx	r4H
			sta	r4L
:l496b			rts
:l496c			ldx	#$0c
			jsr	l49c7
			lda	#$00
			sta	r3H
			ldy	#$02
			lda	(r5L),y
			asl
			asl
			asl
			rol	r3H
			sta	r3L
			iny
			lda	(r5L),y
			sta	r2L
			iny
			lda	#$00
			sta	r4H
			lda	(r5L),y
			asl
			asl
			pha
			asl
			rol	r4H
			sec
			sbc	#$01
			sta	r4L
			bcs	l499b
:l4999			dec	r4H
:l499b			jsr	l49ab
			iny
			lda	(r5L),y
			clc
			adc	r2L
			sec
			sbc	#$01
			sta	r2H
			pla
			rts
:l49ab			lda	r3L
			clc
			adc	r4L
			sta	r4L
			lda	r3H
			adc	r4H
			sta	r4H
			rts
:l49b9			asl
			tax
			lda	$03c4,x
			sta	r0L
			inx
			lda	$03c4,x
			sta	r0H
			rts
:l49c7			pha
			asl
			asl
			asl
			clc
			adc	#$28
			sta	$00,x
			lda	#$04
			adc	#$00
			sta	$01,x
			pla
			rts
:l49d8			ldy	#$49
			sty	r0H
			ldy	#$fe
			sty	r0L
:l49e0			ldx	#$01
			stx	r13L
:l49e4			asl
			asl
			asl
			tax
			ldy	#$00
:l49ea			lda	#$08
			sta	r13H
:l49ee			lda	(r0L),y
			sta	$0428,x
			inx
			iny
			dec	r13H
			bne	l49ee
:l49f9			dec	r13L
			bne	l49ea
:l49fd			rts
			b $fd,$28,$00
			b $00,$03,$15
			b $47,$3f
:l4a06			ldx	#$01
			stx	r13L
:l4a0a			tay
			lda	r13L
			pha
			tya
			pha
			jsr	l4a50
			beq	l4a42
:l4a15			dey
:l4a16			lda	(r5L),y
			sta	$02,x
			inx
			iny
			cpy	#$06
			bne	l4a16
:l4a20			jsr	BitmapUp
			pla
			pha
			cmp	#$08
			bcs	l4a31
:l4a29			ldx	$024d
			beq	l4a31
:l4a2e			jsr	l4a78
:l4a31			pla
			pha
			jsr	l47d8
			pla
			pha
			jsr	l4065
			cpx	#$ff
			beq	l4a42
:l4a3f			jsr	l487a
:l4a42			pla
			tax
			inx
			pla
			sta	r13L
			txa
			dec	r13L
			bne	l4a0a
:l4a4d			dex
			txa
			rts
:l4a50			ldx	#$0c
			jsr	l49c7
			ldy	#$00
			ldx	#$00
			lda	(r5L),y
			iny
			ora	(r5L),y
			rts
:l4a5f			lda	diskOpenFlg
			and	$024d
			beq	l4a77
:l4a67			lda	a7L
			bne	l4a77
:l4a6b			lda	#$07
:l4a6d			pha

			jsr	l4a78
			pla
			sec
			sbc	#$01
			bpl	l4a6d
:l4a77			rts
:l4a78			sta	r0L
			jsr	l4a50
			beq	l4ad0
:l4a7f			lda	r0L
			ldx	#$0c
			jsr	l467e
			ldy	#$16
			lda	(r5L),y
			jsr	l4ad1
			sta	r5L
			lda	$8ff0
			and	#$0f
			ora	r5L
			ldy	r0L
			clv
			bvc	l4a9f
:l4a9b			tay
			lda	$8ff0
:l4a9f			jsr	l2536
			bcc	l4ad0
:l4aa4			jsr	l5954
			bcc	l4ad0
:l4aa9			sta	r0L
			lda	l4608,y
			sta	r5H
			lda	l4610,y
			sta	r5L
			ldx	#$03
:l4ab7			ldy	#$00
			lda	r0L
:l4abb			sta	(r5L),y
			iny
			cpy	#$03
			bne	l4abb
:l4ac2			lda	r5L
			clc
			adc	#$28
			sta	r5L
			bcc	l4acd
:l4acb			inc	r5H
:l4acd			dex
			bne	l4ab7
:l4ad0			rts
:l4ad1			lsr
			tay
			lda	$8fe8,y
			bcs	l4adc
:l4ad8			asl
			asl
			asl
			asl
:l4adc			and	#$f0
			rts
:l4adf			ldy	#$01
			bit	$ffa0
			lda	diskOpenFlg
			beq	l4aed
:l4ae9			sty	r1L
			bne	l4af1
:l4aed			rts
:l4aee			jsr	l4b35
:l4af1			lda	r1L
			pha
			jsr	l4b51
			pla
			clc
			adc	a0L
			bpl	l4aff
:l4afd			lda	a1L
:l4aff			cmp	a1L
			bcc	l4b07
:l4b03			beq	l4b07
:l4b05			lda	#$00
:l4b07			cmp	a0L
			beq	l4b13
:l4b0b			sta	a0L
			jsr	l34a2
			jsr	l59ca
:l4b13			jmp	l3c0f
:l4b16			cmp	a1L
			beq	l4b1c
:l4b1a			bcs	l4b34
:l4b1c			cmp	a0L
			beq	l4b34
:l4b20			pha
			bcs	l4b29
:l4b23			lda	#$ff
			sta	r1L
			bne	l4b2d
:l4b29			lda	#$01
			sta	r1L
:l4b2d			jsr	l4b51
			pla
			jsr	l4b07
:l4b34			rts
:l4b35			lda	#$01
			ldx	#$02
			jsr	l584c
			lda	$3a
			sec
			sbc	r0L
			clc
			adc	#$7c
			ldy	#$01
			cmp	$3c
			beq	l4b4c
:l4b4a			bcs	l4b4e
:l4b4c			ldy	#$ff
:l4b4e			sty	r1L
			rts
:l4b51			lda	r1L
			pha
			jsr	l4183
			jsr	l237e
			jsr	l589a
			lda	#$00
			sta	r4H
			lda	#$18
			sta	r4L
			lda	#$7c
			sta	r11L
			pla
			pha
			sta	r1L
			tay
			lda	#$00
			sta	r1H
			lda	#$08
			sta	r1L
			tya
			bpl	l4b8d
:l4b79			lda	#$00
			sta	r4H
			lda	#$68
			sta	r4L
			lda	#$29
			sta	r11L
			lda	#$ff
			sta	r1H
			lda	#$f8
			sta	r1L
:l4b8d			lda	#$00
			sta	r0L
			lda	#$0a
			sta	r0H
:l4b95			lda	#$00
			sta	r3H
			lda	#$09
			sta	r3L
			lda	r0L
			jsr	HorizontalLine
			lda	r11L
			sta	r3L
			lda	#$8a
			sta	r3H
			lda	r0L
			jsr	VerticalLine
			lda	r0L
			eor	#$ff
			sta	r0L
			bpl	l4b95
:l4bb7			lda	r1L
			clc
			adc	r4L
			sta	r4L
			lda	r1H
			adc	r4H
			sta	r4H
			sec
			lda	r11L
			sbc	r1L
			sta	r11L
			dec	r0H
			bne	l4b95
:l4bcf			lda	#$12
			jsr	l4a06
			pla
			sta	r1L
			rts
:l4bd8			lda	#$4c
			sta	r0H
			lda	#$11
			sta	r0L
			lda	a7L
			beq	l4bf6
			jsr	i_FrameRectangle
			b $7c,$8b,$08,$00,$07,$01,$ff
			lda	#$4c
			sta	r0H
			lda	#$19
			sta	r0L
:l4bf6			lda	#$12
			jsr	l49e0
			lda	#$4c
			sta	r0H
			lda	#$21

			sta	r0L
			lda	#$13
			jsr	l49e0
			lda	#$02
			sta	r13L
			lda	#$12
			jmp	l4a0a
			b $5e,$29,$01
:l4c14			b $7c,$02
:l4c16			b $10,$ee
:l4c18			b $4a,$3d,$29,$10
			b $7c,$02
:l4c1e			b $10,$4c
:l4c20			b $55,$7f
			b $29,$1e,$11,$02
			b $0b,$78,$36
			b $00,$0c,$00
			b $00,$d8,$00
			b $07
:l4c30			b $24,$2f,$40
:l4c33			b $56,$4d,$29,$2f
			b $40,$61
:l4c39			b $4d,$2f,$2f,$40
:l4c3d			b $6c,$4d,$42,$2f
			b $40,$77
:l4c43			b $4d,$37,$2f,$40
			b $82
:l4c48			b $4d,$3c,$2f,$40
			b $8d
:l4c4d			b $4d,$4b,$2f,$40
			b $98,$4d,$0c
:l4c54			b $44
			b $00,$00,$5f
			b $00
:l4c59			b $84,$4f
			b $2f,$00,$64
			b $55,$59,$2f
			b $00,$6d,$55
			b $72,$2f,$00
			b $1c,$55,$81
			b $2f,$00
:l4c6c			b $25,$55,$66,$0a
			b $00,$f5,$4e
			b $77,$0a,$00
			b $f5,$4e,$88
			b $0a,$00,$f5
			b $4e,$99,$0a
			b $00,$f5,$4e
			b $aa,$0a,$00
			b $f5,$4e,$bb
			b $0a,$00,$f5
			b $4e,$cc,$0a
			b $00,$f5,$4e
			b $dd,$0a,$00
			b $f5
:l4c95			b $4e
:l4c96			b $0c
			b $6f,$20,$00
			b $77,$00,$87
			b $97,$2f,$00
			b $c2,$3c,$b7
			b $2f,$00,$88
			b $55,$a5,$2f
			b $00,$7f,$55
			b $66,$2f,$00
			b $13,$55,$ca
			b $2f,$00
:l4cb4			b $a1,$54,$d9,$2f
			b $00,$b0,$54
			b $e8,$2f,$00
			b $dd,$54,$0c
			b $57,$38,$00
			b $77,$00,$85
			b $fc,$2f,$00
			b $7b
:l4ccb			b $51,$1e,$30,$00
:l4ccf			b $7b
:l4cd0			b $51,$29,$30,$00
:l4cd4			b $7b
:l4cd5			b $51,$13,$30,$00
:l4cd9			b $7b
:l4cda			b $51,$08,$30,$00
:l4cde			b $7b
			b $51,$0c,$6f,$60,$00
			b $b7,$00,$87,$32
:l4ce8			b $30,$00
:l4cea			b $53,$4f,$40
:l4ced			b $30,$00
:l4cef			b $75,$36
			b $51,$30
			b $00,$76
:l4cf5			b $55,$63
			b $30,$00
:l4cf9			b $77,$4f,$73
:l4cfc			b $30,$00
:l4cfe			b $bf,$54,$84
:l4d01			b $30,$00
:l4d03			b $e6,$54,$93
:l4d06			b $30,$00
:l4d08			b $c8
			b $54,$0c,$37
			b $88,$00,$f7
:l4d0f			b $00,$83,$c7
:l4d12			b $30,$00
:l4d14			b $f8,$54,$da
:l4d17			b $30,$00
:l4d19			b $01,$55
			b $ed,$30,$00
			b $0a,$55,$0c
			b $27,$a8,$00
			b $ef,$00,$82
			b $a6
:l4d28			b $30,$00
:l4d2a			b $2e,$55,$b6
			b $30,$00
:l4d2f			b $37,$55,$0c
			b $47,$c0,$00
			b $ff,$00,$84
			b $05,$31,$00
			b $91,$55,$16
			b $31,$00,$9f
			b $51
:l4d42			b $10,$31
			b $00,$52,$55
			b $23,$31,$00
			b $a0,$55
:l4d4c			b $47,$45
			b $4f,$53,$20
			b $42,$4f,$4f
			b $54,$a0
:l4d56			ldx	#$04
			jsr	l4dd6
			lda	#$53
			ldy	#$4c
			bne	l4da1
:l4d61			ldx	#$08
			jsr	l4dd6
			lda	#$96
			ldy	#$4c
			bne	l4da1
:l4d6c			ldx	#$0c
			jsr	l4dd6
			lda	#$c0
			ldy	#$4c
:l4d75			bne	l4da1
:l4d77			ldx	#$10
			jsr	l4dd6
			lda	#$e0
			ldy	#$4c
			bne	l4da1
:l4d82			ldx	#$14
			jsr	l4dd6
			lda	#$0a
			ldy	#$4d
			bne	l4da1
:l4d8d			ldx	#$18
			jsr	l4dd6
			lda	#$20
			ldy	#$4d
			bne	l4da1
:l4d98			ldx	#$1c
			jsr	l4dd6
			lda	#$31
			ldy	#$4d
:l4da1			sty	r0H
			sta	r0L
			jmp	l2665
:l4da8			b $00
:l4da9			ldx	l4da8
			cpx	#$ff
			beq	l4dd5
:l4db0			cpx	#$20
			bne	l4db9
:l4db4			jsr	l3bdf
			ldx	#$20
:l4db9			txa
			pha
			jsr	l26f7
			jsr	l4a5f
			pla
			tax
			jsr	l4de6
			ldx	l4da8
			cpx	#$20
			bne	l4dd0
:l4dcd			jsr	l3c44
:l4dd0			lda	#$ff
			sta	l4da8
:l4dd5			rts
:l4dd6			stx	l4da8
			jsr	l4eb6
			jsr	l4e23
			ldy	#$00
			tya
			sta	(r7L),y
			beq	l4dee
:l4de6			jsr	l4eb6
			jsr	l4e23
			lda	#$ff
:l4dee			sta	r4H
:l4df0			ldx	r2H

			jsr	GetScanLine
			lda	r2L
			asl
			asl
			asl
			bcc	l4dfe
:l4dfc			inc	r5H
:l4dfe			tay
			lda	r3L
			sta	r4L
:l4e03			bit	r4H
			bpl	l4e0d
:l4e07			jsr	l4e80
			clv
			bvc	l4e10
:l4e0d			jsr	l4e36
:l4e10			clc
			adc	#$08
			bcc	l4e17
:l4e15			inc	r5H
:l4e17			tay
			dec	r4L
			bne	l4e03
:l4e1c			inc	r2H
			dec	r3H
			bne	l4df0
:l4e22			rts
:l4e23			jsr	l4e2d
:l4e26			inc	r1L
			bne	l4e2c
:l4e2a			inc	r1H
:l4e2c			rts
:l4e2d			lda	r1H
			sta	r7H
			lda	r1L
			sta	r7L
			rts
:l4e36			tya
			pha
			lda	r1H
			cmp	#$6d
			bcs	l4e7e
:l4e3e			lda	(r5L),y
			ldy	#$00
			tax
			bne	l4e56
:l4e45			lda	(r7L),y
			bmi	l4e4d
:l4e49			cmp	#$7f
			bne	l4e77
:l4e4d			jsr	l4e23
			lda	#$00
			sta	(r7L),y
			beq	l4e77
:l4e56			lda	(r7L),y
			bpl	l4e67
:l4e5a			cmp	#$ff
			beq	l4e67
:l4e5e			txa
			sta	(r1L),y
			jsr	l4e26
			clv
			bvc	l4e77
:l4e67			jsr	l4e23
			lda	#$80
			sta	(r7L),y
			lda	r1H
			cmp	#$6d
			bcs	l4e7e
:l4e74			clv
			bvc	l4e5e
:l4e77			lda	(r7L),y
			clc
			adc	#$01
			sta	(r7L),y
:l4e7e			pla
			rts
:l4e80			tya
			pha
:l4e82			ldy	#$00
			lda	(r7L),y
			and	#$7f
			bne	l4e90
:l4e8a			jsr	l4e23
			clv
			bvc	l4e82
:l4e90			ldx	#$00
			lda	r1H
			cmp	#$6d
			beq	l4eaf
:l4e98			lda	(r7L),y
			bmi	l4ea0
:l4e9c			lda	#$00
			beq	l4ea7
:l4ea0			lda	(r1L),y
			pha
			jsr	l4e26
			pla
:l4ea7			tax
			lda	(r7L),y
			sec
			sbc	#$01
			sta	(r7L),y
:l4eaf			pla
			tay
			txa
			sta	(r5L),y
			tya
			rts
:l4eb6			txa
			pha
			lda	#$66
			sta	r1H
			lda	#$00
			sta	r1L
			ldy	#$00
:l4ec2			lda	l4ed1,x
			sta	$0006,y
			inx
			iny
			cpy	#$04
			bne	l4ec2
:l4ece			pla
			tax
			rts
:l4ed1			b $08,$20,$19
			b $68,$00,$0c,$0d
:l4ed8			b $3a,$04
			b $0c,$0c,$64
			b $07,$0c,$09
:l4ee0			b $4c,$0c,$0c
			b $0c,$64,$11
			b $0c,$0f
:l4ee8			b $2c,$15,$0c
			b $0a,$1e,$18
			b $0c,$09,$3e
			b $09,$77,$16
			b $44
:l4ef5			pha
			jsr	DoPreviousMenu
			pla
			sec
			sbc	#$04
			sta	r6L
			asl
			asl
			asl
			asl
			clc
			adc	r6L
			adc	#$66
			sta	r6L
			lda	#$00
			adc	#$0a
			sta	r6H
			jsr	FindFile
			jsr	l59ca
:l4f16			jsr	l4086
			jsr	l5a2f
			ldx	#$00
			stx	r10L
			stx	r0L
			lda	l4c96
			pha
			lda	l4c95
			pha
			jsr	LdDeskAcc
			lda	#$80
			sta	$2f
			pla
			sta	l4c95
			pla
			sta	l4c96
			txa
			pha
			lda	screencolors
			sta	l4f48
			jsr	i_FillRam
			b $e8,$03
			b $00,$8c
:l4f48			b $00
			pla
			beq	l4f50
			tax
			jsr	l259d
:l4f50			jmp	MainInit
			jsr	DoPreviousMenu
:l4f56			lda	$024c
			beq	l4f6b
:l4f5b			jsr	l4183
			lda	curDrive
			cmp	#$08
			beq	l4f68
:l4f65			jmp	l5377
:l4f68			jmp	l5374
:l4f6b			jsr	l4819
			jsr	l4839
			jsr	l31ec
			jmp	l31e2
:l4f77			jsr	DoPreviousMenu
			lda	diskOpenFlg
			bne	l4f80

:l4f7f			rts
:l4f80			jsr	l237e
			jsr	l4086
			jsr	GetDirHead
			txa
			bne	l5004
:l4f8c			jsr	l5078
			cmp	#$03
			beq	l4f95
:l4f93			bcs	l4fd8
:l4f95			sta	$0520
			jsr	l340a
			lda	r0L
			ldy	isGEOS
			beq	l4fa4
:l4fa2			and	#$fe
:l4fa4			ora	r0H
			bne	l4fb4
:l4fa8			ldx	#$50
			lda	#$66
			jsr	l2483
			cmp	#$03
			beq	l4fb4
:l4fb3			rts
:l4fb4			lda	$82bd
			cmp	#$42
			bne	l4fbe
:l4fbb			jmp	l5112
:l4fbe			lda	curDrive
			sta	a6H
			sta	a1H
			ldy	numDrives
			cpy	#$02
			bcc	l4fce
:l4fcc			eor	#$01
:l4fce			sta	a2L
			tay
			lda	driveType -8,y
			and	#$0f
			cmp	#$03
:l4fd8			beq	l4fdc
:l4fda			bcs	l5026
:l4fdc			cmp	$0520
			beq	l4fea
:l4fe1			cmp	#$03
			beq	l5026
:l4fe5			cmp	$0520
			bcc	l5026
:l4fea			sta	$0521
			lda	driveType -8,y
			bmi	l5005
:l4ff2			tya
			clc
			adc	#$39
			sta	l2dcd
			ldx	#$50
			lda	#$d4
			jsr	l2483
			cmp	#$02
			bne	l5005
:l5004			rts
:l5005			lda	a2L
			jsr	l1af1
			jsr	NewDisk
			txa
			bne	l5016
:l5010			jsr	GetDirHead
			txa
			beq	l502e
:l5016			jsr	l54d4
			txa
			beq	l5005
:l501c			cpx	#$0c
			beq	l5060
:l5020			jsr	l259d
			clv
			bvc	l5060
:l5026			ldy	#$03
			jsr	l246b
			clv
			bvc	l5060
:l502e			lda	$82bd
			beq	l5039
:l5033			jsr	l5112
			clv
			bvc	l5060
:l5039			lda	$0521
			cmp	#$02
			bne	l504f
:l5040			bit	$8203
			bmi	l504f
:l5045			lda	#$01
			sta	$0521
			cmp	$0520
			bne	l5026
:l504f			jsr	l508c
			ldx	#$50
			lda	#$e6
			jsr	l2483
			cmp	#$02
			beq	l5060
:l505d			jsr	l1956
:l5060			jsr	l23dc
			jmp	MainInit
			b $81,$0b,$0c
			b $20
:l506a			b $30,$31
			b $0b,$0c
:l506e			b $30,$4b
:l5070			b $31,$03
			b $01,$48
			b $04,$11,$48
			b $00
:l5078			ldy	curDrive
			lda	driveType -8,y
			and	#$0f
			cmp	#$02
			bne	l508b
:l5084			bit	$8203
			bmi	l508b
:l5089			lda	#$01
:l508b			rts
:l508c			jsr	l5a09
			jsr	l2565
			ldy	#$0e
			jsr	l2416
			ldx	#$06
			lda	#$8b
			sta	r3H
:l509d			lda	#$bc
			sta	r3L
			ldy	#$08
			lda	#$12
			jsr	CopyFString
			lda	#$02
			sta	r2H
			lda	#$00
			sta	r2L
			lda	#$8b
			sta	r7H
			lda	#$d0
			sta	r7L
			ldx	#$06
			ldy	#$10
:l50bc			jsr	l2416
			lda	#$8b
			sta	$03f9
			lda	#$bc
			sta	$03f8
			lda	#$02
			sta	$03f7
			lda	#$00
			sta	$03f6
			rts
:l50d4			b $81,$0b,$10,$20
			b $b1
:l50d9			b $2d,$0b,$10,$30,$cf
			b $2d,$01,$01
			b $48,$02,$11
			b $48,$00,$81
			b $0b,$10
:l50e9			b $10,$16
:l50eb			b $2e,$0c,$10,$20
			b $0e,$0b,$10,$30
			b $2b
:l50f4			b $2e,$0c,$10,$40
:l50f8			b $10,$03
			b $01,$48,$02
:l50fd			b $11,$48
			b $00
:l5101			jsr	l477b
			cmp	#$04
			beq	l512f
:l5107			cmp	#$0c
			beq	l5137
:l510b			rts
:l510c			ldy	#$9f
			ldx	#$2b
			bne	l513d
:l5112			cmp	#$42
			bne	l511c
:l5116			ldy	#$5f
			ldx	#$2e
			bne	l513d
:l511c			ldy	#$71
			ldx	#$2e
			bne	l513d
:l5122			lda	a4L
			beq	l5127
:l5126			rts
:l5127			pla
			pla
:l5129			ldy	#$84
			ldx	#$2e
			bne	l513d
:l512f			pla
			pla
			ldy	#$3a
			ldx	#$2c
			bne	l513d
:l5137			pla
			pla

:l5139			ldy	#$b0
			ldx	#$2c
:l513d			sty	r5L
			stx	r5H
			ldx	#$51
			lda	#$4b
			jsr	l2483
			ldx	#$0c
			rts
:l514b			b $81,$0b,$10,$10
			b $3c,$2e,$0b
:l5152			b $10,$20
:l5154			b $50,$2e
			b $0c
:l5157			b $10,$30
			b $0c,$0b
:l515b			b $10,$40
			b $9f
			b $2e,$01,$11,$48
			b $00
:l5163			lda	a5L
			sta	r9L
			sta	r6L
			sta	r7L
			lda	a5H
			sta	r9H
			sta	r6H
			sta	r7H
			cmp	#$6d
:l5175			bcs	l517a
			jsr	l464a
:l517a			rts
:l517b			pha
			jsr	DoPreviousMenu
			pla
			cmp	a7L
			beq	l519e
:l5184			ldx	diskOpenFlg
			beq	l519e
:l5189			sta	a7L
			cmp	#$00
			bne	l5192
:l518f			jsr	l34a2
:l5192			jsr	l4086
			jsr	l589a
			jsr	l3bdf
			jsr	l4bd8
:l519e			rts
:l519f			jsr	DoPreviousMenu
			jsr	l4183
			jmp	MainInit

; MainInit
:MainInit		ldx	#$48
			lda	#$00
:l51ac			sta	$01ff,x
			dex
			bne	l51ac
:l51b2			lda	#$00
			ldy	#$03
:l51b6			sta	$00fb,y
			dey
			bpl	l51b6
:l51bc			ldy	#$0f
:l51be			sta	$0070,y
			dey
			bpl	l51be
:l51c4			sta	iconSelFlag
			sta	$04ed
			sta	$024c
			sta	$0248
			sta	$1872
			sta	$0af0
			lda	#$ff
			sta	$024d
			sta	$04ec
			jsr	l5220
			lda	#$52
			sta	r0H
			lda	#$35
			sta	r0L
			jsr	InitRam
			jsr	l2518
			jsr	l2536
			bcs	l51f7
:l51f4			jsr	l559a
:l51f7			lda	#$4c
			sta	r0H
			lda	#$29
			sta	r0L
			lda	#$02
			jsr	DoMenu
			jsr	l4780
			jsr	l5649
			jsr	l5a38
			cpx	#$21
			bne	l5214
:l5211			jsr	l367d
:l5214			jsr	l59ca
			lda	#$ff
			sta	$0249
			jsr	l5417
			rts
:l5220			ldx	#$90
			lda	#$00
:l5224			sta	$0333,x
			dex
			bne	l5224
:l522a			ldx	#$ff
			lda	#$00
:l522e			sta	$0525,x
			dex
			bne	l522e
:l5234			rts
			b $a9,$84,$02
			b $56,$41,$9b
			b $84,$02,$53
			b $52,$a3,$84
			b $02,$74,$52
			b $8d,$84,$01
			b $01,$2f,$00
			b $01,$80,$b1
			b $84,$02,$a9
:l5250			b $4d,$00,$00
:l5253			lda	$0525
			beq	l5273
:l5258			lda	#$01
			sta	r3L
			lda	$3c
			sec
			sbc	#$08
			sta	r5L
			sec
			lda	$3a
			sbc	#$08
			sta	r4L
			lda	$3b
			sbc	#$00
			sta	r4H
			jmp	PosSprite
:l5273			rts
:l5274			lda	$024c
			ora	menuNumber
			bne	l5273
:l527c			lda	keyData
:l527f			ldx	diskOpenFlg
			beq	l52f0
:l5284			ldx	a7L
			bne	l52f0
:l5288			ldy	#$0e
:l528a			cmp	l529d,y
			beq	l5294
:l528f			dey
			bpl	l528a
:l5292			bmi	l52ac
:l5294			ldx	l5365,y
			lda	l5356,y
			jmp	CallRoutine
:l529d			b $fa
:l529e			b $e8,$ed,$e4,$f1
			b $f0,$f5
			b $f3,$f4,$f7
:l52a7			b $f8,$f9,$e7,$10
:l52ab			b $11
:l52ac			cmp	#$30
			bne	l52b4
:l52b0			lda	#$09
			bne	l52dc
:l52b4			tay
			cmp	#$3a
			bcs	l52be
:l52b9			sec
			sbc	#$31
			bcs	l52dc
:l52be			tya
			cmp	#$40
			bne	l52c7
:l52c3			lda	#$0c
			bne	l52dc
:l52c7			cmp	#$2f
			bne	l52cf
:l52cb			lda	#$10
			bne	l52dc
:l52cf			cmp	#$29
			bcs	l52df
:l52d3			cmp	#$21
			bcc	l52df
:l52d7			and	#$0f
			clc
			adc	#$09
:l52dc			jmp	l4b16
:l52df			tya
			cmp	#$a1
			bcc	l52f0
:l52e4			cmp	#$a9
			bcc	l532d
:l52e8			cmp	#$b1
			bcc	l52f0
:l52ec			cmp	#$b9
			bcc	l5332
:l52f0			ldy	#$0c
:l52f2			cmp	l5306,y
			beq	l52fc
:l52f7			dey
			bpl	l52f2

:l52fa			bmi	l5305
:l52fc			ldx	l5313,y
			lda	l5320,y
			jsr	CallRoutine
:l5305			rts
:l5306			b $e1,$e2,$c1
			b $c2,$e3,$e9
			b $ee,$eb,$ef
			b $e5,$f6,$e6
			b $f2
:l5313			b $38,$38
			b $53,$53,$36
			b $55,$55,$4f
			b $4f,$54,$54
			b $54,$51
:l5320			b $37
			b $3b,$74,$77
			b $78,$28,$79
			b $7a,$6b,$e9
			b $c2,$cb,$a2
:l532d			b $38,$e9,$99
			b $d0,$03
:l5332			sec
			sbc	#$b1
:l5335			tay
			jsr	l4183
			tya
			jsr	l4890
			bne	l5340
:l533f			rts
:l5340			tya
			sta	r0L
			jsr	l4065
			cpx	#$ff
			beq	l5350
:l534a			jsr	l3f0e
			jmp	l3ffd
:l5350			jsr	l3f9a
			jmp	l3fbf
:l5356			b $c5,$8b,$82
			b $b3,$16,$a4
			b $e0,$31,$3a
			b $fb,$04,$0d
			b $b5,$e2,$df
:l5365			b $3c,$55,$55
			b $54,$55,$54
			b $54,$55
:l536d			b $55,$54,$55,$55
			b $41,$4a,$4a
:l5374			lda	#$08
			b $2c
:l5377			lda	#$09
			ldx	$8490
			beq	l53b6
:l537e			bit	$88c4
			bvc	l53b6
:l5383			pha
			jsr	l4086
			pla
			sta	r10L
			jsr	l1af1
			lda	$8491
			bne	l53b6
:l5392			lda	#$0b
			jsr	l53b7
			lda	#$0a
			jsr	l1af1
			lda	r10L
			jsr	l53b7
			lda	#$0b
			jsr	l1af1
			lda	#$0a
			jsr	l53b7
			lda	r10L
			jsr	l1af1
			jsr	l3b4b
			jmp	MainInit
:l53b6			rts
:l53b7			pha
			tay
			lda	l5406 +1,y
			sta	r1L
			lda	l540b,y
			sta	r1H
			lda	#$90
			sta	r0H
			lda	#$00
			sta	r0L
			lda	#$0d
			sta	r2H
			lda	#$80
			sta	r2L
			lda	#$00
			sta	r3L
			jsr	StashRAM
			pla
			sta	r0L
			lda	curDrive
			pha
			tay
			lda	$88bf,y
			pha
			lda	driveType -8,y
			pha
			bpl	l53f4
:l53ec			lda	r0L
			jsr	l1af1
			clv
			bvc	l53f9
:l53f4			lda	r0L
			jsr	ChangeDiskDevice
:l53f9			ldy	curDrive
			pla
			sta	driveType -8,y
:l5400			pla
			sta	$88bf,y
			pla
			tay
:l5406			lda	#$00
			sta	$88bf,y
:l540b			sta	driveType -8,y
			rts
:l540f			b $00,$80,$00,$80
:l5413			b $83
:l5414			b $90,$9e
			b $ab
:l5417			ldy	#$01
			b $2c
:l541a			ldy	#$02
			b $2c
:l541d			ldy	#$03
			b $2c
:l5420			ldy	#$04
			b $2c
:l5423			ldy	#$05
			cpy	a9L
			bne	l542f
:l5429			jsr	l55a9
			jmp	l5477
:l542f			lda	a9L
			pha
			sty	a9L
			lda	curDrive
			pha
:l5438			jsr	l2577
			jsr	l3e38
			cpx	#$0c
			beq	l547b
:l5442			txa
			bne	l546c
:l5445			jsr	l59ee
			jsr	OpenRecordFile
			txa
			bne	l546c
:l544e			lda	a9L
			jsr	PointRecord
			txa
			bne	l546c
:l5456			ldy	#>vlirModBase
			sty	r7H
			ldy	#<vlirModBase
			sty	r7L
			lda	#>vlirModSize
			sta	r2H
			lda	#<vlirModSize
			sta	r2L
			jsr	ReadRecord
			txa
			beq	l5472
:l546c			jsr	l259d
			clv
			bvc	l5438
:l5472			pla
			jsr	l1b16
			pla
:l5477			ldx	#$00
			beq	l548d
:l547b			pla
			jsr	l1b16
			pla
			sta	a9L
			jsr	l4086
			lda	a9H
			bne	l548b
:l5489			pla
			pla
:l548b			ldx	#$ff
:l548d			txa
			pha
			lda	$0248
			bne	l5497
:l5494			jsr	l38ed
:l5497			lda	#$00
			sta	a9H
			sta	$0248
			pla
			tax
			rts
:l54a1			jsr	DoPreviousMenu
			jsr	l5417
			jmp	$5b46
:l54aa			jsr	l5417
			jmp	$5b49

:l54b0			jsr	DoPreviousMenu
			jsr	l5417
			jmp	$5b4c
:l54b9			jsr	l5417
			jmp	$5b4f
:l54bf			jsr	DoPreviousMenu
			jsr	l5417
			jmp	$5b52
:l54c8			jsr	DoPreviousMenu
			jsr	l55a9
			jsr	l5417
			jmp	$5b55
:l54d4			jsr	l55a9
			jsr	l5417
			jmp	$5b58
:l54dd			jsr	DoPreviousMenu
			jsr	l5417
			jmp	$5b5b
:l54e6			jsr	DoPreviousMenu
			jsr	l55a9
			jsr	l5417
			jmp	$5b5e
:l54f2			jsr	l5417
			jmp	$5b61
:l54f8			jsr	DoPreviousMenu
			jsr	l5417
			jmp	$5b64
:l5501			jsr	DoPreviousMenu
			jsr	l5417
			jmp	$5b67
:l550a			jsr	DoPreviousMenu
			jsr	l5417
			jmp	$5b6a
:l5513			jsr	DoPreviousMenu
			jsr	l541a
			jmp	$5b46
:l551c			jsr	DoPreviousMenu
			jsr	l541d
			jmp	$5b46
:l5525			jsr	DoPreviousMenu
			jsr	l541d
			jmp	$5b49
:l552e			jsr	DoPreviousMenu
			jsr	l541d
			jmp	$5b4c
:l5537			jsr	DoPreviousMenu
			jsr	l541d
			jmp	$5b4f
:l5540			jmp	$5b46
			jmp	$5b49
:l5546			jmp	$5b4c
:l5549			jmp	$5b4f
:l554c			jsr	l5420
			jmp	$5b52
:l5552			jsr	DoPreviousMenu
			jsr	l55a9
			jsr	l5420
			jmp	$5b55
:l555e			jsr	l5420
			jmp	$5b58
:l5564			jsr	DoPreviousMenu
			jsr	l5420
			jmp	$5b5b
:l556d			jsr	DoPreviousMenu
			jsr	l5420
			jmp	$5b5e
:l5576			jsr	DoPreviousMenu
			jsr	l5420
			jmp	$5b61
:l557f			jsr	DoPreviousMenu
			jsr	l5420
			jmp	$5b64
:l5588			jsr	DoPreviousMenu
			jsr	l5420
			jmp	$5b67
:l5591			jsr	DoPreviousMenu
:l5594			jsr	l5423
			jmp	$5b46
:l559a			jsr	l5423
			jmp	$5b49
:l55a0			jsr	DoPreviousMenu
			jsr	l5423
			jmp	$5b4c
:l55a9			lda	#$ff
			sta	$0248
			rts
:l55af			bit	a2H
			bpl	l561f
:l55b3			sta	l5605 +1
			stx	l5605 +2
			jsr	l4183
			lda	$3c
			sta	$1873
			lda	$3b
			sta	$1875
			lda	$3a
			sta	$1874
			lda	#$ff
			sta	$024b
			lda	a6L
:l55d2			inc	$024b
			tax
			cpx	#$ff
			beq	l561f
:l55da			dex
			txa
			pha
			jsr	l3f08
			lda	r0H
			pha
			lda	r0L
			pha
			lda	r1H
			pha
			lda	r1L
			pha
			lda	$1872
			beq	l5600
:l55f1			lda	$1873
			sta	$3c
			lda	$1875
			sta	$3b
			lda	$1874
			sta	$3a
:l5600			jsr	MouseOff
			lda	a3L
:l5605			jsr	$0000
			jsr	MouseUp
			pla
			sta	r1L
			pla
			sta	r1H
			pla
			sta	r0L
			pla
			sta	r0H
			cpx	#$ff
			bne	l5622
:l561b			jsr	l4086
			pla
:l561f			ldx	#$00
			rts
:l5622			cpx	#$00
			beq	l562d
:l5626			cpx	#$0c
			bne	l563c
:l562a			jsr	l3ffd
:l562d			jsr	l59ac
			beq	l5636
:l5632			pla
			clv
			bvc	l55d2
:l5636			jsr	l4086
			jsr	l31d1
:l563c			pla
			rts
:l563e			ldy	#$04
			jsr	l246b
			jsr	l4086
			ldx	#$ff
			rts
:l5649			lda	#$00
			sta	$0250
			jsr	l2447
			jsr	i_Rectangle
			b $00,$0c,$ef
			b $00,$3f,$01
			jsr	i_FrameRectangle
			b $00,$0c,$ef
			b $00,$3f,$01,$ff
:l5662			lda	#$56
			sta	r0H
			lda	#$7c
			sta	r0L
			lda	#$01
			jsr	InitProcesses
:l5671			jsr	l5677
			jmp	l56ef
:l5677			ldx	#$00
			jmp	RestartProcess
			b $95,$56,$3c
			b $00
:l5680			ldx	#$00
			jmp	BlockProcess
:l5685			cmp	$194c,x
			beq	l5694
:l568a			sta	$194c,x
			txa
			pha
			jsr	l575b
			pla
			tax
:l5694			rts
:l5695			bit	$0250
			bmi	l56d6
:l569a			php
			sei
			lda	$01
			pha
			lda	#$35
			sta	$01
			jsr	l56d7

			jsr	l57a0
			pha
			txa
			ldx	#$00
			jsr	l5685
			inx
			pla
			jsr	l5685
			lda	$dc0a
			jsr	l57a0
			pha
			txa
			ldx	#$03
			jsr	l5685
			inx
			pla
			jsr	l5685
			lda	$dc08
			pla
			sta	$01
			plp
			lda	hour
			ora	minutes
			beq	l56ef
:l56d6			rts
:l56d7			lda	$dc0b
			bpl	l56e8
:l56dc			and	#$7f
			cmp	#$12
			beq	l56ee
:l56e2			sed
			clc
			adc	#$12
			cld
			rts
:l56e8			cmp	#$12
			bne	l56ee
:l56ec			lda	#$00
:l56ee			rts
:l56ef			lda	#$00
			sta	$1952
			sta	$194b
			lda	#$20
			sta	$1951
			sta	$194a
			php
			sei
			lda	$01
			pha
			lda	#$35
			sta	$01
			lda	#$3a
			sta	$194e
			lda	$dc0a
			jsr	l57a0
			sta	$1950
			stx	$194f
			jsr	l56d7
			jsr	l57a0
			sta	$194d
			stx	$194c
			bit	$dc08
			pla
			sta	$01
			plp
			lda	year
			jsr	l57b0
			sta	$1949
			stx	$1948
			lda	#$2e
			sta	$1947
			sta	$1944
			lda	day
			jsr	l57b0
			sta	$1943
			stx	$1942
			lda	month
			jsr	l57b0
			sta	$1946
			stx	$1945
			jsr	l577b
:l575b			php
			sei
			lda	$01
			pha
			lda	#$30
			sta	$01
			lda	#$19
			sta	r0H
			lda	#$4c
			sta	r0L
			lda	#$01
			sta	r11H
			lda	#$26
			sta	r11L
			lda	#$09
			sta	r1H
			clv
			bvc	l5798
:l577b			php
			sei
			lda	$01
			pha
			lda	#$30
			sta	$01
			lda	#$19
			sta	r0H
			lda	#$42
			sta	r0L
			lda	#$00
			sta	r11H
			lda	#$f5
			sta	r11L
			lda	#$09
			sta	r1H
:l5798			jsr	PutString
			pla
			sta	$01
			plp
			rts
:l57a0			pha
			lsr
			lsr
			lsr
			lsr
			clc
			adc	#$30
			tax
			pla
			and	#$0f
			clc
			adc	#$30
			rts
:l57b0			ldx	#$30
			sec
:l57b3			sbc	#$0a
			bcc	l57ba
:l57b7			inx
			bcs	l57b3
:l57ba			adc	#$3a
			rts
:l57bd			stx	r0H
			sta	r0L
:l57c1			ldx	#$00
			stx	r1L
			lda	#$20
			sta	$8b80,x
			inx
			jsr	l57dd
			ldx	r1L
			inx
			lda	#$20
			sta	$8b80,x
			inx
			lda	#$00
			sta	$8b80,x
			rts
:l57dd			ldy	#$00
:l57df			lda	(r0L),y
			beq	l57fe
:l57e3			and	#$7f
			cmp	#$20
			bcc	l57ed
:l57e9			cmp	#$7f
			bcc	l57ef
:l57ed			lda	#$2a
:l57ef			sta	$8b80,x
			cmp	#$20
			beq	l57f8
:l57f6			stx	r1L
:l57f8			inx
			iny
			cpy	#$10
			bne	l57df
:l57fe			rts
:l57ff			jsr	l581c
			clv
			bvc	l580c
:l5805			jsr	l581c
			lsr	r4H
			ror	r4L
:l580c			lda	r11L
			sec
			sbc	r4L
			sta	r11L
			lda	r11H
			sbc	r4H
			sta	r11H
			jmp	PutString
:l581c			ldy	#$00
			sty	r4L
			sty	r4H
:l5822			lda	(r0L),y
:l5824			beq	l583b
:l5826			sty	$024f
			jsr	GetCharWidth
			ldy	$024f
			clc
			adc	r4L
			sta	r4L
			bcc	l5838
:l5836			inc	r4H

:l5838			iny
			bne	l5822
:l583b			rts
:l583c			ldx	#$00
			jsr	l57dd
			ldy	r1L
			iny
			jsr	l256e
			lda	#$00
			sta	(r6L),y
			rts
:l584c			ldy	#$00
			sty	$01,x
			asl
			asl
			asl
			rol	$01,x
			sta	$00,x
			rts
:l5858			jsr	l586c
			b $90,$c7
			b $2f,$00
:l585f			b $18,$01
			rts
:l5862			jsr	l586c
			b $29,$8a
			b $09,$00
			b $06,$01
			rts
:l586c			pla
			sta	$3d
			pla
			sta	$3e
			ldy	#$01
			lda	($3d),y
			sta	r2L
			iny
			lda	($3d),y
			sta	r2H
			iny
			lda	($3d),y
			sta	r3L
			iny
			lda	($3d),y
			sta	r3H
			iny
			lda	($3d),y
			sta	r4L
			iny
			lda	($3d),y
			sta	r4H
			jsr	IsMseInRegion
			php
			lda	#$07
			jmp	DoInlineReturn
:l589a			jsr	l2447
			lda	#$80
			sta	$2f
			jsr	i_Rectangle
			and	#$8a
			ora	#$00
			asl	$01
			jmp	l26f7
:l58ad			stx	r0H
			sta	r0L
			jmp	PutString
:l58b4			jsr	l2447
			jsr	i_Rectangle
			and	#$76
			ora	#$00
			asl	$01
			jmp	l26f7
:l58c3			lda	#$04
			sta	r5H
			lda	#$06
			sta	r5L
:l58cb			lda	a5H
			sta	r4H
			lda	a5L
			sta	r4L
			rts
:l58d4			lda	#$00
			sta	r0L
			lda	a0L
			clc
			adc	#$6d
			sta	r0H
			rts
:l58e0			ldy	#$2f
			ldx	#$0d
			lda	PrntFileName
			beq	l58ed
:l58e9			ldy	#$84
			ldx	#$65
:l58ed			sty	$03e7
			stx	$03e6
			rts
:l58f4			lda	$03e6
			sta	r6L
			lda	$03e7
			sta	r6H
			jsr	FindFile
			txa
			cmp	#$05
			beq	l5929
:l5906			ldy	#$16
			lda	(r5L),y
			cmp	#$09
			bne	l5929
:l590e			lda	#$b7
			sta	r2L
			lda	#$c7
			sta	r2H
			lda	#$00
			sta	r3H
			lda	#$03
			sta	r3L
			lda	#$00
			sta	r4H
			lda	#$3f
			sta	r4L
			jmp	l594e
:l5929			lda	#$2c
			sta	r2H
			lda	#$84
			sta	r2L
			lda	#$bb
			sta	r1H
			lda	#$00
			sta	r11H
			lda	#$23
			sta	r11L
:l593d			jsr	l480e
			lda	r2H
			sta	r0H
			lda	r2L
			sta	r0L
			jsr	l5805
			jmp	UseSystemFont
:l594e			jsr	l244a
			jmp	Rectangle
:l5954			pha
			lda	a7L
			beq	l595c
:l5959			pla
			clc
			rts
:l595c			pla
			sec
			rts
:l595f			clc
			lda	#$03
			adc	r0L
			sta	r0L
			bcc	l596a
:l5968			inc	r0H
:l596a			jsr	l57c1
			lda	#$8b
			sta	r2H
			lda	#$80
			sta	r2L
			lda	#$b4
			sta	r1H
			lda	#$01
			sta	r11H
			lda	#$23
			sta	r11L
			jmp	l593d
:l5984			lda	#$b0
			sta	r2L
			lda	#$b9
			sta	r2H
			lda	#$00
			sta	r3H
			lda	#$fd
			sta	r3L
			lda	#$01
			sta	r4H
			lda	#$3f
			sta	r4L
			jmp	l594e
:l599f			lda	r1H
			sta	r0H
			lda	r1L
			sta	r0L
			rts
:l59a8			lda	#$cf
			bne	l59ae
:l59ac			lda	#$7f
:l59ae			sta	r15L
			php
			sei
			lda	$01
			pha
			lda	#$35
			sta	$01
			lda	#$7f
			sta	$dc00
			ldx	mport
			pla
			sta	$01
			plp

			txa
			sec
			sbc	r15L
			rts
:l59ca			txa
			beq	l59d1
:l59cd			cmp	#$0c
			bne	l59d2
:l59d1			rts
:l59d2			jsr	l259d
			jmp	l23c2
:l59d8			txa
			beq	l59e6
:l59db			cmp	#$0c
			beq	l59e6
:l59df			pla
			pla
			jsr	l31d1
			ldx	#$ff
:l59e6			rts
:l59e7			ldy	curDrive
			lda	driveType -8,y
			rts
:l59ee			lda	#$8b
			sta	r0H
			lda	#$80
			sta	r0L
			rts
:l59f7			lda	#$03
			sta	r1H
			lda	#$34
			sta	r1L
			rts
:l5a00			lda	#$8b
			sta	r2H
			lda	#$bc
:l5a06			sta	r2L
			rts
:l5a09			lda	#$82
			sta	r2H
			lda	#$90
			sta	r2L
			ldx	#$06
			rts
:l5a14			lda	#$8b
			sta	r3H
			lda	#$d0
			sta	r3L
			rts
:l5a1d			lda	#$8a
			sta	r4H
			lda	#$80
			sta	r4L
			rts
:l5a26			lda	#$8b
			sta	r5H
			lda	#$e4
			sta	r5L
			rts
:l5a2f			lda	#$84
			sta	r9H
			lda	#$00
			sta	r9L
			rts
:l5a38			lda	$0af0
			bne	l5a6f
:l5a3d			ldy	curDrive
			sty	$0af1
			lda	driveType -8,y
			sta	r5L
			lda	curDrive
			eor	#$01
			tay
			lda	driveType -8,y
			beq	l5abc
:l5a53			sta	r5H
			inc	numDrives
			lda	$88c3
			bne	l5a6f
:l5a5d			lda	r5H
			cmp	#$03
			beq	l5a69
:l5a63			bcs	l5a7c
:l5a65			cmp	r5L
			beq	l5a6f
:l5a69			jsr	l5abf
			txa
			bne	l5a7c
:l5a6f			jsr	l1aec
			jsr	OpenDisk
			cpx	#$0d
			bne	l5a86
:l5a79			jsr	l1aec
:l5a7c			dec	numDrives
			lda	#$00
			sta	$0af0
			beq	l5abc
:l5a86			txa
			bne	l5a8f
:l5a89			jsr	l36c7
			clv
			bvc	l5a92
:l5a8f			jsr	l369a
:l5a92			lda	$88c3
			beq	l5ab9
:l5a97			lda	curDrive
			pha
			lda	#$0a
			jsr	l1b16
			cpx	#$0d
			beq	l5ab5
:l5aa4			txa
			beq	l5aad
:l5aa7			jsr	l369a
			clv
			bvc	l5ab5
:l5aad			lda	$88c6
			beq	l5ab5
:l5ab2			jsr	l36c7
:l5ab5			pla
			jsr	l1b16
:l5ab9			jsr	l1aec
:l5abc			jmp	l31ec
:l5abf			sta	r12L
			lda	#$66
			sta	r6H
			lda	#$00
			sta	r6L
			lda	#$0e
			sta	r7L
			lda	#$01
			sta	r7H
			lda	#$5b
			sta	r10H
			lda	#$1a
			sta	r10L
			jsr	FindFTypes
			jsr	l253e
			ldx	#$05
			lda	r7H
			bne	l5b11
:l5ae5			lda	#$66
			sta	r0H
			lda	#$00
			sta	r0L
			jsr	OpenRecordFile
			jsr	l253e
			lda	r12L
			clc
			adc	#$01
			jsr	PointRecord
			jsr	l253e
			lda	#$0a
			sta	r7H
			lda	#$f2
			sta	r7L
			lda	#$0d
			sta	r2H
			lda	#$80
			sta	r2L
			jsr	ReadRecord
:l5b11			jsr	l253e
			lda	#$ff
			sta	$0af0
			rts
			b $43,$6f,$6e
			b $66,$69,$67
			b $75,$72,$65
			b $00,$4c,$bd

.vlirModBase		= $5b46
.vlirModSize		= $0aba
.vlirModEnd		= ( vlirModBase + vlirModSize )

;Endadresse Haupt-Modul testen:
			g vlirModBase
