; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;--- Modul-Information:
;* Dateifenster/Titel-Menü.

;*** Symboltabellen.
if .p
			t "opt.GDOSl10n.ext"
			t "SymbTab_GDOS"
			t "SymbTab_1"
			t "SymbTab_GTYP"
			t "SymbTab_DTYP"
			t "SymbTab_APPS"
			t "SymbTab_CHAR"
			t "MacTab"

;--- Labels für GeoDesk64.
			t "TopSym.GD"

;--- Externe Labels.
			t "s.GD.10.Core.ext"
			t "s.GD.20.WM.ext"
			t "s.GD.21.Desk.ext"
endif

;*** GEOS-Header.
			n "obj.GD37"
			f DATA

			o BASE_GDMENU

;*** Sprungtabelle.
;:MAININIT		jmp	OpenMenu_Title

;*** PopUp/Titelzeile.
:OpenMenu_Title		lda	MP3_64K_DISK		;Laufwerkstreiber im RAM?
			bne	:init			; => Ja, weiter...

			lda	#ITALICON		;Wechsel des Laufwerksmodus
			sta	txDrvMode		;deaktivieren.

;--- Menü initialisieren.
::init			ldx	#GMOD_CMDPART
			ldy	GD_DACC_ADDR_B,x	;CMD-Partitionen installiert?
			bne	:0			; => Ja, weiter...

			lda	#ITALICON		;CMD-Partitionen-Menü
			sta	txPartName		;deaktivieren.

::0			ldx	WM_WCODE
			ldy	WIN_DRIVE,x		;Laufwerksadresse einlesen.
			beq	:exit			; => Kein Laufwerk, Ende...

;--- Partitions-/DiskImage-Modus.
			lda	WIN_DATAMODE,x		;CMD-/DiskImage-Browser aktiv?
			bmi	:CMD			; => CMD, Modus wechseln.
			bne	:SD2IEC			; => SD2IEC, DiskImage-Menü.

;--- Dateimodus.
;			ldx	WM_WCODE
;			ldy	WIN_DRIVE,x		;Laufwerksadresse einlesen.
			lda	RealDrvMode -8,y	;CMD/SD2IEC/Native ?
			and	#SET_MODE_PARTITION!SET_MODE_SD2IEC!SET_MODE_SUBDIR
			beq	:exit			; => Nein, Ende...

			cmp	#SET_MODE_PARTITION
			beq	:478CMD			; => CMD 41/71/81.
			cmp	#SET_MODE_SD2IEC
			beq	:478SD2IEC		; => SD2IEC 41/71/81.

			cmp	#SET_MODE_PARTITION!SET_MODE_SUBDIR
			beq	:NativeCMD		; => CMD Native.
			cmp	#SET_MODE_SD2IEC!SET_MODE_SUBDIR
			beq	:NativeSD2IEC		; => SD2IEC Native.

			cmp	#SET_MODE_SUBDIR
			beq	:NativeRAM		; => RAM Native.

;--- Rechter Maisklick auf Titel nicht möglich.
::exit			rts

::CMD			jmp	execCMD			;CMD/Browser.
::SD2IEC		jmp	execSD2IEC		;SD/Browser.
::NativeRAM		jmp	execNativeRAM		;RAM-Laufwerk.
::NativeCMD		jmp	execNativeCMD		;Native/CMD.
::NativeSD2IEC		jmp	execNativeSD2IEC	;Native/SD2IEC.
::478CMD		jmp	exec478CMD		;417181/CMD.
::478SD2IEC		jmp	exec478SD2IEC		;417181/SD2IEC.

;*** CMD/Browser.
:execCMD		lda	MP3_64K_DISK		;"Treiber-in-RAM" aktiv ?
			beq	:skipmenu		; => Nein, kein Menü anzeigen.

			LoadW	r0,menuCMD
			LoadB	r5H,widthCMD
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

::skipmenu		lda	#< MOD_CMDPART		;Direkt zu "Partition umbenennen".
			ldx	#> MOD_CMDPART
			bne	execSkipMenu

;*** SD2IEC/Browser.
:execSD2IEC		LoadW	r0,menuSD2IEC
			LoadB	r5H,widthSD2IEC
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

;*** Native/RAM.
:execNativeRAM		LoadW	r0,menuNativeRAM
			LoadB	r5H,widthNativeRAM
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

;*** Native/CMD.
:execNativeCMD		LoadW	r0,menuNativeCMD
			LoadB	r5H,widthNativeCMD
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

;*** Native/SD2IEC.
:execNativeSD2IEC	LoadW	r0,menuNativeSD
			LoadB	r5H,widthNativeSD
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

;*** CMD-41/71/81-Laufwerk.
:exec478CMD		LoadW	r0,menu478CMD
			LoadB	r5H,width478CMD
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

;*** SD2IEC-41/71/81-Laufwerk.
:exec478SD2IEC		lda	MP3_64K_DISK		;"Treiber-in-RAM" aktiv ?
			beq	:skipmenu		; => Nein, kein Menü anzeigen.

			LoadW	r0,menu478SD
			LoadB	r5H,width478SD
			jsr	MENU_SET_SIZE
			jmp	OPEN_MENU

::skipmenu		lda	#< PF_SWAP_DSKIMG	;Direkt zu "DiskImage wechseln".
			ldx	#> PF_SWAP_DSKIMG
;			bne	execSkipMenu

;--- Hinweis:
;":OPEN_MENU" und ":EXIT_POPUP_MENU"
;führen zusätzliche Routinen aus.
;Wird ein externes Modul direkt ohne
;Menü aufgerufen, dann müssen diese
;Routinen manuell aufgerufen werden!
:execSkipMenu		pha				;Ziel-Routine zwischenspeichern.
			txa
			pha

			php				;Mausabfrage starten.
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

			jsr	sys_SvBackScrn		;Bildschirm zwischenspeichern.
			jsr	UPDATE_GD_CORE		;Variablen sichern.

			pla
			tax
			pla
			jmp	CallRoutine		;Ziel-Routine aufrufen.

;** Menü-Texte.
if LANG = LANG_DE
:txDrvMode		b PLAINTEXT
			b "Laufwerksmodus",NULL
:txSwapPart		b PLAINTEXT
			b "Partition wechseln",NULL
:txPartName		b PLAINTEXT
			b "Partition umbenennen",NULL
:txDirRoot		b PLAINTEXT
			b "Hauptverzeichnis",NULL
:txDirUp		b "Verzeichnis zurück",NULL
:txMakeDir		b "Verzeichnis erstellen",NULL
:txMakeDImg		b "DiskImage erstellen",NULL
endif

if LANG = LANG_EN
:txDrvMode		b PLAINTEXT
			b "Drive mode",NULL
:txSwapPart		b PLAINTEXT
			b "Switch partition",NULL
:txPartName		b PLAINTEXT
			b "Rename partition",NULL
:txDirRoot		b PLAINTEXT
			b "Root directory",NULL
:txDirUp		b "Parent directory",NULL
:txMakeDir		b "Create directory",NULL
:txMakeDImg		b "Create DiskImage",NULL
endif

;*** Menü-Routinen.
:jobDrvMode		jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_SWAP_DRVMODE		;Laufwerksmodus wechseln.

:jobSwapPart		jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_SWAP_DSKIMG		;Partition wechseln.

:jobPartName		jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	MOD_CMDPART		;Partition umbenennen.

:jobDirRoot		jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_OPEN_ROOT		;Hauptverzeichnis.

:jobDirUp		jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_OPEN_PARENT		;Ein Verzeichnis zurück.

:jobMakeDir		jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_CREATE_DIR		;Verzeichnis erstellen.

:jobMakeDImg		jsr	EXIT_POPUP_MENU		;PopUp-Menü beenden.
			jmp	PF_CREATE_IMG		;DiskImage erstellen.

;*** PopUp/Titelzeile CMD/Browser.
if LANG = LANG_DE
:widthCMD = $67
endif
if LANG = LANG_EN
:widthCMD = $57
endif

:menuCMD		b $00,$00
			w $0000,$0000

			b 2!VERTICAL

::_07			w txDrvMode			;Laufwerksmodus wechseln.
			b MENU_ACTION
			w jobDrvMode

::_12			w txPartName			;Partition umbenennen.
			b MENU_ACTION
			w jobPartName

;*** PopUp/Titelzeile SD2IEC/Browser.
if LANG = LANG_DE
:widthSD2IEC = $5f
endif
if LANG = LANG_EN
:widthSD2IEC = $57
endif

:menuSD2IEC		b $00,$00
			w $0000,$0000

			b 4!VERTICAL

::_07			w txDrvMode			;Laufwerksmodus wechseln.
			b MENU_ACTION
			w jobDrvMode

::_12			w txDirRoot			;Hauptverzeichnis.
			b MENU_ACTION
			w jobDirRoot

::_17			w txDirUp			;Ein Verzeichnis zurück.
			b MENU_ACTION
			w jobDirUp

::_22			w txMakeDImg			;DiskIamge erstellen.
			b MENU_ACTION
			w jobMakeDImg

;*** PopUp/Titelzeile Native/RAM.
if LANG = LANG_DE
:widthNativeRAM = $67
endif
if LANG = LANG_EN
:widthNativeRAM = $57
endif

:menuNativeRAM		b $00,$00
			w $0000,$0000

			b 3!VERTICAL

::_07			w txDirRoot			;Hauptverzeichnis.
			b MENU_ACTION
			w jobDirRoot

::_12			w txDirUp			;Ein Verzeichnis zurück.
			b MENU_ACTION
			w jobDirUp

::_17			w txMakeDir			;Verzeichnis erstellen.
			b MENU_ACTION
			w jobMakeDir

;*** PopUp/Titelzeile CMD/Native.
if LANG = LANG_DE
:widthNativeCMD = $67
endif
if LANG = LANG_EN
:widthNativeCMD = $57
endif

:menuNativeCMD		b $00,$00
			w $0000,$0000

			b 6!VERTICAL

::_07			w txDrvMode			;Laufwerksmodus wechseln.
			b MENU_ACTION
			w jobDrvMode

::_12			w txDirRoot			;Hauptverzeichnis.
			b MENU_ACTION
			w jobDirRoot

::_17			w txDirUp			;Ein Verzeichnis zurück.
			b MENU_ACTION
			w jobDirUp

::_22			w txMakeDir			;Verzeichnis erstellen.
			b MENU_ACTION
			w jobMakeDir

::_27			w txSwapPart			;Partition wechseln.
			b MENU_ACTION
			w jobSwapPart

::_32			w txPartName			;Partition umbenennen.
			b MENU_ACTION
			w jobPartName

;*** PopUp/Titelzeile SD2IEC/Native.
if LANG = LANG_DE
:widthNativeSD = $67
endif
if LANG = LANG_EN
:widthNativeSD = $57
endif

:menuNativeSD		b $00,$00
			w $0000,$0000

			b 5!VERTICAL

::_07			w txDrvMode			;Laufwerksmodus wechseln.
			b MENU_ACTION
			w jobDrvMode

::_12			w txDirRoot			;Hauptverzeichnis.
			b MENU_ACTION
			w jobDirRoot

::_17			w txDirUp			;Ein Verzeichnis zurück.
			b MENU_ACTION
			w jobDirUp

::_22			w txMakeDir			;Verzeichnis erstellen.
			b MENU_ACTION
			w jobMakeDir

::_27			w txSwapPart			;Partition wechseln.
			b MENU_ACTION
			w jobSwapPart

;*** PopUp/Titelzeile CMD-41/71/81.
if LANG = LANG_DE
:width478CMD = $67
endif
if LANG = LANG_EN
:width478CMD = $57
endif

:menu478CMD		b $00,$00
			w $0000,$0000

			b 3!VERTICAL

::_07			w txDrvMode			;Laufwerksmodus wechseln.
			b MENU_ACTION
			w jobDrvMode

::_12			w txSwapPart			;Partition wechseln.
			b MENU_ACTION
			w jobSwapPart

::_17			w txPartName			;Partition umbenennen.
			b MENU_ACTION
			w jobPartName

;*** PopUp/Titelzeile SD2IEC-41/71/81.
if LANG = LANG_DE
:width478SD = $5f
endif
if LANG = LANG_EN
:width478SD = $4f
endif

:menu478SD		b $00,$00
			w $0000,$0000

			b 2!VERTICAL

::_07			w txDrvMode			;Laufwerksmodus wechseln.
			b MENU_ACTION
			w jobDrvMode

::_12			w txSwapPart			;DiskImage wechseln.
			b MENU_ACTION
			w jobSwapPart

;******************************************************************************
;Sicherstellen das genügend Speicher
;für Menü-Daten verfügbar ist.
			g BASE_GDMENU +SIZE_GDMENU -1
;******************************************************************************
