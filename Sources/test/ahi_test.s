
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		wzonka-lad the emulator - ahi tester
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		incdir	"binworld:includes/"
		include	"exec/memory.i"
		include	"dos/dos.i"
		include	"exec_lib.i"
		include	"dos_lib.i"
		include	"ahi_lib.i"

		include	"devices/ahi.i"
		incdir	"binworld:gameboy/"

TRUE		=1
FALSE		=0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		section	juures,code
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

ahi_test:	movem.l	d2-d7/a2-a6,-(SP)		;stack!
		move.l	execbase,exec_base		;cache it locally.

		move.l	exec_base,a6
		lea	dos_name,a1
		moveq.l	#39,d0
		jsr	OpenLibrary(a6)
		move.l	d0,dos_base
		beq.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		open ahi
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		bsr.w	open_ahi
		move.l	d0,ahi_base
		beq.w	quit

		move.l	ahi_base,a6
		sub.l	a0,a0					;no tags.
		jsr	AHI_AllocAudioRequestA(a6)
		move.l	d0,ahi_request
;		beq.w	no_ahi_ctrl

		move.l	ahi_base,a6
		move.l	ahi_request,a0
		lea	ahi_requ_tags,a1
		jsr	AHI_AudioRequestA(a6)

		move.l	ahi_request,a0
		lea	ahi_alloc_tags,a1
		move.l	ahiam_AudioID(a0),4(a1)			;use selected mode.

		move.l	ahi_base,a6
		lea	ahi_alloc_tags,a1
		jsr	AHI_AllocAudioA(a6)
		move.l	d0,ahi_audio_ctrl
		beq.w	no_ahi_ctrl

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		load samples
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	smpl_info_I,a0
		move.l	#AHIST_M8S,ahisi_Type(a0)		;type.
		move.l	#smpl_I_bn,ahisi_Address(a0)		;address.
		move.l	#1024,ahisi_Length(a0)			;size.

		move.l	ahi_base,a6
		moveq.l	#0,d0					;sample number.
		move.l	#AHIST_SAMPLE,d1			;type.
		lea	smpl_info_I,a0				;info field.
		move.l	ahi_audio_ctrl,a2			;ctrl.
		jsr	AHI_LoadSound(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		play samples
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	ahi_base,a6
		lea	ahi_ctrl_tags_I,a1
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_ControlAudioA(a6)
;		tst.l	d0
;		bne.s	ahi_error_I

		move.l	ahi_base,a6
		moveq.l	#0,d0					;channel.
		move.l	#131000,d1				;freq.
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2				;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetFreq(a6)

		move.l	ahi_base,a6
		moveq.l	#0,d0					;channel.
		moveq.l	#0,d1					;sample.
		moveq.l	#1,d2					;offset.
		move.l	#0,d3					;size (full).
		moveq.l	#0,d4
		bset	#AHISB_IMM,d4				;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetSound(a6)

		move.l	ahi_base,a6
		moveq.l	#0,d0					;channel.
		move.l	#$10000,d1				;volume (max).
		move.l	#$8000,d2				;pan.
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3				;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetVol(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		quit ahi
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

jorma:		btst.b	#6,$bfe001
		bne.s	jorma

		move.l	ahi_base,a6
		move.l	ahi_request,a0
		jsr	AHI_FreeAudioRequest(a6)

		move.l	ahi_base,a6
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_FreeAudio(a6)

no_ahi_ctrl:	bsr.w	close_ahi

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		exit
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

quit:		move.l	exec_base,a6
		move.l	dos_base,d1
		beq.s	no_dos_base
		move.l	d1,a1
		jsr	CloseLibrary(a6)

no_dos_base:	movem.l	(SP)+,d2-d7/a2-a6		;unstack!
		moveq.l	#0,d0				;no errors.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		open ahi
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

open_ahi:	move.l	exec_base,a6
		jsr	CreateMsgPort(a6)

		move.l	d0,ahi_port
		beq.b	ahi_error

		move.l	d0,a0
		move.l	#AHIRequest_SIZEOF,d0
		jsr	CreateIORequest(a6)

		move.l	d0,ahi_ior
		beq.b	ahi_error

		lea	ahi_name,a0
		move.l	d0,a1
		clr.w	ahir_Version(a1)		;all versions are fine!
		move.l	#AHI_NO_UNIT,d0
		moveq.l	#0,d1
		jsr	OpenDevice(a6)

		move.l	d0,ahi_device
		bne.b	ahi_error

		move.l	ahi_ior,a0
		move.l	IO_DEVICE(a0),d0
		bra.s	ahi_exit

ahi_error:	moveq.l	#0,d0
ahi_exit:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		close ahi
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

close_ahi:	move.l	exec_base,a6
		tst.l	ahi_device
		bne.s	ahi_close_nd

		move.l	ahi_ior,a1
		jsr	CloseDevice(a6)

ahi_close_nd:	move.l	ahi_ior,d0
		beq.s	ahi_no_ior
		move.l	d0,a0
		jsr	DeleteIORequest(a6)

ahi_no_ior:	move.l	ahi_port,d0
		beq.s	ahi_no_msg_port
		move.l	d0,a0
		jsr	DeleteMsgPort(a6)

ahi_no_msg_port:rts
 
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		section	murrr,data
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

dos_name:	dc.b	"dos.library",0
		even

ahi_name:	dc.b	"ahi.device",0
		even

exec_base:	dc.l	0
dos_base:	dc.l	0

ahi_port:	dc.l	0
ahi_ior:	dc.l	0
ahi_device:	dc.l	0
ahi_audio_ctrl:	dc.l	0
ahi_request:	dc.l	0
ahi_base:	dc.l	0

ahi_alloc_tags:	dc.l	AHIA_AudioID,AHI_DEFAULT_ID
		dc.l	AHIA_MixFreq,4410
		dc.l	AHIA_Channels,4
		dc.l	AHIA_Sounds,4
		dc.l	TAG_END,0

ahi_requ_tags:	dc.l	AHIR_TitleText,ahi_title
		dc.l	AHIR_InitialMixFreq,4410
		dc.l	AHIR_DoMixFreq,TRUE
		dc.l	TAG_END,0

ahi_ctrl_tags_I:dc.l	AHIC_Play,TRUE
		dc.l	TAG_END,0

smpl_info_I:	ds.b	AHISampleInfo_SIZEOF

ahi_title:	dc.b	"Select a sound driver",0
		even

smpl_I_bn:	incbin	"samples/noise.smpl"
		even

		END
