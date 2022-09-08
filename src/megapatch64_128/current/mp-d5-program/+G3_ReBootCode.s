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

			PushW	$0314			;Zeiger auf IRQ-Routine retten

			LoadB	CPU_DATA,$30
			LoadB	RAM_Conf_Reg,$40	;keine Common Area    VIC = Bank 1
			LoadB	MMU,$7e			;nur RAM Bank 1 + IO

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

			LoadB	MMU,$7f			;nur RAM Bank 1

			ldy	#$00
::4			lda	(r0L),y			;Daten nach
			sta	(r1L),y			;$d000 (Bank 1)
			iny	 			;bis $feff verschieben
			bne	:4
			inc	r0H
			inc	r1H
			lda	r1H
			cmp	#$ff
			bne	:4

			ldy	#5			;Bereich $ff05 bis $ffff
::3			lda	(r0L),y			;setzen in Bank 1
			sta	(r1L),y
			iny
			bne	:3

			LoadB	MMU,$7e			;nur RAM Bank 1 + IO

			LoadW	r0,$1000
			LoadW	r1,$3900
			LoadW	r2,$3000
			LoadB	r3L,$00
			jsr	SysFetchRAM		;Kernal Teil #5 (Bank 0) einlesen.

			LoadW	r0 ,$1000
			LoadW	r1 ,$c000		;$c000 - $efff in Bank 0 setzen

			LoadB	RAM_Conf_Reg,$4b	;16kByte Common Area oben = Bank 0
			LoadB	MMU,$7f			;nur RAM Bank 1

			ldy	#$00
::4a			lda	(r0L),y			;Daten nach
			sta	(r1L),y			;$c000 (Bank 0)
			iny	 			;bis $efff verschieben
			bne	:4a
			inc	r0H
			inc	r1H
			lda	r1H
			cmp	#$f0			;Ende $f000 erreicht?
			bne	:4a			;>nein

			LoadB	RAM_Conf_Reg,$40	;keine Common Area    VIC = Bank 1
			LoadB	MMU,$7e			;nur RAM Bank 1 + IO

			LoadW	r0,$1000
			LoadW	r1,$6900
			LoadW	r2,$1000
			LoadB	r3L,$00
			jsr	SysFetchRAM		;Kernal Teil #6 (Bank 0) einlesen.

			LoadW	r0 ,$1000
			LoadW	r1 ,$f000		;$f000 - $ffff in Bank 0 setzen

			LoadB	RAM_Conf_Reg,$4b	;16kByte Common Area oben = Bank 0
			LoadB	MMU,$7f			;nur RAM Bank 1

			ldy	#$00
::4b			lda	(r0L),y			;Daten nach
			sta	(r1L),y			;$f000 (Bank 0)
			iny	 			;bis $feff verschieben
			bne	:4b
			inc	r0H
			inc	r1H
			lda	r1H
			cmp	#$ff
			bne	:4b

			ldy	#5			;Bereich $ff05 bis $ffff
::3a			lda	(r0L),y			;setzen in Bank 0
			sta	(r1L),y
			iny
			bne	:3a

			LoadB	MMU,$7e			;nur RAM Bank 1 + IO
			LoadB	RAM_Conf_Reg,$40	;keine Common Area    VIC = Bank 1

;*** Variablenspeicher löschen.
			jsr	i_FillRam
			w	$0500
			w	$8400
			b	$00

;*** GEOS initiailisieren.
			LoadB	dispBufferOn,ST_WR_FORE

			lda	Mode_Conf_Reg		;40(1)/80(2) Zeichen Modus
			and	#$80			;Flag maskieren und umdrehen
			eor	#$80			;umdrehen und in graphMode
			sta	graphMode		;speichern 40($00)/80($80)
			bmi	:80

			LoadW	r0,$a000
			ldx	#$7d
::1			ldy	#$3f
::2			lda	#$55
			sta	(r0L),y
			dey
			lda	#$aa
			sta	(r0L),y
			dey
			bpl	:2
			lda	r0L
			clc
			adc	#$40
			sta	r0L
			bcc	:7
			inc	r0H
::7			dex
			bne	:1
			beq	:weiter

::80			lda	#$02
			jsr	SetPattern
			jsr	i_Rectangle
			b	$00,$c7
			w	$0000,$027f

::weiter		jsr	FirstInit
			jsr	SCPU_OptOn		;SCPU optimieren.
			lda	#$ff
			sta	firstBoot

			jsr	InitMouse		;Mausabfrage initialisieren.

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

			lda	$dc08
			sta	$dc08

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
;    notwendig. Fehlt diese Routine ist ohne ein Laufwerk wie z.B. C=1541
;    ein Start über RBOOT nicht möglich (Fehlerhaftes IRQ-verhalten!)
;    Ist kein Gerät am ser. Bus aktiviert, kann GEOS ohne diese Routine
;    nicht gestartet werden!!!
:Wait			jsr	InitForIO		;I/O-Bereich einblenden.

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
