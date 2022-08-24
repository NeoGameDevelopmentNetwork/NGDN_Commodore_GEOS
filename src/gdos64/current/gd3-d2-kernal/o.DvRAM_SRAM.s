; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Symboltabellen.
if .p
;--- C64-Labels.
			t "SymbTab_SCPU"

			t "SymbTab_GDOS"
			t "SymbTab_1"
			t "SymbTab_GTYP"
			t "MacTab"

;--- Externe Labels.
			t "s.GD3_KERNAL.ext"
			t "o.Patch_SRAM.ext"

;--- SuperCPU/RAMCard-Kernal-Einsprünge.
:SCPU_STASH_RAM		= StashRAM_SCPU
:SCPU_FETCH_RAM		= FetchRAM_SCPU
:SCPU_SWAP_RAM		= SwapRAM_SCPU
:SCPU_VERIFY_RAM	= VerifyRAM_SCPU
endif

;*** GEOS-Header.
			n "obj.DvRAM_SRAM"
			f DATA

			o BASE_RAM_DRV

;*** DoRAMOp-Routine für RAMCard.
			t "-R3_DoRAM_SRAM"
			t "-R3_DoRAMOpSRAM"

;******************************************************************************
;*** Endadresse testen.
;******************************************************************************
			g GD_JUMPTAB
;******************************************************************************
