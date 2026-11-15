
create_planar_to_chunky_table:
		move.l	planar_to_chunky_table_background,a0
		move.b	#$00,d1
		move.b	#$01,d2
		move.b	#$02,d3
		move.b	#$03,d4

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		planar to chunky table creator
;		INPUT:
;		a0	= table ($10000*8).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	#$10000,d0
		moveq.l	#0,d1

create_planar_to_chunky_table_loop:
		moveq.l	#8-1,d2

create_planar_to_chunky_table_bits_to_bytes:
		move.w	d1,d3
		move.w	d1,d4
		lsr.w	#8,d3
		lsr.b	d2,d4
		lsr.b	d2,d3
		lsl.b	#1,d4
		and.b	#%1,d3
		and.b	#%10,d4
		or.b	d3,d4
		move.b	d4,(a0)+
		dbra	d2,create_planar_to_chunky_table_bits_to_bytes

		addq.w	#1,d1
		subq.l	#1,d0
		bne.s	create_planar_to_chunky_table_loop
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		chunky output the data
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_draw_for_chunky_output_out:
		move.l	gameboy_chunky_buffer,a0
		move.l	game_array,a1
		move.l	pen_conversion_table,a2
		add.l	chunky_scroll_x,a0
		move.l	chunky_scroll_y,d0
		mulu.w	#160+8+8,d0
		add.l	d0,a0
		moveq.l	#0,d7
		add.l	#(160+8+8)*16+8,a0

screen_draw_for_chunky_output_out_convert:
		move.w	#144-1,d0

screen_draw_for_chunky_output_out_copy:
		moveq.l	#160/4/4-1,d1

screen_draw_for_chunky_output_out_copy_loop:
		move.w	(a0)+,d7
		move.w	(a2,d7.l*2),(a1)+
		move.w	(a0)+,d7
		move.w	(a2,d7.l*2),(a1)+
		move.w	(a0)+,d7
		move.w	(a2,d7.l*2),(a1)+
		move.w	(a0)+,d7
		move.w	(a2,d7.l*2),(a1)+
		move.w	(a0)+,d7
		move.w	(a2,d7.l*2),(a1)+
		move.w	(a0)+,d7
		move.w	(a2,d7.l*2),(a1)+
		move.w	(a0)+,d7
		move.w	(a2,d7.l*2),(a1)+
		move.w	(a0)+,d7
		move.w	(a2,d7.l*2),(a1)+
		dbra	d1,screen_draw_for_chunky_output_out_copy_loop

		add.l	#16,a0
		dbra	d0,screen_draw_for_chunky_output_out_copy

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		output the data
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_draw_for_chunky_output_out_array:
		move.l	game_array,a2
		move.l	#159,d2
		move.l	#143,d3

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		output the data
;		INPUT:
;		d2	= output x.
;		d3	=        y.
;		a2	= input array.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	wzonka_ptr,a0
		move.l	wd_rport(a0),a0
		moveq.l	#0,d0
		moveq.l	#0,d1

		move.l	graphics_base,a6
		move.l	game_output_tmp_rast_port,a1
		jsr	WritePixelArray8(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		screen draw for chunky output
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_draw_for_chunky_output:
		move.l	gb_memory,a6
		moveq.l	#0,d7
		add.l	#$ff40,a6			;lcd control.
		move.b	(a6),d7
		btst	#7,d7				;lcd operation?
		beq.s	screen_draw_for_chunky_output_no_chunky_output
							;nope. empty.
		move.l	d7,lcd_control

		bsr.b	screen_draw_for_chunky_output_palette
		bsr.w	screen_draw_for_chunky_output_background
		bsr.w	screen_draw_for_chunky_output_window

screen_draw_for_chunky_output_no_chunky_output:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		palette
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_draw_for_chunky_output_palette:
		move.l	gb_memory,a0
		moveq.l	#0,d0
		add.l	#$ff47,a0			;bgrdpal (background palette).
		move.b	(a0),d0				;d0 = palette byte.

		move.b	back_ground_colour_byte,d5
		cmp.b	d5,d0
		beq.s	screen_draw_for_chunky_output_palette_done
		move.b	d0,back_ground_colour_byte
		eor.b	d0,d5

		lea	pen_list,a2
		lea	gameboy_colours_conversion_table,a1
		moveq.l	#4-1,d7

screen_draw_for_chunky_output_palette_1st:
		move.l	d0,d1
		and.b	#%11,d1
		move.b	(a2,d1.l),(a1)+
		lsr.b	#2,d0
		dbra	d7,screen_draw_for_chunky_output_palette_1st

		lea	gameboy_colours_conversion_table,a0
		move.l	pen_conversion_table,a1
		moveq.l	#0,d3
		moveq.l	#0,d7

		move.b	d5,d0
		and.b	#%11,d0
		beq.s	screen_draw_for_chunky_output_palette_ncc_0
		bsr.b	chunky_output_do_conversion_table_x

screen_draw_for_chunky_output_palette_ncc_0:
		move.b	d5,d0
		and.b	#%1100,d0
		beq.s	screen_draw_for_chunky_output_palette_ncc_1
		move.b	#1,d7
		bsr.b	chunky_output_do_conversion_table_x

screen_draw_for_chunky_output_palette_ncc_1:
		move.b	d5,d0
		and.b	#%110000,d0
		beq.s	screen_draw_for_chunky_output_palette_ncc_2
		move.b	#2,d7
		bsr.b	chunky_output_do_conversion_table_x

screen_draw_for_chunky_output_palette_ncc_2:
		move.b	d5,d0
		and.b	#%11000000,d0
		beq.s	screen_draw_for_chunky_output_palette
		move.b	#3,d7
		bsr.b	chunky_output_do_conversion_table_x

screen_draw_for_chunky_output_palette_done:
		rts

chunky_output_do_conversion_table_x:
		move.b	(a0,d7.w),d4
		moveq.l	#16-1,d1
		move.b	d7,d6
		lsl.w	#8,d4
		lsl.w	#8,d6
		lea	16(a0),a2

chunky_output_do_conversion_table_copy_x:
		move.w	d4,d2
		move.w	d6,d3
		move.b	-(a2),d2
		move.b	d1,d3
		move.w	d2,(a1,d3.l*2)
		ror.w	#8,d2
		ror.w	#8,d3
		move.w	d2,(a1,d3.l*2)
		dbra	d1,chunky_output_do_conversion_table_copy_x
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		background
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_draw_for_chunky_output_background:
		move.l	lcd_control,d0
		btst	#0,d0				;background display?
		beq.w	screen_draw_for_chunky_output_background_exit
							;no. quit.
		move.l	gb_memory,a0
		move.l	a0,a1
		add.l	#$ff42,a1			;lcd control.
		moveq.l	#0,d2
		move.b	(a1)+,d2			;bg scroll y.
		moveq.l	#0,d3
		move.b	(a1),d3				;bg scroll x.

		move.l	d0,d1				;d1 = the control byte.
		and.b	#%1000,d0			;d0 = background tiles.
		lsl.w	#7,d0				;0/1 * 1024.
		move.l	a0,a1
		add.l	#$9800,a1			;tile position.
		add.l	d0,a1				;selected position.
							;a1 = input tiles.
		and.b	#%10000,d1			;d1 = background tile
		move.l	d1,d6				;datas. 0/1 * 2048.
		lsl.b	#3,d6				;d6 = tile adder (signed/
		bchg	#7,d6				;unsigned).
		lsl.w	#7,d1
		move.l	a0,a2
		add.l	#$8800,a2			;tile data position.
		sub.l	d1,a2				;selected position.
							;a2 = input tile datas.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy background data
;		INPUT:
;		d2	= background scroll y.
;		d3	= background scroll x.
;		d6	= tile adder.
;		a1	= tiles.
;		a2	= tile datas.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	d2,d4
		and.b	#%11111000,d2

		move.l	d3,d5
		lsr.b	#3,d3

		and.b	#%111,d4
		and.b	#%111,d5
		move.l	d4,chunky_scroll_y
		move.l	d5,chunky_scroll_x

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		INPUT:
;		d2	= (background start y) / 8 * 8.
;		d3	= (background start x) / 8.
;		d6	= tile adder.
;		a1	= tiles.
;		a2	= tile pattern datas.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lsl.w	#2,d2
		move.l	gameboy_chunky_buffer,a0	;(160+8+8)x(144+16+16).
		move.l	planar_to_chunky_table_background,a6
							;planar to chunky table.
		lea	4(a6),a5

		moveq.l	#19-1,d0			;y.
		moveq.l	#0,d5
		move.l	#(160+8+8)*7+8,a4
		add.l	#16*(160+8+8)+8,a0

screen_draw_for_chunky_output_background_y:
		moveq.l	#21-1,d1			;x.
		move.l	d3,d4

screen_draw_for_chunky_output_background_x:
		move.l	d6,d7
		lea	(a1,d2.w),a3			;y.
		add.b	(a3,d4.w),d7			;x.
		lsl.w	#4,d7
		lea	(a2,d7.w),a3

		move.w	(a3)+,d5
		move.l	(a6,d5.l*8),(a0)
		move.l	(a5,d5.l*8),4(a0)

		move.w	(a3)+,d5
		move.l	(a6,d5.l*8),176(a0)
		move.l	(a5,d5.l*8),180(a0)

		move.w	(a3)+,d5
		move.l	(a6,d5.l*8),352(a0)
		move.l	(a5,d5.l*8),356(a0)

		move.w	(a3)+,d5
		move.l	(a6,d5.l*8),528(a0)
		move.l	(a5,d5.l*8),532(a0)

		move.w	(a3)+,d5
		move.l	(a6,d5.l*8),704(a0)
		move.l	(a5,d5.l*8),708(a0)

		move.w	(a3)+,d5
		move.l	(a6,d5.l*8),880(a0)
		move.l	(a5,d5.l*8),884(a0)

		move.w	(a3)+,d5
		move.l	(a6,d5.l*8),1056(a0)
		move.l	(a5,d5.l*8),1060(a0)

		move.w	(a3),d5
		move.l	(a6,d5.l*8),1232(a0)
		move.l	(a5,d5.l*8),1236(a0)

		addq.b	#1,d4
		addq.l	#8,a0
		and.b	#%11111,d4
		dbra	d1,screen_draw_for_chunky_output_background_x

		add.w	#32,d2
		add.l	a4,a0
		and.w	#%1111111111,d2
		dbra	d0,screen_draw_for_chunky_output_background_y

screen_draw_for_chunky_output_background_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_draw_for_chunky_output_window:
		move.l	lcd_control,d0
		btst	#5,d0				;window display?
		beq.w	screen_draw_for_chunky_output_window_exit

		move.l	gb_memory,a0			;a0 = the fixed 16bit
		move.l	a0,a1				;memory area.
		move.l	a0,a2

		add.l	#$9800,a0			;window tiles.
		and.b	#%1000000,d0			;d0 = tile position.
		lsl.w	#4,d0				;d0 = 0/1 * 1024.
		add.l	d0,a0				;a0 = window tiles.

		add.l	#$8800,a1			;a1 = window tile pattern table.

		add.l	#$ff4a,a2			;a2 = window y position.
		moveq.l	#0,d0
		move.b	(a2)+,d0			;d0 = window y pos ($ff4A).
		moveq.l	#0,d1
		move.b	(a2),d1				;d1 = window x pos ($ff4B).
		subq.w	#7,d1
		bge.s	screen_draw_for_chunky_output_window_ok_x
		moveq.l	#0,d1

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		INPUT:
;		d0	= window y position.
;		d1	= window x position.
;		a0	= window tiles.
;		a1	= window tile pattern table.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

screen_draw_for_chunky_output_window_ok_x:
		move.w	#160,d2
		sub.w	d1,d2
		ble.w	screen_draw_for_chunky_output_window_exit
		move.w	#144,d3
		sub.w	d0,d3
		ble.w	screen_draw_for_chunky_output_window_exit

		add.l	chunky_scroll_x,d1
		add.l	chunky_scroll_y,d0
		add.w	#16,d0
		move.l	gameboy_chunky_buffer,a2
		mulu.w	#160+8+8,d0
		addq.l	#8,d1
		add.l	d0,a2
		add.l	d1,a2

		lsr.w	#3,d2
		lsr.w	#3,d3

		move.l	planar_to_chunky_table_background,a3
							;planar to chunky table.
		lea	4(a3),a4

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		INPUT:
;		d2	= x/8.
;		d3	= y/8.
;		a0	= window tiles.
;		a1	= window tile pattern table.
;		a2	= chunky buffer.
;		a3	= planar to chunky table.
;		a4	= a3 + 4.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	#128,d1
		moveq.l	#0,d5
		move.l	#(160+8+8)*8,d6
		move.l	a2,d4

screen_draw_for_chunky_output_window_y:
		move.w	d2,d0
		move.l	a0,a5
		move.l	d4,a2

screen_draw_for_chunky_output_window_x:
		move.l	d1,d7
		add.b	(a5)+,d7
		lsl.w	#4,d7
		lea	(a1,d7.w),a6

		move.w	(a6)+,d5
		move.l	(a3,d5.l*8),(a2)
		move.l	(a4,d5.l*8),4(a2)

		move.w	(a6)+,d5
		move.l	(a3,d5.l*8),176(a2)
		move.l	(a4,d5.l*8),180(a2)

		move.w	(a6)+,d5
		move.l	(a3,d5.l*8),352(a2)
		move.l	(a4,d5.l*8),356(a2)

		move.w	(a6)+,d5
		move.l	(a3,d5.l*8),528(a2)
		move.l	(a4,d5.l*8),532(a2)

		move.w	(a6)+,d5
		move.l	(a3,d5.l*8),704(a2)
		move.l	(a4,d5.l*8),708(a2)

		move.w	(a6)+,d5
		move.l	(a3,d5.l*8),880(a2)
		move.l	(a4,d5.l*8),884(a2)

		move.w	(a6)+,d5
		move.l	(a3,d5.l*8),1056(a2)
		move.l	(a4,d5.l*8),1060(a2)

		move.w	(a6),d5
		move.l	(a3,d5.l*8),1232(a2)
		move.l	(a4,d5.l*8),1236(a2)

		addq.l	#8,a2
		dbra	d0,screen_draw_for_chunky_output_window_x

		add.l	d6,d4
		add.l	#32,a0
		dbra	d3,screen_draw_for_chunky_output_window_y

screen_draw_for_chunky_output_window_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		variables
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

chunky_scroll_x:dc.l	0
chunky_scroll_y:dc.l	0

gameboy_chunky_buffer:
		dc.l	0
planar_to_chunky_table_background:
		dc.l	0
