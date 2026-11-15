
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound channel I sub routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
sound_I_0:	tst.b	sound_I_onf_master
		bne.s	sound_I_0_exit

		move.b	d6,(a2,d7.l)			;$ff10.
		move.b	#1,sound_I_f_envelope
sound_I_0_exit:	rts

		cnop	0,4
sound_I_1:	tst.b	sound_I_onf_master
		bne.s	sound_I_duty_exit

		move.b	d6,(a2,d7.l)			;$ff11.

		and.b	#%11000000,d6
		cmp.b	old_sound_I_duty,d6
		beq.w	sound_I_duty_exit

		move.b	d6,old_sound_I_duty

		movem.l	d0-d3/a0-a2,-(SP)

		move.l	ahi_base,a6
		moveq.l	#0,d0
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_UnloadSound(a6)

		move.l	smpl_info_I,a0
		moveq.l	#0,d7
		move.b	d6,d7
		lsr.b	#6,d7
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
		move.l	#131072,d1
		sub.l	sound_I_f,d2
		divu.l	d2,d1
		lsl.l	#3,d1
		and.l	#%111111111111111111,d1

		moveq.l	#0,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetFreq(a6)

		moveq.l	#0,d0
		moveq.l	#0,d1
		tst.l	sound_I_status
		bne.s	no_s_I_addz
		move.l	sound_I_v,d1
no_s_I_addz:	move.l	sound_I_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetVol(a6)

		movem.l	(SP)+,d0-d3/a0-a2

sound_I_duty_exit:
		rts

		cnop	0,4
sound_I_2:	tst.b	sound_I_onf_master
		bne.s	sound_I_2_exit

		move.b	d6,(a2,d7.l)			;$ff12.

		movem.l	d0-d3/a0-a2,-(SP)

		moveq.l	#0,d7
		move.b	d6,d7
		lsr.b	#4,d7
		lea	sound_env_volumes,a6
		move.l	(a6,d7.w*4),sound_I_v

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
		jsr	AHI_SetVol(a6)

		move.b	#1,sound_I_v_envelope

		movem.l	(SP)+,d0-d3/a0-a2
sound_I_2_exit:	rts

		cnop	0,4
sound_I_3:	tst.b	sound_I_onf_master
		bne.s	sound_I_3_exit

		move.b	d6,sound_I_fl			;$ff13.

		movem.l	d0-d2/a0-a2,-(SP)

		move.l	#2048,d2
		move.l	#131072,d1
		sub.l	sound_I_f,d2
		divu.l	d2,d1
		lsl.l	#3,d1
		and.l	#%111111111111111111,d1

		move.l	ahi_base,a6
		moveq.l	#0,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetFreq(a6)

		movem.l	(SP)+,d0-d2/a0-a2
sound_I_3_exit:	rts

		cnop	0,4
sound_I_4:	tst.b	sound_I_onf_master
		bne.s	sound_I_4_exit

		movem.l	d0-d2/a0-a2,-(SP)		;$ff14.

		move.l	ahi_base,a6

		move.b	d6,d0
		and.b	#%111,d6
		and.b	#%01000000,d0
		move.b	d6,sound_I_fh
		move.b	d0,(a2,d7.l)

		move.l	#2048,d2
		move.l	#131072,d1
		sub.l	sound_I_f,d2
		divu.l	d2,d1
		lsl.l	#3,d1
		and.l	#%111111111111111111,d1

		moveq.l	#0,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetFreq(a6)

		movem.l	(SP)+,d0-d2/a0-a2
sound_I_4_exit:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound channel II sub routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
sound_II_1:	tst.b	sound_II_onf_master
		bne.s	sound_II_duty_exit

		move.b	d6,(a2,d7.l)			;$ff16.

		and.b	#%11000000,d6
		cmp.b	old_sound_II_duty,d6
		beq.w	sound_II_duty_exit

		move.b	d6,old_sound_II_duty

		movem.l	d0-d3/a0-a2,-(SP)

		move.l	ahi_base,a6
		moveq.l	#1,d0
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_UnloadSound(a6)

		move.l	smpl_info_II,a0
		moveq.l	#0,d7
		move.b	d6,d7
		lsr.b	#6,d7
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
		move.l	#131072,d1
		sub.l	sound_II_f,d2
		divu.l	d2,d1
		lsl.l	#3,d1
		and.l	#%111111111111111111,d1

		moveq.l	#1,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetFreq(a6)

		moveq.l	#1,d0
		moveq.l	#0,d1
		tst.l	sound_II_status
		bne.s	no_s_II_addz
		move.l	sound_II_v,d1
no_s_II_addz:	move.l	sound_II_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetVol(a6)

		movem.l	(SP)+,d0-d3/a0-a2

sound_II_duty_exit:
		rts

		cnop	0,4
sound_II_2:	tst.b	sound_II_onf_master
		bne.s	sound_II_2_exit

		move.b	d6,(a2,d7.l)			;$ff17.

		movem.l	d0-d3/a0-a2,-(SP)

		moveq.l	#0,d7
		move.b	d6,d7
		lsr.b	#4,d7
		lea	sound_env_volumes,a6
		move.l	(a6,d7.w*4),sound_II_v

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
		jsr	AHI_SetVol(a6)

		move.b	#1,sound_II_v_envelope

		movem.l	(SP)+,d0-d3/a0-a2
sound_II_2_exit:rts

		cnop	0,4
sound_II_3:	tst.b	sound_II_onf_master
		bne.s	sound_II_3_exit

		move.b	d6,sound_II_fl			;$ff18.

		movem.l	d0-d2/a0-a2,-(SP)

		move.l	#131072,d1
		move.l	#2048,d2
		sub.l	sound_II_f,d2
		divu.l	d2,d1
		lsl.l	#3,d1
		and.l	#%111111111111111111,d1

		move.l	ahi_base,a6
		moveq.l	#1,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetFreq(a6)

		movem.l	(SP)+,d0-d2/a0-a2
sound_II_3_exit:rts

		cnop	0,4
sound_II_4:	tst.b	sound_II_onf_master
		bne.s	sound_II_4_exit

		movem.l	d0-d2/a0-a2,-(SP)		;$ff19.

		move.l	ahi_base,a6

		move.b	d6,d0
		and.b	#%111,d6
		and.b	#%01000000,d0
		move.b	d6,sound_II_fh
		move.b	d0,(a2,d7.l)

		move.l	#131072,d1
		move.l	#2048,d2
		sub.l	sound_II_f,d2
		divu.l	d2,d1
		lsl.l	#3,d1
		and.l	#%111111111111111111,d1

		moveq.l	#1,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetFreq(a6)

		movem.l	(SP)+,d0-d2/a0-a2
sound_II_4_exit:rts

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

		move.l	ahi_base,a6
		moveq.l	#2,d0
		moveq.l	#0,d1
		move.l	sound_III_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetVol(a6)

		movem.l	(SP)+,d0-d3/a0-a2
sound_III_0_exit:
		rts

		cnop	0,4
sound_III_on:	clr.b	sound_III_onf_bit

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
		jsr	AHI_SetVol(a6)

		movem.l	(SP)+,d0-d3/a0-a2
		rts

		cnop	0,4
sound_III_1:	tst.b	sound_III_onf_master
		bne.s	sound_III_1_exit

		move.b	d6,(a2,d7.l)			;$ff1b.
sound_III_1_exit:
		rts

		cnop	0,4
sound_III_2:	tst.b	sound_III_onf_master
		bne.s	sound_III_2_exit

		and.b	#%01100000,d6			;$ff1c.
		move.b	d6,(a2,d7.l)

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
		jsr	AHI_SetVol(a6)

		movem.l	(SP)+,d0-d3/a0-a2
sound_III_2_exit:
		rts

		cnop	0,4
sound_III_3:	tst.b	sound_III_onf_master
		bne.s	sound_III_3_exit

		move.b	d6,sound_III_fl			;$ff1d.

		movem.l	d0-d2/a0-a2,-(SP)

		move.l	#131072/2,d1
		move.l	#2048,d2
		sub.l	sound_III_f,d2
		divu.l	d2,d1
		lsl.l	#5,d1
		and.l	#%111111111111111111,d1

		move.l	ahi_base,a6
		moveq.l	#2,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetFreq(a6)

		movem.l	(SP)+,d0-d2/a0-a2
sound_III_3_exit:
		rts

		cnop	0,4
sound_III_4:	tst.b	sound_III_onf_master
		bne.s	sound_III_4_exit

		movem.l	d0-d2/a0-a2,-(SP)		;$ff1e.

		move.b	d6,d0
		and.b	#%111,d6
		and.b	#%01000000,d0
		move.b	d6,sound_III_fh
		move.b	d0,(a2,d7.l)

		move.l	#131072,d1
		move.l	#2048,d2
		sub.l	sound_III_f,d2
		divu.l	d2,d1
		lsl.l	#5,d1
		and.l	#%111111111111111111,d1

		move.l	ahi_base,a6
		moveq.l	#2,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetFreq(a6)

		movem.l	(SP)+,d0-d2/a0-a2
sound_III_4_exit:
		rts

		cnop	0,4
copy_snd_data:	move.b	d6,(a2,d7.l)			;copy the byte
							;to gb ram.
		sub.w	#$ff30,d7
		move.l	sound_III_lst,a6
		and.l	#$ff,d6
		move.w	(a6,d6.w*2),d6

		move.l	smpl_III_mem,a6
		move.w	d6,(a6,d7.w*2)			;expand the steps.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound channel IV sub routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
sound_IV_1:	tst.b	sound_IV_onf_master
		bne.s	sound_IV_1_exit

		move.b	d6,(a2,d7.l)			;$ff20.
sound_IV_1_exit:rts

		cnop	0,4
sound_IV_2:	tst.b	sound_IV_onf_master
		bne.s	sound_IV_2_exit

		move.b	d6,(a2,d7.l)			;$ff21.

		movem.l	d0-d3/a0-a2,-(SP)

		moveq.l	#0,d7
		move.b	d6,d7
		lsr.b	#4,d7
		lea	sound_env_volumes,a6
		move.l	(a6,d7.w*4),sound_IV_v

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
		jsr	AHI_SetVol(a6)

		move.b	#1,sound_I_v_envelope

		movem.l	(SP)+,d0-d3/a0-a2
sound_IV_2_exit:rts

		cnop	0,4
sound_IV_3:	tst.b	sound_IV_onf_master
		bne.s	sound_IV_3_exit

		move.b	d6,(a2,d7.l)			;$ff22.

		movem.l	d0-d3/a0-a2,-(SP)

		move.b	d6,d7

		lea	sound_4_freq_table,a0
		and.l	#%111,d6
		move.l	(a0,d6.w*4),d1

		lsr.b	#4,d7
		and.b	#%1111,d7
		addq.b	#1,d7
		lsr.l	d7,d1

		move.l	ahi_base,a6
		moveq.l	#3,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetFreq(a6)

		movem.l	(SP)+,d0-d3/a0-a2
sound_IV_3_exit:rts

		cnop	0,4
sound_IV_4:	tst.b	sound_IV_onf_master
		bne.s	sound_IV_4_exit

		and.b	#%01000000,d6			;$ff23.
		move.b	d6,(a2,d7.l)

		beq.s	sound_IV_4_kicked

		movem.l	d0-d3/a0-a2,-(SP)

		move.l	ahi_base,a6
		moveq.l	#3,d0
		moveq.l	#0,d1
		move.l	sound_IV_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetVol(a6)

		movem.l	(SP)+,d0-d3/a0-a2
sound_IV_4_exit:rts

sound_IV_4_kicked:
		movem.l	d0-d3/a0-a2,-(SP)

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
		jsr	AHI_SetVol(a6)

		movem.l	(SP)+,d0-d3/a0-a2
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound control routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
sound_V_0:	move.b	d6,(a2,d7.l)			;$ff24.

;		move.b	d6,sound_master_bits

		move.b	1(a2,d7.l),d6

sound_V_1:	move.b	d6,(a2,d7.l)			;$ff25.

		movem.l	d0-d3/a0-a2,-(SP)

		lea	pan_table,a6
		lea	onf_table,a2
		moveq.l	#0,d7

		move.b	d6,d7
		and.b	#%10001,d7
		move.b	d7,d0
		lsr.b	#3,d7
		and.b	#%1,d0
		or.b	d0,d7
		move.l	(a6,d7.w*4),sound_I_pan
		move.b	(a2,d7.w),sound_I_onf

		move.b	d6,d7
		and.b	#%100010,d7
		lsr.b	#1,d7
		move.b	d7,d0
		lsr.b	#3,d7
		and.b	#%1,d0
		or.b	d0,d7
		move.l	(a6,d7.w*4),sound_II_pan
		move.b	(a2,d7.w),sound_II_onf

		move.b	d6,d7
		and.b	#%1000100,d7
		lsr.b	#2,d7
		move.b	d7,d0
		lsr.b	#3,d7
		and.b	#%1,d0
		or.b	d0,d7
		move.l	(a6,d7.w*4),sound_III_pan
		move.b	(a2,d7.w),sound_III_onf

		and.l	#%10001000,d6
		lsr.b	#3,d6
		move.b	d6,d0
		lsr.b	#3,d6
		and.b	#%1,d0
		or.b	d0,d6
		move.l	(a6,d6.w*4),sound_IV_pan
		move.b	(a2,d6.w),sound_IV_onf

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
		jsr	AHI_SetVol(a6)

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
		jsr	AHI_SetVol(a6)

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
		jsr	AHI_SetVol(a6)

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
		jsr	AHI_SetVol(a6)

no_IV_vc:	movem.l	(SP)+,d0-d3/a0-a2
		rts

		cnop	0,4
sound_V_2:	and.b	#%10001111,d6			;$ff26.
		move.b	d6,(a2,d7.l)

		movem.l	d0-d3/a0-a2,-(SP)

		clr.b	sound_I_onf_master
		clr.b	sound_II_onf_master
		clr.b	sound_III_onf_master
		clr.b	sound_IV_onf_master

		btst	#7,d6
		bne.w	sounds_on_jmp

sound_V_off:	move.l	ahi_base,a6

		moveq.l	#0,d0
		moveq.l	#0,d1
		move.l	sound_I_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetVol(a6)

		moveq.l	#1,d0
		moveq.l	#0,d1
		move.l	sound_II_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetVol(a6)

		moveq.l	#2,d0
		moveq.l	#0,d1
		move.l	sound_III_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetVol(a6)

		moveq.l	#3,d0
		moveq.l	#0,d1
		move.l	sound_IV_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetVol(a6)

		move.b	#1,sound_I_onf_master
		move.b	#1,sound_II_onf_master
		move.b	#1,sound_III_onf_master
		move.b	#1,sound_IV_onf_master

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

		movem.l	(SP)+,d0-d3/a0-a2
		rts
