; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** GEOS-Variablen löschen.
:xFirstInit		sei
			cld
if Flag64_128 = TRUE_C128
			LoadB	scr80polar,%01000000
endif
			jsr	GEOS_Init1

			lda	#>xEnterDeskTop
			sta	EnterDeskTop   +2
			lda	#<xEnterDeskTop
			sta	EnterDeskTop   +1

			lda	#$7f
			sta	maxMouseSpeed
			sta	mouseAccel
			lda	#$1e
			sta	minMouseSpeed

			jsr	xResetScreen

			ldy	#$3e
			lda	#$00
::2			sta	mousePicData,y
			dey
			bpl	:2

			ldx	#$15
::3			lda	OrgMouseData,x		;Daten für Mauszeiger ab
			sta	mousePicData,x		;":OrgMouseData" kopieren.
			dex
			bpl	:3

;*** Sprite-Zeiger-Kopie setzen.
:DefSprPoi		lda	#$bf
			sta	$8ff0
			ldx	#$07
			lda	#$bb
::1			sta	$8fe8,x
			dex
			bpl	:1

if Flag64_128 = TRUE_C64
			rts
else
			lda	#0
			sta	r0L
			sta	r0H
			jmp	xSetMsePic		;80-Zeichen Mausdaten setzen
endif
