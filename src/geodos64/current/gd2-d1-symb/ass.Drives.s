; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;--- Laufwerke.
;Auf NativeMode-Laufwerken kann in der
;Datei "ass.NativeDir" auch ein
;Ziel-Verzeichnis für jedes Laufwerk
;definiert werden.
;Laufwerk für Symboltabellen, Macros
;und AutoAssembler Dateien.
;RAMLink
;:DvPart_Symbol = 6
;:DvAdr_Symbol  = 11
;3x1581
;:DvPart_Symbol = 0
;:DvAdr_Symbol  = 9
;2xRAMNative
:DvPart_Symbol = 0
:DvAdr_Symbol  = 11

;Laufwerk für Quelltexte
;RAMLink
;:DvPart_Main    = 7
;:DvAdr_Main     = 10
;:DvPart_Convert = 8
;:DvAdr_Convert  = 10
;:DvPart_DosCbm  = 9
;:DvAdr_DosCbm   = 10
;:DvPart_Tools   = 7
;:DvAdr_Tools    = 10
;3x1581
;:DvPart_Main    = 0
;:DvAdr_Main     = 0
;:DvPart_Convert = 0
;:DvAdr_Convert  = 0
;:DvPart_DosCbm  = 0
;:DvAdr_DosCbm   = 0
;:DvPart_Tools   = 0
;:DvAdr_Tools    = 0
;2xRAMNative
:DvPart_Main    = 0
:DvAdr_Main     = 11
:DvPart_Convert = 0
:DvAdr_Convert  = 11
:DvPart_DosCbm  = 0
:DvAdr_DosCbm   = 11
:DvPart_Tools   = 0
:DvAdr_Tools    = 11

;Laufwerk für Bootpartition und
;Ausgabe des Programmcodes
;RAMLink
;:DvPart_Target = 2
;:DvAdr_Target  = 8
;3x1581
;:DvPart_Target = 0
;:DvAdr_Target  = 8
;2xRAMNative
:DvPart_Target = 0
:DvAdr_Target  = 10
