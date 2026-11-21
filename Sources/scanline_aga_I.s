
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		scanline drawer
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scanline_aga:	move.b	output_bit,d7
		cmp.b	frame_update,d7
		bne.w	no_scan_aga			;no draw.

		move.l	aga_map_inactive,d6
		cmp.l	aga_map_I,d6
		beq.s	wait_Ix
wait_IIx:	tst.b	visual_frame
		bne.s	wait_IIx
		bra.s	wait_donex
wait_Ix:	tst.b	visual_frame
		beq.s	wait_Ix

wait_donex:	cmp.l	#144,gb_scanlines		;drawing time?
		beq.w	scan_aga_swap			;yes!!!
		bgt.w	no_scan_aga			;no!

		move.l	gb_memory,a6
		add.l	#$ff40,a6			;a6 = lcd control.
		moveq.l	#0,d6
		move.b	(a6),d6				;d6 = lcd control byte.
		btst	#7,d6				;lcd operation?
		beq.s	no_scan_aga			;no. quit.
		move.l	d6,lcd_control			;store the byte.

		bsr.w	push_z80

		IFNE	GFX_PROFILE
		move.l	gb_scanlines,d0
		cmp.l	gfx_profile_line,d0
		seq	gfx_profile_aga_sample
		ENDC
		gfx_aga_line_start
		clr.b	aga_spr_amount			;zero sprites done.
		bsr.w	scan_aga_sprs			;do the sprites.
		move.l	aga_sprs_inactive,a5		;a5 = signal data.
		add.l	gb_scanlines,a5
		move.b	aga_spr_amount,(a5)		;set the signal.
		gfx_aga_line_end gfx_prof_aga_spr

		gfx_aga_line_start
		bsr.w	scan_aga_bg			;do the background.
		gfx_aga_line_end gfx_prof_aga_bg
		gfx_aga_line_start
		bsr.w	scan_aga_win			;do the window.
		gfx_aga_line_end gfx_prof_aga_win
		IFNE	GFX_PROFILE
		tst.b	gfx_profile_aga_sample
		beq.s	scan_aga_sample_done
		move.w	ccr,-(SP)
		moveq.l	#0,d0
		move.b	aga_spr_amount,d0		;reuse the dirty-row count after timing.
		add.l	d0,gfx_profile_aga_rows
		move.w	(SP)+,ccr
scan_aga_sample_done:
		clr.b	gfx_profile_aga_sample
		ENDC

		bsr.w	pull_z80
no_scan_aga:	rts					;exit.

scan_aga_swap:
		IFNE	GFX_PROFILE
		addq.l	#1,gfx_profile_line
		cmp.l	#144,gfx_profile_line
		blo.s	swap_aga_buffex
		clr.l	gfx_profile_line
		ENDC
swap_aga_buffex:move.l	copper_inactive,d7
		cmp.l	copper_I,d7
		beq.w	copper_I_in

copper_II_in:	bsr.w	update_aga_pal
		move.l	copper_I,copper_inactive
		move.l	aga_map_I,aga_map_inactive
		move.l	aga_ro_list_I,aga_ro_inactive
		move.l	aga_sprs_cI,aga_sprs_inactive
		move.l	aga_sprs_cxI,aga_sprs_inactive_x
		move.l	#bg_scroll_y_I,bg_scroll_inactive
		move.l	#aga_spr_Ia,aga_spr_inactive_pointer
		rts

copper_I_in:	bsr.w	update_aga_pal
		move.l	copper_II,copper_inactive
		move.l	aga_map_II,aga_map_inactive
		move.l	aga_ro_list_II,aga_ro_inactive
		move.l	aga_sprs_cII,aga_sprs_inactive
		move.l	aga_sprs_cxII,aga_sprs_inactive_x
		move.l	#bg_scroll_y_II,bg_scroll_inactive
		move.l	#aga_spr_Ib,aga_spr_inactive_pointer
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		update AGA h/w palette
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

update_aga_pal:	movem.l	a4/d0,-(SP)

		move.l	gb_memory,a4
		add.l	#$ff47,a4			;bgrdpal (background palette).
		move.l	aga_col_bg,a5			;a5 = colour table.
		move.l	aga_hw_spr_cI,a6		;output = sprite palette.

		moveq.l	#0,d7
		move.b	(a4),d0				;d0 = palette byte.
		move.b	aga_palette_byte,d7		;last frame's palette.
		move.b	d0,aga_palette_byte
		lsl.w	#4,d7
		add.l	d7,a5
		moveq.l	#4-1,d0
update_aga_palc:move.l	(a5)+,d7
		move.w	d7,10(a6)
		move.w	d7,74(a6)
		move.w	d7,138(a6)
		move.w	d7,202(a6)
		swap	d7
		move.w	d7,2(a6)
		move.w	d7,66(a6)
		move.w	d7,130(a6)
		move.w	d7,194(a6)
		add.l	#16,a6
		dbra	d0,update_aga_palc

		move.l	aga_col_bg,a5			;a5 = colour table.
		move.l	aga_col_cI,a6			;a6 = output.
		moveq.l	#3-1,d6
next_aga_col:	moveq.l	#0,d7
		move.b	(a4)+,d7			;d7 = palette byte.
		tst.b	lcd_blank_phase
		beq.s	next_aga_col_ready
		moveq.l	#0,d7
next_aga_col_ready:
		lsl.w	#4,d7
		add.l	d7,a5

		move.w	(a5)+,2(a6)			;c0.
		move.w	(a5)+,10(a6)
		move.w	(a5)+,18(a6)			;c1.
		move.w	(a5)+,26(a6)
		move.w	(a5)+,34(a6)			;c2.
		move.w	(a5)+,42(a6)
		move.w	(a5)+,50(a6)			;c3.
		move.w	(a5),58(a6)
		add.l	#16*4,a6
		move.l	aga_col_sprs,a5			;new palette.
		dbra	d6,next_aga_col

		movem.l	(SP)+,a4/d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		execute the background copying
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scan_aga_bg:	move.l	lcd_control,d0			;d0 = lcd control byte.
		btst	#0,d0				;background display?
		beq.w	scan_aga_bgy			;no. quit.

		move.l	gb_memory,a0			;a0 = the fixed 16bit
		move.l	a0,a1				;memory area.
		add.l	#$ff42,a1
		moveq.l	#0,d2
		move.b	(a1)+,d2			;d2 = bg scroll y.
		moveq.l	#0,d3
		move.b	(a1),d3				;d3 = bg scroll x.

		move.l	d0,d1				;d1 = the control byte.
		and.b	#%1000,d0			;d0 = background tiles.
		lsl.w	#7,d0				;0/1 * 1024.
		lea	(a0,d0.l),a1
		add.l	#$9800,a1			;tile position.
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

		move.l	gb_scanlines,d7
		add.l	d7,d2				;y = y start + y position.
		move.b	d2,d4
		lsr.w	#3,d2				;d2 = number of rows
							;to be skipped.
		and.l	#%11111,d2			;stay inside the range.

		lsl.w	#5,d2				;d2 = d2 * 32 (start y).
		add.l	d2,a1				;y of tiles = done.

		move.l	d3,d5
		lsr.w	#3,d3				;d3 = x start.
		subq.w	#1,d3				;one before.
		and.l	#%11111,d3			;stay inside the range.
		move.l	d3,d6				;when d6 = 32 then back
							;to x = 0.
		and.b	#%111,d5
		moveq.l	#8,d0
		and.l	#%111,d4			;d4 = y pixel scroll (0-7).
		sub.b	d5,d0

		move.l	aga_ro_inactive,a0
		move.b	d0,(a0,d7.l)			;new shift value.
		move.l	d0,gb_x				;save for the window.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy 160x1
;		INPUT:
;		d4	= background scroll y.
;		d6	= (background start x) / 8.
;		d7	= gb_scanlines.
;		a1	= tiles.
;		a2	= tile datas.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	aga_map_inactive,a0
		move.l	d7,d5
		lsl.w	#8,d7
		lsl.w	#6,d5
		add.l	d7,a0				;256 + 64 = 320.
		add.l	d5,a0				;y position fix.
		add.l	#64/8-2,a0			;h/w scroll fix.
		lsl.b	#1,d4				;d4 = d4 * 2.
		lea	40(a0),a3			;bitmap (output p1).
		add.l	d4,a2				;correct line position added.
		move.l	tile_adder,d4			;speed up.
		moveq.l	#0,d1				;clear (for .W usage).

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy 160x1 area
;		INPUT:
;		d4	= tile adder.
;		d6	= (background start x) / 8.
;		a0	= bitmap (output p0).
;		a1	= tiles.
;		a2	= tile datas.
;		a3	= bitmap (output p1).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.w	d4,d1
		add.b	(a1,d6.l),d1			;d1 = left tile.
		lsl.w	#4,d1				;d1 = d1 * 16.
		addq.b	#1,d6
		move.w	(a2,d1.l),d5			;d5 = left tile data.

		move.b	d5,d2				;d2 = plane 1.
		and.b	#%11111,d6
		lsr.w	#8,d5				;d5 = plane 0.

		move.w	d4,d1
		lsl.w	#8,d5
		add.b	(a1,d6.l),d1			;d1 = left tile.
		lsl.w	#8,d2
		lsl.w	#4,d1				;d1 = d1 * 16.
		addq.b	#1,d6
		move.w	(a2,d1.l),d0			;d0 = left tile data.

		move.b	d0,d2				;d2 = plane 1.
		move.w	d2,(a3)+			;p1 write.
		and.b	#%11111,d6
		lsr.w	#8,d0
		move.b	d0,d5				;d5 = plane 0.
		move.w	d5,(a0)+			;p0 write.

; The first pair starts a new group; three shifts drop the old bytes.
scan_aga_pack_tile: MACRO
		IFNE	\1
		lsl.l	#8,d5
		lsl.l	#8,d2
		ENDC
		move.w	d4,d1
		add.b	(a1,d6.l),d1
		lsl.w	#4,d1
		addq.b	#1,d6
		move.w	(a2,d1.l),d0
		move.b	d0,d2					;d2 = plane 1.
		and.b	#%11111,d6
		lsr.w	#8,d0
		move.b	d0,d5					;d5 = plane 0.
		ENDM

		moveq.l	#20/4-1,d7
scan_aga_bg_group:
		scan_aga_pack_tile 0
		scan_aga_pack_tile 1
		scan_aga_pack_tile 1
		scan_aga_pack_tile 1

		move.l	d5,(a0)+			;p0 write.
		move.l	d2,(a3)+			;p1 write.
		dbra	d7,scan_aga_bg_group
scan_aga_bgy:	rts					;exit background drawing.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		draw a scanline of the window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scan_aga_win:	move.l	lcd_control,d3			;d3 = lcd control byte.
		btst	#5,d3				;window display?
		beq.w	scan_aga_wxt			;nope.
		btst	#0,d3
		beq.w	scan_aga_wxt

		move.l	gb_memory,a0			;a0 = the fixed 16bit
		move.l	a0,a2

		moveq.l	#0,d0
		add.l	#$ff4a,a2			;a2 = window y position.
		move.b	(a2)+,d0			;d0 = window y pos ($ff4A).
		move.l	gb_scanlines,d2			;d2 = the current scanline.
		cmp.w	d0,d2
		blt.w	scan_aga_wxt			;window not achieved, yet.

		moveq.l	#0,d1				;position fix.
		move.b	(a2),d1				;d1 = window x pos ($ff4B).
		subq.w	#7,d1				;x position fix.
		bge.s	win_aga_ok
		clr.w	d1
win_aga_ok:	cmp.w	#160,d1
		bge.w	scan_aga_wxt			;right out!

		addq.l	#8,d1				;position fixing.
		sub.l	gb_x,d1				;apply h/w shifter.
		add.l	#$9800,a0			;window tiles.
		and.b	#%1000000,d3			;d3 = tile position.
		lsl.w	#4,d3				;d3 = 0/1 * 1024.
		add.l	d3,a0				;a0 = window tiles.

		move.l	gb_tiles,a1

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		INPUT:
;		a0	= window tiles.
;		a1	= window tile pattern table.
;		d0	= window y position.
;		d1	= window x position.
;		d2	= gb scanline.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	d2,d3
		sub.l	d0,d2				;d2 = delta y in window.
		move.l	d2,d6				;d6 = y in window.
		move.l	d1,d7				;d7 = window x position.
		lsr.w	#3,d6				;d6 = y in bytes.
		lsr.w	#3,d7				;d7 = x in bytes.
		lsl.w	#5,d6				;d6 = y in gb rows.

		add.l	d6,a0				;rows added.
		move.l	d3,d4
		lsl.w	#8,d3
		lsl.w	#6,d4
		add.l	d4,d3				;d3 = y * 40*8 = y * 320.
		move.l	aga_map_inactive,a3
		addq.l	#64/8-1,d3			;aga h/w position fix.
		add.l	d7,d3				;d3 = x and y.
		add.l	d3,a3				;a3 = output bg  (p0).

		and.l	#%111,d2			;d2 = scanline adder.
		moveq.l	#160/8+2,d3
		lsl.b	#1,d2				;data size fix.
		sub.b	d7,d3				;d3 = delta x in bytes.
		ble.s	scan_aga_wxt			;too little bytes!
		and.b	#%111,d1			;d1 = x right shifter.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		INPUT:
;		d1	= x pixels to right shifter.
;		d2	= the scanline adder.
;		d3	= delta x in bytes.
;		a0	= window tiles.
;		a1	= window tile pattern table.
;		a3	= background plane 0.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		add.l	d2,a1				;y inside the block.
		lea	40(a3),a4
		move.l	tile_adder,d2
		bra.w	win_span_spill
scan_aga_wxt:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		do the sprites
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scan_aga_sprs:	gfx_aga_part_start
		move.l	aga_sprs_inactive,a0
		move.l	gb_scanlines,d7
		add.l	d7,a0
		tst.b	(a0)
		beq.s	empty_spr_done			;no sprites here.
		move.l	aga_map_inactive,a1
		move.l	d7,d3
		lsl.w	#8,d7
		lsl.w	#6,d3
		add.l	d3,d7				;d7 = d7 * 40 * 8.
		add.l	d7,a1				;y position fixed.
		add.l	#40*4,a1			;p0.
		moveq.l	#0,d0
		moveq.l	#0,d1
		moveq.l	#0,d2
		moveq.l	#0,d3
		moveq.l	#0,d4
		moveq.l	#0,d5
		moveq.l	#0,d6
; Clear the same 28 bytes per plane; the last 12 bytes stay untouched.
		movem.l	d0-d6,(a1)
		movem.l	d0-d6,40(a1)
		movem.l	d0-d6,80(a1)
		movem.l	d0-d6,120(a1)
		clr.b	(a0)				;emptied.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		first fo the sprites beyond the window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

empty_spr_done:	gfx_aga_part_end gfx_prof_aga_clear
		move.l	lcd_control,d1			;d1 = lcd control byte.
		btst	#1,d1				;sprites off?
		beq.w	aga_spr_exit			;yes.
		btst	#2,d1				;sprite size?
		bne.w	sspr_aga_n8x16			;8x16.

sspr_aga_n8x8:	move.l	#8-1,sprite_y			;a coming compare fixed
		move.b	#$ff,sprite_mask
		bra.s	sspr_aga_begin			;value.
sspr_aga_n8x16:	move.l	#16-1,sprite_y
		move.b	#$fe,sprite_mask

sspr_aga_begin:	move.l	gb_memory,a0
		move.l	a0,a1
		add.l	#$8000,a1			;a1 = sprite pattern table.
		add.l	#$fe00,a0			;a0 = sprite 0.
		move.l	gb_scanlines,d4
		add.b	#16,d4			;ly + 16.
		move.l	sprite_y,d5
		move.w	d4,d6
		sub.w	d5,d6			;first OAM Y that covers this line.
		lea	spr_pick,a6
		moveq.l	#0,d2
		moveq.l	#40-1,d0
		gfx_aga_part_start
sspr_aga_pick:	move.l	(a0)+,d1			;y, x, tile, flags.
		move.l	d1,d3
		rol.l	#8,d3			;Y in the low byte.
; Visible LY makes the accepted OAM Y range lie within 1..159.
		sub.b	d6,d3
		cmp.b	d5,d3
		dbls	d0,sspr_aga_pick		;reject and continue if out of range.
		bhi.s	sspr_aga_picked		;the final entry was rejected.
		move.l	d1,(a6)+
		addq.b	#1,d2			;hardware counts this one.
		dbra	d0,sspr_aga_pick
sspr_aga_picked:
		gfx_aga_part_end gfx_prof_aga_oam
		tst.b	d2
		beq.w	aga_spr_exit			;nothing on this line.
		move.l	a6,a0			;draw the last pick first.
		move.l	d2,d0
		subq.l	#1,d0
		move.l	d4,d6				;d4 = the scanline number.
		sub.w	#16,d6				;y position fix.
		move.l	d6,d7
		lsl.w	#8,d7
		lsl.w	#6,d6
		add.w	d7,d6				;y on screen.
		add.w	#64/8-1,d6			;aga h/w position fix.
		move.l	aga_map_inactive,a2
		add.l	d6,a2
		move.l	x_flip_table,a3

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sprite size 8xq, q=8/16.
;		INPUT:
;		d0	= number of sprites.
;		a0	= sprite attribute table.
;		a1	= sprite pattern table.
;		a2	= sprite output row.
;		a3	= x flip table.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sspr_aga_c8xq:
		move.l	-(a0),d1			;d1 = y.B, x.B, gfx.B, flags.B.
		swap	d1				;d1 = gfx.B, flags.B, y.B, x.B.
		moveq.l	#0,d2
		move.b	d1,d2				;d2 = x.B.
		cmp.w	#160+8,d2			;crossed the right border?
		bhs.w	aga_next_spr			;yes.

		moveq.l	#0,d3
		ror.w	#8,d1				;d1 = gfx.B, flags.B, x.B, y.B.
		move.b	d1,d3				;d3 = y.B.

		move.l	d4,d6
		sub.l	d3,d6				;d6 = y inside the sprite.

		rol.l	#8,d1				;d1 = flags.B, x.B, y.B, gfx.B.
		and.b	sprite_mask,d1
		move.b	d1,d3				;d3 = gfx.B.
		lsl.w	#4,d3				;d3 = d3 * 16.

		rol.l	#8,d1				;d1 = x.B, y.B, gfx.B, flags.B.
		btst	#6,d1				;y flipped?
		beq.s	no_aga_spr_yf			;nope.
		eor.b	d5,d6				;y flipped.

no_aga_spr_yf:	lsl.b	#1,d6				;y = y * 2 (for data).
		moveq.l	#0,d7
		add.l	d6,d3
		move.w	(a1,d3.l),d7			;d7 = pattern data.
		beq.w	aga_next_spr			;empty sprite.

		add.l	#$10000,d0			;one sprite more.

		btst	#5,d1				;x flipped?
		beq.s	no_aga_spr_xf			;no.
		move.w	(a3,d7.l*2),d7			;fetch the x flipped data.

no_aga_spr_xf:	move.l	d2,d3
		lsr.b	#3,d3				;d3 = x.B / 8.
		lea	(a2,d3.l),a4			;sprite output at x.

		btst	#4,d1				;which palette?
		bne.s	aga_spr_p1
aga_spr_p0:	add.l	#40*4,a4			;output (data).
		lea	80(a4),a5			;       (mask).
		bra.s	aga_spr_out
aga_spr_p1:	lea	160(a4),a5			;output (mask).
		add.l	#40*6,a4			;       (data).

aga_spr_out:	moveq.l	#0,d3
		move.b	d7,d3				;d3 = 1.B.
		lsr.w	#8,d7				;d7 = 0.B.
		moveq.l	#8,d1
		and.b	#%111,d2			;d2 = bit skip (0-7).
		sub.b	d2,d1
		lsl.w	d1,d7				;shift data 0.
		lsl.w	d1,d3				;shift data 1.
		move.w	d7,d6
		or.w	d3,d6
		eor.w	#$ffff,d6

		IFNE	AGA_FULL_REGISTER_MERGE
		aga_spr_merge_word d6,d7,d2,(a4)
		aga_spr_merge_word d6,d3,d2,40(a4)
		ELSE
		and.w	d6,(a4)
		or.w	d7,(a4)
		add.l	#40,a4
		and.w	d6,(a4)
		or.w	d3,(a4)
		ENDC

		and.w	d6,(a5)
		and.w	d6,40(a5)

aga_next_spr:	dbra	d0,sspr_aga_c8xq		;next sprite.
		swap	d0
		move.b	d0,aga_spr_amount
aga_spr_exit:	rts
