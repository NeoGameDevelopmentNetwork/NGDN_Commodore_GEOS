﻿; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

:AutoInitSpooler	= $3e92
:AutoInitTaskMan	= $3dfe
:BankCodeTab1		= $46c3
:BankCodeTab2		= $46c7
:BankCode_Block		= $08
:BankCode_Disk		= $40
:BankCode_Free		= $00
:BankCode_GEOS		= $80
:BankCode_Move		= $46cb
:BankCode_Spool		= $10
:BankCode_Task		= $20
:BankType_Block		= $46d7
:BankType_Disk		= $46d3
:BankType_GEOS		= $46cf
:BankUsed		= $4683
:BankUsed_2GEOS		= $3bd4
:BootBankBlocked	= $28b4
:BootCRSR_Repeat	= $28a9
:BootColsMode		= $28ad
:BootConfig		= $2880
:BootGCalcFix		= $292b
:BootGrfxFile		= $2909
:BootInptName		= $292c
:BootInstalled		= $2894
:BootLoadDkDv		= $28f5
:BootMLineMode		= $28af
:BootMenuStatus		= $28ae
:BootOptimize		= $28ab
:BootPartRL		= $2884
:BootPartRL_I		= $2888
:BootPartType		= $288c
:BootPrntMode		= $28ac
:BootPrntName		= $291a
:BootQWERTZ		= $293d
:BootRAM_Flag		= $2895
:BootRTCdrive		= $28f4
:BootRamBase		= $2890
:BootSaverName		= $2898
:BootScrSaver		= $2896
:BootScrSvCnt		= $2897
:BootSpeed		= $28aa
:BootSpoolCount		= $28b2
:BootSpoolSize		= $28b3
:BootSpooler		= $28b1
:BootTaskMan		= $28b0
:BootUseFastPP		= $293e
:BootVarEnd		= $293f
:BootVarStart		= $2880
:CheckDrvConfig		= $2d1c
:CheckForSpeed		= $3591
:Class_GeoPaint		= $4621
:Class_ScrSaver		= $4610
:ClearDiskName		= $35b5
:ClearDriveData		= $35cc
:ClrBank_Blocked	= $3c42
:ClrBank_Spooler	= $3c3f
:ClrBank_TaskMan	= $3c3c
:CopyStrg_Device	= $4008
:CountDrives		= $35a2
:CurDriveMode		= $4632
:DiskDataRAM_A		= $2180

:DiskDataRAM_S		= $2280
:DiskDriver_Class	= $45d4
:DiskDriver_DISK	= $45fc
:DiskDriver_FName	= $45ff
:DiskDriver_INIT	= $45fb
:DiskDriver_SIZE	= $45fd
:DiskDriver_TYPE	= $45fa
:DiskFileDrive		= $45f9
:Dlg_DrawTitel		= $3558
:Dlg_IllegalCfg		= $483e
:Dlg_LdDskDrv		= $47ce
:Dlg_LdMenuErr		= $48ae
:Dlg_NoDskFile		= $474c
:Dlg_SetNewDev		= $4905
:Dlg_Titel1		= $4979
:Dlg_Titel2		= $4989
:DoInstallDskDev	= $36af
:DriveInUseTab		= $4646
:DriveRAMLink		= $4631
:Err_IllegalConf	= $34cc
:ExitToDeskTop		= $2cdf
:FetchRAM_DkDrv		= $3072
:FindCurRLPart		= $4c5c
:FindDiskDrvFile	= $30db
:FindDkDvAllDrv		= $3104
:FindDriveType		= $39d7
:FindRTC_64Net		= $40f2
:FindRTC_SM		= $40de
:FindRTCdrive		= $40a1
:FindSystemFile		= $34f7
:Flag_ME1stBoot		= $4634
:GetDrvModVec		= $3359
:GetInpDrvFile		= $3fee
:GetMaxFree		= $3c73
:GetMaxSpool		= $3c79
:GetMaxTask		= $3c76
:GetPrntDrvFile		= $3f69
:InitDkDrv_Disk		= $31a1
:InitDkDrv_RAM		= $319b
:InitGCalcFix		= $3f80
:InitQWERTZ		= $3f8f
:InitScrSaver		= $3ece
:IsDrvAdrFree		= $37ba
:IsDrvOnline		= $3ae6
:LastSpeedMode		= $46f6
:LdBootScrn		= $2e04
:LdMenuError		= $3543
:LdScrnFrmDisk		= $2e30
:LoadDiskDrivers	= $3167
:LoadDskDrvData		= $33ff
:LoadInptDevice		= $3fe0
:LoadPrntDevice		= $3f5b
:LoadSysRecord		= $3523
:LookForDkDvFile	= $3142
:NewDrive		= $462e
:NewDriveMode		= $462f
:NoInptName		= $4707
:NoPrntName		= $46f9
:PrepareExitDT		= $2cf0
:RL_Aktiv		= $46f7
:SCPU_Aktiv		= $46f8

:SetClockGEOS		= $4074
:SetSystemDevice	= $3057
:StashRAM_DkDrv		= $3075
:StdClrGrfx		= $2e22
:StdClrScrn		= $2e12
:StdDiskName		= $4713
:SwapScrSaver		= $3f2b
:SysDrive		= $45e5
:SysDrvType		= $45e6
:SysFileName		= $45e8
:SysRealDrvType		= $45e7
:SystemClass		= $45c3
:SystemDlgBox		= $3551
:TASK_BANK_ADDR		= $28f6
:TASK_BANK_USED		= $28ff
:TASK_COUNT		= $2908
:TurnOnDriveAdr		= $4630
:UpdateDiskDriver	= $31e0
:VLIR_BASE		= $4a0b
:VLIR_Entry		= $23c0
:VLIR_Names		= $2440
:VLIR_SIZE		= $22f5
:VLIR_Types		= $2380
:firstBootCopy		= $4633