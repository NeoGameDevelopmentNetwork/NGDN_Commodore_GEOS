; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Symboltabellen.
if .p
			t "SymbTab_1"
			t "SymbTab_GDOS"
			t "SymbTab_SCPU"
			t "SymbTab_GTYP"
			t "MacTab"
endif

;*** GEOS-Header.
			n "obj.Patch_SRAM"
			f DATA

			o SRAM_USER_PAGE

;******************************************************************************
;RAM_Type = RAM_SCPU
;******************************************************************************
.StashRAM_SCPU		jmp	SCPU_STASH_RAM
.FetchRAM_SCPU		jmp	SCPU_FETCH_RAM
.SwapRAM_SCPU		jmp	SCPU_SWAP_RAM
.VerifyRAM_SCPU		jmp	SCPU_VERIFY_RAM

;*** SuperCPU 16-Bit DoRAMOp-Routinen.
			t "-R3_SRAM16Bit"

;--- DoRAMOpSRAM für GEOS-DACC/Disk.
:DefBankAdrSRAM		= DefBankAdrDACC
;DefBankAdrSRAM		= DefBankAdrDISK
