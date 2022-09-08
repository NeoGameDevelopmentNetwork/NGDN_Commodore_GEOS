; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Symboltabellen.
if .p
			t "opt.GDOSl10n.ext"
			t "SymbTab_GDOS"
			t "SymbTab_1"
			t "SymbTab_GERR"
			t "SymbTab_GTYP"
			t "SymbTab_DTYP"
			t "SymbTab_MMAP"
			t "SymbTab_DISK"
			t "MacTab"

;--- Externe Labels.
			t "s.GDC.Config.ext"
endif

;*** GEOS-Header.
			n "obj.CFG.INIT"
			f DATA

			o BASE_CONFIG_TOOL

;******************************************************************************
;*** Sprungtabelle.
;******************************************************************************
:MainInit		jmp	InitMain
::dummy1		ldx	#FILE_NOT_FOUND
			rts
::dummy2		ldx	#FILE_NOT_FOUND
			rts
;******************************************************************************

;*** GD.CONFIG intialisieren.
:InitMain		ldx	#0
::1			lda	fileHeader +6,x
			sta	sysCfgInitAdr,x
			inx
			cpx	#8*2
			bcc	:1

			jsr	FindCfgTools		;Konfigurations-Module suchen.
			txa				;Fehler?
			bne	:doErrExit		; => Ja, Abbruch...

;--- GD.INI einlesen.
			LoadW	r0,BASE_GCFG_DATA	;Zeiger auf GD.INI in DACC.
			LoadW	r1,R3A_CFG_GDOS
			LoadW	r2,R3S_CFG_GDOS
			lda	MP3_64K_DATA
			sta	r3L
			jsr	FetchRAM		;GD.INI einlesen.

;--- DiskCore einlesen.
			LoadW	r0,BASE_DDRV_CORE	;Zeiger auf GD.DISK.CORE in DACC.
			LoadW	r1,R2A_DDRVCORE
			LoadW	r2,R2S_DDRVCORE
			lda	MP3_64K_SYSTEM
			sta	r3L
			jsr	FetchRAM		;GD.DISK.CORE einlesen.

;--- Treiberliste initialisieren.
			jsr	InitDevList

;--- Menü starten/AutoBoot ausführen.
			bit	firstBoot		;GEOS-BootUp ?
			bmi	:doAppStart		; => Nein, weiter...

::doAutoBoot		ldx	#$ff
			rts

::doAppStart		ldx	#$00
::doErrExit		rts

;*** Konfigurationsmodule suchen.
:FindCfgTools		php
			sei

			jsr	Get1stDirEntry		;Erster DIR-Sektor lesen.
			txa				;Diskettenfehler?
			bne	:8			; => Ja, Abbruch.

;			ldx	#$00			;Cache löschen.
;			lda	#$00
::0			sta	sysCfgToolAdr,x
			inx
			cpx	#8*2
			bcc	:0

			LoadB	r7H,8			;Modulzähler initialisieren.

::1			tay				;yReg=$00.
			lda	(r5L),y			;Gelöschter Eintrag?
			beq	:4			; => Ja, weiter...
			iny
			lda	(r5L),y			;Sektoradresse gültig?
			beq	:4			; => Nein, weiter...

			iny				;"GD.C..." ?
			iny
			lda	(r5L),y
			cmp	#"G"
			bne	:4
			iny
			lda	(r5L),y
			cmp	#"D"
			bne	:4
			iny
			iny
			lda	(r5L),y
			cmp	#"C"
			bne	:4			; => Nein, weiter...

			PushW	r1
			PushW	r4

			jsr	testCfgNames		;Auf Konfigurationsmodul testen.

			PopW	r4
			PopW	r1

			txa				;Modul gefunden?
			bne	:4			; => Nein, weiter...

			dec	r7H			;Alle Module gefunden?
			beq	:8			; => Ja, Ende...

::4			jsr	GetNxtDirEntry		;Zeiger auf nächsten Eintrag.
			txa				;Diskettenfehler?
			bne	:8			; => Ja, Abbruch...
			tya				;Verzeichnis-Ende erreicht?
			beq	:1			; => Nein, weiter...

::8			plp
			rts

;*** Auf Konfigurationsmodul testen.
:testCfgNames		lda	#0			;Modul-Zähler zurücksetzen.
::1			sta	r7L			;Zeiger auf ersten Track/Sektor
			asl				;in Systemtabelle/Cache kopieren.
			tax
			lda	sysCfgToolAdr +0,x
			bne	:4			;Modul bereits gefunden, weiter...

			lda	sysCfgToolNmVec +0,x
			sec
			sbc	#< $0003
			sta	r6L
			lda	sysCfgToolNmVec +1,x
			sbc	#> $0003
			sta	r6H

			ldy	#$03
::2			lda	(r6L),y			;Dateinamen vergleichen.
			beq	:3			; => Ende Modul-Name erreicht...
			cmp	(r5L),y
			bne	:4			; => Falsche Datei...
			iny				;Kompletter Modul-Name geprüft?
			bne	:2			; => Nein, weiter...

::3			cpy	#$13
			beq	:5			; => Richtige Datei...
			lda	(r5L),y
			iny
			cmp	#$a0
			beq	:3
			bne	:4			; => Falsche Datei...

::5			ldy	#1			;Zeiger auf ersten Track/Sektor
			lda	(r5L),y			;einlesen.
			sta	r1L
			iny
			lda	(r5L),y
			sta	r1H

			ldy	#21
			lda	(r5L),y			;SEQ oder VLIR?
			beq	:6			; => SEQ, weiter...

			LoadW	r4,fileHeader
			jsr	GetBlock		;VLIR-Header einlesen.
			txa				;Fehler?
			bne	:4			; => Ja, Datei ignorieren...

			lda	fileHeader +2		;Zeiger auf ersten Track/Sektor
			sta	r1L			;einlesen.
			lda	fileHeader +3
			sta	r1H

::6			lda	r7L			;Zeiger auf ersten Track/Sektor
			asl				;in Systemtabelle/Cache kopieren.
			tax
			lda	r1L
			sta	sysCfgToolAdr +0,x
			lda	r1H
			sta	sysCfgToolAdr +1,x

			ldx	#NO_ERROR
			rts

::4			lda	r7L			;Nächstes Konfigurationsmodul.
			clc
			adc	#$01
			cmp	#8			;Alle Module getestet?
			bcc	:1			; => Nein, weiter...

			ldx	#FILE_NOT_FOUND
			rts

;*** Treiberinformationen initialisieren.
; - Tabelle mit gültigen Laufwerkstypen initialisieren.
; - Tabelle mit verfügbaren Laufwerkstreibern löschen.
:InitDevList		jsr	i_FillRam		;Speicher für Treiber löschen.
			w	SIZE_DDRV_DATA
			w	BASE_DDRV_DATA
			b	$00

			jsr	i_FillRam		;DiskDataRAM_A/S/B
			w	DDRV_MAX*2 +DDRV_MAX*2 +DDRV_MAX
			w	DRVINF_NG_START
			b	$00

			jsr	i_FillRam		;DiskDrvData
			w	DDRV_MAX
			w	DRVINF_NG_FOUND
			b	$00

			jsr	i_MoveData		;DiskDrvTypes
			w	DskDrvTypes
			w	DRVINF_NG_TYPES
			w	DDRV_MAX

			jsr	i_MoveData		;DiskDrvNames
			w	DskDrvNames
			w	DRVINF_NG_NAMES
			w	DDRV_MAX*17

			rts

;--- Hinweis:
;Die Laufwerkstypen werden beim Start
;von GD.CONFIG an die richtige Adresse
;im Speicher kopiert.
			t "-D3_DrvTypes"
