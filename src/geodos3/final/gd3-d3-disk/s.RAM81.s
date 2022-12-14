; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Symboltabellen.
			t "G3_SymMacExtDDrv"

;*** GEOS-Header.
			n "DiskDev_RAM81"
			t "G3_Sys.Author"
			f 3 ;DATA

			o DISK_BASE

if .p
:C_41			= FALSE
:C_71			= FALSE
:C_81			= FALSE
:RD_41			= FALSE
:RD_71			= FALSE
:RD_81			= TRUE
:RD_NM			= FALSE
:RD_NM_SCPU		= FALSE
:RD_NM_CREU		= FALSE
:RD_NM_GRAM		= FALSE
:RL_41			= FALSE
:RL_71			= FALSE
:RL_81			= FALSE
:RL_NM			= FALSE
:HD_41			= FALSE
:HD_71			= FALSE
:HD_81			= FALSE
:HD_NM			= FALSE
:HD_41_PP		= FALSE
:HD_71_PP		= FALSE
:HD_81_PP		= FALSE
:HD_NM_PP		= FALSE
:FD_41			= FALSE
:FD_71			= FALSE
:FD_81			= FALSE
:FD_NM			= FALSE
:PC_DOS			= FALSE
:IEC_NM			= FALSE
:S2I_NM			= FALSE

:DriveModeFlags		= SET_MODE_FASTDISK

:PART_TYPE		= $03
:PART_MAX		= 0

:dir3Head		= $9c80
:DiskDrvMode		= DrvRAM1581
:Tr_BorderBlock		= 40
:Se_BorderBlock		= 39
:Tr_1stDirSek		= 40
:Se_1stDirSek		= 3
:Tr_1stDataSek		= 1
:Se_1stDataSek		= 0
:Tr_DskNameSek		= 40
:Se_DskNameSek		= 0
:MaxDirPages		= 37

;*** TurboDOS-Modus für aktuellen Treiber setzen.
:TDOS_MODE = TDOS_RD_81
endif

;*** Sprungtabelle.
:JumpTab		t "-DX_JumpTable"

;*** Erweiterte Sprungtabelle/Speicheradressen.
			t "-DX_JumpTabDDX"

;*** Include-Dateien.
			t "-DX_IncludeFile"

;******************************************************************************
			g dir3Head
;******************************************************************************
