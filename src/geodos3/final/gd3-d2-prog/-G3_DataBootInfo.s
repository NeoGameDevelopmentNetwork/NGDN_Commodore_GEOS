﻿; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Zeiger auf Textausgabe-Strings.
:StrgVecTab1		w BootText00			;$00
			w BootText00a			;$01
			w BootText01			;$02
			w BootText02			;$03
			w BootText10			;$04
			w BootText11			;$05
			w BootText12			;$06
			w BootText13			;$07
			w BootText14			;$08
			w BootText15			;$09
			w BootText16			;$0a
			w BootText18			;$0b
			w BootText19			;$0c
			w BootText20			;$0d
			w BootText21			;$0e
			w BootText22			;$0f
			w BootText30			;$10
			w BootText31			;$11
			w BootText40			;$12
			w BootText41			;$13
			w BootText50			;$14
			w BootText51			;$15
			w BootText52			;$16
			w BootText60			;$17
			w BootText61			;$18
;			w BootText62			;HD-Kabel nicht beim Systemstart.
			w BootText70			;$19
			w BootText80			;$1a
			w BootText90			;$1b
			w BootText99			;$1c

;*** Texte für Start-Sequenz.
if Sprache = Deutsch
:BootText01		b       " OK",CR,NULL
:BootText02		b       " N.V.",CR,NULL

:BootText10		b       "AUSWAHL DES ERWEITERTEN SPEICHERS:"
			b CR,   "HINWEIS: JEDE SPEICHERERWEITERUNG WIRD"
			b CR,   "         NUR BIS 4096KB UNTERSTUETZT!",CR,NULL
:BootText14		b       "  (1) GEORAM/BBGRAM",NULL
:BootText13		b       "  (2) C=/CMD REU",NULL
:BootText12		b       "  (3) CMD RAMLINK",NULL
:BootText11		b       "  (4) CMD RAMCARD",NULL
:BootText15		b CR,   "IHRE WAHL...................... ?",NULL
:BootText16		b CR,CR,"GEODOS-DACC WIRD INSTALLIERT IN",CR,NULL
:BootText18		b       " ERWEITERTER SPEICHER",CR,NULL
:BootText19		b CR,CR,"WAHL DER RAMLINK-DACC-PARTITION"
			b CR,   "('SPACE' = WECHSELN, 'RETURN' = OK)",CR,NULL

:BootText20		b CR,CR,"GEODOS KANN OHNE RAM NICHT GESTARTET"
			b CR,   "WERDEN. START ABGEBROCHEN...",CR,NULL
:BootText21		b CR,   "INSTALLATIONS-AUTOMATIK AKTIV!"
			b CR,CR,"UM EINE NEUE SPEICHERERWEITERUNG ZU"
			b CR,   "AKTIVIEREN, STARTEN SIE GEODOS MIT DER"
			b CR,   "DATEI 'GD.RESET'",NULL
:BootText22		b CR,CR,"DAS SYSTEM WIRD JETZT GELADEN:",CR,NULL

:BootText30		b CR,   "STARTLAUFWERK INITIALISIEREN",NULL
:BootText31		b CR,   "RAMLINK  : PARTITION #",NULL

:BootText40		b CR,CR,"GEODOS-KERNAL #1 LADEN........:",NULL
:BootText50		b       "GEODOS-KERNAL #1 INSTALLIEREN.:",NULL

:BootText41		b CR,   "GEODOS-KERNAL #2 LADEN........:",NULL
:BootText51		b       "GEODOS-KERNAL #2 INSTALLIEREN.:",NULL
:BootText52		b       "GEODOS-REBOOT INSTALLIEREN....:",NULL

:BootText60		b CR,   "SPEICHER-MANAGEMENT STARTEN...:",NULL
:BootText61		b       "SUPERCPU-MANAGEMENT STARTEN...:",NULL
;:BootText62		b       "CMD-HD-KABEL ABSCHALTEN.......:",NULL

:BootText70		b CR,   "GEODOS-KERNAL STARTEN...",NULL
:BootText80		b       " ERROR"
			b CR,CR,"KERNEL KONNTE NICHT IN DER SPEICHER-"
			b CR,   "ERWEITERUNG INSTALLIERT WERDEN!"
			b CR,CR,"SPEICHERERWEITERUNG FEHLERHAFT!",CR,NULL
:BootText90		b       "ERWEITERTEN SPEICHER TESTEN...:",NULL
:BootText99		b       " ERROR"
			b CR,CR,"GEODOS KONNTE NICHT GELADEN WERDEN:"
			b CR,   "FEHLER BEIM LADEN VON DATEIEN!",CR,NULL
endif

;*** Texte für Start-Sequenz.
if Sprache = Englisch
:BootText01		b       " OK",CR,NULL
:BootText02		b       " N.A.",CR,NULL

:BootText10		b       "SELECT EXTENDED MEMORY:"
			b CR,   "NOTE: RAM-EXPANSIONS WILL BE SUPPORTED"
			b CR,   "      TO A MAXIMUM SIZE OF 4096KB!",CR,NULL
:BootText14		b       "  (1) GEORAM/BBGRAM",NULL
:BootText13		b       "  (2) C=/CMD REU",NULL
:BootText12		b       "  (3) CMD RAMLINK",NULL
:BootText11		b       "  (4) CMD RAMCARD",NULL
:BootText15		b CR,   "YOUR CHOICE.................... ?",NULL
:BootText16		b CR,CR,"GEODOS-DACC WILL BE INSTALLED IN",CR,NULL
:BootText18		b       " EXTENDED MEMORY",CR,NULL
:BootText19		b CR,CR,"SELECT RAMLINK-DACC-PARTITION"
			b CR,   "('SPACE' = CHANGE, 'RETURN' = OK)",CR,NULL

:BootText20		b CR,CR,"BOOTING GEODOS WITHOUT RAM IS NOT"
			b CR,   "POSSIBLE. START CANCELLED...",CR,NULL
:BootText21		b CR,   "AUTO-INSTALLATION ACTIV!"
			b CR,CR,"TO SELECT A NEW RAM-EXPANSION PLEASE"
			b CR,   "BOOT GEODOS WITH FILE 'GD.RESET'",NULL
:BootText22		b CR,CR,"THE SYSTEM WILL NOW BE LOADED:",CR,NULL

:BootText30		b CR,   "INITIALIZING BOOT-DEVICE",NULL
:BootText31		b CR,   "RAMLINK  : PARTITION #",NULL

:BootText40		b CR,CR,"LOAD    GEODOS-KERNAL #1......:",NULL
:BootText50		b       "INSTALL GEODOS-KERNAL #1......:",NULL

:BootText41		b CR,   "LOAD    GEODOS-KERNAL #1......:",NULL
:BootText51		b       "INSTALL GEODOS-KERNAL #1......:",NULL
:BootText52		b       "INSTALL GEODOS-REBOOT.........:",NULL

:BootText60		b CR,   "INSTALL MEMORY-MANAGER........:",NULL
:BootText61		b       "INSTALL SUPERCPU-MANAGER......:",NULL
;:BootText62		b       "DEACTIVATE CMD-HD-CABEL.......:",NULL

:BootText70		b CR,   "STARTING GEODOS...",NULL
:BootText80		b       " ERROR"
			b CR,CR,"UNABLE TO INSTALL THE KERNAL"
			b CR,   "IN THE RAM-EXPANSION-UNIT!"
			b CR,CR,"RAM-EXPANSION MIGHT BE CORRUPT!",CR,NULL
:BootText90		b       "TESTING EXPANDED MEMORY.......:",NULL
:BootText99		b       " ERROR"
			b CR,CR,"UNABLE TO LOAD GEODOS SYSTEM MODULES:"
			b CR,   "ERROR WHILE LOADING FILES!",CR,NULL
endif
