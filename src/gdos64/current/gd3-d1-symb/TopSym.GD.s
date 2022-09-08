; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Debug-Modes.
;
;SYSINFO:
;Wenn auf TRUE gesetzt, dann erscheint
;im System-Einstellungen-Menü eine
;zusätzliche Registerkarte "DEBUG".
;Hier werden Speicherinformationen zu
;GeoDesk angezeigt.
;
;Standard: FALSE
;
:DEBUG_SYSINFO		= TRUE

;*** Bildschirmgröße.
:SCRN_WIDTH		= $0140
:SCRN_HEIGHT		= $c8
:SCRN_XCARDS		= 40
:SCRN_XBYTES		= SCRN_XCARDS*8

;*** Größe Dateizähler definieren,
;    Max. Anzahl Dateien im RAM.
;Hinweis: Max.160 wegen Icon-Cache!
:MAXENTRY16BIT		= FALSE				;Max. 256 Einträge.
:MAX_DIR_ENTRIES	= 160
;MAXENTRY16BIT 		= TRUE				;Max. 65536 Einträge wenn Speicher verfügbar ;-)
;MAX_DIR_ENTRIES	= 148

;MAX_DIR_ENTRIES	= 7				;Für PagingMode-Test.

;*** Modul-Nummern.
;Hinweis:
;Die Nummern entsprechen nicht mehr den
;VLIR-Datensätzen, sondern sind laufend
;durchnummeriert!
;GMOD_BOOT		= 0  ;00

:GMOD_GDCORE		= 0  ;10

:GMOD_WMCORE		= 1  ;20
:GMOD_DESKTOP		= 2  ;21

:GMNU_GEOS		= 3  ;30
:GMNU_WIN		= 4  ;31
:GMNU_MYCOMP		= 5  ;32
:GMNU_DTOP		= 6  ;33
:GMNU_ALINK		= 7  ;34
:GMNU_DISK		= 8  ;35
:GMNU_FILE		= 9  ;36
:GMNU_TITLE		= 10 ;37

:GMNU_DRAWDTOP		= 11 ;3A
:GMNU_START_HC		= 12 ;3B
:GMNU_SHORTCUT		= 13 ;3C

:GMOD_PARTITION		= 14 ;40
:GMOD_APPLINK		= 15 ;41
:GMOD_FILE_OPEN		= 16 ;42
:GMOD_SWAPBORDER	= 17 ;43
:GMOD_LOAD_FILES	= 18 ;45
:GMOD_BACKSCRN		= 19 ;48

:GMOD_SYSINFO		= 20 ;50
:GMOD_SYSTIME		= 21 ;52
:GMOD_COLORSETUP	= 22 ;53
:GMOD_SAVE_CONFIG	= 23 ;54
:GMOD_SETDRVMODE	= 24 ;55
:GMOD_STATMSG		= 25 ;56

:GMOD_DISKINFO		= 26 ;60
:GMOD_CREATEIMG		= 27 ;61
:GMOD_CLRDISK		= 28 ;62
:GMOD_DISKCOPY		= 29 ;63
:GMOD_VALIDATE		= 30 ;64

:GMOD_FILE_INFO		= 31 ;80
:GMOD_NM_DIR		= 32 ;81
:GMOD_FILE_DELETE	= 33 ;82
:GMOD_COPYMOVE		= 34 ;83

;--- Zusätzliche GEODESK-Module.
:GMOD_INFO		= 35 ;90
:GMOD_DIRSORT		= 36 ;91
:GMOD_FILECVT		= 37 ;92
:GMOD_GPSHOW		= 38 ;93
:GMOD_SENDTO		= 39 ;94
:GMOD_CBMDISK		= 40 ;95
:GMOD_CMDPART		= 41 ;96

;*** Anzahl VLIR-Module ohne BOOT.
;Letzte Modul-Nummer +1 (für BOOT) !!!
;Die Anzahl der Module wird dann in
;den DACC-Speicher geladen.
:GD_VLIR_COUNT		= 42

;*** Startadresse WindowManager.
:BASE_WMCORE		= $6000
:SIZE_WMCORE		= $2000

;*** Startadresse Speicher für Module.
;Hinweis:
;Überlagert den Bereich von WMCORE!
:BASE_EXTDATA		= BASE_WMCORE
:SIZE_EXTDATA		= OS_BASE -BASE_EXTDATA

;*** Menü-Bereich.
:BASE_GDMENU		= $4400
:SIZE_GDMENU		= $0800

;*** Startadresse Verzeichnis-Daten.
:BASE_DIRDATA		= BASE_GDMENU +SIZE_GDMENU

;*** Startadresse VLIR im DACC.
;Bereich $0000-$01FF ist reserviert für
;Original-EnterDeskTop-Routine.
:DACC_GEODESK		= $0200

;*** Optionen/Systemwerte für GeoDesk.
:GDA_OPTIONS		= APP_RAM      ;Speicheradresse Konfiguration Hauptmodul.
:GDS_OPTIONS		= 254          ;254Bytes Optionen.
:GDA_SYSTEM		= GDA_OPTIONS +GDS_OPTIONS  +2
:GDS_SYSTEM		= 256          ;256Bytes Systemwerte.

;*** Startadresse GeoDesk-Hauptmodul.
:BASE_GEODESK		= GDA_SYSTEM +GDS_SYSTEM

;*** Startadresse Boot-Loader.
:BASE_BOOTLOAD		= $7000        ;Ladeadresse Boot-Loader.
:SIZE_BOOTLOAD		= $1000        ;Max. Größe Boot-Loader.

;*** Ladeadresse VLIR-Module.
:BASE_VLIRDATA		= GDA_SYSTEM +GDS_SYSTEM
:SIZE_VLIRDATA		= BASE_BOOTLOAD -BASE_VLIRDATA

;*** AppLink-Typen.
:AL_TYPE_FILE		= $00
:AL_TYPE_DRIVE		= $ff
:AL_TYPE_PRNT		= $fe
:AL_TYPE_SUBDIR		= $fd
:AL_TYPE_MYCOMP		= $80

;*** AppLink: Zeiger auf Datentabelle.
:AL_ID_FILE		= $00
:AL_ID_DRIVE		= $01
:AL_ID_PRNT		= $02
:AL_ID_SUBDIR		= $03

;*** AppLink: $FF = Fensteroptionen speichern.
:AL_WMODE_FILE		= $00
:AL_WMODE_DRIVE		= $ff
:AL_WMODE_PRNT		= $00
:AL_WMODE_SUBDIR	= $ff

;*** Farbe für GeoDesk-Uhr.
:GD_COLOR_CLOCK		= $07

;*** Dateityp für "Weitere Dateien".
:GD_MORE_FILES		= $ff

;*** Datei-Auswahl.
:GD_MODE_SELECT		= $ff
:GD_MODE_UNSLCT		= $00
:GD_MODE_MASK		= %11111111

;*** Icon-Cache.
:GD_MODE_ICACHE		= $00
:GD_MODE_NOICON		= $ff

;*** SET_LOAD-Flag.
:GD_LOAD_DISK		= %1000 0000			;Dateien immer von Disk laden.
:GD_TEST_CACHE		= %0100 0000			;Dateien aus Cache oder von Disk.
:GD_SORT_ONLY		= %0011 1111			;Nur Dateien sortieren.
:GD_LOAD_CACHE		= %0000 0000			;Dateien aus Cache laden (Standard).

;*** Ersatz-Zeichen für Sonderzeichen.
:GD_REPLACE_CHAR	= "_"

;*** Statusmeldungen.
;Wegen fehlendem Symbolspeicher als
;HEX-Werte direkt im Code enthalten.
;
;Siehe auch "s.GD.56.StatMsg".
;
;PRNT_UPDATED		= $80 ! %01000000
;PRNT_NOT_UPDATED	= $80
;INPT_UPDATED		= $81 ! %01000000
;INPT_NOT_UPDATED	= $81
;UNKNOWN_FTYPE		= $82
;FILENAME_ERROR		= $83
;APPL_NOT_FOUND		= $84
;ALNK_NOT_FOUND		= $85
;SKIP_DIRECTORY		= $86
;GMOD_NOT_FOUND		= $87
;SENDTO_DRV_ERR		= $88
