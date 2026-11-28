
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		screen draw aga - the third generation routines 8D
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
aga_screen_draw:move.l	a2,a6				;a6 = the fixed 16bit
		add.l	#$ff40,a6			;a6 = lcd control.
		moveq.l	#0,d7
		move.b	(a6),d7				;d7 = lcd control byte.
		btst	#7,d7				;lcd operation?
		beq.s	clear_aga_screen		;no. clear and quit.
		move.l	d7,lcd_control			;store the byte.

		bsr.w	push_z80

		move.l	aga_map_inactive,d6
		cmp.l	aga_map_I,d6
		beq.s	wait_I
wait_II:	tst.b	visual_frame
		bne.s	wait_II
		bra.s	wait_done
wait_I:		tst.b	visual_frame
		beq.s	wait_I

wait_done:
		gfx_time_start
		bsr.w	screen_aga_bg
		gfx_time_end gfx_prof_aga_bg
		gfx_time_start
		bsr.w	screen_aga_win
		gfx_time_end gfx_prof_aga_win
		IFNE	GFX_PROFILE
		move.b	#1,gfx_profile_aga_sample
		ENDC
		gfx_time_start
		bsr.w	screen_aga_sprs
		gfx_time_end gfx_prof_aga_spr
		IFNE	GFX_PROFILE
		clr.b	gfx_profile_aga_sample
		ENDC
		bsr.w	update_aga_pal
		bsr.w	swap_aga_buffex			;swap the lists.

		bsr.w	pull_z80
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		clear screen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

clear_aga_screen:
		bsr.w	push_z80

		move.l	aga_map_inactive,d6
		cmp.l	aga_map_I,d6
		beq.s	wait_In
wait_IIn:	tst.b	visual_frame
		bne.s	wait_IIn
		bra.s	wait_donen
wait_In:	tst.b	visual_frame
		beq.s	wait_In

wait_donen:	clr.l	lcd_control			;sprites off -> clear.
							;window off -> clear.
							;background off -> clear.
		bsr.w	screen_aga_clear_the_background
		bsr.w	screen_aga_win
		tst.b	old_refresh
		beq.s	clear_aga_full_sprites
		bsr.w	screen_aga_sprs
		bra.s	clear_aga_present
clear_aga_full_sprites:
		bsr.w	clear_aga_scanline_sprites
clear_aga_present:
		bsr.w	update_aga_pal			;update the palette.
		bsr.w	swap_aga_buffex			;swap the lists.

		bsr.w	pull_z80
		rts

; Full starts at row 0, not at the x/153 sprite bitmap's 16-row margin.
clear_aga_scanline_sprites:
		bsr.w	gfx_cache_invalidate
		move.l	aga_map_inactive,a0
		lea	160(a0),a0
		move.w	#144-1,d0
		moveq.l	#0,d1
		moveq.l	#0,d2
		moveq.l	#0,d3
		moveq.l	#0,d4
		moveq.l	#0,d5
		moveq.l	#0,d6
		moveq.l	#0,d7
clear_aga_scanline_row:
		movem.l	d1-d7,(a0)
		movem.l	d1-d7,40(a0)
		movem.l	d1-d7,80(a0)
		movem.l	d1-d7,120(a0)
		lea	320(a0),a0
		dbra	d0,clear_aga_scanline_row
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		execute the background copying
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
screen_aga_bg:	move.l	d7,d0				;d0 = lcd control byte.
		btst	#0,d0				;background display?
		beq.w	screen_aga_clear_the_background	;no. quit.

		move.l	gb_memory,a0			;a0 = the fixed 16bit
		move.l	a0,a1				;memory area.
		add.l	#$ff42,a1			;a1 = lcd control.
		moveq.l	#0,d2
		move.b	(a1)+,d2			;d2 = bg scroll y.
		moveq.l	#0,d3
		move.b	(a1),d3				;d3 = bg scroll x.

		move.l	d0,d1				;d1 = the control byte.
		and.b	#%1000,d0			;d0 = background tiles.
		lsl.w	#7,d0				;0/1 * 1024.
		move.l	a0,a1
		add.l	#$9800,a1			;tile position.
		add.l	d0,a1				;selected position.
							;a1 = input tiles.
		and.b	#%10000,d1			;d1 = background tile
		move.l	d1,d7				;datas. 0/1 * 2048.
		lsl.b	#3,d7				;d7 = tile adder (signed/
		bchg	#7,d7				;unsigned).
		move.l	d7,tile_adder
		lsl.w	#7,d1
		move.l	a0,a2
		add.l	#$8800,a2			;tile data position.
		sub.l	d1,a2				;selected position.
							;a2 = input tile datas.
		move.l	a2,gb_tiles

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy background data
;		INPUT:
;		d2	= background scroll y.
;		d3	= background scroll x.
;		a1	= tiles.
;		a2	= tile datas.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	d2,d4
		lsr.w	#3,d2				;d2 = number of rows
							;to be skipped.
		move.b	d2,d6				;when d6=32 then back to y=0.

		lsl.w	#5,d2				;d2 = d2 * 32 (start y).
		add.l	d2,a1				;y of tiles = done.

		move.l	d3,d5
		lsr.w	#3,d3				;d3 = x start.
		move.b	d3,d7				;when d7=32 then back to x=0.

		move.l	bg_scroll_inactive,a0
		and.b	#%111,d4			;d4 = y pixel scroll (0-7).
		and.b	#%111,d5			;d5 = x pixel scroll (0-7).
		move.l	d4,(a0)				;store the scroll value.
		moveq.l	#8,d0
		sub.b	d5,d0
		move.l	aga_ro_inactive,a0
		move.b	d0,(a0)				;new x h/w shift value used.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		INPUT:
;		d6	= (background start y) / 8.
;		d7	= (background start x) / 8.
;		a1	= tiles.
;		a2	= tile pattern datas.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	aga_map_inactive,a0		;a0 = p0.
		bsr.w	screen_aga_bg_cache_begin
		add.l	#40*8*16+64/8-1,a0		;position fix.
		moveq.l	#(144/8)+1-1,d0			;y.
		move.l	tile_adder,d2			;d2 = tile adder.

		cnop	0,4
screen_aga_colu:movem.l	d6/d7/a0,-(SP)
		bsr.w	screen_aga_margin
		addq.b	#1,d7
		and.b	#%11111,d7
		addq.l	#1,a0
		moveq.l	#(160/8)/4-1,d1			;x.
; Tile offsets fit in a positive word (0..4080); ignore packed pixels in d3's high word.
screen_aga_rows:move.w	d2,d3
		add.b	(a1,d7.l),d3			;d3 = left tile.
		addq.b	#1,d7
		lsl.w	#4,d3				;d3 = d3 * 16.
		and.b	#%11111,d7
		lea	(a2,d3.w),a3

		move.w	d2,d3
		add.b	(a1,d7.l),d3			;d3 = left tile.
		addq.b	#1,d7
		lsl.w	#4,d3				;d3 = d3 * 16.
		and.b	#%11111,d7
		lea	(a2,d3.w),a4

		move.w	d2,d3
		add.b	(a1,d7.l),d3			;d3 = left tile.
		addq.b	#1,d7
		lsl.w	#4,d3				;d3 = d3 * 16.
		and.b	#%11111,d7
		lea	(a2,d3.w),a5

		move.w	d2,d3
		add.b	(a1,d7.l),d3			;d3 = left tile.
		addq.b	#1,d7
		lsl.w	#4,d3				;d3 = d3 * 16.
		and.b	#%11111,d7
		lea	(a2,d3.w),a6

screen_aga_pack_row: MACRO
		move.w	(a3)+,d3
		lsl.l	#8,d3
		move.w	d3,d5
		move.w	(a4)+,d3
		move.b	d3,d5
		lsl.l	#8,d5
		lsl.l	#8,d3
		move.w	(a5)+,d3
		move.b	d3,d5
		lsl.l	#8,d5
		move.w	(a6)+,d4
		move.b	d4,d5				;d5 = p1 data.
		move.l	d5,\2
		lsr.w	#8,d4
		move.b	d4,d3				;d3 = p0 data.
		move.l	d3,\1
		ENDM

		tst.l	aga_bg_cache_next
		beq.s	screen_aga_pack_block
		bsr.w	screen_aga_bg_cache_block
		beq.w	screen_aga_skip_block
screen_aga_pack_block:
		moveq.l	#8/2-1,d6
screen_aga_out:	screen_aga_pack_row (a0),40(a0)
		screen_aga_pack_row 320(a0),360(a0)
		add.l	#2*8*40,a0
		dbra	d6,screen_aga_out		;next pair of rows.

		sub.l	#8*8*40-4,a0		;next x.
		bra.s	screen_aga_next_block
screen_aga_skip_block:
		addq.l	#4,a0				;next x.
screen_aga_next_block:
		dbra	d1,screen_aga_rows		;next four blocks.

		; Fine scrolling exposes part of the next tile at the right edge.
		move.l	aga_ro_inactive,a4
		cmp.b	#8,(a4)
		beq.s	screen_aga_colu_next
		bsr.s	screen_aga_margin
screen_aga_colu_next:
		movem.l	(SP)+,d6/d7/a0
		add.l	#8*8*40,a0			;next y.
		addq.b	#1,d6				;       (register).
		and.b	#%11111,d6
		beq.s	screen_aga_tup			;back to beginning.
		add.l	#32,a1				;next y.
		dbra	d0,screen_aga_colu		;next 168x8 line.
		rts

		cnop	0,4
screen_aga_tup:	sub.l	#32*31,a1			;back to the beginning.
		dbra	d0,screen_aga_colu		;next 168x8 line.
		rts

screen_aga_pack_margin: MACRO
		move.w	(a3)+,d4
		move.b	d4,\2
		lsr.w	#8,d4
		move.b	d4,\1
		ENDM

screen_aga_margin:
		moveq.l	#8/2-1,d6
		move.w	d2,d3
		add.b	(a1,d7.l),d3
		lsl.w	#4,d3
		lea	(a2,d3.w),a3
		move.l	a0,a4
screen_aga_bdat:	screen_aga_pack_margin (a4),40(a4)
		screen_aga_pack_margin 320(a4),360(a4)
		add.l	#2*40*8,a4
		dbra	d6,screen_aga_bdat
		rts

screen_aga_bg_cache_begin:
		move.l	aga_bg_cache,d0
		move.l	d0,aga_bg_cache_next
		beq.s	screen_aga_bg_cache_ready
		move.l	d0,a3
		move.l	a0,d0
		lea	aga_bg_motion,a4
		cmp.l	aga_map_I,d0
		beq.s	screen_aga_bg_cache_first
		addq.l	#4,a4
		addq.l	#1,a3
screen_aga_bg_cache_first:
		move.l	a4,aga_bg_motion_slot
		move.w	d6,d3
		lsl.w	#8,d3
		move.b	d7,d3
		cmp.w	(a4),d3
		beq.s	screen_aga_bg_cache_stationary
		move.w	d3,(a4)
		cmp.b	#2,2(a4)
		bhs.s	screen_aga_bg_cache_bypass
		cmp.b	#80,3(a4)
		blo.s	screen_aga_bg_cache_stationary
		addq.b	#1,2(a4)
		cmp.b	#2,2(a4)
		bhs.s	screen_aga_bg_cache_bypass
		bra.s	screen_aga_bg_cache_enable
screen_aga_bg_cache_stationary:
		clr.b	2(a4)
screen_aga_bg_cache_enable:
		clr.b	3(a4)
		move.b	(a3),aga_bg_cache_cold
		st	(a3)
		not.b	aga_bg_cache_cold
		move.l	aga_bg_cache,a3
		cmp.l	aga_map_I,d0
		beq.s	screen_aga_bg_cache_ptr
		lea	aga_bg_cache_buffer(a3),a3
screen_aga_bg_cache_ptr:
		lea	4(a3),a3
		move.l	a3,aga_bg_cache_next
screen_aga_bg_cache_ready:
		rts
screen_aga_bg_cache_bypass:
		clr.b	(a3)				;the uncached draw overwrites this buffer.
		clr.l	aga_bg_cache_next
		rts

aga_bg_compare_tile: MACRO
		move.l	(\1),d3
		cmp.l	\2(a0),d3
		bne.w	screen_aga_bg_cache_miss
		move.l	4(\1),d3
		cmp.l	\2+4(a0),d3
		bne.w	screen_aga_bg_cache_miss
		move.l	8(\1),d3
		cmp.l	\2+8(a0),d3
		bne.w	screen_aga_bg_cache_miss
		move.l	12(\1),d3
		cmp.l	\2+12(a0),d3
		bne.w	screen_aga_bg_cache_miss
		ENDM

aga_bg_save_tile: MACRO
		movem.l	(\1),d3-d6
		movem.l	d3-d6,\2(a0)
		ENDM

; Compare actual pattern bytes, not IDs, so VRAM edits need no write hook.
; a3-a6 point to four raw tiles; the buffer-specific snapshot is in Fast RAM.
screen_aga_bg_cache_block:
		move.l	a0,-(sp)
		move.l	aga_bg_cache_next,a0
		add.l	#64,aga_bg_cache_next
		tst.b	aga_bg_cache_cold
		bne.w	screen_aga_bg_cache_save
		aga_bg_compare_tile a3,0
		aga_bg_compare_tile a4,16
		aga_bg_compare_tile a5,32
		aga_bg_compare_tile a6,48
		move.l	(sp)+,a0
		moveq.l	#0,d3
		rts
screen_aga_bg_cache_miss:
		move.l	a1,-(sp)
		move.l	aga_bg_motion_slot,a1
		addq.b	#1,3(a1)
		move.l	(sp)+,a1
screen_aga_bg_cache_save:
		aga_bg_save_tile a3,0
		aga_bg_save_tile a4,16
		aga_bg_save_tile a5,32
		aga_bg_save_tile a6,48
		move.l	(sp)+,a0
		moveq.l	#1,d3
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		clear the background
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_aga_clear_the_background:
		move.l	aga_bg_cache,d0
		beq.s	screen_aga_clear_background_start
		move.l	d0,a0
		clr.l	(a0)
		clr.l	aga_bg_motion
		clr.l	aga_bg_motion+4
screen_aga_clear_background_start:
		move.l	aga_map_inactive,a0
		moveq.l	#256/2-1,d0			;two rows per iteration.
		moveq.l	#0,d1
		moveq.l	#0,d2
		moveq.l	#0,d3
		moveq.l	#0,d4
		moveq.l	#0,d5
		moveq.l	#0,d6
		moveq.l	#0,d7
		move.l	d1,a1
		move.l	d1,a2
		move.l	d1,a3

; Clear only the first two 40-byte planes of each 320-byte row.
screen_aga_clear_the_background_loop:
		movem.l	d1-d7/a1-a3,(a0)
		movem.l	d1-d7/a1-a3,40(a0)
		movem.l	d1-d7/a1-a3,320(a0)
		movem.l	d1-d7/a1-a3,360(a0)
		lea	640(a0),a0
		dbra	d0,screen_aga_clear_the_background_loop
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		do the sprites
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

aga_clear_sprite_row: MACRO
		tst.b	\1(a2)
		beq.s	aga_clear_sprite_row_done\@
		clr.b	\1(a2)
		movem.l	d1/d3-d7,\2(a0)
		movem.l	d1/d3-d7,\3(a0)
aga_clear_sprite_row_done\@:
		ENDM

; The 144 visible flags form 36 complete groups starting at row 16.
aga_clear_sprite_list:
		lea	16(a2),a2
		moveq.l	#144/4-1,d0
aga_clear_sprite_group:
		tst.l	(a2)
		beq.s	aga_clear_sprite_next
		aga_clear_sprite_row 0,0,40
		aga_clear_sprite_row 1,320,360
		aga_clear_sprite_row 2,640,680
		aga_clear_sprite_row 3,960,1000
aga_clear_sprite_next:
		addq.l	#4,a2
		lea	1280(a0),a0			;four 320-byte rows.
		dbra	d0,aga_clear_sprite_group
		rts

		cnop	0,4
screen_aga_sprs:
		tst.l	aga_layer_cache
		beq.s	screen_aga_sprs_draw
		bsr.w	aga_layer_check
		beq.w	aga_spr_exit
screen_aga_sprs_draw:
		gfx_aga_part_start
; Six zero longwords cover the existing 24-byte span in each plane.
		moveq.l	#0,d1
		moveq.l	#0,d3
		moveq.l	#0,d4
		moveq.l	#0,d5
		moveq.l	#0,d6
		moveq.l	#0,d7

		move.l	aga_map_inactive,a0
		add.l	#40*8*16+4+40*4,a0		;sprite plane 0.
		move.l	aga_sprs_inactive,a2
		bsr.w	aga_clear_sprite_list
		move.l	aga_map_inactive,a0
		add.l	#40*8*16+4+40*6,a0		;sprite plane 2.
		move.l	aga_sprs_inactive_x,a2
		bsr.w	aga_clear_sprite_list

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		line clearing has been executed
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		gfx_aga_part_end gfx_prof_aga_clear
		move.l	lcd_control,d1			;d1 = lcd control byte.
		btst	#1,d1				;sprites off?
		beq.w	aga_spr_exit			;yes.

		move.l	gb_memory,a1
		bsr.w	spr_order_frame
		moveq.l	#3,d3
		bsr.w	spr_priority_prepare
		bmi.w	aga_spr_exit
		add.l	#$8000,a1			;a1 = sprite pattern table.
		move.l	x_flip_table,a2			;        .

		btst	#2,d1				;sprite size?
		bne.w	aspr_n8x16			;8x16.

aspr_n8x8:	move.l	#8-1,sprite_y
		move.b	#$ff,sprite_mask
		bra.s	aspr_c8xq			;do the copying.
aspr_n8x16:	move.l	#16-1,sprite_y
		move.b	#$fe,sprite_mask

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sprite size 8xq, q=8/16.
;		INPUT:
;		d0	= number of sprites.
;		a0	= sprite attribute table.
;		a1	= sprite pattern area.
;		a2	= x flip table.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

aspr_c8xq:	move.l	-(a0),d1			;d1 = y.B, x.B, gfx.B, flags.B.
aspr_xcute:	swap	d1				;d1 = gfx.B, flags.B, y.B, x.B.
		move.l	bg_scroll_x,d2			;x start (bg scroll pixels).
		add.b	d1,d2				;d2 = x.B.
		cmp.w	#8+160+8,d2			;out of vision?
		bge.w	aspr_xit			;yes.

		moveq.l	#0,d3
		ror.w	#8,d1				;d1 = gfx.B, flags.B, x.B, y.B.
		move.b	d1,d3				;d3 = y.B.
		cmp.w	#16+144+8,d3			;out of vision?
		bge.w	aspr_xit			;yes.

		move.l	d3,a3				;a3 = scanline clear bytes.

		move.w	d3,d4
		lsl.w	#8,d4
		lsl.w	#6,d3
		add.w	d4,d3				;d3 = y on screen.
							;(d3 = d3 * 40*8).
		move.l	d2,d4				;d4 = x.B.
		lsr.w	#3,d4				;d4 = x.B / 8.
		add.l	d4,d3				;d3 = y and x fixed.
		move.l	aga_map_inactive,a4
		and.b	#%111,d2			;d2 = bit skip (0-7).
		add.l	d3,a4				;a4 = output.
		rol.l	#8,d1				;d1 = flags.B, x.B, y.B, gfx.B.
		and.b	sprite_mask,d1
		move.b	d1,d4				;d4 = gfx.B.
		add.l	#40*4+(64/8)-1,a4		;to sprite planes.
		lsl.w	#4,d4				;d4 = d4 * 16.
		lea	(a1,d4.l),a6			;a6 = pattern data.

		btst	#4+24,d1			;palette bit test.
		beq.s	aga_spr_nop			;palette 0.
		move.l	a4,a5				;a5 = mask plane.
		add.l	#40*2,a4			;palette 1.
		add.l	aga_sprs_inactive_x,a3		;         .
		bra.s	pal_pla_done
aga_spr_nop:	move.l	a4,a5
		add.l	#40*2,a5			;a5 = mask plane.
		add.l	aga_sprs_inactive,a3		;palette 0.

pal_pla_done:	move.l	sprite_y,d7			;d7 = y-1.
		btst	#6+24,d1			;y flipped?
		bne.w	aga_spr_y			;yes.
		btst	#5+24,d1			;x flipped?
		bne.s	aga_spr_x			;yes.

; Merge in a register to avoid writing the intermediate mask into CHIP RAM.
; Arguments: keep mask, new pixels, scratch register, destination.
aga_spr_merge_word: MACRO
		move.w	\4,\3
		and.w	\1,\3
		or.w	\2,\3
		move.w	\3,\4
		ENDM

; Planes are 40 bytes apart; advance each pair by the full row stride.
aga_spr_merge_row: MACRO
		aga_spr_merge_word d5,d3,d6,(a4)
		aga_spr_merge_word d5,d4,d6,40(a4)
		lea	320(a4),a4

		and.w	d5,(a5)
		and.w	d5,40(a5)
		lea	320(a5),a5
		ENDM

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		normal sprite output
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.w	#$ffff,d1			;speed up.
		cnop	0,4
aga_spr_normal:	move.w	(a6)+,d3
		beq.s	aga_spr_nx			;empty data.
		spr_priority_filter aga_spr_nx

		move.b	d3,d4				;d4 = 01.
		clr.b	d3				;d3 = 0x.
		lsl.w	#8,d4				;d4 = 1x.
		lsr.w	d2,d3				;bits skipped.
		lsr.w	d2,d4				;bits skipped.

		move.w	d3,d5
		move.b	d1,(a3)+			;this sl must be cleared.
		or.w	d4,d5
		eor.w	d1,d5

		aga_spr_merge_row

		dbra	d7,aga_spr_normal		;next y (sprite data).
aspr_xit:	dbra	d0,aspr_c8xq			;next sprite.
		rts

		cnop	0,4
aga_spr_nx:	add.l	#40*8,a4
		addq.l	#1,a3				;no data here.
		add.l	#40*8,a5
		dbra	d7,aga_spr_normal		;next y (sprite data).
		dbra	d0,aspr_c8xq			;next sprite.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		x flipped sprite output
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

aga_spr_x:	moveq.l	#0,d3
		move.w	#$ffff,d1			;speed up.
		cnop	0,4
aga_spr_xz:	move.w	(a6)+,d3
		beq.s	aga_spr_xx			;empty data.
		move.w	(a2,d3.l*2),d3			;x flipped data.
		spr_priority_filter aga_spr_xx

		move.b	d3,d4				;d4 = 01.
		clr.b	d3				;d3 = 0x.
		lsl.w	#8,d4				;d4 = 1x.
		lsr.w	d2,d3				;bits skipped.
		lsr.w	d2,d4				;bits skipped.

		move.w	d3,d5
		move.b	d1,(a3)+			;this sl must be cleared.
		or.w	d4,d5
		eor.w	d1,d5

		aga_spr_merge_row

		dbra	d7,aga_spr_xz			;next y (sprite data).
		dbra	d0,aspr_c8xq			;next sprite.
		rts

		cnop	0,4
aga_spr_xx:	add.l	#40*8,a4
		addq.l	#1,a3				;no data here.
		add.l	#40*8,a5
		dbra	d7,aga_spr_xz			;next y (sprite data).
		dbra	d0,aspr_c8xq			;next sprite.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		y flipping detected
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

aga_spr_y:	move.l	d7,d4
		addq.b	#1,d4
		lsl.b	#1,d4
		add.l	d4,a6				;to sprite data end.

		btst	#5+24,d1			;x flipped?
		bne.s	aga_spr_xy			;yes.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		y flipped sprite output
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.w	#$ffff,d1			;speed up.
		cnop	0,4
aga_spr_yz:	move.w	-(a6),d3
		beq.s	aga_spr_ny			;empty data.
		spr_priority_filter aga_spr_ny

		move.b	d3,d4				;d4 = 01.
		clr.b	d3				;d3 = 0x.
		lsl.w	#8,d4				;d4 = 1x.
		lsr.w	d2,d3				;bits skipped.
		lsr.w	d2,d4				;bits skipped.

		move.w	d3,d5
		move.b	d1,(a3)+			;this sl must be cleared.
		or.w	d4,d5
		eor.w	d1,d5

		aga_spr_merge_row

		dbra	d7,aga_spr_yz			;next y (sprite data).
		dbra	d0,aspr_c8xq			;next sprite.
		rts

		cnop	0,4
aga_spr_ny:	add.l	#40*8,a4
		addq.l	#1,a3				;no data here.
		add.l	#40*8,a5
		dbra	d7,aga_spr_yz			;next y (sprite data).
		dbra	d0,aspr_c8xq			;next sprite.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		x flipped sprite output
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

aga_spr_xy:	moveq.l	#0,d3
		move.w	#$ffff,d1			;speed up.
		cnop	0,4
aga_spr_xyz:	move.w	-(a6),d3
		beq.s	aga_spr_xyx			;empty data.
		move.w	(a2,d3.l*2),d3			;x flipped data.
		spr_priority_filter aga_spr_xyx

		move.b	d3,d4				;d4 = 01.
		clr.b	d3				;d3 = 0x.
		lsl.w	#8,d4				;d4 = 1x.
		lsr.w	d2,d3				;bits skipped.
		lsr.w	d2,d4				;bits skipped.

		move.w	d3,d5
		move.b	d1,(a3)+			;this sl must be cleared.
		or.w	d4,d5
		eor.w	d1,d5

		aga_spr_merge_row

		dbra	d7,aga_spr_xyz			;next y (sprite data).
		dbra	d0,aspr_c8xq			;next sprite.
		rts

		cnop	0,4
aga_spr_xyx:	add.l	#40*8,a4
		addq.l	#1,a3				;no data here.
		add.l	#40*8,a5
		dbra	d7,aga_spr_xyz			;next y (sprite data).
		dbra	d0,aspr_c8xq			;next sprite.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		draw the h/w window using amiga sprites
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
screen_aga_win:	move.l	lcd_control,d0			;d0 = lcd control byte.
		btst	#5,d0				;window display?
		beq.w	screen_aga_wxt			;nope.
		btst	#0,d0
		beq.w	screen_aga_wxt

		move.l	gb_memory,a0
		move.l	a0,a2

		add.l	#$9800,a0			;window tiles.
		and.b	#%1000000,d0			;d0 = tile position.
		lsl.w	#4,d0				;d0 = 0/1 * 1024.
		add.l	d0,a0				;a0 = window tiles.

		move.l	gb_tiles,a1

		add.l	#$ff4a,a2			;a2 = window y position.
		moveq.l	#0,d0
		move.b	(a2)+,d0			;d0 = window y pos ($ff4A).
		moveq.l	#0,d1
		move.b	(a2),d1				;d1 = window x pos ($ff4B).
		cmp.b	#6,d1
		bne.s	win_aga_no_no
		addq.b	#1,d1

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		INPUT:
;		d0	= window y position.
;		d1	=        x         .
;		a0	= window tiles.
;		a1	= window tile pattern table.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

win_aga_no_no:	cmp.w	#160,d1
		bge.w	screen_aga_wxt
		cmp.w	#144,d0
		bge.w	screen_aga_wxt
		move.l	d0,-(SP)

		add.w	#$2c,d0
		add.w	#$81+64-8,d1

		lsl.w	#8,d0
		moveq.l	#3-1,d2				;max three 64x144 sprites.
		move.l	aga_spr_inactive_pointer,a2	;pointers to the sprites.
		move.w	#(144+2*16+12)*256,d4		;d4 = y end of sprite.
		move.w	d1,d3
		move.b	d1,d4
		lsr.w	#1,d3				;d3 = x / 2.
		and.b	#%1,d4				;d4 = sho bit.
		lea	aga_spr_Ix,a5			;mask sprites.
		moveq.l	#-1,d6				;d6 = visible sprite number.
win_aga_pointer:move.l	(a2)+,a3
		move.w	d0,d5
		move.l	(a5)+,a4
		move.b	d3,d5
		move.w	d5,(a3)
		move.w	d4,d7
		move.w	d5,(a4)
		addq.l	#8,a3
		addq.l	#8,a4
		move.w	d7,(a3)
		addq.w	#1,d6				;one sprite more visible.
		move.w	d7,(a4)
		add.w	#64,d1
		cmp.w	#$81+64-8+64*3,d1
		bge.s	win_aga_no_more			;no more sprites.
		add.b	#64/2,d3			;64 pixels right.
		dbra	d2,win_aga_pointer
		bra.s	no_empty_sprs

win_aga_no_more:dbra	d2,win_aga_mush			;empty the next sprites.
		bra.s	no_empty_sprs

win_aga_mush:	move.l	(a2)+,a3
		move.w	d5,(a3)
		addq.l	#8,a3
		move.l	(a5)+,a4
		move.w	d5,(a4)
		addq.l	#8,a4
		move.w	d7,(a3)
		move.w	d7,(a4)		
		dbra	d2,win_aga_mush			;empty the next sprites.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		prepare for the data transfer
;		INPUT:
;		d6	= number of used sprites - 1.
;		a0	= window tiles.
;		a1	= window tile pattern table.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

no_empty_sprs:	move.l	#144,d0
		sub.l	(SP)+,d1
		lsr.b	#3,d0				;d0 = dy/8.
		move.l	aga_spr_inactive_pointer,a2	;a2 = pointer to the sprite
							;pointers.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy data to sprites
;		INPUT:
;		d0	= delta y / 8.
;		d6	= number of used sprites - 1.
;		a0	= window tiles.
;		a1	= window tile pattern table.
;		a2	= pointer to the sprite pointers.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
aga_window_fill:move.l	(a2)+,a6
		movem.l	d0/d6/a0/a2,-(SP)
		add.l	#16,a6				;skip the control words.

aga_win_data_cp:moveq.l	#2-1,d7
aga_win_data_do:move.l	tile_adder,d1
		move.l	d1,d2
		move.l	d1,d3
		move.l	d1,d4
		move.l	(a0)+,d5
		add.b	d5,d4
		lsr.l	#8,d5
		add.b	d5,d3
		lsr.l	#8,d5
		add.b	d5,d2
		lsr.w	#8,d5
		add.b	d5,d1
		lsl.w	#4,d4
		lsl.w	#4,d3
		lsl.w	#4,d2
		lsl.w	#4,d1
		lea	(a1,d4.l),a5			;xxx1.
		lea	(a1,d3.l),a4			;xx1x.
		lea	(a1,d2.l),a3			;x1xx.
		lea	(a1,d1.l),a2			;1xxx.

aga_win_pack_row: MACRO
		move.w	(a2)+,d5
		move.b	d5,d4
		lsl.w	#8,d4
		lsl.l	#8,d5
		move.w	(a3)+,d5
		move.b	d5,d4
		lsl.l	#8,d5
		lsl.l	#8,d4
		move.w	(a4)+,d5
		move.b	d5,d4
		lsl.l	#8,d4
		move.w	(a5)+,d3
		move.b	d3,d4
		move.l	d4,\2
		lsr.w	#8,d3
		move.b	d3,d5
		move.l	d5,\1
		ENDM

		moveq.l	#8/2-1,d6
aga_win_data_mv: aga_win_pack_row (a6),8(a6)
		aga_win_pack_row 16(a6),24(a6)
		add.l	#2*16,a6
		dbra	d6,aga_win_data_mv
		sub.l	#16*8-4,a6			;next x.
		dbra	d7,aga_win_data_do
		add.l	#16*8-8,a6			;next y column.
		add.l	#32-4-4,a0			;             .
		dbra	d0,aga_win_data_cp		;next 64 x 8 line.
		movem.l	(SP)+,d0/d6/a0/a2
		addq.l	#8,a0
		dbra	d6,aga_window_fill		;next sprite.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		move all the sprites away from the view
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_aga_wxt:	moveq.l	#3-1,d0
		move.l	aga_spr_inactive_pointer,a0
not_visible_spr:move.l	(a0)+,a1
		move.b	#32*6,1(a1)
		dbra	d0,not_visible_spr
		rts
