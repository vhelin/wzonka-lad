;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound emulation routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

do_sounds:	movem.l	d0-d7/a0-a6,-(SP)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		channel three
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	gb_memory,a0
		add.l	#$ff1a,a0
		btst.b	#7,(a0)
		beq.w	no_sound_III		

		move.l	ahi_base,a6
		moveq.l	#0,d0				;sound.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_UnLoadSound(a6)

		move.l	gb_memory,a1
		add.l	#$ff30,a1
		lea	smpl_I_bn,a2
		moveq.l	#16-1,d0
sound_III_de:	move.b	(a1)+,d1
		move.b	d1,d2
		lsr.b	#4,d1
		lsl.b	#4,d1
		sub.b	#$ff/2,d1
		move.b	d1,(a2)+

		and.b	#%1111,d2
		lsl.b	#4,d2
		sub.b	#$ff/2,d2
		move.b	d2,(a2)+
		dbra	d0,sound_III_de

		move.l	ahi_base,a6
		moveq.l	#0,d0				;sample number.
		move.l	#AHIST_DYNAMICSAMPLE,d1		;type.
		lea	smpl_info_I,a0			;info field.
		move.l	ahi_audio_ctrl,a2		;ctrl.
		jsr	AHI_LoadSound(a6)

		move.l	gb_memory,a0
		add.l	#$ff1e,a0
		moveq.l	#0,d2
		move.b	(a0),d2
		and.b	#%111,d2
		lsl.w	#8,d2
		subq.l	#1,a0
		move.b	(a0),d2
		move.l	#4194304,d1
		move.l	#2048,d3
		sub.l	d2,d3
		lsl.l	#5,d3
		divu.l	d3,d1				;d1 = frequency.

		move.l	ahi_base,a6
		moveq.l	#0,d0				;channel.
;		move.l	#100,d1				;freq.
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2			;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetFreq(a6)

		move.l	gb_memory,a0
		add.l	#$ff1c,a0
		moveq.l	#0,d1
		move.b	(a0),d1
		lsr.b	#5,d1
		and.b	#%11,d1
		lea	channel_III_vol,a1
		move.l	(a1,d1.l*4),d1			;new volume.

		move.l	ahi_base,a6
		moveq.l	#0,d0				;channel.
;		move.l	#$10000,d1			;volume (max).
		move.l	#$8000,d2			;pan.
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3			;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetVol(a6)
		bra.s	sound_III_done

no_sound_III:	move.l	ahi_base,a6
		moveq.l	#0,d0				;channel.
		move.l	#0,d1				;volume (min).
		move.l	#$8000,d2			;pan.
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3			;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetVol(a6)

sound_III_done:	

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		exit from the sound emulation
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		movem.l	(SP)+,d0-d7/a0-a6
		rts

