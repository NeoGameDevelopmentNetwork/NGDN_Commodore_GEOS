; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;******************************************************************************
;Routine:   SetFileSlctMode
;Parameter: AKKU= Auswahlmodus:
;                 $00 -> Nicht ausgewählt.
;                 $FF -> Ausgewählt.
;Rückgabe:  -
;Verändert: A,X,Y,r10L,r11,r12
;Funktion:  Auswahlflag für alle Dateien setzen/löschen.
;******************************************************************************
:SetFileSlctMode	sta	r10L			;Markierungsmodus merken.

			lda	WM_DATA_MAXENTRY +0
if MAXENTRY16BIT = TRUE
			ora	WM_DATA_MAXENTRY +1
endif
			beq	:exit			; => Dateien vorhanden, weiter.

			LoadW	r12,BASE_DIRDATA	;Zeiger auf Verzeichnisdaten.

			lda	WM_DATA_MAXENTRY +0
			sta	r11L
if MAXENTRY16BIT = TRUE
			lda	WM_DATA_MAXENTRY +1
			sta	r11H			;Dateizähler initialisieren.
endif

::loop			ldy	#$02
			lda	(r12L),y		;Dateityp-Byte einlesen.
			cmp	#GD_MORE_FILES		;"Weitere Dateien"?
			beq	:next			; => Ja, Ende...

			ldy	#$00
			lda	r10L			;Markierungsmodus in Speicher
			sta	(r12L),y		;schreiben.

::next			AddVBW	32,r12			;Zeiger auf nächsten Eintrag/Cache.

if MAXENTRY16BIT = TRUE
			lda	r11L			;Zähler Dateien -1.
			bne	:1
			dec	r11H
endif
::1			dec	r11L

if MAXENTRY16BIT = TRUE
			lda	r11L
			ora	r11H			;Alle Dateien bearbeitet?
endif
			bne	:loop			; => Nein, weiter...

::exit			rts
