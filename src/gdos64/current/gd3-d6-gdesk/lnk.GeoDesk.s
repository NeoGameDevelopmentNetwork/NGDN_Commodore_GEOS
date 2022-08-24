; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;--- GEOS-Dateiname/Info.
			n "GEODESK"			;Name VLIR-Datei.

			h "A new generation of"
			h "   deskTop workplace..."
			h ""
			h "For C64 and GDOS64!"

;--- Hinweis:
;Beim hinzufügen eines VLIR-Moduls muss
;auch ":GD_VLIR_COUNT" in "TopSym.GD"
;angepasst werden!

			m

;00... Boot-Loader!
			- "obj.GD00"			;Boot-Routine.

;00... GD-System mit Variablen!
			- "obj.GD10"			;System.

;01...
			- "obj.GD20"			;WindowManager.
			- "obj.GD21"			;DeskTop.

;03...
			- "obj.GD30"			;Menü: "GEOS".
			- "obj.GD31"			;Menü: "Fenster".
			- "obj.GD32"			;Menü: "Arbeitsplatz".
			- "obj.GD33"			;Menü: "Desktop".
			- "obj.GD34"			;Menü: "AppLink".
			- "obj.GD35"			;Menü: "Laufwerk".
			- "obj.GD36"			;Menü: "Datei".
			- "obj.GD37"			;Menü: "Titelzeile".

;11...
			- "obj.GD3A"			;Menü: Desktop zeichnen.
			- "obj.GD3B"			;Menü: HotCorner-Aktionen ausführen.
			- "obj.GD3C"			;Menü: ShortCuts auswerten.

;14...
			- "obj.GD40"			;Partition wechseln.
			- "obj.GD41"			;AppLink laden/speichern.
			- "obj.GD42"			;Datei öffnen.
			- "obj.GD43"			;Datei mit Borderblock tauschen.
			- "obj.GD45"			;Dateien einlesen.
			- "obj.GD48"			;Hintergrundbild.

;20...
			- "obj.GD50"			;Systeminfos anzeigen.
			- "obj.GD52"			;Systemzeit setzen.
			- "obj.GD53"			;Farben ändern.
			- "obj.GD54"			;Konfiguration speichern.
			- "obj.GD55"			;Laufwerksmodus wechseln.
			- "obj.GD56"			;Laufwerksfehler.

;26...
			- "obj.GD60"			;Disk-Info.
			- "obj.GD61"			;SD-Image erzeugen.
			- "obj.GD62"			;Disk löschen.
			- "obj.GD63"			;Diskette kopieren.
			- "obj.GD64"			;Validate.

;31...
			- "obj.GD80"			;Datei-Eigenschaften.
			- "obj.GD81"			;Verzeichnisse erstellen.
			- "obj.GD82"			;Dateien löschen.
			- "obj.GD83"			;Dateien kopieren/verschieben.

;35...
			- 				;Modul: Info anzeigen.
			- 				;Modul: Verzeichnis sortieren.
			- 				;Modul: GEOS<->CVT.
			- 				;Modul: GeoPaint-SlideShow.
			- 				;Modul: Dateien senden.
			- 				;Modul: CBM-Disk.
			- 				;Modul: CMD-Partitionen.

			/
