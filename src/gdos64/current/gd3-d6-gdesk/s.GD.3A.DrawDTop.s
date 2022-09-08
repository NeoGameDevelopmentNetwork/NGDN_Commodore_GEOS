; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;--- Modul-Information:
;* Desktop/Applinks zeichnen.

;*** Symboltabellen.
if .p
			t "opt.GDOSl10n.ext"
			t "SymbTab_GDOS"
			t "SymbTab_GEXT"
			t "SymbTab_1"
			t "SymbTab_GTYP"
			t "SymbTab_DTYP"
			t "MacTab"

;--- Labels für GeoDesk64.
			t "TopSym.GD"

;--- Externe Labels.
			t "s.GD.10.Core.ext"
			t "s.GD.20.WM.ext"
			t "s.GD.21.Desk.ext"

;--- AppLink-Definition.
			t "e.GD.10.AppLink"
endif

;*** GEOS-Header.
			n "obj.GD3A"
			f DATA

			o BASE_GDMENU

;*** Sprungtabelle.
;:MAININIT		jmp	DrawDeskTop

;*** Desktop zeichnen.
:DrawDeskTop		bit	r10L			;Desktop neu zeichnen?
			bmi	:1			; => Nein, Update...
			bvs	:updappl		; => Fenster-Modus ignorieren.

			bit	GD_HIDEWIN_MODE		;Fenster ausgeblendet?
			bpl	:redraw			; => Nein, neu zeichnen.

::1			jsr	WM_DRAW_BACKSCR		;Desktop zeichen,
			jsr	DrawFullClock		;Uhrzeit aktualisieren und
			jmp	:update			;Fenster aus ScreenBuffer laden.

::redraw		lda	#$00			;Alle Fenster anzeigen.
			sta	GD_HIDEWIN_MODE

::updappl		jsr	WM_CLEAR_SCREEN		;Bildschirm löschen.

			jsr	InitTaskBar		;TaskBar darstellen.

			jsr	SUB_SYSINFO		;Systeminfo anzeigen.

::update		jsr	DrawAppLinks		;AppLinks zeichnen.

			jsr	InitWinMseKbd		;Fenster-/Maus-/Tastatur starten.

			lda	#$00			;DeskTop als aktives Fenster setzen.
			sta	WM_WCODE

			jmp	WM_SAVE_SCREEN		;Bildschirminhalt speichern.

;*** AppLinks auf DeskTop ausgeben.
:DrawAppLinks		jsr	ResetFontGD		;GeoDesk-Font aktivieren.

			jsr	initALDataVec		;AppLink-Register initialisieren.

::1			jsr	MAIN_RESETAREA		;Fenstergrenzen löschen.

			jsr	getALIconSize		;Position/Größe für Icon.

			lda	#$00			;Bildschirm-Bereich für
			jsr	SetPattern		;Icon löschen.
			jsr	Rectangle

			bit	GD_LNK_TITLE		;AppLink-Titel anzeigen?
			bpl	:2			; => Nein, weiter...

			PushB	r2L			;Position/Größe für Icon speichern.
			PushB	r2H
			PushW	r3
			PushW	r4

			ldx	r2H			;Position/Größe für Titel
			inx				;berechnen.
			stx	r2L
			txa
			clc
			adc	#$07
			sta	r2H
			SubVW	16,r3
			AddVBW	16,r4
			MoveW	r3,leftMargin
			MoveW	r4,rightMargin

			lda	#$00			;Bildschirm-Bereich für
			jsr	SetPattern		;AppLink-Titel löschen.
			jsr	Rectangle
			lda	C_GDesk_ALTitle		;Farben für AppLink-Titel auf
			jsr	DirectColor		;Bildschirm löschen.

			PopW	r4			;Position/Größe für Icon wieder
			PopW	r3			;herstellen.
			PopB	r2H
			PopB	r2L

::2			lda	r15L			;Zeiger auf Speicher für
			sta	r0L			;AppLink-Icon.
			lda	r15H
			sta	r0H

			jsr	WM_CONVERT_PIXEL	;Koordinate von Pixel nach CARDs.

			LoadB	r2L,3			;Breite Icon in CARDs.
			LoadB	r2H,21			;Höhe Icon in Pixel.
;			LoadB	r3L,$00			;Farbe für Icon.
			LoadB	r3H,5			;Delta-Y für Titel.

;--- Farbe für Icon definieren.
			ldy	#LINK_DATA_TYPE		;AppLink-Typ einlesen.
			lda	(r14L),y
;			cmp	#AL_TYPE_FILE		;Datei-Icon/Anwendung?
			beq	:9			; => Ja, weiter...

			cmp	#AL_TYPE_MYCOMP		;Arbeitsplatz-Icon?
			beq	:7			; => Ja, weiter...

;--- Laufwerk/Drucker/Verzeichnis.
			lda	r14L			;Zeiger auf Farbtabelle in
			clc				;AppLink-Daten berechnen.
			adc	#< LINK_DATA_COLOR
			sta	r8L
			lda	r14H
			adc	#> LINK_DATA_COLOR
			sta	r8H

			lda	#$00			;Farbe über AppLink setzen.
			beq	:8

;--- Arbeitsplatz-Icon.
::7			lda	C_GDesk_MyComp		;Farbe aus Systemvorgaben setzen.
			jmp	:8

;--- Datei-Icon.
::9			lda	C_GDesk_ALIcon		;Farbe aus Systemvorgaben setzen.

;--- Allgemein: Farbmodus festlegen.
::8			sta	r3L			;Typ der AppLink-Farbe definieren.

			lda	r14L			;Zeiger auf Titel in
			clc				;AppLink-Daten berechnen.
			adc	#17
			sta	r4L
			lda	r14H
			adc	#$00
			sta	r4H

			PushB	r1L			;Position für Icon speichern.
			PushB	r1H

			bit	GD_LNK_TITLE		;AppLink-Titel anzeigen?
			bpl	:3			; => Nein, weiter...

			jsr	GD_FICON_NAME		;Icon und Titel ausgeben.
			jmp	:4

::3			jsr	GD_DRAW_FICON		;Nur Icon ausgeben.

::4			PopB	r1H			;Position für Icon zurücksetzen.
			PopB	r11L

			ldy	#LINK_DATA_TYPE
			lda	(r14L),y		;AppLink-Typ einlesen.
			cmp	#AL_TYPE_DRIVE		;Laufwerk?
			bne	:5			; => Nein, weiter...

			ldy	#LINK_DATA_DRIVE	;Laufwerksbuchstabe auf
			lda	(r14L),y		;AppLink-Icon schreiben.
			sec
			sbc	#$08
			jsr	PrntGeosDrvName		;Laufwerk A: bis D: ausgeben.

::5			jsr	setVecNxALEntry		;Zeiger auf nächste AppLink-Daten.

			dec	AL_CNT_ENTRY		;Alle AppLinks ausgegeben?
			beq	:6			; => Ja, Ende...
			jmp	:1			; => Nein, weiter...
::6			rts

;******************************************************************************
;Sicherstellen das genügend Speicher
;für Desktop-Daten verfügbar ist.
			g BASE_GDMENU +SIZE_GDMENU -1
;******************************************************************************
