; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Speichererweiterung einlesen.
:LoadConfigDACC		lda	#6
			ldy	#> FNamGDINI
			ldx	#< FNamGDINI
			jsr	SETNAM			;Dateiname festlegen.

			lda	#1
			ldx	curDevice
			ldy	#0
			jsr	SETLFS
			jsr	OPENCHN			;OPEN 1,x,0,"GD.INI"

			ldx	#1
			jsr	CHKIN			;Eingabe von Datei.

			jsr	CHRIN			;GD.INI-Kennung einlesen.
			pha
			jsr	CHRIN
			tay
			pla

			ldx	STATUS			;Datei "GD.INI" geöffnet?
			bne	:2			; => Nein, weiter...

			cmp	#GDINI_VER		;GD.INI-Version gültig?
			bne	:err			; => Nein, Abbruch...
			cpy	#$c0			;GD.INI-Kennbyte gültig?
			bne	:err			; => Nein, Abbruch...

			ldy	#0
::1			jsr	CHRIN			;Speichererweiterung einlesen und
			sta	BOOT_RAM_TYPE,y		;zwischenspeichern.
			iny
			cpy	#5
			bcc	:1

			ldx	#NO_ERROR
			b $2c
::err			ldx	#INCOMPATIBLE
::2			txa
			pha

			jsr	CLRCHN			;Standard-I/O herstellen.

			lda	#1
			jsr	CLOSE			;Datei schließen.

			pla
			tax

			rts
