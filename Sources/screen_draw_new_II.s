
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

; D3.W holds the raw planes, A2 the live palette page. Each entry holds
; [transparent, BG adder, p0, p1], with four bits per byte.
spr_col_change:	MACRO
		bfextu	d3{16:4},d4
		lsl.w	#4,d4
		bfextu	d3{24:4},d5
		or.w	d5,d4
		move.l	(a2,d4.w*4),d6
		lsl.l	#4,d6
		bfextu	d3{20:4},d4
		lsl.w	#4,d4
		bfextu	d3{28:4},d5
		or.w	d5,d4
		or.l	(a2,d4.w*4),d6
		move.w	d6,d3
		move.l	d6,d5
		and.l	#$ff000000,d5
		or.l	#$00ff0007,d5
		clr.w	d6
		rol.l	#8,d6
		lsl.w	#8,d6
		or.b	#$ff,d6
		ENDM

; D3 indexes OBP0/OBP1 relative to the pattern table at $8000.
spr_col_page:	MACRO
		move.b	$7f48(a1,d3.l),d3
		and.w	#$fc,d3
		lsl.w	#8,d3
		move.l	spr_col_table,a2
		lea	(a2,d3.l),a2
		ENDM

spr_priority_filter: MACRO
		tst.b	spr_priority_mode
		beq.s	spr_priority_skip\@
		bsr.w	spr_priority_row
		tst.w	d3
		beq.w	\1
spr_priority_skip\@:
		ENDM

spr_priority_filter_scan: MACRO
		tst.b	spr_priority_mode
		beq.s	spr_priority_skip_scan\@
		move.w	d7,d3
		bsr.w	spr_priority_row
		move.w	d3,d7
		beq.w	\1
spr_priority_skip_scan\@:
		ENDM

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

		gfx_time_start
		bsr.w	screen_draw_bg			;do the background copy.
		bsr.w	screen_draw_wi			;do the window copy.
		bsr.w	screen_sprites			;do them!
		gfx_time_end gfx_prof_planar
		bsr.w	swap_lists_nor			;swap the sprite y lists.
		bsr.w	update_bg_pal			;output the palette.
		bsr.w	screen_draw_pl			;all h/w effects are done!

		bsr.w	pull_z80

no_screen_draw:	rts					;exit.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		empty screen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_draw_blank:
		tst.b	old_render
		beq.w	clear_aga_screen
		bsr.w	push_z80
		bsr.w	screen_empty
		bsr.w	update_bg_pal
		bsr.w	screen_draw_pl
		bsr.w	swap_lists_nor
		bra.w	pull_z80

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
		tst.l	output_cyber_status		;RTG also uses a single drawing buffer.
		bne.s	sprs_xx_done

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
		tst.b	lcd_blank_phase
		beq.s	update_bg_palette_ready
		moveq.l	#0,d0
update_bg_palette_ready:

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
;		copy 21 tiles and the left margin, eight rows at a time
;		INPUT:
;		d2	= (background start y) / 8 * 32.
;		d3	= (background start x) / 8.
;		a0	= output (p0).
;		a1	= tiles.
;		a2	= tile datas.
;		a3	= output (p1).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_bg_tile:	MACRO
		move.w	d1,d4
		add.b	(a1,d3.w),d4
		lsl.w	#4,d4
		lea	(a2,d4.w),\1
		addq.w	#1,d3
		and.w	#31,d3
		ENDM

; The old left margin is $00 on plane 0 and the first tile's plane 0
; byte on plane 1. Include it with three tiles in the first longword.
screen_bg_pack_head: MACRO
		moveq.l	#0,d4
		move.w	(a4)+,d4
		move.l	d4,d5
		swap	d5
		lsr.w	#8,d4
		swap	d4
		move.w	(a5)+,d6
		move.b	d6,d5
		lsl.w	#8,d5
		move.w	(a6)+,d7
		move.b	d7,d5
		lsr.w	#8,d6
		lsl.w	#8,d6
		lsr.w	#8,d7
		move.b	d7,d6
		move.w	d6,d4
		move.l	d4,\1
		move.l	d5,\2
		ENDM

; Assemble both planes from four interleaved pattern words, as in AGA.
screen_bg_pack_four: MACRO
		move.w	(a4)+,d4
		lsl.l	#8,d4
		move.w	d4,d5
		move.w	(a5)+,d4
		move.b	d4,d5
		lsl.l	#8,d5
		lsl.l	#8,d4
		move.w	(a6)+,d4
		move.b	d4,d5
		lsl.l	#8,d5
		move.w	(a2)+,d6
		move.b	d6,d5
		move.l	d5,\2
		lsr.w	#8,d6
		move.b	d6,d4
		move.l	d4,\1
		ENDM

screen_bg_pack_tail: MACRO
		move.w	(a4)+,d4
		move.b	d4,d5
		lsl.w	#8,d5
		move.w	(a5)+,d6
		move.b	d6,d5
		lsr.w	#8,d6
		move.b	d6,d4
		move.w	d4,\1
		move.w	d5,\2
		ENDM

		add.l	d2,a1
		moveq.l	#19-1,d0
screen_bg_band:	movem.l	d0/d2-d3/a0/a3,-(sp)
		screen_bg_tile a4
		screen_bg_tile a5
		screen_bg_tile a6
		moveq.l	#4-1,d0
screen_bg_head:	screen_bg_pack_head (a0),(a3)
		screen_bg_pack_head 24(a0),24(a3)
		lea	48(a3),a3
		lea	48(a0),a0
		dbra	d0,screen_bg_head
		lea	-188(a0),a0			;rewind eight rows, advance four bytes.
		lea	-188(a3),a3

		move.l	a2,d7				;keep base while a2 reads tile four.
		moveq.l	#4-1,d2
screen_bg_group:	screen_bg_tile a4
		screen_bg_tile a5
		screen_bg_tile a6
		screen_bg_tile a2
		moveq.l	#4-1,d0
screen_bg_four:	screen_bg_pack_four (a0),(a3)
		screen_bg_pack_four 24(a0),24(a3)
		lea	48(a3),a3
		lea	48(a0),a0
		dbra	d0,screen_bg_four
		lea	-188(a0),a0
		lea	-188(a3),a3
		move.l	d7,a2
		dbra	d2,screen_bg_group

; Bytes 22 and 23 are outside the background span.
		screen_bg_tile a4
		screen_bg_tile a5
		moveq.l	#4-1,d0
screen_bg_tail:	screen_bg_pack_tail (a0),(a3)
		screen_bg_pack_tail 24(a0),24(a3)
		lea	48(a3),a3
		lea	48(a0),a0
		dbra	d0,screen_bg_tail

		movem.l	(sp)+,d0/d2-d3/a0/a3
		lea	192(a0),a0
		lea	192(a3),a3
		lea	32(a1),a1
		add.w	#32,d2
		and.w	#$3ff,d2
		bne.s	screen_bg_next
		lea	-1024(a1),a1
screen_bg_next:	dbra	d0,screen_bg_band

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
		addq.w	#1,d1				;right shift of 1..8.
		cmp.w	#8,d1
		bne.s	win_frame_span
		addq.l	#1,a2				;an 8-bit shift advances one byte.
		moveq.l	#0,d1
win_frame_span:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		a non transparent h/w window emulator
;		INPUT:
;		d1	= right shift.
;		d6/d7	= coarse window y/x.
;		a0	= window tiles.
;		a1	= window tile pattern table.
;		a2	= output area (p0).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		neg.l	d7				;compute the difference.
		add.l	#160/8+1,d7
		ble.s	screen_draw_wxt			;too much right.

		neg.l	d6				;compute the difference.
		add.l	#144/8,d6
		ble.s	screen_draw_wxt			;too much down.
		move.l	d6,d0
		lsl.w	#3,d0				;whole tile rows as before.
		move.l	tile_adder,d2
window_loop_y:	movem.l	d0/d7/a0-a2,-(sp)
		move.l	d7,d3
		move.l	a2,a3
		lea	4224(a2),a4
		bsr.w	win_span_spill
		movem.l	(sp)+,d0/d7/a0-a2
		lea	24(a2),a2
		addq.l	#2,a1
		subq.w	#1,d0
		beq.s	screen_draw_wxt
		move.w	d0,d4
		and.w	#7,d4
		bne.s	window_loop_y
		lea	32(a0),a0
		lea	-16(a1),a1
		bra.s	window_loop_y
screen_draw_wxt:rts

; Shared one-row writer. A0 = tile IDs, A1 = pattern base plus row offset,
; A3/A4 = plane destinations with the same alignment. D1 = right shift,
; D2 = tile bias, D3 = positive byte count per plane. D1/D2 are preserved.
win_span_tile:	MACRO
		IFNE	\1
		lsl.l	#8,d0
		lsl.l	#8,d7
		ENDC
		move.w	d2,d5
		add.b	(a0)+,d5
		lsl.w	#4,d5
		move.w	(a1,d5.w),d5
		move.b	d5,d7
		lsr.w	#8,d5
		move.b	d5,d0
		ENDM

win_span_spill:	bset	#16,d3				;right edge fits in the row.
win_span_draw:	tst.b	d1
		beq.w	win_span_aligned
		moveq.l	#32,d6
		sub.w	d1,d6
		moveq.l	#-1,d5
		lsr.b	d1,d5
		eor.b	#$ff,d5
		move.b	(a3),d0
		move.b	(a4),d7
		and.b	d5,d0
		and.b	d5,d7
		ror.l	#8,d0				;keep bits at the top of each carry.
		ror.l	#8,d7
; Clear the unused lower bits; only the carry at bits 31..24 is combined.
		and.l	#$ff000000,d0
		and.l	#$ff000000,d7
		move.l	d0,a5
		move.l	d7,a6

; Each carry is the last unshifted byte's spill, in the high bits of a long.
win_span_shift_plane: MACRO
		move.l	\1,d4
		lsr.\4	d1,\1
		move.l	\2,d5
		IFEQ	\5
		rol.l	#8,d5
		ENDC
		or.\4	d5,\1
		lsl.l	d6,d4
		move.l	d4,\2
		move.\4	\1,(\3)+
		ENDM

win_span_shift:	cmp.w	#4,d3
		blo.s	win_span_shift_byte
		move.l	a3,d4
		and.w	#3,d4
		beq.s	win_span_shift_long
win_span_shift_byte:
		win_span_tile 0
		win_span_shift_plane d0,a5,a3,b,0
		win_span_shift_plane d7,a6,a4,b,0
		subq.w	#1,d3
		bne.s	win_span_shift
		bra.s	win_span_shift_done
win_span_shift_long:
		win_span_tile 0
		win_span_tile 1
		win_span_tile 1
		win_span_tile 1
		win_span_shift_plane d0,a5,a3,l,1
		win_span_shift_plane d7,a6,a4,l,1
		subq.w	#4,d3
		beq.s	win_span_shift_done
		cmp.w	#4,d3
		bhs.s	win_span_shift_long
		bra.s	win_span_shift_byte

win_span_shift_done:
		btst	#16,d3
		beq.s	win_span_done
		moveq.l	#-1,d5
		lsr.b	d1,d5
		move.l	a5,d0
		move.l	a6,d7
		rol.l	#8,d0
		rol.l	#8,d7
		move.b	(a3),d4
		and.b	d5,d4
		or.b	d0,d4
		move.b	d4,(a3)
		move.b	(a4),d4
		and.b	d5,d4
		or.b	d7,d4
		move.b	d4,(a4)
win_span_done:	rts

win_span_aligned:
		cmp.w	#4,d3
		blo.s	win_span_aligned_byte
		move.l	a3,d4
		and.w	#3,d4
		beq.s	win_span_aligned_long
win_span_aligned_byte:
		win_span_tile 0
		move.b	d0,(a3)+
		move.b	d7,(a4)+
		subq.w	#1,d3
		bne.s	win_span_aligned
		rts
win_span_aligned_long:
		win_span_tile 0
		win_span_tile 1
		win_span_tile 1
		win_span_tile 1
		move.l	d0,(a3)+
		move.l	d7,(a4)+
		subq.w	#4,d3
		beq.s	win_span_done
		cmp.w	#4,d3
		bhs.s	win_span_aligned_long
		bra.s	win_span_aligned_byte

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		do the sprites
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

; A1 = guest VRAM base. As in the frame renderers, skip X=0 or Y=0.
spr_order_frame:
		move.l	a1,a0
		add.l	#$fe00,a0
		lea	spr_pick,a6
		moveq.l	#0,d2
		moveq.l	#40-1,d0
spr_order_pick:
		tst.b	(a0)
		beq.s	spr_order_skip
		tst.b	1(a0)
		beq.s	spr_order_skip
		move.l	(a0)+,(a6)+
		addq.l	#1,d2
		dbra	d0,spr_order_pick
		bra.s	spr_order_by_x
spr_order_skip:
		addq.l	#4,a0
		dbra	d0,spr_order_pick

; D2 = count, A6 = end of the OAM-ordered picks.
; Stable ascending X; drawing backwards makes smaller X and earlier OAM win.
; Returns A0 = end, D0 = count - 1 (N if empty).
spr_order_by_x:
		move.l	a6,a0
		move.l	d2,d0
		subq.w	#1,d0
		ble.s	spr_order_done
		lea	spr_pick,a6
		lea	4(a6),a4
spr_order_next:
		move.b	1(a4),d3
		cmp.b	-3(a4),d3
		bhs.s	spr_order_advance
		move.l	(a4),d7
		move.l	a4,a5
spr_order_shift:
		move.l	-4(a5),(a5)
		subq.l	#4,a5
		cmpa.l	a6,a5
		beq.s	spr_order_insert
		cmp.b	-3(a5),d3
		blo.s	spr_order_shift
spr_order_insert:
		move.l	d7,(a5)
spr_order_advance:
		addq.l	#4,a4
		cmpa.l	a0,a4
		blo.s	spr_order_next
		tst.w	d0
spr_order_done:
		rts

; Only passes with an enabled backdrop and a priority OBJ need a coverage
; map. Reverse the picks so the existing backwards readers draw front first.
; The map uses OAM X coordinates with a 24-byte stride (including margins).
; D3 = 1/2 for planar frame/line, 3/4 for AGA frame/line.
spr_priority_prepare:
		clr.b	spr_priority_mode
		tst.w	d0
		bmi.s	spr_priority_ready
		move.l	lcd_control,d6
		btst	#0,d6
		beq.s	spr_priority_ready
		lea	spr_pick,a4
		move.w	d0,d6
spr_priority_find:
		tst.b	3(a4)
		bmi.s	spr_priority_enable
		addq.l	#4,a4
		dbra	d6,spr_priority_find
spr_priority_ready:
		tst.w	d0
		rts
spr_priority_enable:
		move.b	d3,spr_priority_mode
		lea	spr_pick,a4
		lea	-4(a0),a5
spr_priority_reverse:
		cmpa.l	a5,a4
		bhs.s	spr_priority_clear
		move.l	(a4),d7
		move.l	(a5),(a4)+
		move.l	d7,(a5)
		subq.l	#4,a5
		bra.s	spr_priority_reverse
spr_priority_clear:
		lea	spr_priority_claims,a4
		move.w	#24/4-1,d6
		btst	#0,d3
		beq.s	spr_priority_clear_loop
		move.w	#144*24/4-1,d6
spr_priority_clear_loop:
		clr.l	(a4)+
		dbra	d6,spr_priority_clear_loop
		bra.s	spr_priority_ready

; D3.W = sprite pattern after X flip. A0 points to its OAM entry.
; Claim opaque pixels before testing the backdrop: a hidden winner must
; still block lower-priority sprites. Unclaimed backdrop pixels are raw.
spr_priority_row:
		movem.l	d0-d2/d4-d7/a1-a4,-(sp)
		moveq.l	#0,d1
		move.b	1(a0),d1
		beq.w	spr_priority_return
		cmp.w	#168,d1
		bhs.w	spr_priority_return
		moveq.l	#0,d2
		move.b	spr_priority_mode,d2
		lea	spr_priority_claims,a2
		btst	#0,d2
		beq.s	spr_priority_line
		moveq.l	#0,d0
		move.b	(a0),d0
		add.w	sprite_y+2,d0
		sub.w	d7,d0
		sub.w	#16,d0
		cmp.w	#144,d0
		bhs.w	spr_priority_return
		move.w	d0,d4
		mulu.w	#24,d4
		add.l	d4,a2
		bra.s	spr_priority_x
spr_priority_line:
		move.l	gb_scanlines,d0
spr_priority_x:
		move.w	d1,d4
		lsr.w	#3,d4
		add.w	d4,a2
		moveq.l	#7,d5
		and.w	d1,d5
		move.w	(a2),d7
		lsl.w	d5,d7
		lsr.w	#8,d7
		move.w	d3,d4
		lsr.w	#8,d4
		or.b	d3,d4
		lsl.w	#8,d4
		lsr.w	d5,d4
		or.w	d4,(a2)

		tst.b	3(a0)
		bpl.w	spr_priority_keep
		cmp.b	#2,d2
		beq.s	spr_priority_planar_line
		cmp.b	#1,d2
		bne.s	spr_priority_aga
		move.l	bitmap_bg,a3
		move.w	d0,d4
		add.w	bg_scroll_y+2,d4
		add.w	#16,d4
		mulu.w	#24,d4
		add.l	d4,a3
		move.w	d1,d4
		add.w	bg_scroll_x+2,d4
		bra.s	spr_priority_read_bg
spr_priority_planar_line:
		move.l	bitmap_bg,a3
		move.w	d0,d4
		mulu.w	#20,d4
		add.l	d4,a3
		move.w	d1,d4
		subq.w	#8,d4
		bmi.s	spr_priority_left
		cmp.w	#152,d4
		blo.s	spr_priority_read_bg
		move.b	19(a3),d6
		or.b	2880+19(a3),d6
		and.w	#7,d4
		lsl.b	d4,d6
		bra.s	spr_priority_bg_ready
spr_priority_left:
		neg.w	d4
		move.b	(a3),d6
		or.b	2880(a3),d6
		lsr.b	d4,d6
		bra.s	spr_priority_bg_ready
spr_priority_aga:
		move.l	aga_map_inactive,a3
		move.l	gb_memory,a4
		add.l	#$ff40,a4
		move.w	d0,d4
		cmp.b	#4,d2
		beq.s	spr_priority_aga_line
		move.l	bg_scroll_inactive,a2
		add.w	2(a2),d4
		add.w	#16,d4
		addq.l	#1,a3
spr_priority_aga_line:
		mulu.w	#320,d4
		add.l	d4,a3
		addq.l	#6,a3
		moveq.l	#7,d4
		and.b	3(a4),d4
		add.w	d1,d4
spr_priority_read_bg:
		move.w	d4,d6
		and.w	#7,d4
		lsr.w	#3,d6
		move.w	(a3,d6.w),d5
		cmp.b	#1,d2
		beq.s	spr_priority_frame_plane
		cmp.b	#2,d2
		beq.s	spr_priority_line_plane
		lea	40(a3),a3
		bra.s	spr_priority_read_second
spr_priority_frame_plane:
		lea	4224(a3),a3
		bra.s	spr_priority_read_second
spr_priority_line_plane:
		lea	2880(a3),a3
spr_priority_read_second:
		or.w	(a3,d6.w),d5
		lsl.w	d4,d5
		lsr.w	#8,d5
		move.b	d5,d6
		cmp.b	#3,d2
		bne.s	spr_priority_bg_ready
		bsr.s	spr_priority_aga_window
spr_priority_bg_ready:
		or.b	d6,d7
spr_priority_keep:
		not.b	d7
		move.b	d7,d4
		lsl.w	#8,d4
		move.b	d7,d4
		and.w	d4,d3
spr_priority_return:
		movem.l	(sp)+,d0-d2/d4-d7/a1-a4
		rts

; AGA whole-frame draws the window as hardware sprites. Sample their raw
; packed rows instead of using the BG playfield under that part of the window.
; D0 = LY, D1 = OAM X, A4 = LCD registers, D6.B = backdrop mask in/out.
spr_priority_aga_window:
		move.l	lcd_control,d4
		btst	#5,d4
		beq.s	spr_priority_window_done
		moveq.l	#0,d4
		move.b	10(a4),d4
		sub.w	d4,d0
		bmi.s	spr_priority_window_done
		move.b	11(a4),d4
		cmp.b	#160,d4
		bhs.s	spr_priority_window_done
		cmp.b	#6,d4
		bne.s	spr_priority_window_x
		addq.b	#1,d4
spr_priority_window_x:
		sub.w	d4,d1
		subq.w	#1,d1			;OAM X - 8 - (WX - 7).
		cmp.w	#-8,d1
		ble.s	spr_priority_window_done
		addq.w	#1,d0
		lsl.w	#4,d0			;row plus the control words.
		move.l	aga_spr_inactive_pointer,a1
		move.l	(a1),a2
		tst.w	d1
		bmi.s	spr_priority_window_edge
		move.w	d1,d4
		lsr.w	#6,d4
		lea	(a1,d4.w*4),a1
		move.l	(a1),a2
		move.w	d1,d4
		lsr.w	#3,d4
		and.w	#7,d4
		and.w	#7,d1
		bsr.s	spr_priority_window_byte
		tst.w	d1
		beq.s	spr_priority_window_replace
		move.b	d5,d2
		lsl.w	#8,d2
		addq.w	#1,d4
		cmp.w	#8,d4
		blo.s	spr_priority_window_next
		move.l	4(a1),a2
		moveq.l	#0,d4
spr_priority_window_next:
		bsr.s	spr_priority_window_byte
		move.b	d5,d2
		lsl.w	d1,d2
		lsr.w	#8,d2
		move.b	d2,d5
spr_priority_window_replace:
		move.b	d5,d6
spr_priority_window_done:
		rts
spr_priority_window_edge:
		moveq.l	#0,d4
		bsr.s	spr_priority_window_byte
		neg.w	d1
		lsr.b	d1,d5
		moveq.l	#-1,d4
		lsr.b	d1,d4
		not.b	d4
		and.b	d4,d6
		or.b	d5,d6
		rts
spr_priority_window_byte:
		lea	(a2,d0.w),a3
		move.b	(a3,d4.w),d5
		lea	8(a3),a3
		or.b	(a3,d4.w),d5
		rts

screen_sprites:	move.l	bitmap_spc,a0			;the sprite area.
		move.l	a0,a1
		add.l	#gb_screen_x/8*gb_screen_y,a1

fast_clearing:	move.l	aga_sprs_inactive,a2
		moveq.l	#gb_screen_y/4-1,d0
		moveq.l	#0,d2
		moveq.l	#0,d3
		moveq.l	#0,d4
		moveq.l	#0,d5
		moveq.l	#0,d6
		moveq.l	#0,d7
; The list is aligned; skip four rows without touching either plane.
spr_scnr_group:	tst.l	(a2)
		bne.s	spr_scnr_marked
		addq.l	#4,a2
		lea	96(a0),a0
		lea	96(a1),a1
		dbra	d0,spr_scnr_group
		bra.s	lines_done

spr_scnr_marked:moveq.l	#4-1,d1
spr_scnr_row:	tst.b	(a2)+
		beq.s	spr_scnr_next
		clr.b	-1(a2)
		movem.l	d2-d7,(a0)
		movem.l	d2-d7,(a1)
spr_scnr_next:	lea	24(a0),a0
		lea	24(a1),a1
		dbra	d1,spr_scnr_row
		dbra	d0,spr_scnr_group

lines_done:	move.l	lcd_control,d1			;d1 = lcd control byte.
		btst	#1,d1				;sprites off?
		beq.w	spr_exit			;yes.

		move.l	gb_memory,a1
		bsr.w	spr_order_frame
		moveq.l	#1,d3
		bsr.w	spr_priority_prepare
		bmi.w	spr_exit
		add.l	#$8000,a1			;a1 = sprite pattern table.

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
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

spr_c8xq:	move.l	-(a0),d1			;d1 = y.B, x.B, gfx.B, flags.B.
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
		spr_col_page

		btst	#6,d1				;y flipped?
		bne.w	spr_c8xq_flip			;yes.

		btst	#5,d1				;x flipped?
		bne.s	spr_c8xq_copyx			;yes.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		normal output
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

spr_c8xq_copy:	move.w	(a6)+,d3			;d3 = 01.
		beq.w	next_I
		spr_priority_filter next_I
		spr_col_change

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
		dbra	d0,spr_c8xq			;next sprite.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		x flipped output
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
spr_c8xq_copyx:	moveq.l	#0,d3
		move.l	x_flip_table,a3
		move.w	(a6)+,d3			;d3 = 01.
		beq.s	next_II
		move.w	(a3,d3.l*2),d3			;d3 = x flipped data.
		spr_priority_filter next_II
		spr_col_change

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

		dbra	d7,spr_c8xq_copyx		;next y (register).
		dbra	d0,spr_c8xq			;next sprite.
		rts

next_II:	add.l	#192/8,a4
		add.l	#192/8,a5
		dbra	d7,spr_c8xq_copyx		;next y (register).
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

spr_c8xq_copyy:	move.w	-(a6),d3			;d3 = 01.
		beq.s	next_III
		spr_priority_filter next_III
		spr_col_change

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
spr_c8xq_copyxy:moveq.l	#0,d3
		move.l	x_flip_table,a3
		move.w	-(a6),d3			;d3 = 01.
		beq.s	next_IIII
		move.w	(a3,d3.l*2),d3			;d3 = x flipped data.
		spr_priority_filter next_IIII
		spr_col_change

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

		dbra	d7,spr_c8xq_copyxy		;next y (register).
		dbra	d0,spr_c8xq			;next sprite.
		rts

next_IIII:	add.l	#192/8,a4
		add.l	#192/8,a5
		dbra	d7,spr_c8xq_copyxy		;next y (register).
		dbra	d0,spr_c8xq			;next sprite.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		Build the immutable sprite palette table once at startup.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
spr_col_build:	movem.l	d2-d7/a2,-(sp)
		move.l	spr_col_table,a0
		lea	spr_col_shades(pc),a1
		moveq.l	#0,d0
spr_col_pal:	moveq.l	#3,d5
		and.w	d0,d5
		move.l	(a1,d5.w*4),d5
		move.w	d0,d6
		lsr.w	#2,d6
		and.w	#3,d6
		move.l	(a1,d6.w*4),d6
		move.w	d0,d7
		lsr.w	#4,d7
		move.l	(a1,d7.w*4),d7
		moveq.l	#0,d1
spr_col_entry:	bfextu	d1{24:4},d2
		bfextu	d1{28:4},d3
		move.l	d2,d4
		or.l	d3,d4
		eor.b	#$0f,d4
		ror.l	#8,d4				;transparent bits in the high byte.
		move.l	d2,a2
		and.l	d3,d2				;source colour 3.
		eor.l	d2,d3				;source colour 2.
		mulu.l	#$010101,d3			;repeat the mask in three bytes.
		and.l	d6,d3
		or.l	d3,d4
		move.l	a2,d3
		eor.l	d2,d3				;source colour 1.
		mulu.l	#$010101,d3
		and.l	d5,d3
		or.l	d3,d4
		mulu.l	#$010101,d2
		and.l	d7,d2
		or.l	d2,d4
		move.l	d4,(a0)+
		addq.b	#1,d1
		bne.s	spr_col_entry
		addq.w	#1,d0
		cmp.w	#64,d0
		bne.w	spr_col_pal
		movem.l	(sp)+,d2-d7/a2
		rts

		cnop	0,4
spr_col_shades:	dc.l	$0000ff00,$000000ff,$0000ffff,$00ffffff

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
		gfx_time_start
		cmp.b	#2,old_render
		bne.s	read_pixels_os
		IFEQ	GFX_COMPARE_READBACK
		tst.b	window_direct_readback
		beq.s	read_pixels_os
		bra.w	window_try_fused
		ELSE
		bra.w	window_read_pixels
		ENDC
read_pixels_os:
		jsr	ReadPixelArray8(a6)
read_pixels_ready:
		gfx_time_end gfx_prof_read

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
		cmp.w	#160,d0
		beq.w	scaling_160xb

		bsr.w	convert_array_pens

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		scaling (a x b)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scaling_axb:	gfx_time_start
		move.l	#160*256,d2
		move.l	#144*256,d3
		divu.l	d0,d2
		divu.l	d1,d3
		move.w	d0,d4
		subq.w	#1,d4
		move.w	d1,d5
		subq.w	#1,d5
		move.l	window_scale_table,a6
		move.l	a6,a3
		move.w	d4,d6
		moveq.l	#0,d0
;		Every row uses the same horizontal 8.8 coordinates. A source X fits in a byte.
build_scale_x:
		move.l	d0,d1
		lsr.l	#8,d1
		move.b	d1,(a3)+
		add.l	d2,d0
		dbra	d6,build_scale_x

		moveq.l	#0,d0
		moveq.l	#0,d7
		moveq.l	#-1,d2				;no source row drawn yet.

compute_scaling_y:
		move.l	d7,d1
		lsr.l	#8,d1
		cmp.l	d2,d1
		beq.s	reuse_scaled_row
		move.l	d1,d2
		move.l	a1,a5				;start of this output row.
		move.w	d4,d6
		move.l	a6,a3
		mulu.w	#160,d1
		lea	(a0,d1.l),a4
		subq.w	#7,d6				;(width-8)/8 is the DBRA count.
		bmi.s	compute_scaling_x_tail
		lsr.w	#3,d6
compute_scaling_x_block:
		move.b	(a3)+,d0
		move.b	(a4,d0.w),(a1)+
		move.b	(a3)+,d0
		move.b	(a4,d0.w),(a1)+
		move.b	(a3)+,d0
		move.b	(a4,d0.w),(a1)+
		move.b	(a3)+,d0
		move.b	(a4,d0.w),(a1)+
		move.b	(a3)+,d0
		move.b	(a4,d0.w),(a1)+
		move.b	(a3)+,d0
		move.b	(a4,d0.w),(a1)+
		move.b	(a3)+,d0
		move.b	(a4,d0.w),(a1)+
		move.b	(a3)+,d0
		move.b	(a4,d0.w),(a1)+
		dbra	d6,compute_scaling_x_block
compute_scaling_x_tail:
		move.w	d4,d6
		and.w	#7,d6				;(width-1)&7: 7 means no tail.
		cmp.w	#7,d6
		beq.s	scale_the_image_next_line
compute_scaling_x_byte:
		move.b	(a3)+,d0
		move.b	(a4,d0.w),(a1)+
		dbra	d6,compute_scaling_x_byte
scale_the_image_next_line:
		add.l	d3,d7
		dbra	d5,compute_scaling_y
		bra.w	data_scaling_exit

reuse_scaled_row:move.l	a5,a3
		move.w	d4,d6
		move.w	d4,d1
		addq.w	#1,d1
		and.w	#15,d1				;bytes after the last full block.
		sub.w	d1,d6
		bmi.s	reuse_scaled_row_tail
		lsr.w	#5,d6				;odd number of 16-byte blocks starts halfway.
		bcc.s	reuse_scaled_row_half
reuse_scaled_row_block:
		move.l	(a3)+,(a1)+
		move.l	(a3)+,(a1)+
		move.l	(a3)+,(a1)+
		move.l	(a3)+,(a1)+
reuse_scaled_row_half:
		move.l	(a3)+,(a1)+
		move.l	(a3)+,(a1)+
		move.l	(a3)+,(a1)+
		move.l	(a3)+,(a1)+
		dbra	d6,reuse_scaled_row_block
reuse_scaled_row_tail:
		subq.w	#1,d1
		bmi.s	scale_the_image_next_line
reuse_scaled_row_byte:
		move.b	(a3)+,(a1)+
		dbra	d1,reuse_scaled_row_byte
		bra.s	scale_the_image_next_line

;		Native width: copy whole rows, using the same vertical step as scaling_axb.
scaling_160xb:	cmp.w	#144,d1
		beq.w	no_data_scaling
		bsr.w	convert_array_pens
		gfx_time_start
		move.l	#144*256,d3
		divu.l	d1,d3
		subq.w	#1,d1
		moveq.l	#0,d7

scaling_160_y:	move.l	d7,d2
		lsr.l	#8,d2
		mulu.w	#160,d2
		lea	(a0,d2.l),a4
		moveq.l	#160/32-1,d6
scaling_160_x:	move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		dbra	d6,scaling_160_x
		add.l	d3,d7
		dbra	d1,scaling_160_y
		bra.w	data_scaling_exit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		scaling (320 x b)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scaling_320xb:	bsr.w	build_scale_pen_pairs
		gfx_time_start
		moveq.l	#0,d0
		cmp.w	#144,d1
		beq.w	scaling_320x144
		cmp.w	#288,d1
		beq.w	scaling_320x288

		move.l	#144*256,d3
		divu.l	d1,d3
		move.w	d1,d5
		subq.w	#1,d5
		moveq.l	#0,d7
		moveq.l	#-1,d2				;no source row drawn yet.

compute_scaling_320_y:
		move.l	d7,d1
		lsr.l	#8,d1
		cmp.l	d2,d1
		beq.s	reuse_scaled_row_320
		move.l	d1,d2
		move.l	a1,a3				;start of the expanded row.
		moveq.l	#160/2-1,d6
		mulu.w	#160,d1
		lea	(a0,d1.l),a4
compute_scaling_320_x:
		move.b	(a4)+,d0
		lsl.b	#4,d0
		or.b	(a4)+,d0
		move.l	(a6,d0.w*4),(a1)+
		dbra	d6,compute_scaling_320_x
scale_the_image_next_line_320:
		add.l	d3,d7
		dbra	d5,compute_scaling_320_y
		bra.w	data_scaling_exit

reuse_scaled_row_320:
		move.l	a3,a4
		moveq.l	#320/32-1,d6
reuse_scaled_row_320_block:
		move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		move.l	(a4)+,(a1)+
		dbra	d6,reuse_scaled_row_320_block
		bra.s	scale_the_image_next_line_320

;		Expand a pair into four pixels, optionally copying to the next row.
scale_window_pair: MACRO
		move.b	(a0)+,d0
		lsl.b	#4,d0
		or.b	(a0)+,d0
		IFEQ	\1
		move.l	(a6,d0.w*4),(a1)+
		ELSE
		move.l	(a6,d0.w*4),d2
		move.l	d2,320(a1)
		move.l	d2,(a1)+
		ENDC
		ENDM

;ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
;		scaling (320 x 144)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scaling_320x144:subq.w	#1,d1

compute_scaling_320x144_y:
		moveq.l	#160/8-1,d6
compute_scaling_320x144_x:
		scale_window_pair 0
		scale_window_pair 0
		scale_window_pair 0
		scale_window_pair 0
		dbra	d6,compute_scaling_320x144_x
scale_the_image_next_line_320x144:
		dbra	d1,compute_scaling_320x144_y
		bra.w	data_scaling_exit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		scaling (320 x 288)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

scaling_320x288:move.w	#144-1,d1

compute_scaling_320x288_y:
		moveq.l	#160/8-1,d6
compute_scaling_320x288_x:
		scale_window_pair 1
		scale_window_pair 1
		scale_window_pair 1
		scale_window_pair 1
		dbra	d6,compute_scaling_320x288_x
scale_the_image_next_line_320x288:
		add.l	#320,a1
		dbra	d1,compute_scaling_320x288_y

data_scaling_exit:
		gfx_time_end gfx_prof_scale
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

;		4-bit source pens index [left, left, right, right] at (left<<4)|right.
;		Rebuild from the current Window palette; no state survives between draws.
build_scale_pen_pairs:
		gfx_time_start
		move.l	window_scale_table,a6
		move.l	a6,a2
		lea	gameboy_colours_conversion_table,a3
		moveq.l	#16-1,d2
scale_pen_left:
		move.b	(a3)+,d4
		move.b	d4,d5
		lsl.w	#8,d4
		move.b	d5,d4
		swap	d4
		lea	gameboy_colours_conversion_table,a5
		moveq.l	#16-1,d6
scale_pen_right:
		move.b	(a5),d4
		lsl.w	#8,d4
		move.b	(a5)+,d4
		move.l	d4,(a2)+
		dbra	d6,scale_pen_right
		dbra	d2,scale_pen_left
		gfx_time_end gfx_prof_pens
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
output_screen_pixels:
		bsr.w	sync_os_screen
		bra.s	output_the_data_rest

sync_os_screen:
		tst.b	os_screen_speed_limit
		beq.s	os_screen_sync_exit
		gfx_time_start
		movem.l	d2/d3/a0/a2,-(SP)
		tst.b	forbid_permit_status	;multitasking?
		bne.s	os_screen_sync_wait		;yes.
		move.l	exec_base,a6
		jsr	Permit(a6)
os_screen_sync_wait:
		move.l	graphics_base,a6
		jsr	WaitTOF(a6)			;sync to the monitor.
		tst.b	forbid_permit_status
		bne.s	os_screen_sync_done
		move.l	exec_base,a6
		jsr	Forbid(a6)
os_screen_sync_done:
		movem.l	(SP)+,d2/d3/a0/a2
		gfx_time_end gfx_prof_wait
os_screen_sync_exit:
		rts

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
		gfx_time_start
		jsr	WritePixelArray8(a6)
		gfx_time_end gfx_prof_upload
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
		gfx_time_start
		jsr	WritePixelArray(a6)
		gfx_time_end gfx_prof_upload
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		convert array pens
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
convert_array_pens:
		gfx_time_start
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
		gfx_time_end gfx_prof_pens
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		output a screen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_screen:	tst.l	output_cyber_status
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
		gfx_time_start
		jsr	ScrollVPort(a6)
		gfx_time_end gfx_prof_upload
		bra.w	sync_os_screen

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		cybergraphics screen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

cyber_screen:	bsr.w	read_pixels_and_scale

		move.l	gb_screen_ptr,a0		;the screen.
		lea	sc_RastPort(a0),a0
		bra.w	output_screen_pixels
