; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

			n "GEOS128.3"
			t "G3_SymMacExt"
			t "G3_V.Cl.128.Boot"

			o BASE_GEOS_SYS -2
			p BASE_GEOS_SYS

			i
<MISSING_IMAGE_DATA>

if Sprache = Deutsch
			h "MegaPatch Kernal"
			h "Zusatzfunktionen..."
			h "TaskMan, ScrSaver, BackScrn"
endif

if Sprache = Englisch
			h "MegaPatch Kernal"
			h "Extended functions..."
			h "TaskMan, ScrSaver, BackScrn"
endif

;--- Ladeadresse.
:MainInit		w BASE_GEOS_SYS			;DUMMY-Bytes, da Kernal über
							;BASIC-Load eingelesen wird.

;--- Erweiterte MP3-Funktionen.
.x_TaskSwitch		d "obj.TaskSwitch"
.x_ScreenSaver		d "obj.ScreenSaver"
.x_GetBackScrn		d "obj.GetBackScrn"
