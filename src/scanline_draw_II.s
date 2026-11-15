
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		scanline drawer
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scanline_draw:	tst.b	old_render			;aga mode?
		beq.w	scanline_aga			;yes.

		move.b	output_bit,d7
		cmp.b	frame_update,d7
		bne.w	no_scan_draw			;no draw.

		cmp.l	#144,gb_scanlines		;drawing time?
		bge.w	no_scan_draw			;no!

		move.l	gb_memory,a6			;a6 = the fixed 16bit
		add.l	#$ff40,a6			;a6 = lcd control.
		moveq.l	#0,d6
		move.b	(a6),d6				;d6 = lcd control byte.
		btst	#7,d6				;lcd operation?
		beq.w	no_scan_draw			;no. quit.
		move.l	d6,lcd_control			;store the byte.

		bsr.w	push_z80

		bsr.w	scan_draw_bg			;to the background.

		move.l	aga_sprs_inactive,a1
		move.l	gb_scanlines,d0
		tst.b	(a1,d0.l)			;any old sprites here?
		beq.s	no_scn_spr_clr			;nope.

		move.l	bitmap_spc,a0			;the sprite area.
		move.l	d0,d1
		lsl.w	#4,d0
		lsl.w	#2,d1
		add.l	d1,d0				;d0 = d0 * 20.
		add.l	d0,a0
		lea	2880(a0),a1
;		moveq.l	#160/32-1,d0
		moveq.l	#0,d3
		move.l	d3,(a0)+
		move.l	d3,(a1)+
		move.l	d3,(a0)+
		move.l	d3,(a1)+
		move.l	d3,(a0)+
		move.l	d3,(a1)+
		move.l	d3,(a0)+
		move.l	d3,(a1)+
		move.l	d3,(a0)
		move.l	d3,(a1)

no_scn_spr_clr:	bsr.w	scan_window
		clr.l	aga_spr_amount			;zero done on this scanline.
		bsr.w	scan_sprites			;do them!
		move.l	aga_sprs_inactive,a0
		add.l	gb_scanlines,a0
		move.b	aga_spr_amount,(a0)

		cmp.l	#143,gb_scanlines		;time to update the palette
		bne.s	no_scan_draw_x			;and draw the view?

		bsr.w	update_bg_pal			;yes. do palette.
		bsr.w	screen_draw_pl			;yes. do screen.
		bsr.w	swap_lists_nor

no_scan_draw_x:	bsr.w	pull_z80
no_scan_draw:	rts					;exit.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		execute the background copying
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scan_draw_bg:	move.l	d6,d0				;d0 = lcd control byte.
		btst	#0,d0				;background display?
		beq.w	scan_draw_bgy			;no. quit.

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
		move.l	a0,a1
		add.l	#$9800,a1			;tile position.
		add.l	d0,a1				;selected position.
							;a1 = input tiles.
		moveq.l	#0,d7
		and.b	#%10000,d1			;d1 = background tile
		move.b	d1,d7				;datas. 0/1 * 2048.
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

		move.b	d3,d5
		lsr.w	#3,d3				;d3 = x start.
		and.l	#%11111,d3			;stay inside the range.

		and.l	#%111,d5			;d5 = x pixel scroll (0-7).
		and.l	#%111,d4			;d4 = y pixel scroll (0-7).
		move.b	d5,d0
		swap	d5
		move.b	#8,d5
		sub.b	d0,d5
		swap	d5

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy 160x1
;		INPUT:
;		d3	= (background start x) / 8.
;		d4	= background scroll y.
;		d5	= background scroll x (.W right, .W left).
;		d7	= gb_scanlines.
;		a1	= tiles.
;		a2	= tile datas.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	bitmap_bg,a0			;bitmap (output p0).
		move.l	d7,d1
		lsl.w	#4,d7
		lsl.w	#2,d1
		add.w	d1,d7				;d7 = d7 * 20.

		add.l	d7,a0				;y position fix.
		lea	2880(a0),a3			;bitmap (output p1).

		lsl.b	#1,d4				;d4 = d4 * 2.
		add.l	d4,a2				;y position added.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy 160x1 area
;		INPUT:
;		d3	= (background start x) / 8 (=<31).
;		d5	= background scroll x (.W right, .W left).
;		a0	= bitmap (output p0).
;		a1	= tiles.
;		a2	= tile datas.
;		a3	= bitmap (output p1).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		moveq.l	#160/8/4-1,d0
		move.l	tile_adder,d7
		move.l	d7,a6

load_scn_data:	move.l	a6,d1
		add.b	(a1,d3.l),d1
		addq.b	#1,d3
		lsl.w	#4,d1
		and.b	#$1f,d3
		move.w	(a2,d1.l),d2

		move.l	a6,d1
		add.b	(a1,d3.l),d1
		addq.b	#1,d3
		lsl.w	#4,d1
		and.b	#$1f,d3
		move.w	(a2,d1.l),d4

		move.l	a6,d1
		add.b	(a1,d3.l),d1
		addq.b	#1,d3
		lsl.w	#4,d1
		and.b	#$1f,d3
		move.w	(a2,d1.l),d6

		move.l	a6,d1
		add.b	(a1,d3.l),d1
		addq.b	#1,d3
		lsl.w	#4,d1
		and.b	#$1f,d3
		move.w	(a2,d1.l),d7

		move.b	d2,d1
		lsl.w	#8,d1
		move.b	d4,d1
		lsl.l	#8,d1
		move.b	d6,d1
		lsl.l	#8,d1
		move.b	d7,d1				;d1 = l.B, lm.B, rm.B, r.B.
							;     (p1).
		lsr.w	#8,d4
		move.b	d4,d2
		swap	d2
		move.w	d6,d2
		lsr.w	#8,d7
		move.b	d7,d2				;d2 = l.B, lm.B, rm.B, r.B.
							;     (p0).
		lsl.l	d5,d1
		lsl.l	d5,d2				;both planes shifted.

		move.l	a6,d4
		add.b	(a1,d3.l),d4
		lsl.w	#4,d4
		move.w	(a2,d4.l),d7
		move.b	d7,d6
		swap	d5
		lsr.w	#8,d7
		lsr.b	d5,d6
		lsr.b	d5,d7
		or.b	d6,d1
		or.b	d7,d2

		move.l	d1,(a3)+
		swap	d5
		move.l	d2,(a0)+

		dbra	d0,load_scn_data

scan_draw_bgy:	rts					;exit background drawing.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		do the sprites
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scan_sprites:	move.l	gb_memory,a0
		move.l	a0,a1
		move.l	a0,a2
		add.l	#$fe00+40*4,a0			;a0 = sprite attribute table.
		add.l	#$8000,a1			;a1 = sprite pattern table.
		add.l	#$ff48,a2			;a2 = obj0pal.B, obj1pal.B.
		moveq.l	#40-1,d0			;d0 = number of sprites.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		first fo the sprites beyond the window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	lcd_control,d1			;d1 = lcd control byte.
		btst	#1,d1				;sprites off?
		beq.w	exit_spr			;yes.
		btst	#2,d1				;sprite size?
		bne.w	sspr_n8x16			;8x16.

sspr_n8x8:	move.l	#8-1,sprite_y			;a coming compare fixed
		move.b	#$ff,sprite_mask
		bra.s	sspr_c8xq			;value.
sspr_n8x16:	move.l	#16-1,sprite_y
		move.b	#$fe,sprite_mask

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sprite size 8xq, q=8/16.
;		INPUT:
;		d0	= number of sprites.
;		a0	= sprite attribute table.
;		a1	= sprite pattern table.
;		a2	= obj0pal.B, obj1pal.B.
;		a3	= sprite output planes.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sspr_c8xq:	cmp.b	#10,aga_spr_amount		;max sprites (h/w limit)?
		beq.w	exit_spr			;yes.

		move.l	-(a0),d1			;d1 = y.B, x.B, gfx.B, flags.B.
		swap	d1				;d1 = gfx.B, flags.B, y.B, x.B.
		moveq.l	#0,d2
		moveq.l	#0,d3
		move.b	d1,d2				;d2 = x.B.
		cmp.w	#160+8,d2			;crossed the right border?
		bge.w	next_spr			;yes.

		ror.w	#8,d1				;d1 = gfx.B, flags.B, x.B, y.B.
		move.b	d1,d3				;d3 = y.B.

		move.l	gb_scanlines,d4			;d4 = the scanline number.
		move.l	d4,d5
		add.l	#16,d4				;y position fix.
		move.l	d4,d6
		cmp.w	d3,d4				;scanline lower?
		blt.w	next_spr			;yes.
		move.l	d3,d7
		add.l	sprite_y,d7
		cmp.w	d7,d4				;scanline higher?
		bgt.w	next_spr			;yes.

		move.l	d5,d7
		lsl.w	#4,d5
		lsl.w	#2,d7
		add.w	d7,d5				;d5 = y on screen (d5 * 20).

		sub.l	d3,d6				;d6 = y inside the sprite.
		move.l	bitmap_spc,a4
		move.l	d5,a5				;a5 = output bg  (p0).
		add.l	d5,a4				;a4 = output spr (p0).
		add.l	bitmap_bg,a5

		rol.l	#8,d1				;d1 = flags.B, x.B, y.B, gfx.B.
		and.b	sprite_mask,d1
		move.b	d1,d3				;d3 = gfx.B.
		lsl.w	#4,d3				;d3 = d3 * 16.

		rol.l	#8,d1				;d1 = x.B, y.B, gfx.B, flags.B.
		btst	#6,d1				;y flipped?
		bne.w	sspr_c8xq_flip			;yes.

spr_y_back:	lsl.b	#1,d6				;y = y * 2 (for data).
		moveq.l	#0,d7
		add.l	d6,d3
		move.w	(a1,d3.l),d7			;d7 = pattern data.
		beq.w	next_spr			;empty sprite.

		addq.b	#1,aga_spr_amount		;one more.

		moveq.l	#0,d3
		move.b	d1,d3
		and.b	#%10000,d3			;palette bit.
		lsr.b	#4,d3				;take it down.
		ror.l	#8,d1				;d1 = flags.B, x.B, y.B, gfx.B.
		move.b	(a2,d3.l),d1			;d1 = flags.B, x.B, y.B, pal.B.
		rol.l	#8,d1				;d1 = x.B, y.B, pal.B, flags.B.

		btst	#5,d1				;x flipped?
		bne.w	sspr_c8xq_copyx			;yes.

spr_x_back:	lsr.w	#8,d1				;d1 = x.B, y.B, 0.B, pal.B.
		cmp.w	#8,d2				;x < 8?
		blt.s	spr_less_8			;yes.
		cmp.w	#8+160-8,d2			;152 < x < 160?
		bgt.w	spr_over_152

		subq.l	#8,d2				;x position fix.
		move.l	d2,d4				;d4 = x.B.
		lsr.w	#3,d4				;d4 = x.B / 8.
		add.l	d4,a4				;y and x fixed.
		add.l	d4,a5				;y and x fixed.

		move.w	d7,d3
		bsr.w	spr_col_change

		moveq.l	#0,d7
		move.b	d3,d7				;d7 = 1.B.
		lsr.w	#8,d3				;d3 = 0.B.
		moveq.l	#8,d1
		and.b	#%111,d2			;d2 = bit skip (0-7).
		sub.b	d2,d1
		lsl.w	d1,d7				;shift data 1.
		lsl.w	d1,d3				;shift data 0.
		ror.w	#8,d6
		rol.w	d1,d6				;shift mask.

		and.w	d6,(a4)
		or.w	d3,(a4)
		add.l	#160/8*144,a4
		and.w	d6,(a4)
		or.w	d7,(a4)

		swap	d5				;mask down.
		swap	d6				;adder down.
		ror.w	#8,d5
		ror.w	#8,d6
		rol.w	d1,d5				;shift mask.
		rol.w	d1,d6				;shift adder.
		and.w	d5,(a5)
		or.w	d6,(a5)
		add.l	#160/8*144,a5
		and.w	d5,(a5)
		or.w	d6,(a5)

next_spr:	dbra	d0,sspr_c8xq			;next sprite.
exit_spr:	rts

spr_less_8:	move.w	d7,d3
		bsr.w	spr_col_change

		moveq.l	#8,d1
		and.b	#%111,d2
		sub.b	d2,d1

		move.b	d3,d7				;d7 = 1.B.
		clr.b	d3
		lsl.w	#8,d7
		lsl.w	d1,d7
		lsl.w	d1,d3
		lsl.w	d1,d6				;shift mask.
		moveq.l	#1,d2
		lsl.b	d1,d2
		subq.b	#1,d2
		or.b	d2,d6

		and.w	d6,(a4)
		or.w	d3,(a4)
		add.l	#160/8*144,a4
		and.w	d6,(a4)
		or.w	d7,(a4)

		swap	d5				;mask down.
		swap	d6				;adder down.
		lsl.w	d1,d5				;shift mask.
		lsl.w	d1,d6				;shift adder.
		or.b	d2,d5
		and.w	d5,(a5)
		or.w	d6,(a5)
		add.l	#160/8*144,a5
		and.w	d5,(a5)
		or.w	d6,(a5)

		dbra	d0,sspr_c8xq			;next sprite.
		rts

spr_over_152:	add.l	#(160/8)-2,a4
		add.l	#(160/8)-2,a5

		move.w	d7,d3
		bsr.w	spr_col_change

		and.b	#%111,d2
		moveq.l	#0,d7
		move.b	d3,d7				;d7 = 1.B.
		lsr.w	#8,d3
		lsr.b	d2,d7
		lsr.b	d2,d3

		addq.b	#8,d2
		move.l	#$ffff0000,d1
		move.w	d6,d1
		asr.l	d2,d1

		and.w	d1,(a4)
		or.w	d3,(a4)
		add.l	#160/8*144,a4
		and.w	d1,(a4)
		or.w	d7,(a4)

		move.w	#$ffff,d5
		swap	d5				;mask down.
		swap	d6				;adder down.
		asr.l	d2,d5				;shift mask.
		lsr.w	d2,d6				;shift adder.
		and.w	d5,(a5)
		or.w	d6,(a5)
		add.l	#160/8*144,a5
		and.w	d5,(a5)
		or.w	d6,(a5)

		dbra	d0,sspr_c8xq			;next sprite.
		rts

sspr_c8xq_copyx:move.l	x_flip_table,a3
		move.w	(a3,d7.l*2),d7			;fetch the x flipped data.
		bra.w	spr_x_back

sspr_c8xq_flip:	move.b	sprite_y+3,d4
		eor.b	d4,d6				;y flipped.
		bra.w	spr_y_back

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		draw a scanline of the window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scan_window:	move.l	lcd_control,d3			;d3 = lcd control byte.
		btst	#5,d3				;window display?
		beq.w	scan_draw_wxt			;nope.
		btst	#0,d3
		beq.w	scan_draw_wxt

		move.l	gb_memory,a0			;a0 = the fixed 16bit
		move.l	a0,a2

		moveq.l	#0,d0
		add.l	#$ff4a,a2			;a2 = window y position.
		move.b	(a2)+,d0			;d0 = window y pos ($ff4A).
		move.l	gb_scanlines,d2			;d2 = the current scanline.
		cmp.w	d0,d2
		blt.w	scan_draw_wxt			;window not achieved, yet.

		moveq.l	#0,d1
		move.b	(a2),d1				;d1 = window x pos ($ff4B).
		subq.w	#7,d1				;x position fix.
		bge.s	win_win_ok
		clr.w	d1
win_win_ok:	cmp.w	#160,d1
		bge.w	scan_draw_wxt			;right out!

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
		move.l	d3,d6
		lsl.w	#4,d3
		lsl.w	#2,d6
		add.w	d6,d3				;d3 = d3 * (160/8).
		move.l	bitmap_bg,a3
		add.l	d7,d3				;d3 = x and y.
		add.l	d3,a3				;a3 = output bg  (p0).

		and.l	#%111,d2			;d2 = scanline adder.
		move.l	#160/8,d3
		lsl.b	#1,d2				;data size fix.
		sub.b	d7,d3				;d3 = delta x in bytes.
		ble.s	scan_draw_wxt			;too little bytes!
		and.l	#%111,d1			;d1 = x right shifter.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		INPUT:
;		d1	= x pixels to right shifter.
;		d2	= the scanline adder.
;		d3	= delta x in bytes.
;		a0	= window tiles.
;		a1	= window tile pattern table.
;		a3	= background plane 0.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		subq.w	#1,d3				;dbra correction.
		move.w	#$00ff,d6
		ror.w	d1,d6				;solid mask.
		add.l	d2,a1				;y inside the block.
		move.l	a3,a4
		add.l	#160/8*144,a4

scan_win_solid:	move.l	tile_adder,d0
		add.b	(a0)+,d0
		lsl.w	#4,d0
		move.w	(a1,d0.l),d4			;d4 = data.

		move.b	d4,d5				;d5 = 1.B.
		and.w	d6,(a3)
		clr.b	d4
		lsl.w	#8,d5
		and.w	d6,(a4)
		lsr.w	d1,d4				;shift data.
		lsr.w	d1,d5

		or.w	d4,(a3)
		addq.l	#1,a3
		or.w	d5,(a4)
		addq.l	#1,a4
		dbra	d3,scan_win_solid		;next byte.
scan_draw_wxt:	rts
