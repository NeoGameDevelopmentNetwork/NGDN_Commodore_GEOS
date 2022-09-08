; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;******************************************************************************
;
; SuperMouse64
;
;******************************************************************************
;Linke Maustaste   : Mausklick    20 Mhz
;Mittlere Maustaste: Mausklick     1 Mhz
;Rechte Maustaste  : Doppelklick  20 Mhz
;CTRL-Taste        : DoubleSpeed
;******************************************************************************
;
; Maustreiber für C=1351, SmartMouse, SuperCPU & TC64.
; (c) 1997-2022 M. Kanet
;
; 13.06.2019
; V4.01: Anpassung an TurboChameleon64.
;        Umschaltung auf 1MHz um den
;        "Zitter"-Bug zu umgehen.
;        Entspricht Anpassung für SCPU.
;******************************************************************************

;*** Symboltabellen.
if .p
			t "SymbTab_1"
;			t "SymbTab_GDOS"
			t "SymbTab_CXIO"
			t "SymbTab_SCPU"
			t "SymbTab_TC64"
			t "SymbTab_GTYP"
			t "MacTab"
endif

;*** GEOS-Header.
			n "SuperMouse64",NULL
			c "InputDevice V4.0"
			t "opt.Author"
			f INPUT_DEVICE
			z $80 ;nur GEOS64

			o MOUSE_BASE

			i
<MISSING_IMAGE_DATA>

			h "L:20Mhz, M:1Mhz, R:2-click"
			h "CTRL-key for DoubleSpeed"
			h "C=1351,SmartMouse,SCPU,TC64"

if .p
:FastSpeed		= $02
:FastSpeed80		= $03				;80 Zeichen fastspeed C128
:LowSpeed80		= $01				;80 Zeichen normalspeed C128
:NumClicks		= $02 -1
:ClkDelay		= $0a
endif

;******************************************************************************
			t "-G3_SuperMouse"
;******************************************************************************

;******************************************************************************
;*** Endadresse testen.
;******************************************************************************
			e MOUSE_END
;******************************************************************************
