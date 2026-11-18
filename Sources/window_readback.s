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

; One plane contributes two longwords (eight pens) per input byte.
window_expand_plane:	MACRO
		IFEQ	\3
		move.b	(\1,d6.w),d0
		ELSE
		move.w	(\1,d6.w),d0
		lsr.w	d7,d0
		and.w	#255,d0
		ENDC
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
		move.l	a2,a4
		move.l	wzonka_map_attr,a5
		moveq.l	#0,d4
		move.w	bm_BytesPerRow(a5),d4
		move.l	bm_Planes(a5),a0
		move.l	bm_Planes+4(a5),a1
		move.l	bm_Planes+8(a5),a2
		move.l	bm_Planes+12(a5),a3
		lea	window_readback_table,a5
		mulu.w	d4,d1
		move.l	d0,d6
		lsr.w	#3,d6
		add.w	d1,d6
		sub.w	#160/8,d4
		move.w	#144-1,d5
		move.w	d0,d7
		and.w	#7,d7
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

init_window_readback_table:
		lea	window_readback_table,a0
		lea	window_readback_nibbles,a1
		moveq.l	#0,d4
window_readback_build_bank:
		moveq.l	#0,d0
window_readback_build_byte:
		move.w	d0,d1
		lsr.w	#4,d1
		move.l	(a1,d1.w*4),d2
		lsl.l	d4,d2
		move.l	d2,(a0)+
		move.w	d0,d1
		and.w	#15,d1
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
		IFNE	GFX_COMPARE_READBACK
window_readback_check:
		ds.b	160*144
		ENDC
