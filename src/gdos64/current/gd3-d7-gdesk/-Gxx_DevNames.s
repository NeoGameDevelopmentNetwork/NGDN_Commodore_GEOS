; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Zeiger auf Laufwerks-Info einlesen.
;    Übergabe: YREG =  Laufwerksadresse.
;    Rückhabe: r0 = Zeiger auf Laufwerkstext.
:doGetDevType		LoadW	r0,:names

			ldx	#$00			;Laufwerkstyp in Tabelle suchen.
::1			lda	RealDrvType -8,y	;Laufwerkstyp einlesen.
			cmp	:types,x
			beq	:2
			AddVBW	17,r0
			inx
			cpx	#27			;Alle Laufwerkstypen durchsucht?
			bcc	:1			; => Nein, weiter...

			lda	#<:unknown
			ldy	#>:unknown
			bne	:3			; => Unbekanntes Laufwerk.

::2			tax				;Kein Laufwerk?
			beq	:4			; => Ja, Ende...
			cmp	#$04			;1541-1581?
			bcs	:4			; => Nein, weiter...

			lda	RealDrvMode -8,y
			and	#SET_MODE_SD2IEC	;SD2IEC-Laufwerk?
			beq	:4			; => nein, weiter...

;--- Sonderbehandlung für SD2IEC mit 1541/71/81-Treiber.
			lda	#<:nameSD41
			ldy	#>:nameSD41
			cpx	#Drv1541
			beq	:3
			lda	#<:nameSD71
			ldy	#>:nameSD71
			cpx	#Drv1571
			beq	:3
			lda	#<:nameSD81
			ldy	#>:nameSD81
::3			sta	r0L			;Zeiger auf Laufwerkstext
			sty	r0H			;für SD41/71/81-Laufwerk.
::4			rts

;*** Tabelle mit Laufwerkstypen.
::types			b $00,$01,$41,$02,$03,$05
			b $81,$82,$83,$84
			b $c4,$a4,$b4
			b $31,$32,$33,$34
			b $11,$12,$13,$14,$15
			b $21,$22,$23,$24
			b $04

;*** Texte für Laufwerkstypen.
::names
if LANG = LANG_DE
			b "Kein Laufwerk"
endif
if LANG = LANG_EN
			b "No drive"
endif
			e :names + 1*17
			b "C=1541"
			e :names + 2*17
			b "C=1541 (Cache)"
			e :names + 3*17
			b "C=1571"
			e :names + 4*17
			b "C=1581"
			e :names + 5*17
			b "C=1581/DOS"
			e :names + 6*17
			b "RAM 1541"
			e :names + 7*17
			b "RAM 1571"
			e :names + 8*17
			b "RAM 1581"
			e :names + 9*17
			b "RAM Native"
			e :names +10*17
			b "SRAM Native"
			e :names +11*17
			b "CREU Native"
			e :names +12*17
			b "GRAM Native"
			e :names +13*17
			b "CMD RL41"
			e :names +14*17
			b "CMD RL71"
			e :names +15*17
			b "CMD RL81"
			e :names +16*17
			b "CMD RLNative"
			e :names +17*17
			b "CMD FD41"
			e :names +18*17
			b "CMD FD71"
			e :names +19*17
			b "CMD FD81"
			e :names +20*17
			b "CMD FDNative"
			e :names +21*17
			b "CMD FDPCDOS"
			e :names +22*17
			b "CMD HD41"
			e :names +23*17
			b "CMD HD71"
			e :names +24*17
			b "CMD HD81"
			e :names +25*17
			b "CMD HDNative"
			e :names +26*17
			b "SD2IEC Native"
			e :names +27*17
if LANG = LANG_DE
::unknown		b "Unbekannt ?"
endif
if LANG = LANG_EN
::unknown		b "Unknown ?"
endif
			e :names +28*17

;*** Sondertexte für SD2IEC mit 1541/71/81-Treiber.
::nameSD41		b "SD2IEC 1541"
			e :nameSD41 +17
::nameSD71		b "SD2IEC 1571"
			e :nameSD71 +17
::nameSD81		b "SD2IEC 1581"
			e :nameSD81 +17
