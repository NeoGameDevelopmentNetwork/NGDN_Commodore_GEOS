; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Symboltabellen.
			t "G3_SymMacExt"

;*** Zusätzliche Symboltabellen.
if .p
;--- Laufwerkstreiber-Modus:
;Modus: GD.DISK.xx
;Verwendet StandAlone Laufwerkstreiber.
:GD_NG_MODE		= TRUE
endif

;*** GEOS-Header.
			n "GD.BOOT.1"
			t "G3_Boot.V.Class"
			z $80				;nur GEOS64

			o BASE_GEOS_SYS -2
			p BASE_GEOS_SYS

			i
<MISSING_IMAGE_DATA>

if Sprache = Deutsch
			h "GEOS-Kernal"
			h "Grundfunktionen..."
endif
if Sprache = Englisch
			h "GEOS-kernal"
			h "Core functions..."
endif

;--- Ladeadresse.
:MainInit		w BASE_GEOS_SYS			;DUMMY-Bytes, da Kernal über
							;BASIC-Load eingelesen wird.

;******************************************************************************
;*** GD.BOOT.1 - Kernal
;******************************************************************************
;--- GEOS-Kernal.
::GEOS_Kernal		d "obj.GD_Kernal64"
;******************************************************************************
