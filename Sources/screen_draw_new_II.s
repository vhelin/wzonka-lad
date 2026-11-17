
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		screen draw - the next generation edition ;)
;
;		what are the main differences between this and the older
;		generation screen_draw_x.S? here they come...
;
;		all the things are rendered directly into chip ram.
;		no memory areas are allocated for masking or something
;		like that. here's the dimensions for the chip ram area:
;		16+160+16 = 192 (32 bit) pixels wide and
;		16+144+16 = 176 (16 bit) pixels height planar data area.
;
;		first the background is copied to the chip area.
;		start x = 8, start y = 16.
;		then comes the h/w window.
;		start x = 8, start y = 16 (remember to add the scroll pixels!).
;		then come the sprites.
;		start x = 0, start y = 0 (remember to add the scroll pixels!).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_draw:	tst.b	old_render			;aga?
		beq.w	aga_screen_draw			;yes.

		move.l	a2,a6				;a6 = the fixed 16bit
		add.l	#$ff40,a6			;a6 = lcd control.
		moveq.l	#0,d7
		move.b	(a6),d7				;d7 = lcd control byte.
		btst	#7,d7				;lcd operation?
		beq.s	no_screen_draw			;no. clear and quit.
		move.l	d7,lcd_control			;store the byte.

		bsr.w	push_z80

		bsr.w	screen_draw_bg			;do the background copy.
		bsr.w	screen_draw_wi			;do the window copy.
		bsr.w	screen_sprites			;do them!
		bsr.w	swap_lists_nor			;swap the sprite y lists.
		bsr.w	screen_draw_pl			;all h/w effects are done!
		bsr.w	update_bg_pal			;output the palette.

		bsr.w	pull_z80

no_screen_draw:	rts					;exit.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		empty screen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_empty:	tst.b	old_render			;aga?
		beq.s	aga_empty			;yes.

		move.l	bitmap_spc,a0
		move.l	bitmap_bg,a1

		moveq.l	#0,d1
		tst.b	old_refresh			;mode 144/144?
		bne.s	e_normal			;no.
		move.w	#160/32*144*2-1,d0		;yes.
		bra.s	empty_all
e_normal:	move.w	#gb_screen_x/32*gb_screen_y*2-1,d0
empty_all:	move.l	d1,(a0)+
		move.l	d1,(a1)+
		dbra	d0,empty_all
		rts

aga_empty:	move.l	aga_map_I,a0
		move.l	aga_map_II,a1
		move.w	#40*256*8/4/4-1,d0
		moveq.l	#0,d1
aga_empty_all:	move.l	d1,(a0)+
		move.l	d1,(a0)+
		move.l	d1,(a0)+
		move.l	d1,(a0)+
		move.l	d1,(a1)+
		move.l	d1,(a1)+
		move.l	d1,(a1)+
		move.l	d1,(a1)+
		dbra	d0,aga_empty_all
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		swap the speedup buffers
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

swap_lists_nor:	cmp.b	#2,old_render			;window?
		beq.s	sprs_xx_done			;yes. no buffer changes.

		move.l	aga_sprs_inactive,d7
		cmp.l	aga_sprs_cI,d7
		beq.s	sprs_II_in_nor
sprs_I_in_nor:	move.l	aga_sprs_cI,aga_sprs_inactive
		move.l	aga_sprs_cxI,aga_sprs_inactive_x
sprs_xx_done:	rts
sprs_II_in_nor:	move.l	aga_sprs_cII,aga_sprs_inactive
		move.l	aga_sprs_cxII,aga_sprs_inactive_x
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		recreate and update the background palette
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

update_bg_pal:	tst.b	old_render			;window/screen?
		beq.w	no_upd_col			;nope

		move.l	gb_memory,a0
		add.l	#$ff47,a0			;bgrdpal (background palette).
		moveq.l	#0,d0
		move.b	(a0),d0				;d0 = palette byte.

		cmp.b	#2,old_render
		beq.w	window_colour_update

		lea	gb_pale,a1			;a1 = output palette.
		lea	gameboy_colours,a2
		tst.l	cartridge
		bne.s	update_bg_ok

		move.b	#%11100100,d0			;default palette position.

update_bg_ok:	moveq.l	#4-1,d7

update_bg_clx:	move.l	d0,d1
		and.b	#%11,d1				;colour (0-3).
		move.l	(a2,d1.l*4),d1
		move.l	d1,d2
		clr.w	d1
		lsl.l	#8,d1
		move.l	d1,(a1)+
		move.l	d2,d1
		and.l	#$0000ff00,d1
		swap	d1
		move.l	d1,(a1)+
		and.l	#$000000ff,d2
		ror.l	#8,d2
		move.l	d2,(a1)+			;colour (0-3) loaded.
		lsr.b	#2,d0
		dbra	d7,update_bg_clx

		add.l	#4*4,a2				;to sprite palette.
		moveq.l	#4-1,d0
move_spr_clrs:	move.l	(a2)+,d1
		move.l	d1,d2
		move.l	d1,d3
		clr.w	d1
		lsl.l	#8,d1
		move.l	d1,(a1)+
		and.l	#$0000ff00,d2
		swap	d2
		move.l	d2,(a1)+
		and.l	#$000000ff,d3
		ror.l	#8,d3
		move.l	d3,(a1)+			;colour (0-3) loaded.
		move.l	d1,(a1)+
		move.l	d2,(a1)+
		move.l	d3,(a1)+
		move.l	d1,(a1)+
		move.l	d2,(a1)+
		move.l	d3,(a1)+
		dbra	d0,move_spr_clrs

		move.l	gb_screen_ptr,d0		;the screen.
		beq.s	no_upd_col
		move.l	graphics_base,a6
		move.l	d0,a0
		lea	sc_ViewPort(a0),a0		;the view port.
		lea	gb_pal,a1			;the background palette.
		jsr	LoadRGB32(a6)			;load in the new colours.
no_upd_col:	rts					;exit the palette part.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		update window "palette"
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

window_colour_update:
		move.b	back_ground_colour_byte,d5
		cmp.b	d5,d0
		beq.s	window_colour_update_exit
		move.b	d0,back_ground_colour_byte
		eor.b	d0,d5

		lea	pen_list,a2
		lea	gameboy_colours_conversion_table,a1
		moveq.l	#4-1,d7

update_window_clx:
		move.l	d0,d1
		and.b	#%11,d1
		move.b	(a2,d1.l),(a1)+
		lsr.b	#2,d0
		dbra	d7,update_window_clx

		lea	gameboy_colours_conversion_table,a0
		move.l	pen_conversion_table,a1
		moveq.l	#0,d3
		moveq.l	#0,d7

		move.b	d5,d0
		and.b	#%11,d0
		beq.s	no_colour_change_0
		bsr.b	do_conversion_table_x

no_colour_change_0:
		move.b	d5,d0
		and.b	#%1100,d0
		beq.s	no_colour_change_1
		move.b	#1,d7
		bsr.b	do_conversion_table_x

no_colour_change_1:
		move.b	d5,d0
		and.b	#%110000,d0
		beq.s	no_colour_change_2
		move.b	#2,d7
		bsr.b	do_conversion_table_x

no_colour_change_2:
		move.b	d5,d0
		and.b	#%11000000,d0
		beq.s	window_colour_update_exit
		move.b	#3,d7
		bsr.b	do_conversion_table_x

window_colour_update_exit:
		rts

do_conversion_table_x:
		move.b	(a0,d7.l),d4
		moveq.l	#16-1,d1
		move.b	d7,d6
		lsl.w	#8,d4
		lsl.w	#8,d6
		lea	16(a0),a2
do_conversion_table_copy_x:
		move.w	d4,d2
		move.w	d6,d3
		move.b	-(a2),d2
		move.b	d1,d3
		move.w	d2,(a1,d3.l*2)
		ror.w	#8,d2
		ror.w	#8,d3
		move.w	d2,(a1,d3.l*2)
		dbra	d1,do_conversion_table_copy_x
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		execute the background copying
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_draw_bg:	move.l	d7,d0				;d0 = lcd control byte.
		btst	#0,d0				;background display?
		beq.w	no_upd_col			;no. quit.

		move.l	a2,a1
		add.l	#$ff42,a1			;a1 = lcd control.
		moveq.l	#0,d2
		move.b	(a1)+,d2			;d2 = bg scroll y.
		moveq.l	#0,d3
		move.b	(a1),d3				;d3 = bg scroll x.

		move.l	d0,d1				;d1 = the control byte.
		and.b	#%1000,d0			;d0 = background tiles.
		lsl.w	#7,d0				;0/1 * 1024.
		move.l	a2,a1
		add.l	#$9800,a1			;tile position.
		add.l	d0,a1				;selected position.
							;a1 = input tiles.
		and.b	#%10000,d1			;d1 = background tile
		move.l	d1,d7				;datas. 0/1 * 2048.
		lsl.b	#3,d1				;d7 = tile adder (signed/
		bchg	#7,d1				;unsigned).
		move.l	d1,tile_adder
		lsl.w	#7,d7
		add.l	#$8800,a2			;tile data position.
		sub.l	d7,a2				;selected position.
							;a2 = input tile datas.
		move.l	a2,gb_tiles

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy background data
;		INPUT:
;		d1	= tile adder.
;		d2	= background scroll y.
;		d3	= background scroll x.
;		a1	= tiles.
;		a2	= tile datas.
;		NOTE:
;		output plane information: 192x176 (+4, +4). background tiles
;		will be positioned starting at +1, +2.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	d2,d4
		move.l	d3,d5
		lsr.b	#3,d2				;d2 = number of rows
							;to be skipped.
		lsl.w	#5,d2				;d2 = d2 * 32 (start y).
		lsr.b	#3,d3				;d3 = x start.

		and.b	#%111,d5			;d5 = x pixel scroll (0-7).
		and.b	#%111,d4			;d4 = y pixel scroll (0-7).
		move.l	d5,bg_scroll_x			;store the scroll values.
		move.l	d4,bg_scroll_y

		move.l	bitmap_bg,a0			;a0 = p0.
		add.l	#(192/8)*16,a0			;output position fix.
		lea	4224(a0),a3			;a3 = p1.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy 176x8 lines
;		INPUT:
;		d2	= (background start y) / 8 * 32.
;		d3	= (background start x) / 8.
;		a0	= output (p0).
;		a1	= tiles.
;		a2	= tile datas.
;		a3	= output (p1).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		moveq.l	#19-1,d0
qdo_16x8_cdata:	move.l	d2,d7
		or.b	d3,d7
		move.l	d1,d4
		add.b	(a1,d7.l),d4
		lsl.w	#4,d4
		lea	(a2,d4.l),a4

		moveq.l	#8-1,d4
so_16x8_cdata:	move.w	(a4)+,d5
		move.w	d5,d6
		lsr.w	#8,d6

		move.w	d5,(a3)
		move.w	d6,(a0)
		add.l	#192/8,a3
		add.l	#192/8,a0
		dbra	d4,so_16x8_cdata

		add.w	#32,d2
		and.w	#$3ff,d2
		dbra	d0,qdo_16x8_cdata

		sub.l	#((192/8)*8*19)-2,a0
		sub.l	#((192/8)*8*19)-2,a3
		addq.b	#1,d3
		and.b	#$1f,d3
		sub.w	#19*32,d2
		and.w	#$3ff,d2

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sweeper core
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	#10,x_counter
zdo_16x8_cdata:	moveq.l	#19-1,d0
xdo_16x8_cdata:	move.l	d2,d7
		or.b	d3,d7
		move.l	d1,d4
		add.b	(a1,d7.l),d4
		lsl.w	#4,d4
		addq.b	#1,d3
		lea	(a2,d4.l),a4
		and.b	#$1f,d3

		move.l	d2,d7
		or.b	d3,d7
		move.l	d1,d4
		add.b	(a1,d7.l),d4
		lsl.w	#4,d4
		subq.b	#1,d3
		lea	(a2,d4.l),a5
		and.b	#$1f,d3

		moveq.l	#8-1,d4
do_16x8_cdata:	move.w	(a4)+,d5
		move.b	d5,d6
		lsl.w	#8,d6
		move.w	(a5)+,d7
		move.b	d7,d6
		lsr.w	#8,d7
		move.b	d7,d5

		move.w	d6,(a3)
		move.w	d5,(a0)
		add.l	#192/8,a3
		add.l	#192/8,a0
		dbra	d4,do_16x8_cdata

		add.w	#32,d2
		and.w	#$3ff,d2
		dbra	d0,xdo_16x8_cdata

		sub.l	#((192/8)*8*19)-2,a0
		sub.l	#((192/8)*8*19)-2,a3
		addq.b	#2,d3
		and.b	#$1f,d3
		sub.w	#19*32,d2
		and.w	#$3ff,d2

		subq.l	#1,x_counter
		bne.s	zdo_16x8_cdata

xit_cdata:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		do the window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_draw_wi:	move.l	lcd_control,d0			;d0 = lcd control byte.
		btst	#5,d0				;window display?
		beq.s	xit_cdata			;nope.
		btst	#0,d0
		beq.s	xit_cdata

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
		bne.s	win_win_no_no
		addq.l	#1,d1

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		INPUT:
;		a0	= window tiles.
;		a1	= window tile pattern table.
;		d0	= window y position.
;		d1	= window x position.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

win_win_no_no:	move.l	d0,d6				;d6 = window y position.
		move.l	d1,d7				;d7 = window x position.
		lsr.l	#3,d6				;d6 = y in bytes.
		lsr.l	#3,d7				;d7 = x in bytes.

		add.l	bg_scroll_y,d0
		add.l	#16,d0				;h/w window y position fix!
		move.w	d0,d2
		lsl.w	#3,d2
		lsl.w	#4,d0
		add.w	d2,d0				;d0 = d0 * (192/8).
		add.l	bg_scroll_x,d1			;d1 = x scroll.
		move.l	d1,d2
		lsr.l	#3,d2				;x = bytes.
		add.l	d2,d0				;d0 = x and y fixed.
		move.l	d0,a2
		add.l	bitmap_bg,a2			;a2 = output area (p0).
		and.l	#%111,d1			;d1 = the inverted shift amount.
		eor.b	#%111,d1			;d1 = the shift amount.
		lea	4224(a2),a3			;a3 = output area (p1).

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		a non transparent h/w window emulator
;		INPUT:
;		d0	= x and y added for the start position.
;		d1	= the shift amount.
;		d6	= window y position.
;		d7	= window x position.
;		a0	= window tiles.
;		a1	= window tile pattern table.
;		a2	= output area (p0).
;		a3	=             (p1).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		subq.l	#1,d7				;window x correction (h/w).
		move.l	d7,tile_adder_x
		neg.l	d7				;compute the difference.
		sub.l	#160/8,tile_adder_x
		add.l	#32,tile_adder_x
		add.l	#160/8-1,d7
		blt.w	screen_draw_wxt			;too much right.
		move.l	d7,win_x

		neg.l	d6				;compute the difference.
		add.l	#144/8-1,d6
		blt.w	screen_draw_wxt			;too much down.

		move.w	#$ff00,d4			;solid mask.
		rol.w	d1,d4				;mask shifted.

window_loop_y:	move.l	win_x,d7			;d7 = x-1.

copy_8x8:	move.l	tile_adder,d5			;signum fix.
		add.b	(a0)+,d5			;d5 = left up tile.
		lsl.w	#4,d5				;d5 = d5 * 16.
		lea	(a1,d5.l),a6			;a6 = tile data.

		moveq.l	#8-1,d5
copy_8x8_data:	moveq.l	#0,d3
		move.w	(a6)+,d2			;d2 = L01.
		move.b	d2,d3				;d3 = xxL1.
		and.w	d4,(a2)
		lsr.w	#8,d2				;d2 = xxL0.
		and.w	d4,(a3)				;background masked.

		lsl.w	d1,d2				;p0 shifted.
		or.w	d2,(a2)				;p0 done.
		lsl.w	d1,d3				;p1 shifted.
		add.l	#192/8,a2			;next y (screen).
		or.w	d3,(a3)				;p1 done.
		add.l	#192/8,a3			;               .
		dbra	d5,copy_8x8_data		;next y (register).

		sub.l	#(8*192/8)-1,a2			;next x position.
		sub.l	#(8*192/8)-1,a3			;               .
		sub.l	#(8*192/8)-1,a4			;               .
		sub.l	#(8*192/8)-1,a5			;               .
		dbra	d7,copy_8x8			;do next 8x8.

		add.l	#192/8*8,d0			;next 192x8 line.
		move.l	d0,a2
		add.l	bitmap_bg,a2			;a2 = output area (p0).
		lea	4224(a2),a3			;a3 = output area (p1).
		add.l	tile_adder_x,a0			;update input position.
		dbra	d6,window_loop_y		;next y.
screen_draw_wxt:rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		do the sprites
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_sprites:	move.l	bitmap_spc,a0			;the sprite area.
		move.l	a0,a1
		add.l	#gb_screen_x/8*gb_screen_y,a1

fast_clearing:	move.l	aga_sprs_inactive,a2
		move.w	#gb_screen_y-1,d0
		move.l	#gb_screen_x/8,d2
spr_scnr_empty:	tst.b	(a2)
		bne.s	clear_me
		add.l	d2,a0
		addq.l	#1,a2
		add.l	d2,a1
		dbra	d0,spr_scnr_empty
		bra.s	lines_done
clear_me:	clr.b	(a2)+
		moveq.l	#gb_screen_x/8/4-1,d1
clear_us:	clr.l	(a0)+
		clr.l	(a1)+
		dbra	d1,clear_us
		dbra	d0,spr_scnr_empty

lines_done:	move.l	lcd_control,d1			;d1 = lcd control byte.
		btst	#1,d1				;sprites off?
		beq.w	spr_exit			;yes.

		move.l	gb_memory,a0
		move.l	a0,a1
		move.l	a0,a2
		add.l	#$fe00+40*4,a0			;a0 = sprite attribute table.
		add.l	#$8000,a1			;a1 = sprite pattern table.
		add.l	#$ff48,a2			;a2 = obj0pal.B, obj1pal.B.
		moveq.l	#40-1,d0			;d0 = number of sprites.

		btst	#2,d1				;sprite size?
		bne.w	spr_n8x16			;8x16.

spr_n8x8:	move.l	#8-1,sprite_y
		move.l	#8/4-1,sprite_sign
		move.b	#$ff,sprite_mask
		bra.s	spr_c8xq			;do the copying.
spr_n8x16:	move.l	#16-1,sprite_y
		move.l	#16/4-1,sprite_sign
		move.b	#$fe,sprite_mask

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sprite size 8xq, q=8/16.
;		INPUT:
;		d0	= number of sprites.
;		a0	= sprite attribute table.
;		a1	= sprite pattern table.
;		a2	= obj0pal.B, obj1pal.B.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

spr_c8xq:	move.l	-(a0),d1			;d1 = y.B, x.B, gfx.B, flags.B.
		move.l	d1,d2
		swap	d2
		tst.b	d2
		beq.w	empty_sprite
		lsr.w	#8,d2
		beq.w	empty_sprite

spr_xcute:	swap	d1				;d1 = gfx.B, flags.B, y.B, x.B.
		move.l	bg_scroll_x,d2			;x start (bg scroll pixels).
		add.b	d1,d2				;d2 = x.B.
		cmp.w	#8+160+8,d2			;out of vision?
		bge.w	spr_xit				;yes.

		move.l	bg_scroll_y,d3			;y start (bg scroll pixels).
		ror.w	#8,d1				;d1 = gfx.B, flags.B, x.B, y.B.
		add.b	d1,d3				;d3 = y.B.
		cmp.w	#16+144+8,d3			;out of vision?
		bge.w	spr_xit				;yes.

		move.l	aga_sprs_inactive,a6		;set the marks for clearing.
		add.l	d3,a6
		move.l	sprite_sign,d4
mark_loop:	move.l	#$01010101,(a6)+
		dbra	d4,mark_loop

		move.l	sprite_y,d7			;d7 = y-1.
		move.w	d3,d6
		lsl.w	#3,d6
		lsl.w	#4,d3
		add.w	d6,d3				;d3 = y on screen.
							;(d3 = d3 * 192/8).
		move.l	d2,d4				;d4 = x.B.
		lsr.w	#3,d4				;d4 = x.B / 8.
		add.l	d4,d3				;d3 = y and x fixed.
		move.l	bitmap_spc,a4
		move.l	bitmap_bg,a5
		and.b	#%111,d2			;d2 = bit skip (0-7).
		add.l	d3,a4				;a4 = output spr (p0).
		add.l	d3,a5				;a5 = output bg  (p0).
		rol.l	#8,d1				;d1 = flags.B, x.B, y.B, gfx.B.
		and.b	sprite_mask,d1
		move.b	d1,d4				;d4 = gfx.B.
		lsl.w	#4,d4				;d4 = d4 * 16.
		lea	(a1,d4.l),a6			;a6 = pattern data.

		rol.l	#8,d1				;d1 = x.B, y.B, gfx.B, flags.B.
		moveq.l	#0,d3
		move.b	d1,d3
		and.b	#%10000,d3			;palette bit.
		lsr.b	#4,d3				;take it down.
		ror.l	#8,d1				;d1 = flags.B, x.B, y.B, gfx.B.
		move.b	(a2,d3.l),d1			;d1 = flags.B, x.B, y.B, pal.B.
		rol.l	#8,d1				;d1 = x.B, y.B, pal.B, flags.B.

		btst	#6,d1				;y flipped?
		bne.w	spr_c8xq_flip			;yes.

		btst	#5,d1				;x flipped?
		bne.s	spr_c8xq_copyx			;yes.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		normal output
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lsr.w	#8,d1				;d1 = pal.B.
spr_c8xq_copy:	move.w	(a6)+,d3			;d3 = 01.
		beq.w	next_I
		bsr.w	spr_col_change			;real colours.

		move.b	d3,d4				;d4 = 01.
		clr.b	d3				;d3 = 0x.
		lsr.w	d2,d3				;bits skipped.
		lsl.w	#8,d4				;d4 = 1x.
		lsr.w	d2,d4				;bits skipped.
		ror.w	d2,d6				;d6 = and mask.

		and.w	d6,(a4)				;mask p0.
		or.w	d3,(a4)
		add.l	#4224,a4
		and.w	d6,(a4)				;mask p1.
		or.w	d4,(a4)
		sub.l	#4224-(192/8),a4		;next y.

		swap	d6				;adder down.
		swap	d5				;mask down.
		ror.w	d2,d6				;adder bits skipped.
		ror.w	d2,d5				;and mask bits skipped.
		and.w	d5,(a5)
		or.w	d6,(a5)
		add.l	#4224,a5
		and.w	d5,(a5)
		or.w	d6,(a5)
		sub.l	#4224-(192/8),a5

		dbra	d7,spr_c8xq_copy		;next y (register).
spr_xit:	dbra	d0,spr_c8xq			;next sprite.
spr_exit:	rts

next_I:		add.l	#192/8,a4
		add.l	#192/8,a5
		dbra	d7,spr_c8xq_copy		;next y (register).
empty_sprite:	dbra	d0,spr_c8xq			;next sprite.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		x flipped output
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
spr_c8xq_copyx:	lsr.w	#8,d1				;d1 = pal.B.

spr_c8xq_xopyx:	moveq.l	#0,d3
		move.l	x_flip_table,a3
		move.w	(a6)+,d3			;d3 = 01.
		beq.s	next_II
		move.w	(a3,d3.l*2),d3			;d3 = x flipped data.
		bsr.w	spr_col_change			;real colours.

		move.b	d3,d4				;d4 = 01.
		clr.b	d3				;d3 = 0x.
		lsr.w	d2,d3				;bits skipped.
		lsl.w	#8,d4				;d4 = 1x.
		lsr.w	d2,d4				;bits skipped.
		ror.w	d2,d6				;d6 = and mask.

		and.w	d6,(a4)				;mask p0.
		or.w	d3,(a4)
		add.l	#4224,a4
		and.w	d6,(a4)				;mask p1.
		or.w	d4,(a4)
		sub.l	#4224-(192/8),a4		;next y.

		swap	d6				;adder down.
		swap	d5				;mask down.
		ror.w	d2,d6				;adder bits skipped.
		ror.w	d2,d5				;and mask bits skipped.
		and.w	d5,(a5)
		or.w	d6,(a5)
		add.l	#4224,a5
		and.w	d5,(a5)
		or.w	d6,(a5)
		sub.l	#4224-(192/8),a5

		dbra	d7,spr_c8xq_xopyx		;next y (register).
		dbra	d0,spr_c8xq			;next sprite.
		rts

next_II:	add.l	#192/8,a4
		add.l	#192/8,a5
		dbra	d7,spr_c8xq_xopyx		;next y (register).
		dbra	d0,spr_c8xq			;next sprite.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		y flipped output
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
spr_c8xq_flip:	move.l	d7,d4				;d4 = y-1.
		addq.b	#1,d4				;d4 = y.
		lsl.b	#1,d4				;d4 = y*2.
		add.l	d4,a6				;y fixed.

		btst	#5,d1				;x flipped?
		bne.s	spr_c8xq_copyxy			;yes.

		lsr.w	#8,d1				;d1 = pal.B.
spr_c8xq_copyy:	move.w	-(a6),d3			;d3 = 01.
		beq.s	next_III
		bsr.w	spr_col_change			;real colours.

		move.b	d3,d4				;d4 = 01.
		clr.b	d3				;d3 = 0x.
		lsr.w	d2,d3				;bits skipped.
		lsl.w	#8,d4				;d4 = 1x.
		lsr.w	d2,d4				;bits skipped.
		ror.w	d2,d6				;d6 = and mask.

		and.w	d6,(a4)				;mask p0.
		or.w	d3,(a4)
		add.l	#4224,a4
		and.w	d6,(a4)				;mask p1.
		or.w	d4,(a4)
		sub.l	#4224-(192/8),a4		;next y.

		swap	d6				;adder down.
		swap	d5				;mask down.
		ror.w	d2,d6				;adder bits skipped.
		ror.w	d2,d5				;and mask bits skipped.
		and.w	d5,(a5)
		or.w	d6,(a5)
		add.l	#4224,a5
		and.w	d5,(a5)
		or.w	d6,(a5)
		sub.l	#4224-(192/8),a5

		dbra	d7,spr_c8xq_copyy		;next y (register).
		dbra	d0,spr_c8xq			;next sprite.
		rts

next_III:	add.l	#192/8,a4
		add.l	#192/8,a5
		dbra	d7,spr_c8xq_copyy		;next y (register).
		dbra	d0,spr_c8xq			;next sprite.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		x and y flipped output
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
spr_c8xq_copyxy:lsr.w	#8,d1				;d1 = pal.B.

spr_c8xq_xopyxy:moveq.l	#0,d3
		move.l	x_flip_table,a3
		move.w	-(a6),d3			;d3 = 01.
		beq.s	next_IIII
		move.w	(a3,d3.l*2),d3			;d3 = x flipped data.
		bsr.b	spr_col_change			;real colours.

		move.b	d3,d4				;d4 = 01.
		clr.b	d3				;d3 = 0x.
		lsr.w	d2,d3				;bits skipped.
		lsl.w	#8,d4				;d4 = 1x.
		lsr.w	d2,d4				;bits skipped.
		ror.w	d2,d6				;d6 = and mask.

		and.w	d6,(a4)				;mask p0.
		or.w	d3,(a4)
		add.l	#4224,a4
		and.w	d6,(a4)				;mask p1.
		or.w	d4,(a4)
		sub.l	#4224-(192/8),a4		;next y.

		swap	d6				;adder down.
		swap	d5				;mask down.
		ror.w	d2,d6				;adder bits skipped.
		ror.w	d2,d5				;and mask bits skipped.
		and.w	d5,(a5)
		or.w	d6,(a5)
		add.l	#4224,a5
		and.w	d5,(a5)
		or.w	d6,(a5)
		sub.l	#4224-(192/8),a5

		dbra	d7,spr_c8xq_xopyxy		;next y (register).
		dbra	d0,spr_c8xq			;next sprite.
		rts

next_IIII:	add.l	#192/8,a4
		add.l	#192/8,a5
		dbra	d7,spr_c8xq_xopyxy		;next y (register).
		dbra	d0,spr_c8xq			;next sprite.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		change the sprite's colours to the real ones
;		INPUT:
;		d1	= palette entries .B.
;			= xxyyzzcc,
;			  xx = value for colour 3.
;			  yy =                  2.
;			  zz =                  1.
;			  cc =                  0 (processing not required, because
;						   this is the tranparent colour).
;		d3	= .W data (p0.B, p1.B).
;		d4	= available for mutation.
;		d5	=			.
;		d6	=			.
;		OUTPUT:
;		d3	= .W manipulated data (p0.B, p1.B).
;		d5	= .W bg p0 and p1 mask, .W rubbish.
;		d6	= .W bg p0 and p1 adder, .W mask.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
spr_col_change:	moveq.l	#8-1,d4				;this many pixels.
		move.l	#$00ff0000+16-1,d5		;d5 = mask.W, bit pointer.W.
		move.l	#$000000ff,d6			;d6 = adder.W, mask.W.

spr_col_do:	btst	d4,d3				;p1 bit test.
		bne.s	spr_col_p0set			;it's 1!
spr_col_p0clr:	btst	d5,d3				;p0 bit test.
		bne.s	spr_col_01			;it's 1!

spr_col_00:	bset	d5,d6				;manipulate the mask.
		swap	d2
		move.b	d5,d2
		swap	d5
		bset	d2,d5
		swap	d5
		swap	d2
		subq.b	#1,d5				;one down. do no changes.
		dbra	d4,spr_col_do			;next colour.
		rts					;exit.

		cnop	0,4
spr_col_01:	btst	#3,d1				;p0 new colour.
		bne.s	spr_col_01_p01
spr_col_01_p00:	btst	#2,d1				;p1 new colour.
		bne.s	spr_col_01_p001
spr_col_01_p000:bset	d5,d3
		bclr	d4,d3
		subq.b	#1,d5				;one down.
		dbra	d4,spr_col_do			;next colour.
		rts					;exit.
spr_col_01_p001:bclr	d5,d3
		bset	d4,d3
		subq.b	#1,d5				;one down. do no changes.
		dbra	d4,spr_col_do			;next colour.
		rts					;exit.
spr_col_01_p01:	btst	#2,d1				;p1 new colour.
		bne.s	spr_col_01_p011
spr_col_01_p010:bset	d5,d3
		bset	d4,d3
		subq.b	#1,d5				;one down.
		dbra	d4,spr_col_do			;next colour.
		rts					;exit.
spr_col_01_p011:bset	d4,d3
		bset	d5,d3
		swap	d6
		bset	d5,d6				;adder set.
		swap	d6
		subq.b	#1,d5				;one down. do no changes.
		dbra	d4,spr_col_do			;next colour.
		rts					;exit.

		cnop	0,4
spr_col_p0set:	btst	d5,d3				;p0 bit test.
		bne.s	spr_col_11			;it's 1!

spr_col_10:	btst	#5,d1				;p0 new colour.
		bne.s	spr_col_10_p01
spr_col_10_p00:	btst	#4,d1				;p1 new colour.
		bne.s	spr_col_10_p001
spr_col_10_p000:bset	d5,d3
		bclr	d4,d3
		subq.b	#1,d5				;one down.
		dbra	d4,spr_col_do			;next colour.
		rts					;exit.
spr_col_10_p001:bclr	d5,d3
		bset	d4,d3
		subq.b	#1,d5				;one down. do no changes.
		dbra	d4,spr_col_do			;next colour.
		rts					;exit.
spr_col_10_p01:	btst	#4,d1				;p1 new colour.
		bne.s	spr_col_10_p011
spr_col_10_p010:bset	d5,d3
		bset	d4,d3
		subq.b	#1,d5				;one down.
		dbra	d4,spr_col_do			;next colour.
		rts					;exit.
spr_col_10_p011:bset	d5,d3
		bset	d4,d3
		swap	d6
		bset	d5,d6				;adder set.
		swap	d6
		subq.b	#1,d5				;one down. do no changes.
		dbra	d4,spr_col_do			;next colour.
		rts					;exit.

		cnop	0,4
spr_col_11:	btst	#7,d1				;p0 new colour.
		bne.s	spr_col_11_p01
spr_col_11_p00:	btst	#6,d1				;p1 new colour.
		bne.s	spr_col_11_p001
spr_col_11_p000:bset	d5,d3
		bclr	d4,d3
		subq.b	#1,d5				;one down.
		dbra	d4,spr_col_do			;next colour.
		rts					;exit.
spr_col_11_p001:bclr	d5,d3
		bset	d4,d3
		subq.b	#1,d5				;one down. do no changes.
		dbra	d4,spr_col_do			;next colour.
		rts					;exit.
spr_col_11_p01:	btst	#6,d1				;p1 new colour.
		bne.s	spr_col_11_p011
spr_col_11_p010:bset	d5,d3
		bset	d4,d3
		subq.b	#1,d5				;one down.
		dbra	d4,spr_col_do			;next colour.
		rts					;exit.
spr_col_11_p011:bset	d5,d3
		bset	d4,d3
		swap	d6
		bset	d5,d6				;adder set.
		swap	d6
		subq.b	#1,d5				;one down. do no changes.
		dbra	d4,spr_col_do			;next colour.
		rts					;exit.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		output the created view
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_draw_pl:	cmp.b	#1,old_render			;render mode?
		beq.w	screen_screen			;screen!

		bsr.b	read_pixels_and_scale

		bra.w	output_the_data

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		read pixels and scale the data if scaling is needed
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

read_pixels_and_scale:
		moveq.l	#0,d0
		moveq.l	#0,d1
		move.l	#159,d2
		move.l	#143,d3

		tst.b	old_refresh			;mode 144/144?
		beq.s	no_shifting			;yes.

shifted_blit:	move.l	#8,d4				;area x fix.
		move.l	#16,d5				;area y fix.
		add.l	bg_scroll_x,d4			;src x.
		add.l	bg_scroll_y,d5			;src y.
		add.l	d4,d0
		add.l	d4,d2
		add.l	d5,d1
		add.l	d5,d3

no_shifting:	cmp.b	#1,old_render
		bne.s	no_cyber_screen_read

		move.l	game_tmp_rast_port,a1
		move.l	gb_rport_I,a0
		bra.s	read_pixels_a_lot

no_cyber_screen_read:
		move.l	game_rast_port,a0
		move.l	game_tmp_rast_port,a1

read_pixels_a_lot:
		move.l	graphics_base,a6
		move.l	game_array,a2
		jsr	ReadPixelArray8(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		scaling
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cmp.b	#1,old_render			;render mode?
		beq.w	cyber_screen_data_exit		;screen!

		tst.b	scaling_status
		beq.w	no_data_scaling

		move.l	game_array,a0
		move.l	game_scale_array,a1
		move.l	wzonka_game_x,d0
		move.l	wzonka_game_y,d1

		cmp.w	#320,d0
		beq.w	scaling_320xb

		bsr.w	convert_array_pens

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		scaling (a x b)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scaling_axb:	move.l	#160*256,d2
		move.l	#144*256,d3
		divu.l	d0,d2
		divu.l	d1,d3
		move.w	d0,d4
		subq.w	#1,d4
		move.w	d1,d5
		subq.w	#1,d5
		moveq.l	#0,d7

compute_scaling_y:
		move.w	d4,d6
		moveq.l	#0,d0
		move.l	d7,d1
		lsr.l	#8,d1
		mulu.w	#160,d1
		lea	(a0,d1.l),a4
compute_scaling_x:
		move.l	d0,d1
		lsr.l	#8,d1
		move.b	(a4,d1.l),(a1)+
		add.l	d2,d0
		dbra	d6,compute_scaling_x
scale_the_image_next_line:
		add.l	d3,d7
		dbra	d5,compute_scaling_y
		bra.w	data_scaling_exit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		scaling (320 x b)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scaling_320xb:	cmp.w	#144,d1
		beq.w	scaling_320x144
		cmp.w	#288,d1
		beq.w	scaling_320x288

		move.l	#144*256,d3
		divu.l	d1,d3
		move.w	d1,d5
		subq.w	#1,d5
		moveq.l	#0,d7
		move.l	pen_conversion_table,a6

compute_scaling_320_y:
		moveq.l	#160/2-1,d6
		move.l	d7,d1
		lsr.l	#8,d1
		mulu.w	#160,d1
		lea	(a0,d1.l),a4
compute_scaling_320_x:
		moveq.l	#0,d0
		move.w	(a4)+,d0
		move.w	(a6,d0.l*2),d0
		lsl.l	#8,d0
		lsr.w	#8,d0
		move.l	d0,d1
		lsl.l	#8,d0
		or.l	d1,d0
		move.l	d0,(a1)+
		dbra	d6,compute_scaling_320_x
scale_the_image_next_line_320:
		add.l	d3,d7
		dbra	d5,compute_scaling_320_y
		bra.w	data_scaling_exit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		scaling (320 x 144)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scaling_320x144:subq.w	#1,d1
		move.l	pen_conversion_table,a6

compute_scaling_320x144_y:
		moveq.l	#160/2-1,d6
compute_scaling_320x144_x:
		moveq.l	#0,d0
		move.w	(a0)+,d0
		move.w	(a6,d0.l*2),d0
		lsl.l	#8,d0
		lsr.w	#8,d0
		move.l	d0,d2
		lsl.l	#8,d0
		or.l	d2,d0
		move.l	d0,(a1)+
		dbra	d6,compute_scaling_320x144_x
scale_the_image_next_line_320x144:
		dbra	d1,compute_scaling_320x144_y
		bra.w	data_scaling_exit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		scaling (320 x 288)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scaling_320x288:move.w	#144-1,d1
		move.l	pen_conversion_table,a6

compute_scaling_320x288_y:
		moveq.l	#160/2-1,d6
compute_scaling_320x288_x:
		moveq.l	#0,d0
		move.w	(a0)+,d0
		move.w	(a6,d0.l*2),d0
		lsl.l	#8,d0
		lsr.w	#8,d0
		move.l	d0,d2
		lsl.l	#8,d0
		or.l	d2,d0
		move.l	d0,(a1)
		move.l	d0,320(a1)
		addq.l	#4,a1
		dbra	d6,compute_scaling_320x288_x
scale_the_image_next_line_320x288:
		add.l	#320,a1
		dbra	d1,compute_scaling_320x288_y

data_scaling_exit:
		move.l	game_scale_array,a2
		move.l	wzonka_game_x,d2
		move.l	wzonka_game_y,d3
		subq.w	#1,d2
		subq.w	#1,d3
		rts

no_data_scaling:bsr.w	convert_array_pens
		move.l	game_array,a2
		move.l	#159,d2
		move.l	#143,d3
		rts

cyber_screen_data_exit:
		move.l	game_array,a2
		move.l	#159,d2
		move.l	#143,d3
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		output the data
;		INPUT:
;		d2	= output x.
;		d3	=        y.
;		a2	= input array.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

output_the_data:move.l	wzonka_ptr,a0
		move.l	wd_RPort(a0),a0
		tst.b	os_screen_speed_limit
		beq.w	output_the_data_rest
		movem.l	d2/d3/a0/a2,-(SP)
		tst.b	forbid_permit_status	;multitasking?
		bne.s	window_sync_wait		;yes.
		move.l	exec_base,a6
		jsr	Permit(a6)
window_sync_wait:
		move.l	graphics_base,a6
		jsr	WaitTOF(a6)			;sync to the monitor.
		tst.b	forbid_permit_status
		bne.s	window_sync_done
		move.l	exec_base,a6
		jsr	Forbid(a6)
window_sync_done:
		movem.l	(SP)+,d2/d3/a0/a2

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		output the data - rest
;		INPUT:
;		d2	= output x.
;		d3	=        y.
;		a0	= output rastport.
;		a2	= input array.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

output_the_data_rest:
		moveq.l	#0,d0
		moveq.l	#0,d1

		cmp.l	#FALSE,output_cyber_status
		beq.s	no_cyber_routines

		tst.l	cyber_base
		bne.s	use_cyber_routines

no_cyber_routines:
		move.l	graphics_base,a6
		move.l	game_output_tmp_rast_port,a1
		jsr	WritePixelArray8(a6)
		rts

use_cyber_routines:
		move.l	cyber_base,a6
		move.l	a0,a1
		addq.w	#1,d2
		addq.w	#1,d3
		move.w	d2,d5
		move.w	d3,d6
		move.l	a2,a0
		moveq.l	#0,d3
		moveq.l	#0,d4
		move.l	#RECTFMT_LUT8,d7
		jsr	WritePixelArray(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		convert array pens
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
convert_array_pens:
		move.l	game_array,a3
		move.l	pen_conversion_table,a4
		move.w	#160*144/2/8-1,d6
		moveq.l	#0,d7
convert_array:	move.w	(a3),d7
		move.w	(a4,d7.l*2),(a3)+
		move.w	(a3),d7
		move.w	(a4,d7.l*2),(a3)+
		move.w	(a3),d7
		move.w	(a4,d7.l*2),(a3)+
		move.w	(a3),d7
		move.w	(a4,d7.l*2),(a3)+
		move.w	(a3),d7
		move.w	(a4,d7.l*2),(a3)+
		move.w	(a3),d7
		move.w	(a4,d7.l*2),(a3)+
		move.w	(a3),d7
		move.w	(a4,d7.l*2),(a3)+
		move.w	(a3),d7
		move.w	(a4,d7.l*2),(a3)+
		dbra	d6,convert_array
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		output a screen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_screen:	tst.l	cyber_base
		bne.w	cyber_screen

		tst.b	gb_buffer_no
		bne.s	zscreen_II

zscreen_I:	move.l	gb_bmap_I,a2
		move.b	#1,gb_buffer_no
		move.l	gb_bmap_II,a0
		bra.s	zscreen

zscreen_II:	move.l	gb_bmap_II,a2
		clr.b	gb_buffer_no
		move.l	gb_bmap_I,a0

zscreen:	lea	bm_Planes(a0),a0		;to bitmaps.
		move.l	(a0),bitmap_bg
		move.l	8(a0),bitmap_spc

		move.l	gb_screen_ptr,a0
		lea	sc_ViewPort(a0),a0
		move.l	vp_RasInfo(a0),a1

		move.w	bg_scroll_x+2,d0
		add.w	#8,d0
		move.w	bg_scroll_y+2,d1
		add.w	#16,d1

		tst.b	old_refresh			;mode 144/144?
		bne.s	use_these_values

		moveq.l	#0,d0
		moveq.l	#0,d1

use_these_values:
		move.w	d0,ri_RxOffset(a1)
		move.w	d1,ri_RyOffset(a1)
		move.l	a2,ri_BitMap(a1)

		move.l	graphics_base,a6
		jsr	ScrollVPort(a6)

		tst.b	os_screen_speed_limit
		beq.s	no_speed_limit

		jsr	WaitTOF(a6)

no_speed_limit:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		cybergraphics screen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

cyber_screen:	bsr.w	read_pixels_and_scale

		move.l	gb_screen_ptr,a0		;the screen.
		lea	sc_RastPort(a0),a0
		bra.w	output_the_data_rest
