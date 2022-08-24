; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

			n "SetupMP_128"
			t "G3_SymMacExt"

			c "SetupMP_128 V2.1"
			a "M.Kanet/W.Grimm"
			f APPLICATION
			z $40

			o $0400
			p MainMenu

			i
<MISSING_IMAGE_DATA>

;*** Infoblock definieren.
if Sprache = Deutsch
			h "* MegaPatch128 *",CR
			h "Installationsprogramm"
endif
if Sprache = Englisch
			h "* MegaPatch128 *",CR
			h "Setup program"
endif

;******************************************************************************
;*** Programmteile einbinden.
;******************************************************************************
:Class_StartMP		b "SetupMP128."			;Class für Filesuche
:Class_Group		b "1V2.1",NULL
:FNameStartMP		b "SetupMP128."			;Text für Dialogbox wenn Datei
:Class_Group2		b "1",NULL			;nicht gefunden wurde
:FNameMP3		b "GEOS128.MP3",NULL

;*** Shared Code...
			t "-G3_FilesMP3"		;Dateiliste einbinden.
			t "-S3_UseFontG3"		;Zeichensatz einbinden.
			t "-S3_TxIcnPData"		;Positionsdaten für Icons und Texte.
			t "-S3_Shared"			;Hauptprogramm.
			t "-S3_DlgBox"			;Dialogboxen.
			t "-S3_Text"			;Systemtexte.
			t "-S3_Icons"			;System-Icons.

;*** Prüfsummen-Routine.
;    Hier wird eine eigene Routine eingebunden, da nicht auszuschließen
;    ist das andere GEOS-Versionen andere CRC-Ergebnisse liefern.
			t "-G3_PatchCRC"

;*** Archiv-Informationen.
:PatchDataTS		b $00,$00
			b $00,$00
			b $00,$00
			b $00,$00
			b $00,$00
:PatchInfoTS		b $00,$00
			b $00,$00
			b $00,$00
			b $00,$00
			b $00,$00

:PatchSizeKB		b $00
			b $00
			b $00
			b $00
			b $00

;*** Startadressen der Dateien innerhalb des Archivs.
:PackFileSAdr		s (MP3_Files   * 32) + 4
:PackFileSAdr_1		= PackFileSAdr
:PackFileSAdr_2		= PackFileSAdr_1 + (FileCount_1 *  4)
:PackFileSAdr_3		= PackFileSAdr_2 + (FileCount_2 *  4)
:PackFileSAdr_4		= PackFileSAdr_3 + (FileCount_3 *  4)
:PackFileSAdr_5		= PackFileSAdr_4 + (FileCount_4 *  4)

:PackFileVecAdr		w PackFileSAdr_1
			w PackFileSAdr_2
			w PackFileSAdr_3
			w PackFileSAdr_4
			w PackFileSAdr_5

:CRC_CODE		w $0000				;Prüfsumme.

:FNameTab1
:CopyBuffer		= FNameTab1      + (MP3_Files   * 32) + 1 +3
:DskDvVLIR		= CopyBuffer     + 256
:DskDvVLIR_org		= DskDvVLIR      + 256
:DskInfTab		= DskDvVLIR_org  + 256
:DskInf_VLIR		= DskInfTab      + 2*254
:DskInf_Modes		= DskInfTab      + 3*254
:DskInf_VlirSet		= DskInfTab      + 3*254 +64
:DskInf_Names		= DskInfTab      + 3*254 +64 +64*2
:FreeSekTab		= DskInfTab      + 3*254 +64 +64*2 +64*17
