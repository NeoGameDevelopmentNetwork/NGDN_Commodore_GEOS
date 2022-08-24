; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

:ConvClu2Sek		= $9b95
:ConvDOS2CBMsek		= $9c3a
:CurrentDiskName	= $90db
:DOS_DataArea		= $9085
:Data_1stRDirSek	= $90a5
:Data_1stSDirClu	= $90ac
:Data_AliasSektor	= $90b6
:Data_AnzSLK		= $90a1
:Data_Anz_Fat		= $9097
:Data_Anz_Files		= $9098
:Data_Anz_Sektor	= $909a
:Data_AreSek		= $9095
:Data_Boot		= $9087
:Data_BpSek		= $9092
:Data_Disk_Typ		= $908a
:Data_FstSek		= $90a3
:Data_Media		= $909c
:Data_ParentSDir	= $90ae
:Data_SekFat		= $909d
:Data_SekSpr		= $909f
:Data_SpClu		= $9094
:Def1stDataSek		= $9ad5
:Def1stRDirSek		= $9af5
:DefAdrRootDir		= $9b38
:DiskDrvMode		= $05
:DriveModeFlags		= $40
:DummyDiskName		= $90c9
:Flag_DirType		= $90ab
:Flag_UpdateDir		= $90c6
:Flag_UpdateDkDv	= $90c7
:GetClusterLink		= $9ac0
:Inc_Sek		= $9b73
:LoadAliasData		= $99a5
:Load_Reg_r0_r4		= $9541
:MaxDirPages		= $ff
:PART_MAX		= $00
:PART_TYPE		= $05
:RAM_AREA_ALIAS		= $4000
:RAM_AREA_BOOT		= $0200
:RAM_AREA_BUFFER	= $3e00
:RAM_AREA_DIR		= $2000
:RAM_AREA_FAT		= $0400
:RAM_AREA_SEKTOR	= $00
:ReadBlock_DOS		= $90f0
:Save_Reg_r0_r4		= $9552
:Se_1stDataSek		= $00
:Se_1stDirSek		= $01
:Se_BootSektor		= $01
:Se_BorderBlock		= $01
:Se_DskNameSek		= $01
:SearchEntryFAT		= $9a8a
:Seite			= $9082
:Sektor			= $9084
:SendFCom_CRC1		= $90f6
:SendFCom_CRC2		= $90f9
:SetBOOT_Area		= $95a8
:SetDOS_Area		= $95ba
:Spur			= $9083
:SwapBOOT_Buffer	= $958e
:SwapDOS_Buffer		= $9581
:SwapFAT_Buffer		= $956d

:SwapTMP_Buffer		= $959b
:Swap_ExtData		= $9514
:TMP_AREA_ALIAS		= $4000
:TMP_AREA_BOOT		= $8000
:TMP_AREA_BUFFER	= $8200
:TMP_AREA_DIR		= $4000
:TMP_AREA_FAT		= $4000
:TMP_AREA_SEKTOR	= $8000
:Tr_1stDataSek		= $20
:Tr_1stDirSek		= $01
:Tr_BootSektor		= $00
:Tr_BorderBlock		= $4f
:Tr_DskNameSek		= $00
:UpdateDriver		= $95c3
:WriteBlock_DOS		= $90f3
:dir3Head		= $9b80
