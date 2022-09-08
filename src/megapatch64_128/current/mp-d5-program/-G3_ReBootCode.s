; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** GEOS-ReBoot-Routine.
:GEOS_ReBootSys		sei
			cld
			ldx	#$ff
			txs
			lda	#$30
			sta	CPU_DATA

			PushW	$0314			;IRQ-Vektor speichern.

			LoadW	r0,DISK_BASE
			LoadW	r1,$8300
			LoadW	r2,$0d80
			LoadB	r3L,$00
			jsr	SysFetchRAM		;Laufwerkstreiber einlesen.

			LoadW	r0,$9d80
			LoadW	r1,$b900
			LoadW	r2,$0280
			LoadB	r3L,$00
			jsr	SysFetchRAM		;Kernal Teil #1 einlesen.

			LoadW	r0,$bf40
			LoadW	r1,$bb80
			LoadW	r2,$00c0
			LoadB	r3L,$00
			jsr	SysFetchRAM		;Kernal Teil #2 einlesen.

			LoadW	r0,$c100
			LoadW	r1,$bd40
			LoadW	r2,$0f00
			LoadB	r3L,$00
			jsr	SysFetchRAM		;Kernal Teil #3 einlesen.

			LoadW	r0,$1000
			LoadW	r1,$cc40
			LoadW	r2,$3000
			LoadB	r3L,$00
			jsr	SysFetchRAM		;Kernal Teil #4 einlesen.

			LoadW	r0 ,$1000
			LoadW	r1 ,$d000

			ldx	#$30
			ldy	#$00
::51			lda	(r0L),y
			sta	(r1L),y
			iny
			bne	:51
			inc	r0H
			inc	r1H
			dex
			bne	:51

;*** Variablenspeicher löschen.
			jsr	i_FillRam
			w	$0500
			w	$8400
			b	$00

;*** GEOS initiailisieren.
			jsr	FirstInit		;GEOS initialisieren.
			jsr	SCPU_OptOn		;SCPU optimieren.

			lda	#$ff			;GEOS-Boot-Vorgang.
			sta	firstBoot

			jsr	InitMouse		;Mausabfrage initialisieren.

			LoadB	dispBufferOn,ST_WR_FORE

			lda	#$02			;Bildschirm löschen.
			jsr	SetPattern

			jsr	i_Rectangle
			b	$00,$c7
			w	$0000,$013f

;*** GEOS-Variablen aus REU einlesen.
			LoadW	r0,ramExpSize		;GEOS-Variablen aus REU in
			LoadW	r1,$7dc3		;C64-RAM kopieren.
			LoadW	r2,$0002
			LoadB	r3L,$00
			jsr	SysFetchRAM

			lda	sysFlgCopy		;System-Flag speichern.
			sta	sysRAMFlg

			LoadW	r0,year			;Datum aus REU einlesen.
			LoadW	r1,$7a16
			LoadW	r2,$0003
			lda	#$00
			sta	r3L
			jsr	FetchRAM

			LoadW	r0,driveType		;Laufwerkstypen aus REU einlesen.
			LoadW	r1,$798e
			LoadW	r2,$0004
			jsr	FetchRAM

			LoadW	r0,ramBase		;RAM-Adressen aus REU einlesen.
			LoadW	r1,$7dc7
			LoadW	r2,$0004
			jsr	FetchRAM

			LoadW	r0,driveData		;Laufwersdaten aus REU einlesen.
			LoadW	r1,$7dbf
			LoadW	r2,$0004
			jsr	FetchRAM

			LoadW	r0,PrntFileName		;Name des Druckertreibes aus
			LoadW	r1,$7965		;REU einlesen.
			LoadW	r2,$0011
			jsr	FetchRAM

			LoadW	r0,inputDevName		;Name des Eingabetreibes aus
			LoadW	r1,$7dcb		;REU einlesen.
			LoadW	r2,$0011
			jsr	FetchRAM

			LoadW	r0,curDrive		;Aktuelles Laufwerk aus
			LoadW	r1,$7989		;REU einlesen.
			LoadW	r2,$0001
			jsr	FetchRAM

			LoadW	r0,$8a00		;Mauszeiger aus.
			LoadW	r1,$fc40		;REU einlesen.
			LoadW	r2,$003f
			jsr	FetchRAM

			LoadW	r0,mousePicData		;Mauszeiger aus.
			LoadW	r1,$fc40		;REU einlesen.
			LoadW	r2,$003f
			jsr	FetchRAM

;*** Warteschleife.
;    Dabei wird zuerst der I/O-Bereich eingeblendet und anschließend die
;    Original-IRQ-Routine aktiviert. Diese Routine ist beim C64 zwingend
;    notwendig. Feht diese Routine ist ohne ein Laufwerk wie z.B. C=1541
;    ein Start über RBOOT nicht möglich (Fehlerhaftes IRQ-verhalten!)
;    Ist kein Gerät am ser. Bus aktiviert, kann GEOS ohne diese Routine
;    nicht gestartet werden!!!
:Wait			jsr	InitForIO		;I/O-Bereich einblenden.

			lda	$dc08			;Uhrzeit starten.
			sta	$dc08

			PopW	$0314			;Zeiger auf IRQ-Routine setzen.
			cli				;IRQ aktivieren und warten bis
			lda	$dc08			;IRQ ausgeführt wurde...
::51			cmp	$dc08
			beq	:51

			jsr	DoneWithIO		;I/O-Bereich ausblenden.

;*** Laufwerke aktivieren.
:InstallDrives		lda	curDrive		;Aktuelles Laufwerk merken.
			pha

			lda	#$00			;Anzahl Laufwerke löschen.
			sta	numDrives

			ldy	#8			;Zeiger auf Laufwerk #8.
::51			sty	:52 +1
			lda	driveType -8,y		;Laufwerk verfügbar ?
			beq	:53			;Nein, weiter...

			inc	numDrives		;Anzahl Laufwerke +1.
			lda	:52 +1
			jsr	SetDevice		;Laufwerk aktivieren.
			jsr	NewDisk			;Diskette öffnen.

::52			ldy	#$ff
::53			iny				;Zeiger auf nächstes Laufwerk.
			cpy	#12			;Alle Laufwerke getestet ?
			bcc	:51			;Nein, weiter...

			pla
			jsr	SetDevice		;Laufwerk zurücksetzen.
			jmp	EnterDeskTop		;Zurück zum DeskTop.
