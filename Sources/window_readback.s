; The Window bitmap is owned by Wzonka-Lad. Keep capture coordinates and
; output pen indices identical to ReadPixelArray8; do not remap palettes here.
window_read_pixels:
		IFNE	GFX_COMPARE_READBACK
		movem.l	d0-d1,-(SP)
		jsr	ReadPixelArray8(a6)
		movem.l	(SP)+,d0-d1
		lea	window_readback_check,a2
		bsr.w	window_planar_to_pens
		move.l	game_array,a0
		lea	window_readback_check,a1
		IFNE	GFX_PROFILE
		addq.l	#1,gfx_profile_checked
		ENDC
		move.w	#160*144/4-1,d0
window_readback_compare:
		move.l	(a0)+,d1
		cmp.l	(a1)+,d1
		bne.s	window_readback_mismatch
		dbra	d0,window_readback_compare
		bra.w	read_pixels_ready
window_readback_mismatch:
		IFNE	GFX_PROFILE
		addq.l	#1,gfx_profile_mismatches
		ENDC
		ELSE
		bsr.w	window_planar_to_pens
		ENDC
		bra.w	read_pixels_ready

; Native output and exact 2x expansion do not need a Y resampling pass.
window_try_fused:
		tst.b	cache_graphics
		beq.s	window_fused_unavailable
		cmp.l	#160,wzonka_game_x
		bne.s	window_try_fused_double
		cmp.l	#144,wzonka_game_y
		beq.s	window_fused_native
window_try_fused_double:
		tst.b	scaling_status
		beq.s	window_fused_unavailable
		cmp.l	#320,wzonka_game_x
		bne.s	window_fused_unavailable
		cmp.l	#144,wzonka_game_y
		beq.s	window_fused_draw
		cmp.l	#288,wzonka_game_y
		beq.s	window_fused_draw
window_fused_unavailable:
		bra.w	window_read_pixels
window_fused_draw:
		gfx_time_end gfx_prof_read
		movem.l	d0-d1,-(sp)
		bsr.w	build_scale_pen_pairs
		movem.l	(sp)+,d0-d1
		gfx_time_start
		move.l	game_scale_array,a2
		bsr.w	window_planar_to_scaled
		bra.w	data_scaling_exit

window_fused_native:
		gfx_time_end gfx_prof_read
		movem.l	d0-d1,-(sp)
		gfx_time_start
		move.l	window_scale_table,a6
		move.l	a6,a2
		lea	gameboy_colours_conversion_table,a3
		moveq.l	#15,d2
window_native_pen_left:
		move.b	(a3)+,d4
		lsl.w	#8,d4
		lea	gameboy_colours_conversion_table,a5
		moveq.l	#15,d6
window_native_pen_right:
		move.b	(a5)+,d4
		move.w	d4,(a2)+
		dbra	d6,window_native_pen_right
		dbra	d2,window_native_pen_left
		gfx_time_end gfx_prof_pens
		movem.l	(sp)+,d0-d1
		gfx_time_start
		move.l	game_array,a2
		bsr.w	window_planar_to_native
		gfx_time_end gfx_prof_scale
		bra.w	cyber_screen_data_exit

window_capture_byte: MACRO
		IFEQ	\2
		move.b	(\1,d6.w),d0
		ELSE
		move.w	(\1,d6.w),d0
		lsr.w	d7,d0
		and.w	#255,d0
		ENDC
		ENDM

; One plane contributes two longwords (eight pens) per input byte.
window_expand_plane:	MACRO
		window_capture_byte \1,\3
		IFEQ	\2
		move.l	(a5,d0.w*8),d2
		move.l	4(a5,d0.w*8),d3
		ELSE
		or.l	\2(a5,d0.w*8),d2
		or.l	\2+4(a5,d0.w*8),d3
		ENDC
		ENDM

window_expand_group:	MACRO
		window_expand_plane a0,0,\1
		window_expand_plane a1,2048,\1
		window_expand_plane a2,4096,\1
		window_expand_plane a3,6144,\1
		move.l	d2,(a4)+
		move.l	d3,(a4)+
		addq.w	#1,d6
		ENDM

; d0/d1 = x/y capture origin, a2 = 160x144 destination. All registers scratch.
window_planar_to_pens:
		bsr.w	window_capture_setup
		lea	window_readback_table,a5
		tst.w	d7
		bne.s	window_read_shifted
		moveq.l	#0,d0
window_read_aligned_row:
		moveq.l	#160/8-1,d1
window_read_aligned_group:
		window_expand_group 0
		dbra	d1,window_read_aligned_group
		add.w	d4,d6
		dbra	d5,window_read_aligned_row
		rts

window_read_shifted:
		neg.w	d7
		addq.w	#8,d7
window_read_shifted_row:
		moveq.l	#160/8-1,d1
window_read_shifted_group:
		window_expand_group 1
		dbra	d1,window_read_shifted_group
		add.w	d4,d6
		dbra	d5,window_read_shifted_row
		rts

window_capture_setup:
		move.l	a2,a4
		move.l	wzonka_map_attr,a5
		moveq.l	#0,d4
		move.w	bm_BytesPerRow(a5),d4
		move.l	bm_Planes(a5),a0
		move.l	bm_Planes+4(a5),a1
		move.l	bm_Planes+8(a5),a2
		move.l	bm_Planes+12(a5),a3
		mulu.w	d4,d1
		move.l	d0,d6
		lsr.w	#3,d6
		add.w	d1,d6
		sub.w	#160/8,d4
		move.w	#144-1,d5
		move.w	d0,d7
		and.w	#7,d7
		rts

; The packed table puts two source indices in each byte, the exact index
; for the existing pen-pair table. No intermediate 160x144 image is stored.
window_fused_pair: MACRO
		bfextu	d2{\1:8},d0
		IFEQ	\2-2
		move.w	(a6,d0.w*2),(a4)+
		ELSE
		IFEQ	\2
		move.l	(a6,d0.w*4),(a4)+
		ELSE
		move.l	(a6,d0.w*4),d3
		move.l	d3,320(a4)
		move.l	d3,(a4)+
		ENDC
		ENDC
		ENDM

window_fused_loop: MACRO
window_fused_row\@:
		moveq.l	#160/8-1,d1
window_fused_group\@:
		window_capture_byte a0,\1
		move.l	(a5,d0.w*4),d2
		window_capture_byte a1,\1
		or.l	1024(a5,d0.w*4),d2
		window_capture_byte a2,\1
		or.l	2048(a5,d0.w*4),d2
		window_capture_byte a3,\1
		or.l	3072(a5,d0.w*4),d2
		window_fused_pair 0,\2
		window_fused_pair 8,\2
		window_fused_pair 16,\2
		window_fused_pair 24,\2
		addq.w	#1,d6
		dbra	d1,window_fused_group\@
		IFEQ	\2-1
		lea	320(a4),a4
		ENDC
		add.w	d4,d6
		dbra	d5,window_fused_row\@
		rts
		ENDM

window_planar_to_scaled:
		bsr.w	window_capture_setup
		lea	window_packed_table,a5
		move.l	window_scale_table,a6
		moveq.l	#0,d0
		tst.w	d7
		bne.w	window_fused_shifted
		cmp.l	#288,wzonka_game_y
		beq.w	window_fused_double
		window_fused_loop 0,0
window_fused_double:
		window_fused_loop 0,1
window_fused_shifted:
		neg.w	d7
		addq.w	#8,d7
		cmp.l	#288,wzonka_game_y
		beq.w	window_fused_shifted_double
		window_fused_loop 1,0
window_fused_shifted_double:
		window_fused_loop 1,1

window_planar_to_native:
		bsr.w	window_capture_setup
		lea	window_packed_table,a5
		move.l	window_scale_table,a6
		moveq.l	#0,d0
		tst.w	d7
		bne.w	window_native_shifted
		window_fused_loop 0,2
window_native_shifted:
		neg.w	d7
		addq.w	#8,d7
		window_fused_loop 1,2

init_window_readback_table:
		lea	window_readback_table,a0
		lea	window_readback_nibbles,a1
		lea	window_packed_table,a2
		lea	window_packed_nibbles,a3
		moveq.l	#0,d4
window_readback_build_bank:
		moveq.l	#0,d0
window_readback_build_byte:
		move.w	d0,d1
		lsr.w	#4,d1
		move.w	(a3,d1.w*2),d3
		swap	d3
		move.l	(a1,d1.w*4),d2
		lsl.l	d4,d2
		move.l	d2,(a0)+
		move.w	d0,d1
		and.w	#15,d1
		move.w	(a3,d1.w*2),d3
		lsl.l	d4,d3
		move.l	d3,(a2)+
		move.l	(a1,d1.w*4),d2
		lsl.l	d4,d2
		move.l	d2,(a0)+
		addq.w	#1,d0
		cmp.w	#256,d0
		bne.s	window_readback_build_byte
		addq.w	#1,d4
		cmp.w	#4,d4
		bne.s	window_readback_build_bank
		rts

		cnop	0,4
window_readback_nibbles:
		dc.l	$00000000,$00000001,$00000100,$00000101
		dc.l	$00010000,$00010001,$00010100,$00010101
		dc.l	$01000000,$01000001,$01000100,$01000101
		dc.l	$01010000,$01010001,$01010100,$01010101
window_readback_table:
		ds.b	4*256*8
window_packed_nibbles:
		dc.w	$0000,$0001,$0010,$0011,$0100,$0101,$0110,$0111
		dc.w	$1000,$1001,$1010,$1011,$1100,$1101,$1110,$1111
window_packed_table:
		ds.b	4*256*4
		IFNE	GFX_COMPARE_READBACK
window_readback_check:
		ds.b	160*144
		ENDC
