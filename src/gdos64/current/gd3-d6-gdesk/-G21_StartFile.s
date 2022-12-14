; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Anwendung starten auf die ":r0" zeigt.
;    Übergabe: r0 = Zeiger auf 32Byte Verzeichnis-Eintrag.
;        Oder:      Zeiger auf dirEntryBuf -2.
;
;    Hinweis:
;:r0 als Quelle und :a0 als Ziel da die
;Register :r0-:r15 durch UPDATE_GD_CORE und
;VLIR-Routinen verändert werden können.
;
:StartFile_r0		MoveW	r0,a0			;Zeiger auf Eintrag nach :a0.
			jsr	UPDATE_GD_CORE		;Variablen sichern.
			jmp	MOD_OPEN_FILE		;VLIR-Modul "StartFile" aufrufen.

;*** Anwendung/Dokument/DA öffnen.
;    Übergabe: r0 = Zeiger auf 32Byte Verzeichnis-Eintrag.
;        Oder:      Zeiger auf dirEntryBuf -2.
:OpenFile_r0		ldy	#$02
			lda	(r0L),y
			and	#ST_FMODES		;Dateityp isolieren.
			cmp	#DIR			;Verzeichnis?
			beq	:3			; => Ja, weiter...

			jsr	CheckFType		;Dateityp auswerten.
			cpx	#NO_ERROR		;Starten möglich?
			beq	:1			; => Ja, weiter...
			cmp	#SYSTEM			;System-Datei?
			beq	:2			; => Ja, weiter... (GeoDesk-Farben?)
			rts

;--- Datei öffnen.
::1			cmp	#PRINTER		;Drucker?
			beq	:4			; => Ja, weiter...
::2			jmp	StartFile_r0		;Datei/Dokument öffnen.

;--- Verzeichnis öffnen.
::3			iny				;Track/Sektor für
			lda	(r0L),y			;Verzeichnis-Header einlesen.
			sta	r1L
			ldx	WM_WCODE
			sta	WIN_SDIR_T,x
			iny
			lda	(r0L),y
			sta	r1H
			sta	WIN_SDIR_S,x
			jsr	OpenSubDir		;Verzeichnis öffnen.

			lda	#$00			;Zeiger auf ersten Eintrag.
			sta	WM_DATA_CURENTRY +0
if MAXENTRY16BIT = TRUE
			sta	WM_DATA_CURENTRY +1
endif

			jsr	WM_SAVE_WIN_DATA	;Fensterdaten speichern.

			jsr	SET_LOAD_DISK		;Dateien von Disk neu einlesen.
			jmp	WM_CALL_DRAW		;Fenster neu laden.

;--- Drucker öffnen.
::4			LoadW	r6,dataFileName		;Zeiger auf Druckername.
			ldx	#r0L 			;Dateiname aus Verzeichnis-Eintrag
			ldy	#r6L			;in Puffer kopieren.
			jsr	SysCopyFName

;--- Hinweis:
;FensterManager speichern, da beim
;laden des Druckertreibers Teile des
;FensterManagers überschrieben werden.
			jsr	BACKUP_WMCORE		;FensterManager sichern.

			jsr	SUB_OPEN_PRNT		;Druckertreiber wechseln.

;--- Hinweis:
;WM nachladen, da der Druckertreiber
;beim laden Teile des WM überschreibt!
			jsr	MOD_WM
			jsr	SUB_SYSINFO		;Statuszeile aktualisieren.

;--- Hinweis
;Arbeitsplatz aktualisieren.
; -Oberstes Fenster zwischenspeichern
; -Arbeitsplatz aktualisieren
; -Oberstes Fenster wieder aktivieren
;
;Damit wird sichergestellt, das die
;Drucker im Arbeitsplatz-Fenster
;aktuell sind und das Fenster mit dem
;Druckertreiber weiterhin aktiv ist.
			ldx	WM_MYCOMP		;Fenster "MyComputer" geöffnet?
			beq	:exit			; => Nein, Ende...

			lda	WM_WCODE		;Aktuelles Fenster einlesen und
			pha				;zwischenspeichern.

			stx	WM_WCODE		;Fenster "MyComputer" aktualisieren.
			jsr	WM_CALL_DRAW

			pla
			sta	WM_WCODE		;Fenster-Nr. zurücksetzen.
			jsr	WM_LOAD_WIN_DATA	;Fensterdaten einlesen.

			jsr	OpenWinDrive		;Fensterlaufwerk öffnen.

			jsr	WM_LOAD_SCREEN		;Fenster aus ScreenBuffer laden.

::exit			rts

;*** Auf gültigen GEOS-Dateityp testen.
;    Übergabe: r0 = Zeiger auf 32Byte Verzeichnis-Eintrag.
;        Oder:      Zeiger auf dirEntryBuf -2.
;    Rückgabe: XReg = $00/Datei gültig oder #INCOMPATIBLE.
:CheckFType		ldx	#NO_ERROR

			ldy	#$18			;Dateityp auswerten.
			lda	(r0L),y
			beq	:exit			; => BASIC-Programm.
			cmp	#APPLICATION		;Anwendung?
			beq	:exit			; => Ja, weiter...
			cmp	#AUTO_EXEC		;AutoExec?
			beq	:exit			; => Ja, weiter...
			cmp	#APPL_DATA		;Dokument?
			beq	:exit			; => Ja, weiter...
			cmp	#DESK_ACC		;Hilfsmittel?
			beq	:exit			; => Ja, weiter...
			cmp	#PRINTER		;Drucker?
			beq	:exit			; => Ja, weiter...

			cmp	#DISK_DEVICE		;Laufwerkstreiber ?
			bne	:bad			; => Nein, Ende...

;--- Hinweis:
;Damit GeoDesk Dateien vom Typ
;"Laufwerkstreiber" starten kann, muss
;der GEOS-Dateityp überprüft werden.
			lda	r0L			;Zeiger auf Dateieintrag
			pha				;zwischenspeichern und für
			clc				;":GetFHdrInfo" korrigieren.
			adc	#<$0002
			sta	r9L
			lda	r0H
			pha
			adc	#>$0002
			sta	r9H

			jsr	GetFHdrInfo		;Infoblock einlesen.

			pla				;Zeiger auf Dateieintrag
			sta	r0H			;zurücksetzen.
			pla
			sta	r0L

			txa				;Fehler ?
			bne	:bad			; => Ja, Abbruch...

;--- Hinweis:
;GEOS-Klasse überprüfen. Damit hier
;Laufwerkstreiber gestartet werden
;können, muss die Klasse für GDOS64
;übereinstimmen.
			ldy	#0
::1			lda	:diskDrvClass,y
			bne	:2

			lda	fileHeader +$4d,y
			beq	:exit
			bne	:bad

::2			cmp	fileHeader +$4d,y
			bne	:bad

			iny
			cpy	#16			;"GD.DISKDEV  Vx.y"
			bcc	:1
			bcs	:exit

::bad			ldx	#INCOMPATIBLE		;Unbekannt, Ende...
::exit			rts

;--- GEOS-Klasse Laufwerkstreiber.
::diskDrvClass		t "opt.DDrv.Build"
