
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		wzonka-lad palette editor
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		incdir	"binworld:includes/"
		include	"exec/memory.i"
		include	"intuition/intuition.i"
		include	"graphics/videocontrol.i"
		include	"graphics/gfx.i"
		include	"graphics/gfxbase.i"
		include	"dos/dos.i"
		include	"reqtools.i"
		include	"intuition_lib.i"
		include	"diskfont_lib.i"
		include	"graphics_lib.i"
		include	"exec_lib.i"
		include	"dos_lib.i"
		include	"reqtools_lib.i"
		include	"gadtools_lib.i"

		include	"devices/inputevent.i"
		include	"devices/keyboard.i"
		include	"libraries/gadtools.i"
		include	"exec/io.i"

		incdir	"binworld:gameboy/"
		include	"screens.i"
		include	"iconstartup.i"

PGA_Dummy		EQU	(TAG_USER+$31000)
PGA_Freedom		EQU	(PGA_Dummy+$0001)

STRINGA_Dummy		EQU	(TAG_USER+$32000)
STRINGA_Justification	EQU	(STRINGA_Dummy+$0010)
STRINGA_ReplaceMode	EQU	(STRINGA_Dummy+$000D)

GA_Dummy                EQU     (TAG_USER+$30000)
GA_Disabled             EQU     (GA_Dummy+$000E)
GA_TabCycle		EQU	(GA_Dummy+$0024)

LORIENT_HORIZ		EQU	1
LORIENT_VERT		EQU	2

TRUE			=1
FALSE			=0

WriteChunkyPixels	=-1056

menu_x			=576
menu_y			=222

gadgets_x		=0
gadgets_y		=25
font_y_sub		=11
iff_y			=20

menu_idcmp		=IDCMP_GADGETUP!IDCMP_GADGETDOWN!IDCMP_CLOSEWINDOW!IDCMP_MOUSEMOVE!IDCMP_MOUSEBUTTONS
menu_flags		=WFLG_CLOSEGADGET!WFLG_DEPTHGADGET!WFLG_DRAGBAR!WFLG_ACTIVATE!WFLG_SMART_REFRESH!WFLG_GIMMEZEROZERO

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		section	juures,code
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gb_emu:		movem.l	d2-d7/a2-a6,-(SP)		;stack!
		move.l	execbase,exec_base		;cache it locally.

		move.l	exec_base,a6
		jsr	Forbid(a6)
		lea	message_port_name,a1
		jsr	FindPort(a6)
		move.l	d0,d7
		jsr	Permit(a6)
		tst.l	d7
		bne.w	quit				;only one palette editor
							;running at a time.
		move.l	exec_base,a6
		lea	disk_font_name,a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		move.l	d0,disk_font_base
		beq.w	quit

		lea	dos_name,a1
		moveq.l	#39,d0
		jsr	OpenLibrary(a6)
		move.l	d0,dos_base
		beq.w	quit

		lea	graphics_name,a1
		moveq.l	#39,d0
		jsr	OpenLibrary(a6)
		move.l	d0,graphics_base
		beq.w	quit

		lea	intuition_name,a1
		moveq.l	#39,d0
		jsr	OpenLibrary(a6)
		move.l	d0,intuition_base
		beq.w	quit

		lea	req_tools_name,a1
		moveq.l	#38,d0
		jsr	OpenLibrary(a6)
		move.l	d0,req_tools_base
		beq.w	quit

		lea	gad_tools_name,a1
		moveq.l	#38,d0
		jsr	OpenLibrary(a6)
		move.l	d0,gad_tools_base
		beq.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate the initial memory areas and set some pointers
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	list_of_areas,a4		;the memory list.
		lea	list_of_areas_ptr,a5
		bsr.w	allocate_list			;allocate memory.
		tst.l	d0				;errors?
		beq.w	quit				;yes! quit!

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		lock the pubscreen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	intuition_base,a6
		sub.l	a0,a0				;default pub screen.
		jsr	LockPubScreen(a6)
		move.l	d0,pub_screen_lock
		beq.w	quit

		move.l	gad_tools_base,a6
		move.l	d0,a0
		sub.l	a1,a1				;no tag list.
		jsr	GetVisualInfoA(a6)
		move.l	d0,visual_info
		beq.w	quit

		move.l	pub_screen_lock,a0
		lea	sc_RastPort(a0),a0
		moveq.l	#0,d0
		move.w	rp_TxHeight(a0),d0
		move.l	d0,screen_font_y

		add.l	#menu_y,d0
		move.l	d0,menu_window_y

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		convert the colour list
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	gameboy_colours,a0
		lea	colours_dat,a1
		moveq.l	#8-1,d0
convert_colours:move.b	1(a0),(a1)+
		move.b	2(a0),(a1)+
		move.b	3(a0),(a1)+
		addq.l	#4,a0
		dbra	d0,convert_colours

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		center the window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		moveq.l	#0,d0
		moveq.l	#0,d1
		move.l	pub_screen_lock,a0
		move.w	sc_Width(a0),d0
		move.w	sc_Height(a0),d1
		sub.l	#menu_x,d0
		sub.l	menu_window_y,d1
		tst.l	d0
		blt.w	quit
		tst.l	d1
		blt.w	quit
		lsr.w	#1,d0
		lsr.w	#1,d1
		lea	menu_window,a0
		move.w	d0,nw_LeftEdge(a0)
		move.w	d1,nw_TopEdge(a0)

		move.l	menu_window_y,d0
		move.w	d0,nw_Height(a0)
		move.w	d0,nw_MaxHeight(a0)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		create message port
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	exec_base,a6
		jsr	CreateMsgPort(a6)
		move.l	d0,message_port
		beq.w	quit

		move.l	d0,a1
		move.l	#message_port_name,LN_NAME(a1)
		move.b	#1,LN_PRI(a1)

		jsr	AddPort(a6)

		move.l	colour_message,a0
		move.l	colour_message_name,LN_NAME(a0)
		move.l	message_port,MN_REPLYPORT(a0)
		move.w	#MN_SIZE+8*3,MN_LENGTH(a0)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		gadtools
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	gad_tools_base,a6
		lea	context_g_menu,a0
		jsr	CreateContext(a6)
		tst.l	d0
		beq.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		open a font
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	disk_font_base,a6
		lea	font_attr,a0			;attributes for the font.
		jsr	OpenDiskFont(a6)		;open the font.
		move.l	d0,font_ptr			;save the pointer.
		bne.s	font_ok				;open worked perfectly.

		lea	font_attr,a0			;auxiliary font I.
		move.l	#another_name,(a0)
		jsr	OpenDiskFont(a6)
		move.l	d0,font_ptr
		bne.s	font_ok

		clr.b	font_attr_flags			;not a proportional font.
		lea	font_attr,a0			;auxiliary font II.
		move.l	#res_font_name,(a0)
		jsr	OpenDiskFont(a6)
		move.l	d0,font_ptr
font_ok:	

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate reqtools resources for rom loading and
;		snapshot loading / saving separately
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	rt_list,a5
		move.l	req_tools_base,a6
rt_f_alc_req:	tst.l	(a5)
		beq.s	rt_f_alc_done
		move.l	#RT_FILEREQ,d0
		moveq.l	#0,d1
		jsr	rtAllocRequestA(a6)
		move.l	(a5)+,a4
		move.l	d0,(a4)
		beq.w	quit
		bra.s	rt_f_alc_req
rt_f_alc_done:	

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		create the back pattern map
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	back_pattern_bn,a0
		move.l	back_pattern_map,a1
		moveq.l	#2-1,d7
back_pattern_crt:
		move.l	(a0)+,d0
		move.l	(a0)+,d1
		move.w	#menu_y/2-1,d3
back_pattern_crt_y:
		move.w	#menu_x/8/4-1,d2
back_pattern_crt_x_1:
		move.l	d0,(a1)+
		dbra	d2,back_pattern_crt_x_1
		move.w	#menu_x/8/4-1,d2
back_pattern_crt_x_2:
		move.l	d1,(a1)+
		dbra	d2,back_pattern_crt_x_2
		dbra	d3,back_pattern_crt_y
		dbra	d7,back_pattern_crt

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		init bitmaps
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	back_pattern_map_attr,a0
		move.l	back_pattern_map,a1
		moveq.l	#2,d0
		move.l	#menu_x,d1
		move.l	#menu_y,d2
		bsr.w	init_bit_map

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		precalc the gfx window game still colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	graphics_base,a6
		move.l	image_rast_port_1,a1
		jsr	InitRastPort(a6)
		move.l	image_rast_port_2,a1
		jsr	InitRastPort(a6)

		move.l	image_rast_port_1,a0
		move.l	image_tmp_rast_port_1,a1
		bsr.w	copy_rast_port

		move.l	image_rast_port_2,a0
		move.l	image_tmp_rast_port_2,a1
		bsr.w	copy_rast_port

		move.l	image_map_attr_1,a0
		lea	image_map_1,a1
		bsr.w	init_still_map
		move.l	image_map_attr_2,a0
		lea	image_map_2,a1
		bsr.w	init_still_map

		move.l	image_map_attr_1,a4
		lea	image_tmp_map_attr_1,a5
		bsr.w	alloc_bit_map
		tst.l	d0
		beq.w	quit

		move.l	d0,a0
		move.w	#176/8,bm_BytesPerRow(a0)
		move.w	#1,bm_Rows(a0)

		move.l	image_map_attr_2,a4
		lea	image_tmp_map_attr_2,a5
		bsr.w	alloc_bit_map
		tst.l	d0
		beq.w	quit

		move.l	d0,a0
		move.w	#176/8,bm_BytesPerRow(a0)
		move.w	#1,bm_Rows(a0)

		move.l	image_rast_port_1,a0
		move.l	image_map_attr_1,rp_BitMap(a0)
		move.l	image_rast_port_2,a0
		move.l	image_map_attr_2,rp_BitMap(a0)
		move.l	image_tmp_rast_port_1,a0
		move.l	image_tmp_map_attr_1,rp_BitMap(a0)
		clr.l	rp_Layer(a0)
		move.l	image_tmp_rast_port_2,a0
		move.l	image_tmp_map_attr_2,rp_BitMap(a0)
		clr.l	rp_Layer(a0)

		moveq.l	#0,d0
		moveq.l	#0,d1
		move.l	#175,d2
		moveq.l	#30,d3
		move.l	image_rast_port_1,a0
		move.l	image_tmp_rast_port_1,a1
		move.l	image_array_1,a2
		jsr	ReadPixelArray8(a6)

		moveq.l	#0,d0
		moveq.l	#0,d1
		move.l	#175,d2
		moveq.l	#30,d3
		move.l	image_rast_port_2,a0
		move.l	image_tmp_rast_port_2,a1
		move.l	image_array_2,a2
		jsr	ReadPixelArray8(a6)

		lea	image_tmp_map_attr_1,a1
		bsr.w	free_bit_maps
		lea	image_tmp_map_attr_2,a1
		bsr.w	free_bit_maps

		bsr.w	obtain_pens_and_convert_gfx	;obtain pens.
		bsr.w	copy_pens			;copy the pens forward.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		create all the gadtools buttons
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	menu_gadgets,a4
		lea	context_g_menu,a5
		bsr.w	gadget_crt			;create gadgets.
		tst.l	d0
		bne.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		load .prefs path from wzonka-lad.prefs
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	exec_base,a6
		move.l	#120,d0
		moveq.l	#MEMF_PUBLIC,d1
		jsr	AllocVec(a6)
		move.l	d0,d7				;d7 = buffer pointer.
		beq.w	prefs_path_load_error

		move.l	dos_base,a6
		move.l	#prefs_file_name,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,d6
		beq.w	prefs_path_load_error

		move.l	d0,d1
		move.l	#120*2,d2
		move.l	#OFFSET_BEGINNING,d3
		jsr	Seek(a6)

		move.l	d6,d1
		move.l	d7,d2
		move.l	#120,d3
		jsr	Read(a6)

		move.l	d6,d1
		jsr	Close(a6)

		move.l	req_tools_base,a6
		move.l	request_ptr_prefs,a1
		lea	req_change_tags,a0
		move.l	d7,4(a0)			;new def dir!
		jsr	rtChangeReqAttrA(a6)		;change to the default dir.

prefs_path_load_error:
		move.l	d7,a1
		bsr.w	free_vec

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		open the window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	intuition_base,a6
		lea	menu_window,a0
		lea	win_tags_u,a1			;universal taglist.
		jsr	OpenWindowTagList(a6)		;structure and open the window.
		move.l	d0,menu_ptr
		beq.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		init new bit maps for the output routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	graphics_base,a6
		cmp.w	#40,LIB_VERSION(a6)
		blt.s	no_graphics_lib_v40_or_hw
		tst.l	gb_ChunkyToPlanarPtr(a6)
		beq.s	no_graphics_lib_v40_or_hw
		move.l	#1,chunky_to_planar_hardware
		bra.w	no_tmp_rast_ports

no_graphics_lib_v40_or_hw:
		move.l	menu_ptr,a4
		move.l	wd_RPort(a4),a4
		move.l	rp_BitMap(a4),a4
		lea	image_tmp_map_attr_1,a5
		bsr.w	alloc_bit_map
		tst.l	d0
		beq.w	quit

		move.l	d0,a0
		move.w	#176/8,bm_BytesPerRow(a0)
		move.w	#1,bm_Rows(a0)

		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a0
		move.l	image_tmp_rast_port_1,a1
		bsr.w	copy_rast_port

		move.l	image_tmp_rast_port_1,a0
		move.l	image_tmp_map_attr_1,rp_BitMap(a0)
		clr.l	rp_Layer(a0)

		move.l	menu_ptr,a4
		move.l	wd_RPort(a4),a4
		move.l	rp_BitMap(a4),a4
		lea	image_tmp_map_attr_2,a5
		bsr.w	alloc_bit_map
		tst.l	d0
		beq.w	quit

		move.l	d0,a0
		move.w	#176/8,bm_BytesPerRow(a0)
		move.w	#1,bm_Rows(a0)

		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a0
		move.l	image_tmp_rast_port_2,a1
		bsr.w	copy_rast_port

		move.l	image_tmp_rast_port_2,a0
		move.l	image_tmp_map_attr_2,rp_BitMap(a0)
		clr.l	rp_Layer(a0)

no_tmp_rast_ports:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		continue with inits
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	graphics_base,a6
		move.l	back_pattern_map_attr,a0	;a0 = source bitmap.
		move.l	menu_ptr,a1
		move.l	wd_RPort(a1),a1			;a1 = destination rastport.
		moveq.l	#0,d0				;org x.
		moveq.l	#0,d1				;org y.
		moveq.l	#0,d2				;dst x.
		moveq.l	#0,d3				;dst y.
		move.l	#menu_x-4-4,d4			;size x.
		move.l	#menu_y-2-4+1,d5		;size y.
		move.l	#$c0,d6				;minterm.
		jsr	BltBitMapRastPort(a6)		;update the screen window.

		lea	menu_bevel_list,a5
		jsr	draw_bevel_list

		move.l	intuition_base,a6
		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a0
		lea	menu_item_text_1,a1
		moveq.l	#0,d0
		moveq.l	#0,d1
		jsr	PrintIText(a6)

		lea	colour_box_list,a5
		bsr.w	draw_colour_list

		bsr.w	write_still_images

		move.l	intuition_base,a6
		move.l	menu_ptr,a0
		move.l	#-1,a1
		lea	menu_scr_txt,a2
		jsr	SetWindowTitles(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		refresh the graphics
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	intuition_base,a6
		move.l	menu_ptr,a0
		move.l	context_g_menu,a1
		sub.l	a2,a2
		moveq.l	#-1,d0
		moveq.l	#-1,d1
		jsr	AddGList(a6)

		move.l	context_g_menu,a0
		move.l	menu_ptr,a1
		sub.l	a2,a2
		moveq.l	#-1,d0				;all gadgets.
		jsr	RefreshGList(a6)

		move.l	gad_tools_base,a6
		move.l	menu_ptr,a0
		sub.l	a1,a1
		jsr	GT_RefreshWindow(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		message loop
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_message:	move.l	dos_base,a6
		moveq.l	#5,d1
		jsr	Delay(a6)

		move.l	gad_tools_base,a6
		move.l	menu_ptr,a0
		move.l	wd_UserPort(a0),a0		;userport -> a0.
		jsr	GT_GetIMsg(a6)			;get every message.
		tst.l	d0				;avoid queue.
		bne.w	menu_message

		bsr.w	obtain_status

		bra.s	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		message from the menu window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_message:	move.l	exec_base,a6
		move.l	d0,a0
		move.l	im_Class(a0),d0

		cmp.l	#IDCMP_CLOSEWINDOW,d0
		beq.s	menu_quit

		move.l	im_IAddress(a0),d1		;address of a gadget.
		moveq.l	#0,d2
		move.w	im_Code(a0),d2			;menu id data.

		movem.l	d0-d2,-(SP)
		move.l	a0,a1				;a1 = message.
		jsr	ReplyMsg(a6)			;reply to it.
		movem.l	(SP)+,d0-d2

		cmp.l	#IDCMP_GADGETUP,d0
		beq.s	menu_buttons
		cmp.l	#IDCMP_MOUSEMOVE,d0
		beq.w	menu_sliders

		bra.w	get_message

menu_quit:	move.l	a0,a1				;a1 = message.
		jsr	ReplyMsg(a6)			;reply to it.
		bra.w	quit

menu_buttons:	moveq.l	#0,d0
		move.l	d1,a0
		move.w	gg_GadgetID(a0),d0		;d0 = gadget id.
		sub.b	#24,d0
		lea	menu_jump_tbl,a0
		jmp	([a0,d0.l*4])

menu_sliders:	moveq.l	#0,d0
		move.l	d1,a0
		move.w	gg_GadgetID(a0),d0		;d0 = gadget id.

		move.l	d0,-(SP)
		move.l	gad_tools_base,a6
		move.l	menu_ptr,a1
		sub.l	a2,a2
		lea	get_gadget_attrs_tag_list,a3
		jsr	GT_GetGadgetAttrsA(a6)
		move.l	(SP)+,d0

		move.l	get_gadget_attrs_tag_return,d1
		lea	colours_dat,a0
		cmp.b	(a0,d0.l),d1
		beq.w	get_message

		move.b	d1,(a0,d0.l)			;store the new colour value.

		lea	pen_list,a4
		move.l	(a4),pen_storage_list		;save the pens.
		move.l	4(a4),pen_storage_list+4		

		divu.w	#3,d0
		and.l	#$ff,d0
		move.l	d0,-(SP)
		move.l	graphics_base,a6
		move.l	pub_screen_lock,a0
		lea	sc_ViewPort(a0),a0
		move.l	vp_ColorMap(a0),a0
		move.b	(a4,d0.l),d0
		jsr	ReleasePen(a6)
		move.l	(SP)+,d0

		move.l	pub_screen_lock,a0
		lea	sc_ViewPort(a0),a0
		move.l	vp_ColorMap(a0),a0
		lea	colours_dat,a4			;input (r.B, g.B, b.B).
		lea	pen_list,a3			;output (.B).
		add.l	d0,a3
		move.l	d0,d1
		mulu.w	#3,d0
		add.l	d0,a4

		lea	colour_box_list,a5
		addq.l	#2*4,a5
		mulu.w	#12,d1
		add.l	d1,a5

		lea	obtain_pens_tag_list,a1
		moveq.l	#0,d1
		moveq.l	#0,d2
		moveq.l	#0,d3
		move.b	(a4)+,d1
		move.b	(a4)+,d2
		move.b	(a4),d3
		ror.l	#8,d1
		ror.l	#8,d2
		ror.l	#8,d3
		jsr	ObtainBestPenA(a6)
		move.b	d0,(a3)
		and.l	#$ff,d0
		move.l	d0,(a5)

		move.l	a5,-(SP)
		bsr.w	remap_still_images		;remap?
		move.l	(SP)+,a5

		tst.l	conversion_occurred		;is the redrawing needed?
		beq.w	get_message			;nope, no differences.

		move.l	a5,-(SP)
		bsr.w	write_still_images		;output the images.
		move.l	(SP)+,a5

		move.l	(a5),d7
		subq.l	#2*4,a5
		move.l	(a5)+,d0
		move.l	(a5),d1
		bsr.w	draw_colour_box

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		load .prefs colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

prefs_load:	move.l	req_tools_base,a6
		lea	req_tags,a0			;the tags.
		move.l	menu_ptr,4(a0)			;the position pointer.
		move.l	request_ptr_prefs,a1		;the requester pointer.
		move.l	prefs_name,a2			;the output area.
		lea	prefs_load_and_save_txt,a3	;the title text.
		jsr	rtFileRequestA(a6)		;open a file requester.

		move.l	prefs_name_and_dir,a0
		move.l	prefs_name,a1
		move.l	request_ptr_prefs,a2
		bsr.w	parse_req_name

		move.l	dos_base,a6
		move.l	prefs_name_and_dir,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,d7
		beq.w	prefs_load_error

		move.l	d0,d1
		move.l	#colours_dat,d2
		move.l	#3*4*2,d3
		jsr	Read(a6)

		move.l	d7,d1
		jsr	Close(a6)

		bsr.w	obtain_colours_apply_list	;use the list.

prefs_load_error:
		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		save .prefs colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

prefs_save:	move.l	req_tools_base,a6
		lea	req_tags,a0			;the tags.
		move.l	menu_ptr,4(a0)			;the position pointer.
		move.l	request_ptr_prefs,a1		;the requester pointer.
		move.l	prefs_name,a2			;the output area.
		lea	prefs_load_and_save_txt,a3	;the title text.
		jsr	rtFileRequestA(a6)		;open a file requester.

		move.l	prefs_name_and_dir,a0
		move.l	prefs_name,a1
		move.l	request_ptr_prefs,a2
		bsr.w	parse_req_name

		move.l	dos_base,a6
		move.l	prefs_name_and_dir,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,d7
		beq.w	prefs_save_error

		move.l	d0,d1
		move.l	#colours_dat,d2
		move.l	#3*4*2,d3
		jsr	Write(a6)

		move.l	d7,d1
		jsr	Close(a6)

		bsr.w	obtain_colours_apply_list	;use the list.

prefs_save_error:
		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		load .iff file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

iff_load:	move.l	req_tools_base,a6
		lea	req_tags,a0			;the tags.
		move.l	menu_ptr,4(a0)			;the position pointer.
		move.l	request_ptr_iff,a1		;the requester pointer.
		move.l	iff_name,a2			;the output area.
		lea	iff_load_txt,a3			;the title text.
		jsr	rtFileRequestA(a6)		;open a file requester.

		move.l	iff_name_and_dir,a0
		move.l	iff_name,a1
		move.l	request_ptr_iff,a2
		bsr.w	parse_req_name

		move.l	dos_base,a6
		move.l	iff_name_and_dir,d1
		moveq.l	#ACCESS_READ,d2
		jsr	Lock(a6)
		move.l	d0,d6
		beq.w	iff_load_error			;an error occurred!

		move.l	file_info_ptr,d2
		move.l	d0,d1
		jsr	Examine(a6)

		move.l	d6,d1
		jsr	UnLock(a6)

		move.l	file_info_ptr,a0
		move.l	124(a0),d7			;d7 = file size.

iff_load_allocate_buffer:
		move.l	exec_base,a6
		move.l	d7,d0
		moveq.l	#MEMF_PUBLIC,d1
		jsr	AllocVec(a6)
		move.l	d0,d6				;d6 = buffer pointer.
		beq.w	iff_load_error

		move.l	dos_base,a6
		move.l	iff_name_and_dir,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,d5
		beq.w	iff_load_free_buffer

		move.l	d0,d1
		move.l	d6,d2
		move.l	d7,d3
		jsr	Read(a6)

		move.l	d5,d1
		jsr	Close(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		find the CMAP tag
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	colours_dat,a0
		move.l	d6,a1
		move.l	d7,d0
iff_find_tag:	cmp.l	#"CMAP",(a1)
		beq.s	iff_found_cmap
		addq.l	#1,a1
		subq.l	#1,d0
		bne.s	iff_find_tag
		bra.s	iff_load_free_buffer

iff_found_cmap:	addq.l	#4+4,a1
		moveq.l	#8-1,d0
iff_copy_data:	move.w	(a1)+,(a0)+
		move.b	(a1)+,(a0)+
		dbra	d0,iff_copy_data

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		use the obtained colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

iff_load_apply_list:
		move.l	d6,-(SP)
		bsr.w	obtain_colours_apply_list	;use the list.
		move.l	(SP)+,d6

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		exit .iff loading
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

iff_load_free_buffer:
		move.l	exec_base,a6
		move.l	d6,a1
		jsr	FreeVec(a6)

iff_load_error:	bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		load .cfg file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

cfg_load:	move.l	req_tools_base,a6
		lea	req_tags,a0			;the tags.
		move.l	menu_ptr,4(a0)			;the position pointer.
		move.l	request_ptr_cfg,a1		;the requester pointer.
		move.l	cfg_name,a2			;the output area.
		lea	cfg_load_txt,a3			;the title text.
		jsr	rtFileRequestA(a6)		;open a file requester.

		move.l	cfg_name_and_dir,a0
		move.l	cfg_name,a1
		move.l	request_ptr_cfg,a2
		bsr.w	parse_req_name

		move.l	dos_base,a6
		move.l	cfg_name_and_dir,d1
		moveq.l	#ACCESS_READ,d2
		jsr	Lock(a6)
		move.l	d0,d7
		beq.w	cfg_load_error			;an error occurred!

		move.l	file_info_ptr,d2
		move.l	d0,d1
		jsr	Examine(a6)

		move.l	d7,d1
		jsr	UnLock(a6)

		move.l	file_info_ptr,a0
		move.l	124(a0),d7			;d7 = file size.

cfg_load_allocate_buffer:
		move.l	exec_base,a6
		move.l	d7,d0
		moveq.l	#MEMF_PUBLIC,d1
		jsr	AllocVec(a6)
		move.l	d0,d6				;d6 = buffer pointer.
		beq.w	cfg_load_error

		move.l	dos_base,a6
		move.l	cfg_name_and_dir,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,d5
		beq.w	cfg_load_free_buffer

		move.l	d0,d1
		move.l	d6,d2
		move.l	d7,d3
		jsr	Read(a6)

		move.l	d5,d1
		jsr	Close(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		convert all letters to lower case
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	d6,a0
		move.l	d7,d0
		moveq.l	#0,d1
cfg_load_lower_case_conversion:
		move.b	(a0),d1
		cmp.w	#"A",d1
		blt.s	cfg_load_lower_case_miss
		cmp.w	#"Z",d1
		bgt.s	cfg_load_lower_case_miss
		sub.b	#"A"-"a",(a0)
cfg_load_lower_case_miss:
		addq.l	#1,a0
		subq.l	#1,d0
		bne.s	cfg_load_lower_case_conversion

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		seek the colour values
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

cfg_load_seek:	lea	cfg_colour_id_list_long_names,a1
		moveq.l	#(4+4+4)*2+4-1,d1		;number of choices.
		lea	cfg_colour_id_list_position,a5
cfg_load_execute_long_seek:
		move.l	d6,a0
		move.l	d7,d0
		move.l	(a1)+,a2			;.B comparison value.
		move.b	(a2)+,d2
		lea	colours_dat,a3
		add.l	(a5)+,a3
cfg_load_execute_long_seeking:
		cmp.b	(a0),d2
		beq.w	cfg_load_execute_long_hit
		addq.l	#1,a0
		subq.l	#1,d0
		bne.s	cfg_load_execute_long_seeking

		dbra	d1,cfg_load_execute_long_seek	;locate the next entry.
		bra.w	cfg_load_apply_list

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		a hit occurred!
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

cfg_load_execute_hit:
		addq.l	#1,a0				;(a0) = "#xyz" / eg. "blue".
		cmp.b	#"#",(a0)
		beq.s	cfg_load_execute_hit_digits
cfg_load_execute_hit_name:
		movem.l	d0-d7/a0-a6,-(SP)

		lea	vgb_colours,a4
		lea	vgb_colours_h-3,a5
		move.l	a0,d7
cfg_load_execute_hit_name_validity_check:
		move.l	(a4)+,d0
		beq.s	cfg_load_execute_hit_name_invalid
		move.l	d0,a1
		move.l	d7,a0
		addq.l	#3,a5
cfg_load_execute_hit_name_validity_checking:
		move.b	(a1)+,d2
		beq.s	cfg_load_execute_hit_name_valid
		cmp.b	(a0)+,d2
		bne.s	cfg_load_execute_hit_name_validity_check
		bra.s	cfg_load_execute_hit_name_validity_checking

cfg_load_execute_hit_name_valid:
		move.w	(a5)+,(a3)+
		move.b	(a5),(a3)

cfg_load_execute_hit_name_invalid:
		movem.l	(SP)+,d0-d7/a0-a6
		rts

cfg_load_execute_hit_digits:
		addq.l	#1,a0
		moveq.l	#3-1,d0
		moveq.l	#0,d2
		move.l	a3,a4
cfg_load_execute_hit_digits_obtain:
		bsr.b	cfg_load_execute_hit_digits_parse
		move.b	d2,d3
		lsl.b	#4,d3
		bsr.b	cfg_load_execute_hit_digits_parse
		or.b	d2,d3
		move.b	d3,(a4)+
		dbra	d0,cfg_load_execute_hit_digits_obtain
		rts

cfg_load_execute_hit_digits_parse:
		move.b	(a0)+,d2
		cmp.w	#"0",d2
		blt.s	cfg_load_execute_hit_digits_no_number
		cmp.w	#"9",d2
		bgt.s	cfg_load_execute_hit_digits_no_number
		sub.b	#"0",d2
		rts

cfg_load_execute_hit_digits_no_number:
		cmp.w	#"a",d2
		blt.s	cfg_load_execute_hit_digits_no_letter
		cmp.w	#"f",d2
		bgt.s	cfg_load_execute_hit_digits_no_letter
		sub.b	#"a"-$a,d2
		rts

cfg_load_execute_hit_digits_no_letter:
		clr.b	d2
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the first letter was the same
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

cfg_load_execute_long_hit:
		movem.l	d0-d7/a0-a6,-(SP)
		addq.l	#1,a0

cfg_load_execute_long_hit_validity_check:
		move.b	(a2)+,d2
		beq.s	cfg_load_execute_long_hit_valid
		cmp.b	(a0)+,d2
		bne.s	cfg_load_execute_long_hit_invalid
		bra.s	cfg_load_execute_long_hit_validity_check

cfg_load_execute_long_hit_valid:
		bsr.w	cfg_load_execute_hit

		movem.l	(SP)+,d0-d7/a0-a6
		dbra	d1,cfg_load_execute_long_seek	;locate the next entry.
		bra.s	cfg_load_apply_list

cfg_load_execute_long_hit_invalid:
		movem.l	(SP)+,d0-d7/a0-a6
		addq.l	#1,a0
		subq.l	#1,d0
		bne.w	cfg_load_execute_long_seeking

		dbra	d1,cfg_load_execute_long_seek	;locate the next entry.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		use the obtained colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

cfg_load_apply_list:
		move.l	d6,-(SP)
		bsr.w	obtain_colours_apply_list	;use the list.
		move.l	(SP)+,d6

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		exit .cfg loading
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

cfg_load_free_buffer:
		move.l	exec_base,a6
		move.l	d6,a1
		jsr	FreeVec(a6)

cfg_load_error:	bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		jump table
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_jump_tbl:	dc.l	prefs_load
		dc.l	prefs_save
		dc.l	cfg_load
		dc.l	cfg_save
		dc.l	obtain_from_wzonka_lad
		dc.l	interpolate_back_ground
		dc.l	interpolate_sprites

		dc.l	copy_left_1
		dc.l	copy_right_1
		dc.l	copy_left_2
		dc.l	copy_right_2
		dc.l	copy_left_3
		dc.l	copy_right_3
		dc.l	copy_left_4
		dc.l	copy_right_4

		dc.l	iff_load

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		obtain new colours from wzonka-lad
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

obtain_from_wzonka_lad:
		move.l	exec_base,a6
		jsr	Forbid(a6)
		lea	message_port_wzonka_lad_name,a1
		jsr	FindPort(a6)
		move.l	d0,message_port_wzonka_lad
		jsr	Permit(a6)

		tst.l	message_port_wzonka_lad
		beq.w	get_message

		move.l	message_port_wzonka_lad,a0
		move.l	colour_message,a1
		move.l	colour_message_name,a2
		move.b	#1,(a2)				;request for the colours.
		jsr	PutMsg(a6)

		move.l	message_port,a0
		jsr	WaitPort(a6)

		bsr.w	obtain_status_on_get_message
		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		turn on/off the obtain-gadget?
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

obtain_status:	subq.b	#1,obtain_status_counter
		bne.s	obtain_status_x
		move.b	#4,obtain_status_counter

		move.l	exec_base,a6
		jsr	Forbid(a6)
		lea	message_port_wzonka_lad_name,a1
		jsr	FindPort(a6)
		move.l	d0,message_port_wzonka_lad
		jsr	Permit(a6)

		tst.l	message_port_wzonka_lad
		bne.s	obtain_on

obtain_off:	tst.l	obtain_gadget_status
		bne.s	obtain_status_x

		move.l	intuition_base,a6
		move.l	menu_b_5,a0
		move.l	menu_ptr,a1
		sub.l	a2,a2
		jsr	OffGadget(a6)

		move.l	#1,obtain_gadget_status
obtain_status_x:rts

obtain_on:	tst.l	obtain_gadget_status
		beq.s	obtain_status_on_get_message

		move.l	intuition_base,a6
		move.l	menu_b_5,a0
		move.l	menu_ptr,a1
		sub.l	a2,a2
		jsr	OnGadget(a6)

		clr.l	obtain_gadget_status
obtain_status_on_get_message:
		move.l	exec_base,a6
		move.l	message_port,a0
		jsr	GetMsg(a6)
		tst.l	d0
		beq.s	obtain_status_on_x

obtain_status_on_message_ready:
		move.l	d0,a0
		move.l	LN_NAME(a0),a1

		move.l	MN_REPLYPORT(a0),d1
		cmp.l	message_port_wzonka_lad,d1
		beq.s	send_new_colours
		cmp.l	message_port,d1
		beq.s	obtain_new_colours

obtain_status_reply:
		move.l	a0,a1
		jsr	ReplyMsg(a6)			;send the stuff back.

obtain_status_on_x:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		send new colours
;		INPUT:
;		a0	= message.
;		a1	= data area (256.B).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

send_new_colours:
		lea	colours_dat,a2
		moveq.l	#8*3/4-1,d0
		lea	(MN_LENGTH+2)(a0),a3
copy_colours_data:
		move.l	(a2)+,(a3)+
		dbra	d0,copy_colours_data

		move.l	a0,a1
		jsr	ReplyMsg(a6)			;send the colours back.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		obtain new colours
;		INPUT:
;		a0	= message.
;		a1	= data area (256.B).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

obtain_new_colours:
		lea	colours_dat,a2
		moveq.l	#8*3/4-1,d0
		lea	(MN_LENGTH+2)(a0),a3
obtain_colours_data:
		move.l	(a3)+,(a2)+
		dbra	d0,obtain_colours_data

obtain_colours_apply_list:
		lea	pen_list,a4
		move.l	(a4),pen_storage_list		;save the pens.
		move.l	4(a4),pen_storage_list+4		
		lea	colours_dat,a3

		move.l	pub_screen_lock,a5
		lea	sc_ViewPort(a5),a5
		move.l	vp_ColorMap(a5),a5
		move.l	graphics_base,a6
		moveq.l	#8-1,d7

obtain_change_pens:
		moveq.l	#0,d0
		move.b	(a4),d0
		move.l	a5,a0
		jsr	ReleasePen(a6)

		lea	obtain_pens_tag_list,a1
		moveq.l	#0,d1
		moveq.l	#0,d2
		moveq.l	#0,d3
		move.b	(a3)+,d1
		move.b	(a3)+,d2
		move.b	(a3)+,d3
		ror.l	#8,d1
		ror.l	#8,d2
		ror.l	#8,d3
		move.l	a5,a0
		jsr	ObtainBestPenA(a6)
		move.b	d0,(a4)+
		dbra	d7,obtain_change_pens

		bsr.w	remap_still_images		;remap?

		tst.l	conversion_occurred		;is the redrawing needed?
		beq.w	obtain_new_colours_x		;nope, no differences.

		bsr.w	write_still_images		;output the images.
		bsr.w	copy_pens			;copy pens.

		lea	colour_box_list,a5
		bsr.w	draw_colour_list

obtain_new_colours_x:
		move.l	gad_tools_base,a6
		lea	colours_dat,a4
		lea	colour_1_r,a5			;the very first slider.
		moveq.l	#0,d5

		moveq.l	#8*3-1,d7
obtain_new_set_colour_slider_attrs:
		move.l	(a5)+,a0
		move.l	menu_ptr,a1
		sub.l	a2,a2
		lea	set_gadget_attrs_tag_list,a3
		move.b	(a4)+,d5
		move.l	d5,4(a3)
		jsr	GT_SetGadgetAttrsA(a6)
		dbra	d7,obtain_new_set_colour_slider_attrs
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

copy_left_1:	moveq.l	#0,d7
		bra.w	copy_left

copy_left_2:	moveq.l	#1,d7
		bra.w	copy_left

copy_left_3:	moveq.l	#2,d7
		bra.w	copy_left

copy_left_4:	moveq.l	#3,d7
		bra.w	copy_left

copy_right_1:	moveq.l	#0,d7
		bra.w	copy_right

copy_right_2:	moveq.l	#1,d7
		bra.w	copy_right

copy_right_3:	moveq.l	#2,d7
		bra.w	copy_right

copy_right_4:	moveq.l	#3,d7
		bra.w	copy_right

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy left
;		INPUT:
;		d7	= number of colour.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

copy_left:	lea	pen_list,a4
		move.l	(a4),pen_storage_list		;save the pens.
		move.l	4(a4),pen_storage_list+4		

		lea	colours_dat,a0
		move.l	d7,d1
		mulu.w	#3,d1
		lea	(a0,d1.l),a3
		add.l	#3*4,d1
		add.l	d1,a0
		move.w	(a0)+,(a3)
		move.b	(a0),2(a3)

		bra.s	remap_one_colour

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy right
;		INPUT:
;		d7	= number of colour.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

copy_right:	lea	pen_list,a4
		move.l	(a4),pen_storage_list		;save the pens.
		move.l	4(a4),pen_storage_list+4		

		lea	colours_dat,a0
		move.l	d7,d1
		mulu.w	#3,d1
		lea	(a0,d1.l),a3
		add.l	#3*4,d1
		add.l	d1,a0
		move.w	(a3),(a0)+
		move.b	2(a3),(a0)

		add.b	#4,d7
		bra.s	remap_one_colour

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		remap only one colour
;		INPUT:
;		d7	= number of colour.
;		a3	= rgb value list.
;		a4	= pen list.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

remap_one_colour:
		add.l	d7,a4
		move.l	pub_screen_lock,a5
		lea	sc_ViewPort(a5),a5
		move.l	vp_ColorMap(a5),a5
		move.l	graphics_base,a6
		moveq.l	#0,d0
		move.b	(a4),d0
		move.l	a5,a0
		jsr	ReleasePen(a6)

		lea	obtain_pens_tag_list,a1
		moveq.l	#0,d1
		moveq.l	#0,d2
		moveq.l	#0,d3
		move.b	(a3)+,d1
		move.b	(a3)+,d2
		move.b	(a3),d3
		ror.l	#8,d1
		ror.l	#8,d2
		ror.l	#8,d3
		move.l	a5,a0
		jsr	ObtainBestPenA(a6)
		move.b	d0,(a4)

		move.l	d7,-(SP)
		bsr.w	remap_still_images		;remap?
		move.l	(SP)+,d7

		tst.l	conversion_occurred		;is the redrawing needed?
;		beq.w	get_message			;nope, no differences.

		move.l	d7,-(SP)
		bsr.w	write_still_images		;output the images.
		bsr.w	copy_pens
		move.l	(SP),d7

		lea	colour_box_list,a0
		mulu.w	#3*4,d7
		add.l	d7,a0
		move.l	(a0)+,d0
		move.l	(a0)+,d1
		move.l	(a0),d7
		bsr.w	draw_colour_box

		move.l	(SP)+,d0
		move.l	gad_tools_base,a6
		lea	colour_1_r,a5			;the very first slider.
		move.l	d0,d1
		mulu.w	#12,d0
		add.l	d0,a5
		moveq.l	#0,d5
		lea	colours_dat,a4
		mulu.w	#3,d1
		add.l	d1,a4

		moveq.l	#3-1,d7
set_colour_slider_attributes:
		move.l	(a5)+,a0
		move.l	menu_ptr,a1
		sub.l	a2,a2
		lea	set_gadget_attrs_tag_list,a3
		move.b	(a4)+,d5
		move.l	d5,4(a3)
		jsr	GT_SetGadgetAttrsA(a6)
		dbra	d7,set_colour_slider_attributes

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		save .cfg colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

cfg_save:	move.l	req_tools_base,a6
		lea	req_tags,a0			;the tags.
		move.l	menu_ptr,4(a0)			;the position pointer.
		move.l	request_ptr_cfg,a1		;the requester pointer.
		move.l	cfg_name,a2			;the output area.
		lea	cfg_save_txt,a3			;the title text.
		jsr	rtFileRequestA(a6)		;open a file requester.

		move.l	cfg_name_and_dir,a0
		move.l	cfg_name,a1
		move.l	request_ptr_cfg,a2
		bsr.w	parse_req_name

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		encode the colour values
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	cfg_colours_output,a0		;pointer list.
		lea	colours_dat,a1
		bsr.w	encode_four_colours

		lea	cfg_colours_output+4*4,a0
		lea	colours_dat,a1
		bsr.w	encode_four_colours

		lea	cfg_colours_output+4*4*2,a0
		lea	colours_dat+4*3,a1
		bsr.w	encode_four_colours

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		save the file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	dos_base,a6			;open the data file.
		move.l	cfg_name_and_dir,d1		;the name of the file.
		move.l	#Mode_New,d2
		jsr	Open(a6)
		move.l	d0,d7
		beq.w	cfg_save_error			;file error!

		move.l	d0,d1
		move.l	#cfg_save_file,d2		;output address.
		move.l	#cfg_save_file_end-cfg_save_file,d3
							;the length.
		jsr	Write(a6)

		move.l	d7,d1
		jsr	Close(a6)

cfg_save_error:	bra.w	get_message			;back to the loop.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		encode four colours
;		INPUT:
;		a0	= pointer list.
;		a1	= colour values.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

encode_four_colours:
		moveq.l	#4-1,d0
encode_four_colours_rgb:
		moveq.l	#3-1,d1
		move.l	(a0)+,a2
encode_four_colours_byte:
		move.b	(a1)+,d2
		move.b	d2,d3
		lsr.b	#4,d3
		bsr.b	encode_four_colours_nibble
		and.b	#$f,d2
		move.b	d2,d3
		bsr.b	encode_four_colours_nibble
		dbra	d1,encode_four_colours_byte
		dbra	d0,encode_four_colours_rgb
		rts

encode_four_colours_nibble:
		cmp.b	#$a,d3
		blt.s	encode_four_colours_number
encode_four_colours_letter:
		add.b	#'a'-$a,d3
		move.b	d3,(a2)+
		rts
encode_four_colours_number:
		add.b	#'0',d3
		move.b	d3,(a2)+
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		interpolate colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

interpolate_back_ground:
		moveq.l	#4,d0
		bra.s	interpolate_colours

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		interpolate colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

interpolate_sprites:
		moveq.l	#0,d0
;		bra.s	interpolate_colours

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		interpolate colours
;		INPUT:
;		d0	= starting colour.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

interpolate_colours:
		move.l	d0,-(SP)

		lea	colours_dat,a4
		mulu.w	#3,d0

		add.l	d0,a4
		move.l	(a4),d1				;c0.
		lsr.l	#8,d1
		move.l	3(a4),d2			;c1.
		lsr.l	#8,d2
		move.l	6(a4),d3			;c2.
		lsr.l	#8,d3
		move.l	9(a4),d4			;c3.
		lsr.l	#8,d4

		moveq.l	#0,d5
		moveq.l	#0,d6
		move.b	d1,d5				;b.
		move.b	d4,d6
		sub.l	d5,d6
		divs.l	#3,d6				;d6 = delta blue.
		add.l	d6,d5
		move.b	d5,d2
		add.l	d6,d5
		move.b	d5,d3				;b done.

		moveq.l	#0,d5
		moveq.l	#0,d6
		move.w	d1,d5				;g.
		move.w	d4,d6
		clr.b	d5
		clr.b	d6
		sub.l	d5,d6
		divs.l	#3,d6				;d6 = delta green.
		add.l	d6,d5
		move.b	d2,d5
		move.w	d5,d2
		add.l	d6,d5
		move.b	d3,d5
		move.w	d5,d3				;g done.

		move.l	d1,d5				;r.
		move.l	d4,d6
		clr.w	d5
		clr.w	d6
		sub.l	d5,d6
		divs.l	#3,d6				;d6 = delta red.
		add.l	d6,d5
		move.w	d2,d5
		move.l	d5,d2
		add.l	d6,d5
		move.w	d3,d5
		move.l	d5,d3				;r done.

		move.b	d2,5(a4)
		lsr.l	#8,d2
		move.b	d2,4(a4)
		lsr.w	#8,d2
		move.b	d2,3(a4)

		move.b	d3,8(a4)
		lsr.l	#8,d3
		move.b	d3,7(a4)
		lsr.w	#8,d3
		move.b	d3,6(a4)

		move.l	(SP),d0
		addq.b	#1,d0
		addq.l	#3,a4

		move.l	gad_tools_base,a6
		lea	colour_1_r,a5			;the very first slider.
		mulu.w	#12,d0
		add.l	d0,a5
		moveq.l	#0,d5

		moveq.l	#2*3-1,d7
set_colour_slider_attrs:
		move.l	(a5)+,a0
		move.l	menu_ptr,a1
		sub.l	a2,a2
		lea	set_gadget_attrs_tag_list,a3
		move.b	(a4)+,d5
		move.l	d5,4(a3)
		jsr	GT_SetGadgetAttrsA(a6)
		dbra	d7,set_colour_slider_attrs

		move.l	(SP)+,d0
		addq.b	#1,d0				;to the second colour.

		lea	pen_list,a4
		move.l	(a4),pen_storage_list		;save the pens.
		move.l	4(a4),pen_storage_list+4		
		add.l	d0,a4
		lea	colours_dat,a3
		mulu.w	#3,d0
		add.l	d0,a3

		move.l	pub_screen_lock,a5
		lea	sc_ViewPort(a5),a5
		move.l	vp_ColorMap(a5),a5
		move.l	graphics_base,a6
		moveq.l	#2-1,d7

change_pens:	moveq.l	#0,d0
		move.b	(a4),d0
		move.l	a5,a0
		jsr	ReleasePen(a6)

		lea	obtain_pens_tag_list,a1
		moveq.l	#0,d1
		moveq.l	#0,d2
		moveq.l	#0,d3
		move.b	(a3)+,d1
		move.b	(a3)+,d2
		move.b	(a3)+,d3
		ror.l	#8,d1
		ror.l	#8,d2
		ror.l	#8,d3
		move.l	a5,a0
		jsr	ObtainBestPenA(a6)
		move.b	d0,(a4)+
		dbra	d7,change_pens

		bsr.w	remap_still_images		;remap?

		tst.l	conversion_occurred		;is the redrawing needed?
		beq.w	get_message			;nope, no differences.

		bsr.w	write_still_images		;output the images.
		bsr.w	copy_pens			;copy pens.

		lea	colour_box_list,a5
		bsr.w	draw_colour_list

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate bit map (tmp)
;		INPUT:
;		a4	= another bit map.
;		a5	= place for pointer.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

alloc_bit_map:	move.l	#176,d0
		moveq.l	#1,d1
		moveq.l	#0,d2
		move.b	bm_Depth(a4),d2
		moveq.l	#0,d3
		sub.l	a0,a0
		move.l	graphics_base,a6
		jsr	AllocBitMap(a6)
		move.l	d0,(a5)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		init the given bitmap
;		INPUT:
;		d0	= z.
;		d1	= x.
;		d2	= y.
;		a0	= attributes.
;		a1	= planes.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

init_bit_map:	lea	bm_Planes(a0),a2
		move.l	d1,d3
		lsr.w	#3,d3
		mulu.w	d2,d3				;d3 = x/8*y.
		move.w	d0,d7
		subq.w	#1,d7
init_bit_map_pt:move.l	a1,(a2)+
		add.l	d3,a1
		dbra	d7,init_bit_map_pt

		move.l	graphics_base,a6
		jsr	InitBitMap(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		remap
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

remap_still_images:
		move.l	pen_list,d0
		cmp.l	pen_storage_list,d0
		bne.s	convert_all_pens		;pen(s) have changed.
		move.l	pen_list+4,d0
		cmp.l	pen_storage_list+4,d0
		bne.s	convert_all_pens
		clr.l	conversion_occurred
		rts					;no conversion.

convert_all_pens:
		move.l	#1,conversion_occurred		;the image has to be
							;redrawn.
		move.l	image_array_1,a0
		move.l	image_tmp_array_1,a1
		lea	pen_list,a2
		move.w	#(176*31)-1,d0
		moveq.l	#0,d1
remap_convert_pens:
		move.b	(a0)+,d1
		move.b	(a2,d1.l),(a1)+
		dbra	d0,remap_convert_pens

		move.l	image_array_2,a0
		move.l	image_tmp_array_2,a1
		lea	pen_list,a2
		move.w	#(176*31)-1,d0
		moveq.l	#0,d1
remap_convert_pens_x:
		move.b	(a0)+,d1
		move.b	(a2,d1.l),(a1)+
		dbra	d0,remap_convert_pens_x
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		write still images
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

write_still_images:
		move.l	graphics_base,a6
		tst.l	chunky_to_planar_hardware
		bne.s	use_write_chunky_pixels

		move.l	#132,d0
		move.l	#185-font_y_sub,d1
		move.l	#132+175,d2
		move.l	#185+30-font_y_sub,d3
		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a0
		move.l	image_tmp_rast_port_1,a1
		move.l	image_tmp_array_1,a2
		jsr	WritePixelArray8(a6)

		move.l	#362,d0
		move.l	#185-font_y_sub,d1
		move.l	#362+175,d2
		move.l	#185+30-font_y_sub,d3
		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a0
		move.l	image_tmp_rast_port_2,a1
		move.l	image_tmp_array_2,a2
		jsr	WritePixelArray8(a6)
		rts

use_write_chunky_pixels:
		move.l	#132,d0
		move.l	#185-font_y_sub,d1
		move.l	#132+175,d2
		move.l	#185+30-font_y_sub,d3
		move.l	#176,d4
		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a0
		move.l	image_tmp_array_1,a2
		jsr	WriteChunkyPixels(a6)

		move.l	#362,d0
		move.l	#185-font_y_sub,d1
		move.l	#362+175,d2
		move.l	#185+30-font_y_sub,d3
		move.l	#176,d4
		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a0
		move.l	image_tmp_array_2,a2
		jsr	WriteChunkyPixels(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		create gadgets
;		INPUT:
;		a4	= gadget list
;		a5	= the first gadget
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gadget_crt:	move.l	gad_tools_base,a6

gadget_crt_s:	move.l	univ_gadget,a1
		move.w	(a4)+,gng_LeftEdge(a1)		;x.
		beq.w	gadget_crt_x			;end of gadgets.
		move.w	(a4)+,gng_TopEdge(a1)		;y.
		move.l	(a4)+,gng_Flags(a1)		;flags.
		move.l	(a4)+,gng_GadgetText(a1)	;text.
		move.w	(a4)+,gng_GadgetID(a1)		;id number.
		move.l	#font_attr,gng_TextAttr(a1)
		move.l	visual_info,gng_VisualInfo(a1)

		move.l	(a5),a0
		move.w	(a4)+,d1
		beq.s	gadget_crt_btn			;no tags! (button_kind).
		cmp.b	#1,d1
		beq.s	gadget_crt_mx			;mx_kind!
		cmp.b	#2,d1
		beq.s	gadget_crt_str			;string_kind!
		cmp.b	#3,d1
		beq.w	gadget_crt_lw			;listview_kind!
		cmp.b	#4,d1
		beq.w	gadget_crt_sld			;slider_kind!

gadget_crt_mx:	move.w	#17,gng_Width(a1)		;dx.
		move.w	#9,gng_Height(a1)		;dy.
		move.l	(a4)+,a2
		move.l	(a4)+,4(a2)
		move.l	#MX_KIND,d0			;gadget type.
		jsr	CreateGadgetA(a6)

		move.l	(a4)+,a5
		move.l	d0,(a5)
		beq.w	gadget_crt_err
		bra.w	gadget_crt_s

gadget_crt_btn:	move.w	(a4)+,gng_Width(a1)		;dx.
		move.w	(a4)+,gng_Height(a1)		;dy.
		sub.l	a2,a2				;no tags!
		move.l	#BUTTON_KIND,d0
		jsr	CreateGadgetA(a6)

		move.l	(a4)+,a5
		move.l	d0,(a5)
		beq.s	gadget_crt_err
		bra.w	gadget_crt_s

gadget_crt_str:	move.w	(a4)+,gng_Width(a1)		;dx.
		move.w	(a4)+,gng_Height(a1)		;dy.
		move.l	(a4)+,a2
		move.l	(a4)+,a5
		move.l	(a5),4(a2)
		move.l	#STRING_KIND,d0
		jsr	CreateGadgetA(a6)

		move.l	(a4)+,a5
		move.l	d0,(a5)
		beq.s	gadget_crt_err
		bra.w	gadget_crt_s

gadget_crt_lw:	move.w	(a4)+,gng_Width(a1)		;dx.
		move.w	(a4)+,gng_Height(a1)		;dy.
		move.l	(a4)+,a2
		move.l	#LISTVIEW_KIND,d0
		jsr	CreateGadgetA(a6)

		move.l	(a4)+,a5
		move.l	d0,(a5)
		beq.s	gadget_crt_err
		bra.w	gadget_crt_s

gadget_crt_sld:	move.w	(a4)+,gng_Width(a1)		;dx.
		move.w	(a4)+,gng_Height(a1)		;dy.
		move.l	(a4)+,a2
		lea	colours_dat,a5
		moveq.l	#0,d0
		move.w	gng_GadgetID(a1),d0
		move.b	(a5,d0.l),d0
		move.l	d0,4(a2)			;new level.
		move.l	#SLIDER_KIND,d0			;gadget type.
		jsr	CreateGadgetA(a6)

		move.l	(a4)+,a5
		move.l	d0,(a5)
		beq.s	gadget_crt_err
		bra.w	gadget_crt_s

gadget_crt_x:	moveq.l	#0,d0
		rts
gadget_crt_err:	moveq.l	#1,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		quit / exit
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

quit:		bsr.w	free_pens_list

		move.l	intuition_base,a6
		sub.l	a0,a0				;no name.
		move.l	pub_screen_lock,d0
		beq.s	no_pub_lock
		move.l	d0,a1
		jsr	UnlockPubScreen(a6)

no_pub_lock:	move.l	request_ptr_cfg,d0
		bsr.w	free_reqs
		move.l	request_ptr_prefs,d0
		bsr.w	free_reqs
		move.l	request_ptr_iff,d0
		bsr.w	free_reqs

		move.l	font_ptr,d0
		beq.s	no_font				;no font opened.
		move.l	d0,a1
		move.l	graphics_base,a6
		jsr	CloseFont(a6)			;close the font.

no_font:	move.l	menu_ptr,d0
		bsr.w	close_window

		move.l	context_g_menu,d0
		bsr.w	free_gadgets

		move.l	gad_tools_base,a6
		move.l	visual_info,d0
		beq.s	no_visual_info
		move.l	d0,a0
		jsr	FreeVisualInfo(a6)

no_visual_info:	move.l	message_port,d0
		beq.s	no_message_port
		move.l	d0,a1
		move.l	exec_base,a6
		jsr	RemPort(a6)

		move.l	message_port,a0
		jsr	DeleteMsgPort(a6)

no_message_port:lea	image_tmp_map_attr_1,a1
		bsr.w	free_bit_maps
		lea	image_tmp_map_attr_2,a1
		bsr.w	free_bit_maps

		lea	list_of_areas_ptr,a5
		bsr.w	free_vectors			;free the allocated memory.

		move.l	req_tools_base,d0
		bsr.b	free_libs
		move.l	gad_tools_base,d0
		bsr.b	free_libs
		move.l	graphics_base,d0
		bsr.b	free_libs
		move.l	dos_base,d0
		bsr.b	free_libs
		move.l	disk_font_base,d0
		bsr.b	free_libs

		movem.l	(SP)+,d2-d7/a2-a6		;unstack!
		moveq.l	#0,d0				;no errors.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		misc closes
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

free_vec:	move.l	a1,d0
		beq.s	free_vec_x
		move.l	exec_base,a6
		jsr	FreeVec(a6)			;free the area.
free_vec_x:	rts

free_reqs:	move.l	d0,a1
		beq.s	free_reqs_x
		move.l	req_tools_base,a6
		jsr	rtFreeRequest(a6)		;free the requester
free_reqs_x:	rts

free_libs:	move.l	d0,a1
		beq.s	free_libs_x
		move.l	exec_base,a6
		jsr	CloseLibrary(a6)
free_libs_x:	rts

close_window:	move.l	d0,a0
		beq.s	close_window_x
		move.l	intuition_base,a6
		jsr	CloseWindow(a6)
close_window_x:	rts

free_gadgets:	move.l	d0,a0
		beq.s	free_gadgets_x
		move.l	gad_tools_base,a6
		jsr	FreeGadgets(a6)		
free_gadgets_x:	rts


free_bit_maps:	tst.l	(a1)
		beq.s	no_bit_map
		move.l	(a1),a0
		clr.l	(a1)
		move.l	graphics_base,a6
		jsr	FreeBitMap(a6)
no_bit_map:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy rast port
;		INPUT:
;		a0	= source.
;		a1	= target.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

copy_rast_port:	move.w	#rp_SIZEOF-1,d0
copy_rast_port_data:
		move.b	(a0)+,(a1)+
		dbra	d0,copy_rast_port_data
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		free pens
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

free_pens_list:	lea	pen_list,a4
		move.l	(a4),pen_storage_list		;save the pens.
		move.l	4(a4),pen_storage_list+4		

		move.l	pub_screen_lock,d0
		beq.s	no_pens
		move.l	d0,a5
		lea	sc_ViewPort(a5),a5
		move.l	vp_ColorMap(a5),a5
		move.l	graphics_base,a6
		moveq.l	#8-1,d7
free_pens:	moveq.l	#0,d0
		move.b	(a4)+,d0
		move.l	a5,a0
		jsr	ReleasePen(a6)
		dbra	d7,free_pens
no_pens:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		init the colour box colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

copy_pens:	lea	colour_box_list,a0
		lea	pen_list,a1
		moveq.l	#8-1,d0
		moveq.l	#0,d1
		addq.l	#4*2,a0
copy_pen_box:	move.b	(a1)+,d1
		move.l	d1,(a0)+
		addq.l	#4*2,a0
		dbra	d0,copy_pen_box
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		obtain pens for the bitmaps and convert the static
;		images to use the obtained colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

obtain_pens_and_convert_gfx:
		move.l	graphics_base,a6
		move.l	pub_screen_lock,a5
		lea	sc_ViewPort(a5),a5
		move.l	vp_ColorMap(a5),a5
		lea	colours_dat,a4			;input (r.B, g.B, b.B).
		lea	pen_list,a3			;output (.B).
		moveq.l	#8-1,d7
obtain_pens:	move.l	a5,a0
		lea	obtain_pens_tag_list,a1
		moveq.l	#0,d1
		moveq.l	#0,d2
		moveq.l	#0,d3
		move.b	(a4)+,d1
		move.b	(a4)+,d2
		move.b	(a4)+,d3
		ror.l	#8,d1
		ror.l	#8,d2
		ror.l	#8,d3
		jsr	ObtainBestPenA(a6)
		move.b	d0,(a3)+
		dbra	d7,obtain_pens

		move.l	image_array_1,a0
		move.l	image_tmp_array_1,a1
		lea	pen_list,a2
		move.w	#(176*31)-1,d0
		moveq.l	#0,d1
convert_pens:	move.b	(a0)+,d1
		move.b	(a2,d1.l),(a1)+
		dbra	d0,convert_pens

		move.l	image_array_2,a0
		move.l	image_tmp_array_2,a1
		move.w	#(176*32)-1,d0
convert_pens_x:	move.b	(a0)+,d1
		move.b	(a2,d1.l),(a1)+
		dbra	d0,convert_pens_x
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		init still map
;		INPUT:
;		a0	= map attributes.
;		a1	= map.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

init_still_map:	move.l	#176,d1
		moveq.l	#31,d2
		moveq.l	#3,d0
		lea	bm_Planes(a0),a2
		move.l	d1,d3
		lsr.w	#3,d3
		mulu.w	d2,d3				;d3 = x/8*y.
		move.w	d0,d7
		subq.w	#1,d7
init_bit_map_xx:move.l	a1,(a2)+
		add.l	d3,a1
		dbra	d7,init_bit_map_xx
		jsr	InitBitMap(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		draw a set of colour boxes
;		a5	= colour box list.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

draw_colour_list:
		move.l	(a5)+,d0
		beq.s	draw_colour_end
		move.l	(a5)+,d1
		move.l	(a5)+,d7
		bsr.b	draw_colour_box
		bra.s	draw_colour_list
draw_colour_end:rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		draw a colour box
;		INPUT:
;		d0	= x.
;		d1	= y.
;		d7	= pen.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

draw_colour_box:move.l	gad_tools_base,a6
		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a0
		lea	bevel_box_tagz,a1
		move.l	visual_info,4(a1)
		moveq.l	#26,d2
		moveq.l	#13,d3
		movem.l	d0/d1,-(SP)
		jsr	DrawBevelBoxA(a6)

		move.l	graphics_base,a6
		move.l	d7,d0
		move.l	d7,d1
		move.l	#RP_JAM1,d2
		move.l	menu_ptr,a1
		move.l	wd_RPort(a1),a1
		jsr	SetABPenDrMd(a6)

		movem.l	(SP)+,d0/d1
		move.l	d0,d2
		move.l	d1,d3
		add.l	#21,d2
		add.l	#10,d3
		addq.l	#4,d0
		addq.l	#2,d1
		move.l	menu_ptr,a1
		move.l	wd_RPort(a1),a1
		jsr	RectFill(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		draw a set of bevel boxes
;		INPUT:
;		a5	= bevel box list.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

draw_bevel_list:move.w	(a5)+,d0			;x.
		beq.s	draw_bevel_end
		move.w	(a5)+,d1			;y.
		move.w	(a5)+,d2			;dx.
		move.w	(a5)+,d3			;dy.
		bsr.b	draw_bevel_box
		bra.s	draw_bevel_list
draw_bevel_end:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		draw a bevel box
;		INPUT:
;		d0	= x.
;		d1	= y.
;		d2	= dx.
;		d3	= dy.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

draw_bevel_box:	move.l	gad_tools_base,a6
		movem.l	d0-d3,-(SP)

		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a0
		lea	bevel_box_tags,a1
		move.l	visual_info,4(a1)
		jsr	DrawBevelBoxA(a6)

		movem.l	(SP)+,d0-d3
		movem.l	d0-d3,-(SP)

		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a0
		addq.l	#1,d0
		addq.l	#1,d1
		subq.l	#2,d2
		subq.l	#2,d3
		lea	bevel_box_tagz,a1
		move.l	visual_info,4(a1)
		jsr	DrawBevelBoxA(a6)

		move.l	graphics_base,a6
		movem.l	(SP)+,d0-d3

		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a1
		add.l	d0,d2
		add.l	d1,d3
		addq.l	#2,d0
		addq.l	#2,d1
		subq.l	#3,d2
		subq.l	#3,d3
		jsr	EraseRect(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		join the directory and name into a single expression
;		INPUT:
;		a0	= output.
;		a1	= name.
;		a2	= the requester pointer.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

parse_req_name:	move.l	rtfi_Dir(a2),a2

		moveq.l	#120,d0				;max letters.
		tst.b	(a2)				;current directory?
		beq.s	no_path_fix			;yes. skip this part.
copy_path:	move.b	(a2)+,d1
		beq.s	exit_path			;path is done.
		move.b	d1,(a0)+			;output path.
		dbra	d0,copy_path			;next letter.
;		bra.s	exit_path			;too many letters! quit!

exit_path:	cmp.b	#':',-1(a0)			;device?
		beq.s	no_path_fix			;yes. no need to fix the output.
		move.b	#'/',(a0)+			;fixed the directory name.

no_path_fix:	moveq.l	#120,d0				;max letters.
copy_name:	move.b	(a1)+,d1
		beq.s	exit_name			;name is done.
		move.b	d1,(a0)+			;output name.
		dbra	d0,copy_name			;next letter.
;		bra.s	exit_name			;too many letters! quit!

exit_name:	clr.b	(a0)				;end of file name.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		misc routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		include	"/routines/list_alloc_32bit.s"

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		section	murrr,data
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

intuition_name:	dc.b	"intuition.library",0
		even
dos_name:	dc.b	"dos.library",0
		even
graphics_name:	dc.b	"graphics.library",0
		even
disk_font_name:	dc.b	"diskfont.library",0
		even
		even
req_tools_name:	dc.b	"reqtools.library",0
		even
gad_tools_name:	dc.b	"gadtools.library",0
		even

cli_or_wb:	dc.b	0
obtain_status_counter:
		dc.b	4
		even

list_of_areas_ptr:
		dc.l	0

exec_base:	dc.l	0
intuition_base:	dc.l	0
graphics_base:	dc.l	0
dos_base:	dc.l	0
disk_font_base:	dc.l	0
req_tools_base:	dc.l	0
gad_tools_base:	dc.l	0

chunky_to_planar_hardware:
		dc.l	0

file_info_ptr:	dc.l	0
file_data_ptr:	dc.l	0

pub_screen_lock:dc.l	0
visual_info:	dc.l	0
screen_font_y:	dc.l	0
menu_window_y:	dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		font
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

font_ptr:	dc.l	0

font_attr:	dc.l	font_name
		dc.w	8				;y.
		dc.b	0				;style.
font_attr_flags:dc.b	32				;flags (32 = proportional).

font_name:	dc.b	"wzonka.font",0
		even
another_name:	dc.b	"zapot.font",0
		even
res_font_name:	dc.b	"topaz.font",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the req tools requester tag items and variables
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

rt_list:	dc.l	request_ptr_cfg
		dc.l	request_ptr_prefs
		dc.l	request_ptr_iff
		dc.l	0

request_ptr_cfg:dc.l	0				;cfg file requester.
request_ptr_prefs:
		dc.l	0				;prefs file requester.
request_ptr_iff:dc.l	0				;iff file requester.

cfg_name:	dc.l	0
cfg_name_and_dir:
		dc.l	0
prefs_name:	dc.l	0
prefs_name_and_dir:
		dc.l	0
iff_name:	dc.l	0
iff_name_and_dir:
		dc.l	0

req_tags:	dc.l	RT_Window,0
		dc.l	new_RTFI_Flags,FREQF_PATGAD
		dc.l	TAG_END,0

req_change_tags:dc.l	xRTFI_Dir,0
		dc.l	TAG_END,0

cfg_save_txt:	dc.b	"Save .cfg file",0
		even
cfg_load_txt:	dc.b	"Select .cfg file",0
		even
prefs_load_and_save_txt:
		dc.b	"Select .prefs file",0
		even
iff_load_txt:	dc.b	"Select .iff file",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the memory allocation list
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

list_of_areas:	dc.l	back_pattern_map_attr,bm_SIZEOF,MEMF_PUBLIC
		dc.l	back_pattern_map,menu_x/8*menu_y*2,MEMF_CHIP

		dc.l	univ_gadget,gng_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	file_info_ptr,fib_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	colour_message,MN_SIZE+8*3,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	colour_message_name,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	file_info_ptr,fib_SIZEOF,MEMF_PUBLIC

		dc.l	cfg_name,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	cfg_name_and_dir,256*2,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	prefs_name,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	prefs_name_and_dir,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	iff_name,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	iff_name_and_dir,256*2,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	image_array_1,176*32,MEMF_PUBLIC
		dc.l	image_array_2,176*32,MEMF_PUBLIC
		dc.l	image_tmp_array_1,176*32,MEMF_PUBLIC
		dc.l	image_tmp_array_2,176*32,MEMF_PUBLIC
		dc.l	image_rast_port_1,rp_SIZEOF,MEMF_PUBLIC
		dc.l	image_rast_port_2,rp_SIZEOF,MEMF_PUBLIC
		dc.l	image_tmp_rast_port_1,rp_SIZEOF,MEMF_PUBLIC
		dc.l	image_tmp_rast_port_2,rp_SIZEOF,MEMF_PUBLIC
		dc.l	image_map_attr_1,bm_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	image_map_attr_2,bm_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		universal window tags
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

win_tags_u:	dc.l	WA_NewLookMenus,TRUE
		dc.l	TAG_END,0			;3d look, here too.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_ptr:	dc.l	0

menu_window:	dc.w	0
		dc.w	11
		dc.w	menu_x
		dc.w	menu_y
		dc.b	0
		dc.b	1
		dc.l	menu_idcmp
		dc.l	menu_flags
		dc.l	0
		dc.l	0
		dc.l	menu_title
		dc.l	0
		dc.l	0
		dc.w	0
		dc.w	0
		dc.w	menu_x
		dc.w	menu_y
		dc.w	WBENCHSCREEN

menu_title:	dc.b	"Wzonka-Lad Palette Editor 1.10 (68020) © Ville Helin 1997-99",0
		even

univ_gadget:	dc.l	0

menu_b_1:	dc.l	0
menu_b_2:	dc.l	0
menu_b_3:	dc.l	0
menu_b_4:	dc.l	0
menu_b_5:	dc.l	0
menu_b_interpolate_background:
		dc.l	0
menu_b_interpolate_sprites:
		dc.l	0
menu_b_iff_load:dc.l	0

menu_b_copy_left_1:
		dc.l	0
menu_b_copy_left_2:
		dc.l	0
menu_b_copy_left_3:
		dc.l	0
menu_b_copy_left_4:
		dc.l	0
menu_b_copy_right_1:
		dc.l	0
menu_b_copy_right_2:
		dc.l	0
menu_b_copy_right_3:
		dc.l	0
menu_b_copy_right_4:
		dc.l	0

colour_1_r:	dc.l	0
colour_1_g:	dc.l	0
colour_1_b:	dc.l	0
colour_2_r:	dc.l	0
colour_2_g:	dc.l	0
colour_2_b:	dc.l	0
colour_3_r:	dc.l	0
colour_3_g:	dc.l	0
colour_3_b:	dc.l	0
colour_4_r:	dc.l	0
colour_4_g:	dc.l	0
colour_4_b:	dc.l	0
colour_5_r:	dc.l	0
colour_5_g:	dc.l	0
colour_5_b:	dc.l	0
colour_6_r:	dc.l	0
colour_6_g:	dc.l	0
colour_6_b:	dc.l	0
colour_7_r:	dc.l	0
colour_7_g:	dc.l	0
colour_7_b:	dc.l	0
colour_8_r:	dc.l	0
colour_8_g:	dc.l	0
colour_8_b:	dc.l	0

menu_load:	dc.b	"Load",0
		even
menu_save:	dc.b	"Save",0
		even
menu_obtain:	dc.b	"Obtain",0
		even
menu_interpolate:
		dc.b	"Interpolate",0
		even

colour_r:	dc.b	"R",0
		even
colour_g:	dc.b	"G",0
		even
colour_b:	dc.b	"B",0
		even

menu_copy_left:	dc.b	"<",0
		even
menu_copy_right:dc.b	">",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		context gadgets
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

context_g_menu:	dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu gadgets
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_scr_txt:	dc.b	"Wzonka-Lad Palette Editor 1.10",0
		even

menu_gadgets:	dc.w	180,50-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_r
		dc.w	0
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_1_r

		dc.w	180,50+9-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_g
		dc.w	1
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_1_g

		dc.w	180,50+9*2-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_b
		dc.w	2
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_1_b

		dc.w	180,50+35-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_r
		dc.w	3
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_2_r

		dc.w	180,50+9+35-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_g
		dc.w	4
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_2_g

		dc.w	180,50+9*2+35-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_b
		dc.w	5
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_2_b

		dc.w	180,50+35*2-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_r
		dc.w	6
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_3_r

		dc.w	180,50+9+35*2-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_g
		dc.w	7
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_3_g

		dc.w	180,50+9*2+35*2-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_b
		dc.w	8
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_3_b

		dc.w	180,50+35*3-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_r
		dc.w	9
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_4_r

		dc.w	180,50+9+35*3-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_g
		dc.w	10
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_4_g

		dc.w	180,50+9*2+35*3-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_b
		dc.w	11
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_4_b

		dc.w	410,50-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_r
		dc.w	12
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_5_r

		dc.w	410,50+9-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_g
		dc.w	13
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_5_g

		dc.w	410,50+9*2-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_b
		dc.w	14
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_5_b

		dc.w	410,50+35-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_r
		dc.w	15
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_6_r

		dc.w	410,50+9+35-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_g
		dc.w	16
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_6_g

		dc.w	410,50+9*2+35-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_b
		dc.w	17
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_6_b

		dc.w	410,50+35*2-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_r
		dc.w	18
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_7_r

		dc.w	410,50+9+35*2-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_g
		dc.w	19
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_7_g

		dc.w	410,50+9*2+35*2-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_b
		dc.w	20
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_7_b

		dc.w	410,50+35*3-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_r
		dc.w	21
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_8_r

		dc.w	410,50+9+35*3-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_g
		dc.w	22
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_8_g

		dc.w	410,50+9*2+35*3-font_y_sub
		dc.l	PLACETEXT_LEFT
		dc.l	colour_b
		dc.w	23
		dc.w	4				;slider_kind!
		dc.w	100,8
		dc.l	slider_h_tags
		dc.l	colour_8_b

		dc.w	30+gadgets_x,40+gadgets_y-font_y_sub+iff_y
		dc.l	PLACETEXT_IN
		dc.l	menu_load
		dc.w	24
		dc.w	0				;button_kind!
		dc.w	60,14
		dc.l	menu_b_1

		dc.w	30+gadgets_x,40+15+gadgets_y-font_y_sub+iff_y
		dc.l	PLACETEXT_IN
		dc.l	menu_save
		dc.w	25
		dc.w	0				;button_kind!
		dc.w	60,14
		dc.l	menu_b_2

		dc.w	30+gadgets_x,89+gadgets_y-font_y_sub+iff_y
		dc.l	PLACETEXT_IN
		dc.l	menu_load
		dc.w	26
		dc.w	0				;button_kind!
		dc.w	60,14
		dc.l	menu_b_3

		dc.w	30+gadgets_x,89+15+gadgets_y-font_y_sub+iff_y
		dc.l	PLACETEXT_IN
		dc.l	menu_save
		dc.w	27
		dc.w	0				;button_kind!
		dc.w	60,14
		dc.l	menu_b_4

		dc.w	30+gadgets_x,138+gadgets_y-font_y_sub+iff_y
		dc.l	PLACETEXT_IN
		dc.l	menu_obtain
		dc.w	28
		dc.w	0				;button_kind!
		dc.w	60,14
		dc.l	menu_b_5

		dc.w	405,26-font_y_sub
		dc.l	PLACETEXT_IN
		dc.l	menu_interpolate
		dc.w	29
		dc.w	0				;button_kind!
		dc.w	110,14
		dc.l	menu_b_interpolate_sprites

		dc.w	175,26-font_y_sub
		dc.l	PLACETEXT_IN
		dc.l	menu_interpolate
		dc.w	30
		dc.w	0				;button_kind!
		dc.w	110,14
		dc.l	menu_b_interpolate_background

		dc.w	321,57-font_y_sub
		dc.l	PLACETEXT_IN
		dc.l	menu_copy_left
		dc.w	31
		dc.w	0				;button_kind!
		dc.w	14,11
		dc.l	menu_b_copy_left_1

		dc.w	335,57-font_y_sub
		dc.l	PLACETEXT_IN
		dc.l	menu_copy_right
		dc.w	32
		dc.w	0				;button_kind!
		dc.w	14,11
		dc.l	menu_b_copy_right_1

		dc.w	321,57+35-font_y_sub
		dc.l	PLACETEXT_IN
		dc.l	menu_copy_left
		dc.w	33
		dc.w	0				;button_kind!
		dc.w	14,11
		dc.l	menu_b_copy_left_2

		dc.w	335,57+35-font_y_sub
		dc.l	PLACETEXT_IN
		dc.l	menu_copy_right
		dc.w	34
		dc.w	0				;button_kind!
		dc.w	14,11
		dc.l	menu_b_copy_right_2

		dc.w	321,57+35*2-font_y_sub
		dc.l	PLACETEXT_IN
		dc.l	menu_copy_left
		dc.w	35
		dc.w	0				;button_kind!
		dc.w	14,11
		dc.l	menu_b_copy_left_3

		dc.w	335,57+35*2-font_y_sub
		dc.l	PLACETEXT_IN
		dc.l	menu_copy_right
		dc.w	36
		dc.w	0				;button_kind!
		dc.w	14,11
		dc.l	menu_b_copy_right_3

		dc.w	321,57+35*3-font_y_sub
		dc.l	PLACETEXT_IN
		dc.l	menu_copy_left
		dc.w	37
		dc.w	0				;button_kind!
		dc.w	14,11
		dc.l	menu_b_copy_left_4

		dc.w	335,57+35*3-font_y_sub
		dc.l	PLACETEXT_IN
		dc.l	menu_copy_right
		dc.w	38
		dc.w	0				;button_kind!
		dc.w	14,11
		dc.l	menu_b_copy_right_4

		dc.w	30+gadgets_x,6+gadgets_y-font_y_sub+iff_y
		dc.l	PLACETEXT_IN
		dc.l	menu_load
		dc.w	39
		dc.w	0				;button_kind!
		dc.w	60,14
		dc.l	menu_b_iff_load

		dc.l	0				;end of the list.

slider_h_tags:	dc.l	GTSL_Level,0
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,255
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	GTSL_Justification,GTJ_LEFT
		dc.l	GTSL_MaxLevelLen,3
		dc.l	GTSL_LevelFormat,level_format
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_END,0

level_format:	dc.b	"%ld",0
		even

menu_item_text_1:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	30+gadgets_x+10
		dc.w	40+gadgets_y-13-font_y_sub+iff_y
		dc.l	font_attr
		dc.l	menu_item_txt_1
		dc.l	menu_item_text_2

menu_item_text_2:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	30+gadgets_x+18
		dc.w	89+gadgets_y-13-font_y_sub+iff_y
		dc.l	font_attr
		dc.l	menu_item_txt_2
		dc.l	menu_item_text_3

menu_item_text_3:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	30+gadgets_x-4
		dc.w	138+gadgets_y-13-font_y_sub+iff_y
		dc.l	font_attr
		dc.l	menu_item_txt_3
		dc.l	menu_item_text_4

menu_item_text_4:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	160
		dc.w	21-8-font_y_sub
		dc.l	font_attr
		dc.l	menu_item_txt_4
		dc.l	menu_item_text_5

menu_item_text_5:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	410
		dc.w	21-8-font_y_sub
		dc.l	font_attr
		dc.l	menu_item_txt_5
		dc.l	menu_item_text_6

menu_item_text_6:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	230
		dc.w	50-8-font_y_sub
		dc.l	font_attr
		dc.l	menu_colour_1
		dc.l	menu_item_text_7

menu_item_text_7:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	230
		dc.w	50+35-8-font_y_sub
		dc.l	font_attr
		dc.l	menu_colour_2
		dc.l	menu_item_text_8

menu_item_text_8:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	230
		dc.w	50+35*2-8-font_y_sub
		dc.l	font_attr
		dc.l	menu_colour_3
		dc.l	menu_item_text_9

menu_item_text_9:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	230
		dc.w	50+35*3-8-font_y_sub
		dc.l	font_attr
		dc.l	menu_colour_4
		dc.l	menu_item_text_10

menu_item_text_10:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	460
		dc.w	50-8-font_y_sub
		dc.l	font_attr
		dc.l	menu_colour_1
		dc.l	menu_item_text_11

menu_item_text_11:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	460
		dc.w	50+35-8-font_y_sub
		dc.l	font_attr
		dc.l	menu_colour_2
		dc.l	menu_item_text_12

menu_item_text_12:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	460
		dc.w	50+35*2-8-font_y_sub
		dc.l	font_attr
		dc.l	menu_colour_3
		dc.l	menu_item_text_13

menu_item_text_13:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	460
		dc.w	50+35*3-8-font_y_sub
		dc.l	font_attr
		dc.l	menu_colour_4
		dc.l	menu_item_text_14

menu_item_text_14:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	52
		dc.w	38-font_y_sub
		dc.l	font_attr
		dc.l	menu_item_txt_6
		dc.l	0

menu_item_txt_1:dc.b	".prefs",0
		even
menu_item_txt_2:dc.b	".cfg",0
		even
menu_item_txt_3:dc.b	"Wzonka-Lad",0
		even
menu_item_txt_4:dc.b	"Background colours",0
		even
menu_item_txt_5:dc.b	"Sprite colours",0
		even
menu_item_txt_6:dc.b	".iff",0
		even

menu_colour_1:	dc.b	"1",0
		even
menu_colour_2:	dc.b	"2",0
		even
menu_colour_3:	dc.b	"3",0
		even
menu_colour_4:	dc.b	"4",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		bitmaps
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

back_pattern_map_attr:
		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the version string
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

version_data:	dc.b	"$VER: Wzonka-Lad Palette Editor 1.10 (25.05.99)",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		bevel box lists
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_bevel_list:dc.w	22+gadgets_x,35+iff_y+gadgets_y-font_y_sub,76,39
		dc.w	22+gadgets_x,84+iff_y+gadgets_y-font_y_sub,76,39
		dc.w	22+gadgets_x,133+iff_y+gadgets_y-font_y_sub,76,24
		dc.w	22+gadgets_x,21+gadgets_y-font_y_sub,76,24

		dc.w	120,21-font_y_sub,200,200
		dc.w	350,21-font_y_sub,200,200
		dc.w	0

bevel_box_tags:	dc.l	GT_VisualInfo,0
		dc.l	GTBB_Recessed,TRUE
		dc.l	GTBB_FrameType,BBFT_BUTTON
		dc.l	TAG_END,0

bevel_box_tagz:	dc.l	GT_VisualInfo,0
		dc.l	GTBB_FrameType,BBFT_BUTTON
		dc.l	TAG_END,0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		window graphics
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

back_pattern_bn:incbin	"windows/pattern.bn"
		even

back_pattern_map:
		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		message port
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

message_port:	dc.l	0
message_port_name:
		dc.b	"Wzonka-Lad Palette Editor Port",0
		even

message_port_wzonka_lad:
		dc.l	0
message_port_wzonka_lad_name:
		dc.b	"Wzonka-Lad Port",0
		even

obtain_gadget_status:
		dc.l	0				;0 = on / 1 = off.
colour_message:	dc.l	0
colour_message_name:
		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		read pixel array
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

image_array_1:	dc.l	0
image_array_2:	dc.l	0
image_map_attr_1:
		dc.l	0
image_map_attr_2:
		dc.l	0
image_rast_port_1:
		dc.l	0
image_rast_port_2:
		dc.l	0

image_tmp_array_1:
		dc.l	0
image_tmp_array_2:
		dc.l	0
image_tmp_map_attr_1:
		dc.l	0
image_tmp_rast_port_1:
		dc.l	0
image_tmp_map_attr_2:
		dc.l	0
image_tmp_rast_port_2:
		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		obtain pens
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

obtain_pens_tag_list:
		dc.l	OBP_Precision,PRECISION_IMAGE
		dc.l	OBP_FailIfBad,FALSE
		dc.l	TAG_END,0
gameboy_colours:incbin	"data/gameboy_colours.pal"
		even
pen_list:	ds.b	8
pen_storage_list:
		ds.b	8

conversion_occurred:
		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

colours_dat:	ds.b	8*3
		even

get_gadget_attrs_tag_list:
		dc.l	GTSL_Level,get_gadget_attrs_tag_return
		dc.l	TAG_END,0

get_gadget_attrs_tag_return:
		dc.l	0

set_gadget_attrs_tag_list:
		dc.l	GTSL_Level,0
		dc.l	TAG_END,0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		list of colour boxes
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

colour_box_list:dc.l	130,56-font_y_sub,0
		dc.l	130,56-font_y_sub+35*1,1
		dc.l	130,56-font_y_sub+35*2,2
		dc.l	130,56-font_y_sub+35*3,3
		dc.l	360,56-font_y_sub,4
		dc.l	360,56-font_y_sub+35*1,5
		dc.l	360,56-font_y_sub+35*2,6
		dc.l	360,56-font_y_sub+35*3,7
		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		input / output .cfg file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

cfg_colour_id_list_position:
		dc.l	0,3,6,9
		dc.l	0,3,6,9

		dc.l	0,3,6,9
		dc.l	0,3,6,9
		dc.l	0,3,6,9

		dc.l	12,15,18,21
		dc.l	12,15,18,21

cfg_colour_id_list_long_names:
		dc.l	cfg_wc_0
		dc.l	cfg_wc_1
		dc.l	cfg_wc_2
		dc.l	cfg_wc_3

		dc.l	cfg_windowcolor_0
		dc.l	cfg_windowcolor_1
		dc.l	cfg_windowcolor_2
		dc.l	cfg_windowcolor_3

		dc.l	cfg_c_0
		dc.l	cfg_c_1
		dc.l	cfg_c_2
		dc.l	cfg_c_3

		dc.l	cfg_bc_0
		dc.l	cfg_bc_1
		dc.l	cfg_bc_2
		dc.l	cfg_bc_3

		dc.l	cfg_backgroundcolor_0
		dc.l	cfg_backgroundcolor_1
		dc.l	cfg_backgroundcolor_2
		dc.l	cfg_backgroundcolor_3

		dc.l	cfg_sc_0
		dc.l	cfg_sc_1
		dc.l	cfg_sc_2
		dc.l	cfg_sc_3

		dc.l	cfg_spritecolor_0
		dc.l	cfg_spritecolor_1
		dc.l	cfg_spritecolor_2
		dc.l	cfg_spritecolor_3

cfg_c_0:	dc.b	"-c0",0
		even
cfg_c_1:	dc.b	"-c1",0
		even
cfg_c_2:	dc.b	"-c2",0
		even
cfg_c_3:	dc.b	"-c3",0
		even

cfg_wc_0:	dc.b	"-wc0",0
		even
cfg_wc_1:	dc.b	"-wc1",0
		even
cfg_wc_2:	dc.b	"-wc2",0
		even
cfg_wc_3:	dc.b	"-wc3",0
		even

cfg_bc_0:	dc.b	"-bc0",0
		even
cfg_bc_1:	dc.b	"-bc1",0
		even
cfg_bc_2:	dc.b	"-bc2",0
		even
cfg_bc_3:	dc.b	"-bc3",0
		even

cfg_sc_0:	dc.b	"-sc0",0
		even
cfg_sc_1:	dc.b	"-sc1",0
		even
cfg_sc_2:	dc.b	"-sc2",0
		even
cfg_sc_3:	dc.b	"-sc3",0
		even

cfg_windowcolor_0:
		dc.b	"-windowcolor0",0
		even
cfg_windowcolor_1:
		dc.b	"-windowcolor1",0
		even
cfg_windowcolor_2:
		dc.b	"-windowcolor2",0
		even
cfg_windowcolor_3:
		dc.b	"-windowcolor3",0
		even

cfg_backgroundcolor_0:
		dc.b	"-backgroundcolor0",0
		even
cfg_backgroundcolor_1:
		dc.b	"-backgroundcolor1",0
		even
cfg_backgroundcolor_2:
		dc.b	"-backgroundcolor2",0
		even
cfg_backgroundcolor_3:
		dc.b	"-backgroundcolor3",0
		even

cfg_spritecolor_0:
		dc.b	"-spritecolor0",0
		even
cfg_spritecolor_1:
		dc.b	"-spritecolor1",0
		even
cfg_spritecolor_2:
		dc.b	"-spritecolor2",0
		even
cfg_spritecolor_3:
		dc.b	"-spritecolor3",0
		even

cfg_colours_output:
		dc.l	cfg_save_win_0
		dc.l	cfg_save_win_1
		dc.l	cfg_save_win_2
		dc.l	cfg_save_win_3

		dc.l	cfg_save_bg_0
		dc.l	cfg_save_bg_1
		dc.l	cfg_save_bg_2
		dc.l	cfg_save_bg_3

		dc.l	cfg_save_spr_0
		dc.l	cfg_save_spr_1
		dc.l	cfg_save_spr_2
		dc.l	cfg_save_spr_3

cfg_save_file:
		dc.b	"-sc0 #"
cfg_save_spr_0:	ds.b	6
		dc.b	$A
		dc.b	"-sc1 #"
cfg_save_spr_1:	ds.b	6
		dc.b	$A
		dc.b	"-sc2 #"
cfg_save_spr_2:	ds.b	6
		dc.b	$A
		dc.b	"-sc3 #"
cfg_save_spr_3:	ds.b	6
		dc.b	$A
		dc.b	"-wc0 #"
cfg_save_win_0:	ds.b	6
		dc.b	$A
		dc.b	"-wc1 #"
cfg_save_win_1:	ds.b	6
		dc.b	$A
		dc.b	"-wc2 #"
cfg_save_win_2:	ds.b	6
		dc.b	$A
		dc.b	"-wc3 #"
cfg_save_win_3:	ds.b	6
		dc.b	$A
		dc.b	"-bc0 #"
cfg_save_bg_0:	ds.b	6
		dc.b	$A
		dc.b	"-bc1 #"
cfg_save_bg_1:	ds.b	6
		dc.b	$A
		dc.b	"-bc2 #"
cfg_save_bg_2:	ds.b	6
		dc.b	$A
		dc.b	"-bc3 #"
cfg_save_bg_3:	ds.b	6
		dc.b	$A
cfg_save_file_end:
		even

vgb_colours:	dc.l	vgb_c1
		dc.l	vgb_c2
		dc.l	vgb_c3
		dc.l	vgb_c4
		dc.l	vgb_c5
		dc.l	vgb_c6
		dc.l	vgb_c7
		dc.l	vgb_c8
		dc.l	vgb_c9
		dc.l	vgb_c10
		dc.l	vgb_c11
		dc.l	vgb_c12
		dc.l	vgb_c13
		dc.l	vgb_c14
		dc.l	vgb_c15
		dc.l	vgb_c16
		dc.l	vgb_c17
		dc.l	vgb_c18
		dc.l	vgb_c19
		dc.l	0

vgb_colours_h:	dc.b	255,255,0
		dc.b	0,255,0
		dc.b	165,82,0
		dc.b	0,0,0
		dc.b	85,255,255
		dc.b	255,0,0
		dc.b	255,255,255
		dc.b	255,165,165
		dc.b	0,0,255
		dc.b	0,165,165
		dc.b	255,115,8
		dc.b	255,82,255
		dc.b	165,0,165
		dc.b	0,165,165
		dc.b	0,165,0
		dc.b	165,0,0
		dc.b	0,0,165
		dc.b	165,165,165
		dc.b	82,82,82

vgb_c1:		dc.b	"yellow",0
		even
vgb_c2:		dc.b	"green",0
		even
vgb_c3:		dc.b	"brown",0
		even
vgb_c4:		dc.b	"black",0
		even
vgb_c5:		dc.b	"cyan",0
		even
vgb_c6:		dc.b	"red",0
		even
vgb_c7:		dc.b	"white",0
		even
vgb_c8:		dc.b	"pink",0
		even
vgb_c9:		dc.b	"blue",0
		even
vgb_c10:	dc.b	"dkcyan",0
		even
vgb_c11:	dc.b	"orange",0
		even
vgb_c12:	dc.b	"magenta",0
		even
vgb_c13:	dc.b	"dkmagenta",0
		even
vgb_c14:	dc.b	"dkcyan",0
		even
vgb_c15:	dc.b	"dkgreen",0
		even
vgb_c16:	dc.b	"dkred",0
		even
vgb_c17:	dc.b	"dkblue",0
		even
vgb_c18:	dc.b	"gray",0
		even
vgb_c19:	dc.b	"dkgray",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		load .prefs path from here
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

prefs_file_name:dc.b	"ENVARC:Wzonka-Lad.prefs",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
		section	displayable_images,data_c
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
image_map_1:	incbin	"data/palette_editor_still_1.bn"
		cnop	0,4
image_map_2:	incbin	"data/palette_editor_still_2.bn"
		cnop	0,4

		END
