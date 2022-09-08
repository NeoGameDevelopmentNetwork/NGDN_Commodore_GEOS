; UTF-8 Byte Order Mark (BOM), do not remove!
;
; Area6510 (c) by Markus Kanet
;
; This file is used to document the source code, not for
; creating an executable program.
;

;*** Menü-Modul nachladen.
;Übergabe: xReg = Modul-Nummer.
:LdDTopMod		tax
			asl
			asl
			tay

			lda	GD_DACC_ADDR_B,x	;Speicherbank für VLIR-Modul
			sta	r3L			;einlesen.

			ldx	#$00
::1			lda	GD_DACC_ADDR,y		;Adresse des Moduls in der REU und
			sta	r1L,x			;Größe des Moduls kopieren.
			iny
			inx
			cpx	#$04
			bcc	:1

			LoadW	r0,BASE_GDMENU
			jsr	FetchRAM		;Modul einlesen.

;--- Hinweis:
;Menüroutinen sichern den Bildschirm
;vor dem öffnen des PopUp-Menüs.
;			jsr	sys_SvBackScrn		;Aktuellen Bildschirm speichern.

			jmp	BASE_GDMENU		;Modul starten.
