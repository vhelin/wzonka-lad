		IFND	GFX_COMPARE_READBACK
GFX_COMPARE_READBACK =0
		ENDC
		IFND	GFX_PROFILE
		IFNE	GFX_COMPARE_READBACK
GFX_PROFILE	=1			;comparison results go in the profile.
		ELSE
GFX_PROFILE	=0
		ENDC
		ENDC

gfx_prof_planar	=0
gfx_prof_read	=12
gfx_prof_pens	=24
gfx_prof_scale	=36
gfx_prof_wait	=48
gfx_prof_upload	=60
gfx_prof_aga_bg	=72
gfx_prof_aga_win	=84
gfx_prof_aga_spr	=96
gfx_prof_aga_oam	=108
gfx_prof_aga_clear =120
gfx_prof_stages	=11

gfx_time_start:	MACRO
		IFNE	GFX_PROFILE
		bsr.w	gfx_profile_start
		ENDC
		ENDM

gfx_time_end:	MACRO
		IFNE	GFX_PROFILE
		move.w	ccr,-(SP)
		move.l	d1,-(SP)
		moveq.l	#\1,d1
		bsr.w	gfx_profile_end
		move.l	(SP)+,d1
		move.w	(SP)+,ccr
		ENDC
		ENDM

gfx_aga_line_start: MACRO
		IFNE	GFX_PROFILE
		tst.b	gfx_profile_aga_sample
		beq.s	gfx_aga_start_skip\@
		gfx_time_start
gfx_aga_start_skip\@:
		ENDC
		ENDM

gfx_aga_line_end: MACRO
		IFNE	GFX_PROFILE
		tst.b	gfx_profile_aga_sample
		beq.s	gfx_aga_end_skip\@
		gfx_time_end \1
gfx_aga_end_skip\@:
		ENDC
		ENDM

; Keep the enclosing sprite timestamp on the stack during each substage.
gfx_aga_part_start: MACRO
		IFNE	GFX_PROFILE
		tst.b	gfx_profile_aga_sample
		beq.s	gfx_aga_part_start_skip\@
		move.l	gfx_profile_start_lo,-(SP)
		gfx_time_start
gfx_aga_part_start_skip\@:
		ENDC
		ENDM

gfx_aga_part_end: MACRO
		IFNE	GFX_PROFILE
		tst.b	gfx_profile_aga_sample
		beq.s	gfx_aga_part_end_skip\@
		gfx_time_end \1
		move.l	(SP)+,gfx_profile_start_lo
gfx_aga_part_end_skip\@:
		ENDC
		ENDM
