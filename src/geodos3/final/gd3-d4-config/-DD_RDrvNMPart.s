; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Name für RAM-Laufwerk definieren.
;    Übergabe: A/X/Y enthalten die drei Buchstaben für den Standard-
;              Laufwerksnamen (RAM, GEOS, REU, SRC).
;              Zusammen mit dem Laufwerks-Buchstaben erhält damit jedes
;              RAM-Laufwerk einen individuellen Namen. Notwendig für
;              ältere DeskTop-varianten die Laufwerke über den Disknamen
;              erkennen (z.B. DESKTOP v2.0).
:SetRDrvName		sta	RDrvNMDskName +0	;Laufwerkskennung speichern.
			stx	RDrvNMDskName +1
			sty	RDrvNMDskName +2

			lda	DrvAdrGEOS		;Laufwerksbuchstabe speichern.
			clc
			adc	#$39
			sta	RDrvNMDskName +3
			rts

;*** Ist BAM und Partitionsgröße gültig ?
:TestCurBAM		jsr	CheckDiskBAM
			txa				;Gültige BAM verfügbar?
			bne	:bad			; => Nein, Ende...

			jsr	GetSekPartSize		;Größe des Laufwerks einlesen.
			txa				;Diskettenfehler?
			bne	:bad			; => Ja, Abbruch...

;--- Ergänzung: 19.05.21/M.Kanet
;Größe des Laufwerks testen. Falls
;BAM gültig beim GEOS-BootUp bzw. bei
;GD-Update Größe übernehmen.
			lda	SetSizeRRAM		;Laufwerksgröße definiert ?
			bne	:skip			; => Ja, weiter...
			bit	firstBoot		;GEOS-BootUp ?
			bmi	:skip			; => Nein, weiter...
			sty	SetSizeRRAM		;Laufwerksgröße übernehmen.
			bpl	:ok			;(Wegen GD-Update notwendig!)
::skip			cpy	SetSizeRRAM		;Partitionsgröße unverändert ?
			bne	:bad			; => Nein, Ende...

::ok			ldx	#NO_ERROR
			rts
::bad			ldx	#BAD_BAM
			rts

;*** Ist ein gültige BAM vorhanden ?
:CheckDiskBAM		jsr	OpenDisk		;Diskette öffnen.
			txa				;Diskettenfehler ?
			bne	:52			; => Ja, Laufwerk initialisieren.

;--- Ergänzung: 16.12.18/M.Kanet
;Da standardmäßig keine GEOS-Disketten mehr erzeugt werden kann der
;GEOS-Format-String nicht als Referenz genutzt werden.
;Byte#2=$48 / Byte#3=$00 verwenden.
if EN_GEOS_DISK = FALSE
			lda	curDirHead +2		;"H" = NativeMode.
			cmp	#$48
			bne	:52
			ldy	curDirHead +3		;$00 = Standard.
			bne	:52
::50			lda	curDirHead+64,y		;Weitere Prüfbytes.
			bne	:52
			iny
			cpy	#$10
			bcc	:50
endif

if EN_GEOS_DISK = TRUE
			LoadW	r0,curDirHead +$ad
			LoadW	r1,DrvFormatCode
			ldx	#r0L
			ldy	#r1L			;Auf GEOS-Kennung
			lda	#12			;"GEOS-format" testen.
			jsr	CmpFString		;Kennung vorhanden ?
			bne	:52			; => Nein, Directory löschen.
endif

::51			ldx	#NO_ERROR
			rts
::52			ldx	#BAD_BAM
			rts

;*** BAM erstellen.
:InitRDrvNM		jsr	CreateBAM		;BAM erstellen.
			txa				;Installationsfehler ?
			bne	:2			; => Ja, Abbruch...

			lda	DrvAdrGEOS		;Laufwerk aktivieren.
			jsr	SetDevice
			jsr	OpenDisk		;Diskette öffnen.
			txa				;Diskfehler?
			bne	:2			; => Ja, Abbruch...

			ldx	#r0L			;Zeiger auf aktuellen Disknamen.
			jsr	GetPtrCurDkNm

			ldy	#$00
			lda	(r0L),y			;Diskettenname gültig ?
			bne	:3			; => Ja, weiter...

			ldy	#$00			;BAM Teil #1 definieren.
::1			lda	BAM_NM_BLK1,y
			sta	curDirHead,y
			iny
			cpy	#$c0
			bcc	:1

			jsr	PutDirHead		;Aktuellen BAM-Sektor speichern.
			txa				;Vorgang erfolgreich?
			beq	:3			;Ja, weiter...

;--- Fehler beim erstellen der BAM, Laufwerk nicht installiert.
::2			ldx	DrvAdrGEOS		;Laufwerksdaten löschen.
			jsr	DskDev_ClrData
			ldx	#BAD_BAM
			rts

;--- Laufwerk installiert, Ende...
::3			ldx	#NO_ERROR
			rts

;*** Partitionsgröße einstellen.
:SetPartSizeData	lda	MaxSizeRRAM		;Speicher verfügbar?
			beq	:error			; => Nein, Abbruch.

			ldx	SetSizeRRAM		;Größe bereits festgelegt ?
			bne	:1			; => Ja, weiter.
			sta	SetSizeRRAM		;Max. Größe vorbelegen.

::1			cmp	SetSizeRRAM		;Max. Größe überschritten ?
			bcs	:2			; => Nein, weiter...
			sta	SetSizeRRAM		; => Ja, Größe zurücksetzen...

::2			bit	firstBoot		;GEOS-BootUp ?
			bmi	:set_size		; => Nein, weiter...

			ldx	DrvAdrGEOS
			lda	SetSizeRRAM		;Startadresse RAM-Speicher mit
			cmp	DrvDataSize -8,x	;gesp. RAM-Größe vergleichen.
			bne	:update			; => Ja, weiter...
			beq	:done

;--- Partitionsgröße einstellen.
::set_size		jsr	DoDlg_RDrvNMSize	;Partitionsgröße wählen.
			txa				;Auswahl abgebrochen ?
			bne	:cancel			; => Ja, Ende...

::update		ldx	DrvAdrGEOS
			lda	SetSizeRRAM		;Startadresse RAM-Speicher in
			sta	DrvDataSize -8,x	;aktuelle Konfiguration übernehmen.

			jsr	UpdateDskDrvData	;Neue Einstellung speichern.

::done			ldx	#NO_ERROR		;Kein Fehler, Ende.
			rts
::cancel		ldx	#CANCEL_ERR
			rts
::error			ldx	#NO_FREE_RAM
			rts

;*** Größe der aktiven Partition einlesen.
:GetCurPartSize		bit	firstBoot		;GEOS-BootUp ?
			bmi	:test			; => Nein, weiter...

			ldx	#NO_ERROR
			lda	SetSizeRRAM		;Partitionsgröße definiert ?
			bne	:skip			; => Ja, weiter...

::test			lda	DrvMode
			and	#%11110000
			cmp	#%10000000		;RAMNative oder Ext.RAM-Laufwerk ?
			beq	:ram_nm			; => RAMNative, weiter...

;--- Test für Ext.RAM-Laufwerke.
;			ldx	DrvAdrGEOS
;			lda	ramExpSize		;Start hinter GEOS-DACC.
;			sta	rambase -8,x		;Startadresse RAM-Laufwerk setzen.

::ram_ext		jsr	CheckDiskBAM		;BAM überprüfen.
			txa				;Ist BAM gültig ?
			bne	:11			; => Nein, Ende...

			jsr	GetSekPartSize		;Größe eines früheren RAMNative-
			cpy	MaxSizeRRAM		;Laufwerks ermitteln.
			bcc	:12			;Damit wird bei RAMNative die
::11			ldy	MaxSizeRRAM		;frühere Größe als Vorgabe gesetzt.
::12			sty	SetSizeRRAM
			rts

;--- Test für RAM-Native.
::ram_nm		ldy	DrvAdrGEOS
			lda	ramBase -8,y		;Startadresse Laufwerk speichern.
			pha

			bne	:21			; => Start definiert, weiter...
			ldy	#1
			jsr	FindFreeRAM		;Freie Speicherbank suchen.
			cpx	#NO_ERROR		;Speicher frei ?
			bne	:done			; => Nein, Abbruch...

			ldx	DrvAdrGEOS
			sta	ramBase -8,x		;Startadresse RAM-Laufwerk setzen.

::21			jsr	GetSekPartSize		;Größe eines früheren RAMNative-
							;Laufwerks ermitteln.
							;Damit wird bei RAMNative die
;			ldy	#xy			;frühere Größe als Vorgabe gesetzt.
			jsr	FindFreeRAM		;Kann Laufwerk eingerichtet werden ?
			cpx	#NO_ERROR
			bne	:done			; => Nein, weiter..

			ldx	DrvAdrGEOS		;Laufwerksadresse einlesen.
			sta	ramBase -8,x		;Startadresse setzen. Kann eine
							;andere sein als zuvor gesetzt, z.B.
							;wenn der benötigte Speicher an der
							;alten Adresse nicht verfügbar ist.

			jsr	CheckDiskBAM		;BAM überprüfen.
			txa				;Ist BAM gültig?
			bne	:done			; => Nein, Ende...

			jsr	GetSekPartSize		;Größe des installierten
			txa				;Laufwerks ermitteln.
			bne	:done

			sty	SetSizeRRAM 		;Partitionsgröße speichern.

::done			pla
			ldy	DrvAdrGEOS
			sta	ramBase -8,y
::skip			rts

;*** Sektor mit Laufwerksgröße einlesen.
:GetSekPartSize		ldx	#$01			;Sektor 01/02 mit BAM einlesen.
			stx	r1L
			inx
			stx	r1H
			LoadW	r4,diskBlkBuf
			jsr	GetBlock
			txa				;Diskettenfehler?
			bne	:51			;Ja, Abbruch...

			lda	MaxSizeRRAM
			ldy	diskBlkBuf +8		;Laufwerksgröße einlesen.
			beq	:50			; => Ungültig, Ende...
			cpy	MaxSizeRRAM		;Laufwerksgröße möglich ?
			bcc	:51			; => Ja, weiter...
::50			tay				;Laufwerksgröße übergeben.

::51			rts

;*** Neue BAM erstellen.
:ClearCurBAM		lda	SetSizeRRAM		;Partitionsgröße festlegen.
			sta	BAM_NM_SIZE

			ldy	#$00			;BAM Teil #1 definieren.
::51			lda	BAM_NM_BLK1,y
			sta	diskBlkBuf,y
			iny
			cpy	#$c0
			bcc	:51

			lda	#$00
::52			sta	diskBlkBuf,y
			iny
			bne	:52

			lda	#$01			;BAM Teil #1 speichern.
			sta	r1L
			sta	r1H
			LoadW	r4,diskBlkBuf
			jsr	PutBlock
			txa				;Diskettenfehler?
			bne	:58			;Ja, Abbruch...

			ldy	#$00			;BAM Teil #2 definieren.
::53			lda	BAM_NM_BLK2,y
			sta	diskBlkBuf,y
			iny
			cpy	#$40
			bcc	:53

			lda	#$ff
::54			sta	diskBlkBuf,y
			iny
			bne	:54

			inc	r1H			;BAM Teil #2 speichern.
;			LoadW	r4,diskBlkBuf
			jsr	PutBlock
			txa				;Diskettenfehler?
			bne	:58			;Ja, Abbruch...

			ldy	#$00			;BAM Teil #3 definieren.
			lda	#$ff
::55			sta	diskBlkBuf,y
			iny
			bne	:55

::56			inc	r1H			;Zeiger auf nächstenn Sektor.
			CmpBI	r1H,$22			;BAM erstellt?
			bcs	:57			;Ja, -> Ende.

;			LoadW	r4,diskBlkBuf
			jsr	PutBlock
			txa				;Diskettenfehler?
			bne	:58			;Ja, Abbruch...
			beq	:56

;--- Ersten Verzeichnissektor löschen.
::57			jsr	OpenDisk		;BAM einlesen und Größe der Native-
			txa				;Partition innerhalb des Treibers
			bne	:58			;festlegen.

			jsr	ClrDiskSekBuf		;Sektorspeicher löschen.

			lda	#$ff			;Ersten Verzeichnissektor löschen.
			sta	diskBlkBuf +$01
			lda	#$01
			sta	r1L
			lda	#$22
			sta	r1H
			LoadW	r4,diskBlkBuf
			jsr	PutBlock
			txa				;Diskettenfehler?
			bne	:58			;Ja, Abbruch...

			lda	#$ff			;Sektor $01/$ff löschen.
			sta	r1H			;Ist Borderblock für DeskTop 2.0!
;			LoadW	r4,diskBlkBuf
			jsr	PutBlock
::58			rts

;*** Sektorspeicher löschen.
:ClrDiskSekBuf		ldy	#$00
			tya
::1			sta	diskBlkBuf,y
			dey
			bne	:1
			rts

;*** Bytes $00-$BF für BAM-Block #1.
:BAM_NM_BLK1		b $01,$22,$48,$00
;--- Ergänzung: 06.01.19/M.Kanet
;Standardmäßig Diskname nur ab Byte $90 erstellen.
;Die Routine "-D3_SwapDkNmDat" tauscht 25Bytes aus.
;:DkNmBuffer		b "R","A","M","A"
;			b "N","a","t","i","v","e",$a0,$a0
;			b $a0,$a0,$a0,$a0,$a0,$a0,"R","D"
;			b $a0,"1","H",$a0,$a0,$a0,$a0,$00
:DkNmBuffer		b $00,$00,$00,$00
::08			b $00,$00,$00,$00,$00,$00,$00,$00
::10			b $00,$00,$00,$00,$00,$00,$00,$00
::18			b $00,$00,$00,$00,$00,$00,$00,$00
::20			b $01,$01,$00,$00,$00,$00,$00,$00
::28			b $00,$00,$00,$00,$00,$00,$00,$00
::30			b $00,$00,$00,$00,$00,$00,$00,$00
::38			b $00,$00,$00,$00,$00,$00,$00,$00
::40			b $00,$00,$00,$00,$00,$00,$00,$00
::48			b $00,$00,$00,$00,$00,$00,$00,$00
::50			b $00,$00,$00,$00,$00,$00,$00,$00
::58			b $00,$00,$00,$00,$00,$00,$00,$00
::60			b $00,$00,$00,$00,$00,$00,$00,$00
::68			b $00,$00,$00,$00,$00,$00,$00,$00
::70			b $00,$00,$00,$00,$00,$00,$00,$00
::78			b $00,$00,$00,$00,$00,$00,$00,$00
::80			b $00,$00,$00,$00,$00,$00,$00,$00
::88			b $00,$00,$00,$00,$00,$00,$00,$00
:RDrvNMDskName		b "R","A","M","A","N","a","t","i"
::98			b "v","e",$a0,$a0,$a0,$a0,$a0,$a0
::a0			b $a0,$a0,"R","D",$a0,"1","H",$a0
::a8			b $a0,$a0,$a0

;--- Ergänzung: 16.12.18/M.Kanet
;Standardmäßig keine GEOS-Diskette erzeugen.
if EN_GEOS_DISK = FALSE
:RDrvNMBorderTS		b $00,$00			;Kein BorderBlock.
::ad			b $00,$00,$00
::b0			b $00,$00,$00,$00,$00,$00,$00,$00
::b8			b $00,$00,$00,$00,$00,$00,$00,$00
endif
if EN_GEOS_DISK = TRUE
:RDrvNMBorderTS		b $01,$ff			;BorderBlock.
::ad			b "G","E","O"
::b0			b "S"," ","f","o","r","m","a","t"
::b8			b " ","V","1",".","0",$00,$00,$00
endif

;--- Bytes $00-$3F für BAM-Block #2.
:BAM_NM_BLK2		b $00,$00,$48,$b7,$52,$44,$c0,$00
:BAM_NM_SIZE		b $02,$00,$00,$00,$00,$00,$00,$00
::10			b $00,$00,$00,$00,$00,$00,$00,$00
::18			b $00,$00,$00,$00,$00,$00,$00,$00
::20			b $00,$00,$00,$00,$1f,$ff,$ff,$ff
::28			b $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
::30			b $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
::38			b $ff,$ff,$ff,$ff,$ff,$ff,$ff

;--- Ergänzung: 16.12.18/M.Kanet
;Standardmäßig keine GEOS-Diskette erzeugen.
;Bit#0 steht für Track $01/Sektor $ff
if EN_GEOS_DISK = FALSE
:RDrvNMBorderBAM	b %11111111
endif
if EN_GEOS_DISK = TRUE
:RDrvNMBorderBAM	b %11111110
endif

;*** Kennung für eine gültige GEOS-Diskette.
if EN_GEOS_DISK = TRUE
:DrvFormatCode		b "GEOS format "
endif
