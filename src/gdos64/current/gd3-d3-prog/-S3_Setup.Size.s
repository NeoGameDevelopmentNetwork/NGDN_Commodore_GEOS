; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Größe der entpackten Dateien berechnen für "teilw. Installation".
:CalcGroupSize		lda	#$00
			sta	PatchSizeKB +0
			sta	PatchSizeKB +1

			lda	#1
			sta	ExtractFileType

;--- Berechnung initialisieren.
::loop			jsr	SetVecTopArchiv		;Zeiger auf Tabelle mit Dateinamen.

			lda	#$00			;Größe für aktuelle Gruppe löschen.
			sta	r13L
			sta	r13H

;--- Dateigrößen für aktuelle Gruppe addieren.
::51			lda	EntryPosInArchiv
			asl
			tax
			lda	ExtractFileType		;Entspricht Datei gewünschter
			cmp	FileModeTab +0,x	;Dateigruppe ?
			bne	:52			; => Nein, weiter...

;--- Speicher für Gruppe anpassen.
			ldy	#30			;Dateigröße addieren.
			lda	(a7L),y
			clc
			adc	r13L
			sta	r13L
			iny
			lda	(a7L),y
			adc	r13H
			sta	r13H

;--- Min. benötigten Speicher anpassen.
			lda	FileModeTab +1,x	;Erforderliche Systemdatei ?
			bne	:52			; => Nein, weiter...

			ldy	#30			;Dateigröße addieren.
			lda	(a7L),y
			clc
			adc	PatchSizeKB +0
			sta	PatchSizeKB +0
			iny
			lda	(a7L),y
			adc	PatchSizeKB +1
			sta	PatchSizeKB +1

::52			jsr	SetVecNxEntry		;Alle Dateien addiert ?
			bne	:51			; => Nein, weiter...

;--- Benötigten Speicher für Gruppe in Tabelle kopieren.
			lda	ExtractFileType
			asl
			tay
			lda	r13L			;Benötigten Speicherplatz für Gruppe
			sta	PatchSizeKB +0,y	;in Tabelle ablegen.
			lda	r13H
			sta	PatchSizeKB +1,y

;--- Max. benötigten Speicher berechnen.
			lda	r13L			;Speicherplatz für alle Gruppen
			clc				;addieren.
			adc	PatchSizeMax +0
			sta	PatchSizeMax +0
			lda	r13H
			adc	PatchSizeMax +1
			sta	PatchSizeMax +1

;--- Weiter mit nächster Gruppe.
			inc	ExtractFileType
			lda	ExtractFileType
			cmp	#5 +1 			;Alle Gruppen addiert?
			bcs	:done			; => Ja, Ende...
			jmp	:loop			;Weiter mit nächster Gruppe...

;--- Speicher berechnet, Ende.
::done			rts
