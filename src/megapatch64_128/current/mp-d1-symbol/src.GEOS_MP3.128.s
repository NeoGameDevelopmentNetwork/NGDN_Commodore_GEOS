﻿; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

:AppendRecord		= $c289
:BASE_RAM_DRV		= $9ee7
:BASE_RAM_DRV_END	= $9f54
:BBMult			= $c160
:BMult			= $c163
:BackScrPattern		= $9fcf
:BitOtherClip		= $c2c5
:BitmapClip		= $c2aa
:BitmapUp		= $c142
:BldGDirEntry		= $c1f3
:BlkAlloc		= $c1fc
:BlockProcess		= $c10c
:CRC			= $c20e
:C_Balken		= $9fea
:C_DBoxBack		= $9ff0
:C_DBoxDIcon		= $9ff1
:C_DBoxTitel		= $9fef
:C_FBoxBack		= $9ff3
:C_FBoxDIcon		= $9ff4
:C_FBoxFiles		= $9ff5
:C_FBoxTitel		= $9ff2
:C_FarbTab		= $9fea
:C_GEOS_BACK		= $9ffd
:C_GEOS_FRAME		= $9ffe
:C_GEOS_MOUSE		= $9fff
:C_InputField		= $9ffb
:C_InputFieldOff	= $9ffc
:C_Mouse		= $9fee
:C_PullDMenu		= $9ffa
:C_Register		= $9feb
:C_RegisterBack		= $9fed
:C_RegisterOff		= $9fec
:C_WinBack		= $9ff7
:C_WinIcon		= $9ff9
:C_WinShadow		= $9ff8
:C_WinTitel		= $9ff6
:CalcBlksFree		= $c1db
:CallRoutine		= $c1d8
:ChangeDiskDevice	= $c2bc
:ChkDkGEOS		= $c1de
:ClearMouseMode		= $c19c
:ClearRam		= $c178
:CloseRecordFile	= $c277
:CmpFString		= $c26e
:CmpString		= $c26b
:ColorPoint		= $c2f8
:ColorRectangle		= $c2fb
:CopyFString		= $c268
:CopyString		= $c265
:DB_CopyIconInTab	= $f005
:DB_CurColor		= $f26f
:DB_DrawIcons		= $ee9f
:DB_FBoxData		= $f268
:DB_GFileClass		= $9fd8
:DB_GFileType		= $9fd7
:DB_GetFileEntry	= $9fda
:DB_GetFilesOpt		= $f28b
:DB_IconColor		= $f270
:DB_Icon_DrvA		= $f10f
:DB_Icon_DrvB		= $f112
:DB_Icon_DrvC		= $f115

:DB_Icon_DrvD		= $f118
:DB_ResetGrafx		= $f28f
:DB_SaveScreen		= $ee8d
:DB_SetDrvIcons		= $f28c
:DB_SetDrvXYpos		= $f28d
:DB_SlctFileName	= $f27a
:DB_StdBoxSize		= $9fdb
:DB_TestUpsize		= $ef99
:DB_VecFNameBuf		= $f278
:DMult			= $c166
:DSdiv			= $c16c
:DShiftLeft		= $c15d
:DShiftRight		= $c262
:Dabs			= $c16f
:Ddec			= $c175
:Ddiv			= $c169
:DeleteFile		= $c238
:DeleteRecord		= $c283
:DeskTopName		= $c9bb
:DeskTopNameEnd		= $c9c6
:Deutsch		= $0110
:DirectColor		= $c0e2
:DisablSprite		= $c1d5
:DlgBoxDTdisk		= $fec8
:DlgBoxDTopMsg1		= $c9c7
:DlgBoxDTopMsg1End	= $c9df
:DlgBoxDTopMsg2		= $c9e0
:DlgBoxDTopMsg2End	= $c9f4
:Dnegate		= $c172
:DoBAMBuf		= $c2ef
:DoBOp			= $c2ec
:DoDlgBox		= $c256
:DoIcons		= $c15a
:DoInlineReturn		= $c2a4
:DoMenu			= $c151
:DoPreviousMenu		= $c190
:DoRAMOp		= $c2d4
:DoSoftSprites		= $e045
:DoneWithDskDvJob	= $cf06
:DoneWithIO		= $c25f
:DrawLine		= $c130
:DrawPoint		= $c133
:DrawSprite		= $c1c6
:DskDrvBaseH		= $9f82
:DskDrvBaseL		= $9f7e
:EnablSprite		= $c1d2
:EnableProcess		= $c109
:EndGetStrgAdr		= $c016
:Englisch		= $0220
:EnterDeskTop		= $c22c
:EnterTurbo		= $c214
:ExecMseKeyb		= $c39f
:Exit7ByteInline	= $c365
:ExitTurbo		= $c232
:FastDelFile		= $c244
:FetchRAM		= $c2cb
:FillRam		= $c17b
:FindBAMBit		= $c2ad
:FindFTypes		= $c23b
:FindFile		= $c20b
:FirstInit		= $c271

:Flag64_128		= $f000
:Flag_ColorDBox		= $9fd1
:Flag_CrsrRepeat	= $9fce
:Flag_DBoxType		= $9fd5
:Flag_ExtRAMinUse	= $9fcb
:Flag_GetFiles		= $9fd6
:Flag_IconDown		= $9fd4
:Flag_IconMinX		= $9fd2
:Flag_IconMinY		= $9fd3
:Flag_LoadPrnt		= $9fae
:Flag_MenuStatus	= $9fe2
:Flag_Optimize		= $9fac
:Flag_ScrSaver		= $9fcd
:Flag_ScrSvCnt		= $9fcc
:Flag_SetColor		= $9fd0
:Flag_SetMLine		= $9fe1
:Flag_SplCurDok		= $9fc7
:Flag_SplMaxDok		= $9fc8
:Flag_SpoolADDR		= $9fc3
:Flag_SpoolCount	= $9fc6
:Flag_SpoolMaxB		= $9fc2
:Flag_SpoolMinB		= $9fc1
:Flag_Spooler		= $9fc0
:Flag_TaskAktiv		= $9fc9
:Flag_TaskBank		= $9fca
:FollowChain		= $c205
:FrameRectangle		= $c127
:FreeBlock		= $c2b9
:FreeFile		= $c226
:FreezeProcess		= $c112
:GCalcFix1		= $cf98
:GCalcFix2		= $cfa4
:GEOS_IRQ		= $ff05
:GEOS_Init1		= $fef7
:GEOS_InitSystem	= $c0ee
:GEOS_RAM_TYP		= $9fa8
:Get2Word1Byte		= $fed7
:GetBackScreen		= $c0e8
:GetBlock		= $c1e4
:GetCharWidth		= $c1c9
:GetDirHead		= $c247
:GetFHdrInfo		= $c229
:GetFile		= $c208
:GetFreeDirBlk		= $c1f6
:GetNextChar		= $c2a7
:GetPtrCurDkNm		= $c298
:GetRandom		= $c187
:GetRealSize		= $c1b1
:GetScanLine		= $c13c
:GetSerialNumber	= $c196
:GetString		= $c1ba
:GetVDC			= $ca82
:GotoFirstMenu		= $c1bd
:GraphicsString		= $c136
:HideOnlyMouse		= $c2f2
:HorizontalLine		= $c118
:IRQ_END		= $ff25
:IRQ_VECTOR		= $fffe
:Icon_CANCEL		= $d194
:Icon_DISK		= $d339
:Icon_DRIVE_A		= $d38d

:Icon_DRIVE_B		= $d3ae
:Icon_DRIVE_C		= $d3cf
:Icon_DRIVE_D		= $d3f0
:Icon_NO		= $d23c
:Icon_OK		= $d1e8
:Icon_OPEN		= $d2e4
:Icon_YES		= $d290
:ImprintRectangle	= $c250
:InitCurDskDvJob	= $cef8
:InitForDskDvJob	= $cef5
:InitForIO		= $c25c
:InitMouse		= $fe80
:InitProcesses		= $c103
:InitRam		= $c181
:InitTextPrompt		= $c1c0
:InitVDCdata		= $ff26
:InsertRecord		= $c286
:InterruptMain		= $c100
:InvertLine		= $c11b
:InvertRectangle	= $c12a
:IsMseInRegion		= $c2b3
:Jsr_00Akku		= $9f5f
:JumpB0_Basic		= $e063
:JumpB0_Basic2		= $e066
:Ld128			= $fcec
:LdApplic		= $c21d
:LdDeskAcc		= $c217
:LdFile			= $c211
:LoadCharSet		= $c1cc
:LoadGEOS_Data		= $f301
:MAX_FILES_BROWSE	= $ff
:MAX_SPOOL_DOC		= $0f
:MAX_SPOOL_SIZE		= $40
:MAX_SPOOL_STD		= $04
:MAX_TASK_ACTIV		= $09
:MP3_64K_DATA		= $9faa
:MP3_64K_DISK		= $9fab
:MP3_64K_SYSTEM		= $9fa9
:MP3_CODE		= $c014
:MPatchVersion		= $20
:MainLoop		= $c1c3
:Mem_9F7E		= $9f7e
:Mem_9F7E_Temp		= $9f79
:Mem_CFFF		= $cf38
:Mem_CFFF_Temp		= $cf1f
:Mem_OSMP		= $9fce
:Mem_OSMP_Temp		= $9fce
:MouseOff		= $c18d
:MouseUp		= $c18a
:MoveBData		= $c2e3
:MoveData		= $c17e
:NMI_VECTOR		= $fffa
:NewDisk		= $c1e1
:NextRecord		= $c27a
:NormalizeX		= $c2e0
:NxtBlkAlloc		= $c24d
:OS_VAR_MP		= $9f7e
:Old_grMd		= $ca97
:OpenDisk		= $c2a1
:OpenRecordFile		= $c274
:Panic			= $c2c2

:Patch_BASE_2		= $c635
:Patch_BASE_2a		= $c6bd
:PointRecord		= $c280
:PosSprite		= $c1cf
:PreviousRecord		= $c27d
:PrntFileNameRAM	= $9faf
:PromptOff		= $c29e
:PromptOn		= $c29b
:PurgeTurbo		= $c235
:PutBlock		= $c1e7
:PutChar		= $c145
:PutDecimal		= $c184
:PutDirHead		= $c24a
:PutKeyInBuffer		= $c0f1
:PutString		= $c148
:RAM_MAX_SIZE		= $40
:RAM_SIZE		= $40
:RESET_VECTOR		= $fffc
:RamBankFirst		= $9fa6
:RamBankInUse		= $9f96
:ReDoMenu		= $c193
:ReadBlock		= $c21a
:ReadByte		= $c2b6
:ReadFile		= $c1ff
:ReadRecord		= $c28c
:RealDrvMode		= $9f92
:RealDrvType		= $9f8e
:RecColorBox		= $c0e5
:RecoverAllMenus	= $c157
:RecoverLine		= $c11e
:RecoverMenu		= $c154
:RecoverRectangle	= $c12d
:Rectangle		= $c124
:RenameFile		= $c259
:ResetHandle		= $c003
:ResetScreen		= $c0eb
:RestartProcess		= $c106
:RstrAppl		= $c23e
:RstrFrmDialogue	= $c2bf
:SCPU_OptOff		= $c0fa
:SCPU_OptOn		= $c0f7
:SCPU_PATCH_JMPTAB	= $c0f7
:SCPU_Pause		= $c0f4
:SCPU_SetOpt		= $c0fd
:SaveFile		= $c1ed
:SaveGEOS_Data		= $f2f9
:SerialNumber		= $9f54
:SetADDR_BackScrn	= $cfc2
:SetADDR_DB_COLS	= $cfc5
:SetADDR_DB_GRFX	= $cfc8
:SetADDR_DB_SCRN	= $cfcb
:SetADDR_DoAlarm	= $cfd7
:SetADDR_EnterDT	= $cfe3
:SetADDR_GFilData	= $cfd1
:SetADDR_GFilMenu	= $cfce
:SetADDR_GetFiles	= $cfd4
:SetADDR_GetNxDay	= $cfda
:SetADDR_PANIC		= $cfdd
:SetADDR_Printer	= $cfb3
:SetADDR_PrnSpHdr	= $cfb6
:SetADDR_PrnSpool	= $cfb9

:SetADDR_PrntHdr	= $cfb0
:SetADDR_Register	= $cfe6
:SetADDR_ScrSaver	= $cfbf
:SetADDR_Spooler	= $cfbc
:SetADDR_TaskMan	= $cfed
:SetADDR_ToBASIC	= $cfe0
:SetDevice		= $c2b0
:SetGDirEntry		= $c1f0
:SetGEOSDisk		= $c1ea
:SetMouse		= $fe89
:SetMseFullWin		= $f805
:SetMsePic		= $c2da
:SetNewMode		= $c2dd
:SetNextFree		= $c292
:SetPattern		= $c139
:SetVDC			= $ca76
:SetVecToSek		= $9edb
:Sleep			= $c199
:SlowMouse		= $fe83
:SmallPutChar		= $c202
:Sprache		= $0110
:StartAppl		= $c22f
:StartMouseMode		= $c14e
:StashRAM		= $c2c8
:Sv128			= $fcd9
:SwapBData		= $c2e6
:SwapRAM		= $c2ce
:SystemReBoot		= $c000
:TaskManKey1		= $fe9b
:TaskManKey2		= $fea7
:TaskMan_LoadMenu	= $feb4
:TaskMan_NewJob		= $feac
:TaskMan_QuitJob	= $feaf
:TaskMan_Quit_DA	= $feb2
:TaskManager		= $fe8c
:TempHideMouse		= $c2d7
:TestPoint		= $c13f
:ToBasic		= $c241
:UnblockProcess		= $c10f
:UnfreezeProcess	= $c115
:UpdateMouse		= $fe86
:UpdateRecordFile	= $c295
:UseSystemFont		= $c14b
:VDC_ModeInit		= $c2f5
:VerWriteBlock		= $c223
:VerWriteSek		= $9e8b
:VerifyBData		= $c2e9
:VerifyRAM		= $c2d1
:VerticalLine		= $c121
:WriteBlock		= $c220
:WriteFile		= $c1f9
:WriteRecord		= $c28f
:bootName		= $c006
:c128Flag		= $c013
:dateCopy		= $c018
:doubleSideFlg		= $9f86
:drivePartData		= $9f8a
:i_BitmapUp		= $c1ab
:i_ColorBox		= $c0df
:i_FillRam		= $c1b4
:i_FrameRectangle	= $c1a2

:i_GraphicsString	= $c1a8
:i_ImprintRectangle	= $c253
:i_MoveData		= $c1b7
:i_PutString		= $c1ae
:i_RecoverRectangle	= $c1a5
:i_Rectangle		= $c19f
:i_UserColor		= $c0dc
:key0y			= $c83e
:key0z			= $c831
:key1y			= $c896
:key1z			= $c889
:millenium		= $9fad
:nationality		= $c010
:sysFlgCopy		= $c012
:version		= $c00f
:xEnterDeskTop		= $c307
:xGEOS_IRQ		= $c425
:xGetBackScreenVDC	= $e078
:xLoad80Screen		= $e07b
:xResetScreen		= $f4a9
:xSave80Screen		= $e07e
:xSet_C_FarbTab		= $e081
:xSpritesSpool80	= $e084
:xStartAppl		= $f38e
