; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** GEOS-Menü öffnen.
.OPEN_MENU_GEOS		lda	#GMNU_GEOS
			b $2c

;*** Fenster-Menü öffnen.
.OPEN_MENU_SCRN		lda	#GMNU_WIN		;Zeiger auf Menü-Daten setzen.

			pha
			jsr	WM_HIDEWIN_OFF		;"Fenster ausblenden" deaktivieren.
			pla

			jmp	LdDTopMod		;Menü nachladen.

;*** Farbe setzen und PullDown-Menü öffnen.
;    Übergabe: r0 = Zeiger auf Menüdaten.
.OPEN_MENU		jsr	DoneWithWM		;Fenster-Abfrage abschalten.

			ClrW	keyVector		;Tastaturabfrage löschen.

			jsr	MAIN_RESETAREA		;Textgrenzen löschen.
			jsr	sys_SvBackScrn		;Aktuellen Bildschirm speichern.

			jsr	OPEN_MENU_SETCOL	;Farbe für Menü setzen.

			lda	#$01
			jsr	DoMenu			;Menü aktivieren.

;*** Menü-Vektoren setzen.
.OPEN_MENU_INIT		LoadW	appMain,DrawClock
			LoadW	RecoverVector,:1	;Eigene RecoverRectangle-Routine.
			LoadW	mouseFaultVec,:2	;Eigene Mausabfrage setzen.
			rts

;--- Ersatz für RecoverRectangle.
::1			LoadW	r10,GD_BACKSCR_BUF
			LoadW	r11,GD_BACKCOL_BUF
			lda	GD_SYSDATA_BUF
			jmp	WM_LOAD_AREA

;--- Mausabfrage.
::2			lda	faultData		;Hat Mauszeiger aktuelles Menü
			and	#%00001000		;verlassen ?
			bne	:3			;Ja, ein Menü zurück.
			ldx	#%10000000
			ldy	#%11000000
::3			txa				;Hat Mauszeiger obere/linke
			and	faultData		;Grenze verlassen ?
			bne	:4			;Ja, ein Menü zurück.
			tya

::4			lda	menuNumber		;Hauptmenü aktiv ?
			beq	:5			;Ja, übergehen.
			jsr	OPEN_PREV_MENU		;Ein Menü zurück.
			jmp	OPEN_MENU_INIT

::5			jsr	RecoverAllMenus		;Menüs löschen.
			;jmp	CLOSE_MENU		;Vektoren zurücksetzen.

;*** Vektoren zurücksetzen.
.CLOSE_MENU		lda	#$00
			sta	mouseFaultVec +0	;Mausabfrage löschen.
			sta	mouseFaultVec +1
			sta	RecoverVector +0	;RecoverRectangle löschen.
			sta	RecoverVector +1

			lda	mouseOn			;Menü-Flag löschen.
			and	#%10111111
			sta	mouseOn

			jmp	InitWinMseKbd		;Fenster-/Maus-/Tastatur starten.

;*** Zeiger auf Menü-Initialisierung setzen.
;    Übergabe: XAKKU/XREG = Zeiger auf Menüdaten.
.MENU_SETINT		sta	r0L
			stx	r0H
.MENU_SETINT_r0		LoadW	appMain,OPEN_MENU_INIT
;			jmp	OPEN_MENU_SETCOL

;*** Hintergrundfarbe für Menü setzen.
:OPEN_MENU_SETCOL	ldy	#$05
::1			lda	(r0L),y			;Fenstergröße einlesen.
			sta	r2,y
			dey
			bpl	:1

			lda	C_PullDMenu		;Farbe für Menü setzen.
			jmp	DirectColor

;*** Erweiterung für ":DoPreviousMenu", damit auch Farben des
;    letzten Menüs richtig gesetzt werden.
:OPEN_PREV_MENU		lda	Rectangle +1		;Rectangel-Routine von
			sta	:2 +1			;GEOS auf eigene Routine umbiegen.
			lda	Rectangle +2
			sta	:3 +1

			lda	#< :1
			sta	Rectangle +1
			lda	#> :1
			sta	Rectangle +2

			jmp	DoPreviousMenu		;Vorheriges Menü aufrufen.

::1			lda	C_PullDMenu		;Farbe für Menü setzen.
			jsr	DirectColor

::2			lda	#$ff			;Original-Rectangle-Routine im
			sta	Rectangle +1		;GEOS-Kernal wieder installieren.
::3			ldx	#$ff
			stx	Rectangle +2
			jmp	CallRoutine		;Rectangle aufrufen.

;*** GEOS-Menü beenden.
.EXIT_MENU_GEOS		jsr	RecoverAllMenus		;Menüs löschen.
			jsr	CLOSE_MENU		;Vektoren zurücksetzen.
			jmp	UPDATE_GD_CORE		;Variablen sichern.

;*** Größe für Menü berechnen.
;Übergabe: r0  = Zeiger auf Menü-Tabelle.
;          r5L = Breite.
;
;Hinweis: Das Menü wird dabei auf
;ganze CARDs ab-/aufgerundet um die
;Farb-CARDs am C64 nutzen zu können.
.MENU_SET_SIZE		ldy	#$06			;Anzahl Menü-Einträge einlesen.
			lda	(r0L),y
			and	#%00001111

			tay				;Höhe für Menü berechnen.
			lda	#$02
::1			clc
			adc	#14
			dey
			bne	:1

			ora	#%00000111		;Untere Kante auf volle CARDs
			sta	r5L			;aufrunden.

			lda	#MAX_AREA_WIN_Y -1
			sec
			sbc	r5L
			cmp	mouseYPos		;Y-Position für Menü ermitteln.
			bcc	:4			;Standard = Mausposition. Wenn
			lda	mouseYPos		;Menü ausserhalb Bildschirm, dann
							;Y-Position korrigieren.
::4			and	#%11111000		;Obere Kante auf ganze CARDs
			sta	r2L			;abrunden.
			clc
			adc	r5L
			sta	r2H

			sec				;X-Position für Menü ermitteln.
			lda	#< MAX_AREA_WIN_X -1
			sbc	r5H
			sta	r3L
			lda	#> MAX_AREA_WIN_X -1
			sbc	#$00
			sta	r3H

			CmpW	r3,mouseXPos		;Standard = Mausposition. Wenn
			bcc	:5			;Menü ausserhalb Bildschirm, dann
			MoveW	mouseXPos,r3		;X-Position korrigieren.

::5			clc				;Linke Kante auf volle CARDS
			lda	r3L			;abrunden, rechte Kante auf volle
			and	#%11111000		;CARDs aufrunden.
			sta	r3L
			adc	r5H
			sta	r4L
			lda	r3H
			adc	#$00
			sta	r4H

			ldy	#$05			;Größe für Menü in
::6			lda	r2,y			;Menüdaten kopieren.
			sta	(r0L),y
			dey
			bpl	:6
			rts

;*** PopUp-Menü beenden.
.EXIT_POPUP_MENU	php
			sei
			clc
			jsr	StartMouseMode
			cli

;--- Hinweis:
;Warten bis Maustaste nicht mehr
;gedrückt. Führt sonst zu Problemen
;bei der Tastaturabfrage.
			jsr	waitNoMseKey		;Warten bis keine M-Taste gedrückt.

			plp

			jsr	RecoverAllMenus		;Menüs löschen.
			jsr	CLOSE_MENU		;Vektoren zurücksetzen.
			jmp	UPDATE_GD_CORE		;Variablen sichern.

;*** PopUp-Fenster für DeskTop-Eigenschaften.
:PM_PROPERTIES		jsr	WM_HIDEWIN_OFF		;"Fenster ausblenden" deaktivieren.

			jsr	AL_FIND_ICON		;AppLink-Icons suchen.
			txa				;Wurde AppLink angeklickt?
			bne	:dtop			; => Nein, weiter...

;--- Rechter Mausklick auf AppLink.
::alink			MoveB	r13H,AL_CNT_FILE
			MoveW	r14 ,AL_VEC_FILE
			MoveW	r15 ,AL_VEC_ICON

			lda	#GMNU_ALINK		;Zeiger auf AppLink-Menü setzen.
			b $2c

;--- Rechter Mausklick auf DeskTop.
::dtop			lda	#GMNU_DTOP		;Zeiger auf DeskTop-Menü setzen.
			jmp	LdDTopMod		;Menü nachladen.

;*** PopUp-Fenster für Datei-Eigenschaften.
:PM_FILE		lda	#$00
			sta	drvUpdFlag		;Fenster nicht aktualisieren.
			sta	drvUpdSDir +0		;Kein neues Verzeichnis setzen.
			sta	drvUpdSDir +1
			sta	drvUpdMode		;Laufwerksmodus nicht ändern.

			lda	WM_DATA_MAXENTRY +0
			sta	fileEntryCount +0	;Max.Dateianzahl zwischenspeichern.
if MAXENTRY16BIT = TRUE
			lda	WM_DATA_MAXENTRY +1
			sta	fileEntryCount +1
endif

			lda	WM_TITEL_STATUS		;Rechtsklick/Titel angeklickt?
			bne	:title			; => Ja, weiter...

;--- Mausklick auf Fensterinhalt.
::window		ldx	WM_WCODE		;Fenster-Nummer einlesen.
			lda	WIN_DATAMODE,x		;Partitionsauswahl aktiv?
			bne	:drive			; => Ja, weiter...

			jsr	WM_TEST_ENTRY		;Icon angeklickt?
			bcc	:drive			; => Nein, weiter...

;--- Rechter Mausklick auf Datei-Icon.
::file			stx	fileEntryPos +0		;Eintrag-Nr. zwischenspeichern.
if MAXENTRY16BIT = TRUE
			sty	fileEntryPos +1
endif

			stx	r0L			;Eintrag-Nr. für Berechnung
if MAXENTRY16BIT = TRUE
			sty	r0H			;Adresse zwischenspeichern.
endif

			ldx	#r0L			;Zeiger auf Dateieintrag
			jsr	WM_SETVEC_ENTRY		;berechnen.

			ldy	#$02
			lda	(r0L),y			;Dateityp-Byte einlesen.
			cmp	#GD_MORE_FILES		;"Weitere Dateien"?
			beq	:exit			; => Ja, Ende...

;			PushW	r0			;Zeiger auf aktuelle Datei sichern.
			MoveW	r0,fileEntryVec

			jsr	FILE_r14_SLCT		;Aktuelle Datei unter Mauszeiger
							;im Speicher und am Bildschirm
							;auswählen (":r0" nicht verändern!)

			jsr	SET_POS_CACHE		;Zeiger auf Datei im Cache.

			MoveW	r14,r1			;Cache aktualisieren.
			LoadW	r2,32
			lda	r12H
			sta	r3L
			jsr	StashRAM

;			PopW	fileEntryVec		;Zeiger auf Datei zurücksetzen.

;--- Datei-Menü anzeigen.
			lda	#GMNU_FILE
			b $2c

;--- Disk-/Partitions-Menü anzeigen.
::drive			lda	#GMNU_DISK
			b $2c

;--- Rechter Mausklkick auf Titelzeile.
::title			lda	#GMNU_TITLE
			jmp	LdDTopMod

;--- Mausklick ignorieren.
::exit			rts

;*** Rechter Mausklick auf Arbeitsplatz.
:PM_MYCOMP		jsr	WM_TEST_ENTRY		;Eintrag angeklickt?
			bcc	:exit			; => Nein, Ende...

			stx	MyCompEntry +0
if MAXENTRY16BIT = TRUE
			sty	MyCompEntry +1
endif

			jsr	WM_HIDEWIN_OFF		;"Fenster ausblenden" deaktivieren.

			lda	#GMNU_MYCOMP		;Zeiger auf Menü-Daten setzen.
			jmp	LdDTopMod		;Menü nachladen.

::exit			rts
