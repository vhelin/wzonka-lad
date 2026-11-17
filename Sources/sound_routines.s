
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound channel I sub routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
sound_I_0:	tst.b	sound_I_onf_master
		bne.s	sound_I_0_exit

		move.b	d6,(a2,d7.l)			;$ff10.
sound_I_0_exit:	rts

		cnop	0,4
sound_I_1:	tst.b	sound_I_onf_master
		bne.w	sound_I_duty_exit

		move.b	d6,(a2,d7.l)			;$ff11.
		move.l	d0,-(SP)
		moveq.l	#0,d0
		move.b	d6,d0
		and.b	#%00111111,d0
		neg.b	d0
		add.b	#64,d0
		move.b	d0,sound_I_length
		move.l	(SP)+,d0

		cmp.b	#2,snd_quality
		beq.w	sound_I_duty_exit

		and.b	#%11000000,d6
		lsr.b	#6,d6
		cmp.b	old_sound_I_duty,d6
		beq.w	sound_I_duty_exit

		move.b	d6,old_sound_I_duty

		movem.l	d0-d4/a0-a2,-(SP)

		move.l	ahi_base,a6
		moveq.l	#0,d0
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_UnloadSound(a6)

		move.l	smpl_info_I,a0
		moveq.l	#0,d7
		move.b	d6,d7
		lea	smpl_mem_1,a1
		move.l	(a1,d7.w*4),ahisi_Address(a0)	;address.

		moveq.l	#0,d0				;sample number.
		move.l	#AHIST_SAMPLE,d1		;type.
		move.l	smpl_info_I,a0			;info field.
		move.l	ahi_audio_ctrl,a2		;ctrl.
		jsr	AHI_LoadSound(a6)

		moveq.l	#0,d0				;channel.
		moveq.l	#0,d1				;sample.
		moveq.l	#0,d2				;offset.
		move.l	#8*512,d3			;size (full).
		moveq.l	#0,d4
		bset	#AHISB_IMM,d4			;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetSound(a6)

		move.l	#2048,d2
		move.l	#1048576,d1
		sub.l	sound_I_f,d2
		divu.l	d2,d1

		moveq.l	#0,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

		moveq.l	#0,d0
		moveq.l	#0,d1
		tst.l	sound_I_status
		bne.s	no_s_I_addz
		move.l	sound_I_v,d1
no_s_I_addz:	move.l	sound_I_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		movem.l	(SP)+,d0-d4/a0-a2

sound_I_duty_exit:
		rts

		cnop	0,4
sound_I_2:	tst.b	sound_I_onf_master
		bne.s	sound_I_2_exit

		move.b	d6,(a2,d7.l)			;$ff12.

		movem.l	d0-d3/a0-a2,-(SP)

		move.b	d6,d0
		and.b	#$F8,d0
		bne.s	sound_I_2_dac
		move.l	a2,a0
		add.l	#$ff00,a0
		bclr.b	#0,$26(a0)
		clr.b	sound_I_v_envelope
		clr.b	sound_I_f_envelope
		clr.l	sound_I_v
		cmp.b	#2,snd_quality
		beq.s	sound_I_2_dac

		move.l	ahi_base,a6
		moveq.l	#0,d0
		moveq.l	#0,d1
		tst.l	sound_I_status
		bne.s	no_s_I_addx
		move.l	sound_I_v,d1
no_s_I_addx:	move.l	sound_I_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

sound_I_2_dac:
		movem.l	(SP)+,d0-d3/a0-a2
sound_I_2_exit:	rts

		cnop	0,4
sound_I_3:	tst.b	sound_I_onf_master
		bne.s	sound_I_3_exit

		move.b	d6,sound_I_fl			;$ff13.
		move.b	d6,(a2,d7.l)
		cmp.b	#2,snd_quality
		beq.s	sound_I_3_exit

		movem.l	d0-d2/a0-a2,-(SP)

		move.l	#2048,d2
		move.l	#1048576,d1
		sub.l	sound_I_f,d2
		divu.l	d2,d1

		move.l	ahi_base,a6
		moveq.l	#0,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

		movem.l	(SP)+,d0-d2/a0-a2
sound_I_3_exit:	rts

		cnop	0,4
sound_I_4:	tst.b	sound_I_onf_master
		bne.w	sound_I_4_exit

		movem.l	d0-d3/a0-a2,-(SP)		;$ff14.

		move.b	d6,d3
		and.b	#%111,d6
		move.b	d6,sound_I_fh
		move.b	d3,d6
		and.b	#%01000111,d6
		move.b	d6,(a2,d7.l)

		tst.b	d3
		bpl.w	sound_I_4_freq

		tst.b	sound_I_length
		bne.s	sound_I_4_len
		move.b	#64,sound_I_length
sound_I_4_len:	move.b	#1,sound_I_v_envelope
		move.l	a2,a0
		add.l	d7,a0
		moveq.l	#0,d0
		move.b	-2(a0),d0
		move.b	d0,d2
		and.b	#$F8,d2
		beq.s	sound_I_4_nodac
		bset.b	#0,$12(a0)
sound_I_4_nodac:
		lsr.b	#4,d0
		lea	sound_env_volumes,a0
		move.l	(a0,d0.w*4),sound_I_v

		bsr.w	sound_sweep_trigger

sound_I_4_freq:	cmp.b	#2,snd_quality
		beq.w	sound_I_4_restore
		move.l	#2048,d2
		move.l	#1048576,d1
		sub.l	sound_I_f,d2
		divu.l	d2,d1

		move.l	ahi_base,a6
		moveq.l	#0,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

		tst.b	d3
		bpl.w	sound_I_4_restore

		moveq.l	#0,d0
		moveq.l	#0,d1
		tst.l	sound_I_status
		bne.s	sound_I_4_nov
		move.l	sound_I_v,d1
sound_I_4_nov:	move.l	sound_I_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

sound_I_4_restore:
		movem.l	(SP)+,d0-d3/a0-a2
sound_I_4_exit:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound channel II sub routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
sound_II_1:	tst.b	sound_II_onf_master
		bne.w	sound_II_duty_exit

		move.b	d6,(a2,d7.l)			;$ff16.
		move.l	d0,-(SP)
		moveq.l	#0,d0
		move.b	d6,d0
		and.b	#%00111111,d0
		neg.b	d0
		add.b	#64,d0
		move.b	d0,sound_II_length
		move.l	(SP)+,d0

		cmp.b	#2,snd_quality
		beq.w	sound_II_duty_exit

		and.b	#%11000000,d6
		lsr.b	#6,d6
		cmp.b	old_sound_II_duty,d6
		beq.w	sound_II_duty_exit

		move.b	d6,old_sound_II_duty

		movem.l	d0-d4/a0-a2,-(SP)

		move.l	ahi_base,a6
		moveq.l	#1,d0
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_UnloadSound(a6)

		move.l	smpl_info_II,a0
		moveq.l	#0,d7
		move.b	d6,d7
		lea	smpl_mem_1,a1
		move.l	(a1,d7.w*4),ahisi_Address(a0)	;address.

		moveq.l	#1,d0				;sample number.
		move.l	#AHIST_SAMPLE,d1		;type.
		move.l	smpl_info_II,a0			;info field.
		move.l	ahi_audio_ctrl,a2		;ctrl.
		jsr	AHI_LoadSound(a6)

		moveq.l	#1,d0				;channel.
		moveq.l	#1,d1				;sample.
		moveq.l	#0,d2				;offset.
		move.l	#8*512,d3			;size (full).
		moveq.l	#0,d4
		bset	#AHISB_IMM,d4			;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetSound(a6)

		move.l	#2048,d2
		move.l	#1048576,d1
		sub.l	sound_II_f,d2
		divu.l	d2,d1

		moveq.l	#1,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

		moveq.l	#1,d0
		moveq.l	#0,d1
		tst.l	sound_II_status
		bne.s	no_s_II_addz
		move.l	sound_II_v,d1
no_s_II_addz:	move.l	sound_II_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		movem.l	(SP)+,d0-d4/a0-a2

sound_II_duty_exit:
		rts

		cnop	0,4
sound_II_2:	tst.b	sound_II_onf_master
		bne.s	sound_II_2_exit

		move.b	d6,(a2,d7.l)			;$ff17.

		movem.l	d0-d3/a0-a2,-(SP)

		move.b	d6,d0
		and.b	#$F8,d0
		bne.s	sound_II_2_dac
		move.l	a2,a0
		add.l	#$ff00,a0
		bclr.b	#1,$26(a0)
		clr.b	sound_II_v_envelope
		clr.l	sound_II_v
		cmp.b	#2,snd_quality
		beq.s	sound_II_2_dac

		move.l	ahi_base,a6
		moveq.l	#1,d0
		moveq.l	#0,d1
		tst.l	sound_II_status
		bne.s	no_s_II_addx
		move.l	sound_II_v,d1
no_s_II_addx:	move.l	sound_II_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

sound_II_2_dac:
		movem.l	(SP)+,d0-d3/a0-a2
sound_II_2_exit:rts

		cnop	0,4
sound_II_3:	tst.b	sound_II_onf_master
		bne.s	sound_II_3_exit

		move.b	d6,sound_II_fl			;$ff18.
		move.b	d6,(a2,d7.l)
		cmp.b	#2,snd_quality
		beq.s	sound_II_3_exit

		movem.l	d0-d2/a0-a2,-(SP)

		move.l	#1048576,d1
		move.l	#2048,d2
		sub.l	sound_II_f,d2
		divu.l	d2,d1

		move.l	ahi_base,a6
		moveq.l	#1,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

		movem.l	(SP)+,d0-d2/a0-a2
sound_II_3_exit:rts

		cnop	0,4
sound_II_4:	tst.b	sound_II_onf_master
		bne.w	sound_II_4_exit

		movem.l	d0-d3/a0-a2,-(SP)		;$ff19.

		move.b	d6,d3
		and.b	#%111,d6
		move.b	d6,sound_II_fh
		move.b	d3,d6
		and.b	#%01000111,d6
		move.b	d6,(a2,d7.l)

		tst.b	d3
		bpl.w	sound_II_4_freq

		tst.b	sound_II_length
		bne.s	sound_II_4_len
		move.b	#64,sound_II_length
sound_II_4_len:	move.b	#1,sound_II_v_envelope
		move.l	a2,a0
		add.l	d7,a0
		moveq.l	#0,d0
		move.b	-2(a0),d0
		move.b	d0,d2
		and.b	#$F8,d2
		beq.s	sound_II_4_nodac
		bset.b	#1,$0D(a0)
sound_II_4_nodac:
		lsr.b	#4,d0
		lea	sound_env_volumes,a0
		move.l	(a0,d0.w*4),sound_II_v

sound_II_4_freq:	cmp.b	#2,snd_quality
		beq.w	sound_II_4_restore
		move.l	#2048,d2
		move.l	#1048576,d1
		sub.l	sound_II_f,d2
		divu.l	d2,d1

		move.l	ahi_base,a6
		moveq.l	#1,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

		tst.b	d3
		bpl.w	sound_II_4_restore

		moveq.l	#1,d0
		moveq.l	#0,d1
		tst.l	sound_II_status
		bne.s	sound_II_4_nov
		move.l	sound_II_v,d1
sound_II_4_nov:	move.l	sound_II_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

sound_II_4_restore:
		movem.l	(SP)+,d0-d3/a0-a2
sound_II_4_exit:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound channel III sub routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
sound_III_0:	tst.b	sound_III_onf_master
		bne.s	sound_III_0_exit

		and.b	#%10000000,d6			;$ff1a.
		move.b	d6,(a2,d7.l)

		bne.s	sound_III_on

sound_III_off:	movem.l	d0-d3/a0-a2,-(SP)

		move.b	#1,sound_III_onf_bit

		move.l	a2,a0
		add.l	#$ff00,a0
		bclr.b	#2,$26(a0)
		cmp.b	#2,snd_quality
		beq.s	sound_III_off_pop

		move.l	ahi_base,a6
		moveq.l	#2,d0
		moveq.l	#0,d1
		move.l	sound_III_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

sound_III_off_pop:
		movem.l	(SP)+,d0-d3/a0-a2
sound_III_0_exit:
		rts

		cnop	0,4
sound_III_on:	clr.b	sound_III_onf_bit

		cmp.b	#2,snd_quality
		beq.s	sound_III_0_exit

		movem.l	d0-d3/a0-a2,-(SP)

		move.l	ahi_base,a6
		moveq.l	#2,d0
		moveq.l	#0,d1
		tst.l	sound_III_status
		bne.s	no_s_III_addq
		move.l	sound_III_v,d1
no_s_III_addq:	move.l	sound_III_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		movem.l	(SP)+,d0-d3/a0-a2
		rts

		cnop	0,4
sound_III_1:	tst.b	sound_III_onf_master
		bne.s	sound_III_1_exit

		move.b	d6,(a2,d7.l)			;$ff1b.
		move.l	d0,-(SP)
		moveq.l	#0,d0
		move.b	d6,d0
		move.w	#256,sound_III_length
		sub.w	d0,sound_III_length
		move.l	(SP)+,d0
sound_III_1_exit:
		rts

		cnop	0,4
sound_III_2:	tst.b	sound_III_onf_master
		bne.s	sound_III_2_exit

		and.b	#%01100000,d6			;$ff1c.
		move.b	d6,(a2,d7.l)
		cmp.b	#2,snd_quality
		beq.s	sound_III_2_exit

		movem.l	d0-d3/a0-a2,-(SP)

		lsr.b	#3,d6
		and.l	#%1100,d6
		lea	sound_III_vol,a1
		move.l	(a1,d6.w),sound_III_v

		move.l	ahi_base,a6
		moveq.l	#2,d0
		moveq.l	#0,d1
		tst.l	sound_III_status
		bne.s	no_s_III_addp
		move.l	sound_III_v,d1
no_s_III_addp:	move.l	sound_III_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		movem.l	(SP)+,d0-d3/a0-a2
sound_III_2_exit:
		rts

		cnop	0,4
sound_III_3:	tst.b	sound_III_onf_master
		bne.s	sound_III_3_exit

		move.b	d6,sound_III_fl			;$ff1d.
		move.b	d6,(a2,d7.l)
		cmp.b	#2,snd_quality
		beq.s	sound_III_3_exit

		movem.l	d0-d2/a0-a2,-(SP)

		move.l	#2097152,d1
		move.l	#2048,d2
		sub.l	sound_III_f,d2
		divu.l	d2,d1

		move.l	ahi_base,a6
		moveq.l	#2,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

		movem.l	(SP)+,d0-d2/a0-a2
sound_III_3_exit:
		rts

		cnop	0,4
sound_III_4:	tst.b	sound_III_onf_master
		bne.w	sound_III_4_exit

		movem.l	d0-d3/a0-a2,-(SP)		;$ff1e.

		move.b	d6,d3
		and.b	#%111,d6
		move.b	d6,sound_III_fh
		move.b	d3,d6
		and.b	#%01000111,d6
		move.b	d6,(a2,d7.l)

		cmp.b	#2,snd_quality
		beq.s	sound_III_4_trigger
		move.l	#2097152,d1
		move.l	#2048,d2
		sub.l	sound_III_f,d2
		divu.l	d2,d1

		move.l	ahi_base,a6
		moveq.l	#2,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

sound_III_4_trigger:
		tst.b	d3
		bpl.w	sound_III_4_restore

		tst.w	sound_III_length
		bne.s	sound_III_4_len
		move.w	#256,sound_III_length
sound_III_4_len:
		move.l	gb_memory,a0
		add.l	#$ff00,a0
		btst.b	#7,$1a(a0)
		beq.s	sound_III_4_nodac
		bset.b	#2,$26(a0)
sound_III_4_nodac:
		cmp.b	#2,snd_quality
		beq.s	sound_III_4_restore
		moveq.l	#2,d0
		moveq.l	#0,d1
		tst.l	sound_III_status
		bne.s	sound_III_4_nov
		move.l	sound_III_v,d1
sound_III_4_nov:	move.l	sound_III_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

sound_III_4_restore:
		movem.l	(SP)+,d0-d3/a0-a2
sound_III_4_exit:
		rts

		cnop	0,4
copy_snd_data:	move.b	d6,(a2,d7.l)			;copy the byte
							;to gb ram.
		cmp.b	#2,snd_quality
		beq.s	copy_snd_exit
		sub.w	#$ff30,d7
		move.l	sound_III_lst,a6
		and.l	#$ff,d6
		move.w	(a6,d6.w*2),d6

		move.l	smpl_III_mem,a6
		move.w	d6,(a6,d7.w*2)			;expand the steps.
copy_snd_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound channel IV sub routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
sound_IV_1:	tst.b	sound_IV_onf_master
		bne.s	sound_IV_1_exit

		move.b	d6,(a2,d7.l)			;$ff20.
		move.l	d0,-(SP)
		moveq.l	#0,d0
		move.b	d6,d0
		and.b	#%00111111,d0
		neg.b	d0
		add.b	#64,d0
		move.b	d0,sound_IV_length
		move.l	(SP)+,d0
sound_IV_1_exit:rts

		cnop	0,4
sound_IV_2:	tst.b	sound_IV_onf_master
		bne.s	sound_IV_2_exit

		move.b	d6,(a2,d7.l)			;$ff21.

		movem.l	d0-d3/a0-a2,-(SP)

		move.b	d6,d0
		and.b	#$F8,d0
		bne.s	sound_IV_2_dac
		move.l	a2,a0
		add.l	#$ff00,a0
		bclr.b	#3,$26(a0)
		clr.b	sound_IV_v_envelope
		clr.l	sound_IV_v
		cmp.b	#2,snd_quality
		beq.s	sound_IV_2_dac

		move.l	ahi_base,a6
		moveq.l	#3,d0
		moveq.l	#0,d1
		tst.l	sound_IV_status
		bne.s	no_s_IV_addx
		move.l	sound_IV_v,d1
no_s_IV_addx:	move.l	sound_IV_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

sound_IV_2_dac:
		movem.l	(SP)+,d0-d3/a0-a2
sound_IV_2_exit:rts

		cnop	0,4
sound_IV_3:	tst.b	sound_IV_onf_master
		bne.s	sound_IV_3_exit

		move.b	d6,(a2,d7.l)			;$ff22.
		cmp.b	#2,snd_quality
		beq.w	sound_IV_3_exit

		movem.l	d0-d3/a0-a2,-(SP)

		move.b	d6,d7

		btst	#3,d6
		sne	d0
		cmp.b	old_sound_IV_width,d0
		beq.s	sound_IV_3_pitch
		move.b	d0,old_sound_IV_width
		bsr.w	load_noise_sample
sound_IV_3_pitch:
		lea	sound_4_freq_table,a0
		and.l	#%111,d6
		move.l	(a0,d6.w*4),d1

		lsr.b	#4,d7
		and.b	#%1111,d7
		lsr.l	d7,d1
		cmp.b	#14,d7
		blo.s	sound_IV_3_rate
		moveq.l	#0,d1
sound_IV_3_rate:

		move.l	ahi_base,a6
		moveq.l	#3,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

		movem.l	(SP)+,d0-d3/a0-a2
sound_IV_3_exit:rts

load_noise_sample:
		movem.l	d0-d5/a0-a5,-(SP)
		tst.b	snd_chnlIV
		bne.w	load_noise_pop
		tst.l	ahi_audio_ctrl
		beq.w	load_noise_pop
		move.b	d0,d3
		move.l	ahi_base,a6
		moveq.l	#3,d0
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_UnloadSound(a6)

		move.l	smpl_info_IV,a0
		move.l	smpl_IV_mem,d0
		move.l	#32767,d4
		tst.b	d3
		beq.s	load_noise_long
		move.l	smpl_IV_short,d0
		moveq.l	#127,d4
load_noise_long:
		move.l	d0,ahisi_Address(a0)
		move.l	d4,ahisi_Length(a0)

		moveq.l	#3,d0
		move.l	#AHIST_SAMPLE,d1
		move.l	smpl_info_IV,a0
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_LoadSound(a6)

		moveq.l	#3,d0
		moveq.l	#3,d1
		moveq.l	#0,d2
		move.l	d4,d3
		moveq.l	#0,d4
		bset	#AHISB_IMM,d4
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetSound(a6)
load_noise_pop:
		movem.l	(SP)+,d0-d5/a0-a5
		rts

		cnop	0,4
sound_IV_4:	tst.b	sound_IV_onf_master
		bne.w	sound_IV_4_exit

		movem.l	d0-d3/a0-a2,-(SP)		;$ff23.

		move.b	d6,d3
		and.b	#%01000000,d6
		move.b	d6,(a2,d7.l)
		tst.b	d3
		bpl.w	sound_IV_4_restore

		tst.b	sound_IV_length
		bne.s	sound_IV_4_len
		move.b	#64,sound_IV_length
sound_IV_4_len:	move.b	#1,sound_IV_v_envelope
		move.l	a2,a0
		add.l	d7,a0
		moveq.l	#0,d0
		move.b	-2(a0),d0
		move.b	d0,d2
		and.b	#$F8,d2
		beq.s	sound_IV_4_nodac
		bset.b	#3,$03(a0)
sound_IV_4_nodac:
		lsr.b	#4,d0
		lea	sound_env_volumes,a0
		move.l	(a0,d0.w*4),sound_IV_v

		cmp.b	#2,snd_quality
		beq.s	sound_IV_4_restore

		move.l	ahi_base,a6
		moveq.l	#3,d0
		moveq.l	#0,d1
		tst.l	sound_IV_status
		bne.s	no_s_IV_addt
		move.l	sound_IV_v,d1
no_s_IV_addt:	move.l	sound_IV_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

sound_IV_4_restore:
		movem.l	(SP)+,d0-d3/a0-a2
sound_IV_4_exit:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound control routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
sound_V_0:	btst.b	#7,$ff26(a2)
		beq.w	sound_V_exit
		move.b	d6,(a2,d7.l)			;$ff24.
		cmp.b	#2,snd_quality
		beq.w	sound_V_exit

;		move.b	d6,sound_master_bits

		move.b	1(a2,d7.l),d6
		bra.s	sound_V_update

sound_V_1:	btst.b	#7,$ff26(a2)
		beq.w	sound_V_exit
		move.b	d6,(a2,d7.l)			;$ff25.
		cmp.b	#2,snd_quality
		beq.w	sound_V_exit

sound_V_update:
		movem.l	d0-d3/a0-a2,-(SP)

		bsr.w	sound_update_mixer

sounds_on_jmp:	move.l	ahi_base,a6

		tst.b	snd_chnlI
		bne.s	no_I_vc

		moveq.l	#0,d0
		moveq.l	#0,d1
		tst.l	sound_I_status
		bne.s	no_s_I_add
		move.l	sound_I_v,d1
no_s_I_add:	move.l	sound_I_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

no_I_vc:	tst.b	snd_chnlII
		bne.s	no_II_vc

		moveq.l	#1,d0
		moveq.l	#0,d1
		tst.l	sound_II_status
		bne.s	no_s_II_add
		move.l	sound_II_v,d1
no_s_II_add:	move.l	sound_II_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

no_II_vc:	tst.b	snd_chnlIII
		bne.s	no_III_vc

		moveq.l	#2,d0
		moveq.l	#0,d1
		tst.l	sound_III_status
		bne.s	no_s_III_add
		move.l	sound_III_v,d1
no_s_III_add:	move.l	sound_III_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

no_III_vc:	tst.b	snd_chnlIV
		bne.s	no_IV_vc

		moveq.l	#3,d0
		moveq.l	#0,d1
		tst.l	sound_IV_status
		bne.s	no_s_IV_add
		move.l	sound_IV_v,d1
no_s_IV_add:	move.l	sound_IV_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

no_IV_vc:	movem.l	(SP)+,d0-d3/a0-a2
		rts

		cnop	0,4
sound_V_2:	movem.l	d0-d3/a0-a2,-(SP)		;$ff26.
		move.b	(a2,d7.l),d0
		btst	#7,d6
		beq.w	sound_V_off
		btst	#7,d0
		bne.s	sound_V_keep
		move.b	#$F0,(a2,d7.l)
		clr.b	sound_I_onf_master
		clr.b	sound_II_onf_master
		clr.b	sound_III_onf_master
		clr.b	sound_IV_onf_master
		cmp.b	#2,snd_quality
		beq.s	sound_V_keep
		bra.w	sounds_on_jmp
sound_V_keep:	movem.l	(SP)+,d0-d3/a0-a2
		rts

sound_V_off:	move.b	#$70,(a2,d7.l)
		cmp.b	#2,snd_quality
		beq.w	sound_V_off_state
		move.l	ahi_base,a6

		moveq.l	#0,d0
		moveq.l	#0,d1
		move.l	sound_I_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		moveq.l	#1,d0
		moveq.l	#0,d1
		move.l	sound_II_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		moveq.l	#2,d0
		moveq.l	#0,d1
		move.l	sound_III_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		moveq.l	#3,d0
		moveq.l	#0,d1
		move.l	sound_IV_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

sound_V_off_state:
		move.b	#1,sound_I_onf_master
		move.b	#1,sound_II_onf_master
		move.b	#1,sound_III_onf_master
		move.b	#1,sound_IV_onf_master

		clr.b	sound_I_v_envelope
		clr.b	sound_II_v_envelope
		clr.b	sound_IV_v_envelope
		clr.b	sound_I_f_envelope
		clr.l	sound_I_v
		clr.l	sound_II_v
		clr.l	sound_III_v
		clr.l	sound_IV_v

		move.l	gb_memory,a0			;reset the sound registers.
		add.l	#$ff00,a0

		clr.b	$10(a0)
		clr.b	$11(a0)
		clr.b	$12(a0)
		clr.b	$13(a0)
		clr.b	$14(a0)

		clr.b	$16(a0)
		clr.b	$17(a0)
		clr.b	$18(a0)
		clr.b	$19(a0)

		clr.b	$1a(a0)
		clr.b	$1b(a0)
		clr.b	$1c(a0)
		clr.b	$1d(a0)
		clr.b	$1e(a0)

		clr.b	$20(a0)
		clr.b	$21(a0)
		clr.b	$22(a0)
		clr.b	$23(a0)
		clr.b	$24(a0)
		clr.b	$25(a0)
		clr.b	sound_I_length
		clr.b	sound_II_length
		clr.w	sound_III_length
		clr.b	sound_IV_length
		clr.l	sound_I_f
		clr.l	sound_II_f
		clr.l	sound_III_f
		bsr.w	sound_update_mixer

		movem.l	(SP)+,d0-d3/a0-a2
sound_V_exit:
		rts

sound_update_mixer:
		movem.l	d0-d7/a0-a3,-(SP)
		move.l	gb_memory,a0
		add.l	#$ff24,a0
		moveq.l	#0,d4
		move.b	(a0),d4
		move.l	d4,d5
		lsr.b	#4,d4
		and.l	#7,d4
		and.l	#7,d5
		addq.l	#1,d4
		addq.l	#1,d5
		moveq.l	#0,d6
		move.b	1(a0),d6
		lea	sound_I_pan,a1
		lea	sound_I_gain,a2
		lea	sound_I_onf,a3
		moveq.l	#3,d7
sound_mix_channel:
		moveq.l	#0,d0
		moveq.l	#0,d1
		btst	#4,d6
		beq.s	sound_mix_right
		move.l	d4,d0
sound_mix_right:
		btst	#0,d6
		beq.s	sound_mix_sum
		move.l	d5,d1
sound_mix_sum:	move.l	d0,d2
		add.l	d1,d2
		beq.s	sound_mix_off
		clr.b	(a3)
		lsl.l	#8,d1
		lsl.l	#8,d1
		divu.l	d2,d1
		move.l	d1,(a1)+
;		AHI pans linearly; keep each output at the same level when centered.
		lsl.l	#8,d2
		lsl.l	#4,d2
		move.l	d2,(a2)+
		bra.s	sound_mix_next
sound_mix_off:	move.b	#1,(a3)
		move.l	#$8000,(a1)+
		clr.l	(a2)+
sound_mix_next:
		addq.l	#4,a3
		lsr.b	#1,d6
		dbra	d7,sound_mix_channel
		movem.l	(SP)+,d0-d7/a0-a3
		rts

sound_set_volume:
		movem.l	d4/a0,-(SP)
		lea	sound_I_pan,a0
		move.l	(a0,d0.w*4),d2
		move.l	gb_memory,a0
		add.l	#$ff26,a0
		btst.b	#7,(a0)
		beq.s	sound_volume_off
		btst	d0,(a0)
		beq.s	sound_volume_off
		lea	sound_I_gain,a0
		move.l	(a0,d0.w*4),d4
		cmp.l	#$10000,d4
		beq.s	sound_volume_pan
		mulu.l	d4,d1
		swap	d1
		and.l	#$ffff,d1
sound_volume_pan:
		lea	sound_I_pan,a0
		move.l	(a0,d0.w*4),d2
		bra.s	sound_volume_play
sound_volume_off:
		moveq.l	#0,d1
sound_volume_play:
		movem.l	(SP)+,d4/a0
		jsr	AHI_SetVol(a6)
		rts

sound_set_frequency:
;		AHI 4.180 overflows 2^20 and 2^21 Hz to a zero step with FreqOK set,
;		hanging its interrupt mixer. Pause these ultrasonic tones instead.
		cmp.l	#$100000,d1
		bcs.s	sound_frequency_play
		moveq.l	#0,d1
sound_frequency_play:
		jsr	AHI_SetFreq(a6)
		rts

sound_sweep_trigger:
		movem.l	d0-d3/a0,-(SP)
		move.l	sound_I_f,d0
		and.l	#$7ff,d0
		move.l	d0,sound_I_f_initial_frequency
		clr.b	sound_I_f_envelope
		move.l	gb_memory,a0
		add.l	#$ff10,a0
		moveq.l	#0,d0
		move.b	(a0),d0
		move.l	d0,d1
		and.l	#$77,d1
		beq.s	sound_sweep_trigger_pop
		move.b	#2,sound_I_f_envelope
		move.l	d0,d1
		lsr.b	#4,d1
		and.l	#7,d1
		bne.s	sound_sweep_trigger_period
		moveq.l	#8,d1
sound_sweep_trigger_period:
		mulu.w	#72,d1
		move.l	d1,sound_I_f_envelope_counter_base
		move.l	d1,sound_I_f_envelope_counter
		and.b	#7,d0
		beq.s	sound_sweep_trigger_pop
		bsr.s	sound_sweep_calculate
		cmp.l	#2047,d0
		bls.s	sound_sweep_trigger_pop
		bsr.s	sound_sweep_disable
sound_sweep_trigger_pop:
		movem.l	(SP)+,d0-d3/a0
		rts

sound_sweep_calculate:
		move.l	gb_memory,a0
		add.l	#$ff10,a0
		move.l	sound_I_f_initial_frequency,d0
		move.l	d0,d1
		moveq.l	#0,d2
		move.b	(a0),d2
		and.b	#7,d2
		lsr.l	d2,d1
		btst.b	#3,(a0)
		beq.s	sound_sweep_add
		sub.l	d1,d0
		rts
sound_sweep_add:
		add.l	d1,d0
		rts

sound_sweep_disable:
		clr.b	sound_I_f_envelope
		clr.b	sound_I_v_envelope
		clr.l	sound_I_v
		move.l	gb_memory,a0
		add.l	#$ff26,a0
		bclr.b	#0,(a0)
		rts

sound_restore_state:
		movem.l	d0-d3/a0-a2,-(SP)
		move.l	gb_memory,a0
		add.l	#$ff00,a0
		btst.b	#7,$26(a0)
		beq.w	sound_V_keep
		lea	sound_env_volumes,a1
		moveq.l	#0,d0
		move.b	$12(a0),d0
		lsr.b	#4,d0
		move.l	(a1,d0.w*4),sound_I_v
		moveq.l	#0,d0
		move.b	$17(a0),d0
		lsr.b	#4,d0
		move.l	(a1,d0.w*4),sound_II_v
		moveq.l	#0,d0
		move.b	$21(a0),d0
		lsr.b	#4,d0
		move.l	(a1,d0.w*4),sound_IV_v
		clr.b	sound_I_v_envelope
		clr.b	sound_II_v_envelope
		clr.b	sound_IV_v_envelope
		btst.b	#0,$26(a0)
		beq.s	sound_restore_II
		move.b	#1,sound_I_v_envelope
		bsr.w	sound_sweep_trigger
sound_restore_II:
		btst.b	#1,$26(a0)
		beq.s	sound_restore_IV
		move.b	#1,sound_II_v_envelope
sound_restore_IV:
		btst.b	#3,$26(a0)
		beq.s	sound_restore_mixer
		move.b	#1,sound_IV_v_envelope
sound_restore_mixer:
		bsr.w	sound_update_mixer
		cmp.b	#2,snd_quality
		beq.w	sound_V_keep
		bra.w	sounds_on_jmp
