
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		wzonka-lad the emulator
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		incdir	"binworld:includes/"
		include	"exec/memory.i"
		include	"intuition/intuition.i"
		include	"graphics/videocontrol.i"
		include	"graphics/gfx.i"
		include	"graphics/gfxbase.i"
		include	"dos/dos.i"
		include	"libraries/reqtools.i"
		include	"intuition/intuition.i"
		include	"diskfont/diskfont.i"
		include	"graphics/gfx.i"
		include	"custom/exec_lib.i"
		;include	"lowlevel.i"
		include	"dos/dos_lib.i"
		include	"libraries/reqtools_lib.i"
		include	"lvo/xpkmaster_lib.i"
		include	"xpk/xpk.i"
		include	"custom/custom.i"
		;include	"controlpad.i"
		include	"libraries/gadtools.i"
		include	"graphics/displayinfo.i"

		include	"cybergraphics/cybergraphics.i"
		include	"cybergraphics/cybergraphics_lib.i"

		include	"devices/inputevent.i"
		include	"devices/keyboard.i"
		include	"devices/serial.i"
		include	"libraries/gadtools.i"
		include	"exec/io.i"

		include	"ahi/ahi_lib.i"
		include	"ahi/ahi.i"

		include	"binworld:Wzonka-Lad/Sources/short_lvo.i"
		include	"binworld:Wzonka-Lad/Sources/screens.i"
		include	"binworld:Wzonka-Lad/Sources/iconstartup.i"
		include	"binworld:Wzonka-Lad/Sources/z80_mode.i"

GFX_PROFILE=0
		IFND	AGA_FULL_REGISTER_MERGE
AGA_FULL_REGISTER_MERGE =1		;1 = register merge, 0 = memory baseline for profiling.
		ENDC
GAMEBOY_DEBUG		=0				;0 = n / 1 = y.
GAMEBOY_SERIAL		=0				;0 = n / 1 = y.
GAMEBOY_USERS		=0				;0 = r / 1 = e.
GAMEBOY_OAM_BUG		=0				;0 = n / 1 = y.
		include	"gfx_profile.i"

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
		IFEQ	GAMEBOY_USERS
key_name_decode	=0
key_sounds_init	=4
key_serial_area =8
		ENDIF
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

;PGA_Dummy		=(TAG_USER+$31000)
;PGA_Freedom		=(PGA_Dummy+$0001)

;STRINGA_Dummy		=(TAG_USER+$32000)
;STRINGA_Justification	=(STRINGA_Dummy+$0010)
;STRINGA_ReplaceMode	=(STRINGA_Dummy+$000D)

;GA_Dummy                =(TAG_USER+$30000)
;GA_Disabled             =(GA_Dummy+$000E)
;GA_TabCycle		=(GA_Dummy+$0024)

;LORIENT_HORIZ		=1
;LORIENT_VERT		=2

JPB_BUTTON_BLUE		=23				;blue.
JPB_BUTTON_RED		=22				;red.
JPB_BUTTON_YELLOW	=21				;yellow.
JPB_BUTTON_GREEN	=20				;green.
JPB_JOY_UP		=3				;up.
JPB_JOY_DOWN		=2				;down.
JPB_JOY_LEFT		=1				;left.
JPB_JOY_RIGHT		=0				;right.
JPB_BUTTON_PLAY		=17				;pause.
JPB_BUTTON_REVERSE	=18
JPB_BUTTON_FORWARD	=19

TRUE			=1
FALSE			=0

INPUT_OK		=0
INPUT_GBS_LOAD		=1
INPUT_GBS_SAVE		=2
INPUT_HALT		=3

WriteChunkyPixels	=-1056

Q			=%1000000000000			;dpf colours.
sprite_memory		=3*1024				;amount of ram / sprite.

menu_x			=304
menu_y			=104+5

function_x		=384
function_y		=194
function_x_bm		=384
function_y_bm		=193
gb_screen_x		=192
gb_screen_y		=176
register_x		=320
register_y		=160
window_right_bar_x	=14
window_max_game_x	=160*9
window_max_game_y	=144*9
window_resize_idcmp	=IDCMP_NEWSIZE!IDCMP_CHANGEWINDOW!IDCMP_RAWKEY

function_idcmp		=IDCMP_GADGETUP!IDCMP_GADGETDOWN!IDCMP_MOUSEMOVE!IDCMP_MOUSEBUTTONS!IDCMP_CLOSEWINDOW
function_flags		=WFLG_DEPTHGADGET!WFLG_DRAGBAR!WFLG_GIMMEZEROZERO!WFLG_SMART_REFRESH!WFLG_CLOSEGADGET
menu_idcmp		=IDCMP_GADGETUP!IDCMP_GADGETDOWN!IDCMP_MENUPICK!IDCMP_CLOSEWINDOW!IDCMP_VANILLAKEY
menu_flags		=WFLG_CLOSEGADGET!WFLG_DEPTHGADGET!WFLG_DRAGBAR!WFLG_ACTIVATE!WFLG_SMART_REFRESH!WFLG_GIMMEZEROZERO
wzonka_idcmp		=0
wzonka_flags		=WFLG_DEPTHGADGET!WFLG_DRAGBAR!WFLG_SMART_REFRESH!WFLG_GIMMEZEROZERO
register_flags		=WFLG_ACTIVATE!WFLG_SMART_REFRESH!WFLG_GIMMEZEROZERO

tput_d0_to_a1:	MACRO

		and.w	#$ff,d0
		move.w	d0,d1
		lsr.b	#4,d0
		cmp.w	#$A,d0
		blt.s	atoo_0\@
		add.b	#'A'-$a,d0
		bra.s	ajoo_0\@
atoo_0\@:	add.b	#48,d0
ajoo_0\@:	move.b	d0,(a1)+

		and.b	#%1111,d1
		cmp.w	#$A,d1
		blt.s	atoo_1\@
		add.b	#'A'-$a,d1
		bra.s	ajoo_1\@
atoo_1\@:	add.b	#48,d1
ajoo_1\@:	move.b	d1,(a1)+

		ENDM

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		start
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gb_emu:		movem.l	d2-d7/a2-a6,-(SP)
		move.l	execbase,exec_base
		move.l	a0,cli_load

		move.l	exec_base,a6
		lea	disk_font_name,a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		move.l	d0,disk_font_base
		beq.w	missing_diskfont

		lea	dos_name,a1
		moveq.l	#39,d0
		jsr	OpenLibrary(a6)
		move.l	d0,dos_base
		beq.w	missing_dos

		lea	graphics_name,a1
		moveq.l	#39,d0
		jsr	OpenLibrary(a6)
		move.l	d0,graphics_base
		beq.w	missing_graphics

		lea	intuition_name,a1
		moveq.l	#39,d0
		jsr	OpenLibrary(a6)
		move.l	d0,intuition_base
		beq.w	missing_intuition

		lea	req_tools_name,a1
		moveq.l	#38,d0
		jsr	OpenLibrary(a6)
		move.l	d0,req_tools_base
		beq.w	missing_reqtools

		lea	gad_tools_name,a1
		moveq.l	#38,d0
		jsr	OpenLibrary(a6)
		move.l	d0,gad_tools_base
		beq.w	missing_gadtools

		IFEQ	GAMEBOY_USERS

		lea	low_level_name,a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		move.l	d0,low_level_base

		lea	control_pad_name,a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		move.l	d0,control_pad_base

		ENDIF

		lea	xpk_master_name,a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		move.l	d0,xpk_master_base

		lea	cyber_name,a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		move.l	d0,cyber_base

		IFGT	GAMEBOY_SERIAL

		bsr.w	serial_allocate
		tst.l	d0
		bne.w	quit

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		debug init
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFGT	GAMEBOY_DEBUG

		move.l	dos_base,a6
		move.l	#debug_consol_name,d1
		move.l	#Mode_New,d2
		jsr	Open(a6)
		move.l	d0,debug_con_handle

		move.l	#debug_message,d2
		move.l	#debug_message_end-debug_message,d3
		move.l	dos_base,a6
		move.l	debug_con_handle,d1
		jsr	Write(a6)

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		init the wzonka game window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	wzonka_window,a0
		move.l	#wzonka_idcmp,nw_IDCMPFlags(a0)
		move.l	#wzonka_flags,nw_Flags(a0)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate the initial memory areas
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	list_default_structure,a4	;the memory list.
		lea	list_default,a5
		bsr.w	allocate_list			;allocate memory.
		tst.l	d0				;errors?
		beq.w	quit				;yes! quit!

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get aga status
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	graphics_base,a6
		move.b	$ec(a6),d0
		and.b	#%100,d0
		lsr.b	#2,d0
		move.b	d0,aga_status			;0 = no aga / 1 = aga.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		lock the pubscreen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	intuition_base,a6
		sub.l	a0,a0				;default pub screen.
		jsr	LockPubScreen(a6)
		move.l	d0,pub_screen_lock
		beq.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get visual infos and fix window sizes
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

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

		lea	menu_window,a0
		addq.l	#3,d0
		move.w	d0,nw_TopEdge(a0)
		move.l	d0,d1
		move.l	d0,d2
		add.l	#menu_y,d1
		move.w	d1,nw_Height(a0)
		move.w	d1,nw_MaxHeight(a0)
		lea	function_window,a0
		lsl.l	#1,d0
		move.w	d0,nw_TopEdge(a0)
		add.l	#function_y,d2
		move.w	d2,nw_Height(a0)
		move.w	d2,nw_MaxHeight(a0)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		obtain crucial window dimensions
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	wzonka_window,a1

		move.l	screen_font_y,d1
		addq.l	#3+2,d1
		move.l	d1,window_bars_height
		move.w	d1,d2
		add.w	#window_max_game_y,d2
		move.w	d2,nw_MaxHeight(a1)
		add.l	#144,d1
		move.w	d1,nw_MinHeight(a1)
		move.w	d1,wzonka_window_y

		moveq.l	#8,d1
		move.l	d1,window_bars_width
		move.w	d1,d2
		add.w	#window_max_game_x+window_right_bar_x,d2
		move.w	d2,nw_MaxWidth(a1)
		add.l	#160+window_right_bar_x,d1
		move.w	d1,wzonka_window_x
		move.w	d1,nw_MinWidth(a1)

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
		move.w	#MN_SIZE,MN_LENGTH(a0)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		key file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS

		bsr.w	load_key

		tst.b	key_status
		beq.w	missing_key			;no key!!!

		move.l	exec_base,a6
		jsr	CacheClearU(a6)			;clear the cache first.

		lea	about_txt_2,a1
		move.l	#"REGI",(a1)+
		move.l	#"STER",(a1)+
		move.l	#"ED T",(a1)+
		move.w	#"O ",(a1)+			;a1 = output.

		move.l	key_file,a0
		lea	reg_to_obsolete,a2		;coordinates output.
		add.l	key_name_decode(a0),a0
		jsr	(a0)

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		ahi inits
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS

		bsr.w	open_ahi
		move.l	d0,ahi_base
		beq.s	no_key_exit

		move.l	d0,a6
		sub.l	a0,a0				;no tags.
		jsr	AHI_AllocAudioRequestA(a6)
		move.l	d0,ahi_request
		beq.w	quit
no_key_exit:	
		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		gadtools
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	gad_tools_base,a6
		move.l	context_g_menu,a0
		jsr	CreateContext(a6)
		tst.l	d0
		beq.w	quit

		move.l	context_g_sfx,a0
		jsr	CreateContext(a6)
		tst.l	d0
		beq.w	quit

		move.l	context_g_prefs,a0
		jsr	CreateContext(a6)
		tst.l	d0
		beq.w	quit

		move.l	context_g_gfx,a0
		jsr	CreateContext(a6)
		tst.l	d0
		beq.w	quit

		move.l	context_g_misc,a0
		jsr	CreateContext(a6)
		tst.l	d0
		beq.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		create controller data lists
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	joy_label_list,a6
		move.l	joy_names_list,a1		;list structure.
		lea	joy_item_list,a5
		move.l	#LN_SIZE,d1
		addq.w	#2,d1

		move.l	a1,LH_HEAD(a6)
		move.l	a6,LN_PRED(a1)

		move.l	#joy_name_1,LN_NAME(a1)
		move.l	a1,a3
		add.l	d1,a1
		move.l	a1,LN_SUCC(a3)
		move.b	#0,(a5)+

		IFEQ	GAMEBOY_USERS

		tst.b	key_status
		beq.s	no_sega_joypad

		movem.l	d1/a0-a6,-(SP)
		move.l	key_file,a0
		add.l	key_serial_area(a0),a0
		jsr	(a0)
		movem.l	(SP)+,d1/a0-a6

		tst.l	low_level_base
		beq.s	no_cd32_joypad

		move.l	#joy_name_2,LN_NAME(a1)
		move.l	a3,LN_PRED(a1)
		move.l	a1,a3
		add.l	d1,a1
		move.l	a1,LN_SUCC(a3)
		move.b	#1,(a5)+

no_cd32_joypad:	tst.l	control_pad_base
		beq.s	no_sega_joypad

		move.l	#joy_name_3,LN_NAME(a1)
		move.l	a3,LN_PRED(a1)
		move.l	a1,a3
		add.l	d1,a1
		move.l	a1,LN_SUCC(a3)
		move.b	#2,(a5)+

		move.l	#joy_name_4,LN_NAME(a1)
		move.l	a3,LN_PRED(a1)
		move.l	a1,a3
		add.l	d1,a1
		move.l	a1,LN_SUCC(a3)
		move.b	#3,(a5)+

no_sega_joypad:	tst.b	key_status
		beq.s	no_2b_joy

		move.l	#joy_name_5,LN_NAME(a1)
		move.l	a3,LN_PRED(a1)
		move.l	a1,a3
		add.l	d1,a1
		move.l	a1,LN_SUCC(a3)
		move.b	#4,(a5)+

		move.l	#joy_name_6,LN_NAME(a1)
		move.l	a3,LN_PRED(a1)
		move.b	#5,(a5)
		bra.s	joy_2b_done

		ENDIF

no_2b_joy:	move.l	#joy_name_5,LN_NAME(a1)
		move.l	a3,LN_PRED(a1)
		move.b	#4,(a5)

joy_2b_done:	move.l	a1,LH_TAILPRED(a6)
		lea	LH_TAIL(a6),a5
		move.l	a5,LN_SUCC(a1)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		close controller libraries
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS

		move.l	exec_base,a6
		move.l	low_level_base,d0
		beq.s	no_strt_low
		move.l	d0,a1
		jsr	CloseLibrary(a6)
		clr.l	low_level_base
no_strt_low:	move.l	control_pad_base,d0
		beq.s	no_strt_pad
		move.l	d0,a1
		jsr	CloseLibrary(a6)
		clr.l	control_pad_base
no_strt_pad:	

		ENDIF

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

rt_f_alc_done:	move.l	#RT_SCREENMODEREQ,d0
		moveq.l	#0,d1
		jsr	rtAllocRequestA(a6)
		move.l	d0,request_ptr_sm
		beq.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		create the back pattern map
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	back_pattern_bn,a0
		move.l	back_pattern_map,a1
		moveq.l	#2-1,d7
back_pattern_crt:
		move.l	(a0)+,d0
		move.l	(a0)+,d1
		moveq.l	#function_y_bm/2-1,d3
back_pattern_crt_y:
		moveq.l	#function_x_bm/8/4-1,d2
back_pattern_crt_x_1:
		move.l	d0,(a1)+
		dbra	d2,back_pattern_crt_x_1
		moveq.l	#function_x_bm/8/4-1,d2
back_pattern_crt_x_2:
		move.l	d1,(a1)+
		dbra	d2,back_pattern_crt_x_2
		dbra	d3,back_pattern_crt_y
		add.l	#function_x_bm/8,a1		;NOTE! ALERT!
		dbra	d7,back_pattern_crt

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		init bitmaps
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	info_map_rle,a0
		move.l	info_map,a1
		bsr.w	rle_unpack

		lea	about_map_rle,a0
		move.l	about_map,a1
		bsr.w	rle_unpack

		move.l	info_map_attr,a0
		move.l	info_map,a1
		moveq.l	#8,d0
		bsr.w	init_bit_map_function

		move.l	about_map_attr,a0
		move.l	about_map,a1
		moveq.l	#8,d0
		bsr.w	init_bit_map_function

		move.l	back_pattern_map_attr,a0
		move.l	back_pattern_map,a1
		moveq.l	#2,d0
		bsr.w	init_bit_map_function

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		precalc the gfx window game still colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	graphics_base,a6
		move.l	gfx_game_still_rast_port,a1
		jsr	InitRastPort(a6)

		move.l	gfx_game_still_rast_port,a0
		move.l	gfx_game_still_tmp_rast_port,a1
		bsr.w	copy_rast_port

		move.l	gfx_game_still_map_attr,a0
		lea	gfx_game_still_map,a1
		move.l	#304,d1
		moveq.l	#39,d2
		moveq.l	#3,d0
		bsr.w	init_bit_map

		move.l	gfx_game_still_map_attr,a4
		lea	gfx_game_still_tmp_map_attr,a5
		bsr.w	alloc_bit_map
		tst.l	d0
		beq.w	quit

		move.l	d0,a0
		move.w	#304/8,bm_BytesPerRow(a0)
		move.w	#1,bm_Rows(a0)

		move.l	gfx_game_still_rast_port,a0
		move.l	gfx_game_still_map_attr,rp_BitMap(a0)
		move.l	gfx_game_still_tmp_rast_port,a0
		move.l	gfx_game_still_tmp_map_attr,rp_BitMap(a0)
		clr.l	rp_Layer(a0)

		moveq.l	#0,d0
		moveq.l	#0,d1
		move.l	#303,d2
		moveq.l	#38,d3
		move.l	gfx_game_still_rast_port,a0
		move.l	gfx_game_still_tmp_rast_port,a1
		move.l	gfx_game_still_array,a2
		jsr	ReadPixelArray8(a6)

		lea	gfx_game_still_tmp_map_attr,a1
		bsr.w	free_bit_maps

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		precalc
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		bsr.w	do_x_flip_t
		bsr.l	spr_col_build

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		collect all the packer sub library names
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		tst.l	xpk_master_base
		beq.w	xpk_count_xit			;no library open - no count.

		move.l	dos_base,a6			;time for some dos magic. ;)
		move.l	#xpk_dir_name,d1		;the name.
		moveq.l	#ACCESS_READ,d2
		jsr	Lock(a6)
		move.l	d0,file_hd
		beq.w	xpk_count_e			;an error occurred!

		move.l	file_info_ptr,d2		;d2 = file info structure.
		move.l	d0,d1				;d1 = file hd.
		jsr	Examine(a6)			;load file info.
		tst.l	d0				;errors?
		beq.w	xpk_count_eu			;yes! quit!

		move.l	xpk_names,a5			;the names buffer.
		move.l	file_info_ptr,a1
		lea	fib_FileName(a1),a4
xpk_count_exa:	move.l	file_hd,d1
		move.l	file_info_ptr,d2
		jsr	ExNext(a6)

		tst.l	d0				;no errors?
		beq.s	xpk_count_io			;hmm...

xpk_count_test:	cmp.w	#'xp',(a4)			;right start?
		bne.s	xpk_count_exa			;no. continue testing.
		cmp.b	#'k',2(a4)			;right end?
		bne.s	xpk_count_exa			;no. continue testing.

xpk_one_found:	addq.l	#1,xpk_names_v			;one name more.
		move.l	3(a4),(a5)+			;name stored.
		bra.s	xpk_count_exa			;loop until the end comes.

xpk_count_done:	bsr.w	sort_xpk_names			;sort the names and create
		tst.l	d0				;a list.
		bne.w	quit				;errors!

		move.l	dos_base,a6
		move.l	file_hd,d1
		jsr	UnLock(a6)			;unlock it.

		bra.s	xpk_count_xit			;normal exit.

xpk_count_io:	jsr	IoErr(a6)			;get an error code.
		cmp.l	#ERROR_NO_MORE_ENTRIES,d0	;end of list.
		beq.s	xpk_count_done			;all done.
							;an error occurred!
xpk_count_eu:	move.l	dos_base,a6
		move.l	file_hd,d1
		jsr	UnLock(a6)			;unlock it.

xpk_count_e:	move.l	exec_base,a6			;close the library.
		move.l	xpk_master_base,a1		;it won't be used anymore.
		jsr	CloseLibrary(a6)
		clr.l	xpk_master_base
xpk_count_xit:	

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		load preferences
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		bsr.w	prefs_load_default
		bsr.w	load_game_genie_list

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		obtain pens for the bitmaps and convert the static
;		images to use the obtained colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	graphics_base,a6
		move.l	pub_screen_lock,a5
		lea	sc_ViewPort(a5),a5
		move.l	vp_ColorMap(a5),a5
		lea	gameboy_colours,a4		;input (0.B, r.B, g.B, b.B).
		lea	pen_list,a3			;output (.B).
		moveq.l	#8-1,d7
obtain_pens:	move.l	a5,a0
		lea	obtain_pens_tag_list,a1
		moveq.l	#0,d1
		moveq.l	#0,d2
		moveq.l	#0,d3
		move.b	1(a4),d1
		move.b	2(a4),d2
		move.b	3(a4),d3
		ror.l	#8,d1
		ror.l	#8,d2
		ror.l	#8,d3
		addq.l	#4,a4
		jsr	ObtainBestPenA(a6)
		move.b	d0,(a3)+
		dbra	d7,obtain_pens

		move.l	gfx_game_still_array,a0
		move.l	gfx_game_still_tmp_array,a1
		lea	pen_list,a2
		move.w	#(304*39)-1,d0
		moveq.l	#0,d1
convert_pens:	move.b	(a0)+,d1
		move.b	(a2,d1.l),(a1)+
		dbra	d0,convert_pens

		lea	pen_list,a4
		move.l	(a4),pen_storage_list		;save the pens.
		move.l	4(a4),pen_storage_list+4		

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate gfx driver memory
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		bsr.w	allocate_gfx_driver_memory
		tst.l	d0				;errors?
		bne.w	quit				;yes! quit!

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		create all the gadtools buttons
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	menu_gadgets,a4
		move.l	context_g_menu,a5
		bsr.w	gadget_crt			;create gadgets.
		tst.l	d0
		bne.w	quit

		move.l	gg_label_list,misc_b_code_list_tags+4
		bsr.w	get_gg				;init the list.

		lea	misc_gadgets,a4
		move.l	context_g_misc,a5
		bsr.w	gadget_crt			;create gadgets.
		tst.l	d0
		bne.w	quit

		IFEQ	GAMEBOY_USERS
		bchg.b	#0,snd_master			;compability fix.
		bchg.b	#0,snd_chnlI
		bchg.b	#0,snd_chnlII
		bchg.b	#0,snd_chnlIII
		bchg.b	#0,snd_chnlIV
		ENDIF

		IFEQ	GAMEBOY_USERS
		lea	sfx_gadgets,a4
		move.l	context_g_sfx,a5
		bsr.w	gadget_crt			;create gadgets.
		tst.l	d0
		bne.w	quit
		ENDIF

		IFEQ	GAMEBOY_USERS
		bchg.b	#0,snd_master			;compability fix.
		bchg.b	#0,snd_chnlI
		bchg.b	#0,snd_chnlII
		bchg.b	#0,snd_chnlIII
		bchg.b	#0,snd_chnlIV
		ENDIF

		move.l	joy_label_list,prefs_g_joy_l+4
		move.l	xpk_label_list,prefs_g_xpk_l+4

		lea	prefs_gadgets,a4
		move.l	context_g_prefs,a5
		bsr.w	gadget_crt			;create gadgets.
		tst.l	d0
		bne.w	quit

		lea	gfx_gadgets,a4
		move.l	context_g_gfx,a5
		bsr.w	gadget_crt			;create gadgets.
		tst.l	d0
		bne.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		bsr.w	do_menu_items			;create the menu lists.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy sound channel data
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS
		move.l	smpl_mem_1,a2
		move.w	#512-1,d0
smpl_multiply_1:lea	smpl_bn_1,a0
		move.l	(a0)+,(a2)+
		move.l	(a0),(a2)+
		dbra	d0,smpl_multiply_1

		move.l	smpl_mem_2,a2
		move.w	#512-1,d0
smpl_multiply_2:lea	smpl_bn_2,a0
		move.l	(a0)+,(a2)+
		move.l	(a0),(a2)+
		dbra	d0,smpl_multiply_2

		move.l	smpl_mem_3,a2
		move.w	#512-1,d0
smpl_multiply_3:lea	smpl_bn_3,a0
		move.l	(a0)+,(a2)+
		move.l	(a0),(a2)+
		dbra	d0,smpl_multiply_3

		move.l	smpl_mem_4,a2
		move.w	#512-1,d0
smpl_multiply_4:lea	smpl_bn_4,a0
		move.l	(a0)+,(a2)+
		move.l	(a0),(a2)+
		dbra	d0,smpl_multiply_4
		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		create sound channel III table
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS
		move.l	sound_III_lst,a0
		move.w	#256-1,d0
		moveq.l	#0,d1
sound_III_tbl_c:move.l	d1,d2
		move.l	d1,d3
		and.b	#%1111,d2			;d2 = low nibble.
		lsr.b	#4,d3				;d3 = high nibble.
		move.b	d2,d4
		lsl.b	#4,d2
		or.b	d4,d2
		move.b	d3,d4
		lsl.b	#4,d3
		or.b	d4,d3
		sub.b	#128,d2
		sub.b	#128,d3
		move.b	d3,(a0)+			;high byte first.
		addq.b	#1,d1
		move.b	d2,(a0)+			;then the low byte.
		dbra	d0,sound_III_tbl_c

		move.l	smpl_IV_mem,a0
		move.l	#$7fff,d2
		move.w	#32767-1,d0
noise_15:	move.w	d2,d3
		lsr.w	#1,d3
		eor.w	d2,d3
		and.w	#1,d3
		lsr.w	#1,d2
		tst.w	d3
		beq.s	noise_15_bit
		or.w	#$4000,d2
noise_15_bit:	move.w	d2,d1
		and.w	#1,d1
		beq.s	noise_15_high
		move.b	#$81,(a0)+
		bra.s	noise_15_next
noise_15_high:	move.b	#$7f,(a0)+
noise_15_next:	dbra	d0,noise_15

		move.l	smpl_IV_short,a0
		move.l	#$7fff,d2
		move.w	#127-1,d0
noise_7:	move.w	d2,d3
		lsr.w	#1,d3
		eor.w	d2,d3
		and.w	#1,d3
		lsr.w	#1,d2
		and.w	#$ffbf,d2
		tst.w	d3
		beq.s	noise_7_bit
		or.w	#$4000,d2
		or.w	#$0040,d2
noise_7_bit:	move.w	d2,d1
		and.w	#1,d1
		beq.s	noise_7_high
		move.b	#$81,(a0)+
		bra.s	noise_7_next
noise_7_high:	move.b	#$7f,(a0)+
noise_7_next:	dbra	d0,noise_7

		tst.b	key_status
		bne.w	no_zfx_off
		ENDIF

		bsr.w	do_register_window_stuff

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		open windows
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

no_zfx_off:	move.l	intuition_base,a6
		lea	menu_window,a0
		lea	win_tags_u,a1			;universal taglist.
		jsr	OpenWindowTagList(a6)		;structure and open the window.
		move.l	d0,menu_ptr
		beq.w	quit

		move.l	d0,a0
		lea	menu_recent,a1
		jsr	SetMenuStrip(a6)		;add menus.

		move.l	graphics_base,a6
		move.l	back_pattern_map_attr,a0	;a0 = source bitmap.
		move.l	menu_ptr,a1
		move.l	wd_RPort(a1),a1			;a1 = destination rastport.
		moveq.l	#0,d0				;org x.
		moveq.l	#0,d1				;org y.
		moveq.l	#0,d2				;dst x.
		moveq.l	#0,d3				;dst y.
		move.l	#menu_x,d4			;size x.
		sub.l	window_bars_width,d4
		move.l	#menu_y-2,d5			;size y.
		move.l	#$c0,d6				;minterm.
		jsr	BltBitMapRastPort(a6)		;update the screen window.

		move.l	intuition_base,a6
		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a0
		lea	menu_text_1,a1
		moveq.l	#0,d0
		moveq.l	#0,d1
		jsr	PrintIText(a6)

		move.l	menu_ptr,a0
		move.l	#-1,a1
		lea	menu_scr_txt,a2
		jsr	SetWindowTitles(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		refresh the graphics
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	menu_ptr,a4
		lea	menu_bevel_list,a5
		bsr.w	draw_bevel_list

		lea	status_waiting_txt,a5
		bsr.w	print_status_middle

		move.l	intuition_base,a6
		move.l	menu_ptr,a0
		move.l	context_g_menu,a1
		move.l	(a1),a1
		sub.l	a2,a2
		moveq.l	#-1,d0
		moveq.l	#-1,d1
		jsr	AddGList(a6)

		move.l	context_g_menu,a0
		move.l	(a0),a0
		move.l	menu_ptr,a1
		sub.l	a2,a2
		moveq.l	#-1,d0				;all gadgets.
		jsr	RefreshGList(a6)

		move.l	gad_tools_base,a6
		move.l	menu_ptr,a0
		sub.l	a1,a1
		jsr	GT_RefreshWindow(a6)

		IFEQ	GAMEBOY_USERS
		tst.b	key_status
		bne.s	no_sfx_off
		ENDIF

yes_sfx_off:	move.l	intuition_base,a6

		move.l	menu_b_4,a0
		move.l	menu_ptr,a1
		sub.l	a2,a2
		jsr	OffGadget(a6)

		move.l	menu_b_5,a0
		move.l	menu_ptr,a1
		sub.l	a2,a2
		jsr	OffGadget(a6)

		move.l	menu_b_8,a0
		move.l	menu_ptr,a1
		sub.l	a2,a2
		jsr	OffGadget(a6)

		IFEQ	GAMEBOY_USERS
		bra.s	no_key_sfx_off

no_sfx_off:	move.l	key_file,a0
		add.l	key_serial_area(a0),a0
		jsr	(a0)
		ENDIF

no_key_sfx_off:	

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		init new bit maps for the output routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a0
		move.l	gfx_game_still_tmp_rast_port,a1
		bsr.w	copy_rast_port

		move.l	menu_ptr,a4
		move.l	wd_RPort(a4),a4
		move.l	rp_BitMap(a4),a4
		lea	gfx_game_still_tmp_map_attr,a5
		bsr.w	alloc_bit_map
		tst.l	d0
		beq.w	quit

		move.l	d0,a0
		move.w	#304/8,bm_BytesPerRow(a0)
		move.w	#1,bm_Rows(a0)

		move.l	gfx_game_still_tmp_rast_port,a0
		move.l	gfx_game_still_tmp_map_attr,rp_BitMap(a0)
		clr.l	rp_Layer(a0)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		check out the command line input from a shell
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		tst.b	cli_or_wb
		bne.s	get_message

		move.l	cli_load,a0
		move.l	dir_n_name_ptr,a1
		moveq.l	#0,d0
move_name:	move.b	(a0)+,d1
		beq.s	exit_name_move
		cmp.b	#$a,d1
		beq.s	exit_name_move
		cmp.b	#" ",d1
		beq.s	move_name			;skip spaces.
		move.b	d1,(a1)+
		addq.w	#1,d0
		bra.s	move_name

exit_name_move:	tst.w	d0
		beq.s	get_message

		move.b	#0,(a1)				;end name.
		bsr.w	cli_load_here			;load the cartridge.
		bra.w	jump_g_load_aft

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		message loop
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_message:	moveq.l	#5,d1
		bsr.w	do_delay

		move.l	gad_tools_base,a6
		move.l	menu_ptr,a0
		move.l	wd_UserPort(a0),a0		;userport -> a0.
		jsr	GT_GetIMsg(a6)			;get every message.
		tst.l	d0				;avoid queue.
		bne.w	menu_message

		bsr.w	poll_wzonka_window
		bsr.w	obtain_status			;turn it on/off / handle
							;messages.
		tst.l	function_jmp
		beq.s	get_function_message_exec

		move.l	function_ptr,d0
		beq.s	get_message
		move.l	d0,a0
		move.l	gad_tools_base,a6
		move.l	wd_UserPort(a0),a0		;userport -> a0.
		jsr	GT_GetIMsg(a6)			;get every message.
		tst.l	d0				;avoid queue.
		bne.w	function_message

		bra.w	get_message

get_function_message_exec:
		move.l	function_ptr,d0
		beq.w	get_message
		move.l	d0,a0
		move.l	exec_base,a6
		move.l	wd_UserPort(a0),a0		;userport -> a0.
		jsr	GetMsg(a6)			;get every message.
		tst.l	d0				;avoid queue.
		bne.w	function_message_exec

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		dos.library delay
;		INPUT:
;		d1	= time.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

do_delay:	move.l	dos_base,a6
		jsr	Delay(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		no keyfile - open the centered register window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

do_register_window_stuff:
		move.l	window_bars_height,d7
		add.l	#register_y,d7

		moveq.l	#0,d0
		moveq.l	#0,d1
		move.l	pub_screen_lock,a0
		move.w	sc_Width(a0),d0
		move.w	sc_Height(a0),d1
		sub.l	#register_x,d0
		blt.w	quit
		sub.l	d7,d1
		blt.w	quit
		lsr.w	#1,d0
		lsr.w	#1,d1
		lea	register_window,a0
		move.w	d0,nw_LeftEdge(a0)
		move.w	d1,nw_TopEdge(a0)
		move.w	d7,nw_Height(a0)
		move.w	#register_x,nw_Width(a0)

		move.l	intuition_base,a6
		lea	register_window,a0
		lea	win_tags_u,a1			;universal taglist.
		jsr	OpenWindowTagList(a6)		;structure and open the window.
		move.l	d0,register_ptr
		beq.w	quit

		move.l	graphics_base,a6
		move.l	back_pattern_map_attr,a0	;a0 = source bitmap.
		move.l	register_ptr,a1
		move.l	wd_RPort(a1),a1			;a1 = destination rastport.
		moveq.l	#0,d0				;org x.
		moveq.l	#0,d1				;org y.
		moveq.l	#0,d2				;dst x.
		moveq.l	#0,d3				;dst y.
		move.l	#register_x,d4			;size x.
		sub.l	window_bars_width,d4
		move.l	#register_y,d5			;size y.
		move.l	#$c0,d6				;minterm.
		jsr	BltBitMapRastPort(a6)		;update the screen window.

		move.l	register_ptr,a4
		lea	register_bevel_list,a5
		bsr.w	draw_bevel_list

		lea	register_text_1,a0
		bsr.w	print_middle_register
		lea	register_text_11,a0
		bsr.w	print_middle_register
		lea	register_text_20,a0
		bsr.w	print_middle_register
		lea	register_text_21,a0
		bsr.w	print_middle_register
		lea	register_text_22,a0
		bsr.w	print_middle_register
		lea	register_text_23,a0
		bsr.w	print_middle_register
		lea	register_text_24,a0
		bsr.w	print_middle_register
		lea	register_text_2,a0
		bsr.w	print_middle_register

		moveq.l	#30-1,d0
		moveq.l	#30,d1

register_delay:	movem.l	d0/d1,-(SP)

		lea	register_text_2,a0
		clr.b	(a0)
		bsr.w	print_middle_register

		movem.l	(SP)+,d0/d1
		movem.l	d0/d1,-(SP)

		lea	register_txt_2_number,a0
		move.l	d1,d2
		divu.w	#10,d2
		add.b	#"0",d2
		move.b	d2,(a0)+
		swap	d2
		add.b	#"0",d2
		move.b	d2,(a0)

		lea	register_text_2,a0
		move.b	#2,(a0)
		bsr.w	print_middle_register

		moveq.l	#50,d1
		bsr.w	do_delay

		movem.l	(SP)+,d0/d1
		subq.b	#1,d1
		add.l	#1,z80_cycles
		dbra	d0,register_delay

		lea	register_ptr,a5
		bsr.w	close_window
		rts

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
		beq.s	menu_buttons_x
		cmp.l	#IDCMP_MENUPICK,d0
		beq.s	menu_menu_its
		cmp.l	#IDCMP_VANILLAKEY,d0
		beq.s	menu_keys_x
		bra.w	get_message

menu_quit:	move.l	a0,a1				;a1 = message.
		jsr	ReplyMsg(a6)			;reply to it.
		bra.w	quit

menu_buttons_x:	moveq.l	#0,d0
		move.l	d1,a0
		move.w	gg_GadgetID(a0),d0		;d0 = gadget id.
		lea	menu_jump_tbl,a0
		jmp	([a0,d0.l*4])

menu_menu_its:	cmp.w	#$ffff,d2			;no selections?
		beq.w	get_message			;yes. exit this.

		move.b	d2,d0
		lsr.w	#5,d2
		and.w	#%111111,d2

		and.b	#%11,d0				;check out the menu number.
		beq.s	menu_go_I
		cmp.b	#1,d0
		beq.s	menu_go_II
		bra.w	get_message

menu_keys_x:	cmp.b	#"l",d2
		beq.w	menu_rom_load
		cmp.b	#"r",d2
		beq.w	menu_rom_run
		cmp.b	#"e",d2
		beq.w	menu_rom_reset
		cmp.b	#"i",d2
		beq.w	menu_rom_info

		cmp.b	#"o",d2
		beq.w	menu_gbs_load
		cmp.b	#"a",d2
		beq.w	menu_gbs_save
		cmp.b	#"b",d2
		beq.w	menu_misc_about

		cmp.b	#"g",d2
		beq.w	menu_edit_gfx
		cmp.b	#"s",d2
		beq.w	menu_edit_sfx
		cmp.b	#"p",d2
		beq.w	menu_edit_prefs
		cmp.b	#"m",d2
		beq.w	menu_edit_misc

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		do things for menu items
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_go_I:	lsl.w	#5,d2				;position is 32.B aligned.
		move.l	prefs_file,a0
		add.l	#560,a0
		bra.s	menu_go_go

menu_go_II:	lsl.w	#5,d2				;position is 32.B aligned.
		move.l	menu_favo_nf,a0

menu_go_go:	add.l	d2,a0				;activated item selected.
		move.l	name_ptr,a1			;output.
		tst.l	(a0)
		beq.w	get_message			;an empty item.
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0),(a1)			;new name copied.
		move.b	#1,load_menu_tag		;an old name load.
		bsr.w	load_load_cart			;load a rom image.
		clr.b	load_menu_tag
		bra.w	jump_g_load_aft			;the normal procedures.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		message from the wzonka game window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

poll_wzonka_window:
		tst.b	scaling_status
		beq.s	poll_wzonka_done
		tst.l	wzonka_ptr
		beq.s	poll_wzonka_done
		move.l	wzonka_ptr,a5
		move.l	wd_UserPort(a5),a0
		move.l	exec_base,a6
		jsr	GetMsg(a6)
		tst.l	d0
		beq.s	poll_wzonka_done
		move.l	d0,a1
		move.l	im_Class(a1),d4
		moveq.l	#0,d2
		move.w	im_Code(a1),d2
		move.w	im_Qualifier(a1),d3
		movem.l	d2-d3,-(SP)
		jsr	ReplyMsg(a6)
		movem.l	(SP)+,d2-d3
		cmp.l	#IDCMP_RAWKEY,d4
		beq.s	wzonka_resize_key
		cmp.l	#IDCMP_NEWSIZE,d4
		beq.w	update_wzonka_window_size
		cmp.l	#IDCMP_CHANGEWINDOW,d4
		beq.w	update_wzonka_window_size
poll_wzonka_done:
		rts

wzonka_resize_key:
		move.l	wd_Flags(a5),d0
		and.l	#WFLG_WINDOWACTIVE,d0
		beq.s	poll_wzonka_done
		cmp.w	#1,d2				;top-row 1 through 9, key-down only.
		blo.s	poll_wzonka_done
		cmp.w	#9,d2
		bhi.s	poll_wzonka_done
		move.w	d3,d0
		and.w	#IEQUALIFIER_REPEAT!IEQUALIFIER_CONTROL!IEQUALIFIER_LALT!IEQUALIFIER_RALT!IEQUALIFIER_LCOMMAND!IEQUALIFIER_RCOMMAND,d0
		bne.s	poll_wzonka_done

		move.w	wd_Width(a5),d4
		move.w	wd_Height(a5),d5
		tst.w	window_requested_width
		beq.s	wzonka_resize_axis
		move.w	window_requested_width,d4
		move.w	window_requested_height,d5
wzonka_resize_axis:
		and.w	#IEQUALIFIER_LSHIFT!IEQUALIFIER_RSHIFT,d3
		bne.s	wzonka_resize_key_height
		mulu.w	#160,d2
		add.w	window_bars_width+2,d2
		add.w	#window_right_bar_x,d2
		move.w	d2,d4
		bra.s	wzonka_resize_key_check
wzonka_resize_key_height:
		mulu.w	#144,d2
		add.w	window_bars_height+2,d2
		move.w	d2,d5
wzonka_resize_key_check:
		tst.w	window_requested_width
		beq.s	wzonka_resize_key_current
		cmp.w	window_requested_width,d4
		bne.s	wzonka_resize_key_bounds
		cmp.w	window_requested_height,d5
		beq.w	poll_wzonka_done
		bra.s	wzonka_resize_key_bounds
wzonka_resize_key_current:
		cmp.w	wd_Width(a5),d4
		bne.s	wzonka_resize_key_bounds
		cmp.w	wd_Height(a5),d5
		beq.w	poll_wzonka_done
wzonka_resize_key_bounds:
		move.l	wd_WScreen(a5),a0
		cmp.w	sc_Width(a0),d4
		bhi.s	wzonka_resize_denied
		cmp.w	sc_Height(a0),d5
		bhi.s	wzonka_resize_denied
		cmp.w	wd_MaxWidth(a5),d4
		bhi.s	wzonka_resize_denied
		cmp.w	wd_MaxHeight(a5),d5
		bhi.s	wzonka_resize_denied
		bsr.w	reserve_wzonka_window_size
		tst.l	d0
		beq.s	wzonka_resize_denied
		move.w	d4,window_requested_width
		move.w	d5,window_requested_height
		bra.w	set_wzonka_window_box

wzonka_resize_denied:
		move.l	wd_WScreen(a5),a0
		move.l	intuition_base,a6
		jsr	_LVODisplayBeep(a6)
		rts

;		d4/d5 = outer box size. Keep the position unless the larger box needs room.
set_wzonka_window_box:
		move.l	wd_WScreen(a5),a1
		move.w	sc_Width(a1),d2
		sub.w	d4,d2
		move.w	sc_Height(a1),d3
		sub.w	d5,d3
		move.w	wd_LeftEdge(a5),d0
		move.w	wd_TopEdge(a5),d1
		cmp.w	d2,d0
		ble.s	wzonka_box_left_ok
		move.w	d2,d0
wzonka_box_left_ok:
		tst.w	d0
		bpl.s	wzonka_box_top
		moveq.l	#0,d0
wzonka_box_top:
		cmp.w	d3,d1
		ble.s	wzonka_box_top_ok
		move.w	d3,d1
wzonka_box_top_ok:
		tst.w	d1
		bpl.s	wzonka_box_apply
		moveq.l	#0,d1
wzonka_box_apply:
		move.l	a5,a0
		move.w	d4,d2
		move.w	d5,d3
		move.l	intuition_base,a6
		jsr	_LVOChangeWindowBox(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		message from the function window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

function_message:
		move.l	exec_base,a6
		move.l	d0,a1
		move.l	im_Class(a1),d0

		cmp.l	#IDCMP_CLOSEWINDOW,d0
		beq.s	function_quit

		move.l	im_IAddress(a1),d1		;address of a gadget.

		movem.l	d0/d1,-(SP)
		jsr	ReplyMsg(a6)			;reply to it.
		movem.l	(SP)+,d0/d1

		cmp.l	#IDCMP_GADGETUP,d0
		beq.s	get_function_message
		cmp.l	#IDCMP_GADGETDOWN,d0
		beq.s	get_function_message
		cmp.l	#IDCMP_MOUSEBUTTONS,d0
		beq.s	get_function_message
		cmp.l	#IDCMP_MOUSEMOVE,d0
		beq.s	get_function_message
		bra.w	get_message

get_function_message:
		moveq.l	#0,d0
		move.l	d1,a0
		move.w	gg_GadgetID(a0),d0		;d0 = gadget id.
		move.l	function_jmp,a0
		jmp	([a0,d0.l*4])

		cmp.l	#IDCMP_CLOSEWINDOW,d0
		beq.s	function_quit

function_quit:	jsr	ReplyMsg(a6)

		bsr.w	gadgets_rmv

		move.l	function_ptr,a5
		lea	function_window,a4
		move.w	wd_LeftEdge(a5),nw_LeftEdge(a4)
		move.w	wd_TopEdge(a5),nw_TopEdge(a4)

		lea	function_ptr,a5
		bsr.w	close_window

		clr.l	function_status

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		function message from window gadgets only
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

function_message_exec:
		move.l	d0,a1
		move.l	im_Class(a1),d0

		cmp.l	#IDCMP_CLOSEWINDOW,d0
		beq.s	function_quit

		jsr	ReplyMsg(a6)

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		jump table
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_jump_tbl:	dc.l	menu_rom_load
		dc.l	menu_rom_run
		dc.l	menu_rom_info

		dc.l	menu_gbs_load
		dc.l	menu_gbs_save
		dc.l	menu_misc_about

		dc.l	menu_edit_gfx
		dc.l	menu_edit_sfx
		dc.l	menu_edit_prefs
		dc.l	menu_edit_misc

		dc.l	menu_rom_reset

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate bit map (tmp)
;		INPUT:
;		a4	= another bit map.
;		a5	= place for pointer.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

alloc_bit_map:	move.l	#304,d0
alloc_bit_map_other:
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

init_bit_map_function:
		move.l	#function_x_bm,d1
		move.l	#function_y_bm,d2

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
		cmp.b	#5,d1
		beq.w	gadget_crt_chb			;checkbox kind!

gadget_crt_mx:	move.w	#17,gng_Width(a1)		;dx.
		move.w	#9,gng_Height(a1)		;dy.
		move.l	(a4)+,a2
		move.l	(a4)+,4(a2)			;labels list.
		move.l	(a4)+,a5
		moveq.l	#0,d0
		move.b	(a5),d0
		move.l	d0,12(a2)			;active number.
		move.l	#MX_KIND,d0			;gadget type.
		jsr	CreateGadgetA(a6)

		move.l	(a4)+,a5
		move.l	d0,(a5)
		beq.w	gadget_crt_err
		bra.w	gadget_crt_s

gadget_crt_btn:	move.w	(a4)+,gng_Width(a1)		;dx.
		move.w	(a4)+,gng_Height(a1)		;dy.
		lea	button_gadget_underscore_tag,a2 ;no tags!
		move.l	#BUTTON_KIND,d0
		jsr	CreateGadgetA(a6)

		move.l	(a4)+,a5
		move.l	d0,(a5)
		beq.w	gadget_crt_err
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
		beq.w	gadget_crt_err
		bra.w	gadget_crt_s

gadget_crt_lw:	move.w	(a4)+,gng_Width(a1)		;dx.
		move.w	(a4)+,gng_Height(a1)		;dy.
		move.l	(a4)+,a2
		move.l	(a4)+,a5
		moveq.l	#0,d0
		move.b	(a5),d0
		move.l	d0,12(a2)
		move.l	d0,20(a2)
		move.l	#LISTVIEW_KIND,d0
		jsr	CreateGadgetA(a6)

		move.l	(a4)+,a5
		move.l	d0,(a5)
		beq.s	gadget_crt_err
		bra.w	gadget_crt_s

gadget_crt_sld:	move.w	(a4)+,gng_Width(a1)		;dx.
		move.w	(a4)+,gng_Height(a1)		;dy.
		move.l	(a4)+,a2
		move.l	(a4)+,12(a2)
		move.l	(a4)+,a5
		moveq.l	#0,d0
		move.b	(a5),d0
		move.l	d0,4(a2)
		move.l	#SLIDER_KIND,d0			;gadget type.
		jsr	CreateGadgetA(a6)

		move.l	(a4)+,a5
		move.l	d0,(a5)
		beq.s	gadget_crt_err
		bra.w	gadget_crt_s

gadget_crt_chb:	move.l	(a4)+,a2
		moveq.l	#0,d0
		move.l	(a4)+,a5
		move.b	(a5),d0
		move.l	d0,4(a2)
		move.l	#CHECKBOX_KIND,d0
		jsr	CreateGadgetA(a6)

		move.l	(a4)+,a5
		move.l	d0,(a5)
		beq.w	gadget_crt_err
		bra.w	gadget_crt_s

gadget_crt_x:	moveq.l	#0,d0
		rts
gadget_crt_err:	moveq.l	#1,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu rom reset
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_rom_reset:	tst.l	cartridge
		beq.w	get_message

		bsr.w	save_battery_ram
		move.b	#1,load_or_reset
		bsr.w	load_ok_ok
		bra.s	jump_g_load_aft

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu rom load
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_rom_load:	bsr.w	load_rom

jump_g_load_aft:tst.l	d0				;any errors?
		beq.w	menu_rom_load_okay
		cmp.b	#1,d0
		beq.w	get_message			;not selected!

		move.b	#1,cartridge_status		;invalid ROM!
		bra.w	get_message

menu_rom_load_okay:
		clr.l	four_ram_banks_from_gbs		;set by GBS loading when
							;appropriate.
		clr.l	ram_bank_no

		bsr.w	gb_memory_at_start		;init some values.

		move.l	memory_banks,a0			;randomize battery RAM.
		move.w	#131072/4/4-1,d0
		move.l	#$51347394,d1
randomize_ram_banks:
		move.l	d1,(a0)+
		add.l	#$01020103,d1
		move.l	d1,(a0)+
		add.l	#$02010301,d1
		move.l	d1,(a0)+
		add.l	#$01020103,d1
		move.l	d1,(a0)+
		add.l	#$02010301,d1
		dbra	d0,randomize_ram_banks

		bsr.w	load_battery_ram
		bsr.w	load_prefs			;load rom image prefs.
		move.b	#1,new_load			;sign of a new load!
		bsr.w	do_info
		bsr.w	get_gg

		tst.b	cartridge_status
		beq.s	cartridge_is_ok

		lea	status_corrupted_rom_txt,a5
		bsr.w	print_status_middle

		bra.w	get_message

cartridge_is_ok:tst.b	load_or_reset
		bne.s	cartridge_reset_is_ok

		lea	status_rom_loaded_txt,a5
		bsr.w	print_status_middle
		bra.w	get_message

cartridge_reset_is_ok:
		lea	status_rom_reset_txt,a5
		bsr.w	print_status_middle
		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		save battery ram
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

save_battery_ram:
		bsr.w	battery_existence
		tst.l	d0
		bne.s	save_battery_ram_exit		;no battery.

		tst.b	battery_status
		bne.s	save_battery_ram_exit
		tst.l	cartridge
		beq.s	save_battery_ram_exit

		bsr.w	copy_cartridge_name_to_file_name

		move.b	battery_xpk_status,d6		;xpk status.
		move.l	cartridge,a0
		moveq.l	#0,d1
		move.b	$149(a0),d1
		lea	ram_size_list,a1
		and.b	#%111,d1
		move.l	(a1,d1.l*4),d7

		cmp.l	#8192,d7
		beq.s	save_one_bank

save_four_banks_or_more:
		move.l	memory_banks,a3
		move.l	a3,a5
		move.l	gb_memory,a4
		add.l	#$A000,a4
		move.l	ram_bank_no,d0			;the active bank.
		lsl.l	#8,d0
		lsl.l	#5,d0				;8kb.
		add.l	d0,a3
		move.w	#8192/4/4-1,d0
save_active_bank:
		move.l	(a4)+,(a3)+
		move.l	(a4)+,(a3)+
		move.l	(a4)+,(a3)+
		move.l	(a4)+,(a3)+
		dbra	d0,save_active_bank
		bra.s	save_the_banks

save_one_bank:	move.l	gb_memory,a5
		add.l	#$A000,a5

save_the_banks:	bsr.w	save_file

save_battery_ram_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		load battery ram
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_battery_ram:
		clr.b	battery_load			;no battery loaded, yet.

		bsr.b	battery_existence
		tst.l	d0
		bne.s	load_battery_ram_exit		;no battery.

		tst.b	battery_status
		bne.s	load_battery_ram_exit
		tst.l	cartridge
		beq.s	save_battery_ram_exit

		bsr.b	copy_cartridge_name_to_file_name

		move.l	memory_banks,a5
		move.l	cartridge,a0
		moveq.l	#0,d1
		move.b	$149(a0),d1
		lea	ram_size_list,a1
		and.b	#%111,d1
		move.l	(a1,d1.l*4),d7
		bsr.w	load_file
		tst.l	d0
		bne.s	load_battery_ram_exit		;error!

use_loaded_battery_ram:
		move.l	memory_banks,a0
		move.l	gb_memory,a1
		add.l	#$A000,a1
		move.w	#$2000/4/8-1,d0
copy_ram_banks:	move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		dbra	d0,copy_ram_banks

		move.b	#1,battery_load			;battery loaded!

load_battery_ram_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		battery existence checker
;		OUTPUT:
;		d0	= status (0 = battery found / 1 = no battery).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

battery_existence:
		move.l	cartridge,d0
		beq.s	battery_existence_error
		move.l	d0,a0
		move.b	$147(a0),d0
		cmp.b	#3,d0
		beq.s	battery_existence_exit
		cmp.b	#6,d0
		beq.s	battery_existence_exit
		cmp.b	#9,d0
		beq.s	battery_existence_exit
		cmp.b	#$10,d0
		beq.s	battery_existence_exit
		cmp.b	#$13,d0
		beq.s	battery_existence_exit
		cmp.b	#$1b,d0
		beq.s	battery_existence_exit
		cmp.b	#$ff,d0
		beq.s	battery_existence_exit

battery_existence_error:
		moveq.l	#1,d0				;no battery.
		rts

battery_existence_exit:
		moveq.l	#0,d0				;battery found.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy cartridge name to file name to be used by
;		battery loader
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

copy_cartridge_name_to_file_name:
		move.l	prefs_str_4,prefs_str_ptr
		bsr.w	get_cartridge_path_and_name
		move.l	#".sav",(a0)+
		clr.b	(a0)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get gg list
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

GG_ERROR	=0
GG_GG_BEGIN	=1
GG_GAME_BEGIN	=2
GG_NAME		=3
GG_CODE		=4
GG_DESC		=5
GG_GAME_END	=6
GG_GG_END	=7

get_gg:
		IFEQ	GAMEBOY_USERS
		tst.l	gg_list
		beq.w	get_gg_list_exit_exit
		tst.l	gg_list_size
		beq.w	get_gg_list_exit_exit
		tst.l	cartridge
		beq.w	get_gg_list_exit_exit
		tst.b	key_status
		beq.w	get_gg_list_exit_exit

		move.l	key_file,a0
		add.l	key_serial_area(a0),a0
		jsr	(a0)

		bsr.w	free_gg_linked_list

		lea	gg_rom_name,a0
		bsr.w	copy_rom_name_to_a0

		move.l	gg_list,a1
		move.l	gg_list_size,d1

		addq.l	#1,a1
		subq.l	#1,d1
		beq.w	get_gg_list_exit

		bsr.w	get_gg_next_tag
		cmp.b	#GG_ERROR,d0
		beq.w	get_gg_list_exit
		cmp.b	#GG_GG_BEGIN,d0
		bne.w	get_gg_list_exit

get_gg_begin_loop:
		bsr.w	get_gg_next_tag
		cmp.b	#GG_GG_END,d0
		beq.w	get_gg_list_exit
		cmp.b	#GG_ERROR,d0
		beq.w	get_gg_list_exit
		cmp.b	#GG_GAME_BEGIN,d0
		beq.s	get_gg_name_loop
		bra.s	get_gg_begin_loop

get_gg_name_loop:
		bsr.w	get_gg_next_tag
		cmp.b	#GG_GG_END,d0
		beq.w	get_gg_list_exit
		cmp.b	#GG_ERROR,d0
		beq.w	get_gg_list_exit
		cmp.b	#GG_NAME,d0
		beq.s	get_gg_cmp_name
		bra.s	get_gg_name_loop

get_gg_cmp_name:lea	gg_rom_name,a0
		addq.l	#1,a1
		subq.l	#1,d1
		beq.w	get_gg_list_exit
		moveq.l	#16-1,d0

get_gg_cmp_name_loop:
		move.b	(a0)+,d7
		subq.l	#1,d1
		beq.w	get_gg_list_exit
		cmp.b	(a1)+,d7
		bne.s	get_gg_begin_loop
		dbra	d0,get_gg_cmp_name_loop

get_gg_name_size:
		bsr.w	get_gg_next_tag
		cmp.b	#GG_GG_END,d0
		beq.w	get_gg_list_exit
		cmp.b	#GG_ERROR,d0
		beq.w	get_gg_list_exit
		cmp.b	#GG_GAME_END,d0
		beq.s	get_gg_list_exit
		cmp.b	#GG_DESC,d0
		bne.s	get_gg_list_exit

		moveq.l	#0,d4
		move.l	a1,a0
		move.l	d1,d5

get_gg_name_size_loop:
		move.b	(a0)+,d7
		beq.s	get_gg_list_exit
		cmp.b	#$A,d7
		beq.s	get_gg_name_size_computed
		addq.l	#1,d4
		subq.l	#1,d5
		beq.s	get_gg_list_exit
		bra.s	get_gg_name_size_loop

get_gg_name_size_computed:
		tst.l	d4
		beq.s	get_gg_list_exit

		move.l	d4,-(SP)
		addq.l	#1,d4
		bsr.w	allocate_gg_linked_list_shell
		move.l	(SP)+,d4
		tst.l	d7
		beq.s	get_gg_list_exit

		move.l	d7,a0
		move.l	8(a0),a0
		move.l	a1,a3
get_gg_copy_name:
		move.b	(a3)+,(a0)+
		subq.l	#1,d4
		bne.s	get_gg_copy_name
		clr.b	(a0)

		move.l	d7,-(SP)
		bsr.w	get_gg_next_tag
		move.l	(SP)+,a0
		cmp.b	#GG_GG_END,d0
		beq.s	get_gg_list_exit
		cmp.b	#GG_ERROR,d0
		beq.s	get_gg_list_exit
		cmp.b	#GG_GAME_END,d0
		beq.s	get_gg_list_exit
		cmp.b	#GG_CODE,d0
		bne.s	get_gg_list_exit

		moveq.l	#3+1+3+1+3-1,d0
		move.l	d1,d4
		move.l	a1,a3
		add.l	#12,a0
get_gg_copy_code:
		move.b	(a3)+,(a0)+
		subq.l	#1,d4
		beq.s	get_gg_list_exit
		dbra	d0,get_gg_copy_code

		bra.w	get_gg_name_size		;next name.

get_gg_list_exit:
		move.l	gg_linked_list,d0
		beq.s	get_gg_list_exit_exit
		move.l	d0,a1
		move.l	4(a1),d0
		beq.s	get_gg_list_exit_exit
		move.l	d0,a1

		move.l	gg_linked_list_last_item,d0
		beq.s	get_gg_list_exit_exit
		move.l	d0,a2
		move.l	4(a2),d0
		beq.s	get_gg_list_exit_exit
		move.l	d0,a2

		move.l	gg_label_list,a6
		move.b	#1,gg_code_status

		move.l	a1,LH_HEAD(a6)
		move.l	a6,LN_PRED(a1)

		move.l	a2,LH_TAILPRED(a6)
		lea	LH_TAIL(a6),a5
		move.l	a5,LN_SUCC(a2)

		bra.s	get_gg_install_new_list
		ENDIF

get_gg_list_exit_exit:
		move.l	gg_dummy_item,a1
		move.l	gg_label_list,a6

		move.l	a1,LH_HEAD(a6)
		move.l	a6,LN_PRED(a1)

		move.l	#gg_dummy_item_txt,d0
		move.b	#2,gg_code_status

		IFEQ	GAMEBOY_USERS
		tst.b	key_status
		bne.s	get_gg_list_exit_exit_reg
		ENDIF

		move.l	#gg_dummy_item_register_txt,d0
		clr.b	gg_code_status

get_gg_list_exit_exit_reg:
		move.l	d0,LN_NAME(a1)
		move.l	a1,LH_TAILPRED(a6)
		lea	LH_TAIL(a6),a5
		move.l	a5,LN_SUCC(a1)

get_gg_install_new_list:
		cmp.l	#"MISC",function_status
		bne.s	get_gg_x

		move.l	misc_b_code_list,d0
		beq.s	get_gg_x
		move.l	d0,a0
		move.l	gad_tools_base,a6
		move.l	function_ptr,a1
		sub.l	a2,a2
		lea	misc_b_code_list_change_tags,a3
		move.l	gg_label_list,4(a3)
		jsr	GT_SetGadgetAttrsA(a6)

get_gg_x:	rts

get_gg_next_tag:move.b	-1(a1),d7
		lsl.w	#8,d7
		move.b	(a1)+,d7

		subq.l	#1,d1
		beq.w	get_gg_next_tag_error
		cmp.w	#$0A23,d7			;$A, '#'.
		beq.s	get_gg_next_tag_tag
		bra.s	get_gg_next_tag

get_gg_next_tag_tag:
		cmp.l	#'GG_B',(a1)
		bne.s	get_gg_next_tag_tag_1
		cmp.l	#'EGIN',4(a1)
		bne.s	get_gg_next_tag_tag_1
		move.b	#GG_GG_BEGIN,d0
		bra.s	get_gg_next_tag_tag_ok

get_gg_next_tag_tag_1:
		cmp.l	#'GAME',(a1)
		bne.s	get_gg_next_tag_tag_2
		cmp.l	#'_BEG',4(a1)
		bne.s	get_gg_next_tag_tag_2
		cmp.w	#'IN',8(a1)
		bne.s	get_gg_next_tag_tag_2
		move.b	#GG_GAME_BEGIN,d0
		bra.s	get_gg_next_tag_tag_ok

get_gg_next_tag_tag_2:
		cmp.l	#'NAME',(a1)
		bne.s	get_gg_next_tag_tag_3
		move.b	#GG_NAME,d0
		bra.s	get_gg_next_tag_tag_ok

get_gg_next_tag_tag_3:
		cmp.l	#'CODE',(a1)
		bne.s	get_gg_next_tag_tag_4
		move.b	#GG_CODE,d0
		bra.s	get_gg_next_tag_tag_ok

get_gg_next_tag_tag_4:
		cmp.l	#'DESC',(a1)
		bne.s	get_gg_next_tag_tag_5
		move.b	#GG_DESC,d0
		bra.s	get_gg_next_tag_tag_ok

get_gg_next_tag_tag_5:
		cmp.l	#'GAME',(a1)
		bne.s	get_gg_next_tag_tag_6
		cmp.l	#'_END',4(a1)
		bne.s	get_gg_next_tag_tag_6
		move.b	#GG_GAME_END,d0
		bra.s	get_gg_next_tag_tag_ok

get_gg_next_tag_tag_6:
		cmp.l	#'GG_E',(a1)
		bne.s	get_gg_next_tag_tag_7
		cmp.w	#'ND',4(a1)
		bne.s	get_gg_next_tag_tag_7
		move.b	#GG_GG_END,d0
		bra.s	get_gg_next_tag_tag_ok

get_gg_next_tag_tag_7:
		bra.w	get_gg_next_tag

get_gg_next_tag_tag_ok:
		move.b	(a1)+,d7
		subq.l	#1,d1
		beq.s	get_gg_next_tag_error
		cmp.b	#$A,d7
		bne.s	get_gg_next_tag_tag_ok
		rts

get_gg_next_tag_error:
		move.b	#GG_ERROR,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		free gg linked list
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

;		.L	= pointer to next item.
;		.L	= pointer to list item.
;		.L	= pointer to text.
;		.L*3	= game genie code.

free_gg_linked_list:
		cmp.l	#"MISC",function_status
		bne.s	free_gg_x

		move.l	misc_b_code_list,d0
		beq.s	free_gg_x
		move.l	d0,a0
		move.l	gad_tools_base,a6
		move.l	function_ptr,a1
		sub.l	a2,a2
		lea	misc_b_code_list_change_tags,a3
		clr.l	4(a3)				;detach!
		jsr	GT_SetGadgetAttrsA(a6)

free_gg_x:	move.l	gg_label_list,d0
		beq.s	get_gg_free_old_linked_list_start
		move.l	d0,a6
		clr.l	LH_HEAD(a6)
		clr.l	LH_TAILPRED(a6)

get_gg_free_old_linked_list_start:
		move.l	gg_linked_list,d6
		move.l	exec_base,a6

get_gg_free_old_linked_list:
		tst.l	d6
		beq.s	get_gg_linked_list_freed

		move.l	d6,a1
		move.l	(a1),d6
		move.l	4(a1),d5
		move.l	8(a1),d4
		jsr	FreeVec(a6)

		tst.l	d5
		beq.s	get_gg_free_1
		move.l	d5,a1
		jsr	FreeVec(a6)

get_gg_free_1:	tst.l	d4
		beq.s	get_gg_free_2
		move.l	d4,a1
		jsr	FreeVec(a6)

get_gg_free_2:	bra.s	get_gg_free_old_linked_list

get_gg_linked_list_freed:
		clr.l	gg_linked_list
		clr.l	gg_linked_list_last_item
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate a new shell to gg linked list
;		INPUT:
;		d4	= text size.
;		OUTPUT:
;		d7	= allocated shell.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

;		.L	= pointer to next item.
;		.L	= pointer to list item.
;		.L	= pointer to text.
;		.L*3	= game genie code.

allocate_gg_linked_list_shell:
		movem.l	d0-d6/a0-a6,-(SP)

		move.l	exec_base,a6
		moveq.l	#3*4+3*4,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1
		jsr	AllocVec(a6)
		tst.l	d0
		beq.w	allocate_gg_linked_list_shell_error

		move.l	d0,a5

		tst.l	gg_linked_list
		bne.s	allocate_gg_linked_list_another

		move.l	d0,gg_linked_list
		moveq.l	#0,d7
		bra.s	allocate_gg_linked_list_continue

allocate_gg_linked_list_another:
		move.l	gg_linked_list_last_item,a0
		move.l	d0,(a0)
		move.l	4(a0),d7

allocate_gg_linked_list_continue:
		move.l	a5,gg_linked_list_last_item
		clr.l	(a5)
		clr.l	4(a5)
		clr.l	8(a5)

		move.l	#LN_SIZE,d0
		addq.w	#2,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1
		jsr	AllocVec(a6)
		tst.l	d0
		beq.s	allocate_gg_linked_list_shell_error

		move.l	d0,4(a5)
		move.l	d0,a4

		tst.l	d7
		beq.s	allocate_gg_linked_list_no_succ
		move.l	d7,a0
		move.l	d0,LN_SUCC(a0)

allocate_gg_linked_list_no_succ:
		move.l	d4,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1
		jsr	AllocVec(a6)
		tst.l	d0
		beq.s	allocate_gg_linked_list_shell_error

		move.l	d0,8(a5)
		move.l	d0,LN_NAME(a4)

		tst.l	d7
		beq.s	allocate_gg_linked_list_no_pred
		move.l	d7,LN_PRED(a4)

allocate_gg_linked_list_no_pred:
		movem.l	(SP)+,d0-d6/a0-a6
		move.l	gg_linked_list_last_item,d7
		rts

allocate_gg_linked_list_shell_error:
		movem.l	(SP)+,d0-d6/a0-a6
		moveq.l	#0,d7
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		set & clear window pointer
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

set_window_pointer:
		tst.l	(a0)
		beq.s	set_window_pointer_exit

		move.l	intuition_base,a6
		move.l	(a0),a0
		lea	pause_pointer_tags,a1
		jsr	SetWindowPointerA(a6)

set_window_pointer_exit:
		rts

clear_window_pointer:
		tst.l	(a0)
		beq.s	clear_window_pointer_exit

		move.l	intuition_base,a6
		move.l	(a0),a0
		jsr	ClearPointer(a6)

clear_window_pointer_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu rom run
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_rom_run:	tst.b	cartridge_status
		bne.w	get_message

		tst.l	cartridge
		beq.w	get_message

		lea	menu_ptr,a0
		bsr.b	set_window_pointer
		lea	function_ptr,a0
		bsr.b	set_window_pointer
		lea	wzonka_ptr,a0
		bsr.b	set_window_pointer

		tst.b	old_render
		bne.s	menu_rom_run_no_aga
		tst.b	aga_status
		beq.w	get_message			;no aga available.

menu_rom_run_no_aga:
		lea	status_running_txt,a5
		bsr.w	print_status_middle
		IFNE	GFX_PROFILE
		bsr.w	gfx_profile_open
		ENDC

		tst.b	forbid_permit_status
		bne.s	no_forbid

		move.l	exec_base,a6
		jsr	Forbid(a6)

no_forbid:	

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		test cybergraphics screen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cmp.b	#2,old_render			;screen mode was checked at open.
		bne.s	no_cyber_graphics_screen
		move.l	pub_screen_lock,a0
		bsr.w	get_screen_cyber_status

no_cyber_graphics_screen:
		move.l	cartridge,a0
		bsr.w	compute_jmp_lst			;create the mem jump table.

		bsr.w	turn_ahi_on			;on with the music.
		bsr.w	do_pen_table
		bsr.w	screen_empty			;empty the buffer.
		clr.b	output_bit			;for frame skipping.

		IFEQ	GAMEBOY_USERS
		moveq.l	#0,d1
		move.b	sfx_y_update,d1
		addq.b	#1,d1
		swap	d1
		divu.l	#60,d1
		move.l	d1,sfx_y_adder
		move.l	#$10000,sfx_y_actual_value	;init the counter (y mode).
		ENDIF

		cmp.b	#1,old_render			;screen mode?
		bne.s	no_scr_front			;nope.

		move.l	intuition_base,a6
		move.l	gb_screen_ptr,a0		;the screen.
		jsr	ScreenToFront(a6)		;bring it near.
no_scr_front:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate controller resources
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	joy_item_list,a0
		moveq.l	#0,d0
		move.b	keystick,d0
		move.b	(a0,d0.l),d1			;keyboard?
		beq.s	keyb_alloc
		cmp.b	#1,d1				;cd³² pad?
		beq.s	cd32_alloc
		cmp.b	#2,d1				;sega 4 button pad?
		beq.s	sega_4b_alloc
		cmp.b	#3,d1				;sega 2 button pad?
		beq.s	sega_2b_alloc
		cmp.b	#4,d1				;1b joystick?
		beq.s	joystick_alloc
		cmp.b	#5,d1				;2b joystick?
		beq.s	joystick_alloc

cd32_alloc:	move.l	exec_base,a6
		lea	low_level_name,a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		move.l	d0,low_level_base
		bra.s	control_a_done

sega_4b_alloc:	bsr.b	sega_alloc			;sega routines
		bra.s	control_a_done			;and nothing else.

sega_2b_alloc:	bsr.b	sega_alloc			;sega routines
		bsr.b	keyb_init_yes			;and the keyboard routines.
		bra.s	control_a_done

keyb_alloc:	bsr.b	keyb_init_yes
		bra.s	control_a_done

joystick_alloc:	bsr.b	keyb_init_yes
		bra.s	control_a_done

sega_alloc:	move.l	exec_base,a6
		lea	control_pad_name,a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		move.l	d0,control_pad_base
		beq.s	no_cp_allocx

		move.l	d0,a6
		move.b	#CPU_JOYPORT,d0			;joyport only.
		jsr	cpAlloc(a6)			;allocate the port.
		move.l	d0,cp_handle			;controlpad handler.
no_cp_allocx:	rts

keyb_init_yes:	move.l	exec_base,a6
		move.l	keyboard_io,a1
		move.w	#KBD_READMATRIX,IO_COMMAND(a1)	;read events.
		move.b	#IOB_QUICK,IO_FLAGS(a1)
		move.l	keyboard_matrix,IO_DATA(a1)
		move.l	#16,IO_LENGTH(a1)
		moveq.l	#0,d0
		moveq.l	#0,d1
		lea	keyboard_device_name,a0
		jsr	OpenDevice(a6)
		rts
control_a_done:	

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		possible aga preparations
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	aga_sprs_cI,a0			;set the lists to clear
		move.l	aga_sprs_cII,a1			;the sprite planes.
		move.l	aga_sprs_cxI,a2
		move.l	aga_sprs_cxII,a3
		moveq.l	#256/4-1,d0
set_to_clear:	move.l	#$01010101,(a0)+
		move.l	#$01010101,(a1)+
		move.l	#$01010101,(a2)+
		move.l	#$01010101,(a3)+
		dbra	d0,set_to_clear

		tst.b	old_render			;aga mode?
		bne.w	no_aga_init			;nope.

		move.l	aga_scr_cI,a0
		tst.b	old_refresh			;144/144 mode?
		beq.s	yes_144_144			;yep.
		move.w	#$ffff,(a0)
		bra.s	c_end_fix_done
yes_144_144:	move.w	#$2d11,(a0)

c_end_fix_done:	bsr.w	compute_aga_bg			;compute the colour tables.
		bsr.w	compute_aga_spr

		move.l	graphics_base,a6
	        move.l  $22(a6),old_wb_view		;store current view.
		move.l 	38(a6),old_copper
		move.w	dmaconr+$dff000,old_dmareq

		move.l	aga_map_I,d0
		move.l	aga_pln_cI,a0
		moveq.l	#8-1,d1
		moveq.l	#40,d2				;modulus.
		bsr.w	load_bitplanes			;load planes.

		move.l	aga_spr_Ix,a0
		move.l	aga_spr_IIx,a1
		move.l	aga_spr_IIIx,a2
		move.w	#20,(a0)
		move.w	#144*256,8(a0)
		move.w	#20,(a1)
		move.w	#144*256,8(a1)
		move.w	#20,(a2)
		move.w	#144*256,8(a2)
		add.l	#16,a0
		add.l	#16,a1
		add.l	#16,a2
		move.w	#144*2*2-1,d0
		move.l	#$ffffffff,d1
make_mask_sprs:	move.l	d1,(a0)+
		move.l	d1,(a1)+
		move.l	d1,(a2)+
		dbra	d0,make_mask_sprs

		move.l	aga_spr_cI,a0
		move.l	aga_spr_empty,a1
		move.w	#20,(a1)
		move.w	#1*256,8(a1)
		moveq.l	#8-1,d0
		move.l	a1,d1
sprite_null_ptr:move.w	d1,6(a0)
		swap	d1
		move.w	d1,2(a0)
		swap	d1
		addq.l	#8,a0
		dbra	d0,sprite_null_ptr

		move.l	aga_spr_cI,a0			;output.
		add.l	#8*4,a0
		lea	aga_spr_Ix,a1
		moveq.l	#3-1,d0
load_mask_ptrs:	move.l	(a1)+,d1
		move.w	d1,6(a0)
		swap	d1
		move.w	d1,2(a0)
		addq.l	#8,a0
		dbra	d0,load_mask_ptrs

		lea	aga_spr_Ia,a0
		moveq.l	#6-1,d0
hide_sprites:	move.l	(a0)+,a1
		move.w	#20,(a1)
		dbra	d0,hide_sprites

		move.l	intuition_base,a6
		sub.l	a0,a0				;no newscreen structure.
		lea	block_screen_taglist,a1		;only tagitems. 

		tst.b	aga_mode
		beq.s	aga_mode_pal
aga_mode_ntsc:	move.l	#NTSC_MONITOR_ID!LORES_KEY,block_screen_id+4
		bra.s	aga_mode_done
aga_mode_pal:	move.l	#PAL_MONITOR_ID!LORES_KEY,block_screen_id+4

aga_mode_done:	jsr	OpenScreenTagList(a6)
		move.l	d0,block_screen_ptr
;		beq.w	quit_db

		move.l	dos_base,a6
		moveq.l	#2,d1
		jsr	Delay(a6)

		move.l  graphics_base,a6
;		sub.l	a1,a1
;		jsr	LoadView(a6)			;flush view to nothing.
		jsr	WaitTOF(a6)			;wait once.
		jsr	WaitTOF(a6)			;wait again.
		move.l	copper_I,cop1lc+$dff000		;install copper list.

		move.l	copper_II,copper_inactive
		move.l	aga_map_II,aga_map_inactive
		move.l	aga_ro_list_II,aga_ro_inactive
		move.l	#bg_scroll_y_II,bg_scroll_inactive
		move.l	#aga_spr_Ib,aga_spr_inactive_pointer
		clr.b	aga_palette_byte		;start palette = 00.

		move.l	exec_base,a6
		lea	get_vbr,a5			;the subroutine.
		jsr	Supervisor(a6)			;enter supervisor!
		bra.s	vbr_obtained			;fetch completed.

get_vbr:	movec	VBR,d0				;take the pointer.
		move.l	d0,vbr_pointer			;store the pointer.
		rte					;exit supervisor.

vbr_obtained:	move.l	vbr_pointer,a0			;from memory with love.
		move.l	$6c(a0),old_vbr			;take the old.
   		move.l	#vbr_interrupt,$6c(a0)		;install an interrupt.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		normal procedures before starting the game
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

no_aga_init:	move.l	aga_sprs_cxII,aga_sprs_inactive_x
		move.l	aga_sprs_cII,aga_sprs_inactive	;this one is universally
							;used.
		clr.b	lcd_blank_presented
		move.l	exec_base,a6
		jsr	CacheClearU(a6)			;clear the cache first.

		tst.b	new_load
		beq.s	no_new_load			;using an old rom image.

		clr.b	new_load
		bsr.w	run_cartridge			;run the cartridge!

		bra.s	back_to_menu
no_new_load:	clr.b	input_status			;clear the pause flag.
		bsr.w	cartridge_loop			;run the cartridge!

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		game has been paused - return to the normal order via
;		these small routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

back_to_menu:	bsr.w	turn_ahi_off			;turn off the sounds.
		IFNE	GFX_PROFILE
		bsr.w	gfx_profile_report
		ENDC

		lea	status_paused_txt,a5
		bsr.w	print_status_middle

		lea	menu_ptr,a0
		bsr.w	clear_window_pointer
		lea	function_ptr,a0
		bsr.w	clear_window_pointer
		lea	wzonka_ptr,a0
		bsr.w	clear_window_pointer

		lea	joy_item_list,a0
		moveq.l	#0,d0
		move.b	keystick,d0
		move.b	(a0,d0.l),d1
		beq.s	keyb_return			;keyboard.
		cmp.b	#1,d1				;cd³² joypad?
		beq.s	cd32_return
		cmp.b	#2,d1				;sega 4 button pad?
		beq.s	sega_4b_return
		cmp.b	#3,d1				;sega 2 button pad?
		beq.s	sega_2b_return
		cmp.b	#4,d1				;1b joystick?
		beq.s	joystick_return		
		cmp.b	#5,d1				;2b joystick?
		beq.s	joystick_return		

		bra.w	get_message			;the others - do nothing.

cd32_return:	move.l	exec_base,a6
		move.l	low_level_base,d0
		beq.w	get_message
		move.l	d0,a1
		jsr	CloseLibrary(a6)
		bra.w	get_message

sega_4b_return:	bsr.b	sega_return			;free sega resources.
		bra.w	get_message

sega_2b_return:	bsr.b	keyb_free_yes			;free keyboard and
		bsr.b	sega_return			;sega resources.
		bra.w	get_message

keyb_return:	bsr.b	keyb_free_yes
		bra.w	get_message

joystick_return:bsr.b	keyb_free_yes
		bra.w	get_message

sega_return:	move.l	control_pad_base,d0		;sega controller.
		beq.w	sega_xit
		move.l	d0,a6
		move.l	cp_handle,a0
		jsr	cpFree(a6)			;free the allocated info
							;block area.
		move.l	control_pad_base,a1
		move.l	exec_base,a6
		jsr	CloseLibrary(a6)
		clr.l	control_pad_base
sega_xit:	rts

keyb_free_yes:	move.l	exec_base,a6			;keyboard controller fix.
		move.l	keyboard_io,a1
		jsr	_LVOAbortIO(a6)

		move.l	keyboard_io,a1
		jsr	CloseDevice(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		compute an aga h/w colour tables
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

compute_aga_bg:	move.l	aga_col_bg,a0
		lea	gameboy_colours,a1
		bra.s	create_colours

compute_aga_spr:move.l	aga_col_sprs,a0
		lea	gameboy_colours+4*4,a1

create_colours:	moveq.l	#0,d0
create_colour:	move.l	d0,d1
		and.b	#%11,d1
		bsr.b	create_col			;colour 0.
		move.l	d0,d1
		and.b	#%1100,d1
		lsr.b	#2,d1
		bsr.b	create_col			;colour 1.
		move.l	d0,d1
		and.b	#%110000,d1
		lsr.b	#4,d1
		bsr.b	create_col			;colour 2.
		move.l	d0,d1
		lsr.b	#6,d1
		bsr.b	create_col			;colour 3.

		cmp.b	#$ff,d0
		beq.s	compute_exit
		addq.b	#1,d0
		bra.b	create_colour
compute_exit:	rts

create_col:	lea	(a1,d1.l*4),a2			;a2 = colour values.
		move.b	1(a2),d2			;d2 = r.
		move.b	2(a2),d3			;d3 = g.
		move.b	3(a2),d4			;d4 = b.

		moveq.l	#0,d5
		move.b	d2,d5
		lsl.w	#4,d5
		move.b	d3,d5
		move.b	d4,d6
		lsr.b	#4,d6
		and.b	#%11110000,d5
		or.b	d6,d5				;d5 = rgb (h).
		move.w	d5,(a0)+

		and.b	#%00001111,d2
		lsl.w	#8,d2
		move.b	d3,d2
		lsl.b	#4,d2
		and.b	#%00001111,d4
		or.b	d4,d2				;d2 = rgb (l).
		move.w	d2,(a0)+
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate a double buffered game screen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_screen_cyber_status:
		clr.l	output_cyber_status
		tst.l	cyber_base
		beq.s	screen_cyber_status_done

		lea	sc_ViewPort(a0),a0
		move.l	graphics_base,a6
		jsr	GetVPModeID(a6)

		move.l	cyber_base,a6
		jsr	IsCyberModeID(a6)
		move.l	d0,output_cyber_status
screen_cyber_status_done:
		rts

dbuf_alloc:	clr.b	gb_buffer_no
		move.l	gb_bmap_I,a0
		move.l	gb_bplanes_I,a1			;planes.
		bsr.w	dbuf_init

		move.l	gb_bmap_II,a0
		move.l	gb_bplanes_II,a1		;planes.
		bsr.w	dbuf_init

		move.l	gb_bplanes_I,a0
		move.l	a0,bitmap_bg			;background.
		add.l	d0,a0				;to bitmap 1 (0, 1, 2, 3).
		add.l	d0,a0				;to bitmap 2 (0, 1, 2, 3).
		move.l	a0,bitmap_spc			;sprites.

		move.l	graphics_base,a6
		move.l	gb_rport_I,a1
		jsr	InitRastPort(a6)
		move.l	gb_rport_II,a1
		jsr	InitRastPort(a6)

		move.l	gb_rport_I,a0
		move.l	gb_bmap_I,rp_BitMap(a0)
		move.l	gb_rport_II,a0
		move.l	gb_bmap_II,rp_BitMap(a0)

		tst.l	output_cyber_status
		bne.w	alloc_cyber_screen_data

dbuf_alloc_done:moveq.l	#0,d0				;no errors.
		rts

quit_db:	moveq.l	#1,d0				;error!
		rts

dbuf_init:	tst.b	old_refresh			;mode 144/144?
		bne.s	normal_dbuf			;no.
		move.l	#160/8*144,d0			;yes.
		move.l	#160,d1
		move.l	#144,d2
		bra.s	dbuf_init_ok
normal_dbuf:	move.l	#gb_screen_x/8*gb_screen_y,d0
		move.l	#gb_screen_x,d1			;width.
		move.l	#gb_screen_y,d2			;height.

dbuf_init_ok:	move.l	d0,-(SP)			;for the pointers.

		lea	bm_Planes(a0),a2
		move.l	a1,a5
		move.l	a1,(a2)+
		add.l	d0,a1
		move.l	a1,(a2)+
		add.l	d0,a1
		move.l	a1,(a2)+
		add.l	d0,a1
		move.l	a1,(a2)				;stored the all pointers.

		move.l	d0,d7
		subq.l	#1,d7
dbuf_clear:	clr.l	(a5)+
		dbra	d7,dbuf_clear			;clear buffer.

		move.l	graphics_base,a6
		moveq.l	#4,d0				;depth.
		jsr	InitBitMap(a6)			;init the structure.

		move.l	(SP)+,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		center screen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

center_screen:	clr.l	gb_taglist_x+4

		move.l	graphics_base,a6
		move.l	gb_screen_id+4,d0
		jsr	FindDisplayInfo(a6)
		move.l	d0,display_info_handle
		beq.s	center_screen_exit

		move.l	d0,a0
		move.l	dimension_info,a1
		move.l	#dim_SIZEOF,d0
		move.l	#DTAG_DIMS,d1
		move.l	gb_screen_id,d2
		jsr	GetDisplayInfoData(a6)
		tst.l	d0
		beq.s	center_screen_exit

		moveq.l	#0,d0
		move.l	dimension_info,a0
		lea	dim_StdOScan(a0),a0
		move.w	ra_MaxX(a0),d0
		sub.w	#160,d0
		lsr.w	#1,d0

		move.l	d0,gb_taglist_x+4

center_screen_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate and initialize data structures for
;		a cybergraphics screen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

alloc_cyber_screen_data:
		move.l	game_tmp_rast_port,a1
		move.l	graphics_base,a6
		jsr	InitRastPort(a6)
		move.l	#160,d0
		tst.b	old_refresh			;mode 144/144?
		beq.s	no_value_fix			;yes.
		move.l	#gb_screen_x,d0
no_value_fix:	moveq.l	#1,d1
		moveq.l	#4,d2
		moveq.l	#0,d3
		sub.l	a0,a0
		jsr	AllocBitMap(a6)
		move.l	d0,cyber_tmp_read_bitmap
		beq.w	quit_db

		move.l	game_tmp_rast_port,a1
		clr.l	rp_Layer(a1)
		move.l	d0,rp_BitMap(a1)
		bra.w	dbuf_alloc_done

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		free screen buffers and a screen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

dbuf_dealloc:	lea	cyber_tmp_read_bitmap,a1
		bsr.w	free_bit_maps
		move.l	intuition_base,d0
		beq.s	quit_gb_scr
		move.l	d0,a6
		move.l	gb_screen_ptr,d0
		beq.s	quit_gb_scr			;no screen opened.
		move.l	d0,a0
		jsr	CloseScreen(a6)
		clr.l	gb_screen_ptr

quit_gb_scr:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		different sized input buffers for graphics data
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

init_wzonka_176:move.l	graphics_base,a6
		move.l	game_rast_port,a1
		jsr	InitRastPort(a6)

		move.l	game_rast_port,a0
		move.l	game_tmp_rast_port,a1
		bsr.w	copy_rast_port

		move.l	wzonka_map,bitmap_bg		;planes 0 and 1.
		move.l	wzonka_map,bitmap_spc		;sprite planes (2 and 3).
		add.l	#gb_screen_x/8*gb_screen_y*2,bitmap_spc

		move.l	wzonka_map_attr,a0
		lea	bm_Planes(a0),a0		;plane pointers.
		move.l	bitmap_bg,a1
		move.l	#gb_screen_x/8*gb_screen_y,d0
		bsr.w	init_bitmap

		move.l	graphics_base,a6
		move.l	wzonka_map_attr,a0
		moveq.l	#4,d0				;depth.
		move.l	#gb_screen_x,d1			;width.
		move.l	#gb_screen_y,d2			;height.
		jsr	InitBitMap(a6)			;init the structure.

		move.l	#gb_screen_x,d0
		move.l	wzonka_map_attr,a4
		lea	game_tmp_map_attr,a5
		bsr.w	alloc_bit_map_other

		move.l	d0,a0
		move.w	#gb_screen_x/8,bm_BytesPerRow(a0)
		move.w	#1,bm_Rows(a0)

		move.l	game_rast_port,a0
		move.l	wzonka_map_attr,rp_BitMap(a0)
		move.l	game_tmp_rast_port,a0
		move.l	game_tmp_map_attr,rp_BitMap(a0)
		clr.l	rp_Layer(a0)

		bra.w	allocate_window_output

init_wzonka_160:move.l	graphics_base,a6
		move.l	game_rast_port,a1
		jsr	InitRastPort(a6)

		move.l	game_rast_port,a0
		move.l	game_tmp_rast_port,a1
		bsr.w	copy_rast_port

		move.l	wzonka_map,bitmap_bg		;planes 0 and 1.
		move.l	wzonka_map,bitmap_spc		;sprite planes (2 and 3).
		add.l	#160/8*144*2,bitmap_spc

		move.l	wzonka_map_attr,a0
		lea	bm_Planes(a0),a0		;plane pointers.
		move.l	bitmap_bg,a1
		move.l	#160/8*144,d0
		bsr.w	init_bitmap

		move.l	graphics_base,a6
		move.l	wzonka_map_attr,a0
		moveq.l	#4,d0				;depth.
		move.l	#160,d1				;width.
		move.l	#144,d2				;height.
		jsr	InitBitMap(a6)			;init the structure.

		move.l	#160,d0
		move.l	wzonka_map_attr,a4
		lea	game_tmp_map_attr,a5
		bsr.w	alloc_bit_map_other
		tst.l	d0
		beq.w	quit

		move.l	d0,a0
		move.w	#160/8,bm_BytesPerRow(a0)
		move.w	#1,bm_Rows(a0)

		move.l	game_rast_port,a0
		move.l	wzonka_map_attr,rp_BitMap(a0)
		move.l	game_tmp_rast_port,a0
		move.l	game_tmp_map_attr,rp_BitMap(a0)
		clr.l	rp_Layer(a0)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		init new bit maps for the output routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

allocate_window_output:
		bsr.w	init_window_readback_table
		move.l	wzonka_ptr,a0
		move.l	wd_RPort(a0),a0
		move.l	game_output_tmp_rast_port,a1
		bsr.w	copy_rast_port

		move.l	wzonka_game_x,d0
		tst.b	scaling_status
		beq.s	allocate_window_output_bitmap
		move.l	#window_max_game_x,d0		;one row; width changes need no reallocation.
allocate_window_output_bitmap:
		move.l	wzonka_ptr,a4
		move.l	wd_RPort(a4),a4
		move.l	rp_BitMap(a4),a4
		lea	game_output_tmp_map_attr,a5
		bsr.w	alloc_bit_map_other
		tst.l	d0
		beq.w	quit

		move.l	d0,a0
		move.l	wzonka_game_x,d0
		lsr.l	#3,d0
		move.w	d0,bm_BytesPerRow(a0)
		move.w	#1,bm_Rows(a0)

		move.l	game_output_tmp_rast_port,a0
		move.l	game_output_tmp_map_attr,rp_BitMap(a0)
		clr.l	rp_Layer(a0)
		rts

init_bitmap:	moveq.l	#4-1,d7
init_bitmap_n:	move.l	a1,(a0)+
		add.l	d0,a1
		dbra	d7,init_bitmap_n
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		create copper lists for AGA modes
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

create_coppers:	move.l	copper_I,a0
		lea	aga_copper,a2

		move.w	#(aga_scr_0-aga_copper),d0
		bsr.b	copy_copper_d
		move.l	a0,aga_scr_0_cI

		move.w	#(aga_col-aga_scr_0),d0
		bsr.b	copy_copper_d
		move.l	a0,aga_col_cI

		move.w	#(spr_col-aga_col),d0
		bsr.b	copy_copper_d
		move.l	a0,aga_hw_spr_cI

		move.w	#(aga_sprites-spr_col),d0
		bsr.b	copy_copper_d
		move.l	a0,aga_spr_cI

		move.w	#(aga_planes-aga_sprites),d0
		bsr.b	copy_copper_d
		move.l	a0,aga_pln_cI

		move.w	#(aga_scr_x-aga_planes),d0
		bsr.b	copy_copper_d
		move.l	a0,aga_scr_cI

		move.w	#144-1,d0
		move.w	#$2d11,d1
create_rasters:	move.w	d1,(a0)+
		move.w	#$fffe,(a0)+
		move.w	#bplcon1,(a0)+
		clr.w	(a0)+
		add.w	#$100,d1			;next raster line.
		dbra	d0,create_rasters

		move.l	#$fffffffe,(a0)			;the end.
		rts

copy_copper_d:	lsr.w	#2,d0
		subq.w	#1,d0
copy_copper_dat:move.l	(a2)+,(a0)+
		dbra	d0,copy_copper_dat
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu rom info
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_rom_info:	bsr.w	function_window_output
		tst.l	d0
		beq.w	get_message

		cmp.l	#"INFO",function_status
		beq.w	get_message			;don't output this twice.

		bsr.w	gadgets_rmv

		move.l	graphics_base,a6
		move.l	info_map_attr,a0		;a0 = source bitmap.
		move.l	function_ptr,a1
		move.l	wd_RPort(a1),a1			;a1 = destination rastport.
		moveq.l	#0,d0				;org x.
		moveq.l	#0,d1				;org y.
		moveq.l	#0,d2				;dst x.
		moveq.l	#0,d3				;dst y.
		move.l	#function_x_bm,d4		;size x.
		move.l	#function_y_bm,d5		;size y.
		move.l	#$c0,d6				;minterm.
		jsr	BltBitMapRastPort(a6)		;update the screen window.

		move.l	#"INFO",function_status
		bsr.w	do_info

		lea	info_win_txt,a1
		bsr.w	change_win_title

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		fill the information form
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

do_info:	tst.l	cartridge
		beq.w	do_info_text			;no changes.

		clr.w	d6
		bsr.w	info_text_out			;clear the old texts.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		examine the cartridge and find the essential information
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		clr.b	cartridge_status
		move.l	cartridge,a0
		lea	rom_table,a2
		moveq.l	#0,d0
		move.b	$148(a0),d0			;d0 = rom size.
		cmp.w	#9,d0
		blt.s	rom_size_ok

		cmp.b	#$52,d0
		bne.s	rom_no_52
		move.b	#10,d0
		bra.s	rom_size_ok
rom_no_52:	cmp.b	#$53,d0
		bne.s	rom_no_53
		move.b	#11,d0
		bra.s	rom_size_ok
rom_no_53:	cmp.b	#$54,d0
		bne.s	rom_no_54
		move.b	#11,d0
		bra.s	rom_size_ok
rom_no_54:	move.b	#9,d0				;illegal rom size!
		move.b	#1,cartridge_status		;error!!!
rom_size_ok:	lea	rom_banks_list,a5
		move.l	(a5,d0.w*4),rom_banks_mask
		move.l	(a2,d0.l*4),d2			;d2 = rom size text.
		move.b	$149(a0),d0			;d0 = ram size.
		moveq.l	#0,d5
		lea	ram_banks_list,a1
		move.b	(a1,d0.l),d5
		move.l	d5,ram_banks
		lea	ram_banks_mask_list,a1
		move.b	(a1,d0.l),d5
		move.l	d5,ram_banks_mask
		lea	ram_table,a1
		cmp.w	#5,d0
		blt.s	ram_size_ok
		move.b	#5,d0				;illegal ram size!
		move.b	#1,cartridge_status		;error!!!
ram_size_ok:	move.l	(a1,d0.l*4),d3			;d3 = ram size text.

		move.b	$147(a0),d0			;d0 = cartridge type.
		move.l	#map_inv,battery_ptr

		cmp.b	#$ff,d0
		bne.s	no_huc1_d
		move.l	#map_ff,battery_ptr
		bra.s	mapper_done

no_huc1_d:	cmp.b	#$fe,d0
		bne.s	no_huc3_d
		move.l	#map_fe,battery_ptr
		bra.s	mapper_done

no_huc3_d:	cmp.b	#$fd,d0
		bne.s	no_tama5_d
		move.l	#map_fd,battery_ptr
		bra.s	mapper_done

no_tama5_d:	cmp.w	#$1f,d0
		bgt.s	mapper_done

		lea	mapper_table,a5
		move.l	(a5,d0.l*4),battery_ptr

mapper_done:	cmp.l	#map_inv,battery_ptr
		bne.s	mapper_id_ok
		move.b	#1,cartridge_status

mapper_id_ok:	add.l	#$134,a0			;a0 = name.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		identify MBC3-mappers
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		clr.b	mbc3_existence
		cmp.w	#$f,d0
		blt.s	no_mbc3_in_use
		cmp.w	#$13,d0
		bgt.s	no_mbc3_in_use
		move.b	#1,mbc3_existence

no_mbc3_in_use:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		check nintendo logo existence
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		lea	info_txt_2,a6
		moveq.l	#$133-$104,d0
		move.l	cartridge,a2
		add.l	#$104,a2
nintendo_logo_area_test:
		tst.b	(a2)+
		bne.s	nintendo_logo_area_filthy	;not a zero!
		dbra	d0,nintendo_logo_area_test

nintendo_logo_area_clean:
		move.l	#"FAN ",(a6)+
		move.l	#"SOFT",(a6)+
		move.l	#"WARE",(a6)+
		clr.b	(a6)
		bra.s	nintendo_logo_area_done

nintendo_logo_area_filthy:
		move.l	#"LICE",(a6)+
		move.l	#"NSED",(a6)+
		move.l	#" SOF",(a6)+
		move.l	#"TWAR",(a6)+
		move.w	#"E?",(a6)+
		clr.b	(a6)

nintendo_logo_area_done:
		move.l	d2,rom_ptr			;store the pointers.
		move.l	d3,ram_ptr

		lea	info_txt_1,a2			;cart name.
		moveq.l	#16-1,d2
		move.b	#'"',(a2)+
		move.l	a2,a0
		bsr.w	copy_rom_name_to_a0
		move.l	a0,a2
		move.w	#'" ',(a2)+

		move.l	cartridge,a0
		cmp.b	#$80,$143(a0)
		beq.s	support_cgb
		cmp.b	#$03,$146(a0)
		beq.s	support_sgb
support_dmg:	move.l	#"(GB)",(a2)+
		bra.s	support_done
support_sgb:	move.l	#"(SGB",(a2)+
		move.b	#")",(a2)+
		bra.s	support_done
support_cgb:	move.l	#"(CGB",(a2)+
		move.b	#")",(a2)+

support_done:	clr.b	(a2)				;the end of the name.
		bra.s	do_info_text

compute_rom_checksum:
		move.l	cartridge,a0
		add.l	#$134,a0
		moveq.l	#$14d-$134-1,d0
		moveq.l	#0,d1

compute_rom_checksum_compute:
		add.b	(a0)+,d1
		dbra	d0,compute_rom_checksum_compute

		add.b	#25,d1
		beq.s	rom_checksum_ok
		move.b	#1,cartridge_status

rom_checksum_ok:
do_info_x:	rts					;no. quit.

do_info_text:	move.w	#$0100,d6
		bsr.w	info_text_out
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		output the cartridge info texts
;		INPUT:
;		d6	= $0100/$0000.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

info_text_out:	cmp.l	#"INFO",function_status
		bne.w	info_text_out_x			;no output.

		lea	info_text_list,a5
		moveq.l	#5-1,d7
info_text_clr:	move.l	(a5)+,a4
		move.w	d6,(a4)				;new colours.
		move.l	a4,a0
		bsr.w	print_middle
		dbra	d7,info_text_clr
info_text_out_x:rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu gbs load
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_gbs_load:
		IFEQ	GAMEBOY_USERS

		bsr.b	gbs_load_get_name
		tst.l	d0
		beq.w	get_message

		bsr.w	gbs_load
		ENDIF
		bra.w	get_message

runtime_gbs_load:
		IFEQ	GAMEBOY_USERS

		tst.b	key_status
		beq.s	runtime_gbs_load_exit

		movem.l	d0-d7/a0-a6,-(SP)

		move.l	dir_n_name_ptr,a0		;the name of the file.
		move.l	#"T:Wz",(a0)+
		move.l	#"onka",(a0)+
		move.l	#"-Lad",(a0)+
		move.l	#".RT.",(a0)+
		move.w	#"GB",(a0)+
		move.b	#"S",(a0)+
		move.b	gbs_file_id,(a0)+
		clr.b	(a0)

		bsr.w	gbs_load

		move.l	key_file,a6
		add.l	key_serial_area(a6),a6
		jsr	(a6)

		bsr.w	init_the_sound_registers

		movem.l	(SP)+,d0-d7/a0-a6

		ENDIF

runtime_gbs_load_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		gbs load routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS
gbs_load_get_name:
		move.l	key_file,a0
		add.l	key_serial_area(a0),a0
		jsr	(a0)

		move.l	req_tools_base,a6
		lea	req_tags,a0			;the tags.
		move.l	menu_ptr,4(a0)			;the position pointer.
		move.l	request_ptr_ss,a1		;the requester pointer.
		move.l	name_ptr,a2			;the output area.
		lea	request_lsshot,a3		;the title text.
		jsr	rtFileRequestA(a6)		;open a file requester.

		move.l	request_ptr_ss,a2		;directory.
		move.l	rtfi_Dir(a2),a2
		move.l	def_ss_dir,a0
		bsr.w	memorize_dir			;memorize the dir.

		tst.l	d0
		beq.s	gbs_error_no_select		;error! none selected!

		move.l	request_ptr_ss,a2		;directory.
		bsr.w	parse_req_name
		moveq.l	#1,d0

gbs_error_no_select:
		rts

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		find out if the file can be unpacked with xpk master
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS
gbs_load:	move.l	xpk_master_base,d0
		beq.w	no_xpk_lss
		move.l	d0,a6
		lea	xfh_pointer,a0
		lea	xpk_in_tags,a1
		move.l	dir_n_name_ptr,4(a1)
		jsr	XpkOpen(a6)
		tst.l	d0
		bne.w	no_xpk_lss

		bsr.w	get_packer_name

		move.l	xfh_pointer,a0			;a0 = xpkfib structure.
		move.l	xf_Type(a0),d0			;d0 = file type.
		cmp.l	#XPKTYPE_PACKED,d0		;is it packed?
		bne.w	quit_xpk_lss			;no. it's something else.

		move.l	xf_ULen(a0),d0
		cmp.l	#$8000+$8000+1024,d0
		bgt.w	quit_lss_e			;too big a file!

		move.l	d0,file_length			;uncompressed length.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		unpack the snapshot file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	xfh_pointer,a0
		jsr	XpkClose(a6)

		move.l	dos_base,a6			;open the data file.
		move.l	dir_n_name_ptr,d1		;the name of the file.
		move.l	#Mode_Old,d2
		jsr	Open(a6)			;narsk.
		move.l	d0,file_hd
		beq.w	ssload_error_file_not_found	;file error!

		lea	status_xpk_unpack_txt,a5
		bsr.w	print_status_middle

		move.l	xpk_master_base,a6
		lea	xpk_unp_tags,a0
		move.l	file_hd,4(a0)
		move.l	snapshot_area,12(a0)
		move.l	#$2000*16+$8000+1024+XPK_MARGIN,20(a0)
							;output area length.
		jsr	XpkUnpack(a6)
		tst.l	d0
		bne.s	xpk_argh_lss			;error here!

		move.l	dos_base,a6
		move.l	file_hd,d1
		jsr	Close(a6)			;click.

		bra.w	load_ok_lss

xpk_argh_lss:	move.l	dos_base,a6
		move.l	file_hd,d1
		jsr	Close(a6)			;click.

		move.l	xpk_master_base,a6		;an error occurred!
		move.l	xfh_pointer,a0
		jsr	XpkClose(a6)

		bra.w	ssload_error_xpk_error

quit_lss_e:	move.l	xpk_master_base,a6		;an error occurred!
		move.l	xfh_pointer,a0
		jsr	XpkClose(a6)

		bra.w	ssload_error_too_big_a_file

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		normal dos open and loading
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

quit_xpk_lss:	move.l	xpk_master_base,a6
		move.l	xfh_pointer,a0			;it was not packed.
		jsr	XpkClose(a6)

no_xpk_lss:	move.l	dos_base,a6
		move.l	dir_n_name_ptr,d1
		moveq.l	#ACCESS_READ,d2
		jsr	Lock(a6)
		move.l	d0,file_hd
		beq.w	ssload_error_file_not_found

		move.l	file_info_ptr,d2
		move.l	d0,d1
		jsr	Examine(a6)

		move.l	file_hd,d1
		jsr	UnLock(a6)

		move.l	file_info_ptr,a0
		move.l	fib_Size(a0),snapshot_size

		move.l	dir_n_name_ptr,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,file_hd
		beq.w	ssload_error_file_not_found

		move.l	d0,d1
		move.l	snapshot_area,d2
		move.l	snapshot_size,d3
		cmp.l	#$2000*16+$8000+1024,d3
		bgt.w	ssload_error
		jsr	Read(a6)

		move.l	file_hd,d1
		jsr	Close(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		move the data from snapshot to gameboy
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_ok_lss:	move.l	snapshot_area,a0
		lea	z80_registers,a1

		move.b	(a0)+,z80_halt
;		move.b	(a0)+,i_1			;old interrupt level
;		move.b	(a0)+,i_2			;signal bytes.
;		move.b	(a0)+,i_3
		addq.l	#3,a0

		addq.l	#4,a1				;skip code pointer     (a0).
		move.l	#z80_optcode_00,(a1)+		;xx optcodes           (a1).
		move.l	gb_memory,(a1)+			;pointer to pseudo ram (a2).
		move.l	a1,a3
		addq.l	#4,a1				;skip rom pointer      (a3).
		move.l	#z80_optc_CB00,(a1)+		;cbxx optcodes.        (a4).

		moveq.l	#6-1,d0
z80_reg_rest:	move.l	(a0)+,(a1)+
		dbra	d0,z80_reg_rest

		addq.l	#4,a0				;compability fix.
							;(old z80_status.L).
;		move.l	(a0)+,lcd_status
;		move.l	(a0)+,timer_status
;		move.l	(a0)+,debug_status
		add.l	#12,a0

;		move.l	(a0)+,z80_cycles
		addq.l	#4,a0

		move.l	(a0)+,d0
		add.l	rom_32k,d0
		move.l	d0,bank_address
		move.l	(a0)+,ram_bank_no
		and.l	#%11,ram_bank_no

		move.l	d0,(a3)				;install rom pointer   (a3).
		move.l	a0,-(SP)

fix_pc_address:	bsr.w	pull_z80

		tst.w	d1
		blt.s	pc_from_ram
		lea	(a3,d1.l),a0			;install code pointer  (a0).
		move.l	a3,z80_pc_base
		bra.s	pc_accuired
pc_from_ram:	lea	(a2,d1.l),a0			;install code pointer  (a0).
		move.l	a2,z80_pc_base

pc_accuired:	moveq.l	#0,d1
		swap	d0				;debc.
		move.w	d0,d1
		clr.w	d0				;de00.
		swap	d0				;00de.

		bsr.w	push_z80

		move.l	(SP)+,a0
		move.l	gb_memory,a1
		add.l	#$8000,a1
		move.w	#($10000-$8000)/4-1,d0
mem_rest_I:	move.l	(a0)+,(a1)+
		dbra	d0,mem_rest_I
		tst.b	$ff40-$10000(a1)
		spl	lcd_blank_phase		;legacy snapshots do not store LCD warm-up.
		clr.b	lcd_blank_presented
		clr.w	window_y_state		;legacy snapshots restart at scanline zero.
		bsr.w	dmg_unmapped_io
		bsr.w	dmg_mirror_wram
		bsr.w	sound_import_regs
		IFEQ	Z80_MODE
		clr.b	lcd_start_line
		bsr.l	sound_div_rebase
		ENDIF

		move.l	(a0)+,d0			;restore the banks, too?
		beq.s	no_banks_rest			;no.
		cmp.l	#1,d0
		beq.s	no_banks_rest			;no.

		move.l	d0,four_ram_banks_from_gbs
		move.l	memory_banks,a1
		mulu.l	#$2000/4,d0
mem_rest_II:	move.l	(a0)+,(a1)+
		subq.l	#1,d0
		bne.s	mem_rest_II

no_banks_rest:	move.b	(a0)+,i_flag			;interrupt flag.
		clr.b	new_load			;snapshot loading invalidates
							;the new_load flag.
		lea	status_gbs_loaded_txt,a5
		bsr.w	print_status_middle

ssload_error:	rts

ssload_error_file_not_found:
		lea	status_file_not_found_txt,a5
		bsr.w	print_status_middle
		rts

ssload_error_xpk_error:
		lea	status_xpk_error_txt,a5
		bsr.w	print_status_middle
		rts

ssload_error_too_big_a_file:
		lea	status_too_big_a_file_txt,a5
		bsr.w	print_status_middle
		rts

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		gbs save
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_gbs_save:
		IFEQ	GAMEBOY_USERS

		bsr.b	gbs_save_encode
		bsr.w	gbs_save_request

		ENDIF

		bra.w	get_message

runtime_gbs_save:
		IFEQ	GAMEBOY_USERS

		tst.b	key_status
		beq.s	runtime_gbs_save_exit

		movem.l	d0-d7/a0-a6,-(SP)

		move.l	dir_n_name_ptr,a0		;the name of the file.
		move.l	#"T:Wz",(a0)+
		move.l	#"onka",(a0)+
		move.l	#"-Lad",(a0)+
		move.l	#".RT.",(a0)+
		move.w	#"GB",(a0)+
		move.b	#"S",(a0)+
		move.b	gbs_file_id,(a0)+
		clr.b	(a0)

		bsr.w	gbs_save_encode

		move.b	pck_xpk_status,d6
		move.l	snapshot_area,a5
		move.l	snapshot_size,d7
		bsr.w	save_file

		move.l	key_file,a6
		add.l	key_serial_area(a6),a6
		jsr	(a6)

		movem.l	(SP)+,d0-d7/a0-a6

		ENDIF

runtime_gbs_save_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		gbs save routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS

gbs_save_encode:move.l	key_file,d0
		beq.w	gbs_save_exit
		move.l	d0,a0
		add.l	key_serial_area(a0),a0
		jsr	(a0)

		bsr.w	pull_z80
		move.l	a0,d7
		sub.l	z80_pc_base,d7
		IFEQ	Z80_MODE
		and.l	#$ffff,d7
		ENDIF

		move.l	snapshot_area,a0
		move.b	z80_halt,(a0)+
;		move.b	i_1,(a0)+			;old interrupt level
;		move.b	i_2,(a0)+			;signal bytes.
;		move.b	i_3,(a0)+
		addq.l	#3,a0				;4.

		swap	d0
		move.w	d1,d0
		swap	d0
		move.l	d0,(a0)+			;bcde stored (d0).

		move.l	d7,(a0)+			;pc stored   (d1).
		move.l	d2,(a0)+			;hl stored   (d2).
		move.l	d3,(a0)+			;fa stored   (d3).
		move.l	d4,(a0)+			;ccr stored  (d4).
		move.l	d5,(a0)+			;sp stored   (d5).

		addq.l	#4,a0				;compability fix.
							;(old z80_status.L).
;		move.l	lcd_status,(a0)+
;		move.l	timer_status,(a0)+
;		move.l	debug_status,(a0)+
		add.l	#12,a0				;44.

		move.l	z80_cycles,(a0)+
		move.l	bank_address,d0
		sub.l	rom_32k,d0
		move.l	d0,(a0)+
		move.l	ram_bank_no,(a0)+		;56.

		move.l	gb_memory,a1
		add.l	#$8000,a1
		move.w	#($10000-$8000)/4-1,d0
mem_copy_I:	move.l	(a1)+,(a0)+
		dbra	d0,mem_copy_I

; Preserve the raw sound registers in the existing snapshot format.
		move.l	a0,-(SP)
		lea	$ff10-$10000(a0),a0
		lea	sound_raw_regs,a1
		moveq.l	#$26-$10-1,d0
mem_copy_sound:
		move.b	(a1)+,(a0)+
		dbra	d0,mem_copy_sound
		move.l	(SP)+,a0

		tst.l	ram_banks			;save the banks, too?
		beq.s	no_banks_save			;no.
		cmp.l	#1,ram_banks
		beq.s	no_banks_save			;no.

		move.l	ram_banks,(a0)+			;banks marker (4/16).
		move.l	memory_banks,a1
		move.l	#$2000/4,d0
		mulu.l	ram_banks,d0
mem_copy_II:	move.l	(a1)+,(a0)+
		subq.l	#1,d0
		bne.s	mem_copy_II
		bra.s	copy_done

no_banks_save:	clr.l	(a0)+				;no banks saved.

copy_done:	move.b	i_flag,(a0)+			;save interrupt flag.

        	sub.l	snapshot_area,a0
		move.l	a0,snapshot_size		;save the size.
		rts

gbs_save_request:
		move.l	req_tools_base,a6
		lea	req_tags,a0			;the tags.
		move.l	menu_ptr,4(a0)			;the position pointer.
		move.l	request_ptr_ss,a1		;the requester pointer.
		move.l	name_ptr,a2			;the output area.
		lea	request_ssshot,a3		;the title text.
		jsr	rtFileRequestA(a6)		;open a file requester.

		move.l	request_ptr_ss,a2		;directory.
		move.l	rtfi_Dir(a2),a2
		move.l	def_ss_dir,a0
		bsr.w	memorize_dir			;memorize the dir.

		tst.l	d0
		beq.w	gbs_save_exit

		move.l	request_ptr_ss,a2		;directory.
		bsr.w	parse_req_name

		move.b	pck_xpk_status,d6
		move.l	snapshot_area,a5
		move.l	snapshot_size,d7
		bsr.b	save_file

		move.l	key_file,a6
		add.l	key_serial_area(a6),a6
		jsr	(a6)
gbs_save_exit:	rts

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		save file
;		INPUT:
;		d6	= use xpk packing (0 = yes / 1 = no).
;		d7	= size of the area.
;		a5	= pointer to the area.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

save_file:	move.l	dos_base,a6			;open the data file.
		move.l	dir_n_name_ptr,d1		;the name of the file.
		move.l	#Mode_New,d2
		jsr	Open(a6)
		move.l	d0,file_hd
		beq.w	file_save_error

		tst.l	xpk_master_base
		beq.w	no_xpk_file_save

		tst.b	d6				;none lib??
		bne.w	no_xpk_file_save

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		pack the file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		movem.l	d7/a5,-(SP)
		move.l	pck_method,status_xpk_name_txt	;show packer name.
		lea	status_xpk_pack_txt,a5
		bsr.w	print_status_middle
		movem.l	(SP)+,d7/a5

		move.l	xpk_master_base,a6
		lea	xpk_pck_tags,a0
		move.l	file_hd,4(a0)
		move.l	a5,12(a0)
		move.l	d7,20(a0)
		jsr	XpkPack(a6)
		tst.l	d0
		bne.s	quit_file_save_error

		move.l	dos_base,a6
		move.l	file_hd,d1
		jsr	Close(a6)

		lea	status_file_saved_txt,a5
		bsr.w	print_status_middle
		rts

quit_file_save_error:
		move.l	dos_base,a6
		move.l	file_hd,d1
		jsr	Close(a6)
		bra.w	file_save_error

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		normal dos open and saving
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

no_xpk_file_save:
		move.l	dos_base,a6
		move.l	d0,d1
		move.l	a5,d2
		move.l	d7,d3
		jsr	Write(a6)

		move.l	file_hd,d1
		jsr	Close(a6)

		lea	status_file_saved_txt,a5
		bsr.w	print_status_middle
		rts

file_save_error:lea	status_file_saved_error_txt,a5
		bsr.w	print_status_middle
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		load file
;		INPUT:
;		d7	= size of the area.
;		a5	= pointer to the area.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_file:	move.l	xpk_master_base,d0
		beq.w	load_file_no_xpk_open
		move.l	d0,a6
		lea	xfh_pointer,a0
		lea	xpk_in_tags,a1
		move.l	dir_n_name_ptr,4(a1)
		jsr	XpkOpen(a6)
		tst.l	d0
		bne.w	load_file_no_xpk_open

		move.l	xfh_pointer,a0			;a0 = xpkfib structure.
		move.l	xf_Type(a0),d0			;d0 = file type.
		cmp.l	#XPKTYPE_PACKED,d0		;is it packed?
		bne.w	load_file_quit_xpk		;no. it's something else.

		move.l	xf_ULen(a0),file_length		;uncompressed length.
		cmp.l	file_length,d7
		bne.w	load_file_quit_xpk_e
		add.l	#XPK_MARGIN,file_length		;xpk margin area.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		unpack the file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		bsr.w	print_status_middle_erase
		bsr.w	get_packer_name

		move.l	xpk_master_base,a6
		move.l	xfh_pointer,a0
		jsr	XpkClose(a6)

		move.l	dos_base,a6			;open the data file.
		move.l	dir_n_name_ptr,d1		;the name of the file.
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,file_hd
		beq.w	load_file_quit_xpk_e

		move.l	a5,-(SP)
		lea	status_xpk_unpack_txt,a5
		bsr.w	print_status_middle_new
		move.l	(SP)+,a5

		move.l	xpk_master_base,a6
		lea	xpk_unp_tags,a0
		move.l	file_hd,4(a0)
		move.l	a5,12(a0)
		move.l	file_length,20(a0)		;output area length!
		jsr	XpkUnpack(a6)
		tst.l	d0
		bne.s	load_file_xpk_argh		;error here!

		move.l	dos_base,a6
		move.l	file_hd,d1
		jsr	Close(a6)
		moveq.l	#0,d0
		rts

load_file_xpk_argh:
		move.l	dos_base,a6
		move.l	file_hd,d1
		jsr	Close(a6)

		bra.w	load_file_error

load_file_quit_xpk_e:
		move.l	xpk_master_base,a6		;an error occurred!
		move.l	xfh_pointer,a0
		jsr	XpkClose(a6)

		bra.w	load_file_error

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		normal dos open and loading
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_file_quit_xpk:
		move.l	xpk_master_base,a6
		move.l	xfh_pointer,a0			;it was not packed.
		jsr	XpkClose(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		now load the file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_file_no_xpk_open:
		move.l	dos_base,a6
		move.l	dir_n_name_ptr,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,file_hd
		beq.w	load_file_error

		move.l	d0,d1
		move.l	a5,d2
		move.l	d7,d3
		jsr	Read(a6)

		move.l	file_hd,d1
		jsr	Close(a6)
		moveq.l	#0,d0
		rts

load_file_error:moveq.l	#1,d0				;error!
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu misc about
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_misc_about:bsr.w	function_window_output
		tst.l	d0
		beq.w	get_message

		cmp.l	#"ABOU",function_status
		beq.w	get_message			;don't output this twice.

		bsr.w	gadgets_rmv

		move.l	graphics_base,a6
		move.l	about_map_attr,a0		;a0 = source bitmap.
		move.l	function_ptr,a1
		move.l	wd_RPort(a1),a1			;a1 = destination rastport.
		moveq.l	#0,d0				;org x.
		moveq.l	#0,d1				;org y.
		moveq.l	#0,d2				;dst x.
		moveq.l	#0,d3				;dst y.
		move.l	#function_x_bm,d4		;size x.
		move.l	#function_y_bm,d5		;size y.
		move.l	#$c0,d6				;minterm.
		jsr	BltBitMapRastPort(a6)		;update the screen window.

		lea	about_text_1,a0
		bsr.w	print_middle

		lea	about_text_2,a0
		bsr.w	print_middle

		lea	about_win_txt,a1
		bsr.w	change_win_title

		move.l	#"ABOU",function_status
		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu edit gfx
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_edit_gfx:	bsr.b	menu_edit_gfx_on
		tst.l	d0
		beq.w	get_message

		bsr.w	gfx_values_update		;has .prefs loading altered
							;any gadget values?
		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu edit gfx
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_edit_gfx_on:
		bsr.w	function_window_output
		tst.l	d0
		beq.w	menu_edit_gfx_on_exit

		moveq.l	#1,d0
		cmp.l	#"GFX!",function_status
		beq.w	menu_edit_gfx_on_exit		;don't output this twice.

		bsr.w	gadgets_rmv
		bsr.w	back_pattern_function

		move.l	function_ptr,a4
		lea	gfx_bevel_list,a5
		bsr.w	draw_bevel_list

		move.l	context_g_gfx,a1
		move.l	(a1),a1
		bsr.w	gadgets_ins

		move.l	#gfx_jmp_table,function_jmp
		move.l	#"GFX!",function_status

		bsr.w	gfx_values_update		;has .prefs loading altered
							;any gadget values?
		bsr.w	obtain_status_direct		;turn it on/off?

		bsr.w	write_test_image

		move.l	intuition_base,a6
		move.l	function_ptr,a0
		move.l	wd_RPort(a0),a0
		lea	gfx_txt_1,a1
		moveq.l	#0,d0
		moveq.l	#0,d1
		jsr	PrintIText(a6)

		lea	gfx_win_txt,a1
		bsr.w	change_win_title

menu_edit_gfx_on_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu edit sfx
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_edit_sfx:
		IFEQ	GAMEBOY_USERS

		bsr.w	function_window_output
		tst.l	d0
		beq.w	get_message

		cmp.l	#"SFX!",function_status
		beq.w	get_message			;don't output this twice.

		bsr.w	gadgets_rmv
		bsr.w	back_pattern_function

		move.l	ahi_mode_txt,sfx_ahi_txt	;install the pointer.

		move.l	function_ptr,a4
		lea	sfx_bevel_list,a5
		bsr.w	draw_bevel_list

		move.l	context_g_sfx,a1
		move.l	(a1),a1
		bsr.w	gadgets_ins

		move.l	sfx_g_y_hz,a0
		lea	alter_tags_slider,a3
		move.b	sfx_y_update,d0
		bsr.w	set_gadget_attributes

		move.l	intuition_base,a6
		move.l	function_ptr,a0
		move.l	wd_RPort(a0),a0
		lea	sfx_c_1_text,a1
		moveq.l	#0,d0
		moveq.l	#0,d1
		jsr	PrintIText(a6)

		move.l	#sfx_jmp_table,function_jmp
		move.l	#"SFX!",function_status

		lea	sfx_win_txt,a1
		bsr.w	change_win_title

		tst.l	ahi_base
		bne.s	ahi_is_in_system

		move.l	ahi_mode_txt,a0
		move.l	#"Inst",(a0)+
		move.l	#"all ",(a0)+
		move.l	#"AHI ",(a0)+
		move.l	#"asap",(a0)+
		move.b	#"!",(a0)+
		clr.b	(a0)

		lea	sfx_ahi_text,a0
		move.b	#1,(a0)
		bsr.w	print_middle

		ENDIF

		bra.w	get_message

		IFEQ	GAMEBOY_USERS

ahi_is_in_system:
		move.l	ahi_mode_id,d0
		bra.w	ahi_mode_info			;print the text ->
							;get_message.
		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		obtain new colours from wzonka-lad
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

obtain_from_colour_editor:
		move.l	exec_base,a6
		jsr	Forbid(a6)

		lea	message_port_colour_editor_name,a1
		jsr	FindPort(a6)
		move.l	d0,message_port_colour_editor
		jsr	Permit(a6)

		tst.l	message_port_colour_editor
		beq.w	get_message

		move.l	exec_base,a6
		move.l	message_port_colour_editor,a0
		move.l	colour_message,a1
		move.l	colour_message_name,a2
		move.b	#1,(a2)				;request for the colours.
		jsr	PutMsg(a6)

		move.l	message_port,a0
		jsr	WaitPort(a6)

		bsr.w	obtain_status_on_get_message
		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		select a new screen mode
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_gfx_screen_mode:
		move.l	req_tools_base,a6
		move.l	request_ptr_sm,a1		;requester.
		lea	request_smode,a3		;requester title.
		lea	req_smode_tags,a0		;requester tags.
		jsr	rtScreenModeRequestA(a6)	;ask for screen mode.
		cmp.l	#FALSE,d0			;cancelled?
		beq.s	no_mode				;yes. use default.

		move.l	request_ptr_sm,a0
		move.l	rtsc_DisplayID(a0),d7		;take the new screen id.
		cmp.l	gb_screen_id+4,d7
		beq.s	no_mode
		move.l	d7,gb_screen_id+4

		bsr.b	close_graphics

		bsr.w	allocate_gfx_driver_memory
		tst.l	d0				;errors?
		bne.w	quit				;yes! quit!

no_mode:	bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get gfx driver button value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_gfx_driver:	move.l	gfx_g_driver,a0
		bsr.w	get_mx

		cmp.b	old_render,d0
		beq.w	get_message			;it's the same.

		move.b	d0,old_render

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		free old driver option vectors and allocate new ones
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		bsr.b	close_graphics

		bsr.w	allocate_gfx_driver_memory
		tst.l	d0				;errors?
		bne.w	quit				;yes! quit!

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		close graphics
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

close_graphics:	bsr.b	close_and_free_aga
		bsr.b	close_and_free_screen
		bsr.b	close_and_free_window
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		close graphics driver output and free the vectors
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

close_and_free_aga:
		lea	list_aga,a5
		bsr.w	free_vectors			;free the allocated memory.
		rts
close_and_free_screen:
		bsr.w	dbuf_dealloc

		lea	list_screen,a5
		bsr.w	free_vectors			;free the allocated memory.
		rts
close_and_free_window:
		lea	list_window,a5
		bsr.w	free_vectors			;free the allocated memory.

		lea	wzonka_ptr,a5
		lea	wzonka_window,a4
		tst.l	(a5)
		beq.s	close_and_free_window_no_window
		move.l	(a5),a0
		move.w	wd_LeftEdge(a0),nw_LeftEdge(a4)
		move.w	wd_TopEdge(a0),nw_TopEdge(a4)
		tst.b	scaling_status
		beq.s	close_and_free_window_fixed
		move.w	wd_Width(a0),wzonka_window_x
		move.w	wd_Height(a0),wzonka_window_y
close_and_free_window_fixed:
		bsr.w	close_window

close_and_free_window_no_window:
		lea	game_tmp_map_attr,a1
		bsr.w	free_bit_maps
		lea	game_output_tmp_map_attr,a1
		bsr.w	free_bit_maps
		clr.l	window_scale_capacity
		clr.l	window_requested_width		;also clears the adjacent height.
		clr.l	wzonka_game_x
		clr.l	wzonka_game_y
		tst.l	game_scale_array
		beq.s	close_and_free_window_done
		move.l	game_scale_array,a1
		clr.l	game_scale_array
		move.l	exec_base,a6
		jsr	FreeVec(a6)
close_and_free_window_done:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate gfx driver memory
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

allocate_gfx_driver_memory:
		move.b	old_render,d0
		beq.s	allocate_aga
		cmp.b	#1,d0
		beq.s	allocate_screen
		cmp.b	#2,d0
		beq.s	allocate_window
		moveq.l	#0,d0
		rts

allocate_aga:	tst.b	aga_status
		beq.s	allocate_gfx_driver_memory_exit	;no aga available.

		lea	list_aga_structure,a4
		lea	list_aga,a5
		bsr.w	allocate_list			;allocate memory.
		tst.l	d0				;errors?
		beq.w	allocate_gfx_driver_memory_error;yes! quit!

		bsr.w	create_coppers			;create the copper list
							;for aga h/w modes.
allocate_gfx_driver_memory_exit:
		moveq.l	#0,d0
		rts

allocate_screen:bsr.w	center_screen
		move.l	intuition_base,a6
		sub.l	a0,a0
		lea	gb_taglist,a1
		jsr	OpenScreenTagList(a6)
		move.l	d0,gb_screen_ptr
		beq.w	allocate_gfx_driver_memory_error
		move.l	d0,a0
		bsr.w	get_screen_cyber_status

		move.l	#MEMF_CHIP!MEMF_CLEAR,screen_chip_1+8
		move.l	#MEMF_CHIP!MEMF_CLEAR,screen_chip_2+8

		tst.l	output_cyber_status		;native display DMA needs CHIP RAM.
		beq.s	allocate_screen_in_chip
		tst.b	fast_ram_bitmaps
		beq.s	allocate_screen_in_chip

		move.l	#MEMF_PUBLIC!MEMF_CLEAR,screen_chip_1+8
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,screen_chip_2+8

allocate_screen_in_chip:
		lea	list_screen_structure,a4
		lea	list_screen,a5
		bsr.w	allocate_list			;allocate memory.
		tst.l	d0				;errors?
		beq.w	allocate_gfx_driver_memory_error;yes! quit!

		bra.w	dbuf_alloc

allocate_window:move.l	#MEMF_CHIP!MEMF_CLEAR,window_chip_1+8

		tst.b	fast_ram_bitmaps
		beq.s	allocate_window_in_chip

		move.l	#MEMF_PUBLIC!MEMF_CLEAR,window_chip_1+8

allocate_window_in_chip:
		lea	wzonka_window,a0
		move.l	#160,d0
		add.l	window_bars_width,d0
		move.w	d0,nw_Width(a0)
		move.l	#144,d0
		add.l	window_bars_height,d0
		move.w	d0,nw_Height(a0)
		tst.b	scaling_status
		beq.s	allocate_window_solid
		move.w	wzonka_window_x,nw_Width(a0)
		move.w	wzonka_window_y,nw_Height(a0)

allocate_window_solid:
		lea	list_window_structure,a4
		lea	list_window,a5
		bsr.w	allocate_list			;allocate memory.
		tst.l	d0				;errors?
		beq.s	allocate_gfx_driver_memory_error;yes! quit!

		move.l	intuition_base,a6
		lea	wzonka_window,a0
		lea	win_tags_u,a1			;universal taglist.
		jsr	OpenWindowTagList(a6)		;structure and open the window.
		move.l	d0,wzonka_ptr
		beq.w	allocate_gfx_driver_memory_error

		move.l	d0,a5
		bsr.w	update_wzonka_window_size
		tst.l	d0
		beq.s	allocate_gfx_driver_memory_error

		tst.b	old_refresh			;mode 144/144?
		beq.s	change_160x144			;yes.		
change_176x152:	bsr.w	init_wzonka_176
		moveq.l	#0,d0
		rts
change_160x144:	bsr.w	init_wzonka_160
		moveq.l	#0,d0
		rts

allocate_gfx_driver_memory_error:
		moveq.l	#1,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		compute wzonka window values
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

update_wzonka_window_size:
		move.w	wd_Width(a5),d4
		move.w	wd_Height(a5),d5
		cmp.w	window_requested_width,d4
		bne.s	wzonka_size_reserve
		cmp.w	window_requested_height,d5
		bne.s	wzonka_size_reserve
		clr.l	window_requested_width
wzonka_size_reserve:
		bsr.w	reserve_wzonka_window_size
		tst.l	d0
		beq.w	wzonka_size_failed
		cmp.l	wzonka_game_x,d2
		bne.s	wzonka_size_commit
		cmp.l	wzonka_game_y,d3
		beq.s	wzonka_size_snap
wzonka_size_commit:
		move.l	d2,wzonka_game_x
		move.l	d3,wzonka_game_y
		move.l	game_output_tmp_map_attr,d0
		beq.s	wzonka_size_title
		move.l	d0,a0
		lsr.w	#3,d2
		move.w	d2,bm_BytesPerRow(a0)
wzonka_size_title:
		move.l	wzonka_game_x,d0
		lea	wzonka_window_title_x,a0
		bsr.w	format_wzonka_window_dimension
		move.l	wzonka_game_y,d0
		lea	wzonka_window_title_y,a0
		bsr.w	format_wzonka_window_dimension
		move.l	a5,a0
		lea	wzonka_window_title_txt,a1
		lea	wzonka_window_screen_txt,a2
		move.l	intuition_base,a6
		jsr	SetWindowTitles(a6)
wzonka_size_snap:
		tst.b	scaling_status
		beq.s	wzonka_size_done
		tst.w	window_requested_width
		bne.s	wzonka_size_done			;don't override a queued keyboard resize.
		move.w	wzonka_game_x+2,d4
		add.w	window_bars_width+2,d4
		add.w	#window_right_bar_x,d4
		cmp.w	wd_Width(a5),d4
		beq.s	wzonka_size_done
		bsr.w	set_wzonka_window_box
wzonka_size_done:
		moveq.l	#1,d0
		rts

wzonka_size_failed:
		clr.l	window_requested_width
		tst.l	wzonka_game_x
		beq.s	wzonka_size_beep
		move.w	wzonka_game_x+2,d4
		add.w	window_bars_width+2,d4
		add.w	#window_right_bar_x,d4
		move.w	wzonka_game_y+2,d5
		add.w	window_bars_height+2,d5
		bsr.w	set_wzonka_window_box		;restore the last drawable size.
wzonka_size_beep:
		bsr.w	wzonka_resize_denied
		moveq.l	#0,d0
		rts

;		d4/d5 = outer box size; return inner width/height in d2/d3.
;		Grow only when needed. A failed allocation leaves the old buffer usable.
reserve_wzonka_window_size:
		moveq.l	#0,d2
		moveq.l	#0,d3
		move.w	d4,d2
		move.w	d5,d3
		sub.l	window_bars_width,d2
		sub.l	window_bars_height,d3
		tst.b	scaling_status
		beq.s	wzonka_size_reserved
		sub.l	#window_right_bar_x,d2
		and.l	#-16,d2				;WritePixelArray8 rows are 16-pixel aligned.
		cmp.l	#160,d2
		blo.s	wzonka_reserve_failed
		cmp.l	#window_max_game_x,d2
		bhi.s	wzonka_reserve_failed
		cmp.l	#144,d3
		blo.s	wzonka_reserve_failed
		cmp.l	#window_max_game_y,d3
		bhi.s	wzonka_reserve_failed
		cmp.w	#160,d2
		bne.s	wzonka_scale_bytes
		cmp.w	#144,d3
		beq.s	wzonka_size_reserved		;native size uploads the readback buffer.
wzonka_scale_bytes:
		move.l	d2,d0
		mulu.w	d3,d0
		cmp.l	window_scale_capacity,d0
		bls.s	wzonka_size_reserved
		move.l	d0,-(SP)
		move.l	#MEMF_PUBLIC,d1
		move.l	exec_base,a6
		jsr	AllocVec(a6)
		move.l	(SP)+,d1
		tst.l	d0
		beq.s	wzonka_reserve_failed
		move.l	game_scale_array,a1
		move.l	d0,game_scale_array
		move.l	d1,window_scale_capacity
		move.l	a1,d1
		beq.s	wzonka_size_reserved
		jsr	FreeVec(a6)
wzonka_size_reserved:
		moveq.l	#1,d0
		rts
wzonka_reserve_failed:
		moveq.l	#0,d0
		rts

format_wzonka_window_dimension:
		divu.w	#1000,d0
		move.b	d0,d1
		beq.s	wzonka_dimension_space
		add.b	#"0",d1
		bra.s	wzonka_dimension_thousands
wzonka_dimension_space:
		moveq.l	#" ",d1
wzonka_dimension_thousands:
		move.b	d1,(a0)+
		clr.w	d0
		swap	d0
		divu.w	#100,d0
		add.b	#"0",d0
		move.b	d0,(a0)+
		clr.w	d0
		swap	d0
		divu.w	#10,d0
		add.b	#"0",d0
		move.b	d0,(a0)+
		swap	d0
		add.b	#"0",d0
		move.b	d0,(a0)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get wzonka game window scaled dimensions
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_wzonka_window_scaled_dimensions:
		move.l	wzonka_ptr,d1
		beq.s	get_wzonka_window_scaled_dimensions_no_window
		tst.b	scaling_status
		beq.s	get_wzonka_window_scaled_dimensions_not_scalable
		move.l	d1,a0
		move.w	wd_Width(a0),wzonka_window_x
		move.w	wd_Height(a0),wzonka_window_y
get_wzonka_window_scaled_dimensions_no_window:
get_wzonka_window_scaled_dimensions_not_scalable:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get gfx scaling button value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_gfx_scaling:move.l	gfx_g_scaling,a0
		bsr.w	get_mx

		move.l	d0,-(SP)
		bsr.b	get_wzonka_window_scaled_dimensions
		bsr.w	close_and_free_window
		move.l	(SP)+,d0
		move.b	d0,scaling_status

		bsr.w	get_wzonka_window_flags
		bsr.w	allocate_gfx_driver_memory
		tst.l	d0
		bne.w	quit

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get gfx mode button value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_gfx_mode:	move.l	gfx_g_mode,a0
		bsr.w	get_mx

		move.l	d0,-(SP)
		bsr.w	close_graphics
		move.l	(SP)+,d0

		move.b	d0,old_refresh
		bsr.w	allocate_gfx_driver_memory

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get x slider value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_gfx_x:	move.l	gfx_g_scanline_x,a0
		bsr.w	get_slider

		move.b	d0,refresh_scanline

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get x slider value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_gfx_colour_status:
		move.l	gfx_g_colour_load,a0
		bsr.w	get_checkbox

		move.b	d0,colour_load_status

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get gfx aga mode button value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_gfx_aga_mode:
		move.l	gfx_g_aga_mode,a0
		bsr.w	get_mx

		move.b	d0,aga_mode

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get frame skip slider value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_gfx_frame_skip:
		move.l	gfx_g_frame_skip,a0
		bsr.w	get_slider

		move.b	d0,frame_update_number
		addq.b	#1,d0
		move.b	d0,frame_update

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		window button jump tables
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gfx_jmp_table:	dc.l	get_gfx_driver
		dc.l	get_gfx_scaling
		dc.l	get_gfx_mode
		dc.l	get_gfx_x
		dc.l	get_gfx_screen_mode
		dc.l	get_gfx_aga_mode
		dc.l	obtain_from_colour_editor
		dc.l	get_gfx_frame_skip
		dc.l	get_gfx_colour_status

prefs_jmp_table:dc.l	get_prefs_str_1
		dc.l	get_prefs_str_2
		dc.l	get_prefs_str_3
		dc.l	get_prefs_str_4
		dc.l	get_prefs_dir_1
		dc.l	get_prefs_dir_2
		dc.l	get_prefs_dir_3
		dc.l	get_prefs_dir_4
		dc.l	get_prefs_xpk
		dc.l	get_prefs_battery_xpk
		dc.l	get_prefs_gbs
		dc.l	get_prefs_joy
		dc.l	prefs_save_default
		dc.l	get_prefs_battery
		dc.l	save_prefs

		IFEQ	GAMEBOY_USERS

sfx_jmp_table:	dc.l	sfx_jmp_audio
		dc.l	sfx_jmp_quality
		dc.l	sfx_jmp_c1
		dc.l	sfx_jmp_c2
		dc.l	sfx_jmp_c3
		dc.l	sfx_jmp_c4
		dc.l	sfx_jmp_ahi
		dc.l	sfx_jmp_y
		dc.l	sfx_jmp_volume

		ENDIF

misc_jmp_table:	dc.l	misc_forbid_permit
		dc.l	misc_os_screen_speed_limit
		dc.l	misc_patch
		dc.l	get_message
		dc.l	get_message
		dc.l	get_message
		dc.l	misc_fast_ram_bitmaps
		dc.l	misc_get_gg
		dc.l	misc_window_readback

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get a new patch code
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

misc_get_gg:	move.l	misc_b_code_list,a0
		bsr.w	get_listview

		move.b	d0,misc_b_code_list_selected

		move.b	gg_code_status,d1
		beq.s	misc_get_gg_reg
		cmp.b	#1,d1
		beq.s	misc_get_gg_real_code
		bra.w	get_message			;none.

misc_get_gg_reg:bsr.b	set_gg_strs			;reg-ist-er!
		bra.w	get_message

misc_get_gg_real_code:
		moveq.l	#0,d1				;the list.
		move.l	gg_linked_list,a0

misc_get_gg_real_code_loop:
		cmp.b	d0,d1
		beq.s	misc_get_gg_real_code_found
		addq.b	#1,d1
		move.l	(a0),a0
		bra.s	misc_get_gg_real_code_loop

misc_get_gg_real_code_found:
		add.l	#12,a0
		move.l	(a0),gg_register_1_txt
		clr.b	gg_register_1_txt+3
		move.l	4(a0),gg_register_2_txt
		clr.b	gg_register_2_txt+3
		move.l	8(a0),gg_register_3_txt
		clr.b	gg_register_3_txt+3

		bsr.b	set_gg_strs
		bra.w	get_message

set_gg_strs:	move.l	misc_b_str_1,a0			;get the gadget.
		move.l	#gg_register_1_txt,d0
		bsr.b	set_gg_str_slot

		move.l	misc_b_str_2,a0			;get the gadget.
		move.l	#gg_register_2_txt,d0
		bsr.b	set_gg_str_slot

		move.l	misc_b_str_3,a0			;get the gadget.
		move.l	#gg_register_3_txt,d0
		bsr.b	set_gg_str_slot
		rts

set_gg_str_slot:move.l	gad_tools_base,a6
		move.l	function_ptr,a1
		sub.l	a2,a2
		lea	prefs_g_str_chg,a3
		move.l	d0,4(a3)
		jsr	GT_SetGadgetAttrsA(a6)		;set the new text.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		patch the rom!!!
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

misc_patch:	tst.l	cartridge
		beq.w	misc_patch_none

		lea	gg_patch,a5

		move.l	gad_tools_base,a6
		move.l	misc_b_str_1,a0
		move.l	function_ptr,a1
		sub.l	a2,a2
		lea	prefs_g_str_chg,a3
		move.l	#prefs_str_ptr,4(a3)
		jsr	GT_GetGadgetAttrsA(a6)
		move.l	prefs_str_ptr,a0
		move.w	(a0)+,(a5)+
		move.b	(a0),(a5)+

		move.l	misc_b_str_2,a0
		move.l	function_ptr,a1
		sub.l	a2,a2
		lea	prefs_g_str_chg,a3
		move.l	#prefs_str_ptr,4(a3)
		jsr	GT_GetGadgetAttrsA(a6)
		move.l	prefs_str_ptr,a0
		move.w	(a0)+,(a5)+
		move.b	(a0),(a5)+

		move.l	misc_b_str_3,a0
		move.l	function_ptr,a1
		sub.l	a2,a2
		lea	prefs_g_str_chg,a3
		move.l	#prefs_str_ptr,4(a3)
		jsr	GT_GetGadgetAttrsA(a6)
		move.l	prefs_str_ptr,a0
		move.w	(a0)+,(a5)+
		move.b	(a0),(a5)

		bsr.w	decode_gg_patch
		tst.l	d6
		bne.s	gg_patch_invalid_code

		move.l	cartridge,a0
		moveq.l	#1,d3
		moveq.l	#1,d4
		add.b	$148(a0),d3
		lsl.w	d3,d4
		subq.w	#1,d4
		moveq.l	#0,d7

gg_patch_rom:	lea	(a0,d1.l),a1
		cmp.b	(a1),d2
		bne.s	gg_patch_rom_miss
		move.b	d0,(a1)
		addq.b	#1,d7
gg_patch_rom_miss:
		add.l	#$8000,a0
		dbra	d4,gg_patch_rom

		tst.b	d7
		beq.s	gg_patch_none

		bsr.w	gg_patch_apply

		lea	status_rom_patched_txt,a5
		bsr.w	print_status_middle
		bra.w	get_message

gg_patch_none:	lea	status_patch_none_txt,a5
		bsr.w	print_status_middle
		bra.w	get_message

gg_patch_invalid_code:
		lea	status_invalid_patch_txt,a5
		bsr.w	print_status_middle
		bra.w	get_message

misc_patch_none:lea	status_no_rom_txt,a5
		bsr.w	print_status_middle
		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get misc forbid/permit checkbox value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

misc_forbid_permit:
		move.l	misc_b_1,a0
		bsr.w	get_checkbox

		move.b	d0,forbid_permit_status

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get misc os screen speed limit checkbox value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

misc_os_screen_speed_limit:
		move.l	misc_b_2,a0
		bsr.w	get_checkbox

		move.b	d0,os_screen_speed_limit

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get misc fast ram bitmaps checkbox value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

misc_fast_ram_bitmaps:
		move.l	misc_b_6,a0
		bsr.w	get_checkbox

		move.b	d0,fast_ram_bitmaps

		bsr.w	close_graphics

		bsr.w	allocate_gfx_driver_memory
		tst.l	d0
		bne.w	quit

		bra.w	get_message

misc_window_readback:
		move.l	misc_b_readback,a0
		bsr.w	get_checkbox
		move.b	d0,window_direct_readback
		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get prefs battery button value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_battery:
		move.l	prefs_g_battery_status,a0
		bsr.w	get_mx

		move.b	d0,battery_status

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get prefs battery xpk button value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_battery_xpk:
		move.l	prefs_g_battery,a0
		bsr.w	get_mx

		move.b	d0,battery_xpk_status

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get xpk listview value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_xpk:	move.l	prefs_g_xpk,a0
		bsr.w	get_listview

		move.l	xpk_names,a0
		move.l	(a0,d0.l*4),pck_method
		move.b	d0,pck_method_number

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get gbs mx value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_gbs:	move.l	prefs_g_gbs,a0
		bsr.w	get_mx

		move.b	d0,pck_xpk_status

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get controller listview value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_joy:	move.l	prefs_g_joy,a0
		bsr.w	get_listview

		move.b	d0,keystick

		bra.w	get_message

		IFEQ	GAMEBOY_USERS

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound preferences - audio on/off
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sfx_jmp_audio:	move.l	sfx_g_audio,a0
		bsr.w	get_checkbox

		bchg	#0,d0
		move.b	d0,snd_master

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound preferences - quality high/low/y hz
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sfx_jmp_quality:move.l	sfx_g_quality,a0
		bsr.w	get_mx

		move.b	d0,snd_quality

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound preferences - channel 1 on/off
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sfx_jmp_c1:	move.l	sfx_g_c_1,a0
		bsr.b	get_checkbox

		bchg	#0,d0
		move.b	d0,snd_chnlI

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound preferences - channel 2 on/off
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sfx_jmp_c2:	move.l	sfx_g_c_2,a0
		bsr.b	get_checkbox

		bchg	#0,d0
		move.b	d0,snd_chnlII
	
		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound preferences - channel 3 on/off
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sfx_jmp_c3:	move.l	sfx_g_c_3,a0
		bsr.b	get_checkbox

		bchg	#0,d0
		move.b	d0,snd_chnlIII

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound preferences - channel 4 on/off
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sfx_jmp_c4:	move.l	sfx_g_c_4,a0
		bsr.b	get_checkbox

		bchg	#0,d0
		move.b	d0,snd_chnlIV

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get y slider value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sfx_jmp_y:	move.l	sfx_g_y_hz,a0
		bsr.w	get_slider

		move.b	d0,sfx_y_update

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get volume slider value
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sfx_jmp_volume:	move.l	sfx_g_volume,a0
		bsr.w	get_slider

		move.b	d0,sfx_volume_value

		bsr.w	fix_volume_tables

		bra.w	get_message

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get checkbox's value
;		INPUT:
;		a0	= the checkbox gadget.
;		OUTPUT:
;		d0	= the value.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_checkbox:	move.l	gad_tools_base,a6
		move.l	function_ptr,a1
		sub.l	a2,a2
		lea	get_checkbox_attr,a3
		jsr	GT_GetGadgetAttrsA(a6)		;get the new text.

		move.l	checkbox_status,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get mx button's value
;		INPUT:
;		a0	= the mx gadget.
;		OUTPUT:
;		d0	= the value.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_mx:		move.l	gad_tools_base,a6
		move.l	function_ptr,a1
		sub.l	a2,a2
		lea	get_mx_attr,a3
		jsr	GT_GetGadgetAttrsA(a6)		;get the new text.

		move.l	mx_attr_value,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get slider's value
;		INPUT:
;		a0	= the slider gadget.
;		OUTPUT:
;		d0	= the value.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_slider:	move.l	gad_tools_base,a6
		move.l	function_ptr,a1
		sub.l	a2,a2
		lea	get_slider_attr,a3
		jsr	GT_GetGadgetAttrsA(a6)		;get the new text.

		move.l	slider_attr_value,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get listview's value
;		INPUT:
;		a0	= the listview gadget.
;		OUTPUT:
;		d0	= the value.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_listview:	move.l	gad_tools_base,a6
		move.l	function_ptr,a1
		sub.l	a2,a2
		lea	get_listview_attr,a3
		jsr	GT_GetGadgetAttrsA(a6)		;get the new text.

		move.l	listview_attr_value,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound preferences - select AHI mode
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS

sfx_jmp_ahi:	move.l	ahi_base,d0
		beq.w	get_message

		move.l	d0,a6
		move.l	ahi_request,a0
		lea	ahi_requ_tags,a1
		move.l	menu_ptr,4(a1)			;pointer to a window.
		move.l	ahi_mix_freq,12(a1)		;old mix freq.
		move.l	ahi_mode_id,20(a1)		;old audio id.
		jsr	AHI_AudioRequestA(a6)

		cmp.l	#FALSE,d0
		beq.w	get_message			;error (close pressed).

		lea	sfx_ahi_text,a0
		clr.b	(a0)
		bsr.w	print_middle

		move.l	ahi_request,a0
		lea	ahi_alloc_tags,a1

		move.l	ahiam_MixFreq(a0),d0
		move.l	d0,12(a1)
		move.l	d0,ahi_mix_freq

		move.l	ahiam_AudioID(a0),d0
		move.l	d0,4(a1)			;use selected mode.
		move.l	d0,ahi_mode_id

ahi_mode_info:	move.l	ahi_mode_txt,a0
		moveq.l	#128/4-1,d1
clr_ahi_txt:	clr.l	(a0)+
		dbra	d1,clr_ahi_txt

		move.l	ahi_base,a6
		lea	ahi_attrs_tags,a1
		move.l	ahi_mode_txt,4(a1)
		jsr	AHI_GetAudioAttrsA(a6)

		move.l	ahi_mode_txt,a0
		moveq.l	#128-1,d0
search_txt_end:	tst.b	(a0)+
		beq.s	search_txt_x
		dbra	d0,search_txt_end

search_txt_x:	subq.l	#1,a0				;output the frequency.
		move.w	#" (",(a0)+
		move.l	ahi_mix_freq,d0

		move.l	d0,d1
		divu.l	#1000000,d1
		beq.s	search_txt_qqq
		add.b	#48,d1
		move.b	d1,(a0)+
		sub.b	#48,d1
		mulu.l	#1000000,d1
		sub.l	d1,d0
search_txt_qqq:	move.l	d0,d1
		divu.l	#100000,d1
		beq.s	search_txt_qq
		add.b	#48,d1
		move.b	d1,(a0)+
		sub.b	#48,d1
		mulu.l	#100000,d1
		sub.l	d1,d0
search_txt_qq:	divu.w	#10000,d0
		beq.s	search_txt_q
		add.b	#48,d0
		move.b	d0,(a0)+
		clr.w	d0
search_txt_q:	swap	d0
		divu.w	#1000,d0
		add.b	#48,d0
		move.b	d0,(a0)+
		clr.w	d0
		swap	d0
		divu.w	#100,d0
		add.b	#48,d0
		move.b	d0,(a0)+
		clr.w	d0
		swap	d0
		divu.w	#10,d0
		add.b	#48,d0
		move.b	d0,(a0)+
		swap	d0
		add.b	#48,d0
		move.b	d0,(a0)+
		move.l	#" Hz)",(a0)+
		clr.b	(a0)

		lea	sfx_ahi_text,a0
		move.b	#1,(a0)
		bsr.w	print_middle

		bra.w	get_message

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu edit misc
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_edit_misc:	bsr.w	function_window_output
		tst.l	d0
		beq.w	get_message

		cmp.l	#"MISC",function_status
		beq.w	get_message			;don't output this twice.

		bsr.w	gadgets_rmv
		bsr.w	back_pattern_function

		move.l	function_ptr,a4
		lea	misc_bevel_list,a5
		bsr.w	draw_bevel_list

		move.l	context_g_misc,a1
		move.l	(a1),a1
		bsr.w	gadgets_ins

		move.l	gad_tools_base,a6
		move.l	misc_b_code_list,a0
		move.l	function_ptr,a1
		sub.l	a2,a2
		lea	misc_b_code_list_change_tags,a3
		move.l	gg_label_list,4(a3)
		jsr	GT_SetGadgetAttrsA(a6)

		move.l	intuition_base,a6
		move.l	function_ptr,a0
		move.l	wd_RPort(a0),a0
		lea	misc_text_1,a1
		moveq.l	#0,d0
		moveq.l	#0,d1
		jsr	PrintIText(a6)

		IFEQ	GAMEBOY_USERS
		tst.b	key_status
		bne.s	no_misc_off
		ENDIF

yes_misc_off:	move.l	intuition_base,a6

		move.l	misc_b_3,a0
		move.l	function_ptr,a1
		sub.l	a2,a2
		jsr	OffGadget(a6)

		IFEQ	GAMEBOY_USERS
		bra.s	no_key_misc_off

no_misc_off:	move.l	key_file,a0
		add.l	key_serial_area(a0),a0
		jsr	(a0)
		ENDIF

no_key_misc_off:move.l	#misc_jmp_table,function_jmp
		move.l	#"MISC",function_status

		lea	misc_win_txt,a1
		bsr.w	change_win_title

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu edit prefs
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_edit_prefs:bsr.w	function_window_output
		tst.l	d0
		beq.w	get_message

		cmp.l	#"PREF",function_status
		beq.w	get_message			;don't output this twice.

		bsr.w	gadgets_rmv
		bsr.w	back_pattern_function

		move.l	function_ptr,a4
		lea	prefs_bevel_list,a5
		bsr.w	draw_bevel_list

		move.l	context_g_prefs,a1
		move.l	(a1),a1
		bsr.w	gadgets_ins

		tst.l	xpk_master_base
		bne.s	xpk_master_ok

		move.l	intuition_base,a6		;turn off all the xpk gadgets!
		move.l	prefs_g_battery,a0
		move.l	function_ptr,a1
		sub.l	a2,a2
		jsr	OffGadget(a6)

		move.l	prefs_g_gbs,a0
		move.l	function_ptr,a1
		sub.l	a2,a2
		jsr	OffGadget(a6)

		move.l	prefs_g_xpk,a0
		move.l	function_ptr,a1
		sub.l	a2,a2
		jsr	OffGadget(a6)

xpk_master_ok:	move.l	intuition_base,a6
		move.l	function_ptr,a0
		move.l	wd_RPort(a0),a0
		lea	prefs_text_1,a1
		moveq.l	#0,d0
		moveq.l	#0,d1
		jsr	PrintIText(a6)

		move.l	#prefs_jmp_table,function_jmp
		move.l	#"PREF",function_status

		lea	prefs_win_txt,a1
		bsr.w	change_win_title

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		change the function window title
;		INPUT:
;		a1	= pointer to the new title.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

change_win_title:
		move.l	intuition_base,a6
		move.l	function_ptr,a0
		sub.l	a2,a2
		jsr	SetWindowTitles(a6)
		rts

		move.l	prefs_file,a0
		lea	gameboy_colours,a1
		moveq.l	#8-1,d0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		save the configuration file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

prefs_save_default:
		move.l	prefs_file,a5

;		120*.B	= rom path.
;		120*.B	= gbs path.
;		120*.B	= prefs path.
;		120*.B	= battery path.
;		.W	= menu x.
;		.W	= menu y.
;		.W	= function x.
;		.W	= function y.
;		.L	= ahi mode id.
;		.L	= ahi mixing frequency.
;		.B	= sound master.
;		.B	= sound quality.
;		.B	= sound channel 1.
;		.B	= sound channel 2.
;		.B	= sound channel 3.
;		.B	= sound channel 4.
;		.L	= gameboy screen id.
;		.B	= render mode.
;		.B	= window scaling status.
;		.B	= refresh mode.
;		.B	= refresh scanline.
;		.B	= aga mode.
;		.B	= frame update scanline.
;		.B	= battery status.
;		.B	= battery xpk packing status.
;		.B	= xpk packing library.
;		.B	= xpk packing status.
;		.B	= controller.
;		.W	= wzonka x.
;		.W	= wzonka y.
;		.W	= wzonka dx.
;		.W	= wzonka dy.
;		8*.L	= colours.
;		.B	= sfx y update value.
;		.B	= forbid / permit status.
;		.B	= os screen speed limit.
;		32*20*.B= the 20 recent cartridge names.
;		.B	= volume value.
;		.B	= colour load status.

		move.l	prefs_str_1,a2
		bsr.w	move_req_path
		move.l	prefs_str_2,a2
		bsr.w	move_req_path
		move.l	prefs_str_3,a2
		bsr.w	move_req_path
		move.l	prefs_str_4,a2
		bsr.w	move_req_path

		move.l	menu_ptr,a0
		bsr.w	move_win_xy
		move.l	function_ptr,a0
		bsr.w	move_win_xy

		IFEQ	GAMEBOY_USERS
		move.l	ahi_mode_id,(a5)+
		move.l	ahi_mix_freq,(a5)+
		move.b	snd_master,(a5)+
		move.b	snd_quality,(a5)+
		move.b	snd_chnlI,(a5)+
		move.b	snd_chnlII,(a5)+
		move.b	snd_chnlIII,(a5)+
		move.b	snd_chnlIV,(a5)+
		ELSE
		move.l	#0,(a5)+
		move.l	#0,(a5)+
		move.b	#0,(a5)+
		move.b	#0,(a5)+
		move.b	#0,(a5)+
		move.b	#0,(a5)+
		move.b	#0,(a5)+
		move.b	#0,(a5)+
		ENDIF

		move.l	gb_screen_id+4,(a5)+
		move.b	old_render,(a5)+
		move.b	scaling_status,(a5)+
		move.b	old_refresh,(a5)+
		move.b	refresh_scanline,(a5)+
		move.b	aga_mode,(a5)+
		move.b	frame_update_number,(a5)+

		move.b	battery_status,(a5)+
		move.b	battery_xpk_status,(a5)+
		move.b	pck_method_number,(a5)+
		move.b	pck_xpk_status,(a5)+
		move.b	keystick,(a5)+

		lea	wzonka_window,a0
		move.l	wzonka_ptr,d0
		beq.s	no_wzonka_window_open
		move.l	d0,a1
		move.w	wd_LeftEdge(a1),nw_LeftEdge(a0)
		move.w	wd_TopEdge(a1),nw_TopEdge(a0)
no_wzonka_window_open:
		move.w	nw_LeftEdge(a0),(a5)+
		move.w	nw_TopEdge(a0),(a5)+

		bsr.w	get_wzonka_window_scaled_dimensions
		move.w	wzonka_window_x,(a5)+
		move.w	wzonka_window_y,(a5)+

		lea	gameboy_colours,a0
		moveq.l	#8-1,d0
copy_gameboy_colours:
		move.l	(a0)+,(a5)+
		dbra	d0,copy_gameboy_colours		

		move.b	sfx_y_update,(a5)+
		move.b	forbid_permit_status,(a5)+
		move.b	os_screen_speed_limit,(a5)+

		add.l	#32*20,a5

		move.b	sfx_volume_value,(a5)+
		move.b	colour_load_status,(a5)+
		move.b	fast_ram_bitmaps,(a5)+
		bsr.w	save_window_readback_pref

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		save the file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	dos_base,a6
		move.l	#prefs_file_name,d1
		move.l	#Mode_New,d2
		jsr	Open(a6)
		move.l	d0,file_hd
		beq.w	prefs_save_def_x

		move.l	d0,d1
		move.l	prefs_file,d2
		move.l	#2048,d3
		jsr	Write(a6)

		move.l	file_hd,d1
		jsr	Close(a6)

prefs_save_def_x:
		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		save window position
;		INPUT:
;		a0	= window ptr.
;		a5	= output.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

move_win_xy:	move.w	wd_LeftEdge(a0),(a5)
		move.w	wd_TopEdge(a0),2(a5)
		addq.l	#4,a5
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		save file path
;		INPUT:
;		a2	= string gadget.
;		a5	= output.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

move_req_path:	moveq.l	#120/4-1,d1
move_req_path_data:
		move.l	(a2)+,(a5)+
		dbra	d1,move_req_path_data
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		restore file path and change the requester path
;		INPUT:
;		d7	= another requester.
;		a2	= string gadget.
;		a4	= the requester.
;		a5	= output.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

move_req_path_and_change:
		move.l	a5,a3
		moveq.l	#120/4-1,d1
move_req_path_and_change_data:
		move.l	(a2)+,(a5)+
		dbra	d1,move_req_path_and_change_data
		move.l	a2,-(SP)

		move.l	a4,d0
		beq.s	move_req_path_and_change_data_no_a4_change_1

		move.l	req_tools_base,a6
		lea	req_change_tags,a0
		move.l	a3,4(a0)			;new def dir!
		move.l	a4,a1
		jsr	rtChangeReqAttrA(a6)		;change to the default dir.
move_req_path_and_change_data_no_a4_change_1:

		tst.l	d7
		beq.s	move_req_path_and_change_data_no_a4_change_2

		lea	req_change_tags,a0
		move.l	a3,4(a0)			;new def dir!
		move.l	d7,a1
		jsr	rtChangeReqAttrA(a6)		;change to the default dir.
move_req_path_and_change_data_no_a4_change_2:
		move.l	(SP)+,a2
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		load the configuration file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

prefs_load_default:
		move.l	dos_base,a6
		move.l	#prefs_file_name,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,file_hd
		beq.w	prefs_load_error

		move.l	d0,d1
		move.l	prefs_file,d2
		move.l	#2048,d3
		jsr	Read(a6)

		move.l	file_hd,d1
		jsr	Close(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get the values from the prefs file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	prefs_file,a2

		move.l	request_ptr_get_1,a4
		move.l	prefs_str_1,a5
		move.l	request_ptr_lo,d7
		bsr.w	move_req_path_and_change
		move.l	request_ptr_get_2,a4
		move.l	prefs_str_2,a5
		move.l	request_ptr_ss,d7
		bsr.w	move_req_path_and_change
		move.l	request_ptr_get_3,a4
		move.l	prefs_str_3,a5
		moveq.l	#0,d7
		bsr.w	move_req_path_and_change
		move.l	request_ptr_get_4,a4
		move.l	prefs_str_4,a5
		moveq.l	#0,d7
		bsr.w	move_req_path_and_change

		lea	menu_window,a0
		bsr.w	recieve_window_edges
		lea	function_window,a0
		bsr.w	recieve_window_edges

		IFEQ	GAMEBOY_USERS
		move.l	(a2)+,ahi_mode_id
		move.l	(a2)+,ahi_mix_freq
		move.b	(a2)+,snd_master
		move.b	(a2)+,snd_quality
		move.b	(a2)+,snd_chnlI
		move.b	(a2)+,snd_chnlII
		move.b	(a2)+,snd_chnlIII
		move.b	(a2)+,snd_chnlIV
		ELSE
		add.l	#4*2+6*1,a2
		ENDIF

		move.l	(a2)+,gb_screen_id+4

		move.l	a2,-(SP)
		move.l	req_tools_base,a6
		lea	req_change_screen_mode_tags,a0
		move.l	gb_screen_id+4,4(a0)
		move.l	request_ptr_sm,a1
		jsr	rtChangeReqAttrA(a6)		;change to the default dir.
		move.l	(SP)+,a2

		move.b	(a2)+,old_render
		move.b	(a2)+,scaling_status
		move.b	(a2)+,old_refresh
		move.b	(a2)+,refresh_scanline
		move.b	(a2)+,aga_mode
		move.b	(a2)+,frame_update_number

		move.b	(a2)+,battery_status
		move.b	(a2)+,battery_xpk_status
		move.b	(a2)+,pck_method_number
		move.b	(a2)+,pck_xpk_status
		move.b	(a2)+,keystick

		lea	wzonka_window,a0
		move.w	(a2)+,nw_LeftEdge(a0)
		move.w	(a2)+,nw_TopEdge(a0)
		move.w	(a2)+,wzonka_window_x
		move.w	(a2)+,wzonka_window_y

		lea	gameboy_colours,a0
		moveq.l	#8-1,d0
restore_gameboy_colours:
		move.l	(a2)+,(a0)+
		dbra	d0,restore_gameboy_colours		

		move.b	(a2)+,sfx_y_update
		move.b	(a2)+,forbid_permit_status
		move.b	(a2)+,os_screen_speed_limit

		add.l	#32*20,a2

		move.b	(a2)+,sfx_volume_value
		move.b	(a2)+,colour_load_status
		move.b	(a2)+,fast_ram_bitmaps
		bsr.w	load_window_readback_pref

		move.l	xpk_names,a0
		moveq.l	#0,d0
		move.b	pck_method_number,d0
		move.l	(a0,d0.l*4),pck_method		;xpk library.

		move.b	frame_update_number,d0
		addq.b	#1,d0
		move.b	d0,frame_update

		bsr.b	get_wzonka_window_flags
		bsr.b	fix_volume_tables

prefs_load_error:
		rts

; A tagged extension in the unused tail keeps legacy preference offsets intact.
save_window_readback_pref:
		move.l	#$57445242,(a5)+		;"WDRB"
		move.b	window_direct_readback,(a5)+
		rts

load_window_readback_pref:
		clr.b	window_direct_readback
		cmp.l	#$57445242,(a2)+
		bne.s	window_readback_pref_done
		cmp.b	#1,(a2)
		bne.s	window_readback_pref_done
		move.b	#1,window_direct_readback
window_readback_pref_done:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		recieve window edges
;		INPUT:
;		a2	= input.
;		a0	= window structure pointer.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

recieve_window_edges:
		move.w	(a2)+,nw_LeftEdge(a0)
		move.w	(a2)+,nw_TopEdge(a0)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get wzonka game window flags
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_wzonka_window_flags:
		lea	wzonka_window,a0
		moveq.l	#0,d0
		move.b	scaling_status,d0
		move.l	d0,d1
		mulu.l	#window_resize_idcmp,d0
		mulu.l	#WFLG_SIZEGADGET,d1
		or.l	#wzonka_idcmp,d0
		move.l	d0,nw_IDCMPFlags(a0)
		or.l	#wzonka_flags,d1
		move.l	d1,nw_Flags(a0)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		fix volume tables
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

fix_volume_tables:
		IFEQ	GAMEBOY_USERS

		moveq.l	#17,d0
		sub.b	sfx_volume_value,d0

		lea	sound_III_vol+4,a0
		move.l	#$10000,d1
		divu.l	d0,d1
		move.l	d1,d2
		subq.l	#2,d2
		move.l	d2,(a0)+
		lsr.l	#1,d1
		move.l	d1,d2
		subq.l	#2,d2
		move.l	d2,(a0)+
		lsr.l	#1,d1
		subq.l	#2,d1
		move.l	d1,(a0)+			;sound_III_vol done!

		lea	sound_env_volumes+4,a0
		move.l	#$10000/15,d1
		divu.l	d0,d1
		moveq.l	#15-1,d2
		moveq.l	#1,d3

sound_env_volumes_composer:
		move.l	d1,d4
		mulu.l	d3,d4
		subq.l	#2,d4
		move.l	d4,(a0)+
		addq.b	#1,d3
		dbra	d2,sound_env_volumes_composer

		ENDIF

		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get the directory (rom)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_str_1:move.l	prefs_str_1,d7
		move.l	request_ptr_lo,a4
		move.l	request_ptr_get_1,a5
		move.l	prefs_g_str_1,d6
		bsr.s	get_prefs_str

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get the directory (gbs)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_str_2:move.l	prefs_str_2,d7
		move.l	request_ptr_ss,a4
		move.l	request_ptr_get_2,a5
		move.l	prefs_g_str_2,d6
		bsr.s	get_prefs_str

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get the directory (prefs)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_str_3:move.l	prefs_str_3,d7
		sub.l	a4,a4
		move.l	request_ptr_get_3,a5
		move.l	prefs_g_str_3,d6
		bsr.s	get_prefs_str

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get the directory (battery)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_str_4:move.l	prefs_str_4,d7
		sub.l	a4,a4
		move.l	request_ptr_get_4,a5
		move.l	prefs_g_str_4,d6
		bsr.s	get_prefs_str

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get the directory from the string gadget
;		INPUT:
;		d6	= the string gadget.
;		d7	= the string (output).
;		a4	= get requester.
;		a5	= changing requester.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_str:	move.l	gad_tools_base,a6
		move.l	d6,a0				;get the gadget.
		move.l	function_ptr,a1
		sub.l	a2,a2
		lea	prefs_g_str_chg,a3
		move.l	#prefs_str_ptr,4(a3)
		jsr	GT_GetGadgetAttrsA(a6)		;get the new text.

		move.l	d7,a0
		move.l	prefs_str_ptr,a1
		moveq.l	#120/4-1,d0
get_prefs_str_copy_name:
		move.l	(a1)+,(a0)+
		dbra	d0,get_prefs_str_copy_name

		move.l	prefs_str_ptr,a2
		move.l	def_dir,a0
		bsr.w	memorize_dir

		lea	req_change_tags,a0
		move.l	def_dir,4(a0)			;new def dir!
		move.l	req_tools_base,a6

		move.l	a4,d0
		beq.s	no_a4_change

		move.l	a4,a1
		jsr	rtChangeReqAttrA(a6)		;change to the default dir.

no_a4_change:	move.l	a5,a1
		lea	req_change_tags,a0
		jsr	rtChangeReqAttrA(a6)		;change to the default dir.
get_prefs_str_x:rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get the directory (rom)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_dir_1:move.l	prefs_str_1,d7
		move.l	request_ptr_lo,a4
		move.l	request_ptr_get_1,a5
		move.l	prefs_g_str_1,d6
		bsr.s	get_prefs_dir

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get the directory (gbs)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_dir_2:move.l	prefs_str_2,d7
		move.l	request_ptr_ss,a4
		move.l	request_ptr_get_2,a5
		move.l	prefs_g_str_2,d6
		bsr.s	get_prefs_dir

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get the directory (prefs)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_dir_3:move.l	prefs_str_3,d7
		sub.l	a4,a4
		move.l	request_ptr_get_3,a5
		move.l	prefs_g_str_3,d6
		bsr.s	get_prefs_dir

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get the directory (battery)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_dir_4:move.l	prefs_str_4,d7
		sub.l	a4,a4
		move.l	request_ptr_get_4,a5
		move.l	prefs_g_str_4,d6
		bsr.s	get_prefs_dir

		bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get the directory
;		INPUT:
;		d6	= the string gadget.
;		d7	= the string (output).
;		a4	= get requester.
;		a5	= changing requester.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_prefs_dir:	move.l	req_tools_base,a6
		lea	req_get_dir_tag,a0		;the tags.
		move.l	menu_ptr,4(a0)			;the position pointer.
		move.l	a5,a1				;the requester pointer.
		move.l	name_ptr,a2			;the output area.
		lea	request_get_dir,a3		;the title text.
		jsr	rtFileRequestA(a6)		;open a file requester.

		move.l	d7,a0
		move.l	rtfi_Dir(a5),a1
		moveq.l	#120/4-1,d0
get_prefs_dir_copy_name:
		move.l	(a1)+,(a0)+
		dbra	d0,get_prefs_dir_copy_name

		move.l	rtfi_Dir(a5),a2
		move.l	def_dir,a0
		bsr.w	memorize_dir			;memorize the dir.

		tst.l	d0				;from the requester.
		beq.w	get_prefs_dir_e			;error! none selected!

		move.l	a4,d0
		beq.s	no_change_a4

		move.l	a4,a1
		lea	req_change_tags,a0
		move.l	def_dir,4(a0)			;new def dir!
		jsr	rtChangeReqAttrA(a6)		;change to the default dir.

no_change_a4:	move.l	gad_tools_base,a6
		move.l	d6,a0				;get the gadget.
		move.l	function_ptr,a1
		sub.l	a2,a2
		lea	prefs_g_str_chg,a3
		move.l	def_dir,4(a3)
		jsr	GT_SetGadgetAttrsA(a6)		;set the new text.
get_prefs_dir_e:rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		save the twenty recently loaded cartridge names
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

save_20_recent:	move.l	dos_base,d0
		beq.s	exit_20
		tst.l	prefs_file
		beq.s	exit_20

		move.l	d0,a6
		move.l	#prefs_file_name,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,d7
		beq.w	exit_20

		move.l	d0,d1
		move.l	#560,d2				;to name fields.
		move.l	#OFFSET_BEGINNING,d3		;offset.
		jsr	Seek(a6)

		move.l	d7,d1
		move.l	prefs_file,d2
		add.l	#560,d2				;to name fields.
		move.l	#32*20,d3
		jsr	Write(a6)

		move.l	d7,d1
		jsr	Close(a6)
exit_20:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		delete five temporary gbs files
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

delete_five_gbs:
		IFEQ	GAMEBOY_USERS

		tst.b	key_status
		beq.s	delete_five_gbs_exit

		move.l	dos_base,d0
		beq.s	delete_five_gbs_exit
		move.l	d0,a6

		moveq.l	#5-1,d7
		move.b	#"5",d6

		move.l	dir_n_name_ptr,d0
		beq.s	delete_five_gbs_exit
		move.l	d0,a0				;the name of the file.
		move.l	#"T:Wz",(a0)+
		move.l	#"onka",(a0)+
		move.l	#"-Lad",(a0)+
		move.l	#".RT.",(a0)+
		move.w	#"GB",(a0)+
		move.b	#"S",(a0)+
		move.l	a0,a5
		move.b	d6,(a0)+
		clr.b	(a0)

delete_five_gbs_all:
		move.l	dir_n_name_ptr,d1
		jsr	DeleteFile(a6)

		subq.b	#1,d6
		move.b	d6,(a5)
		dbra	d7,delete_five_gbs_all

delete_five_gbs_exit:
		ENDIF
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		quit / exit
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

missing_diskfont:
		lea	err_diskfont,a0
		bra.s	missing_say
missing_dos:
		lea	err_dos,a0
		bra.s	missing_say
missing_graphics:
		lea	err_graphics,a0
		bra.s	missing_say
missing_intuition:
		lea	err_intuition,a0
		bra.s	missing_say
missing_reqtools:
		lea	err_reqtools,a0
		bra.s	missing_say
missing_gadtools:
		lea	err_gadtools,a0
		bra.s	missing_say

		IFEQ	GAMEBOY_USERS
missing_key:	lea	err_key,a0
		ENDIF

missing_say:	bsr.w	console_error

quit:
		IFNE	GFX_PROFILE
		bsr.w	gfx_profile_close
		ENDC
		IFGT	GAMEBOY_SERIAL

		bsr.w	serial_deallocate

		ENDIF

		bsr.w	save_20_recent
		bsr.w	save_battery_ram
		bsr.w	delete_five_gbs

		IFGT	GAMEBOY_DEBUG

		move.l	dos_base,a6
		move.l	debug_con_handle,d1
		jsr	Close(a6)

		ENDIF

		lea	cartridge_data,a5
		bsr.w	free_vec
		lea	rom_32k,a5
		bsr.w	free_vec
		lea	xpk_names_list,a5
		bsr.w	free_vec
		lea	xpk_names_all,a5
		bsr.w	free_vec
		lea	gg_list,a5
		bsr.w	free_vec

		move.l	pub_screen_lock,d0
		beq.s	no_pens_for_freeing
		lea	pen_list,a4
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

no_pens_for_freeing:
		move.l	pub_screen_lock,d0
		beq.s	no_pub_lock
		move.l	d0,a1
		sub.l	a0,a0				;no name.
		move.l	intuition_base,a6
		jsr	UnlockPubScreen(a6)

no_pub_lock:	move.l	request_ptr_lo,d0
		bsr.w	free_reqs
		move.l	request_ptr_ss,d0
		bsr.w	free_reqs
		move.l	request_ptr_sm,d0
		bsr.w	free_reqs
		move.l	request_ptr_get_1,d0
		bsr.w	free_reqs
		move.l	request_ptr_get_2,d0
		bsr.w	free_reqs
		move.l	request_ptr_get_3,d0
		bsr.w	free_reqs
		move.l	request_ptr_get_4,d0
		bsr.w	free_reqs

		move.l	font_ptr,d0
		beq.s	no_font				;no font opened.
		move.l	d0,a1
		move.l	graphics_base,a6
		jsr	CloseFont(a6)			;close the font.

no_font:	bsr.w	gadgets_rmv

		move.l	menu_ptr,d0
		beq.s	no_menu
		move.l	d0,a0
		move.l	intuition_base,a6
		jsr	ClearMenuStrip(a6)		;clear menus.

no_menu:	lea	menu_ptr,a5
		bsr.w	close_window
		lea	function_ptr,a5
		bsr.w	close_window
		lea	wzonka_ptr,a5
		bsr.w	close_window
		lea	register_ptr,a5
		bsr.w	close_window

		bsr.w	dbuf_dealloc			;free dbuf.
		bsr.w	free_gg_linked_list		;free game genie code list.

		move.l	context_g_menu,a5
		bsr.w	free_gadgets
		move.l	context_g_sfx,a5
		bsr.w	free_gadgets
		move.l	context_g_prefs,a5
		bsr.w	free_gadgets
		move.l	context_g_gfx,a5
		bsr.w	free_gadgets
		move.l	context_g_misc,a5
		bsr.w	free_gadgets

		move.l	visual_info,d0
		beq.s	no_visual_info
		move.l	d0,a0
		move.l	gad_tools_base,a6
		jsr	FreeVisualInfo(a6)

no_visual_info:	move.l	message_port,d0
		beq.s	no_message_port
		move.l	d0,a1
		move.l	exec_base,a6
		jsr	RemPort(a6)

		move.l	message_port,a0
		jsr	DeleteMsgPort(a6)

no_message_port:lea	gfx_game_still_tmp_map_attr,a1
		bsr.w	free_bit_maps

		lea	list_default,a5
		bsr.w	free_vectors			;free the allocated memory.

		bsr.w	close_graphics
		IFEQ	GAMEBOY_USERS
		bsr.w	close_ahi
		ENDIF

		move.l	cyber_base,d0
		bsr.b	free_libs
		move.l	xpk_master_base,d0
		bsr.b	free_libs
		move.l	low_level_base,d0
		bsr.b	free_libs
		move.l	control_pad_base,d0
		bsr.b	free_libs
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

console_error:	movem.l	d2-d4/a2/a5/a6,-(SP)
		move.l	a0,a2
		move.l	dos_base,d4
		bne.s	console_error_use

		move.l	exec_base,a6
		lea	dos_name,a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		move.l	d0,d4
		beq.s	console_error_out
		move.l	d0,a6
		bsr.s	console_error_write
		move.l	d4,a1
		move.l	exec_base,a6
		jsr	CloseLibrary(a6)
		bra.s	console_error_out

console_error_use:
		move.l	d4,a6
		bsr.s	console_error_write

console_error_out:
		movem.l	(SP)+,d2-d4/a2/a5/a6
		rts

console_error_write:
		jsr	Output(a6)
		move.l	d0,d1
		beq.s	console_error_write_x
		move.l	a2,a5
		move.l	a2,d2
console_error_len:
		tst.b	(a5)+
		bne.s	console_error_len
		subq.l	#1,a5
		sub.l	a2,a5
		move.l	a5,d3
		jsr	Write(a6)
console_error_write_x:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		misc closes
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

free_vec:	tst.l	(a5)
		beq.s	free_vec_x
		move.l	(a5),a1
		move.l	exec_base,a6
		jsr	FreeVec(a6)			;free the area.
		clr.l	(a5)
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

close_window:	tst.l	(a5)
		beq.s	close_window_x
		move.l	(a5),a0
		move.l	intuition_base,a6
		jsr	CloseWindow(a6)
		clr.l	(a5)
close_window_x:	rts

free_gadgets:	tst.l	(a5)
		beq.s	free_gadgets_x
		move.l	(a5),a0
		clr.l	(a5)
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
;		serial allocate
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFGT	GAMEBOY_SERIAL

serial_allocate:move.l	exec_base,a6
		jsr	CreateMsgPort(a6)
		move.l	d0,input_message_port
		beq.w	serial_allocate_error

		jsr	CreateMsgPort(a6)
		move.l	d0,output_message_port
		beq.w	serial_allocate_error

		move.l	input_message_port,a0
		move.l	#IOEXTSER_SIZE,d0
		jsr	CreateIORequest(a6)
		move.l	d0,io_request_in
		beq.w	serial_allocate_error

		move.l	output_message_port,a0
		move.l	#IOEXTSER_SIZE,d0
		jsr	CreateIORequest(a6)
		move.l	d0,io_request_out
		beq.s	serial_allocate_error

		lea	serial_device_name,a0
		move.l	io_request_in,a1
		bset.b	#5,IO_SERFLAGS(a1)		;shared access!
		moveq.l	#0,d0
		moveq.l	#0,d1
		jsr	OpenDevice(a6)
		tst.l	d0
		bne.s	serial_allocate_error

		lea	serial_device_name,a0
		move.l	io_request_out,a1
		bset.b	#5,IO_SERFLAGS(a1)		;shared access!
		moveq.l	#0,d0
		moveq.l	#0,d1
		jsr	OpenDevice(a6)
		tst.l	d0
		bne.s	serial_allocate_error

		move.b	#1,serial_device_status

		move.l	io_request_in,a1
		move.l	#1,IO_LENGTH(a1)
		move.l	io_buffer_in,IO_DATA(a1)
		move.w	#SDCMD_QUERY,IO_COMMAND(a1)
		jsr	DoIO(a6)
		tst.l	d0
		bne.s	serial_allocate_error

;		move.l	io_request_in,a0
;		move.w	IO_STATUS(a0),d0
;		btst	#5,d0
;		bne.s	serial_allocate_error

		moveq.l	#0,d0
		rts

serial_allocate_error:
		moveq.l	#1,d0
		rts

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		serial deallocate
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFGT	GAMEBOY_SERIAL

serial_deallocate:
		move.l	exec_base,a6
		move.l	io_request_in,d0
		beq.s	no_io_request_in
		move.l	d0,a1
		jsr	_LVOAbortIO(a6)

no_io_request_in:
		move.l	io_request_out,d0
		beq.s	no_io_request_out
		move.l	d0,a1
		jsr	_LVOAbortIO(a6)

		tst.b	serial_device_status
		beq.s	no_close_device
		move.l	io_request_in,a1
		jsr	CloseDevice(a6)
		move.l	io_request_out,a1
		jsr	CloseDevice(a6)

no_close_device:move.l	io_request_in,a0
		jsr	DeleteIORequest(a6)
		move.l	io_request_out,a0
		jsr	DeleteIORequest(a6)

no_io_request_out:
		move.l	input_message_port,d0
		beq.s	no_input_message_port
		move.l	d0,a0
		jsr	DeleteMsgPort(a6)

no_input_message_port:
		move.l	output_message_port,d0
		beq.s	no_output_message_port
		move.l	d0,a0
		jsr	DeleteMsgPort(a6)

no_output_message_port:
		rts

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		save rom prefs
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

save_prefs:	tst.l	cartridge
		beq.w	save_prefs_exit

		move.l	prefs_str_3,prefs_str_ptr
		bsr.w	get_cartridge_path_and_name
		move.l	#".pre",(a0)+			;the ending.
		move.w	#"fs",(a0)+
		clr.b	(a0)

		move.l	prefs_file_rom,a5
		lea	gameboy_colours,a1
		moveq.l	#8-1,d0
save_colours_apply:
		move.b	1(a1),(a5)+
		move.b	2(a1),(a5)+
		move.b	3(a1),(a5)+
		addq.l	#4,a1
		dbra	d0,save_colours_apply

		move.b	refresh_scanline,(a5)+
		move.b	frame_update_number,(a5)+

		sub.l	prefs_file_rom,a5

		move.l	dos_base,a6			;open the data file.
		move.l	dir_n_name_ptr,d1		;the name of the file.
		move.l	#Mode_New,d2
		jsr	Open(a6)
		move.l	d0,d7
		beq.w	save_prefs_exit

		move.l	d0,d1
		move.l	prefs_file_rom,d2
		move.l	a5,d3
		jsr	Write(a6)

		move.l	d7,d1
		jsr	Close(a6)

save_prefs_exit:bra.w	get_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		load the preferences for a cartridge
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

;		3*4*2.B	= colours.
;		.B	= refresh scanline.
;		.B	= frameskip.

load_prefs:	move.l	prefs_str_3,prefs_str_ptr
		bsr.w	get_cartridge_path_and_name
		move.l	#".pre",(a0)+			;the ending.
		move.w	#"fs",(a0)+
		clr.b	(a0)

		move.l	dos_base,a6
		move.l	dir_n_name_ptr,d1
		moveq.l	#ACCESS_READ,d2
		jsr	Lock(a6)
		move.l	d0,file_hd
		beq.w	load_prefs_error

		move.l	file_info_ptr,d2
		move.l	d0,d1
		jsr	Examine(a6)

		move.l	file_hd,d1
		jsr	UnLock(a6)

		move.l	file_info_ptr,a0
		move.l	fib_Size(a0),d7

		move.l	dos_base,a6
		move.l	dir_n_name_ptr,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,file_hd
		beq.w	load_prefs_error

		move.l	d0,d1
		move.l	prefs_file_rom,d2
		move.l	d7,d3
		jsr	Read(a6)

		move.l	file_hd,d1
		jsr	Close(a6)

		move.l	prefs_file_rom,a0
		add.l	#3*8,a0				;skip the colours.

		cmp.b	#30,d7
		beq.w	load_prefs_old_prefs_file
		cmp.b	#27,d7
		beq.s	load_prefs_new_prefs_file
		cmp.b	#26,d7
		beq.s	load_prefs_099_13_prefs_file
		cmp.b	#25,d7
		beq.s	load_prefs_097_prefs_file
		rts					;not a real prefs file.

load_prefs_099_13_prefs_file:
		move.b	(a0),refresh_scanline
		move.b	1(a0),d0
		move.b	d0,frame_update_number
		addq.b	#1,d0
		move.b	d0,frame_update
		bra.s	load_prefs_colours

load_prefs_097_prefs_file:
		move.b	(a0),refresh_scanline
		bra.s	load_prefs_colours

load_prefs_new_prefs_file:
		move.b	(a0),refresh_scanline
		bra.s	load_prefs_colours

load_prefs_old_prefs_file:
		addq.l	#4,a0				;skip frame skip and render.
		move.w	(a0),d0
		mulu.w	#3-1,d0
		divu.l	#MAXPOT,d0
		tst.b	d0
		beq.s	load_prefs_old_prefs_file_obsolete_1
		cmp.b	#1,d0
		beq.s	load_prefs_old_prefs_file_obsolete_2
		cmp.b	#2,d0
		beq.s	load_prefs_old_prefs_file_obsolete_3
		bra.s	load_prefs_colours

load_prefs_old_prefs_file_obsolete_1:
		bra.s	load_prefs_colours

load_prefs_old_prefs_file_obsolete_2:
		move.b	#144,refresh_scanline
		bra.s	load_prefs_colours

load_prefs_old_prefs_file_obsolete_3:
		move.b	#153,refresh_scanline

load_prefs_colours:
		tst.b	colour_load_status
		beq.s	load_prefs_colours_exit

		move.l	prefs_file_rom,a0
		lea	gameboy_colours,a1
		moveq.l	#8-1,d0

load_prefs_colours_apply:
		addq.l	#1,a1
		move.b	(a0)+,(a1)+
		move.b	(a0)+,(a1)+
		move.b	(a0)+,(a1)+
		dbra	d0,load_prefs_colours_apply

load_prefs_colours_exit:
		move.b	#1,gfx_values_need_update
		bsr.b	gfx_values_update

load_prefs_error:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		update gfx gadgets and colours
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gfx_values_update:
		tst.b	gfx_values_need_update
		beq.s	gfx_values_update_exit		;no need to update.

		tst.l	function_ptr
		beq.s	gfx_values_update_exit		;no window to update.

		cmp.l	#"GFX!",function_status
		bne.s	gfx_values_update_exit

		bsr.w	obtain_colours_apply		;use the colours.

		move.l	gfx_g_scanline_x,a0
		lea	alter_tags_slider,a3
		move.b	refresh_scanline,d0
		bsr.w	set_gadget_attributes

		move.l	gfx_g_frame_skip,a0
		lea	alter_tags_slider,a3
		move.b	frame_update_number,d0
		bsr.w	set_gadget_attributes

		clr.b	gfx_values_need_update		;updated.

gfx_values_update_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		load game_genie/game_genie.list
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_game_genie_list:
		move.l	dos_base,a6
		move.l	#gg_list_name,d1
		moveq.l	#ACCESS_READ,d2
		jsr	Lock(a6)
		move.l	d0,d7
		beq.s	load_game_genie_list_error

		move.l	file_info_ptr,d2
		move.l	d0,d1
		jsr	Examine(a6)

		move.l	d7,d1
		jsr	UnLock(a6)

		move.l	file_info_ptr,a0
		move.l	fib_Size(a0),gg_list_size

		move.l	#gg_list_name,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,d7
		beq.s	load_game_genie_list_error

		move.l	exec_base,a6
		move.l	gg_list_size,d0
		moveq.l	#MEMF_PUBLIC,d1
		jsr	AllocVec(a6)
		move.l	d0,gg_list
		beq.s	load_game_genie_list_error_close

		move.l	dos_base,a6
		move.l	d7,d1
		move.l	d0,d2
		move.l	gg_list_size,d3
		jsr	Read(a6)

load_game_genie_list_error_close:
		move.l	dos_base,a6
		move.l	d7,d1
		jsr	Close(a6)

load_game_genie_list_error:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		set gadget attributes
;		INPUT:
;		d0	= new value (.B).
;		a0	= gadget.
;		a3	= taglist.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

set_gadget_attributes:
		and.l	#$ff,d0
		move.l	d0,4(a3)
		move.l	gad_tools_base,a6
		move.l	function_ptr,a1
		sub.l	a2,a2
		jsr	GT_SetGadgetAttrsA(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		try to load and parse the twenty favourite rom images list
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

do_menu_items:	move.l	prefs_file,a0
		add.l	#560,a0				;to name fields.
		move.l	a0,men_I_txt
		add.l	#32,a0
		move.l	a0,men_II_txt
		add.l	#32,a0
		move.l	a0,men_III_txt
		add.l	#32,a0
		move.l	a0,men_IV_txt
		add.l	#32,a0
		move.l	a0,men_V_txt
		add.l	#32,a0
		move.l	a0,men_VI_txt
		add.l	#32,a0
		move.l	a0,men_VII_txt
		add.l	#32,a0
		move.l	a0,men_VIII_txt
		add.l	#32,a0
		move.l	a0,men_IX_txt
		add.l	#32,a0
		move.l	a0,men_X_txt
		add.l	#32,a0
		move.l	a0,men_1I_txt
		add.l	#32,a0
		move.l	a0,men_1II_txt
		add.l	#32,a0
		move.l	a0,men_1III_txt
		add.l	#32,a0
		move.l	a0,men_1IV_txt
		add.l	#32,a0
		move.l	a0,men_1V_txt
		add.l	#32,a0
		move.l	a0,men_1VI_txt
		add.l	#32,a0
		move.l	a0,men_1VII_txt
		add.l	#32,a0
		move.l	a0,men_1VIII_txt
		add.l	#32,a0
		move.l	a0,men_1IX_txt
		add.l	#32,a0
		move.l	a0,men_1X_txt

		move.l	dos_base,a6
		move.l	#menu_favo_nm,d1
		moveq.l	#ACCESS_READ,d2
		jsr	Lock(a6)
		move.l	d0,file_hd
		beq.w	menu_favo_erro

		move.l	file_info_ptr,d2
		move.l	file_hd,d1
		jsr	Examine(a6)

		move.l	file_hd,d1
		jsr	UnLock(a6)

		move.l	file_info_ptr,a0
		move.l	124(a0),file_length		;store the length.

		move.l	exec_base,a6
		move.l	file_length,d0
		moveq.l	#MEMF_PUBLIC,d1
		jsr	AllocVec(a6)
		move.l	d0,menu_favo_fl
		beq.w	menu_favo_erro

		move.l	dos_base,a6
		move.l	#menu_favo_nm,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,file_hd
		beq.w	menu_favo_erro

		move.l	d0,d1
		move.l	menu_favo_fl,d2
		move.l	file_length,d3
		jsr	Read(a6)

		move.l	file_hd,d1
		jsr	Close(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		now search and do the names
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	#menu_favourite,menu_recent	;add one menu more.

		moveq.l	#20-1,d0			;max names.
		move.l	menu_favo_nf,a0			;output.
		move.b	#"a",d1				;first letter.
menu_favo_find:	move.l	menu_favo_fl,a1			;input.
		move.l	file_length,d2			;size.
		move.b	d1,d3
		lsl.w	#8,d3
		move.b	#".",d3				;d3 = id word.
menu_favo_go:	cmp.w	(a1),d3
		beq.s	menu_favo_ef			;entry found!

menu_favo_nlin:	move.b	(a1),d4
		cmp.b	#$a,d4				;next line?
		bne.s	menu_favo_nnli			;nope.
		addq.l	#1,a1
		subq.l	#1,d2
		beq.s	menu_favo_nent			;end of file!
		bra.s	menu_favo_go			;new line, try again!

menu_favo_nnli:	addq.l	#1,a1
		subq.l	#1,d2
		bne.s	menu_favo_nlin			;loop through the data.

menu_favo_nent:	addq.b	#1,d1				;next letter.
		add.l	#32,a0				;next output entry.
		dbra	d0,menu_favo_find		;search for it.
		bra.s	menu_favo_ptrs			;all names are done.

menu_favo_ef:	addq.l	#3,a1				;skip the header plus one
		moveq.l	#32-1,d4			;space.
		move.l	a0,a2
menu_favo_ec:	move.b	(a1)+,d5
		cmp.b	#$a,d5
		beq.s	menu_favo_nent			;next entry.
		cmp.b	#0,d5
		beq.s	menu_favo_nent			;next entry.
		move.b	d5,(a2)+
		dbra	d4,menu_favo_ec			;next letter.
		bra.s	menu_favo_nent			;next entry.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy the name pointers
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_favo_ptrs:	move.l	menu_favo_nf,a0			;the names.
		move.l	a0,men_f_I_txt
		add.l	#32,a0
		move.l	a0,men_f_II_txt
		add.l	#32,a0
		move.l	a0,men_f_III_txt
		add.l	#32,a0
		move.l	a0,men_f_IV_txt
		add.l	#32,a0
		move.l	a0,men_f_V_txt
		add.l	#32,a0
		move.l	a0,men_f_VI_txt
		add.l	#32,a0
		move.l	a0,men_f_VII_txt
		add.l	#32,a0
		move.l	a0,men_f_VIII_txt
		add.l	#32,a0
		move.l	a0,men_f_IX_txt
		add.l	#32,a0
		move.l	a0,men_f_X_txt
		add.l	#32,a0
		move.l	a0,men_f_1I_txt
		add.l	#32,a0
		move.l	a0,men_f_1II_txt
		add.l	#32,a0
		move.l	a0,men_f_1III_txt
		add.l	#32,a0
		move.l	a0,men_f_1IV_txt
		add.l	#32,a0
		move.l	a0,men_f_1V_txt
		add.l	#32,a0
		move.l	a0,men_f_1VI_txt
		add.l	#32,a0
		move.l	a0,men_f_1VII_txt
		add.l	#32,a0
		move.l	a0,men_f_1VIII_txt
		add.l	#32,a0
		move.l	a0,men_f_1IX_txt
		add.l	#32,a0
		move.l	a0,men_f_1X_txt

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		favourite menu item compositor exit
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_favo_erro:	move.l	menu_favo_fl,d0
		beq.s	menu_favo_nof
		move.l	exec_base,a6
		move.l	d0,a1
		jsr	FreeVec(a6)

menu_favo_nof:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get cartridge name and path
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_cartridge_path_and_name:
		move.l	dir_n_name_ptr,a0
		moveq.l	#120/4-1,d0
load_colours_empty_buffer:
		clr.l	(a0)+
		dbra	d0,load_colours_empty_buffer

		move.l	dir_n_name_ptr,a0
		move.l	prefs_str_ptr,d0
		beq.s	load_colours_end_ok		;empty field.
		move.l	d0,a1
		moveq.l	#120-1,d0

load_colours_copy_path:
		move.b	(a1)+,(a0)+
		beq.s	load_colours_end_of_path
		dbra	d0,load_colours_copy_path

load_colours_end_of_path:
		subq.l	#1,a0

		move.l	a0,d0
		cmp.l	dir_n_name_ptr,d0
		beq.s	load_colours_end_ok		;no initial path.

		cmp.b	#"/",-1(a0)
		beq.s	load_colours_end_ok
		cmp.b	#":",-1(a0)
		beq.s	load_colours_end_ok
		move.b	#"/",(a0)+			;fix the path.

load_colours_end_ok:
		bsr.b	copy_rom_name_to_a0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy rom name to a0
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

copy_rom_name_to_a0:
		move.l	cartridge,a1
		add.l	#$134,a1			;input name.
		moveq.l	#16-1,d0
xopy_name_co:	move.b	(a1)+,d1
		bne.s	xopy_name_ok
		move.b	#" ",d1				;0 => " ".
xopy_name_ok:	cmp.b	#"/",d1
		bne.s	xo_slash_fix
		move.b	#"-",d1				;"/" => "-".
xo_slash_fix:	cmp.b	#$80,d1
		bne.s	xopy_mystery_fix
		move.b	#" ",d1
xopy_mystery_fix:
		move.b	d1,(a0)+
		dbra	d0,xopy_name_co
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		turn on/off the obtain-gadget?
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

obtain_status:	subq.b	#1,obtain_status_counter
		bne.s	obtain_status_x
		move.b	#4,obtain_status_counter

obtain_status_direct:
		move.l	exec_base,a6
		jsr	Forbid(a6)

		lea	message_port_colour_editor_name,a1
		jsr	FindPort(a6)
		move.l	d0,message_port_colour_editor
		jsr	Permit(a6)

		tst.l	message_port_colour_editor
		bne.s	obtain_on

obtain_off:	tst.l	obtain_gadget_status
		bne.s	obtain_status_x

		cmp.l	#"GFX!",function_status
		bne.s	obtain_status_x

		move.l	intuition_base,a6
		move.l	gfx_g_obtain,a0
		move.l	function_ptr,a1
		sub.l	a2,a2
		jsr	OffGadget(a6)

		move.l	#1,obtain_gadget_status
obtain_status_x:rts

obtain_on:	tst.l	obtain_gadget_status
		beq.s	obtain_status_on_get_message

		cmp.l	#"GFX!",function_status
		bne.s	obtain_status_on_get_message

		move.l	intuition_base,a6
		move.l	gfx_g_obtain,a0
		move.l	function_ptr,a1
		sub.l	a2,a2
		jsr	OnGadget(a6)

		clr.l	obtain_gadget_status
obtain_status_on_get_message:
		move.l	exec_base,a6
		move.l	message_port,a0
		jsr	GetMsg(a6)
		tst.l	d0
		beq.s	obtain_status_on_x

		move.l	LN_NAME(a0),a1
		move.l	d0,a0
		move.l	MN_REPLYPORT(a0),d1
		cmp.l	message_port_colour_editor,d1
		beq.s	send_new_colours
		cmp.l	message_port,d1
		beq.s	obtain_new_colours

obtain_status_reply:
		move.l	a0,a1
		jsr	ReplyMsg(a6)			;send the colours back.

obtain_status_on_x:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		send new colours
;		INPUT:
;		a0	= message.
;		a1	= data area (256.B).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

send_new_colours:
		lea	gameboy_colours,a2
		moveq.l	#8-1,d0
		lea	(MN_LENGTH+2)(a0),a3
copy_colours_data:
		move.l	(a2)+,d1
		move.b	d1,2(a3)
		lsr.l	#8,d1
		move.b	d1,1(a3)
		lsr.w	#8,d1
		move.b	d1,(a3)
		addq.l	#3,a3
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
		lea	gameboy_colours,a2
		moveq.l	#8-1,d0
		moveq.l	#0,d1
		lea	(MN_LENGTH+2)(a0),a3
obtain_colours_data:
		move.b	(a3)+,d1
		lsl.w	#8,d1
		move.b	(a3)+,d1
		lsl.l	#8,d1
		move.b	(a3)+,d1
		move.l	d1,(a2)+
		dbra	d0,obtain_colours_data

obtain_colours_apply:
		lea	pen_list,a4
		move.l	(a4),pen_storage_list		;save the pens.
		move.l	4(a4),pen_storage_list+4		

		lea	gameboy_colours,a3
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
		move.b	1(a3),d1
		move.b	2(a3),d2
		move.b	3(a3),d3
		ror.l	#8,d1
		ror.l	#8,d2
		ror.l	#8,d3
		move.l	a5,a0
		jsr	ObtainBestPenA(a6)
		move.b	d0,(a4)+
		addq.l	#4,a3
		dbra	d7,obtain_change_pens

		move.l	pen_list,d0
		cmp.l	pen_storage_list,d0
		bne.s	convert_all_pens		;pen(s) have changed.
		move.l	pen_list+4,d0
		cmp.l	pen_storage_list+4,d0
		bne.s	convert_all_pens
		rts					;no conversion.

convert_all_pens:
		move.l	gfx_game_still_array,a0
		move.l	gfx_game_still_tmp_array,a1
		lea	pen_list,a2
		move.w	#(304*39)-1,d0
		moveq.l	#0,d1
convert_pen_values:
		move.b	(a0)+,d1
		move.b	(a2,d1.l),(a1)+
		dbra	d0,convert_pen_values

		bsr.b	write_test_image

no_obtained_output:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		output the test image
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

write_test_image:
		cmp.l	#"GFX!",function_status
		bne.s	write_test_image_exit

		tst.l	cyber_base
		bne.s	write_test_image_with_cyber

		move.l	graphics_base,a6
		move.l	#34,d0
		move.l	#139,d1
		move.l	#34+303,d2
		move.l	#139+38,d3
		move.l	function_ptr,a0
		move.l	wd_RPort(a0),a0
		move.l	gfx_game_still_tmp_rast_port,a1
		move.l	gfx_game_still_tmp_array,a2
		jsr	WritePixelArray8(a6)

write_test_image_exit:
		rts

write_test_image_with_cyber:
		move.l	cyber_base,a6
		move.l	gfx_game_still_tmp_array,a0
		moveq.l	#0,d0
		moveq.l	#0,d1
		move.l	#304,d2
		moveq.l	#34,d3
		move.l	#139,d4
		move.l	#304,d5
		moveq.l	#39,d6
		move.l	#RECTFMT_LUT8,d7
		move.l	function_ptr,a1
		move.l	wd_RPort(a1),a1
		jsr	WritePixelArray(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		back pattern the function window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

back_pattern_function:
		move.l	graphics_base,a6
		move.l	back_pattern_map_attr,a0	;a0 = source bitmap.
		move.l	function_ptr,a1
		move.l	wd_RPort(a1),a1			;a1 = destination rastport.
		moveq.l	#0,d0				;org x.
		moveq.l	#0,d1				;org y.
		moveq.l	#0,d2				;dst x.
		moveq.l	#0,d3				;dst y.
		move.l	#function_x,d4			;size x.
		sub.l	window_bars_width,d4
		move.l	#function_y-2,d5		;size y.
		move.l	#$c0,d6				;minterm.
		jsr	BltBitMapRastPort(a6)		;update the screen window.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		draw a set of bevel boxes
;		INPUT:
;		a4	= window pointer.
;		a5	= bevel box list.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

draw_bevel_list:move.w	(a5)+,d0			;x.
		beq.s	draw_bevel_end
		move.w	(a5)+,d1			;y.
		move.w	(a5)+,d2			;dx.
		move.w	(a5)+,d3			;dy.
		move.l	a4,a0
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
;		a0	= window pointer.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

draw_bevel_box:	move.l	gad_tools_base,a6
		movem.l	d0-d3/a0,-(SP)

		move.l	wd_RPort(a0),a0
		lea	bevel_box_tags,a1
		move.l	visual_info,4(a1)
		jsr	DrawBevelBoxA(a6)

		movem.l	(SP)+,d0-d3/a0
		movem.l	d0-d3/a0,-(SP)

		move.l	wd_RPort(a0),a0
		addq.l	#1,d0
		addq.l	#1,d1
		subq.l	#2,d2
		subq.l	#2,d3
		lea	bevel_box_tagz,a1
		move.l	visual_info,4(a1)
		jsr	DrawBevelBoxA(a6)

		move.l	graphics_base,a6
		movem.l	(SP)+,d0-d3/a0

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
;		install gadgets
;		INPUT:
;		a1	= pointer to the first gadget of the list.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gadgets_ins:	move.l	a1,function_gad

		move.l	intuition_base,a6
		move.l	function_ptr,a0
		sub.l	a2,a2
		moveq.l	#-1,d0				;position.
		moveq.l	#-1,d1
		jsr	AddGList(a6)

		move.l	function_gad,a0
		move.l	function_ptr,a1
		sub.l	a2,a2
		moveq.l	#-1,d0				;all gadgets.
		jsr	RefreshGList(a6)

		move.l	gad_tools_base,a6
		move.l	function_ptr,a0
		sub.l	a1,a1
		jsr	GT_RefreshWindow(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		output data to function window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

function_window_output:
		moveq.l	#1,d0

		tst.l	function_ptr
		bne.s	function_window_output_exit

		move.l	intuition_base,a6
		lea	function_window,a0
		lea	win_tags_u,a1			;universal taglist.
		jsr	OpenWindowTagList(a6)		;structure and open the window.
		move.l	d0,function_ptr
		bne.s	function_window_output_exit

		lea	status_cant_open_window_txt,a5
		bsr.w	print_status_middle
		moveq.l	#0,d0

function_window_output_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		remove gadgets
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gadgets_rmv:	move.l	function_ptr,d0
		beq.s	gadgets_rmv_exit
		move.l	function_gad,d1
		beq.s	gadgets_rmv_x

		move.l	d0,a0
		move.l	d1,a1
		moveq.l	#-1,d0				;all gadgets.
		move.l	intuition_base,a6
		jsr	RemoveGList(a6)

		clr.l	function_gad
		clr.l	function_jmp

gadgets_rmv_x:	move.l	graphics_base,a6
		move.l	function_ptr,a1
		move.l	wd_RPort(a1),a1
		moveq.l	#0,d0
		moveq.l	#0,d1
		move.l	#function_x,d2
		sub.l	window_bars_width,d2
		move.l	#function_y-2-11,d3
		jsr	EraseRect(a6)

gadgets_rmv_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		open ahi
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS

open_ahi:	move.l	exec_base,a6
		jsr	CreateMsgPort(a6)

		move.l	d0,ahi_port
		beq.b	ahi_error

		move.l	d0,a0
		move.l	#AHIRequest_SIZEOF,d0
		jsr	CreateIORequest(a6)

		move.l	d0,ahi_ior
		beq.b	ahi_error

		lea	ahi_name,a0
		move.l	d0,a1
		clr.w	ahir_Version(a1)		;all versions are fine!
		move.l	#AHI_NO_UNIT,d0
		moveq.l	#0,d1
		jsr	OpenDevice(a6)

		move.l	d0,ahi_device
		bne.b	ahi_error

		move.l	ahi_ior,a0
		move.l	IO_DEVICE(a0),d0
		rts

ahi_error:	moveq.l	#0,d0
		rts

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		close ahi
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS

close_ahi:	move.l	ahi_base,d0
		beq.s	no_ahi_req
		move.l	d0,a6
		move.l	ahi_request,d0
		beq.s	no_ahi_req
		move.l	d0,a0
		jsr	AHI_FreeAudioRequest(a6)

no_ahi_req:	move.l	exec_base,a6
		tst.l	ahi_device
		beq.s	ahi_close_nd

		move.l	ahi_ior,a1
		jsr	CloseDevice(a6)

ahi_close_nd:	move.l	ahi_ior,d0
		beq.s	ahi_no_ior
		move.l	d0,a0
		jsr	DeleteIORequest(a6)

ahi_no_ior:	move.l	ahi_port,d0
		beq.s	ahi_no_msg_port
		move.l	d0,a0
		jsr	DeleteMsgPort(a6)

ahi_no_msg_port:rts

		ENDIF
 
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		open ahi
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

turn_ahi_on:
		IFEQ	GAMEBOY_USERS

		clr.l	ahi_audio_ctrl
		tst.b	snd_master
		bne.w	ahi_on_quit

		tst.l	ahi_base
		beq.w	ahi_on_quit

		move.b	$bfe001,old_led

		move.l	ahi_base,a6
		lea	ahi_alloc_tags,a1
		move.l	ahi_mode_id,4(a1)		;use the selected settings.
		move.l	ahi_mix_freq,12(a1)
		jsr	AHI_AllocAudioA(a6)
		move.l	d0,ahi_audio_ctrl
		beq.w	ahi_on_quit

		bsr.w	init_the_samples

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		use keyfile audio inits
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	exec_base,a6
		jsr	CacheClearU(a6)			;clear caches.

		move.l	gb_mem_jumps,a0
		bsr.w	key_sound_init

		move.l	exec_base,a6
		jsr	CacheClearU(a6)			;clear caches.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		init the sound registers
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

init_the_sound_registers:
		move.l	gb_memory,a2
		move.l	gb_mem_jumps,a6
		move.l	#$ff26,d7
		move.b	(a2,d7.l),d6
		bmi.s	normal_inits_powered
		jsr	([a6,d7.l*4])			;restore NR52 only; replay would overwrite DMG lengths.
		bra.w	normal_inits_wave

normal_inits_powered:
		clr.b	sound_I_onf_master
		clr.b	sound_II_onf_master
		clr.b	sound_III_onf_master
		clr.b	sound_IV_onf_master
		subq.w	#1,d7
		move.w	#$25-$10,d5

normal_inits_loop_1:
; Keep the forward label unmodified so PhxAss resolves it correctly.
		lea	sound_raw_regs,a0
		sub.l	#$ff10,a0
		move.b	(a0,d7.l),d6
		movem.l	d5/d7/a6,-(SP)

		jsr	([a6,d7.l*4])

		movem.l	(SP)+,d5/d7/a6
		subq.w	#1,d7
		dbra	d5,normal_inits_loop_1

		move.l	gb_mem_jumps,a6
		move.l	gb_memory,a2
		move.l	#$ff10,d7
		move.w	#$25-$10,d5

normal_inits_loop_2:
		lea	sound_raw_regs,a0
		sub.l	#$ff10,a0
		move.b	(a0,d7.l),d6
		movem.l	d5/d7/a6,-(SP)

		jsr	([a6,d7.l*4])

		movem.l	(SP)+,d5/d7/a6
		addq.w	#1,d7
		dbra	d5,normal_inits_loop_2

normal_inits_wave:
		move.l	gb_mem_jumps,a6
		move.l	gb_memory,a2
		move.l	#$ff30,d7
		move.w	#$3f-$30,d5

normal_inits_loop_3:
		move.b	(a2,d7.l),d6
		movem.l	d5/d7/a6,-(SP)

		jsr	([a6,d7.l*4])

		movem.l	(SP)+,d5/d7/a6
		addq.w	#1,d7
		dbra	d5,normal_inits_loop_3
		bsr.l	sound_restore_state

ahi_on_quit:
		ENDIF
		rts

key_sound_init:
		IFEQ	GAMEBOY_USERS
		move.l	key_file,a6
		add.l	#$ff00*4,a0
		lea	snd_master,a1
		lea	sound_routines,a2

		cmp.b	#2,snd_quality
		bne.s	normal_audio_decoding
		lea	sound_routines_for_y_driver,a2

normal_audio_decoding:
		add.l	key_sounds_init(a6),a6
		jsr	(a6)
		ENDIF
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		init the samples
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS

init_the_samples:
		tst.b	snd_chnlI
		bne.s	init_no_1

		move.l	smpl_info_I,a0
		move.l	#AHIST_M8S,ahisi_Type(a0)	;type.
		move.l	smpl_mem_3,ahisi_Address(a0)	;address.
		move.l	#8*512,ahisi_Length(a0)		;size.

		move.l	ahi_base,a6
		moveq.l	#0,d0				;sample number.
		move.l	#AHIST_SAMPLE,d1		;type.
		move.l	smpl_info_I,a0			;info field.
		move.l	ahi_audio_ctrl,a2		;ctrl.
		jsr	AHI_LoadSound(a6)

		moveq.l	#0,d0				;channel.
		moveq.l	#0,d1				;sample.
		moveq.l	#0,d2				;offset.
		move.l	#8*512,d3			;size (full).
		moveq.l	#0,d4
		bset	#AHISB_IMM,d4			;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetSound(a6)

init_no_1:	tst.b	snd_chnlII
		bne.s	init_no_2

		move.l	smpl_info_II,a0
		move.l	#AHIST_M8S,ahisi_Type(a0)	;type.
		move.l	smpl_mem_3,ahisi_Address(a0)	;address.
		move.l	#8*512,ahisi_Length(a0)		;size.

		moveq.l	#1,d0				;sample number.
		move.l	#AHIST_SAMPLE,d1		;type.
		move.l	smpl_info_II,a0			;info field.
		move.l	ahi_audio_ctrl,a2		;ctrl.
		jsr	AHI_LoadSound(a6)

		moveq.l	#1,d0				;channel.
		moveq.l	#1,d1				;sample.
		moveq.l	#0,d2				;offset.
		move.l	#8*512,d3			;size (full).
		moveq.l	#0,d4
		bset	#AHISB_IMM,d4			;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetSound(a6)

init_no_2:	tst.b	snd_chnlIII
		bne.s	init_no_3

		move.l	smpl_info_III,a0
		move.l	#AHIST_M8S,ahisi_Type(a0)	;type.
		move.l	smpl_III_mem,ahisi_Address(a0)	;address.
		move.l	#32,ahisi_Length(a0)		;size.

		moveq.l	#2,d0				;sample number.
		move.l	#AHIST_DYNAMICSAMPLE,d1		;type.
		move.l	smpl_info_III,a0		;info field.
		move.l	ahi_audio_ctrl,a2		;ctrl.
		jsr	AHI_LoadSound(a6)

		moveq.l	#2,d0				;channel.
		moveq.l	#2,d1				;sample.
		moveq.l	#0,d2				;offset.
		move.l	#32,d3				;size (full).
		moveq.l	#0,d4
		bset	#AHISB_IMM,d4			;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetSound(a6)

init_no_3:	tst.b	snd_chnlIV
		bne.s	init_no_4

		move.l	smpl_info_IV,a0
		move.l	#AHIST_M8S,ahisi_Type(a0)	;type.
		move.l	smpl_IV_mem,ahisi_Address(a0)	;address.
		move.l	#32767,ahisi_Length(a0)		;size.

		moveq.l	#3,d0				;sample number.
		move.l	#AHIST_SAMPLE,d1		;type.
		move.l	smpl_info_IV,a0			;info field.
		move.l	ahi_audio_ctrl,a2		;ctrl.
		jsr	AHI_LoadSound(a6)

		moveq.l	#3,d0				;channel.
		moveq.l	#3,d1				;sample.
		moveq.l	#0,d2				;offset.
		move.l	#32767,d3			;size (full).
		moveq.l	#0,d4
		bset	#AHISB_IMM,d4			;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetSound(a6)

init_no_4:	lea	ahi_ctrl_tags_I,a1
		move.b	#2,old_sound_I_duty
		move.b	#2,old_sound_II_duty
		clr.b	old_sound_IV_width
		clr.w	sound_I_f
		clr.w	sound_II_f
		clr.w	sound_III_f
		move.b	#36,sound_length_div
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_ControlAudioA(a6)
;		tst.l	d0
;		bne.s	ahi_error_I
		rts

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		turn ahi off
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

turn_ahi_off:
		IFEQ	GAMEBOY_USERS

		move.l	ahi_audio_ctrl,d0
		beq.s	ahi_off_xit
		move.l	d0,a2
		move.l	ahi_base,a6
		jsr	AHI_FreeAudio(a6)
		clr.l	ahi_audio_ctrl

		move.b	old_led,d1
		and.b	#%10,d1
		move.b	$bfe001,d0
		and.b	#%11111101,d0
		or.b	d1,d0
		move.b	d0,$bfe001

		ENDIF

ahi_off_xit:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		keyfile check and misc init routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_key:
		IFEQ	GAMEBOY_USERS

		bsr.b	load_key_do
		tst.l	d0
		beq.s	load_key_x

		lea	key_name,a0
		move.l	#"L:Wz",(a0)+
		move.l	#"onka",(a0)+
		move.l	#"-Lad",(a0)+
		move.l	#".KEY",(a0)+
		clr.b	(a0)

		bsr.b	load_key_do
load_key_x:	rts

load_key_do:	move.l	dos_base,a6
		move.l	#key_name,d1
		moveq.l	#ACCESS_READ,d2
		jsr	Lock(a6)
		move.l	d0,d7
		beq.w	load_key_quit

		move.l	file_info_ptr,d2
		move.l	d7,d1
		jsr	Examine(a6)

		move.l	d7,d1
		jsr	UnLock(a6)

		move.l	file_info_ptr,a0
		move.l	124(a0),d6

		move.l	#key_name,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,d7
		beq.s	load_key_quit

		move.l	d0,d1
		move.l	key_file,d2
		move.l	d6,d3
		jsr	Read(a6)

		move.l	d7,d1
		jsr	Close(a6)

		move.b	#1,key_status
		move.l	d6,key_size
		moveq.l	#0,d0
		rts

		ENDIF

load_key_quit:	moveq.l	#1,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		print a status text into the middle of a rastport
;		INPUT:
;		a5	= the text.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

print_status_middle:
		bsr.b	print_status_middle_erase
		bsr.b	print_status_middle_new
		rts

print_status_middle_erase:
		move.l	old_status_text,d0
		beq.s	print_status_middle_erase_exit
		lea	emulator_status_text,a4
		move.l	d0,emulator_status_txt
		clr.b	(a4)				;clear the old text.
		bsr.b	print_status_middle_do

print_status_middle_erase_exit:
		rts

print_status_middle_new:
		move.l	a5,old_status_text
		move.l	a5,emulator_status_txt
		lea	emulator_status_text,a4
		move.b	#1,(a4)
		bsr.b	print_status_middle_do
		rts

print_status_middle_do:
		move.l	intuition_base,a6
		move.l	a4,a0
		jsr	IntuiTextLength(a6)

		move.l	#menu_x,d1
		sub.l	d0,d1
		lsr.l	#1,d1
		move.l	d1,d0				;new x.

		move.l	menu_ptr,a0
		move.l	wd_RPort(a0),a0
		move.l	a4,a1
		moveq.l	#0,d1
		jsr	PrintIText(a6)			;print it.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		print a text into the middle of a rastport
;		INPUT:
;		a0	= the text.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

print_middle:	move.l	intuition_base,a6
		move.l	a0,a3
		jsr	IntuiTextLength(a6)

		move.l	#function_x,d1
		sub.l	d0,d1
		lsr.l	#1,d1
		move.l	d1,d0				;new x.

		move.l	function_ptr,a0
		move.l	wd_RPort(a0),a0
		move.l	a3,a1
		moveq.l	#0,d1
		jsr	PrintIText(a6)			;print it.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		print a text into the middle of a rastport
;		INPUT:
;		a0	= the text.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

print_middle_register:
		move.l	intuition_base,a6
		move.l	a0,a3
		jsr	IntuiTextLength(a6)

		move.l	#register_x,d1
		sub.l	d0,d1
		lsr.l	#1,d1
		move.l	d1,d0				;new x.

		move.l	register_ptr,a0
		move.l	wd_RPort(a0),a0
		move.l	a3,a1
		moveq.l	#0,d1
		jsr	PrintIText(a6)			;print it.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sort the xpk packer sub library names and create
;		a system list structure for the gadtools list gadget
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sort_xpk_names:	move.l	xpk_names_v,d0
		subq.w	#1,d0
		ble.s	sort_do_list

		subq.w	#1,d0
sort_xpk_names_bubble:
		move.w	d0,d1
		subq.w	#1,d1
		blt.s	sort_xpk_names_last_bubble
		move.l	xpk_names,a0
		lea	4(a0),a1
sort_xpk_names_sweep:
		move.l	(a0),d2
		cmp.l	(a1),d2
		blt.s	sort_xpk_names_no_swap
		move.l	(a1),(a0)
		move.l	d2,(a1)
sort_xpk_names_no_swap:
		addq.l	#4,a0
		addq.l	#4,a1
		dbra	d1,sort_xpk_names_sweep
		dbra	d0,sort_xpk_names_bubble
		bra.s	sort_do_list

sort_xpk_names_last_bubble:
		move.l	xpk_names,a0
		lea	4(a0),a1
sort_xpk_names_last_sweep:
		move.l	(a0),d2
		cmp.l	(a1),d2
		blt.s	sort_xpk_names_last_no_swap
		move.l	(a1),(a0)
		move.l	d2,(a1)
sort_xpk_names_last_no_swap:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		create list structure
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sort_do_list:
		IFEQ	GAMEBOY_USERS

		tst.b	key_status
		bne.s	xpk_key_yes

		ENDIF

		move.l	#3,xpk_names_v

		IFEQ	GAMEBOY_USERS

		bra.s	xpk_key_no

xpk_key_yes:	move.l	key_file,a0
		add.l	key_serial_area(a0),a0
		jsr	(a0)

		ENDIF

xpk_key_no:	move.l	xpk_names_v,d0
		beq.w	sort_do_no_names

		move.l	exec_base,a6
		move.l	#LN_SIZE+2,d1
		mulu.w	d1,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1	;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,xpk_names_list		;the pointer here.
		beq.w	sort_do_err

		move.l	xpk_names_v,d0
		lsl.l	#3,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1	;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,xpk_names_all		;the pointer here.
		beq.w	sort_do_err

sort_do_list_d:	move.l	xpk_names,a0			;.L names.
		move.l	xpk_names_list,a1		;list structure.
		move.l	xpk_names_all,a2		;names.
		move.l	xpk_label_list,a6

		move.l	a1,LH_HEAD(a6)
		move.l	a6,LN_PRED(a1)

		move.l	#LN_SIZE+2,d1
		move.l	xpk_names_v,d0
		sub.l	a3,a3
		subq.w	#1,d0
		beq.s	sort_do_list_ln			;only one node.

sort_do_list_c:	move.l	(a0)+,(a2)			;do the first node.
		clr.b	4(a2)
		move.l	a2,LN_NAME(a1)
		lea	(a1,d1.l),a3
		move.l	a3,LN_SUCC(a1)
		move.l	a1,a3
		addq.l	#8,a2				;next name.
		add.l	d1,a1				;     node.
		subq.w	#1,d0
		beq.s	sort_do_list_ln			;to last node.
		subq.w	#1,d0

sort_do_list_g:	move.l	(a0)+,(a2)
		clr.b	4(a2)
		move.l	a2,LN_NAME(a1)
		move.l	a3,LN_PRED(a1)
		lea	(a1,d1.l),a3
		move.l	a3,LN_SUCC(a1)
		move.l	a1,a3
		addq.l	#8,a2				;next name.
		add.l	d1,a1				;     node.
		dbra	d0,sort_do_list_g		;         .

sort_do_list_ln:move.l	(a0),(a2)			;do the last node.
		clr.b	4(a2)
		move.l	a2,LN_NAME(a1)
		move.l	a3,LN_PRED(a1)

		move.l	a1,LH_TAILPRED(a6)
		lea	LH_TAIL(a6),a5
		move.l	a5,LN_SUCC(a1)

sort_do_x:	moveq.l	#0,d0
		rts

sort_do_err:	moveq.l	#1,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		no xpk sub library names
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sort_do_no_names:
		move.l	exec_base,a6
		move.l	#LN_SIZE+2,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1	;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,xpk_names_list		;the pointer here.
		beq.w	sort_do_err

		moveq.l	#8,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1	;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,xpk_names_all		;the pointer here.
		beq.w	sort_do_err

		move.l	xpk_names_list,a1		;list structure.
		move.l	xpk_names_all,a2		;names.
		move.l	xpk_label_list,a6

		move.l	a1,LH_HEAD(a6)
		move.l	a6,LN_PRED(a1)

		move.w	#"N/",(a2)			;do the last node.
		move.b	#"A",2(a2)
		clr.b	3(a2)
		move.l	a2,LN_NAME(a1)

		move.l	a1,LH_TAILPRED(a6)
		lea	LH_TAIL(a6),a5
		move.l	a5,LN_SUCC(a1)

		moveq.l	#0,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the pen .W remapping table generator
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

do_pen_table:	cmp.b	#2,old_render
		bne.s	do_pen_table_exit

		lea	pen_list,a0
		lea	gameboy_colours_conversion_table,a1
		move.l	(a0)+,(a1)+
		move.b	(a0)+,d0
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	(a0)+,d0
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	(a0)+,d0
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	d0,(a1)+
		move.b	(a0),(a1)

		move.b	#%11100100,back_ground_colour_byte

		lea	gameboy_colours_conversion_table,a0
		move.l	pen_conversion_table,a1
		moveq.l	#16-1,d0
		moveq.l	#0,d3
do_conversion_table:
		moveq.l	#16-1,d1
do_conversion_table_copy:
		move.b	(a0,d0.l),d2
		lsl.w	#8,d2
		move.b	(a0,d1.l),d2
		move.b	d0,d3
		lsl.w	#8,d3
		move.b	d1,d3
		move.w	d2,(a1,d3.l*2)
		ror.w	#8,d2
		ror.w	#8,d3
		move.w	d2,(a1,d3.l*2)
		dbra	d1,do_conversion_table_copy
		dbra	d0,do_conversion_table

		bsr.w	update_bg_pal

		move.l	exec_base,a6
		jsr	CacheClearU(a6)			;clear caches.

do_pen_table_exit:

		IFEQ	GAMEBOY_USERS
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		create misc trouble for people with false keyfiles
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	#22,z80_cycles
		cmp.l	#300,key_size
		bgt.s	no_trouble_be_nice
		move.l	cartridge,a0
		move.b	$14d(a0),d0
		and.b	#%1,d0
		beq.s	no_trouble_be_nice

get_nasty:	move.l	#300,z80_cycles			;make things go a lot slower.

no_trouble_be_nice:
		ENDIF

		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the x flip table generator
;		TABLE:
;		.W	= flipped data (.B plane 0, .B plane 1).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

do_x_flip_t:	move.l	x_flip_table,a0			;input
		move.l	#$10000,d0			;this many (!).

		moveq.l	#0,d1				;d1 = the input word.
do_x_flip:	move.b	d1,d2
		bsr.b	flip_x_byte			;flip d2.B.
		lsl.w	#8,d2				;right byte left.
		ror.w	#8,d1				;left byte right.
		move.b	d1,d2				;d2 = x-flipped.B, left.B.
		bsr.b	flip_x_byte			;flip d2.B.
		ror.w	#8,d2				;move to the normal order.
		rol.w	#8,d1				;move to the normal order.
		move.w	d2,(a0)+			;store the flipped word.

		addq.w	#1,d1				;next entry.
		subq.l	#1,d0
		bne.s	do_x_flip			;next entry.
		rts					;exit.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the x byte flipper
;		INPUT:
;		a0	= RESERVED!
;		d0	= RESERVED!
;		d1	= RESERVED!
;		d2	= input.B, otherwise RESERVED!
;		OUTPUT:
;		d2	= output.B, otherwise RESERVED!
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

flip_x_byte:	move.b	d2,d3
		and.b	#%1,d2
		ror.b	#1,d2				;%0000000x done.

		move.b	d3,d4
		and.b	#%10,d4
		ror.b	#3,d4
		add.b	d4,d2				;%000000x0 done.

		move.b	d3,d4
		and.b	#%100,d4
		rol.b	#3,d4
		add.b	d4,d2				;%00000x00 done.

		move.b	d3,d4
		and.b	#%1000,d4
		rol.b	#1,d4
		add.b	d4,d2				;%0000x000 done.

		move.b	d3,d4
		and.b	#%10000,d4
		ror.b	#1,d4
		add.b	d4,d2				;%000x0000 done.

		move.b	d3,d4
		and.b	#%100000,d4
		ror.b	#3,d4
		add.b	d4,d2				;%00x00000 done.

		move.b	d3,d4
		and.b	#%1000000,d4
		rol.b	#3,d4
		add.b	d4,d2				;%0x000000 done.

		and.b	#%10000000,d3
		rol.b	#1,d3
		add.b	d3,d2				;%x0000000 done.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		open a specified file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_rom:	move.l	req_tools_base,a6
		lea	req_tags,a0			;the tags.
		move.l	menu_ptr,4(a0)			;the position pointer.
		move.l	request_ptr_lo,a1		;the requester pointer.
		move.l	name_ptr,a2			;the output area.
		lea	request_load,a3			;the title text.
		jsr	rtFileRequestA(a6)		;open a file requester.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		use this directory as the new default dir for
;		cartridge loading
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_load_cart:	move.l	request_ptr_lo,a2		;directory.
		move.l	rtfi_Dir(a2),a2
		move.l	def_dir,a0
		bsr.w	memorize_dir			;memorize the dir.

		tst.l	d0				;from the requester.
		beq.w	load_error_not_selected		;error! none selected!

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		save the old cartridge's battery ram
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		bsr.w	save_battery_ram

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copy the directory and name to a single array and
;		test if the file really exists
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	request_ptr_lo,a2		;directory.
		bsr.w	parse_req_name

		tst.b	load_menu_tag			;an old name load?
		bne.s	cli_load_here			;yes. from the menu list.

		move.l	dos_base,a6
		move.l	dir_n_name_ptr,d1		;the name.
		moveq.l	#ACCESS_READ,d2
		jsr	Lock(a6)
		move.l	d0,d1
		beq.s	cli_load_here			;skip the menu adding part

		jsr	UnLock(a6)			;unlock it. all is well!

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		now copy the cartridge name into the menu field
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	prefs_file,a0
		add.l	#560+32*18,a0			;to name fields.
		lea	32(a0),a1			;the last entry.
		moveq.l	#19-1,d0
roll_names:	move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.l	(a0),(a1)			;32 bytes.
		sub.l	#28+32,a0
		sub.l	#28+32,a1
		dbra	d0,roll_names

		move.l	name_ptr,a2			;name.
		moveq.l	#31-1,d0
copy_name_1st:	move.b	(a2)+,(a1)+
		dbra	d0,copy_name_1st
		clr.b	(a1)

		move.l	intuition_base,a6
		move.l	menu_ptr,a0
		jsr	ClearMenuStrip(a6)		;clear menus.

		move.l	menu_ptr,a0
		lea	menu_recent,a1
		jsr	SetMenuStrip(a6)		;add menus.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		find out if the file can be unpacked with xpk master
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

cli_load_here:	move.l	xpk_master_base,d0
		beq.w	no_xpk_open
		move.l	d0,a6
		lea	xfh_pointer,a0
		lea	xpk_in_tags,a1
		move.l	dir_n_name_ptr,4(a1)
		jsr	XpkOpen(a6)
		tst.l	d0
		bne.w	no_xpk_open

		bsr.w	get_packer_name

		move.l	xfh_pointer,a0			;a0 = xpkfib structure.
		move.l	xf_Type(a0),d0			;d0 = file type.
		cmp.l	#XPKTYPE_PACKED,d0		;is it packed?
		bne.w	quit_xpk			;no. it's something else.

		move.l	xf_ULen(a0),file_length		;uncompressed length.
		add.l	#XPK_MARGIN,file_length		;xpk margin area.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate memory
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		bsr.w	alloc_cart_mem			;allocate memory for
							;the cartridge.
		tst.l	d7
		beq.w	quit_xpk_e_mem			;not enough! quit.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		unpack the rom image
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	xpk_master_base,a6
		move.l	xfh_pointer,a0
		jsr	XpkClose(a6)

		move.l	dos_base,a6			;open the data file.
		move.l	dir_n_name_ptr,d1		;the name of the file.
		move.l	#Mode_Old,d2
		jsr	Open(a6)			;narsk.
		move.l	d0,file_hd
		beq.w	quit_xpk_e			;file error!

		lea	status_xpk_unpack_txt,a5
		bsr.w	print_status_middle

		move.l	xpk_master_base,a6
		lea	xpk_unp_tags,a0
		move.l	file_hd,4(a0)
		move.l	cartridge_data,12(a0)
		move.l	file_length,20(a0)		;output area length!
		jsr	XpkUnpack(a6)
		tst.l	d0
		bne.s	xpk_argh			;error here!

		move.l	dos_base,a6
		move.l	file_hd,d1
		jsr	Close(a6)			;click.

		sub.l	#XPK_MARGIN,file_length		;xpk margin area.
		bra.w	load_ok

xpk_argh:	move.l	dos_base,a6
		move.l	file_hd,d1
		jsr	Close(a6)			;click.

		bra.w	load_error_xpk_error

quit_xpk_e:	move.l	xpk_master_base,a6		;an error occurred!
		move.l	xfh_pointer,a0
		jsr	XpkClose(a6)

		bra.w	load_error_file_not_found

quit_xpk_e_mem:	move.l	xpk_master_base,a6		;an error occurred!
		move.l	xfh_pointer,a0
		jsr	XpkClose(a6)

		bra.w	load_error_not_enough_memory

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		memorize the dir
;		INPUT:
;		a0	= output.
;		a2	= input.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

memorize_dir:	moveq.l	#120-1,d1			;max letters.
		tst.b	(a2)				;current directory?
		beq.s	xexit_path			;yes. skip this part.
xcopy_path:	move.b	(a2)+,d1
		beq.s	xexit_path			;path is done.
		move.b	d1,(a0)+			;output path.
		dbra	d1,xcopy_path			;next letter.

xexit_path:	clr.b	(a0)				;the end.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		normal dos open and loading
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

quit_xpk:	move.l	xpk_master_base,a6
		move.l	xfh_pointer,a0			;it was not packed.
		jsr	XpkClose(a6)

no_xpk_open:	move.l	dos_base,a6
		move.l	dir_n_name_ptr,d1
		moveq.l	#ACCESS_READ,d2
		jsr	Lock(a6)
		move.l	d0,d7
		beq.w	load_error_file_not_found

		move.l	file_info_ptr,d2
		move.l	d0,d1
		jsr	Examine(a6)

		move.l	d7,d1
		jsr	UnLock(a6)

		move.l	file_info_ptr,a0
		move.l	fib_Size(a0),file_length

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate memory
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		bsr.w	alloc_cart_mem			;allocate memory for
							;the cartridge.
		tst.l	d7
		beq.w	load_error_not_enough_memory	;not enough! quit.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		now load the file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	dos_base,a6
		move.l	dir_n_name_ptr,d1
		move.l	#Mode_Old,d2
		jsr	Open(a6)
		move.l	d0,d7
		beq.w	load_error_file_not_found

		move.l	d0,d1
		move.l	cartridge_data,d2
		move.l	file_length,d3
		jsr	Read(a6)

		move.l	d7,d1
		jsr	Close(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		create the bank switching table
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_ok:	move.l	file_length,cartridge_data_length
		clr.b	load_or_reset

load_ok_ok:	move.l	cartridge_data_length,file_length

;		move.l	gb_memory,a0
;		move.l	a0,a1				;output.
;		move.w	#$10000/4/4-1,d0
;		moveq.l	#0,d1
;empty_ram:	move.l	d1,(a0)+
;		move.l	d1,(a0)+
;		move.l	d1,(a0)+
;		move.l	d1,(a0)+
;		dbra	d0,empty_ram

gg_patch_apply:	clr.b	rom_type
		move.l	cartridge_data,a0

		move.l	file_length,d7
		divu.w	#16384,d7

		move.l	d7,d0
		swap	d0
		tst.w	d0
		beq.s	rom_size_okay

		sub.w	#512,d0
		bne.w	load_error_unknown_size

		move.b	#1,rom_type
		add.l	#512,a0

rom_size_okay:	and.l	#$ffff,d7
		move.l	a0,cartridge
		move.l	a0,a1
		move.l	rom_32k,a2

		cmp.b	#$19,$147(a0)
		bne.s	rom_mbc_is_not_5

		move.w	#$4000/4-1,d1
rom_mbc5_32k_0:	move.l	(a1)+,(a2)+
		dbra	d1,rom_mbc5_32k_0
		move.l	a0,a1
		move.w	#$4000/4-1,d1
rom_mbc5_32k_1:	move.l	(a1)+,(a2)+
		dbra	d1,rom_mbc5_32k_1

		bra.s	rom_bank_0_done

rom_mbc_is_not_5:
		move.w	#$8000/4-1,d1
rom_32k_0:	move.l	(a1)+,(a2)+
		dbra	d1,rom_32k_0

rom_bank_0_done:subq.l	#2,d7
		beq.s	rom_32k_created

		sub.l	#$4000,a1
		addq.l	#1,d7

rom_32k_n_more:	move.w	#$4000/4-1,d1
		move.l	a0,a3
rom_32k_n_0:	move.l	(a3)+,(a2)+
		dbra	d1,rom_32k_n_0

		move.w	#$4000/4-1,d1
rom_32k_n:	move.l	(a1)+,(a2)+
		dbra	d1,rom_32k_n

		subq.l	#1,d7
		bne.s	rom_32k_n_more

rom_32k_created:move.l	rom_32k,bank_address		;use area b0, b1.
		moveq.l	#0,d0				;no errors.
		rts

load_error_not_selected:
		moveq.l	#1,d0				;an error has occurred!
		rts

load_error_file_not_found:
		lea	status_file_not_found_txt,a5
		bsr.w	print_status_middle
		moveq.l	#2,d0				;an error has occurred!
		rts

load_error_xpk_error:
		lea	status_xpk_error_txt,a5
		bsr.w	print_status_middle
		moveq.l	#2,d0				;an error has occurred!
		rts

load_error_not_enough_memory:
		lea	status_not_enough_memory_txt,a5
		bsr.w	print_status_middle
		moveq.l	#2,d0				;an error has occurred!
		rts

load_error_unknown_size:
		lea	status_unknown_rom_size_txt,a5
		bsr.w	print_status_middle
		moveq.l	#2,d0				;an error has occurred!
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		cartridge loader memory handler
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

alloc_cart_mem:	bsr.b	free_cart_mem

		move.l	exec_base,a6
		move.l	file_length,d0
		moveq.l	#MEMF_PUBLIC,d1			;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,cartridge_data		;the pointer here.
		beq.s	alloc_cart_mem_error

		move.l	file_length,d0
		lsl.l	#1,d0
		moveq.l	#MEMF_PUBLIC,d1			;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,rom_32k			;the pointer here.
		beq.s	alloc_cart_mem_error

		moveq.l	#1,d7
		rts

alloc_cart_mem_error:
		moveq.l	#0,d7
		rts

free_cart_mem:	move.l	exec_base,a6
		move.l	cartridge_data,d0
		beq.s	free_cart_mem_allocate_rom_32k	;no cartridge loaded.
		move.l	d0,a1
		jsr	FreeVec(a6)			;free the old area.

free_cart_mem_allocate_rom_32k:
		move.l	rom_32k,d0
		beq.s	free_cart_mem_exit
		move.l	d0,a1
		jsr	FreeVec(a6)			;free the old area.

free_cart_mem_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get the xpk packer name that was used to pack the file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_packer_name:move.l	xfh_pointer,a0
		move.l	xf_ID(a0),status_xpk_name_u_txt
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		join the directory and name into a single expression
;		INPUT:
;		a2	= the requester pointer.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

parse_req_name:	move.l	dir_n_name_ptr,a0		;output.
		move.l	name_ptr,a1			;name.
		move.l	rtfi_Dir(a2),a2

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
;		compute a jump list for gameboy memory management
;		INPUT:
;		a0	= pointer to a cartridge (0 = n/a).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

compute_jmp_lst:move.l	a0,d0
		beq.w	no_jmp_list

		lea	mapper_list,a2
		moveq.l	#0,d0

		move.b	$147(a0),d0			;d0 = cartridge type.
		cmp.b	#$ff,d0
		bne.s	no_huc1

		move.l	#mapper_huc1_ram_battery,a2
		bra.s	mapper_ok_n

no_huc1:	move.l	(a2,d0.l*4),a2			;mapper selected.

mapper_ok_n:	move.b	$149(a0),d0			;d0 = amount of ram.
		and.b	#%11,d0				;max values.
		move.l	(a2,d0.l*4),a2			;list selected.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		INPUT:
;		a2	= cartridge memory structure
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	gb_mem_jumps,a1			;a1 = output table.
		move.l	#gb_mem_wr,d0
		move.l	#$10000,d1
gb_mem_init:	move.l	d0,(a1)+
		subq.l	#1,d1
		bne.s	gb_mem_init

		move.l	gb_mem_jumps,a1
		move.l	(a2)+,d0			;dbra amount of sections.
		move.l	(a2)+,d1			;dbra size of a section.
create_banking:	move.l	d1,d2
		move.l	(a2)+,d3

create_banking_move_data:
		move.l	d3,(a1)+
		dbra	d2,create_banking_move_data
		dbra	d0,create_banking

		move.l	gb_mem_jumps,a1
		add.l	#$c000*4,a1
		move.w	#$de00-$c000-1,d0
		move.l	#echo_up,d1
gb_mem_up:	move.l	d1,(a1)+
		dbra	d0,gb_mem_up

		move.l	gb_mem_jumps,a1
		add.l	#$e000*4,a1
		move.w	#$fe00-$e000-1,d0
		move.l	#echo_down,d1
gb_mem_down:	move.l	d1,(a1)+
		dbra	d0,gb_mem_down

		move.l	gb_mem_jumps,a1
		add.l	#$ff00*4,a1
		lea	ffxx_jmp_table,a2
		move.w	#$100-1,d0
gb_mem_ffxx:	move.l	(a2)+,(a1)+
		dbra	d0,gb_mem_ffxx

		move.l	gb_mem_jumps,a1
		add.l	#$fea0*4,a1
		move.l	#no_write,d1
		move.w	#$ff00-$fea0-1,d0
gb_mem_no_write:move.l	d1,(a1)+
		dbra	d0,gb_mem_no_write

		move.l	exec_base,a6
		jsr	CacheClearU(a6)			;clear the caches.

no_jmp_list:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		decode a gamegenie patch
;		OUTPUT:
;		d0	= new value.B.
;		d1	= address.W.
;		d2	= compare value.B.
;		d6	= state (0 = no errors / 1 = error).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

decode_gg_patch:lea	gg_patch,a1

		move.b	(a1),d7
		bsr.w	convert_ascii_to_hex
		tst.l	d6
		bne.w	decode_gg_patch_error
		move.b	d7,d0
		lsl.b	#4,d0
		move.b	1(a1),d7
		bsr.w	convert_ascii_to_hex
		tst.l	d6
		bne.w	decode_gg_patch_error
		or.b	d7,d0				;d0 = new value.B.

		moveq.l	#$f,d1
		move.b	5(a1),d7
		bsr.w	convert_ascii_to_hex
		tst.l	d6
		bne.w	decode_gg_patch_error
		btst	#3,d7
		bne.s	decode_gg_patch_address_ok

		moveq.l	#1,d6				;error in decoding!
		rts

decode_gg_patch_address_ok:
		sub.b	d7,d1
		lsl.b	#4,d1
		move.b	2(a1),d7
		bsr.b	convert_ascii_to_hex
		tst.l	d6
		bne.w	decode_gg_patch_error
		or.b	d7,d1
		lsl.w	#4,d1
		move.b	3(a1),d7
		bsr.b	convert_ascii_to_hex
		tst.l	d6
		bne.w	decode_gg_patch_error
		or.b	d7,d1
		lsl.w	#4,d1
		move.b	4(a1),d7
		bsr.b	convert_ascii_to_hex
		tst.l	d6
		bne.w	decode_gg_patch_error
		or.b	d7,d1				;d1 = address.W.

		move.b	6(a1),d7
		bsr.b	convert_ascii_to_hex
		tst.l	d6
		bne.s	decode_gg_patch_error
		move.b	d7,d2
		lsl.b	#4,d2
		move.b	8(a1),d7
		bsr.b	convert_ascii_to_hex
		tst.l	d6
		bne.s	decode_gg_patch_error
		or.b	d7,d2				;d2 = compare value.B.

		eor.b	#$ff,d2
		ror.b	#2,d2
		eor.b	#$45,d2

		move.b	6(a1),d7
		bsr.b	convert_ascii_to_hex
		tst.l	d6
		bne.s	decode_gg_patch_error
		move.b	d7,d3
		move.b	7(a1),d7
		bsr.b	convert_ascii_to_hex
		tst.l	d6
		bne.s	decode_gg_patch_error
		eor.b	d7,d3
		tst.l	d3
		beq.s	decode_gg_patch_all_ok
		and.b	#%11111000,d3
		bne.s	decode_gg_patch_all_ok

decode_gg_patch_error:
		moveq.l	#1,d6				;error in decoding!
		rts

decode_gg_patch_all_ok:
		moveq.l	#0,d6				;no errors!
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		convert ascii to hex
;		INPUT:
;		d7	= ascii.B.
;		OUTPUT:
;		d7	= hex.B.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

convert_ascii_to_hex:
		moveq.l	#0,d6
		and.l	#$ff,d7
		cmp.w	#"0",d7
		blt.s	convert_ascii_to_hex_no_number
		cmp.w	#"9",d7
		bgt.s	convert_ascii_to_hex_no_number
		sub.b	#"0",d7
		rts

convert_ascii_to_hex_no_number:
		cmp.w	#"A",d7
		blt.s	convert_ascii_to_hex_no_upper_case
		cmp.w	#"F",d7
		bgt.s	convert_ascii_to_hex_no_upper_case
		sub.b	#"A",d7
		add.b	#$a,d7
		rts

convert_ascii_to_hex_no_upper_case:
		cmp.w	#"a",d7
		blt.s	convert_ascii_to_hex_error
		cmp.w	#"f",d7
		bgt.s	convert_ascii_to_hex_error
		sub.b	#"a",d7
		add.b	#$a,d7
		rts

convert_ascii_to_hex_error:
		moveq.l	#1,d6				;error in decoding!
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the gameboy emulation routine. only fresh ROM and fresh
;		ROM with battery come here, GBS loading skips this part.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

run_cartridge:

use_loaded_battery_ram_x:
		move.l	memory_banks,a0
		move.l	gb_memory,a1
		add.l	#$A000,a1
		move.w	#$2000/4-1,d0
copy_ram_banks_x:
		move.l	(a0)+,(a1)+
		dbra	d0,copy_ram_banks_x

		move.l	gb_memory,a0
		add.l	#$c000,a0
		move.w	#$2000/4-1,d0
		move.l	#$51347394,d1
		moveq.l	#13,d2
		moveq.l	#17,d3
; Use a reproducible power-on pattern even for an all-zero cartridge.
dmg_boot_wram:	move.l	d1,d4
		lsl.l	d2,d4
		eor.l	d4,d1
		move.l	d1,d4
		lsr.l	d3,d4
		eor.l	d4,d1
		move.l	d1,d4
		lsl.l	#5,d4
		eor.l	d4,d1
		move.l	d1,(a0)+
		dbra	d0,dmg_boot_wram

		bsr.w	dmg_mirror_wram
		bsr.w	dmg_boot_vram

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		move on with the inits
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		bsr.w	gb_memory_at_start

		move.b	#$cf,buttons_byte
		move.b	#$cf,directions_byte
		move.b	#1,input_poll_lines

		clr.b	transfer_counter

		move.b	#1,i_flag			;disable interrupts.
		clr.b	z80_halt			;CPU is not halted.

		move.l	exec_base,a6
		jsr	CacheClearU(a6)			;any help?

		bsr.w	z80_start			;do the inits.
		IFEQ	Z80_MODE
		IFEQ	GAMEBOY_USERS
		bsr.w	dmg_boot_lcd_tail
		ENDIF
		ENDIF
		bsr.w	push_z80			;push all the registers.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the gameboy loop
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

lcd_slice_mode:	macro
		and.b	#$fc,$41(a6)
		move.l	h_values_indexed,a5
		IFEQ	Z80_MODE
		IFEQ	GAMEBOY_USERS
		moveq.l	#0,d6
		tst.b	lcd_blank_phase
		bmi.s	lcd_mode_set\@
		IFGT	\1
		tst.b	lcd_start_line
		bne.s	lcd_mode_set\@
		ENDIF
		ENDIF
		ENDIF
		move.b	(a5),d6
lcd_mode_set\@:	or.b	d6,$41(a6)
		endm

lcd_restart_check: macro
		IFEQ	Z80_MODE
		IFEQ	GAMEBOY_USERS
		tst.b	lcd_start_line
		bmi.w	lcd_restart
		ENDIF
		ENDIF
		endm

cartridge_loop:
		IFGT	GAMEBOY_DEBUG
		clr.b	debug_exit
		ENDIF

		bsr.w	pull_z80			;pull all the registers.
		IFEQ	Z80_MODE
		IFEQ	GAMEBOY_USERS
		tst.b	lcd_start_line
		bpl.s	lcd_frame_start
lcd_restart:	move.b	#1,lcd_start_line
		clr.b	irq_status_flags
		ENDIF
		ENDIF

lcd_frame_start:
		move.l	#h_values,h_values_indexed
		move.l	a2,a6
		add.l	#$ff00,a6
		clr.l	gb_scanlines			;start from scanline zero.
		clr.b	$44(a6)				;scanline zero.

next_sline:
		IFGT	GAMEBOY_DEBUG
		bsr.w	debug_scanline_out
		ENDIF

		tst.b	old_refresh
		bne.s	no_window_y_check
		bsr.w	window_y_check
no_window_y_check:
		IFLE	Z80_MODE

		cmp.l	#1,gb_scanlines
		bne.s	cmp_blank
		bclr.b	#1,irq_status_flags		;past $00, no vbr effect.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		execute a line comparison irq if enabled
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

cmp_blank:	btst.b	#7,$40(a6)			;lcd enabled?
		beq.s	cmp_up				;no.
		IFEQ	Z80_MODE
		IFEQ	GAMEBOY_USERS
		tst.b	lcd_start_line
		bne.s	cmp_up				;no coincidence on the LCD startup line.
		ENDIF
		ENDIF

		btst.b	#1,irq_status_flags		;vbr effect?
		beq.s	cmp_blank_no_filtering
		move.l	gb_scanlines,d7
;		beq.s	cmp_up				;$00 is off limits.
		cmp.l	#$91,d7
		bge.s	cmp_up				;$91-$99 are off limits, too.

cmp_blank_no_filtering:
		move.b	$45(a6),d7			;d7 = ly compare / lyc.
		cmp.b	$44(a6),d7
		bne.s	lyc_clear			;not the same.
		bset.b	#2,$41(a6)			;coincidence occurred.

		btst.b	#6,$41(a6)			;interrupt?
		beq.s	cmp_up				;nope. disabled.

		btst.b	#1,$ff(a6)			;lcd controller irq enabled?
		beq.s	cmp_up				;no.

cmp_starts:
		IFGT	GAMEBOY_DEBUG
		bsr.w	debug_blank
		ENDIF

		bset.b	#1,$0f(a6)			;lcd occurred.
		bset.b	#2,irq_status_flags		;lyc occurred.
		bra.s	cmp_up				;skip vbr.

lyc_clear:	bclr.b	#2,$41(a6)			;no coincidence.
cmp_up:

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		0/4
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

; Use a cadence coprime to 154 so polls aren't locked to the same LY values.
input_poll_scanline:
		subq.b	#1,input_poll_lines
		bne.s	no_input_this_time
		IFLE	Z80_MODE
		move.b	#53,input_poll_lines		;about three polls per frame.
		ELSE
		move.b	#79,input_poll_lines		;about two polls per frame.
		ENDIF

		movem.l	d0-d6/a0-a6,-(SP)
		bsr.w	inputs_read			;do the joystick input.
		movem.l	(SP)+,d0-d6/a0-a6
		bsr.w	input_irq

no_input_this_time:
		IFLE	Z80_MODE
		IFNE	Z80_MODE-GAMEBOY_USERS
		move.b	$07(a6),d7			;d7 = timer control byte.
		btst	#2,d7				;0 = stopped / 1 = counting.
		beq.s	no_timer_update_0		;0! no update.
		bsr.w	irq_timer
no_timer_update_0:
		ENDIF
		ENDIF

		lcd_slice_mode 1

		IFLE	Z80_MODE

		cmp.l	#143,gb_scanlines
		bne.s	no_vbr_lcd
		btst.b	#2,irq_status_flags		;lyc occurred?
		bne.s	no_lcd_irq_emulation_0		;mask vbr lcd irq out.

no_vbr_lcd:	cmp.l	#144,gb_scanlines
		bgt.s	no_lcd_irq_emulation_0
;		tst.b	i_flag
;		bne.s	no_lcd_irq_emulation_0
;		btst.b	#1,$ff(a6)			;lcd controller irq?
;		beq.s	no_lcd_irq_emulation_0		;no. quit.

		bsr.w	lcd_irq_eh

no_lcd_irq_emulation_0:
		ENDIF

		cmp.l	#144,gb_scanlines
		bne.s	no_vbr_blank			;no vbr interrupt.

vbr_blank:	btst.b	#7,$40(a6)			;lcd operation?
		beq.s	no_vbr_blank			;no. quit.

		clr.w	window_y_state
		bsr.w	lcd_blank_vblank
		IFNE	Z80_MODE
		btst.b	#0,$ff(a6)			;vbr irq?
		beq.s	no_vbr_blank			;no. quit.
		ENDIF

		bset.b	#1,irq_status_flags
		bset.b	#0,$0f(a6)			;vbr occurred.

		IFGT	GAMEBOY_DEBUG
		bsr.w	debug_vbr
		ENDIF

no_vbr_blank:	move.b	$0f(a6),d7
		and.b	$ff(a6),d7			;IE & IF.
		addq.l	#1,h_values_indexed
		and.b	#%11111,d7
		beq.s	no_interrupts_0

		cmp.b	#1,z80_halt			;STOP is not interrupt-woken.
		beq.s	no_interrupts_0
		clr.b	z80_halt			;wake HALT even with IME off.
		tst.b	i_flag
		bne.s	no_interrupts_0

dehalting_z80_0:move.l	a0,d6				;stack the pc.
		sub.l	z80_pc_base,d6
		clr.b	z80_halt

		btst	#0,d7
		bne.w	prior_i_0

		IFLE	Z80_MODE
		btst	#1,d7
		bne.w	prior_ii_0
		btst	#2,d7
		bne.w	prior_iii_0
		ENDIF

		btst	#3,d7
		bne.w	prior_iv_0

		bra.w	prior_v_0

no_interrupts_0:bsr.l	z80_run_slice_first

no_ei_return_0:
		lcd_restart_check
		IFGT	GAMEBOY_DEBUG
		tst.b	debug_exit
		bne.w	z80_halted
		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		1/4
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

cpu_halt_is_on_0:
		move.l	a2,a6
		add.l	#$ff00,a6

		IFLE	Z80_MODE
		IFNE	Z80_MODE-GAMEBOY_USERS
		move.b	$07(a6),d7			;d7 = timer control byte.
		btst	#2,d7				;0 = stopped / 1 = counting.
		beq.w	no_timer_update_1		;0! no update.
		bsr.w	irq_timer
no_timer_update_1:
		ENDIF
		ENDIF

		cmp.l	#$99,gb_scanlines
		bne.s	no_ly_fix
		clr.b	$44(a6)				;scanline zero (short last ly).

no_ly_fix:	subq.b	#1,transfer_counter
		bhi.w	no_transfer
		blt.w	no_transfer_reset

		bclr.b	#7,$2(a6)

		btst.b	#3,$ff(a6)
		beq.w	no_transfer

		bset.b	#3,$f(a6)
		move.b	#$ff,$1(a6)

		IFGT	GAMEBOY_SERIAL

		movem.l	d0-d7/a0-a6,-(SP)

		move.l	a6,a5
		move.l	io_buffer_out,a0
		move.b	$1(a5),(a0)

		move.l	exec_base,a6
		move.l	io_request_out,a1
		move.l	#1,IO_LENGTH(a1)
		move.l	io_buffer_out,IO_DATA(a1)
		move.w	#CMD_WRITE,IO_COMMAND(a1)
		jsr	DoIO(a6)
		tst.l	d0
		bne.s	quit_gb_io

		move.l	io_request_in,a1
		move.l	#1,IO_LENGTH(a1)
		move.l	io_buffer_in,IO_DATA(a1)
		move.w	#CMD_READ,IO_COMMAND(a1)
		jsr	DoIO(a6)
		tst.l	d0
		bne.s	quit_gb_io

		move.l	io_request_in,a1
		jsr	WaitIO(a6)

quit_gb_io:	move.l	io_buffer_in,a0
		move.b	(a0),$1(a5)

		movem.l	(SP)+,d0-d7/a0-a6

		ENDIF

no_transfer_reset:
		clr.b	transfer_counter

no_transfer:
		IFNE	Z80_MODE
		add.b	#1,$04(a6)			;legacy divider.
		ELSE
		IFNE	GAMEBOY_USERS
		add.b	#1,$04(a6)
		ENDIF
		ENDIF

		lcd_slice_mode 0

		IFLE	Z80_MODE
		cmp.l	#144,gb_scanlines
		bge.s	no_lcd_irq_emulation_1
;		tst.b	i_flag
;		bne.s	no_lcd_irq_emulation_1
;		btst.b	#1,$ff(a6)			;lcd controller irq?
;		beq.s	no_lcd_irq_emulation_1		;no. quit.

		bsr.w	lcd_irq_eh

no_lcd_irq_emulation_1:
		ENDIF

		move.b	$0f(a6),d7
		and.b	$ff(a6),d7			;IE & IF.
		addq.l	#1,h_values_indexed
		and.b	#%11111,d7
		beq.s	no_interrupts_1

		cmp.b	#1,z80_halt			;STOP is not interrupt-woken.
		beq.s	no_interrupts_1
		clr.b	z80_halt			;wake HALT even with IME off.
		tst.b	i_flag
		bne.s	no_interrupts_1

dehalting_z80_1:move.l	a0,d6				;stack the pc.
		sub.l	z80_pc_base,d6
		clr.b	z80_halt

		btst	#0,d7
		bne.w	prior_i_1

		IFLE	Z80_MODE
		btst	#1,d7
		bne.w	prior_ii_1
		btst	#2,d7
		bne.w	prior_iii_1
		ENDIF

		btst	#3,d7
		bne.w	prior_iv_1

		bra.w	prior_v_1

no_interrupts_1:bsr.l	z80_run_slice

no_ei_return_1:
		lcd_restart_check
		IFGT	GAMEBOY_DEBUG
		tst.b	debug_exit
		bne.w	z80_halted
		ENDIF

cpu_halt_is_on_1:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		2/4
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	a2,a6
		add.l	#$ff00,a6

		IFLE	Z80_MODE
		IFNE	Z80_MODE-GAMEBOY_USERS
		move.b	$07(a6),d7			;d7 = timer control byte.
		btst	#2,d7				;0 = stopped / 1 = counting.
		beq.w	no_timer_update_2		;0! no update.
		bsr.w	irq_timer
no_timer_update_2:
		ENDIF
		ENDIF

		lcd_slice_mode 0

		move.b	$0f(a6),d7
		and.b	$ff(a6),d7			;IE & IF.
		addq.l	#1,h_values_indexed
		and.b	#%11111,d7
		beq.s	no_interrupts_2

		cmp.b	#1,z80_halt			;STOP is not interrupt-woken.
		beq.s	no_interrupts_2
		clr.b	z80_halt			;wake HALT even with IME off.
		tst.b	i_flag
		bne.s	no_interrupts_2

dehalting_z80_2:move.l	a0,d6				;stack the pc.
		sub.l	z80_pc_base,d6
		clr.b	z80_halt

		btst	#0,d7
		bne.w	prior_i_2

		IFLE	Z80_MODE
		btst	#1,d7
		bne.w	prior_ii_2
		btst	#2,d7
		bne.w	prior_iii_2
		ENDIF

		btst	#3,d7
		bne.w	prior_iv_2

		bra.w	prior_v_2

no_interrupts_2:bsr.l	z80_run_slice_transfer

no_ei_return_2:
		lcd_restart_check
		IFGT	GAMEBOY_DEBUG
		tst.b	debug_exit
		bne.w	z80_halted
		ENDIF

cpu_halt_is_on_2:
		tst.b	old_refresh			;144/144 mode?
		bne.s	frame_draw_2
		bsr.w	window_y_advance
		tst.b	lcd_blank_phase
		bne.w	lcd_blank_output
		bsr.w	scanline_draw			;yes. draw a scanline.
		bra.s	xan_drawed_2

frame_draw_2:	tst.b	lcd_blank_phase
		bne.w	lcd_blank_output
		move.l	gb_scanlines,d7
		cmp.b	refresh_scanline,d7
		bne.s	xan_drawed_2

		move.b	output_bit,d7
		cmp.b	frame_update,d7
		bne.s	xan_drawed_2

		bsr.w	screen_draw			;update the gameboy's screen.

xan_drawed_2:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		3/4
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	a2,a6
		add.l	#$ff00,a6

		IFLE	Z80_MODE
		IFNE	Z80_MODE-GAMEBOY_USERS
		move.b	$07(a6),d7			;d7 = timer control byte.
		btst	#2,d7				;0 = stopped / 1 = counting.
		beq.w	no_timer_update_3		;0! no update.
		bsr.w	irq_timer
no_timer_update_3:
		ENDIF
		ENDIF

		IFNE	Z80_MODE
		add.b	#1,$04(a6)			;legacy divider.
		ELSE
		IFNE	GAMEBOY_USERS
		add.b	#1,$04(a6)
		ENDIF
		ENDIF

		lcd_slice_mode 0

		IFLE	Z80_MODE
		cmp.l	#144,gb_scanlines
		bge.s	no_lcd_irq_emulation_3
;		tst.b	i_flag
;		bne.s	no_lcd_irq_emulation_3
;		btst.b	#1,$ff(a6)			;lcd controller irq?
;		beq.s	no_lcd_irq_emulation_3		;no. quit.

		bsr.w	lcd_irq_eh

no_lcd_irq_emulation_3:
		ENDIF

		move.b	$0f(a6),d7
		and.b	$ff(a6),d7			;IE & IF.
		addq.l	#1,h_values_indexed
		and.b	#%11111,d7
		beq.s	no_interrupts_3

		cmp.b	#1,z80_halt			;STOP is not interrupt-woken.
		beq.s	no_interrupts_3
		clr.b	z80_halt			;wake HALT even with IME off.
		tst.b	i_flag
		bne.s	no_interrupts_3

dehalting_z80_3:move.l	a0,d6				;stack the pc.
		sub.l	z80_pc_base,d6
		clr.b	z80_halt

		btst	#0,d7
		bne.w	prior_i_3

		IFLE	Z80_MODE
		btst	#1,d7
		bne.w	prior_ii_3
		btst	#2,d7
		bne.w	prior_iii_3
		ENDIF

		btst	#3,d7
		bne.w	prior_iv_3

		bra.w	prior_v_3

no_interrupts_3:bsr.l	z80_run_slice

no_ei_return_3:
		lcd_restart_check
		IFGT	GAMEBOY_DEBUG
		tst.b	debug_exit
		bne.w	z80_halted
		ENDIF

cpu_halt_is_on_3:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		4/4
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	a2,a6
		add.l	#$ff00,a6

		IFLE	Z80_MODE
		IFNE	Z80_MODE-GAMEBOY_USERS
		move.b	$07(a6),d7			;d7 = timer control byte.
		btst	#2,d7				;0 = stopped / 1 = counting.
		beq.w	no_timer_update_4		;0! no update.
		bsr.w	irq_timer
no_timer_update_4:
		ENDIF
		ENDIF

		lcd_slice_mode 0

		move.b	$0f(a6),d7
		and.b	$ff(a6),d7			;IE & IF.
		addq.l	#1,h_values_indexed
		and.b	#%11111,d7
		beq.s	no_interrupts_4

		cmp.b	#1,z80_halt			;STOP is not interrupt-woken.
		beq.s	no_interrupts_4
		clr.b	z80_halt			;wake HALT even with IME off.
		tst.b	i_flag
		bne.s	no_interrupts_4

dehalting_z80_4:move.l	a0,d6				;stack the pc.
		sub.l	z80_pc_base,d6
		clr.b	z80_halt

		btst	#0,d7
		bne.w	prior_i_4

		IFLE	Z80_MODE
		btst	#1,d7
		bne.w	prior_ii_4
		btst	#2,d7
		bne.w	prior_iii_4
		ENDIF

		btst	#3,d7
		bne.w	prior_iv_4

		bra.w	prior_v_4

no_interrupts_4:bsr.l	z80_run_slice_last

no_ei_return_4:
		lcd_restart_check
		IFGT	GAMEBOY_DEBUG
		tst.b	debug_exit
		bne.w	z80_halted
		ENDIF

cpu_halt_is_on_4:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		do envelope sweeps if selected
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS
		IFNE	Z80_MODE
		subq.b	#1,sound_length_div
		bne.s	sound_length_line_done
		move.b	#36,sound_length_div
		bsr.w	sound_length_clock
sound_length_line_done:
		ENDIF
		tst.b	snd_quality
		beq.w	snd_high_do
		ENDIF

snd_high_back:	cmp.l	#153,gb_scanlines		;end of lines?
		beq.w	next_frame			;next frame.

		addq.l	#1,gb_scanlines			;next scanline.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		next scanline, update registers
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

next_scanline:	move.l	a2,a6
		move.l	gb_scanlines,d7
		add.l	#$ff00,a6

		and.b	#%10,irq_status_flags		;clear oam and lyc flag.
		IFEQ	Z80_MODE
		IFEQ	GAMEBOY_USERS
		clr.b	lcd_start_line
		btst.b	#7,$40(a6)
		beq.w	next_sline
		ENDIF
		ENDIF
		move.b	d7,$44(a6)			;next scanline (address).
		bra.w	next_sline			;next horizontal line.

lcd_blank_output:
		tst.b	lcd_blank_presented
		bne.w	xan_drawed_2
		st	lcd_blank_presented
		bsr.w	screen_draw_blank
		bra.w	xan_drawed_2

lcd_blank_vblank:
		cmp.b	#1,lcd_blank_phase
		bne.s	lcd_blank_vblank_done
		move.b	#2,lcd_blank_phase
lcd_blank_vblank_done:
		rts

; Keep the image blank through VBlank too: x/153 can draw as late as LY=153.
lcd_blank_frame_end:
		cmp.b	#2,lcd_blank_phase
		bne.s	lcd_blank_frame_done
		clr.b	lcd_blank_phase
		clr.b	lcd_blank_presented
lcd_blank_frame_done:
		rts

; Latch WY at the start of a visible line, before the guest can change it
; in that line's STAT handler. DMG does not require an enabled window.
window_y_check:
		tst.b	window_y_latched
		bne.s	window_y_check_done
		move.l	gb_scanlines,d7
		cmp.b	#144,d7
		bhs.s	window_y_check_done
		cmp.b	$4a(a6),d7
		bne.s	window_y_check_done
		btst.b	#7,$40(a6)
		beq.s	window_y_check_done
		st	window_y_latched
window_y_check_done:
		rts

; Count guest window lines even when the host skips or blanks the image.
window_y_advance:
		tst.b	window_y_latched
		beq.s	window_y_advance_done
		cmp.l	#144,gb_scanlines
		bhs.s	window_y_advance_done
		move.b	$ff40(a2),d7
		and.b	#$a1,d7
		cmp.b	#$a1,d7
		bne.s	window_y_advance_done
		cmp.b	#167,$ff4b(a2)
		bhs.s	window_y_advance_done
		addq.b	#1,window_y_row
window_y_advance_done:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		input
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

input_irq:	move.b	(a6),d6
		bra.w	joypad_update

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		do audio sweeps
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS
snd_high_do:	tst.l	ahi_audio_ctrl
		beq.w	snd_high_back

		IFNE	Z80_MODE
		tst.b	snd_chnlI
		bne.w	snd_high_no_I_f

		tst.b	sound_I_f_envelope
		beq.w	snd_high_no_I_f

snd_high_continue_I_f:
		subq.l	#1,sound_I_f_envelope_counter
		bne.w	snd_high_no_I_f

		move.l	sound_I_f_envelope_counter_base,sound_I_f_envelope_counter

		move.l	a2,a6
		add.l	#$ff10,a6
		move.b	(a6),d6
		and.b	#$70,d6
		beq.w	snd_high_no_I_f

snd_high_I_f_calc:
		movem.l	d0-d3/a0-a2,-(SP)
		bsr.w	sound_sweep_calculate
		cmp.l	#2047,d0
		bhi.w	snd_high_I_f_over
		tst.b	d2
		beq.w	snd_high_I_f_pop
		move.l	d0,sound_I_f_initial_frequency
		move.b	d0,sound_I_fl
		lsr.w	#8,d0
		move.b	d0,sound_I_fh
		move.l	#2048,d2
		move.l	#1048576,d1
		sub.l	sound_I_f,d2
		divu.l	d2,d1
		move.l	ahi_base,a6
		moveq.l	#0,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency
		bsr.w	sound_sweep_calculate
		cmp.l	#2047,d0
		bhi.s	snd_high_I_f_over
		bra.s	snd_high_I_f_pop
snd_high_I_f_over:
		bsr.w	sound_sweep_disable
		move.l	ahi_base,a6
		moveq.l	#0,d0
		moveq.l	#0,d1
		move.l	sound_I_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume
snd_high_I_f_pop:
		movem.l	(SP)+,d0-d3/a0-a2

snd_high_no_I_f:
		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		volume envelopes
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.b	sound_I_v_envelope,d6
		beq.w	snd_high_no_I
		cmp.b	#2,d6
		beq.s	snd_high_continue_I

		clr.b	sound_I_v_envelope		;no further operations??

		move.l	a2,a6
		add.l	#$ff12,a6
		move.b	(a6),d7
		move.b	d7,d6
		and.l	#%111,d7
		beq.w	snd_high_no_I

		lsr.b	#4,d6
		move.b	d6,sound_I_v_envelope_initial_volume

		mulu.w	#144,d7
		move.l	d7,sound_I_v_envelope_counter_base
		move.l	d7,sound_I_v_envelope_counter
		move.b	#2,sound_I_v_envelope		;sweep is on!
		bra.w	snd_high_no_I

snd_high_continue_I:
		subq.l	#1,sound_I_v_envelope_counter
		bne.w	snd_high_no_I

		move.l	sound_I_v_envelope_counter_base,sound_I_v_envelope_counter
		move.b	sound_I_v_envelope_initial_volume,d7

		move.l	a2,a6
		add.l	#$ff00,a6
		btst.b	#3,$12(a6)
		beq.s	snd_high_I_dec

snd_high_I_inc:	add.b	#1,d7
		cmp.b	#16,d7
		bne.s	snd_high_I_new_volume

		clr.b	sound_I_v_envelope

		bra.w	snd_high_no_I

snd_high_I_dec:	subq.b	#1,d7
		bge.s	snd_high_I_new_volume

		clr.b	sound_I_v_envelope
		bra.s	snd_high_no_I

snd_high_I_new_volume:
		move.b	d7,sound_I_v_envelope_initial_volume

		movem.l	d0-d3/a0-a2,-(SP)

		and.w	#%1111,d7
		lea	sound_env_volumes,a6
		move.l	(a6,d7.w*4),sound_I_v

		move.l	ahi_base,a6
		moveq.l	#0,d0
		moveq.l	#0,d1
		tst.l	sound_I_status
		bne.s	no_s_I_addk
		move.l	sound_I_v,d1
no_s_I_addk:	move.l	sound_I_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		movem.l	(SP)+,d0-d3/a0-a2

snd_high_no_I:	

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		channel 2 envelope
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.b	sound_II_v_envelope,d6
		beq.w	snd_high_no_II
		cmp.b	#2,d6
		beq.s	snd_high_continue_II

		clr.b	sound_II_v_envelope		;no further operations??

		move.l	a2,a6
		add.l	#$ff17,a6
		move.b	(a6),d7
		move.b	d7,d6
		and.l	#%111,d7
		beq.w	snd_high_no_II

		lsr.b	#4,d6
		move.b	d6,sound_II_v_envelope_initial_volume

		mulu.w	#144,d7
		move.l	d7,sound_II_v_envelope_counter_base
		move.l	d7,sound_II_v_envelope_counter
		move.b	#2,sound_II_v_envelope		;sweep is on!
		bra.w	snd_high_no_II

snd_high_continue_II:
		subq.l	#1,sound_II_v_envelope_counter
		bne.w	snd_high_no_II

		move.l	sound_II_v_envelope_counter_base,sound_II_v_envelope_counter
		move.b	sound_II_v_envelope_initial_volume,d7

		move.l	a2,a6
		add.l	#$ff00,a6
		btst.b	#3,$17(a6)
		beq.s	snd_high_II_dec

snd_high_II_inc:add.b	#1,d7
		cmp.b	#16,d7
		bne.s	snd_high_II_new_volume

		clr.b	sound_II_v_envelope

		bra.w	snd_high_no_II

snd_high_II_dec:subq.b	#1,d7
		bge.s	snd_high_II_new_volume

		clr.b	sound_II_v_envelope
		bra.s	snd_high_no_II

snd_high_II_new_volume:
		move.b	d7,sound_II_v_envelope_initial_volume

		movem.l	d0-d3/a0-a2,-(SP)

		and.w	#%1111,d7
		lea	sound_env_volumes,a6
		move.l	(a6,d7.w*4),sound_II_v

		move.l	ahi_base,a6
		moveq.l	#1,d0
		moveq.l	#0,d1
		tst.l	sound_II_status
		bne.s	no_s_II_addk
		move.l	sound_II_v,d1
no_s_II_addk:	move.l	sound_II_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		movem.l	(SP)+,d0-d3/a0-a2

snd_high_no_II:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		channel 4 envelope
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.b	sound_IV_v_envelope,d6
		beq.w	snd_high_no_IV
		cmp.b	#2,d6
		beq.s	snd_high_continue_IV

		clr.b	sound_IV_v_envelope		;no further operations??

		move.l	a2,a6
		add.l	#$ff21,a6
		move.b	(a6),d7
		move.b	d7,d6
		and.l	#%111,d7
		beq.w	snd_high_no_IV

		lsr.b	#4,d6
		move.b	d6,sound_IV_v_envelope_initial_volume

		mulu.w	#144,d7
		move.l	d7,sound_IV_v_envelope_counter_base
		move.l	d7,sound_IV_v_envelope_counter
		move.b	#2,sound_IV_v_envelope		;sweep is on!
		bra.w	snd_high_no_IV

snd_high_continue_IV:
		subq.l	#1,sound_IV_v_envelope_counter
		bne.w	snd_high_no_IV

		move.l	sound_IV_v_envelope_counter_base,sound_IV_v_envelope_counter
		move.b	sound_IV_v_envelope_initial_volume,d7

		move.l	a2,a6
		add.l	#$ff00,a6
		btst.b	#3,$21(a6)
		beq.s	snd_high_IV_dec

snd_high_IV_inc:add.b	#1,d7
		cmp.b	#16,d7
		bne.s	snd_high_IV_new_volume

		clr.b	sound_IV_v_envelope

		bra.w	snd_high_no_IV

snd_high_IV_dec:subq.b	#1,d7
		bge.s	snd_high_IV_new_volume

		clr.b	sound_IV_v_envelope
		bra.s	snd_high_no_IV

snd_high_IV_new_volume:
		move.b	d7,sound_IV_v_envelope_initial_volume

		movem.l	d0-d3/a0-a2,-(SP)

		and.w	#%1111,d7
		lea	sound_env_volumes,a6
		move.l	(a6,d7.w*4),sound_IV_v

		move.l	ahi_base,a6
		moveq.l	#3,d0
		moveq.l	#0,d1
		tst.l	sound_IV_status
		bne.s	no_s_IV_addk
		move.l	sound_IV_v,d1
no_s_IV_addk:	move.l	sound_IV_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		movem.l	(SP)+,d0-d3/a0-a2

snd_high_no_IV:	bra.w	snd_high_back

sound_length_clock:
		movem.l	d0-d3/a0-a2,-(SP)
		move.l	a2,a0
		add.l	#$ff00,a0

		btst.b	#6,$14(a0)
		beq.w	sound_length_II
		tst.b	sound_I_length
		beq.w	sound_length_II
		subq.b	#1,sound_I_length
		bne.w	sound_length_II
		clr.b	sound_I_v_envelope
		IFNE	Z80_MODE
		clr.b	sound_I_f_envelope
		ENDIF
		clr.l	sound_I_v
		bclr.b	#0,$26(a0)
		moveq.l	#0,d0
		bsr.w	sound_length_silence

sound_length_II:
		btst.b	#6,$19(a0)
		beq.w	sound_length_III
		tst.b	sound_II_length
		beq.w	sound_length_III
		subq.b	#1,sound_II_length
		bne.w	sound_length_III
		clr.b	sound_II_v_envelope
		clr.l	sound_II_v
		bclr.b	#1,$26(a0)
		moveq.l	#1,d0
		bsr.w	sound_length_silence

sound_length_III:
		btst.b	#6,$1e(a0)
		beq.w	sound_length_IV
		tst.w	sound_III_length
		beq.w	sound_length_IV
		subq.w	#1,sound_III_length
		bne.w	sound_length_IV
		bclr.b	#2,$26(a0)
		moveq.l	#2,d0
		bsr.w	sound_length_silence

sound_length_IV:
		btst.b	#6,$23(a0)
		beq.w	sound_length_clock_pop
		tst.b	sound_IV_length
		beq.w	sound_length_clock_pop
		subq.b	#1,sound_IV_length
		bne.w	sound_length_clock_pop
		clr.b	sound_IV_v_envelope
		clr.l	sound_IV_v
		bclr.b	#3,$26(a0)
		moveq.l	#3,d0
		bsr.w	sound_length_silence

sound_length_clock_pop:
		movem.l	(SP)+,d0-d3/a0-a2
		rts

sound_length_silence:
		tst.l	ahi_audio_ctrl
		beq.s	sound_length_silence_exit
		lea	snd_chnlI,a6
		tst.b	(a6,d0.w)
		bne.s	sound_length_silence_exit
		cmp.b	#2,snd_quality
		beq.s	sound_length_silence_exit
		movem.l	d0-d3/a0-a2,-(SP)
		move.l	ahi_base,a6
		lea	sound_I_pan,a0
		move.l	(a0,d0.w*4),d2
		moveq.l	#0,d1
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume
		movem.l	(SP)+,d0-d3/a0-a2
sound_length_silence_exit:
		rts

		IFEQ	Z80_MODE
; LCD-on ends the old slice at the write, without resetting DIV/TIMA.
lcd_start_request:
		st	lcd_start_line
		tst.b	sound_div_active
		beq.s	lcd_start_request_done
		bsr.l	sound_div_sync
		clr.l	sound_slice_tail
		clr.l	sound_div_budget
		sub.l	a5,a5
		cmp.b	#3,z80_ei_return
		beq.s	lcd_start_irq_check
		tst.b	z80_ei_return
		beq.s	lcd_start_request_done
		move.l	#1,z80_cycles_left	;finish_ei removes its temporary cycle.
lcd_start_request_done:
		rts
lcd_start_irq_check:
		clr.l	z80_cycles_left
		rts

; The timed-read caller has already debited the bus cycle. Project into
; the next slice only if that cycle starts past the current boundary.
lcd_stat_read:
		tst.b	sound_div_active
		beq.s	lcd_stat_read_raw
		tst.b	lcd_blank_phase
		bmi.s	lcd_stat_read_raw
		move.l	a5,d6
		add.l	sound_slice_tail,d6
		tst.b	z80_ei_return
		beq.s	lcd_stat_read_check
		add.l	z80_cycles_left,d6
		cmp.b	#3,z80_ei_return
		beq.s	lcd_stat_read_check
		subq.l	#1,d6
lcd_stat_read_check:
		cmp.l	#-1,d6
		bge.s	lcd_stat_read_raw
		move.l	h_values_indexed,d6
		beq.s	lcd_stat_read_raw
		move.l	d6,a6
		moveq.l	#0,d6
		move.b	$ff41(a2),d6
		and.b	#$fc,d6
		or.b	(a6),d6
		rts
lcd_stat_read_raw:
		moveq.l	#0,d6
		move.b	$ff41(a2),d6
		rts

; At cartridge entry LY already reads 0, but the LCD is still in VBlank.
; Run the last 52 dots of line 153 before the first full scanline.
dmg_boot_lcd_tail:
		move.b	#$85,$ff41(a2)
		clr.b	$ff44(a2)
		moveq.l	#13,d6
		bra.s	sound_cpu_begin_slice

; Split CPU slices at DIV-APU edges and pending timer IRQ deadlines,
; not on individual wave fetches or TIMA increments.
sound_cpu_slice:
		move.l	z80_cycles,d6
		bra.s	sound_cpu_begin_slice
; At normal speed: 20 / (22+21) / (22+29) M-cycles. The first
; line after enabling LCD starts in mode 0 and is two M-cycles shorter.
sound_cpu_lcd_first:
		move.l	z80_cycles,d6
		subq.l	#2,d6
		tst.b	lcd_start_line
		beq.s	sound_cpu_begin_slice
		subq.l	#2,d6
sound_cpu_begin_slice:
		cmp.b	#1,z80_halt
		beq.w	sound_cpu_done
		add.l	z80_slice_debt,d6	;an instruction can finish past a slice boundary.
		ble.w	sound_cpu_debt
		move.l	d6,sound_slice_tail
sound_cpu_run:
		moveq.l	#0,d7
		move.w	sound_div_counter,d7
		and.w	#$1fff,d7
		lsr.w	#2,d7
		neg.w	d7
		add.w	#2048,d7
		move.l	sound_slice_tail,d6
		cmp.l	d7,d6
		bls.s	sound_cpu_budget
		move.l	d7,d6
sound_cpu_budget:
		btst.b	#2,$ffff(a2)
		beq.s	sound_cpu_no_timer_limit
		bsr.w	timer_slice_limit
sound_cpu_no_timer_limit:
		sub.l	d6,sound_slice_tail
		move.l	d6,sound_div_budget
		move.l	d6,a5
		move.b	#1,sound_div_active
		moveq.l	#0,d7
		move.b	z80_irq_cycles,d7
		beq.s	sound_cpu_check_irq
		sub.l	d6,d7
		bpl.s	sound_cpu_irq_wait
		clr.b	z80_irq_cycles
		neg.l	d7
		move.l	d7,a5
		moveq.l	#0,d7
sound_cpu_check_irq:
		btst.b	#2,$ff0f(a2)
		beq.s	sound_cpu_fetch
		btst.b	#2,$ffff(a2)
		beq.s	sound_cpu_fetch
		clr.b	z80_halt
		tst.b	i_flag
		bne.s	sound_cpu_fetch
		bsr.l	reti_back
		bra.s	sound_cpu_ei
sound_cpu_fetch:
		tst.b	z80_halt
		bne.s	sound_cpu_idle
		moveq.l	#0,d7
		IFGT	GAMEBOY_DEBUG
		bsr.l	debug_output
		ELSE
		bsr.l	z80_fetch_opcode
		ENDIF
sound_cpu_ei:	tst.b	z80_ei_return
		beq.s	sound_cpu_elapsed
		bsr.l	finish_ei
		bra.s	sound_cpu_ei
sound_cpu_elapsed:
		cmp.b	#2,z80_halt
		bne.s	sound_cpu_sync
sound_cpu_idle:	move.l	a5,d6
		ble.s	sound_cpu_sync
		move.l	#0,a5			;HALT keeps DIV running.
		bra.s	sound_cpu_sync
sound_cpu_irq_wait:
		move.b	d7,z80_irq_cycles	;an entry can straddle two slices.
		move.l	#0,a5
sound_cpu_sync:	bsr.s	sound_div_sync
		clr.b	sound_div_active
		cmp.b	#1,z80_halt
		beq.s	sound_cpu_done
		move.l	a5,d6
		bpl.s	sound_cpu_tail
		add.l	d6,sound_slice_tail
sound_cpu_tail:	move.l	sound_slice_tail,d6
		bgt.w	sound_cpu_run
sound_cpu_debt:	move.l	d6,z80_slice_debt
sound_cpu_done:	rts

; Synchronize an APU/DIV write after the opcode debits its cycles. EI and
; deferred IRQ dispatch temporarily split the real remaining budget.
sound_div_sync:
		tst.b	sound_div_active
		beq.s	sound_div_sync_done
		movem.l	d6-d7/a6,-(SP)
		move.l	a5,d7
		tst.b	z80_ei_return
		beq.s	sound_div_remaining
		add.l	z80_cycles_left,d7
		cmp.b	#3,z80_ei_return
		beq.s	sound_div_remaining
		subq.l	#1,d7
sound_div_remaining:
		move.l	sound_div_budget,d6
		move.l	d7,sound_div_budget
		sub.l	d7,d6
		lsl.l	#2,d6
		add.l	d6,sound_wave_time
		bpl.s	sound_div_wave_done
		bsr.l	sound_wave_rebase_time
sound_div_wave_done:
		move.w	sound_div_counter,d7
		add.w	d6,sound_div_counter
		move.b	sound_div_counter,$ff04(a2)
		tst.w	timer_shift			;shift and reload phase are adjacent bytes.
		beq.s	sound_div_apu_edge
		bsr.w	timer_advance
sound_div_apu_edge:
		btst	#12,d7
		beq.s	sound_div_sync_pop
		btst.b	#4,sound_div_counter
		bne.s	sound_div_sync_pop
		bsr.s	sound_frame_edge
sound_div_sync_pop:
		movem.l	(SP)+,d6-d7/a6
sound_div_sync_done:
		rts

sound_div_reset:
		bsr.s	sound_div_sync
		bsr.w	timer_div_edge
		btst.b	#4,sound_div_counter
		beq.s	sound_div_clear
		clr.w	sound_div_counter
		bra.s	sound_frame_edge
sound_div_clear:clr.w	sound_div_counter
		rts

sound_frame_edge:
		btst.b	#7,$ff26(a2)
		beq.s	sound_frame_done
		addq.b	#1,sound_frame_phase
		and.b	#3,sound_frame_phase
		btst.b	#0,sound_frame_phase
		beq.s	sound_frame_done
		bsr.w	sound_length_clock
		cmp.b	#3,sound_frame_phase
		beq.l	sound_sweep_clock
sound_frame_done:
		rts

; d6 = elapsed T-cycles, d7.w = old divider. Count the falling edges in
; bulk, stopping only at overflows to account for the delayed reload.
timer_advance:
		tst.l	d6
		bne.s	timer_advance_nonzero
		rts
timer_advance_nonzero:
		movem.l	d0-d1/d6-d7/a6,-(SP)
		move.l	a2,a6
		add.l	#$ff00,a6
		cmp.b	#1,timer_phase
		bne.s	timer_advance_clear
		move.b	$06(a6),$05(a6)
		bset.b	#2,$0f(a6)
		cmp.l	#4,d6
		bne.s	timer_advance_clear
		move.b	#2,timer_phase
		bra.s	timer_advance_edges
timer_advance_clear:
		clr.b	timer_phase
timer_advance_edges:
		moveq.l	#0,d1
		move.b	timer_shift,d1
		beq.s	timer_advance_pop
		and.l	#$ffff,d7
		and.w	timer_mask,d7
		add.l	d7,d6
		move.w	d6,d7
		and.w	timer_mask,d7
		lsr.l	d1,d6
		beq.s	timer_advance_pop
timer_advance_ticks:
		moveq.l	#0,d0
		move.b	$05(a6),d0
		move.w	#256,d1
		sub.w	d0,d1
		sub.w	d1,d6
		blo.s	timer_advance_add
		bne.s	timer_advance_reload
		tst.w	d7
		beq.s	timer_advance_pending
		cmp.w	#4,d7
		bne.s	timer_advance_reload
		move.b	#2,timer_phase
timer_advance_reload:
		move.b	$06(a6),$05(a6)
		bset.b	#2,$0f(a6)
		tst.w	d6
		bne.s	timer_advance_ticks
		bra.s	timer_advance_pop
timer_advance_add:
		add.w	d1,d6
		add.b	d6,$05(a6)
		bra.s	timer_advance_pop
timer_advance_pending:
		clr.b	$05(a6)
		move.b	#1,timer_phase
timer_advance_pop:
		movem.l	(SP)+,d0-d1/d6-d7/a6
		rts

timer_div_edge:
		move.w	d6,-(SP)
		move.w	timer_bit,d6
		and.w	sound_div_counter,d6
		beq.s	timer_div_no_edge
		bsr.s	timer_extra_tick
timer_div_no_edge:
		move.w	(SP)+,d6
		rts

timer_extra_tick:
		cmp.b	#2,timer_phase
		beq.s	timer_extra_done
		addq.b	#1,$ff05(a2)
		bne.s	timer_extra_done
		move.b	#1,timer_phase
timer_extra_done:
		rts

; Decode TAC into the selected divider bit, edge mask and shift count.
; Input is d6.b. A zero bit/shift denotes a disabled timer.
timer_configure:
		btst	#2,d6
		bne.s	timer_configure_on
		clr.b	timer_shift
		clr.w	timer_bit
		rts
timer_configure_on:
		movem.l	d0-d1,-(SP)
		moveq.l	#3,d0
		and.b	d6,d0
		bne.s	timer_configure_shift
		moveq.l	#4,d0
timer_configure_shift:
		add.w	d0,d0
		addq.w	#2,d0
		move.b	d0,timer_shift
		subq.w	#1,d0
		moveq.l	#1,d1
		lsl.w	d0,d1
		move.w	d1,timer_bit
		add.w	d1,d1
		subq.w	#1,d1
		move.w	d1,timer_mask
		movem.l	(SP)+,d0-d1
		rts

; Cap d6 (M-cycles) at the next reload when the interrupt can wake the CPU.
timer_slice_limit:
		btst.b	#2,$ff0f(a2)
		bne.s	timer_limit_done
		cmp.b	#1,timer_phase
		beq.s	timer_limit_pending
		tst.b	timer_shift
		beq.s	timer_limit_done
		movem.l	d0-d1,-(SP)
		moveq.l	#0,d0
		move.b	$ff05(a2),d0
		neg.w	d0
		add.w	#256,d0
		moveq.l	#0,d1
		move.b	timer_shift,d1
		lsl.l	d1,d0
		moveq.l	#0,d7
		move.w	sound_div_counter,d7
		and.w	timer_mask,d7
		sub.l	d7,d0
		lsr.l	#2,d0
		addq.l	#1,d0
		cmp.l	d0,d6
		bls.s	timer_limit_pop
		move.l	d0,d6
timer_limit_pop:
		movem.l	(SP)+,d0-d1
timer_limit_done:
		rts
timer_limit_pending:
		moveq.l	#1,d6
		rts

; Register writes can bring the deadline forward. Return to the slice
; scheduler after the writing opcode, preserving its unspent cycles.
timer_replan:
		tst.b	sound_div_active
		beq.s	timer_replan_done
		btst.b	#2,$ffff(a2)
		beq.s	timer_replan_done
		tst.w	timer_shift
		beq.s	timer_replan_done
		tst.b	z80_ei_return
		bne.s	timer_replan_done
		move.l	a5,d6
		ble.s	timer_replan_done
		add.l	d6,sound_slice_tail
		move.l	#0,a5
		clr.l	sound_div_budget
timer_replan_done:
		rts

sound_div_rebase:
		move.l	a0,-(SP)
		move.l	gb_memory,a0
		clr.w	sound_div_counter
		move.b	$ff04(a0),sound_div_counter
		clr.b	sound_frame_phase
		clr.b	sound_div_active
		clr.b	timer_phase
		clr.l	z80_slice_debt
		move.l	d6,-(SP)
		move.b	$ff07(a0),d6
		bsr.w	timer_configure
		move.l	(SP)+,d6
		bsr.l	sound_wave_reset
		move.l	(SP)+,a0
		rts
		ENDIF

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		fill the RAM with predefined values
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gb_memory_at_start:
		clr.b	lcd_blank_phase
		clr.b	lcd_blank_presented
		clr.w	window_y_state
		IFEQ	Z80_MODE
		clr.b	lcd_start_line
		ENDIF
		move.l	gb_memory,a0
		add.l	#$ff00,a0

		move.b	#$CF,$00(a0)
		move.b	#$00,$01(a0)
		move.b	#$7E,$02(a0)
		move.b	#$AB,$04(a0)
		move.b	#$00,$05(a0)
		move.b	#$00,$06(a0)
		move.b	#%11111000,$07(a0)

		move.b	#$E1,$0F(a0)
		move.b	#$80,$10(a0)
		move.b	#$BF,$11(a0)
		move.b	#$F3,$12(a0)
		move.b	#$FF,$13(a0)
		move.b	#$BF,$14(a0)
		move.b	#$3F,$16(a0)
		move.b	#$00,$17(a0)
		move.b	#$FF,$18(a0)
		move.b	#$BF,$19(a0)
		move.b	#$7F,$1A(a0)
		move.b	#$FF,$1B(a0)
		move.b	#$9F,$1C(a0)
		move.b	#$FF,$1D(a0)
		move.b	#$BF,$1E(a0)
		move.b	#$FF,$20(a0)
		move.b	#$00,$21(a0)
		move.b	#$00,$22(a0)
		move.b	#$BF,$23(a0)
		move.b	#$77,$24(a0)
		move.b	#$F3,$25(a0)
		move.b	#$F1,$26(a0)

		move.b	#$06,$30(a0)		;cgb like wave ram init.
		move.b	#$FE,$31(a0)
		move.b	#$0E,$32(a0)
		move.b	#$7F,$33(a0)
		move.b	#$00,$34(a0)
		move.b	#$FF,$35(a0)
		move.b	#$58,$36(a0)
		move.b	#$DF,$37(a0)
		move.b	#$00,$38(a0)
		move.b	#$EC,$39(a0)
		move.b	#$00,$3A(a0)
		move.b	#$BF,$3B(a0)
		move.b	#$0C,$3C(a0)
		move.b	#$ED,$3D(a0)
		move.b	#$03,$3E(a0)
		move.b	#$F7,$3F(a0)

		move.b	#$91,$40(a0)
		move.b	#%10000000,$41(a0)
		move.b	#$00,$42(a0)
		move.b	#$00,$43(a0)
		move.b	#$00,$45(a0)
		move.b	#$FF,$46(a0)
		move.b	#$FC,$47(a0)
		move.b	#$FF,$48(a0)
		move.b	#$FF,$49(a0)
		move.b	#$00,$4A(a0)
		move.b	#$00,$4B(a0)
		move.b	#$00,$FF(a0)
		bsr.w	dmg_unmapped_io

		IFEQ	GAMEBOY_USERS
		clr.b	sound_I_onf_master
		clr.b	sound_II_onf_master
		clr.b	sound_III_onf_master
		clr.b	sound_IV_onf_master
		clr.b	sound_I_length
		clr.b	sound_II_length
		clr.w	sound_III_length
		clr.b	sound_IV_length
		move.b	#36,sound_length_div
		bsr.w	sound_import_regs
		IFEQ	Z80_MODE
		bsr.l	sound_div_rebase
		move.w	#$abcc,sound_div_counter	;DMG divider phase at PC=$0100.
		ENDIF
		ENDIF

		clr.b	irq_status_flags

		clr.b	mbc1_ram_protection_status
		clr.b	mbc2_ram_protection_status
		clr.b	mbc3_ram_protection_status
		clr.b	mbc3_latched_sec
		clr.b	mbc3_latched_min
		clr.b	mbc3_latched_hrs
		clr.b	mbc3_latched_dayl
		clr.b	mbc3_latched_dayh
		clr.b	mbc3_sec
		clr.b	mbc3_min
		clr.b	mbc3_hrs
		clr.b	mbc3_dayl
		clr.b	mbc3_dayh
		clr.b	mbc3_latch_a
		clr.b	mbc3_latch_b
		clr.b	mbc5_rom_bank
		clr.b	mbc5_rom_bank1
		clr.b	mbc5_rom_bank0

		clr.l	freq_storage
		rts

; CPU reads use the RAM image directly, so seed the unmapped bytes on
; both reset and GBS restore. The I/O write table ignores these addresses.
dmg_unmapped_io:
		move.l	gb_memory,a1
		add.l	#$ff00,a1
		moveq.l	#-1,d0
		move.b	d0,$03(a1)
		move.l	d0,$08(a1)
		move.w	d0,$0c(a1)
		move.b	d0,$0e(a1)
		move.b	d0,$15(a1)
		move.b	d0,$1f(a1)
		move.b	d0,$27(a1)
		move.l	d0,$28(a1)
		move.l	d0,$2c(a1)
		lea	$4c(a1),a1
		moveq.l	#$34/4-1,d0
dmg_unmapped_fill:
		move.l	#-1,(a1)+
		dbra	d0,dmg_unmapped_fill
		rts

dmg_mirror_wram:
		move.l	gb_memory,a1
		add.l	#$c000,a1
		lea	$2000(a1),a6
		move.w	#$1e00/4-1,d0
dmg_mirror_copy:
		move.l	(a1)+,(a6)+
		dbra	d0,dmg_mirror_copy
		rts

; Recreate the boot ROM's VRAM output without running the animation.
dmg_boot_vram:
		move.l	gb_memory,a0
		add.l	#$8000,a0
		move.w	#$2000/4-1,d0
dmg_boot_vram_clear:
		clr.l	(a0)+
		dbra	d0,dmg_boot_vram_clear
		sub.l	#$1ff0,a0
		move.l	cartridge,a1
		lea	$104(a1),a1
		moveq.l	#48-1,d0
dmg_boot_logo_byte:
		move.b	(a1)+,d1
		bsr.s	dmg_boot_logo_nibble
		bsr.s	dmg_boot_logo_nibble
		dbra	d0,dmg_boot_logo_byte
		move.l	#$3c004200,(a0)+
		move.l	#$b900a500,(a0)+
		move.l	#$b900a500,(a0)+
		move.l	#$42003c00,(a0)+

		move.l	gb_memory,a0
		add.l	#$9904,a0
		moveq.l	#1,d1
		moveq.l	#11,d0
dmg_boot_logo_top:
		move.b	d1,(a0)+
		addq.b	#1,d1
		dbra	d0,dmg_boot_logo_top
		move.b	#$19,(a0)
		lea	$14(a0),a0
		moveq.l	#11,d0
dmg_boot_logo_bottom:
		move.b	d1,(a0)+
		addq.b	#1,d1
		dbra	d0,dmg_boot_logo_bottom
		rts

dmg_boot_logo_nibble:
		moveq.l	#0,d2
		moveq.l	#3,d3
dmg_boot_logo_bit:
		lsl.b	#2,d2
		add.b	d1,d1
		bcc.s	dmg_boot_logo_zero
		or.b	#3,d2
dmg_boot_logo_zero:
		dbra	d3,dmg_boot_logo_bit
		move.b	d2,(a0)+
		clr.b	(a0)+
		move.b	d2,(a0)+
		clr.b	(a0)+
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		interrupt debugging
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFGT	GAMEBOY_DEBUG

debug_vbr:	movem.l	d0-d7/a0-a6,-(SP)

		move.l	#debug_vbr_txt,d2
		move.l	#debug_vbr_txt_end-debug_vbr_txt,d3
		move.l	dos_base,a6
		move.l	debug_con_handle,d1
		jsr	Write(a6)

		movem.l	(SP)+,d0-d7/a0-a6
		rts

debug_lcd:	movem.l	d0-d7/a0-a6,-(SP)

		move.l	#debug_lcd_txt,d2
		move.l	#debug_lcd_txt_end-debug_lcd_txt,d3
		move.l	dos_base,a6
		move.l	debug_con_handle,d1
		jsr	Write(a6)

		movem.l	(SP)+,d0-d7/a0-a6
		rts

debug_timer:	movem.l	d0-d7/a0-a6,-(SP)

		move.l	#debug_timer_txt,d2
		move.l	#debug_timer_txt_end-debug_timer_txt,d3
		move.l	dos_base,a6
		move.l	debug_con_handle,d1
		jsr	Write(a6)

		movem.l	(SP)+,d0-d7/a0-a6
		rts

debug_p10:	movem.l	d0-d7/a0-a6,-(SP)

		move.l	#debug_p10_txt,d2
		move.l	#debug_p10_txt_end-debug_p10_txt,d3
		move.l	dos_base,a6
		move.l	debug_con_handle,d1
		jsr	Write(a6)

		movem.l	(SP)+,d0-d7/a0-a6
		rts

debug_blank:	movem.l	d0-d7/a0-a6,-(SP)

		move.l	#debug_blank_txt,d2
		move.l	#debug_blank_txt_end-debug_blank_txt,d3
		move.l	dos_base,a6
		move.l	debug_con_handle,d1
		jsr	Write(a6)

		movem.l	(SP)+,d0-d7/a0-a6
		rts

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		output scanline number
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFGT	GAMEBOY_DEBUG

debug_scanline_out:
		movem.l	d0-d7/a0-a6,-(SP)

		lea	debug_scanline,a1
		move.l	gb_scanlines,d0
		lsr.w	#8,d0
		tput_d0_to_a1
		move.l	gb_scanlines,d0
		tput_d0_to_a1

		move.l	#debug_scanline_message,d2
		move.l	#debug_scanline_message_end-debug_scanline_message,d3
		move.l	dos_base,a6
		move.l	debug_con_handle,d1
		jsr	Write(a6)

		movem.l	(SP)+,d0-d7/a0-a6
		rts

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		use value y to update the sound registers
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS
sfx_update_all:	tst.l	ahi_audio_ctrl
		beq.w	sfx_back

		move.l	sfx_y_adder,d0
		add.l	d0,sfx_y_actual_value
		move.l	sfx_y_actual_value,d1
		swap	d1
		tst.w	d1
		beq.w	sfx_back
		sub.l	#$10000,sfx_y_actual_value

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		update sound register values
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	gb_memory,a5
		add.l	#$ff00,a5
		move.l	ahi_base,a6

		move.b	$26(a5),d6
		btst	#7,d6
		bne.s	sounds_on_go

sounds_off_go:	moveq.l	#0,d0
		moveq.l	#0,d1
		move.l	sound_I_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		moveq.l	#1,d0
		moveq.l	#0,d1
		move.l	sound_II_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		moveq.l	#2,d0
		moveq.l	#0,d1
		move.l	sound_III_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		moveq.l	#3,d0
		moveq.l	#0,d1
		move.l	sound_IV_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		bra.w	sfx_back

sounds_on_go:	bsr.w	sound_update_mixer

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		channel 1
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		tst.b	snd_chnlI
		bne.w	no_chnlI_no_no

		moveq.l	#0,d7
		move.b	$12(a5),d7
		lsr.b	#4,d7
		lea	sound_env_volumes,a2
		move.l	(a2,d7.w*4),sound_I_v

		moveq.l	#0,d0
		moveq.l	#0,d1
		tst.b	sound_I_onf
		bne.s	no_s_I_addb
		move.l	sound_I_v,d1
no_s_I_addb:	move.l	sound_I_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		move.w	sound_raw_regs+$13-$10,d7
		and.l	#%1111111100000111,d7
		ror.w	#8,d7

		move.l	#2048,d2
		move.l	#1048576,d1
		sub.l	d7,d2
		divu.l	d2,d1
		move.l	d1,sound_I_rate

		moveq.l	#0,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

		moveq.l	#0,d6
		move.b	$11(a5),d6
		lsr.b	#6,d6
		cmp.b	old_sound_I_duty,d6
		beq.w	no_chnlI_no_no

		move.b	d6,old_sound_I_duty

		moveq.l	#0,d0
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_UnloadSound(a6)

		move.l	smpl_info_I,a0
		lea	smpl_mem_1,a1
		move.l	(a1,d6.w*4),ahisi_Address(a0)	;address.

		moveq.l	#0,d0				;sample number.
		move.l	#AHIST_SAMPLE,d1		;type.
		move.l	smpl_info_I,a0			;info field.
		move.l	ahi_audio_ctrl,a2		;ctrl.
		jsr	AHI_LoadSound(a6)

		moveq.l	#0,d0				;channel.
		moveq.l	#0,d1				;sample.
		moveq.l	#0,d2				;offset.
		move.l	#8*512,d3			;size (full).
		moveq.l	#0,d4
		bset	#AHISB_IMM,d4			;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetSound(a6)

		moveq.l	#0,d0
		move.l	sound_I_rate,d1
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

		moveq.l	#0,d0
		moveq.l	#0,d1
		tst.b	sound_I_onf
		bne.s	no_s_I_addd
		move.l	sound_I_v,d1
no_s_I_addd:	move.l	sound_I_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

no_chnlI_no_no:	

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		channel 2
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		tst.b	snd_chnlII
		bne.w	no_chnlII_no_no

		moveq.l	#0,d7
		move.b	$17(a5),d7
		lsr.b	#4,d7
		lea	sound_env_volumes,a2
		move.l	(a2,d7.w*4),sound_II_v

		moveq.l	#1,d0
		moveq.l	#0,d1
		tst.b	sound_II_onf
		bne.s	no_s_II_addb
		move.l	sound_II_v,d1
no_s_II_addb:	move.l	sound_II_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		move.w	sound_raw_regs+$18-$10,d7
		and.l	#%1111111100000111,d7
		ror.w	#8,d7

		move.l	#2048,d2
		move.l	#1048576,d1
		sub.l	d7,d2
		divu.l	d2,d1
		move.l	d1,sound_II_rate

		moveq.l	#1,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

		moveq.l	#0,d6
		move.b	$16(a5),d6
		lsr.b	#6,d6
		cmp.b	old_sound_II_duty,d6
		beq.w	no_chnlII_no_no

		move.b	d6,old_sound_II_duty

		moveq.l	#1,d0
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_UnloadSound(a6)

		move.l	smpl_info_II,a0
		lea	smpl_mem_1,a1
		move.l	(a1,d6.w*4),ahisi_Address(a0)	;address.

		moveq.l	#1,d0				;sample number.
		move.l	#AHIST_SAMPLE,d1		;type.
		move.l	smpl_info_II,a0			;info field.
		move.l	ahi_audio_ctrl,a2		;ctrl.
		jsr	AHI_LoadSound(a6)

		moveq.l	#1,d0				;channel.
		moveq.l	#1,d1				;sample.
		moveq.l	#0,d2				;offset.
		move.l	#8*512,d3			;size (full).
		moveq.l	#0,d4
		bset	#AHISB_IMM,d4			;flags.
		move.l	ahi_audio_ctrl,a2
		jsr	AHI_SetSound(a6)

		moveq.l	#1,d0
		move.l	sound_II_rate,d1
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

		moveq.l	#1,d0
		moveq.l	#0,d1
		tst.b	sound_II_onf
		bne.s	no_s_II_addd
		move.l	sound_II_v,d1
no_s_II_addd:	move.l	sound_II_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

no_chnlII_no_no:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		channel 3
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		tst.b	snd_chnlIII
		bne.w	no_chnlIII_no_no

		move.b	$1a(a5),d6
		and.b	#%10000000,d6
		bne.s	sound_III_on_on

		moveq.l	#2,d0
		moveq.l	#0,d1
		move.l	sound_III_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		bra.w	no_chnlIII_no_no

sound_III_on_on:lea	$30(a5),a4
		moveq.l	#16-1,d0
		move.l	sound_III_lst,a1
		move.l	smpl_III_mem,a3
		moveq.l	#0,d7
chnlIII_loop:	move.b	(a4)+,d7
		move.w	(a1,d7.w*2),(a3)+
		dbra	d0,chnlIII_loop

		move.b	$1c(a5),d6
		and.b	#%01100000,d6

		lsr.b	#3,d6
		and.l	#%1100,d6
		lea	sound_III_vol,a1
		move.l	(a1,d6.w),sound_III_v

		moveq.l	#2,d0
		moveq.l	#0,d1
		tst.b	sound_III_onf
		bne.s	no_s_III_addk
		move.l	sound_III_v,d1
no_s_III_addk:	move.l	sound_III_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		move.w	sound_raw_regs+$1d-$10,d6
		and.l	#%1111111100000111,d6
		ror.w	#8,d6

		move.l	#2097152,d1
		move.l	#2048,d2
		sub.l	d6,d2
		divu.l	d2,d1

		moveq.l	#2,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

no_chnlIII_no_no:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		channel 4
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		tst.b	snd_chnlIV
		bne.w	no_chnlIV_no_no

		moveq.l	#0,d7
		move.b	$21(a5),d7
		lsr.b	#4,d7
		lea	sound_env_volumes,a2
		move.l	(a2,d7.w*4),sound_IV_v

		moveq.l	#3,d0
		moveq.l	#0,d1
		tst.b	sound_IV_onf
		bne.s	no_s_IV_addh
		move.l	sound_IV_v,d1
no_s_IV_addh:	move.l	sound_IV_pan,d2
		moveq.l	#0,d3
		bset	#AHISB_IMM,d3
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_volume

		move.b	$22(a5),d6
		move.b	d6,d7

		btst	#3,d6
		sne	d0
		cmp.b	old_sound_IV_width,d0
		beq.s	sfx_noise_pitch
		move.b	d0,old_sound_IV_width
		bsr.l	load_noise_sample
sfx_noise_pitch:
		lea	sound_4_freq_table,a0
		and.l	#%111,d6
		move.l	(a0,d6.w*4),d1

		lsr.b	#4,d7
		and.b	#%1111,d7
		lsr.l	d7,d1
		cmp.b	#14,d7
		blo.s	sfx_noise_rate
		moveq.l	#0,d1
sfx_noise_rate:

		moveq.l	#3,d0
		moveq.l	#0,d2
		bset	#AHISB_IMM,d2
		move.l	ahi_audio_ctrl,a2
		bsr.w	sound_set_frequency

no_chnlIV_no_no:bra.w	sfx_back
		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		execute different interrupts
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

prior_i_0:	btst.b	#7,$40(a6)			;lcd on?
		beq.w	no_interrupts_0			;no.

		bclr.b	#0,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$40(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_0

		IFLE	Z80_MODE
prior_ii_0:	btst.b	#7,$40(a6)			;lcd on?
		beq.w	no_interrupts_0			;no.

		bclr.b	#1,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$48(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_0

prior_iii_0:	bclr.b	#2,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$50(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_0
		ENDIF

prior_iv_0:	bclr.b	#3,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$58(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_0

prior_v_0:	bclr.b	#4,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$60(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_0

prior_i_1:	btst.b	#7,$40(a6)			;lcd on?
		beq.w	no_interrupts_1			;no.

		bclr.b	#0,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$40(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_1

		IFLE	Z80_MODE
prior_ii_1:	btst.b	#7,$40(a6)			;lcd on?
		beq.w	no_interrupts_1			;no.

		bclr.b	#1,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$48(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_1

prior_iii_1:	bclr.b	#2,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$50(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_1
		ENDIF

prior_iv_1:	bclr.b	#3,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$58(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_1

prior_v_1:	bclr.b	#4,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$60(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_1

prior_i_2:	btst.b	#7,$40(a6)			;lcd on?
		beq.w	no_interrupts_2			;no.

		bclr.b	#0,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$40(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_2

		IFLE	Z80_MODE
prior_ii_2:	btst.b	#7,$40(a6)			;lcd on?
		beq.w	no_interrupts_2			;no.

		bclr.b	#1,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$48(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_2

prior_iii_2:	bclr.b	#2,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$50(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_2
		ENDIF

prior_iv_2:	bclr.b	#3,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$58(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_2

prior_v_2:	bclr.b	#4,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$60(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_2

prior_i_3:	btst.b	#7,$40(a6)			;lcd on?
		beq.w	no_interrupts_3			;no.

		bclr.b	#0,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$40(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_3

		IFLE	Z80_MODE
prior_ii_3:	btst.b	#7,$40(a6)			;lcd on?
		beq.w	no_interrupts_3			;no.

		bclr.b	#1,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$48(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_3

prior_iii_3:	bclr.b	#2,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$50(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_3
		ENDIF

prior_iv_3:	bclr.b	#3,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$58(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_3

prior_v_3:	bclr.b	#4,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$60(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_3

prior_i_4:	btst.b	#7,$40(a6)			;lcd on?
		beq.w	no_interrupts_4			;no.

		bclr.b	#0,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$40(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_4

		IFLE	Z80_MODE
prior_ii_4:	btst.b	#7,$40(a6)			;lcd on?
		beq.w	no_interrupts_4			;no.

		bclr.b	#1,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$48(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_4

prior_iii_4:	bclr.b	#2,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$50(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_4
		ENDIF

prior_iv_4:	bclr.b	#3,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$58(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_4

prior_v_4:	bclr.b	#4,$0f(a6)

		IFEQ	Z80_MODE
		bsr.w	write_irq_stack
		ELSE
		ror.w	#8,d6
		subq.w	#2,d5
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$60(a3),a0
		move.l	a3,z80_pc_base
		move.b	#1,i_flag
		clr.b	z80_halt
		bra.w	no_interrupts_4

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		lcd interrupt
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

lcd_irq_eh:
		IFEQ	Z80_MODE
		IFEQ	GAMEBOY_USERS
		btst.b	#7,$40(a6)
		beq.s	lcd_irq_quit
		ENDIF
		ENDIF
		tst.b	d6
		beq.s	lcd_h_blank
		cmp.b	#1,d6
		beq.s	lcd_v_blank
		cmp.b	#2,d6
		beq.s	lcd_oam
		rts

;lcd_3_blank:	bset.b	#1,$0f(a6)			;lcd occurred.
;		rts

lcd_h_blank:	btst.b	#3,$41(a6)
		beq.s	lcd_irq_quit
		btst.b	#2,irq_status_flags		;after lyc?
		bne.s	lcd_irq_quit

		IFGT	GAMEBOY_DEBUG
		bsr.w	debug_lcd
		ENDIF

		bset.b	#0,irq_status_flags		;hblank occurred.
		bset.b	#1,$0f(a6)			;lcd occurred.
lcd_irq_quit:	rts

lcd_v_blank:	btst.b	#4,$41(a6)
		beq.s	lcd_irq_quit

		IFGT	GAMEBOY_DEBUG
		bsr.w	debug_lcd
		ENDIF

		bset.b	#1,$0f(a6)			;lcd occurred.
		rts

lcd_oam:	btst.b	#5,$41(a6)
		beq.s	lcd_irq_quit
		btst.b	#0,irq_status_flags
		bne.s	lcd_irq_quit
		btst.b	#2,irq_status_flags		;after lyc?
		bne.s	lcd_irq_quit
		btst.b	#1,irq_status_flags		;vbr effect?
		beq.s	lcd_oam_no_vbr_filtering
		tst.l	gb_scanlines
		beq.s	lcd_irq_quit			;yes, $00 is off limits.

lcd_oam_no_vbr_filtering:

		IFGT	GAMEBOY_DEBUG
		bsr.w	debug_lcd
		ENDIF

		bset.b	#1,$0f(a6)			;lcd occurred.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		next frame - check the buttons and loop
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

next_frame:	bsr.w	lcd_blank_frame_end
		bsr.w	push_z80
		cmp.b	#2,old_render
		bne.s	next_frame_window_done
		tst.b	scaling_status
		beq.s	next_frame_window_done
		tst.b	forbid_permit_status
		bne.s	next_frame_window_poll
		move.l	exec_base,a6
		jsr	Permit(a6)
		bsr.w	poll_wzonka_window
		move.l	exec_base,a6
		jsr	Forbid(a6)
		bra.s	next_frame_window_done
next_frame_window_poll:
		bsr.w	poll_wzonka_window
next_frame_window_done:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		MBC3 clock emulation
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		tst.b	mbc3_existence
		beq.s	no_mbc3_clock

		add.b	#1,mbc3_sec
		cmp.b	#60,mbc3_sec
		bne.s	mbc3_clock_done

		clr.b	mbc3_sec
		add.b	#1,mbc3_min
		cmp.b	#60,mbc3_min
		bne.s	mbc3_clock_done

		clr.b	mbc3_min
		add.b	#1,mbc3_hrs
		cmp.b	#60,mbc3_hrs
		bne.s	mbc3_clock_done

		clr.b	mbc3_hrs
		move.w	mbc3_day,d7
		addq.w	#1,d7
		btst	#9,d7
		beq.s	mbc3_clock_no_day_carry
		or.w	#%1000000000000000,d7
mbc3_clock_no_day_carry:
		and.w	#%1100000111111111,d7
		move.w	d7,mbc3_day		

mbc3_clock_done:
no_mbc3_clock:	and.b	#%10,irq_status_flags		;clear oam and lyc flag.

		move.b	output_bit,d7
		cmp.b	frame_update,d7
		bne.s	no_empty
		clr.b	output_bit			;reset the counter.

no_empty:	addq.b	#1,output_bit			;one frame done.

		IFEQ	GAMEBOY_USERS
		cmp.b	#2,snd_quality
		beq.w	sfx_update_all			;use y value to update
		ENDIF
							;audio data.
sfx_back:	cmp.b	#INPUT_OK,input_status
		beq.w	cartridge_loop
		cmp.b	#INPUT_HALT,input_status
		beq.w	z80_halted
		cmp.b	#INPUT_GBS_LOAD,input_status
		beq.s	input_gbs_load

input_gbs_save:	bsr.w	runtime_gbs_save
		clr.b	input_status
		bra.w	cartridge_loop

input_gbs_load:	bsr.w	runtime_gbs_load
		clr.b	input_status
		bra.w	cartridge_loop

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		execute a timer interrupt if needed
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

irq_timer:	and.l	#%11,d7				;save the frequency value.
		lea	freq_table,a5			;a5 = the value table.
		move.l	(a5,d7.w*4),d6			;d6 = the freq*4096/60/154/5.
		add.l	freq_storage,d6			;add the old value.
		move.l	d6,d7				;store the value.
		lsr.l	#8,d6
		lsr.l	#4,d6				;d6 = updated timer register.
		cmp.l	#$ff,d6
		ble.s	write_timer			;no overflow.

		moveq.l	#0,d7
		move.b	$06(a6),d6			;d6 = timemod (timer modulo).
		move.b	d6,d7
		lsl.l	#8,d7
		lsl.l	#4,d7

		btst.b	#2,$ff(a6)			;timer overflow?
		beq.s	write_timer			;no. it's disabled. ;(

		IFGT	GAMEBOY_DEBUG
		bsr.w	debug_timer
		ENDIF

timer_starts:	bset.b	#2,$0f(a6)			;timer occurred.
write_timer:	move.b	d6,$05(a6)			;update timecnt.
		move.l	d7,freq_storage			;update fixed storage.
no_timer_update:rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the aga h/w mode vbr interrupt
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

vbr_interrupt:	movem.l	d0-d7/a0-a6,-(SP)

load_copper_in:	move.l	copper_inactive,d0
		tst.b	old_refresh			;144/144?
		beq.w	copper_144_144			;yes.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		1/144 aga h/w plane pointer loads
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cmp.l	copper_I,d0
		beq.s	xload_copper_II
xload_copper_I:	move.l	bg_scroll_y_I,d1		;y scrolling (0-7).
		clr.b	visual_frame			;buffer 0 is used.
		move.l	aga_map_I,d0
		add.l	#40*8*16,d0			;background planes.
		move.w	d1,d2
		lsl.b	#5,d1
		lsl.b	#3,d2
		add.w	d2,d1
		lsl.w	#3,d1				;planes (8), too.
		add.l	d1,d0				;new y!
		move.l	aga_pln_cI,a0
		moveq.l	#4-1,d1
		moveq.l	#40,d2				;modulus.
		bsr.w	load_bitplanes			;load planes.

		move.l	aga_map_I,d0
		add.l	#40*8*16+40*4,d0		;sprite planes.
		move.l	aga_pln_cI,a0
		add.l	#2*4*4,a0			;to sprite plane pointers.
		moveq.l	#4-1,d1
		moveq.l	#40,d2				;modulus.
		bsr.w	load_bitplanes			;load planes.

		move.l	aga_ro_list_I,a0		;the shift input list.
		lea	aga_spr_Ia,a6			;sprites.
		bra.w	load_copper_xit
xload_copper_II:move.l	bg_scroll_y_II,d1		;y scrolling (0-7).
		move.b	#1,visual_frame			;buffer 1 is used.
		move.l	aga_map_II,d0
		add.l	#40*8*16,d0			;background planes.
		move.w	d1,d2
		lsl.b	#5,d1
		lsl.b	#3,d2
		add.w	d2,d1
		lsl.w	#3,d1				;planes (8), too.
		add.l	d1,d0				;new y!
		move.l	aga_pln_cI,a0
		moveq.l	#8-1,d1
		moveq.l	#40,d2				;modulus.
		bsr.w	load_bitplanes			;load planes.

		move.l	aga_map_II,d0
		add.l	#40*8*16+40*4,d0		;sprite planes.
		move.l	aga_pln_cI,a0
		add.l	#2*4*4,a0			;to sprite plane pointers.
		moveq.l	#4-1,d1
		moveq.l	#40,d2				;modulus.
		bsr.w	load_bitplanes			;load planes.

		move.l	aga_ro_list_II,a0		;the shift input list.
		lea	aga_spr_Ib,a6			;sprites.
		bra.w	load_copper_xit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		144/144 aga h/w plane pointer loads
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

copper_144_144:	cmp.l	copper_I,d0
		beq.s	load_copper_II
load_copper_I:	clr.b	visual_frame
		move.l	aga_map_I,d0
		move.l	aga_pln_cI,a0
		moveq.l	#8-1,d1
		moveq.l	#40,d2				;modulus.
		bsr.w	load_bitplanes			;load planes.
		move.l	aga_ro_list_I,a0		;the shift input list.
		lea	aga_spr_Ia,a6			;sprites.
		bra.s	load_copper_xit
load_copper_II:	move.b	#1,visual_frame
		move.l	aga_map_II,d0
		move.l	aga_pln_cI,a0
		moveq.l	#8-1,d1
		moveq.l	#40,d2				;modulus.
		bsr.w	load_bitplanes			;load planes.
		move.l	aga_ro_list_II,a0		;the shift input list.
		lea	aga_spr_Ib,a6			;sprites.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		copper updating continues
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_copper_xit:move.l	aga_scr_0_cI,a1
		move.l	aga_scr_cI,a2
		move.b	(a0)+,3(a1)			;the first value.

		tst.b	old_refresh			;144/144?
		bne.s	no_more_shifts			;nope.

		move.w	#144-1-1,d0
		addq.l	#2+2+2+1,a2
load_roller_vs:	move.b	(a0)+,(a2)			;new scroll values.
		addq.l	#8,a2				;next value.
		dbra	d0,load_roller_vs		;          .

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		load sprite pointers
;		INPUT:
;		a6	= pointer to sprite pointer list.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

no_more_shifts:	moveq.l	#3-1,d0
		move.l	aga_spr_cI,a0			;output.
		lea	aga_spr_Ix,a1			;mask sprites.
load_hw_window:	move.l	(a6)+,a2
		move.l	(a1)+,a3
		move.w	(a2),(a3)			;copy position data.
		move.w	8(a2),8(a3)
		move.l	a2,d1
		move.w	d1,6(a0)
		swap	d1
		move.w	d1,2(a0)
		addq.l	#8,a0
		dbra	d0,load_hw_window		;next sprite.

		movem.l	(SP)+,d0-d7/a0-a6
		jmp	([old_vbr])			;jump to the system routine.

;		move.w	#$60,intreq+$dff000
;		rte

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		z80 processor halted
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

z80_halted:	tst.b	old_render
		bne.s	no_aga_exit			;no aga mode used.

		move.l	vbr_pointer,a0			;return the old
		move.l	old_vbr,$6c(a0)			;interrupt.

		move.l	graphics_base,a6
		move.l	old_wb_view,a1
		jsr	LoadView(a6)			;fix the view.
		jsr	WaitTOF(a6)
		jsr	WaitTOF(a6)			;wait for LoadView().
		move.l	old_copper,cop1lc+$dff000
		move.w	old_dmareq,d0
		or.w	#$8000,d0
		move.w	d0,dmacon+$dff000

no_aga_exit:	tst.b	forbid_permit_status
		bne.s	no_permit

		move.l	exec_base,a6
		jsr	Permit(a6)

no_permit:	tst.l	block_screen_ptr
		beq.s	no_block_screen_exit

		move.l	intuition_base,a6
		move.l	block_screen_ptr,d0
		beq.s	no_aga_exit
		move.l	d0,a0
		jsr	CloseScreen(a6)
		clr.l	block_screen_ptr

no_block_screen_exit:
		rts					;exit the cartridge runner.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		do the joystick input. or is it the keyboard input?
;		or what the hell is it!? ;)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

inputs_read:	lea	joy_item_list,a0
		moveq.l	#0,d0
		move.b	keystick,d0
		move.b	(a0,d0.l),d1			;which one to use?
		beq.s	input_keyboard			;keyboard.
		cmp.b	#1,d1
		beq.w	input_joypad			;cd³² joypad.
		cmp.b	#2,d1
		beq.w	input_sega_4b			;sega 4 button joypad.
		cmp.b	#3,d1
		beq.w	input_sega_2b			;sega 2 button joypad.
		cmp.b	#4,d1
		beq.w	input_joystick_1b		;joystick.
		cmp.b	#5,d1
		beq.w	input_joystick_2b		;joystick.

		move.b	#INPUT_HALT,input_status	;pause!!!!!
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		keyboard input selected. read the keyboard
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

input_keyboard:	move.l	exec_base,a6
		move.l	keyboard_io,a1
		jsr	SendIO(a6)

		move.b	#$ff,d0
		move.b	#$ff,d1
		move.l	keyboard_matrix,a1
		btst.b	#1,3(a1)			;p?
		bne.w	paused_gb
		btst.b	#5,8(a1)			;esc?
		bne.w	paused_gb

		tst.b	10(a1)
		bne.s	gbs_byte_10
		btst.b	#0,11(a1)			;f9?
		bne.w	gbs_load_4
		btst.b	#1,11(a1)			;f10?
		bne.w	gbs_load_5

		move.b	9(a1),d2

		btst	#4,d2				;up?
		beq.s	no_up_key_rd
		bclr	#2,d0
no_up_key_rd:	btst	#5,d2				;down?
		beq.s	no_down_key_rd
		bclr	#3,d0
no_down_key_rd:	btst	#6,d2				;right?
		beq.s	no_righ_key_rd
		bclr	#0,d0
no_righ_key_rd:	btst	#7,d2				;left?
		beq.s	no_left_key_rd
		bclr	#1,d0

no_left_key_rd:	move.b	12(a1),d2

		btst	#0,d2				;b (left shift)?
		beq.s	no_left_shf_rd
		bclr	#1,d1
no_left_shf_rd:	btst	#4,d2				;a (left alt)?
		beq.s	no_left_alt_rd
		bclr	#0,d1
no_left_alt_rd:	btst	#1,d2				;start (right shift)?
		beq.s	no_righ_shf_rd
		bclr	#3,d1
no_righ_shf_rd:	btst	#5,d2				;select (right alt)?
		beq.s	no_righ_alt_rd
		bclr	#2,d1

no_righ_alt_rd:	move.b	d0,directions_byte
		move.b	d1,buttons_byte
rd_keyb_exit:	move.b	#INPUT_OK,input_status		;no pause.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		gbs save and load routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gbs_byte_10:	btst.b	#0,10(a1)			;f1?
		bne.w	gbs_save_1
		btst.b	#1,10(a1)			;f2?
		bne.w	gbs_save_2
		btst.b	#2,10(a1)			;f3?
		bne.w	gbs_save_3
		btst.b	#3,10(a1)			;f4?
		bne.w	gbs_save_4
		btst.b	#4,10(a1)			;f5?
		bne.w	gbs_save_5

		btst.b	#5,10(a1)			;f6?
		bne.w	gbs_load_1
		btst.b	#6,10(a1)			;f7?
		bne.w	gbs_load_2
		bra.w	gbs_load_3

gbs_operation:	cmp.b	#$50,d1				;f1?
		beq.w	gbs_save_1
		cmp.b	#$51,d1				;f2?
		beq.w	gbs_save_2
		cmp.b	#$52,d1				;f3?
		beq.w	gbs_save_3
		cmp.b	#$53,d1				;f4?
		beq.w	gbs_save_4
		cmp.b	#$54,d1				;f5?
		beq.w	gbs_save_5

		cmp.b	#$55,d1				;f6?
		beq.w	gbs_load_1
		cmp.b	#$56,d1				;f7?
		beq.w	gbs_load_2
		cmp.b	#$57,d1				;f8?
		beq.w	gbs_load_3
		cmp.b	#$58,d1				;f9?
		beq.w	gbs_load_4
		bra.w	gbs_load_5

gbs_save_1:	move.b	#"1",gbs_file_id
		move.b	#INPUT_GBS_SAVE,input_status
		rts
gbs_save_2:	move.b	#"2",gbs_file_id
		move.b	#INPUT_GBS_SAVE,input_status
		rts
gbs_save_3:	move.b	#"3",gbs_file_id
		move.b	#INPUT_GBS_SAVE,input_status
		rts
gbs_save_4:	move.b	#"4",gbs_file_id
		move.b	#INPUT_GBS_SAVE,input_status
		rts
gbs_save_5:	move.b	#"5",gbs_file_id
		move.b	#INPUT_GBS_SAVE,input_status
		rts

gbs_load_1:	move.b	#"1",gbs_file_id
		move.b	#INPUT_GBS_LOAD,input_status
		rts
gbs_load_2:	move.b	#"2",gbs_file_id
		move.b	#INPUT_GBS_LOAD,input_status
		rts
gbs_load_3:	move.b	#"3",gbs_file_id
		move.b	#INPUT_GBS_LOAD,input_status
		rts
gbs_load_4:	move.b	#"4",gbs_file_id
		move.b	#INPUT_GBS_LOAD,input_status
		rts
gbs_load_5:	move.b	#"5",gbs_file_id
		move.b	#INPUT_GBS_LOAD,input_status
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		read from the cd³² joypad
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

input_joypad:
		IFEQ	GAMEBOY_USERS

		move.l	low_level_base,a6
		moveq.l	#1,d0
		jsr	ReadJoyPort(a6)

		btst	#JPB_BUTTON_PLAY,d0		;paused?
		bne.w	paused_gb

		btst	#JPB_BUTTON_REVERSE,d0
		bne.w	gbs_save_1
		btst	#JPB_BUTTON_FORWARD,d0
		bne.w	gbs_load_1

		moveq.l	#0,d1
		move.b	$bfec01,d1			;get p-key from keyboard.
		not.b	d1
		ror.b	#1,d1

		cmp.l	#$50,d1
		blt.s	no_gbs_op_joypad
		cmp.l	#$59,d1
		ble.w	gbs_operation

no_gbs_op_joypad:
		move.b	#$ff,d1				;directions byte.
		move.b	#$ff,d2				;buttons byte.

		btst	#JPB_JOY_UP,d0
		beq.s	no_up
		bclr	#2,d1				;up set. ;)
no_up:		btst	#JPB_JOY_DOWN,d0
		beq.s	no_down
		bclr	#3,d1				;down set.
no_down:	btst	#JPB_JOY_LEFT,d0
		beq.s	no_left
		bclr	#1,d1				;left set.
no_left:	btst	#JPB_JOY_RIGHT,d0
		beq.s	no_right
		bclr	#0,d1				;right set.

no_right:	btst	#JPB_BUTTON_RED,d0
		beq.s	no_red
		bclr	#1,d2				;red / b set.
no_red:		btst	#JPB_BUTTON_BLUE,d0
		beq.s	no_blue
		bclr	#0,d2				;blue / a set.
no_blue:	btst	#JPB_BUTTON_GREEN,d0
		beq.s	no_green
		bclr	#2,d2				;green / select set.
no_green:	btst	#JPB_BUTTON_YELLOW,d0
		beq.s	no_yellow
		bclr	#3,d2				;yellow / start set.

no_yellow:	move.b	d1,directions_byte		;output the capture.
		move.b	d2,buttons_byte

		ENDIF

		move.b	#INPUT_OK,input_status		;no pause
		rts

paused_gb:	cmp.b	#1,old_render			;screen mode?
		bne.s	no_front_gb			;nope.

		move.l	gb_screen_ptr,a0
		move.l	intuition_base,a6
		jsr	ScreenToBack(a6)		;screen to back.

no_front_gb:	move.b	#INPUT_HALT,input_status	;emulator paused.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		read input signals from a four button sega joypad
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

input_sega_4b:
		IFEQ	GAMEBOY_USERS

		move.l	control_pad_base,a6
		move.b	#CPU_JOYPORT,d0			;the unit.
		move.l	cp_handle,a0
		jsr	cpGet(a6)			;get sega pad info.

		move.b	$bfec01,d1			;get p-key from keyboard.
		not.b	d1
		ror.b	#1,d1

		cmp.b	#$19,d1				;p?
		beq.s	paused_gb			;yes.
		cmp.b	#$45,d1				;esc?
		beq.s	paused_gb			;yes.

		cmp.l	#$50,d1
		blt.s	no_gbs_op_sega_4b
		cmp.l	#$59,d1
		ble.w	gbs_operation

no_gbs_op_sega_4b:

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		INPUT:
;		d0	= joypad_data.W.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.b	#$ff,d1				;directions byte.
		move.b	#$ff,d2				;buttons byte.

		btst	#CPB_UP,d0
		beq.s	no_cpb_up
		bclr	#2,d1				;up set. ;)
no_cpb_up:	btst	#CPB_DOWN,d0
		beq.s	no_cpb_down
		bclr	#3,d1				;down set.
no_cpb_down:	btst	#CPB_LEFT,d0
		beq.s	no_cpb_left
		bclr	#1,d1				;left set.
no_cpb_left:	btst	#CPB_RIGHT,d0
		beq.s	no_cpb_right
		bclr	#0,d1				;right set.

no_cpb_right:	btst	#CPB_B,d0
		beq.s	no_cpb_b
		bclr	#1,d2				;b / b set.
no_cpb_b:	btst	#CPB_A,d0
		beq.s	no_cpb_a
		bclr	#0,d2				;a / a set.
no_cpb_a:	btst	#CPB_C,d0
		beq.s	no_cpb_c
		bclr	#2,d2				;c / select set.
no_cpb_c:	btst	#CPB_START,d0
		beq.s	no_cpb_start
		bclr	#3,d2				;start / start set.

no_cpb_start:	move.b	d1,directions_byte		;output the capture.
		move.b	d2,buttons_byte

		ENDIF

		move.b	#INPUT_OK,input_status		;no pause
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		read inputs from a two buttons sega joypad and
;		the keyboard device
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

input_sega_2b:
		IFEQ	GAMEBOY_USERS

		move.l	exec_base,a6
		move.l	keyboard_io,a1
		jsr	SendIO(a6)

		move.l	keyboard_matrix,a1
		btst.b	#1,3(a1)			;p?
		bne.w	paused_gb
		btst.b	#5,8(a1)			;esc?
		bne.w	paused_gb

		tst.b	10(a1)
		bne.w	gbs_byte_10
		btst.b	#0,11(a1)			;f9?
		bne.w	gbs_load_4
		btst.b	#1,11(a1)			;f10?
		bne.w	gbs_load_5

		move.l	control_pad_base,a6
		move.b	#CPU_JOYPORT,d0			;the unit.
		move.l	cp_handle,a0
		jsr	cpGet(a6)			;get sega pad info.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		INPUT:
;		d0	= joypad_data.W.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.b	#$ff,d1				;directions byte.
		move.b	#$ff,d2				;buttons byte.

		btst	#CPB_UP,d0
		beq.s	no_cpbx_up
		bclr	#2,d1				;up set. ;)
no_cpbx_up:	btst	#CPB_DOWN,d0
		beq.s	no_cpbx_down
		bclr	#3,d1				;down set.
no_cpbx_down:	btst	#CPB_LEFT,d0
		beq.s	no_cpbx_left
		bclr	#1,d1				;left set.
no_cpbx_left:	btst	#CPB_RIGHT,d0
		beq.s	no_cpbx_right
		bclr	#0,d1				;right set.

no_cpbx_right:	btst	#CPB_C,d0
		beq.s	no_cpbx_cx
		bclr	#0,d2				;c / a set.
no_cpbx_cx:	btst	#CPB_B,d0
		beq.s	no_cpbx_bx
		bclr	#1,d2				;b / b set.

no_cpbx_bx:	move.l	keyboard_matrix,a1
		move.b	12(a1),d3

		btst	#0,d3				;b (left shift)?
		beq.s	no_left_shf_sg
		bclr	#1,d2
no_left_shf_sg:	btst	#4,d3				;a (left alt)?
		beq.s	no_left_alt_sg
		bclr	#0,d2
no_left_alt_sg:	btst	#1,d3				;start (right shift)?
		beq.s	no_righ_shf_sg
		bclr	#3,d2
no_righ_shf_sg:	btst	#5,d3				;select (right alt)?
		beq.s	no_righ_alt_sg
		bclr	#2,d2

no_righ_alt_sg:	move.b	d1,directions_byte
		move.b	d2,buttons_byte

		ENDIF

sg_keyb_exit:	move.b	#INPUT_OK,input_status		;no pause.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		read inputs from the 1b joystick and keyboard
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

input_joystick_1b:
		move.l	exec_base,a6
		move.l	keyboard_io,a1
		jsr	SendIO(a6)

		move.b	#$ff,d0
		move.b	#$ff,d1
		move.l	keyboard_matrix,a1
		btst.b	#1,3(a1)			;p?
		bne.w	paused_gb
		btst.b	#5,8(a1)			;esc?
		bne.w	paused_gb

		tst.b	10(a1)
		bne.w	gbs_byte_10
		btst.b	#0,11(a1)			;f9?
		bne.w	gbs_load_4
		btst.b	#1,11(a1)			;f10?
		bne.w	gbs_load_5

		move.b	12(a1),d3

		btst	#0,d3				;b (left shift)?
		beq.s	no_left_shf_js
		bclr	#1,d1
no_left_shf_js:	btst	#4,d3				;a (left alt)?
		beq.s	no_left_alt_js
		bclr	#0,d1
no_left_alt_js:	btst	#1,d3				;start (right shift)?
		beq.s	no_righ_shf_js
		bclr	#3,d1
no_righ_shf_js:	btst	#5,d3				;select (right alt)?
		beq.s	no_righ_alt_js
		bclr	#2,d1

no_righ_alt_js:	btst.b	#7,$bfe001
		bne.s	no_fire_btn_js
		bclr	#0,d1				;a (fire button)!

no_fire_btn_js:	move.w	joy1dat+$dff000,d2
		move.w	d2,d3

		btst	#1,d2
		beq.s	no_right_js
		bclr	#0,d0
no_right_js:	btst	#9,d2
		beq.s	no_left_js
		bclr	#1,d0

no_left_js:	ror.w	#1,d3
		eor.w	d3,d2
		btst	#0,d2
		beq.s	no_down_js
		bclr	#3,d0
no_down_js:	btst	#8,d2
		beq.s	no_up_js
		bclr	#2,d0

no_up_js:	move.b	d0,directions_byte
		move.b	d1,buttons_byte
js_keyb_exit:	move.b	#INPUT_OK,input_status		;no pause.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		read inputs from the 2b joystick and keyboard
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

input_joystick_2b:
		IFEQ	GAMEBOY_USERS

		move.l	exec_base,a6
		move.l	keyboard_io,a1
		jsr	SendIO(a6)

		move.b	#$ff,d0
		move.b	#$ff,d1
		move.l	keyboard_matrix,a1
		btst.b	#1,3(a1)			;p?
		bne.w	paused_gb
		btst.b	#5,8(a1)			;esc?
		bne.w	paused_gb

		tst.b	10(a1)
		bne.w	gbs_byte_10
		btst.b	#0,11(a1)			;f9?
		bne.w	gbs_load_4
		btst.b	#1,11(a1)			;f10?
		bne.w	gbs_load_5

		move.b	12(a1),d3

		btst	#0,d3				;b (left shift)?
		beq.s	zno_left_shf_js
		bclr	#1,d1
zno_left_shf_js:btst	#4,d3				;a (left alt)?
		beq.s	zno_left_alt_js
		bclr	#0,d1
zno_left_alt_js:btst	#1,d3				;start (right shift)?
		beq.s	zno_righ_shf_js
		bclr	#3,d1
zno_righ_shf_js:btst	#5,d3				;select (right alt)?
		beq.s	zno_righ_alt_js
		bclr	#2,d1

zno_righ_alt_js:btst.b	#7,$bfe001
		bne.s	zno_fire_1btn_js
		bclr	#0,d1				;a (fire button 1)!

zno_fire_1btn_js:
		move.w	#$FF00,$DFF034
		nop
		nop
		btst.b	#6,$DFF016
		bne.s   zno_fire_2btn_js
		bclr	#1,d1				;b (fire button 2)!

zno_fire_2btn_js:
		move.w	joy1dat+$dff000,d2
		move.w	d2,d3

		btst	#1,d2
		beq.s	zno_right_js
		bclr	#0,d0
zno_right_js:	btst	#9,d2
		beq.s	zno_left_js
		bclr	#1,d0

zno_left_js:	ror.w	#1,d3
		eor.w	d3,d2
		btst	#0,d2
		beq.s	zno_down_js
		bclr	#3,d0
zno_down_js:	btst	#8,d2
		beq.s	zno_up_js
		bclr	#2,d0

zno_up_js:	move.b	d0,directions_byte
		move.b	d1,buttons_byte

		ENDIF

zjs_keyb_exit:	move.b	#INPUT_OK,input_status		;no pause.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		push and pull
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
push_z80:	lea	z80_registers,a6
		move.l	a0,(a6)+
		move.l	a1,(a6)+
		move.l	a2,(a6)+
		move.l	a3,(a6)+
		move.l	a4,(a6)+
		move.l	d0,(a6)+
		move.l	d1,(a6)+
		move.l	d2,(a6)+
		move.l	d3,(a6)+
		move.l	d4,(a6)+
		move.l	d5,(a6)
		rts

		cnop	0,4
pull_z80:	lea	z80_registers,a6
		move.l	(a6)+,a0
		move.l	(a6)+,a1
		move.l	(a6)+,a2
		move.l	(a6)+,a3
		move.l	(a6)+,a4
		move.l	(a6)+,d0
		move.l	(a6)+,d1
		move.l	(a6)+,d2
		move.l	(a6)+,d3
		move.l	(a6)+,d4
		move.l	(a6),d5
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		misc routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS
		include	"sound_routines.s"
		ENDIF
		include	"binworld:Wzonka-Lad/Sources/routines/list_alloc_32bit.s"
		include	"binworld:Wzonka-Lad/Sources/routines/load!bitplanes.s"
		include	"rle_unpacker.s"
		include	"screen_draw_new_II.s"
		include	"window_readback.s"
		include	"aga_screen_draw.s"
		include	"scanline_draw_II.s"
		include	"scanline_aga_I.s"
		IFNE	GFX_PROFILE
		include	"gfx_profile.s"
		ENDC

		include	"z80_misc.s"

		IFEQ	Z80_MODE
		include	"z80_full_III.s"
		ELSE
		include	"z80_crippled_I.s"
		ENDIF

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
low_level_name:	dc.b	"lowlevel.library",0
		even
control_pad_name:
		dc.b	"controlpad.library",0
		even
req_tools_name:	dc.b	"reqtools.library",0
		even
gad_tools_name:	dc.b	"gadtools.library",0
		even
xpk_master_name:dc.b	"xpkmaster.library",0
		even
keyboard_device_name:
		dc.b	"keyboard.device",0
		even
cyber_name:	dc.b	"cybergraphics.library",0
		even

err_diskfont:	dc.b	"Wzonka-Lad: could not open diskfont.library.",10,0
		even
err_dos:	dc.b	"Wzonka-Lad: could not open dos.library v39.",10,0
		even
err_graphics:	dc.b	"Wzonka-Lad: could not open graphics.library v39.",10,0
		even
err_intuition:	dc.b	"Wzonka-Lad: could not open intuition.library v39.",10,0
		even
err_reqtools:	dc.b	"Wzonka-Lad: could not open reqtools.library v38.",10,0
		even
err_gadtools:	dc.b	"Wzonka-Lad: could not open gadtools.library v38.",10,0
		even
		IFEQ	GAMEBOY_USERS
err_key:	dc.b	"Wzonka-Lad: Wzonka-Lad.KEY not found in PROGDIR: or L:.",10,0
		even
		ENDIF

exec_base:	dc.l	0
intuition_base:	dc.l	0
graphics_base:	dc.l	0
dos_base:	dc.l	0
disk_font_base:	dc.l	0
low_level_base:	dc.l	0
control_pad_base:
		dc.l	0
req_tools_base:	dc.l	0
gad_tools_base:	dc.l	0
xpk_master_base:dc.l	0
cyber_base:	dc.l	0

cyber_tmp_read_bitmap:
		dc.l	0

output_cyber_status:
		dc.l	0

cli_load:	dc.l	0
new_load:	dc.l	0				;0 = old rom / 1 = fresh rom.
battery_load:	dc.l	0

file_length:	dc.l	0
file_hd:	dc.l	0
file_info_ptr:	dc.l	0
file_data_ptr:	dc.l	0

cartridge_data_length:
		dc.l	0

pub_screen_lock:dc.l	0
visual_info:	dc.l	0
screen_font_y:	dc.l	0

aga_status:	dc.l	0
function_status:dc.l	0
function_gad:	dc.l	0
function_jmp:	dc.l	0

old_copper:	dc.l	0
old_vbr:	dc.l	0
old_dmareq:	dc.l	0
old_wb_view:	dc.l	0
vbr_pointer:	dc.l	0

univ_gadget:	dc.l	0
dimension_info:	dc.l	0
display_info_handle:
		dc.l	0

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
;		xpk master library variables
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

xfh_pointer:	dc.l	0

xpk_in_tags:	dc.l	XPK_InName,0			;use the parsed name.
		dc.l	TAG_END,0

xpk_unp_tags:	dc.l	XPK_InFH,0			;file hd.
		dc.l	XPK_OutBuf,0			;output buffer.
		dc.l	XPK_OutBufLen,0			;output buffer length.
		dc.l	TAG_END,0

xpk_pck_tags:	dc.l	XPK_OutFH,0			;file hd.
		dc.l	XPK_InBuf,0			;input buffer.
		dc.l	XPK_InLen,0			;input buffer length.
		dc.l	XPK_PackMethod,pck_method	;pack method.
		dc.l	TAG_END,0

pck_method:	dc.l	"XXXX"				;the method.
		dc.b	"."
		dc.b	100				;effiency.
		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the xpk sub libraries name finder
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

xpk_names:	dc.l	0
xpk_names_v:	dc.l	0
xpk_names_all:	dc.l	0
xpk_names_list:	dc.l	0
xpk_dir_name:	dc.b	"LIBS:compressors",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the req tools requester tag items and variables
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

rt_list:	dc.l	request_ptr_lo
		dc.l	request_ptr_ss
		dc.l	request_ptr_get_1
		dc.l	request_ptr_get_2
		dc.l	request_ptr_get_3
		dc.l	request_ptr_get_4
		dc.l	0

request_ptr_lo:	dc.l	0				;loading requester.
request_ptr_ss:	dc.l	0				;snapshot saving requester.
request_ptr_sm:	dc.l	0				;screenmode requester.
request_ptr_get_1:
		dc.l	0				;a request for directory gets.
request_ptr_get_2:
		dc.l	0				;a request for directory gets.
request_ptr_get_3:
		dc.l	0				;a request for directory gets.
request_ptr_get_4:
		dc.l	0				;a request for directory gets.
dir_n_name_ptr:	dc.l	0
def_ss_dir:	dc.l	0
name_ptr:	dc.l	0
def_dir:	dc.l	0

request_load:	dc.b	"Select a cartridge",0
		even
request_lsshot:	dc.b	"Load a GBS snapshot",0
		even
request_ssshot:	dc.b	"Save a GBS snapshot",0
		even
request_get_dir:dc.b	"Select a directory",0
		even
request_smode:	dc.b	"Select a screenmode",0
		even

req_tags:	dc.l	RT_Window,0
		dc.l	new_RTFI_Flags,FREQF_PATGAD
		dc.l	TAG_END,0

req_get_dir_tag:dc.l	RT_Window,0
		dc.l	new_RTFI_Flags,FREQF_NOFILES
		dc.l	TAG_END,0

req_change_tags:dc.l	xRTFI_Dir,0
		dc.l	TAG_END,0

req_smode_tags:	dc.l	TAG_END,0

req_change_screen_mode_tags:
		dc.l	xRTSC_DisplayID,0
		dc.l	TAG_END,0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		controller
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

input_status:	dc.b	0
gbs_file_id:	dc.b	0
input_poll_lines: dc.b	1
		even

joy_name_1:	dc.b	"KEYBOARD",0
		even
joy_name_2:	dc.b	"CD32 PAD",0
		even
joy_name_3:	dc.b	"SEGA 4B",0
		even
joy_name_4:	dc.b	"SEGA 2B",0
		even
joy_name_5:	dc.b	"JOY 1B",0
		even
joy_name_6:	dc.b	"JOY 2B",0
		even

joy_item_list:	dc.b	0				;controller id's.
		dc.b	1
		dc.b	2
		dc.b	3
		dc.b	4
		dc.b	5
		even

cp_handle:	dc.l	0
keyboard_io:	dc.l	0
keyboard_matrix:dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		variables for z80_x.S
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS
z80_cycles:	dc.l	22;92;456/5
		ELSE
z80_cycles:	dc.l	22-30;92;456/5			;-30 for crack protection.
		ENDIF

gb_memory:	dc.l	0
bank_address:	dc.l	0
ram_bank_no:	dc.l	0
ram_banks:	dc.l	0
ram_banks_mask:	dc.l	0
rom_banks_mask:	dc.l	0

memory_banks:	dc.l	0
z80_pc_base:	dc.l	0

i_flag:		dc.b	0				;interrupt flag.
z80_halt:	dc.b	0				;halted cpu flag.
		even

h_other_I:	dc.b	0
h_other_II:	dc.b	0
h_with_carry:	dc.b	0
h_the_flag:	dc.b	0

mbc1_status:	dc.b	0
mbc1_ram_protection_status:
		dc.b	0
mbc2_ram_protection_status:
		dc.b	0
mbc3_ram_protection_status:
		dc.b	0
		even

mbc3_latched_sec:
		dc.b	0
mbc3_latched_min:
		dc.b	0
mbc3_latched_hrs:
		dc.b	0
mbc3_latched_dayl:
		dc.b	0
mbc3_latched_dayh:
		dc.b	0

mbc3_sec:	dc.b	0
mbc3_min:	dc.b	0
mbc3_hrs:	dc.b	0
mbc3_day:
mbc3_dayh:	dc.b	0				;order is important.
mbc3_dayl:	dc.b	0

mbc3_latch_a:	dc.b	0
mbc3_latch_b:	dc.b	0
mbc3_existence:	dc.b	0
		even

mbc5_rom_bank:	dc.w	0
mbc5_rom_bank1:	dc.b	0
mbc5_rom_bank0:	dc.b	0

z80_registers:	ds.l	6+5				;d0-d5/a0-a4.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		emulator variables
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

h_values:	dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0

		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	2,3,3,0,0
		dc.b	1,1,1,1,1
		dc.b	1,1,1,1,1
		dc.b	1,1,1,1,1
		dc.b	1,1,1,1,1
		dc.b	1,1,1,1,1
		dc.b	1,1,1,1,1

		dc.b	1,1,1,1,1
		dc.b	1,1,1,1,1
		dc.b	1,1,1,1,1
		IFEQ	Z80_MODE
		IFEQ	GAMEBOY_USERS
		dc.b	1,1,1,1,1
		dc.b	2				;next frame's mode for an overrun read.
		ELSE
		dc.b	1,1,0,0,0
		ENDIF
		ELSE
		dc.b	1,1,0,0,0
		ENDIF
		even

h_values_indexed:
		dc.l	0

lcd_blank_phase: dc.b	0		;0 = visible, -1 = off, 1 = first frame, 2 = its VBlank.
lcd_blank_presented: dc.b 0
		IFEQ	Z80_MODE
lcd_start_line:	dc.b	0		;-1 = restart pending, 1 = LCD startup line.
		ENDIF
visual_frame:	dc.b	0				;used buffer number.
		even

window_y_state:
window_y_latched: dc.b	0
window_y_row:	dc.b	0

bitmap_bg:	dc.l	0				;planes 0 and 1 (c).
bitmap_spc:	dc.l	0				;planes 2 and 3 (c).

gb_scanlines:	dc.l	0
cartridge:	dc.l	0				;pointer to a cartridge.
cartridge_data:	dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		variables for x flipper and rom input supervisor
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

x_flip_table:	dc.l	0
spr_col_table:	dc.l	0
rom_32k:	dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		aga h/w mode variables
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

copper_I:	dc.l	0
copper_II:	dc.l	0
copper_inactive:dc.l	0

aga_scr_0_cI:	dc.l	0
aga_scr_cI:	dc.l	0
aga_spr_cI:	dc.l	0
aga_pln_cI:	dc.l	0
aga_col_cI:	dc.l	0
aga_hw_spr_cI:	dc.l	0

aga_map_I:	dc.l	0
aga_map_II:	dc.l	0
aga_map_inactive:
		dc.l	0

aga_col_bg:	dc.l	0
aga_col_sprs:	dc.l	0
gb_x:		dc.l	0				;scroll x for the screen.
aga_spr_amount:	dc.l	0				;max 10.
spr_pick:	dc.l	0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0
		dc.l	0,0,0,0,0,0,0,0,0,0

aga_ro_list_I:	dc.l	0
aga_ro_list_II:	dc.l	0
aga_ro_inactive:dc.l	0

aga_sprs_cI:	dc.l	0
aga_sprs_cII:	dc.l	0
aga_sprs_cxI:	dc.l	0
aga_sprs_cxII:	dc.l	0
aga_sprs_inactive:
		dc.l	0
aga_sprs_inactive_x:
		dc.l	0

aga_spr_Ia:	dc.l	0				;sprite I.
aga_spr_IIa:	dc.l	0				;       II.
aga_spr_IIIa:	dc.l	0				;       III.
aga_spr_Ib:	dc.l	0				;sprite I.
aga_spr_IIb:	dc.l	0				;       II.
aga_spr_IIIb:	dc.l	0				;       III.
aga_spr_Ix:	dc.l	0				;mask sprite I.
aga_spr_IIx:	dc.l	0				;            II.
aga_spr_IIIx:	dc.l	0				;            III.
aga_spr_empty:	dc.l	0				;empty sprite data.

aga_spr_inactive_pointer:
		dc.l	0

aga_palette_byte:
		dc.b	0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		variables for screen_draw.s
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

bg_scroll_y:	dc.l	0
bg_scroll_y_I:	dc.l	0				;screen scroll y.
bg_scroll_y_II:	dc.l	0
bg_scroll_inactive:
		dc.l	0

bg_scroll_x:	dc.l	0				;screen scroll x.
lcd_control:	dc.l	0				;lcd control byte.

sprite_y:	dc.l	0				;sprite y storage (7/15).
sprite_sign:	dc.l	0				;(sprite_y/4)-1.
win_x:		dc.l	0				;window x start position.
tile_adder:	dc.l	0				;room for signed/unsigned adder.
tile_adder_x:	dc.l	0
x_counter:	dc.l	0				;room for a counter.
gb_tiles:	dc.l	0

spr_win_flag:	dc.b	0				;0 = beyond / 1 = before.
output_bit:	dc.b	0				;for frame skipping.
frame_update:	dc.b	1				;skip this many - 1 frames.
frame_update_number:
		dc.b	0				;frame_update - 1.
sprite_mask:	dc.b	0
		even

gb_pal:		dc.w	16				;16 colours.
		dc.w	0				;the first colour.
gb_pale:	ds.l	3*16				;the colours.
		dc.l	0				;the end of the list.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		universal window tags
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

win_tags_u:	dc.l	WA_NewLookMenus,TRUE
		dc.l	WA_AutoAdjust,TRUE
		dc.l	TAG_END,0			;3d look, here too.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		register window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

register_ptr:	dc.l	0

register_window:dc.w	0
		dc.w	0
		dc.w	register_x
		dc.w	register_y
		dc.b	0
		dc.b	1
		dc.l	0
		dc.l	register_flags
		dc.l	0
		dc.l	0
		dc.l	register_title
		dc.l	0
		dc.l	0
		dc.w	0
		dc.w	0
		dc.w	register_x
		dc.w	register_y
		dc.w	WBENCHSCREEN

register_title:	dc.b	"Register Wzonka-Lad",0
		even

register_y_start	=(register_y-8*10-2-2-1)/2

register_bevel_list:
		dc.w	20,register_y_start,320-40-4-4,8*10+2+2+1
		dc.w	0

register_text_1:dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0
		dc.w	register_y_start+3
		dc.l	font_attr
		dc.l	register_txt_1
		dc.l	0

register_text_11:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0
		dc.w	register_y_start+3+8
		dc.l	font_attr
		dc.l	register_txt_11
		dc.l	0

register_text_20:
		dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0
		dc.w	register_y_start+3+8*2
		dc.l	font_attr
		dc.l	register_txt_20
		dc.l	0

register_text_21:
		dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0
		dc.w	register_y_start+3+8*4
		dc.l	font_attr
		dc.l	register_txt_21
		dc.l	0

register_text_22:
		dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0
		dc.w	register_y_start+3+8*5
		dc.l	font_attr
		dc.l	register_txt_22
		dc.l	0

register_text_23:
		dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0
		dc.w	register_y_start+3+8*6
		dc.l	font_attr
		dc.l	register_txt_23
		dc.l	0

register_text_24:
		dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0
		dc.w	register_y_start+3+8*7
		dc.l	font_attr
		dc.l	register_txt_24
		dc.l	0

register_text_2:dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0
		dc.w	register_y_start+3+8*9
		dc.l	font_attr
		dc.l	register_txt_2
		dc.l	0

register_txt_1:	dc.b	"Register me to get all the features",0
		even
register_txt_11:dc.b	"and to support Amiga!",0
		even

register_txt_20:dc.b	"Send your fan software to",0
		even
register_txt_21:dc.b	"Ville Helin (ville.helin@gmail.com)",0
		even
register_txt_22:dc.b	"Suomenlinna c54 b14",0
		even
register_txt_23:dc.b	"00190 Helsinki",0
		even
register_txt_24:dc.b	"Finland",0
		even

register_txt_2:	dc.b	"This window will close in "
register_txt_2_number:
		dc.b	"xx seconds.",0
		even

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

menu_title:	dc.b	"Wzonka-Lad 1.12.00"
		IFEQ	GAMEBOY_USERS
		dc.b	"r"
		ELSE
		dc.b	"e"
		ENDIF
		dc.b	" (68020)",0
		even

menu_b_1:	dc.l	0
menu_b_2:	dc.l	0
menu_b_3:	dc.l	0
menu_b_4:	dc.l	0
menu_b_5:	dc.l	0
menu_b_6:	dc.l	0
menu_b_7:	dc.l	0
menu_b_8:	dc.l	0
menu_b_9:	dc.l	0
menu_b_10:	dc.l	0
menu_b_11:	dc.l	0

menu_b_1_txt:	dc.b	"_Load",0
		even
menu_b_2_txt:	dc.b	"_Run",0
		even
menu_b_3_txt:	dc.b	"_Info",0
		even
menu_b_4_txt:	dc.b	"L_oad",0
		even
menu_b_5_txt:	dc.b	"S_ave",0
		even
menu_b_6_txt:	dc.b	"A_bout",0
		even
menu_b_7_txt:	dc.b	"_Gfx",0
		even
menu_b_8_txt:	dc.b	"_Sfx",0
		even
menu_b_9_txt:	dc.b	"_Prefs",0
		even
menu_b_10_txt:	dc.b	"_Misc",0
		even
menu_b_11_txt:	dc.b	"R_eset",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		function window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

function_ptr:	dc.l	0

function_window:dc.w	240-16
		dc.w	11+11
		dc.w	function_x
		dc.w	function_y
		dc.b	0
		dc.b	1
		dc.l	function_idcmp
		dc.l	function_flags
		dc.l	0
		dc.l	0
		dc.l	function_title
		dc.l	0
		dc.l	0
		dc.w	0
		dc.w	0
		dc.w	function_x
		dc.w	function_y
		dc.w	WBENCHSCREEN

function_title:	dc.b	"Functions",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		context gadgets
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

context_g_gfx:	dc.l	0
context_g_menu:	dc.l	0
context_g_prefs:dc.l	0
context_g_sfx:	dc.l	0
context_g_misc:	dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		misc gadgets
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

misc_strings_x	=70
misc_strings_dx	=44

misc_b_1:	dc.l	0
misc_b_2:	dc.l	0
misc_b_3:	dc.l	0
misc_b_6:	dc.l	0
misc_b_readback:dc.l	0
misc_b_str_1:	dc.l	0
misc_b_str_2:	dc.l	0
misc_b_str_3:	dc.l	0
misc_b_code_list:
		dc.l	0

misc_str_1:	dc.l	0
misc_str_2:	dc.l	0
misc_str_3:	dc.l	0

misc_g_y	=36
misc_patch_y	=misc_g_y+13

misc_gadgets:	dc.w	100,misc_g_y
		dc.l	PLACETEXT_RIGHT
		dc.l	misc_b_1_txt
		dc.w	0
		dc.w	5				;checkbox_kind!
		dc.l	alter_tags_checkbox
		dc.l	forbid_permit_status
		dc.l	misc_b_1

		dc.w	100,misc_g_y+13
		dc.l	PLACETEXT_RIGHT
		dc.l	misc_b_2_txt
		dc.w	1
		dc.w	5				;checkbox_kind!
		dc.l	alter_tags_checkbox
		dc.l	os_screen_speed_limit
		dc.l	misc_b_2

		dc.w	100,misc_g_y+13*2
		dc.l	PLACETEXT_RIGHT
		dc.l	misc_b_6_txt
		dc.w	6
		dc.w	5				;checkbox_kind!
		dc.l	alter_tags_checkbox
		dc.l	fast_ram_bitmaps
		dc.l	misc_b_6

		dc.w	100,misc_g_y+13*3
		dc.l	PLACETEXT_RIGHT
		dc.l	misc_b_readback_txt
		dc.w	8
		dc.w	5				;checkbox_kind!
		dc.l	alter_tags_checkbox
		dc.l	window_direct_readback
		dc.l	misc_b_readback

		dc.w	260,58+misc_patch_y
		dc.l	PLACETEXT_IN
		dc.l	misc_b_3_txt
		dc.w	2
		dc.w	0				;button_kind!
		dc.w	50,14
		dc.l	misc_b_3

		dc.w	misc_strings_x,59+misc_patch_y
		dc.l	PLACETEXT_LEFT
		dc.l	misc_b_str_1_txt
		dc.w	3
		dc.w	2				;string_kind!
		dc.w	misc_strings_dx,13
		dc.l	misc_b_str_tgs
		dc.l	misc_str_1
		dc.l	misc_b_str_1

		dc.w	misc_strings_x+misc_strings_dx+24,59+misc_patch_y
		dc.l	PLACETEXT_LEFT
		dc.l	misc_b_str_2_txt
		dc.w	4
		dc.w	2				;string_kind!
		dc.w	misc_strings_dx,13
		dc.l	misc_b_str_tgs
		dc.l	misc_str_2
		dc.l	misc_b_str_2

		dc.w	misc_strings_x+misc_strings_dx*2+24*2,59+misc_patch_y
		dc.l	PLACETEXT_LEFT
		dc.l	misc_b_str_3_txt
		dc.w	5
		dc.w	2				;string_kind!
		dc.w	misc_strings_dx,13
		dc.l	misc_b_str_tgs
		dc.l	misc_str_3
		dc.l	misc_b_str_3

		dc.w	55,78+misc_patch_y
		dc.l	PLACETEXT_LEFT
		dc.l	sfx_empty
		dc.w	7
		dc.w	3				;listview_kind!
		dc.w	270,50
		dc.l	misc_b_code_list_tags
		dc.l	misc_b_code_list_selected
		dc.l	misc_b_code_list

		dc.l	0				;end of list.

misc_b_code_list_tags:
		dc.l	GTLV_Labels,0
		dc.l	GTLV_Selected,0
		dc.l	GTLV_MakeVisible,0
		dc.l	GTLV_ShowSelected,0
		dc.l	TAG_END,0

misc_b_code_list_change_tags:
		dc.l	GTLV_Labels,0
		dc.l	TAG_END,0

misc_b_str_tgs:	dc.l	GTST_String,0
		dc.l	GTST_MaxChars,3
		dc.l	GA_TabCycle,TRUE
		dc.l	STRINGA_Justification,GACT_STRINGLEFT
		dc.l	STRINGA_ReplaceMode,FALSE
		dc.l	TAG_END,0

misc_b_1_txt:	dc.b	"Multitasking",0
		even
misc_b_2_txt:	dc.b	"OS screen speed limit",0
		even
misc_b_3_txt:	dc.b	"Patch",0
		even
misc_b_6_txt:	dc.b	"Bitmaps in FAST RAM",0
		even
misc_b_readback_txt:dc.b	"Direct Window readback",0
		even

misc_b_str_1_txt:
		dc.b	" ",0
		even
misc_b_str_2_txt:
		dc.b	"-",0
		even
misc_b_str_3_txt:
		dc.b	"-",0
		even

misc_text_1:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	170
		dc.w	misc_g_y-14
		dc.l	font_attr
		dc.l	misc_txt_1
		dc.l	misc_text_2

misc_text_2:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	122
		dc.w	misc_patch_y+45
		dc.l	font_attr
		dc.l	misc_txt_2
		dc.l	0

misc_txt_1:	dc.b	"Misc",0
		even
misc_txt_2:	dc.b	"GameGenie patch code",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu gadgets
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_scr_txt:	dc.b	"Wzonka-Lad 1.12.00"
		IFEQ	GAMEBOY_USERS
		dc.b	"r"
		ELSE
		dc.b	"e"
		ENDIF
		dc.b	" (68020) Written by Ville Helin 1996-99",0
		even

menu_b_x	=56-16-8
menu_b_y	=34-14
menu_b_width	=60
menu_b_height	=14
menu_b_distance	=88

menu_gadgets:	dc.w	menu_b_x,menu_b_y
		dc.l	PLACETEXT_IN
		dc.l	menu_b_1_txt
		dc.w	0
		dc.w	0				;button_kind!
		dc.w	menu_b_width,menu_b_height
		dc.l	menu_b_1

		dc.w	menu_b_x,menu_b_y+15
		dc.l	PLACETEXT_IN
		dc.l	menu_b_2_txt
		dc.w	1
		dc.w	0				;button_kind!
		dc.w	menu_b_width,menu_b_height
		dc.l	menu_b_2

		dc.w	menu_b_x,menu_b_y+15*3
		dc.l	PLACETEXT_IN
		dc.l	menu_b_3_txt
		dc.w	2
		dc.w	0				;button_kind!
		dc.w	menu_b_width,menu_b_height
		dc.l	menu_b_3

		dc.w	menu_b_x+menu_b_distance,menu_b_y
		dc.l	PLACETEXT_IN
		dc.l	menu_b_4_txt
		dc.w	3
		dc.w	0				;button_kind!
		dc.w	menu_b_width,menu_b_height
		dc.l	menu_b_4

		dc.w	menu_b_x+menu_b_distance,menu_b_y+15
		dc.l	PLACETEXT_IN
		dc.l	menu_b_5_txt
		dc.w	4
		dc.w	0				;button_kind!
		dc.w	menu_b_width,menu_b_height
		dc.l	menu_b_5

		dc.w	menu_b_x+menu_b_distance,menu_b_y+15*2+12
		dc.l	PLACETEXT_IN
		dc.l	menu_b_6_txt
		dc.w	5
		dc.w	0				;button_kind!
		dc.w	menu_b_width,menu_b_height
		dc.l	menu_b_6

		dc.w	menu_b_x+menu_b_distance*2,menu_b_y
		dc.l	PLACETEXT_IN
		dc.l	menu_b_7_txt
		dc.w	6
		dc.w	0				;button_kind!
		dc.w	menu_b_width,menu_b_height
		dc.l	menu_b_7

		dc.w	menu_b_x+menu_b_distance*2,menu_b_y+15
		dc.l	PLACETEXT_IN
		dc.l	menu_b_8_txt
		dc.w	7
		dc.w	0				;button_kind!
		dc.w	menu_b_width,menu_b_height
		dc.l	menu_b_8

		dc.w	menu_b_x+menu_b_distance*2,menu_b_y+15*2
		dc.l	PLACETEXT_IN
		dc.l	menu_b_9_txt
		dc.w	8
		dc.w	0				;button_kind!
		dc.w	menu_b_width,menu_b_height
		dc.l	menu_b_9

		dc.w	menu_b_x+menu_b_distance*2,menu_b_y+15*3
		dc.l	PLACETEXT_IN
		dc.l	menu_b_10_txt
		dc.w	9
		dc.w	0				;button_kind!
		dc.w	menu_b_width,menu_b_height
		dc.l	menu_b_10

		dc.w	menu_b_x,menu_b_y+15*2
		dc.l	PLACETEXT_IN
		dc.l	menu_b_11_txt
		dc.w	10
		dc.w	0				;button_kind!
		dc.w	menu_b_width,menu_b_height
		dc.l	menu_b_11

		dc.l	0				;end of the list.

menu_text_1:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	76-16-8
		dc.w	21-14
		dc.l	font_attr
		dc.l	menu_txt_1
		dc.l	menu_text_2

menu_text_2:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	164-16-8
		dc.w	21-14
		dc.l	font_attr
		dc.l	menu_txt_2
		dc.l	menu_text_3

menu_text_3:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	252-16-8
		dc.w	21-14
		dc.l	font_attr
		dc.l	menu_txt_3
		dc.l	0

menu_txt_1:	dc.b	"ROM",0
		even
menu_txt_2:	dc.b	"GBS",0
		even
menu_txt_3:	dc.b	"Edit",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		prefs gadgets
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

prefs_g_battery:dc.l	0
prefs_g_battery_status:
		dc.l	0
prefs_g_gbs:	dc.l	0
prefs_g_joy:	dc.l	0
prefs_g_str_1:	dc.l	0
prefs_g_str_2:	dc.l	0
prefs_g_str_3:	dc.l	0
prefs_g_str_4:	dc.l	0
prefs_g_get_1:	dc.l	0
prefs_g_get_2:	dc.l	0
prefs_g_get_3:	dc.l	0
prefs_g_get_4:	dc.l	0
prefs_g_rom:	dc.l	0
prefs_g_default:dc.l	0
prefs_g_xpk:	dc.l	0

joy_names_list:	dc.l	0

prefs_g_xpk_l:	dc.l	GTLV_Labels,0
		dc.l	GTLV_Selected,0
		dc.l	GTLV_MakeVisible,0
		dc.l	GTLV_ShowSelected,0
		dc.l	TAG_END,0

prefs_g_joy_l:	dc.l	GTLV_Labels,0
		dc.l	GTLV_Selected,0
		dc.l	GTLV_MakeVisible,0
		dc.l	GTLV_ShowSelected,0
		dc.l	TAG_END,0

prefs_g_str_tgs:dc.l	GTST_String,0
		dc.l	GTST_MaxChars,128
		dc.l	GA_TabCycle,TRUE
		dc.l	STRINGA_Justification,GACT_STRINGLEFT
		dc.l	STRINGA_ReplaceMode,FALSE
		dc.l	TAG_END,0

prefs_g_str_chg:dc.l	GTST_String,0
		dc.l	TAG_END,0

prefs_str_ptr:	dc.l	0

prefs_rom:	dc.b	"ROM",0
		even
prefs_gbs:	dc.b	"GBS",0
		even
prefs_prefs:	dc.b	"Prefs",0
		even
prefs_battery:	dc.b	"Battery",0
		even
prefs_get:	dc.b	"Get",0
		even
prefs_battery_ram:
		dc.b	"Battery RAM",0
		even
prefs_default:	dc.b	"Default",0
		even

string_x	=90
string_y	=15
string_dx	=200
string_dy	=13
string_b_dx	=40
string_b_dy	=13

prefs_gadgets:	dc.w	string_x,string_y
		dc.l	PLACETEXT_LEFT
		dc.l	prefs_rom
		dc.w	0
		dc.w	2				;string_kind!
		dc.w	string_dx,string_dy
		dc.l	prefs_g_str_tgs
		dc.l	prefs_str_1
		dc.l	prefs_g_str_1

		dc.w	string_x,string_y+string_dy+1
		dc.l	PLACETEXT_LEFT
		dc.l	prefs_gbs
		dc.w	1
		dc.w	2				;string_kind!
		dc.w	string_dx,string_dy
		dc.l	prefs_g_str_tgs
		dc.l	prefs_str_2
		dc.l	prefs_g_str_2

		dc.w	string_x,string_y+string_dy*2+1*2
		dc.l	PLACETEXT_LEFT
		dc.l	prefs_prefs
		dc.w	2
		dc.w	2				;string_kind!
		dc.w	string_dx,string_dy
		dc.l	prefs_g_str_tgs
		dc.l	prefs_str_3
		dc.l	prefs_g_str_3

		dc.w	string_x,string_y+string_dy*3+1*3
		dc.l	PLACETEXT_LEFT
		dc.l	prefs_battery
		dc.w	3
		dc.w	2				;string_kind!
		dc.w	string_dx,string_dy
		dc.l	prefs_g_str_tgs
		dc.l	prefs_str_4
		dc.l	prefs_g_str_4

		dc.w	string_x+string_dx+10,string_y
		dc.l	PLACETEXT_IN
		dc.l	prefs_get
		dc.w	4
		dc.w	0				;button_kind!
		dc.w	string_b_dx,string_b_dy
		dc.l	prefs_g_get_1

		dc.w	string_x+string_dx+10,string_y+string_dy+1
		dc.l	PLACETEXT_IN
		dc.l	prefs_get
		dc.w	5
		dc.w	0				;button_kind!
		dc.w	string_b_dx,string_b_dy
		dc.l	prefs_g_get_2

		dc.w	string_x+string_dx+10,string_y+string_dy*2+1*2
		dc.l	PLACETEXT_IN
		dc.l	prefs_get
		dc.w	6
		dc.w	0				;button_kind!
		dc.w	string_b_dx,string_b_dy
		dc.l	prefs_g_get_3

		dc.w	string_x+string_dx+10,string_y+string_dy*3+1*3
		dc.l	PLACETEXT_IN
		dc.l	prefs_get
		dc.w	7
		dc.w	0				;button_kind!
		dc.w	string_b_dx,string_b_dy
		dc.l	prefs_g_get_4

		dc.w	40,107
		dc.l	PLACETEXT_LEFT
		dc.l	sfx_empty
		dc.w	8
		dc.w	3				;listview_kind!
		dc.w	64,40
		dc.l	prefs_g_xpk_l
		dc.l	pck_method_number
		dc.l	prefs_g_xpk

		dc.w	144,90
		dc.l	PLACETEXT_RIGHT
		dc.l	prefs_battery_ram
		dc.w	9
		dc.w	1				;mx_kind!
		dc.l	mx_tags
		dc.l	on_off_txt_list
		dc.l	battery_xpk_status
		dc.l	prefs_g_battery

		dc.w	144,112
		dc.l	PLACETEXT_RIGHT
		dc.l	prefs_gbs
		dc.w	10
		dc.w	1				;mx_kind!
		dc.l	mx_tags
		dc.l	on_off_txt_list
		dc.l	pck_xpk_status
		dc.l	prefs_g_gbs

		dc.w	244,93
		dc.l	PLACETEXT_LEFT
		dc.l	sfx_empty
		dc.w	11
		dc.w	3				;listview_kind!
		dc.w	90,48
		dc.l	prefs_g_joy_l
		dc.l	keystick
		dc.l	prefs_g_joy

		dc.w	40,165
		dc.l	PLACETEXT_IN
		dc.l	prefs_default
		dc.w	12
		dc.w	0				;button_kind!
		dc.w	80,string_b_dy
		dc.l	prefs_g_default

		dc.w	40+80+8,165
		dc.l	PLACETEXT_IN
		dc.l	prefs_rom
		dc.w	14
		dc.w	0				;button_kind!
		dc.w	58,string_b_dy
		dc.l	prefs_g_rom

		dc.w	294,159
		dc.l	PLACETEXT_RIGHT
		dc.l	prefs_battery
		dc.w	13
		dc.w	1				;mx_kind!
		dc.l	mx_tags
		dc.l	on_off_txt_list
		dc.l	battery_status
		dc.l	prefs_g_battery_status

		dc.l	0

prefs_str_1:	dc.l	0
prefs_str_2:	dc.l	0
prefs_str_3:	dc.l	0
prefs_str_4:	dc.l	0

prefs_text_1:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	170
		dc.w	2
		dc.l	font_attr
		dc.l	prefs_txt_1
		dc.l	prefs_text_2

prefs_text_2:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	35
		dc.w	78
		dc.l	font_attr
		dc.l	prefs_txt_2
		dc.l	prefs_text_3

prefs_text_3:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	258
		dc.w	78
		dc.l	font_attr
		dc.l	prefs_txt_3
		dc.l	prefs_text_4

prefs_text_4:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	56
		dc.w	152
		dc.l	font_attr
		dc.l	prefs_txt_4
		dc.l	prefs_text_5

prefs_text_5:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	278
		dc.w	146
		dc.l	font_attr
		dc.l	prefs_txt_5
		dc.l	0

prefs_txt_1:	dc.b	"Paths",0
		even
prefs_txt_2:	dc.b	"XPK packing when saving",0
		even
prefs_txt_3:	dc.b	"Controller",0
		even
prefs_txt_4:	dc.b	"Save preferences",0
		even
prefs_txt_5:	dc.b	"RAM",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sfx gadgets
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sfx_g_audio:	dc.l	0
sfx_g_quality:	dc.l	0
sfx_g_c_1:	dc.l	0
sfx_g_c_2:	dc.l	0
sfx_g_c_3:	dc.l	0
sfx_g_c_4:	dc.l	0
sfx_g_ahi_mode:	dc.l	0
sfx_g_y_hz:	dc.l	0
sfx_g_volume:	dc.l	0

mx_tags:	dc.l	GTMX_Labels,0
		dc.l	GTMX_Active,0
		dc.l	GTMX_Spacing,2
		dc.l	GTMX_TitlePlace,PLACETEXT_LEFT
		dc.l	TAG_END,0

mx_special_tags:dc.l	GTMX_Labels,0
		dc.l	GTMX_Active,0
		dc.l	GTMX_Spacing,10
		dc.l	GTMX_TitlePlace,PLACETEXT_LEFT
		dc.l	TAG_END,0

alter_tags_slider:
		dc.l	GTSL_Level,0
		dc.l	TAG_END,0

alter_tags_mx:	dc.l	GTMX_Active,0
		dc.l	TAG_END,0

alter_tags_checkbox:
		dc.l	GTCB_Checked,0
		dc.l	TAG_END,0

on_off_txt_list:dc.l	sfx_on
		dc.l	sfx_off
		dc.l	0

sfx_quality_txt:dc.l	sfx_high
		dc.l	sfx_low
		dc.l	sfx_y_hz
		dc.l	0

sfx_audio:	dc.b	"Audio",0
		even
sfx_on:		dc.b	"On",0
		even
sfx_off:	dc.b	"Off",0
		even
sfx_quality:	dc.b	"Quality",0
		even
sfx_high:	dc.b	"High",0
		even
sfx_low:	dc.b	"Low",0
		even
sfx_y_hz:	dc.b	"y Hz",0
		even
sfx_y:		dc.b	"y",0
		even
sfx_empty:	dc.b	" ",0
		even
sfx_c_1:	dc.b	"1",0
		even
sfx_c_2:	dc.b	"2",0
		even
sfx_c_3:	dc.b	"3",0
		even
sfx_c_4:	dc.b	"4",0
		even
sfx_volume:	dc.b	"Volume",0
		even

channel_x	=132
channel_y	=82+8
audio_x		=122
audio_y		=38

sfx_slider_h_tags:
		dc.l	GTSL_Level,0
		dc.l	GTSL_Max,60
		dc.l	GTSL_Min,1
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	GTSL_Justification,GTJ_LEFT
		dc.l	GTSL_MaxLevelLen,3
		dc.l	GTSL_LevelFormat,level_format
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_END,0

		IFEQ	GAMEBOY_USERS
sfx_gadgets:	dc.w	audio_x,audio_y-12+8
		dc.l	PLACETEXT_LEFT
		dc.l	sfx_audio
		dc.w	0
		dc.w	5				;checkbox_kind!
		dc.l	alter_tags_checkbox
		dc.l	snd_master
		dc.l	sfx_g_audio

		dc.w	audio_x+170,audio_y-5-10+8
		dc.l	PLACETEXT_RIGHT
		dc.l	sfx_quality
		dc.w	1
		dc.w	1				;mx_kind!
		dc.l	mx_tags
		dc.l	sfx_quality_txt
		dc.l	snd_quality
		dc.l	sfx_g_quality

		dc.w	channel_x+30*3,channel_y
		dc.l	PLACETEXT_RIGHT
		dc.l	sfx_empty
		dc.w	5
		dc.w	5				;checkbox_kind!
		dc.l	alter_tags_checkbox
		dc.l	snd_chnlIV
		dc.l	sfx_g_c_4

		dc.w	channel_x+30*2,channel_y
		dc.l	PLACETEXT_RIGHT
		dc.l	sfx_empty
		dc.w	4
		dc.w	5				;checkbox_kind!
		dc.l	alter_tags_checkbox
		dc.l	snd_chnlIII
		dc.l	sfx_g_c_3

		dc.w	channel_x+30,channel_y
		dc.l	PLACETEXT_RIGHT
		dc.l	sfx_empty
		dc.w	3
		dc.w	5				;checkbox_kind!
		dc.l	alter_tags_checkbox
		dc.l	snd_chnlII
		dc.l	sfx_g_c_2

		dc.w	channel_x,channel_y
		dc.l	PLACETEXT_RIGHT
		dc.l	sfx_empty
		dc.w	2
		dc.w	5				;checkbox_kind!
		dc.l	alter_tags_checkbox
		dc.l	snd_chnlI
		dc.l	sfx_g_c_1

		dc.w	161,117+5
		dc.l	PLACETEXT_IN
		dc.l	ahi_title
		dc.w	6
		dc.w	0				;button_kind!
		dc.w	60,14
		dc.l	sfx_g_ahi_mode

		dc.w	64,164
		dc.l	PLACETEXT_LEFT
		dc.l	sfx_y
		dc.w	7
		dc.w	4				;slider_kind!
		dc.w	250,10
		dc.l	sfx_slider_h_tags
		dc.l	60
		dc.l	refresh_scanline
		dc.l	sfx_g_y_hz

		dc.w	90,41+8
		dc.l	PLACETEXT_LEFT
		dc.l	sfx_volume
		dc.w	8
		dc.w	4				;slider_kind!
		dc.w	84,10
		dc.l	sfx_slider_h_tags
		dc.l	16
		dc.l	sfx_volume_value
		dc.l	sfx_g_volume

		dc.l	0

		ENDIF

sfx_ahi_text:	dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0
		dc.w	116+17+5
		dc.l	font_attr
sfx_ahi_txt:	dc.l	0
		dc.l	0

chnl_num_x	=channel_x+10
chnl_num_y	=channel_y-9

sfx_c_1_text:	dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	chnl_num_x
		dc.w	chnl_num_y
		dc.l	font_attr
		dc.l	sfx_c_1
		dc.l	sfx_c_2_text

sfx_c_2_text:	dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	chnl_num_x+30
		dc.w	chnl_num_y
		dc.l	font_attr
		dc.l	sfx_c_2
		dc.l	sfx_c_3_text

sfx_c_3_text:	dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	chnl_num_x+30*2
		dc.w	chnl_num_y
		dc.l	font_attr
		dc.l	sfx_c_3
		dc.l	sfx_c_4_text

sfx_c_4_text:	dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	chnl_num_x+30*3
		dc.w	chnl_num_y
		dc.l	font_attr
		dc.l	sfx_c_4
		dc.l	sfx_c_5_text

sfx_c_5_text:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	164
		dc.w	109
		dc.l	font_attr
		dc.l	sfx_ahi_mode
		dc.l	sfx_c_6_text

sfx_c_6_text:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	164
		dc.w	60+8
		dc.l	font_attr
		dc.l	sfx_channels
		dc.l	sfx_c_7_text

sfx_c_7_text:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	96
		dc.w	9+8
		dc.l	font_attr
		dc.l	sfx_master
		dc.l	sfx_c_8_text

sfx_c_8_text:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	274
		dc.w	9+8
		dc.l	font_attr
		dc.l	sfx_audio
		dc.l	sfx_c_9_text

sfx_c_9_text:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	164
		dc.w	109+34+9
		dc.l	font_attr
		dc.l	sfx_variables
		dc.l	0

sfx_ahi_mode:	dc.b	"AHI mode",0
		even
sfx_channels:	dc.b	"Channels",0
		even
sfx_master:	dc.b	"Master",0
		even
sfx_variables:	dc.b	"Variables",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		gfx gadgets
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gfx_g_aga_mode:	dc.l	0
gfx_g_driver:	dc.l	0
gfx_g_frame_skip:
		dc.l	0
gfx_g_mode:	dc.l	0
gfx_g_obtain:	dc.l	0
gfx_g_scaling:	dc.l	0
gfx_g_scanline_x:
		dc.l	0
gfx_g_select:	dc.l	0
gfx_g_colour_load:
		dc.l	0

aga_mode_txt_list:
		dc.l	gfx_pal
		dc.l	gfx_ntsc
		dc.l	0

drivers_txt_list:
		dc.l	gfx_aga
		dc.l	gfx_screen
		dc.l	gfx_window
		dc.l	0

scaling_txt_list:
		dc.l	gfx_solid
		dc.l	gfx_scalable
		dc.l	0

update_txt_list:dc.l	gfx_full
		dc.l	gfx_x_153
		dc.l	0

gfx_solid:	dc.b	"Solid",0
		even
gfx_scalable:	dc.b	"Scalable",0
		even
gfx_pal:	dc.b	"PAL",0
		even
gfx_ntsc:	dc.b	"NTSC",0
		even
gfx_full:	dc.b	"Full",0
		even
gfx_x_153:	dc.b	"x/153",0
		even
gfx_aga:	dc.b	"AGA",0
		even
gfx_screen:	dc.b	"Screen",0
		even
gfx_window:	dc.b	"Window",0
		even
gfx_driver:	dc.b	"Driver",0
		even
gfx_scanline:	dc.b	"x",0
		even
gfx_mode:	dc.b	"Mode",0
		even
gfx_select:	dc.b	"Select",0
		even
gfx_obtain:	dc.b	"Obtain",0
		even
gfx_load:	dc.b	"Load",0
		even
gfx_frame_skip:	dc.b	"Frame skip",0
		even
gfx_empty:	dc.b	" ",0

slider_h_tags:	dc.l	GTSL_Level,0
		dc.l	GTSL_Max,153
		dc.l	GTSL_Min,0
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	GTSL_Justification,GTJ_LEFT
		dc.l	GTSL_MaxLevelLen,3
		dc.l	GTSL_LevelFormat,level_format
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_END,0

level_format:	dc.b	"%ld",0
		even

driver_x	=198
driver_y	=20

gfx_gadgets:	dc.w	driver_x+53,driver_y-5
		dc.l	PLACETEXT_RIGHT
		dc.l	gfx_empty
		dc.w	5
		dc.w	1				;mx_kind!
		dc.l	mx_tags
		dc.l	aga_mode_txt_list
		dc.l	aga_mode
		dc.l	gfx_g_aga_mode

		dc.w	driver_x,driver_y
		dc.l	PLACETEXT_RIGHT
		dc.l	gfx_driver
		dc.w	0
		dc.w	1				;mx_kind!
		dc.l	mx_special_tags
		dc.l	drivers_txt_list
		dc.l	old_render
		dc.l	gfx_g_driver

		dc.w	driver_x+72,driver_y+31
		dc.l	PLACETEXT_RIGHT
		dc.l	gfx_empty
		dc.w	1
		dc.w	1				;mx_kind!
		dc.l	mx_tags
		dc.l	scaling_txt_list
		dc.l	scaling_status
		dc.l	gfx_g_scaling

		dc.w	74,33
		dc.l	PLACETEXT_RIGHT
		dc.l	gfx_mode
		dc.w	2
		dc.w	1				;mx_kind!
		dc.l	mx_tags
		dc.l	update_txt_list
		dc.l	old_refresh
		dc.l	gfx_g_mode

		dc.w	50,89
		dc.l	PLACETEXT_LEFT
		dc.l	gfx_scanline
		dc.w	3
		dc.w	4				;slider_kind!
		dc.w	130,10
		dc.l	slider_h_tags
		dc.l	153
		dc.l	refresh_scanline
		dc.l	gfx_g_scanline_x

		dc.w	driver_x+74,driver_y+16
		dc.l	PLACETEXT_IN
		dc.l	gfx_select
		dc.w	4
		dc.w	0				;button_kind!
		dc.w	60,13
		dc.l	gfx_g_select

		dc.w	120,120
		dc.l	PLACETEXT_IN
		dc.l	gfx_obtain
		dc.w	6
		dc.w	0				;button_kind!
		dc.w	61,14
		dc.l	gfx_g_obtain

		dc.w	298,89
		dc.l	PLACETEXT_LEFT
		dc.l	gfx_frame_skip
		dc.w	7
		dc.w	4				;slider_kind!
		dc.w	30,10
		dc.l	slider_h_tags
		dc.l	16
		dc.l	frame_update_number
		dc.l	gfx_g_frame_skip

		dc.w	190,122
		dc.l	PLACETEXT_RIGHT
		dc.l	gfx_load
		dc.w	8
		dc.w	5				;checkbox_kind!
		dc.l	alter_tags_checkbox
		dc.l	colour_load_status
		dc.l	gfx_g_colour_load

		dc.l	0

gfx_txt_1:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	124
		dc.w	2
		dc.l	font_attr
		dc.l	gfx_emulation
		dc.l	gfx_txt_2

gfx_txt_2:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	154
		dc.w	77
		dc.l	font_attr
		dc.l	gfx_variables
		dc.l	gfx_txt_3

gfx_txt_3:	dc.b	2
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	158
		dc.w	106
		dc.l	font_attr
		dc.l	gfx_colours
		dc.l	0

gfx_emulation:	dc.b	"Graphics emulation",0
		even
gfx_variables:	dc.b	"Variables",0
		even
gfx_colours:	dc.b	"Colours",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		about texts
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

about_text_1:	dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0				;x is computed.
		dc.w	173
		dc.l	font_attr
		dc.l	about_txt_1
		dc.l	0

about_text_2:	dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0				;x is computed.
		dc.w	173+8
		dc.l	font_attr
		dc.l	about_txt_2
		dc.l	0

about_txt_1:	dc.b	"WZONKA-LAD 1.12.00"
		IFEQ	GAMEBOY_USERS
		dc.b	"R"
		ELSE
		dc.b	"E"
		ENDIF

		dc.b	" (68020 / "
		IFEQ	Z80_MODE
		dc.b	"FULL Z80)",0
		ENDIF
		IFLT	Z80_MODE
		dc.b	"CRIPPLED Z80)",0
		ENDIF
		IFGT	Z80_MODE
		dc.b	"CRIPPLED HARDWARE)",0
		ENDIF

about_txt_2:	dc.b	"UNREGISTERED VERSION",0
		ds.b	64
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		info texts
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

info_y		=149

info_text_1:	dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0				;x is computed.
		dc.w	info_y
		dc.l	font_attr
		dc.l	info_txt_1
		dc.l	0

info_text_2:	dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0				;x is computed.
		dc.w	info_y+8
		dc.l	font_attr
		dc.l	info_txt_2
		dc.l	0

info_text_3:	dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0				;x is computed.
		dc.w	info_y+8*2
		dc.l	font_attr
rom_ptr:	dc.l	info_txt_na
		dc.l	0

info_text_4:	dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0				;x is computed.
		dc.w	info_y+8*3
		dc.l	font_attr
ram_ptr:	dc.l	info_txt_na
		dc.l	0

info_text_5:	dc.b	1
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0				;x is computed.
		dc.w	info_y+8*4
		dc.l	font_attr
battery_ptr:	dc.l	info_txt_na
		dc.l	0

info_txt_1:	dc.b	"N/A",0
		ds.b	32
		even
info_txt_2:	dc.b	"N/A",0
		ds.b	64
		even
info_txt_na:	dc.b	"N/A",0
		even

info_txt_n_btt:	dc.b	"NO BATTERY FOUND",0
		even
info_txt_y_btt:	dc.b	"BATTERY LOCATED",0
		even

info_text_list:	dc.l	info_text_1
		dc.l	info_text_2
		dc.l	info_text_3
		dc.l	info_text_4
		dc.l	info_text_5

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sanpshotting variables
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

snapshot_area:	dc.l	0
snapshot_size:	dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		bitmaps
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

info_map_attr:	dc.l	0
about_map_attr:	dc.l	0
back_pattern_map_attr:
		dc.l	0
wzonka_map_attr:dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		keyfile
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS
key_name:	dc.b	"PROGDIR:Wzonka-Lad.KEY",0
		ds.b	8
		even

key_file:	dc.l	0

reg_to_obsolete:dc.l	0				;obsolete coordinates.
		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		ahi variables, lists and names
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS
snd_master:	dc.b	0
snd_chnlI:	dc.b	0
snd_chnlII:	dc.b	0
snd_chnlIII:	dc.b	0
snd_chnlIV:	dc.b	0
snd_quality:	dc.b	0
		even

ahi_name:	dc.b	"ahi.device",0
		even

ahi_port:	dc.l	0
ahi_ior:	dc.l	0
ahi_device:	dc.l	0
ahi_audio_ctrl:	dc.l	0
ahi_request:	dc.l	0
ahi_base:	dc.l	0

ahi_alloc_tags:	dc.l	AHIA_AudioID,AHI_DEFAULT_ID
		dc.l	AHIA_MixFreq,4410
		dc.l	AHIA_Channels,4
		dc.l	AHIA_Sounds,4
		dc.l	TAG_END,0

ahi_requ_tags:	dc.l	AHIR_Window,0
		dc.l	AHIR_InitialMixFreq,4410
		dc.l	AHIR_InitialAudioID,AHI_DEFAULT_ID
		dc.l	AHIR_TitleText,ahi_title
		dc.l	AHIR_DoMixFreq,TRUE
		dc.l	TAG_END,0

ahi_ctrl_tags_I:dc.l	AHIC_Play,TRUE
		dc.l	TAG_END,0

ahi_attrs_tags:	dc.l	AHIDB_Name,0
		dc.l	AHIDB_BufferLen,128
		dc.l	TAG_END,0

ahi_mode_txt:	dc.l	0
ahi_mix_freq:	dc.l	4410
ahi_mode_id:	dc.l	0

smpl_info_I:	dc.l	0
smpl_info_II:	dc.l	0
smpl_info_III:	dc.l	0
smpl_info_IV:	dc.l	0

ahi_title:	dc.b	"Select",0
		even

smpl_bn_1:	dc.b	$80
		dc.b	$7f
		dc.b	$7f
		dc.b	$7f
		dc.b	$7f
		dc.b	$7f
		dc.b	$7f
		dc.b	$7f

smpl_bn_2:	dc.b	$80
		dc.b	$80
		dc.b	$7f
		dc.b	$7f
		dc.b	$7f
		dc.b	$7f
		dc.b	$7f
		dc.b	$7f

smpl_bn_3:	dc.b	$80
		dc.b	$80
		dc.b	$80
		dc.b	$80
		dc.b	$7f
		dc.b	$7f
		dc.b	$7f
		dc.b	$7f

smpl_bn_4:	dc.b	$80
		dc.b	$80
		dc.b	$80
		dc.b	$80
		dc.b	$80
		dc.b	$80
		dc.b	$7f
		dc.b	$7f

smpl_mem_1:	dc.l	0
smpl_mem_2:	dc.l	0
smpl_mem_3:	dc.l	0
smpl_mem_4:	dc.l	0

smpl_III_mem:	dc.l	0
smpl_IV_mem:	dc.l	0
smpl_IV_short:	dc.l	0

sound_routines_for_y_driver:
sound_routines:	dc.l	sound_I_0
		dc.l	sound_I_1
		dc.l	sound_I_2
		dc.l	sound_I_3
		dc.l	sound_I_4

		dc.l	sound_II_1
		dc.l	sound_II_2
		dc.l	sound_II_3
		dc.l	sound_II_4

		dc.l	sound_III_0
		dc.l	sound_III_1
		dc.l	sound_III_2
		dc.l	sound_III_3
		dc.l	sound_III_4

		dc.l	sound_IV_1
		dc.l	sound_IV_2
		dc.l	sound_IV_3
		dc.l	sound_IV_4

		dc.l	sound_V_0
		dc.l	sound_V_1
		dc.l	sound_V_2

		dc.l	copy_snd_data

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		rom and ram size tables
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gb_mem_jumps:	dc.l	0

rom_table:	dc.l	rom_kb256,rom_kb512,rom_mb1,rom_mb2,rom_mb4,rom_mb8
		dc.l	rom_mb16,rom_mb32,rom_mb64,rom_illegal
		dc.l	rom_mb9,rom_mb10,rom_mb12

ram_table:	dc.l	ram_kb0,ram_kb16,ram_kb64,ram_kb256,ram_mb1
		dc.l	ram_illegal

mapper_table:	dc.l	map_0,map_1,map_2,map_3,map_inv,map_5,map_6
		dc.l	map_inv,map_8,map_9
		dc.l	map_inv ;a.
		dc.l	map_b   ;b.
		dc.l	map_c   ;c.
		dc.l	map_d   ;d.
		dc.l	map_inv ;e.
		dc.l	map_f   ;f.
		dc.l	map_10  ;10.
		dc.l	map_11  ;11.
		dc.l	map_12  ;12.
		dc.l	map_13  ;13.
		dc.l	map_inv ;14.
		dc.l	map_15  ;15.
		dc.l	map_16  ;16.
		dc.l	map_17  ;17.
		dc.l	map_inv ;18.
		dc.l	map_19  ;19.
		dc.l	map_1a  ;1a.
		dc.l	map_1b  ;1b.
		dc.l	map_1c  ;1c.
		dc.l	map_1d  ;1d.
		dc.l	map_1e  ;1e.
		dc.l	map_1f  ;1f.

map_0:		dc.b	"ROM ONLY",0
		even
map_1:		dc.b	"ROM+MBC1",0
		even
map_2:		dc.b	"ROM+MBC1+RAM",0
		even
map_3:		dc.b	"ROM+MBC1+RAM+BATTERY",0
		even
map_5:		dc.b	"ROM+MBC2",0
		even
map_6:		dc.b	"ROM+MBC2+BATTERY",0
		even
map_8:		dc.b	"ROM+RAM",0
		even
map_9:		dc.b	"ROM+RAM+BATTERY",0
		even
map_b:		dc.b	"ROM+MMM01 (EMAIL ME!)",0
		even
map_c:		dc.b	"ROM+MMM01+SRAM (EMAIL ME!)",0
		even
map_d:		dc.b	"ROM+MMM01+SRAM+BATTERY (EMAIL ME!)",0
		even
map_f:		dc.b	"ROM+MBC3+TIMER+BATTERY",0
		even
map_10:		dc.b	"ROM+MBC3+TIMER+RAM+BATTERY",0
		even
map_11:		dc.b	"ROM+MBC3",0
		even
map_12:		dc.b	"ROM+MBC3+RAM",0
		even
map_13:		dc.b	"ROM+MBC3+RAM+BATTERY",0
		even
map_15:		dc.b	"ROM+MBC4 (EMAIL ME!)",0
		even
map_16:		dc.b	"ROM+MBC4+RAM (EMAIL ME!)",0
		even
map_17:		dc.b	"ROM+MBC4+RAM+BATTERY (EMAIL ME!)",0
		even
map_19:		dc.b	"ROM+MBC5",0
		even
map_1a:		dc.b	"ROM+MBC5+RAM",0
		even
map_1b:		dc.b	"ROM+MBC5+RAM+BATTERY",0
		even
map_1c:		dc.b	"ROM+MBC5+RUMBLE",0
		even
map_1d:		dc.b	"ROM+MBC5+RUMBLE+SRAM",0
		even
map_1e:		dc.b	"ROM+MBC5+RUMBLE+SRAM+BATTERY",0
		even
map_1f:		dc.b	"POCKET CAMERA (EMAIL ME!)",0
		even
map_fd:		dc.b	"BANDAI TAMA5 (EMAIL ME!)",0
		even
map_fe:		dc.b	"ROM+HUC3+RAM+BATTERY (EMAIL ME!)",0
		even
map_ff:		dc.b	"ROM+HUC1+RAM+BATTERY",0
		even
map_inv:	dc.b	"UNKNOWN CARTRIDGE TYPE! (EMAIL ME!)",0
		even

ram_kb0:	dc.b	"NO EXTERNAL RAM",0
		even
ram_kb16:	dc.b	"2KB OF EXTERNAL RAM",0
		even
ram_kb64:	dc.b	"8KB OF EXTERNAL RAM",0
		even
ram_kb256:	dc.b	"32KB OF EXTERNAL RAM",0
		even
ram_mb1:	dc.b	"128KB OF EXTERNAL RAM",0
		even
ram_illegal:	dc.b	"UNKNOWN AMOUNT OF RAM BANKS!",0
		even
rom_kb256:	dc.b	"2 ROM BANKS",0
		even
rom_kb512:	dc.b	"4 ROM BANKS",0
		even
rom_mb1:	dc.b	"8 ROM BANKS",0
		even
rom_mb2:	dc.b	"16 ROM BANKS",0
		even
rom_mb4:	dc.b	"32 ROM BANKS",0
		even
rom_mb8:	dc.b	"64 ROM BANKS",0
		even
rom_mb9:	dc.b	"72 ROM BANKS",0
		even
rom_mb10:	dc.b	"80 ROM BANKS",0
		even
rom_mb12:	dc.b	"96 ROM BANKS",0
		even
rom_mb16:	dc.b	"128 ROM BANKS",0
		even
rom_mb32:	dc.b	"256 ROM BANKS",0
		even
rom_mb64:	dc.b	"512 ROM BANKS",0
		even
rom_illegal:	dc.b	"UNKNOWN AMOUNT OF ROM BANKS!",0
		even

rom_banks_list:	dc.l	2-1,4-1,8-1,16-1,32-1,64-1,128-1,256-1,512-1
		dc.l	0,9-1,10-1,12-1
		even

ram_banks_list:	dc.b	0,1,1,4,16
		even
ram_banks_mask_list:
		dc.b	0,0,0,3,15
		even

cartridge_name:	ds.b	32
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		preferences file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

prefs_file_name:dc.b	"ENVARC:Wzonka-Lad.prefs",0
		even
prefs_file:	dc.l	0
prefs_file_rom:	dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the window titles
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

info_win_txt:	dc.b	"ROM image information",0
		even
about_win_txt:	dc.b	"About Wzonka-Lad",0
		even
prefs_win_txt:	dc.b	"Preferences",0
		even
sfx_win_txt:	dc.b	"Sound settings",0
		even
gfx_win_txt:	dc.b	"Visual settings",0
		even
misc_win_txt:	dc.b	"Misc settings",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the version string
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

version_data:	dc.b	"$VER: Wzonka-Lad 1.12.00"
		IFEQ	GAMEBOY_USERS
		dc.b	"r"
		ELSE
		dc.b	"e"
		ENDIF
		dc.b	" (16.11.2026)",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		list header
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

joy_label_list:	dc.l	0
xpk_label_list:	dc.l	0
gg_label_list:	dc.l	0
gg_dummy_item:	dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		bevel box lists
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_bevel_list:dc.w	24,29-14,76,54+15
		dc.w	24+76+12,29-14,76,39
		dc.w	24+76*2+12*2,29-14,76,54+15
		dc.w	24,80+7,76*3+12*2,14
		dc.w	0

sfx_bevel_list:	dc.w	28,17+8,326-122-22,41
		dc.w	28+326-122,17+8,122,41
		dc.w	100,68+8,182,31
		dc.w	28,68+39+10,326,33
		dc.w	28,68+39+10+33+10,326,19
		dc.w	0

prefs_bevel_list:
		dc.w	26,10,326,66
		dc.w	26,86,174,64
		dc.w	26,160,174,23
		dc.w	227,86,125,58
		dc.w	227,154,125,29
		dc.w	0

gfx_bevel_list:	dc.w	20,10,334,65
		dc.w	20,85,334,19
		dc.w	20,114,334,69
		dc.w	0

misc_bevel_list:dc.w	75,misc_g_y-6,255,49+13
		dc.w	35,misc_patch_y+53,305,78
		dc.w	0

bevel_box_tags:	dc.l	GT_VisualInfo,0
		dc.l	GTBB_Recessed,TRUE
		dc.l	GTBB_FrameType,BBFT_BUTTON
		dc.l	TAG_END,0

bevel_box_tagz:	dc.l	GT_VisualInfo,0
		dc.l	GTBB_FrameType,BBFT_BUTTON
		dc.l	TAG_END,0

button_gadget_underscore_tag:
		dc.l	GT_Underscore, '_'
		dc.l	TAG_END,0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		window graphics
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
back_pattern_bn:incbin	"windows/pattern.bn"
		cnop	0,4
about_map_rle:	incbin	"windows/about.rle"
		cnop	0,4
info_map_rle:	incbin	"windows/info.rle"
		cnop	0,4

about_map:	dc.l	0
info_map:	dc.l	0
back_pattern_map:
		dc.l	0
wzonka_map:	dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		message port
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

message_port:	dc.l	0
message_port_colour_editor:
		dc.l	0
message_port_name:
		dc.b	"Wzonka-Lad Port",0
		even
message_port_colour_editor_name:
		dc.b	"Wzonka-Lad Palette Editor Port",0
		even

obtain_gadget_status:
		dc.l	0				;0 = on / 1 = off.
colour_message:	dc.l	0
colour_message_name:
		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		read pixel array
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gfx_game_still_array:
		dc.l	0
gfx_game_still_map_attr:
		dc.l	0
gfx_game_still_rast_port:
		dc.l	0

gfx_game_still_tmp_array:
		dc.l	0
gfx_game_still_tmp_map_attr:
		dc.l	0
gfx_game_still_tmp_rast_port:
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

gameboy_colours_conversion_table:
		ds.b	16

pen_conversion_table:
		dc.l	0
window_scale_table:
		dc.l	0
pen_list:	ds.b	8
pen_storage_list:
		ds.b	8

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the 20 recent menu items for menu window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		include	"menu_data_recent.i"

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the favourite menu items for menu window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		include	"menu_data_favourite.i"

menu_favo_nf:	dc.l	0				;menu name field.
menu_favo_fl:	dc.l	0				;menu input file.

menu_favo_nm:	dc.b	"PROGDIR:favourites/favourites.list",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the keyboard handler
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

buttons_byte:	dc.b	$cf
directions_byte:dc.b	$cf
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		ram lists
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

ram_size_list:	dc.l	8192				;actually 0kb.
		dc.l	8192				;         2  .
		dc.l	8192
		dc.l	32768
		dc.l	131072
		dc.l	131072
		dc.l	131072
		dc.l	131072

mapper_list:	dc.l	mapper_na
		dc.l	mapper_mbc1
		dc.l	mapper_mbc1_ram
		dc.l	mapper_mbc1_ram_battery
		dc.l	mapper_na			;invalid entry.
		dc.l	mapper_mbc2
		dc.l	mapper_mbc2_battery
		dc.l	mapper_na			;invalid entry.
		dc.l	mapper_ram
		dc.l	mapper_ram_battery

		dc.l	mapper_na			;a.
		dc.l	mapper_na
		dc.l	mapper_na
		dc.l	mapper_na
		dc.l	mapper_na
		dc.l	mapper_mbc3_timer_battery	;f.

		dc.l	mapper_mbc3_timer_ram_battery	;10.
		dc.l	mapper_mbc3			;11.
		dc.l	mapper_mbc3_ram			;12.
		dc.l	mapper_mbc3_ram_battery		;13.
		dc.l	mapper_na
		dc.l	mapper_na			;15.
		dc.l	mapper_na			;16.
		dc.l	mapper_na			;17.
		dc.l	mapper_na

		dc.l	mapper_mbc5			;19.
		dc.l	mapper_mbc5_ram			;1a.
		dc.l	mapper_mbc5_ram_battery		;1b.
		dc.l	mapper_mbc5_rumble		;1c.
		dc.l	mapper_mbc5_rumble_sram		;1d.
		dc.l	mapper_mbc5_rumble_sram_battery	;1e.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		ROM+HUC1+RAM (+BATTERY)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

mapper_huc1_ram:
mapper_huc1_ram_battery:
		dc.l	mapper_huc1_0kb_ram
		dc.l	mapper_huc1_2kb_ram
		dc.l	mapper_huc1_8kb_ram
		dc.l	mapper_huc1_32kb_ram

mapper_huc1_0kb_ram:
		dc.l	6-1,$2000-1
		dc.l	rom_write
		dc.l	mbc1_rom_switch
		dc.l	mbc1_rom_switch_two_address_lines
		dc.l	mbc1_rom_mode_select
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
;		dc.l	gb_mem_wr_denied

mapper_huc1_2kb_ram:
		dc.l	24-1,$800-1

		dc.l	mbc1_ram_protection
		dc.l	mbc1_ram_protection
		dc.l	mbc1_ram_protection
		dc.l	mbc1_ram_protection		;$2000.

		dc.l	mbc1_rom_switch
		dc.l	mbc1_rom_switch
		dc.l	mbc1_rom_switch
		dc.l	mbc1_rom_switch			;$4000.

		dc.l	mbc1_rom_switch_two_address_lines
		dc.l	mbc1_rom_switch_two_address_lines
		dc.l	mbc1_rom_switch_two_address_lines
		dc.l	mbc1_rom_switch_two_address_lines
							;$6000.
		dc.l	mbc1_rom_mode_select
		dc.l	mbc1_rom_mode_select
		dc.l	mbc1_rom_mode_select
		dc.l	mbc1_rom_mode_select		;$8000.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr			;$a000.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr			;$c000.

;		dc.l	gb_mem_wr
;		dc.l	gb_mem_wr_denied
;		dc.l	gb_mem_wr_denied
;		dc.l	gb_mem_wr_denied		;$c000.

mapper_huc1_8kb_ram:
		dc.l	4-1,$2000-1
		dc.l	mbc1_ram_protection
		dc.l	mbc1_rom_switch
		dc.l	mbc1_rom_switch_two_address_lines
		dc.l	mbc1_rom_mode_select

mapper_huc1_32kb_ram:
		dc.l	4-1,$2000-1
		dc.l	mbc1_ram_protection
		dc.l	mbc1_rom_switch
		dc.l	mbc1_ram_switch_with_two_rom_address_lines
		dc.l	mbc1_rom_mode_select

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		ROM+MBC5+RAM (+BATTERY)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

mapper_mbc5_ram:
mapper_mbc5_ram_battery:
mapper_mbc5_rumble_sram:
mapper_mbc5_rumble_sram_battery:
		dc.l	mapper_mbc5_0kb_ram
		dc.l	mapper_mbc5_2kb_ram
		dc.l	mapper_mbc5_8kb_ram
		dc.l	mapper_mbc5_32kb_ram
		dc.l	mapper_mbc5_128kb_ram

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		ROM+MBC5
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

mapper_mbc5:
mapper_mbc5_rumble:
		dc.l	mapper_mbc5_0kb_ram
		dc.l	mapper_mbc5_0kb_ram
		dc.l	mapper_mbc5_0kb_ram
		dc.l	mapper_mbc5_0kb_ram
		dc.l	mapper_mbc5_0kb_ram

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		MBC5
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

mapper_mbc5_0kb_ram:
		dc.l	8-1,$1000-1
		dc.l	rom_write
		dc.l	rom_write
		dc.l	mbc5_romb0			;$3000.
		dc.l	mbc5_romb1			;$4000.
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write			;$8000.

mapper_mbc5_2kb_ram:
		dc.l	8-1,$1000-1
		dc.l	rom_write
		dc.l	rom_write
		dc.l	mbc5_romb0			;$3000.
		dc.l	mbc5_romb1			;$4000.
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write			;$8000.

mapper_mbc5_8kb_ram:
		dc.l	8-1,$1000-1
		dc.l	rom_write
		dc.l	rom_write
		dc.l	mbc5_romb0			;$3000.
		dc.l	mbc5_romb1			;$4000.
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write			;$8000.

mapper_mbc5_32kb_ram:
		dc.l	8-1,$1000-1
		dc.l	mbc5_ramg
		dc.l	mbc5_ramg			;$2000.
		dc.l	mbc5_romb0			;$3000.
		dc.l	mbc5_romb1			;$4000.
		dc.l	mbc5_ramb
		dc.l	mbc5_ramb			;$6000.
		dc.l	rom_write
		dc.l	rom_write			;$8000.

mapper_mbc5_128kb_ram:
		dc.l	8-1,$1000-1
		dc.l	mbc5_ramg
		dc.l	mbc5_ramg			;$2000.
		dc.l	mbc5_romb0			;$3000.
		dc.l	mbc5_romb1			;$4000.
		dc.l	mbc5_ramb
		dc.l	mbc5_ramb			;$6000.
		dc.l	rom_write
		dc.l	rom_write			;$8000.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		ROM+MBC3+RAM (+BATTERY)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

mapper_mbc3_timer_ram_battery:
mapper_mbc3_timer_battery:
mapper_mbc3:
mapper_mbc3_ram:
mapper_mbc3_ram_battery:
		dc.l	mapper_mbc3_0kb_ram
		dc.l	mapper_mbc3_2kb_ram
		dc.l	mapper_mbc3_8kb_ram
		dc.l	mapper_mbc3_32kb_ram

mapper_mbc3_0kb_ram:
		dc.l	4-1,$2000-1
		dc.l	mbc3_ram_protection
		dc.l	mbc3_rom_switch
		dc.l	rom_write
		dc.l	mbc3_latch_clock_counter_data

mapper_mbc3_2kb_ram:
		dc.l	4-1,$2000-1
		dc.l	mbc3_ram_protection
		dc.l	mbc3_rom_switch
		dc.l	rom_write
		dc.l	mbc3_latch_clock_counter_data

mapper_mbc3_8kb_ram:
		dc.l	4-1,$2000-1
		dc.l	mbc3_ram_protection
		dc.l	mbc3_rom_switch
		dc.l	rom_write
		dc.l	mbc3_latch_clock_counter_data

mapper_mbc3_32kb_ram:
		dc.l	4-1,$2000-1
		dc.l	mbc3_ram_protection
		dc.l	mbc3_rom_switch
		dc.l	mbc3_ram_switch_change_ram_bank
		dc.l	mbc3_latch_clock_counter_data

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		ROM ONLY
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

mapper_na:	dc.l	mapper_pure_rom
		dc.l	mapper_pure_rom
		dc.l	mapper_pure_rom
		dc.l	mapper_pure_rom

mapper_pure_rom:dc.l	6-1,$2000-1
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		ROM+MBC1
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

mapper_mbc1:	dc.l	mapper_mbc1_no_ram
		dc.l	mapper_mbc1_no_ram
		dc.l	mapper_mbc1_no_ram
		dc.l	mapper_mbc1_no_ram

mapper_mbc1_no_ram:
		dc.l	6-1,$2000-1
		dc.l	rom_write
		dc.l	mbc1_rom_switch
		dc.l	mbc1_rom_switch_two_address_lines
		dc.l	mbc1_rom_mode_select
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		ROM+MBC1+RAM (+BATTERY)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

mapper_mbc1_ram:
mapper_mbc1_ram_battery:
		dc.l	mapper_mbc1_0kb_ram
		dc.l	mapper_mbc1_2kb_ram
		dc.l	mapper_mbc1_8kb_ram
		dc.l	mapper_mbc1_32kb_ram

mapper_mbc1_0kb_ram:
		dc.l	6-1,$2000-1
		dc.l	rom_write
		dc.l	mbc1_rom_switch
		dc.l	mbc1_rom_switch_two_address_lines
		dc.l	mbc1_rom_mode_select
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr

mapper_mbc1_2kb_ram:
		dc.l	24-1,$800-1

		dc.l	mbc1_ram_protection
		dc.l	mbc1_ram_protection
		dc.l	mbc1_ram_protection
		dc.l	mbc1_ram_protection		;$2000.

		dc.l	mbc1_rom_switch
		dc.l	mbc1_rom_switch
		dc.l	mbc1_rom_switch
		dc.l	mbc1_rom_switch			;$4000.

		dc.l	mbc1_rom_switch_two_address_lines
		dc.l	mbc1_rom_switch_two_address_lines
		dc.l	mbc1_rom_switch_two_address_lines
		dc.l	mbc1_rom_switch_two_address_lines
							;$6000.
		dc.l	mbc1_rom_mode_select
		dc.l	mbc1_rom_mode_select
		dc.l	mbc1_rom_mode_select
		dc.l	mbc1_rom_mode_select		;$8000.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr			;$a000.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr			;$c000.

mapper_mbc1_8kb_ram:
		dc.l	4-1,$2000-1
		dc.l	mbc1_ram_protection
		dc.l	mbc1_rom_switch
		dc.l	mbc1_rom_switch_two_address_lines
		dc.l	mbc1_rom_mode_select

mapper_mbc1_32kb_ram:
		dc.l	4-1,$2000-1
		dc.l	mbc1_ram_protection
		dc.l	mbc1_rom_switch
		dc.l	mbc1_ram_switch_with_two_rom_address_lines
		dc.l	mbc1_rom_mode_select

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		ROM+MBC2 (+BATTERY)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

mapper_mbc2:
mapper_mbc2_battery:
		dc.l	mapper_mbc2_256b_ram
		dc.l	mapper_mbc2_256b_ram
		dc.l	mapper_mbc2_256b_ram
		dc.l	mapper_mbc2_256b_ram

mapper_mbc2_256b_ram:
		dc.l	192-1,$100-1
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write
		dc.l	mbc2_ram_protection
		dc.l	rom_write			;$2000.

		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch
		dc.l	rom_write
		dc.l	mbc2_rom_switch			;$4000.

		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write			;$6000.

		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write			;$8000.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr			;a000.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr			;$c000.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		ROM+RAM (+BATTERY)
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

mapper_ram:
mapper_ram_battery:
		dc.l	mapper_ram_0kb_ram
		dc.l	mapper_ram_2kb_ram
		dc.l	mapper_ram_8kb_ram
		dc.l	mapper_ram_8kb_ram		;illegal?

mapper_ram_0kb_ram:
		dc.l	6-1,$2000-1
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr

mapper_ram_2kb_ram:
		dc.l	24-1,$800-1

		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write			;$2000.

		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write			;$4000.

		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write			;$6000.

		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write			;$8000.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr			;$a000.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr			;$c000.

mapper_ram_8kb_ram:
		dc.l	4-1,$2000-1
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		output screen for gameboy
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gb_taglist:	dc.l	SA_Width,160
		dc.l	SA_Height,144
gb_taglist_x:	dc.l	SA_Left,0
gb_taglist_y:	dc.l	SA_Top,0
		dc.l	SA_Depth,4
		dc.l	SA_BlockPen,2
		dc.l	SA_DetailPen,1
		dc.l	SA_Pens,pens_empty
		dc.l	SA_Type,CUSTOMSCREEN
		dc.l	SA_AutoScroll,TRUE
		dc.l	SA_ShowTitle,FALSE
		dc.l	SA_Behind,TRUE
		dc.l	SA_Quiet,TRUE			;no title, no gadgets.
		dc.l	SA_Font,font_attr
gb_screen_id:	dc.l	SA_DisplayID,PAL_MONITOR_ID!LORES_KEY
							;default = pal.
		dc.l	SA_Draggable,TRUE
		dc.l	SA_VideoControl,video_tags	;v39 only.
		dc.l	SA_Interleaved,FALSE
		dc.l	SA_Overscan,OSCAN_STANDARD
		dc.l	TAG_END,0

video_tags:	dc.l	VTAG_BORDERBLANK_SET,TRUE
		dc.l	TAG_END,0

pens_empty:	dc.w	0,-1				;3d look, thanks!

gb_bplanes_I:	dc.l	0
gb_bplanes_II:	dc.l	0

gb_bmap_I:	dc.l	0
gb_bmap_II:	dc.l	0

gb_rport_I:	dc.l	0
gb_rport_II:	dc.l	0

gb_screen_ptr:	dc.l	0

gb_buffer_no:	dc.b	0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		game window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

wzonka_ptr:	dc.l	0
wzonka_window_x:dc.w	160
wzonka_window_y:dc.w	144
wzonka_game_x:	dc.l	0
wzonka_game_y:	dc.l	0
window_requested_width:dc.w	0
window_requested_height:dc.w	0
window_scale_capacity:
		dc.l	0

game_array:	dc.l	0
game_scale_array:
		dc.l	0
game_rast_port:	dc.l	0
game_tmp_rast_port:
		dc.l	0
game_tmp_map_attr:
		dc.l	0
game_output_tmp_rast_port:
		dc.l	0
game_output_tmp_map_attr:
		dc.l	0

wzonka_window:	dc.w	0
		dc.w	0
		dc.w	160
		dc.w	144
		dc.b	0
		dc.b	1
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	0
		dc.l	wzonka_title
		dc.l	0
		dc.l	0
		dc.w	160
		dc.w	144
		dc.w	window_max_game_x+8+window_right_bar_x
		dc.w	window_max_game_y+24
		dc.w	WBENCHSCREEN

wzonka_title:	dc.b	" ",0
		even

wzonka_window_title_txt:
		dc.b	"Gameboy "
wzonka_window_title_x:
		dc.b	"    "
		dc.b	"x"
wzonka_window_title_y:
		dc.b	"    ",0
		even

wzonka_window_screen_txt:
		dc.b	"Wzonka-Lad Game Window",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the frequency adder
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

freq_storage:	dc.l	0

freq_table:	dc.l	363				;(4096*4096)/(60*154*5).
		dc.l	23241				;(262144*4096)/(60*154*5).
		dc.l	5810				;(65536*4096)/(60*154*5).
		dc.l	1452				;(16384*4096)/(60*154*5).

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the copperlist base model
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

aga_copper:	dc.w	fmode,%1111			;64 bits wide bandwidth.
		dc.w	ddfstrt,$38			;$0
		dc.w	ddfstop,$38+(160+64-16)/2	;$40+(160-16)/2
		dc.w	diwstrt,$2cc1			;$2c81
		dc.w	diwstop,$bc61			;$100*($2c+144)+$21
		dc.w	bplcon0,%0000010000010000	;eight planes + dpf.
		dc.w	bpl1mod,40*7-8+16-8		;64 bit fix.
		dc.w	bpl2mod,40*7-8+16-8		;64 bit fix.
		dc.w	$1011,$fffe			;timing fix (vbr copier).
aga_scr_0:	dc.w	bplcon1,0			;plane shifting.
		dc.w	bplcon2,%1000100		;spr & dpf priorities.
		dc.w	bplcon3,$0000+Q
		dc.w	bplcon4,%00100011		;spr palettes.
aga_col:	dc.w	c0,$000,bplcon3,$200+Q,c0,$000,bplcon3,$0000+Q	;c0.
		dc.w	c1,$000,bplcon3,$200+Q,c1,$000,bplcon3,$0000+Q
		dc.w	c2,$000,bplcon3,$200+Q,c2,$000,bplcon3,$0000+Q
		dc.w	c3,$000,bplcon3,$200+Q,c3,$000,bplcon3,$0000+Q
		dc.w	c4,$000,bplcon3,$200+Q,c4,$000,bplcon3,$0000+Q	;c0.
		dc.w	c17,$000,bplcon3,$200+Q,c17,$000,bplcon3,$0000+Q
		dc.w	c18,$000,bplcon3,$200+Q,c18,$000,bplcon3,$0000+Q
		dc.w	c19,$000,bplcon3,$200+Q,c19,$000,bplcon3,$0000+Q
		dc.w	c4,$000,bplcon3,$200+Q,c4,$000,bplcon3,$0000+Q	;c0.
		dc.w	c20,$000,bplcon3,$200+Q,c20,$000,bplcon3,$0000+Q
		dc.w	c24,$000,bplcon3,$200+Q,c24,$000,bplcon3,$0000+Q
		dc.w	c28,$000,bplcon3,$200+Q,c28,$000,bplcon3,$2000+Q
spr_col:	dc.w	c19,$000,bplcon3,$2200+Q,c19,$000,bplcon3,$2000+Q
		dc.w	c1,$000,bplcon3,$2200+Q,c1,$000,bplcon3,$2000+Q
		dc.w	c2,$000,bplcon3,$2200+Q,c2,$000,bplcon3,$2000+Q
		dc.w	c3,$000,bplcon3,$2200+Q,c3,$000,bplcon3,$2000+Q
		dc.w	c23,$000,bplcon3,$2200+Q,c23,$000,bplcon3,$2000+Q
		dc.w	c5,$000,bplcon3,$2200+Q,c5,$000,bplcon3,$2000+Q
		dc.w	c6,$000,bplcon3,$2200+Q,c6,$000,bplcon3,$2000+Q
		dc.w	c7,$000,bplcon3,$2200+Q,c7,$000,bplcon3,$2000+Q
		dc.w	c27,$000,bplcon3,$2200+Q,c27,$000,bplcon3,$2000+Q
		dc.w	c9,$000,bplcon3,$2200+Q,c9,$000,bplcon3,$2000+Q
		dc.w	c10,$000,bplcon3,$2200+Q,c10,$000,bplcon3,$2000+Q
		dc.w	c11,$000,bplcon3,$2200+Q,c11,$000,bplcon3,$2000+Q
		dc.w	c31,$000,bplcon3,$2200+Q,c31,$000,bplcon3,$2000+Q
		dc.w	c13,$000,bplcon3,$2200+Q,c13,$000,bplcon3,$2000+Q
		dc.w	c14,$000,bplcon3,$2200+Q,c14,$000,bplcon3,$2000+Q
		dc.w	c15,$000,bplcon3,$2200+Q,c15,$000,bplcon3,$0000+Q
aga_sprites:	dc.w	spr0pth,0,spr0ptl,0
		dc.w	spr2pth,0,spr2ptl,0
		dc.w	spr4pth,0,spr4ptl,0
		dc.w	spr6pth,0,spr6ptl,0
		dc.w	spr1pth,0,spr1ptl,0
		dc.w	spr3pth,0,spr3ptl,0
		dc.w	spr5pth,0,spr5ptl,0
		dc.w	spr7pth,0,spr7ptl,0
		dc.w	$2a11,$fffe
aga_planes:	dc.w	bpl1pth,0,bpl1ptl,0
		dc.w	bpl3pth,0,bpl3ptl,0
		dc.w	bpl5pth,0,bpl5ptl,0
		dc.w	bpl7pth,0,bpl7ptl,0
		dc.w	bpl2pth,0,bpl2ptl,0
		dc.w	bpl4pth,0,bpl4ptl,0
		dc.w	bpl6pth,0,bpl6ptl,0
		dc.w	bpl8pth,0,bpl8ptl,0
aga_scr_x:	

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		value get tag lists for gadgets
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_mx_attr:	dc.l	GTMX_Active,mx_attr_value
		dc.l	TAG_END,0
mx_attr_value:	dc.l	0

get_checkbox_attr:
		dc.l	GTCB_Checked,checkbox_status
		dc.l	TAG_END,0
checkbox_status:dc.l	0

get_slider_attr:dc.l	GTSL_Level,slider_attr_value
		dc.l	TAG_END,0
slider_attr_value:
		dc.l	0

get_listview_attr:dc.l	GTLV_Selected,listview_attr_value
		dc.l	TAG_END,0
listview_attr_value:
		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		sound variables
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFEQ	GAMEBOY_USERS
freq_s_I:	dc.l	0
freq_s_I_ctrl:	dc.w	0
		dc.b	0
freq_s_I_ctrl_x:dc.b	0

sound_V:	dc.b	0
sound_V_b:	dc.b	0
		dc.w	0

pan_table:	dc.l	0
		dc.l	0
		dc.l	$10000
		dc.l	$10000/2

onf_table:	dc.b	1					;off.
		dc.b	0					;on (left).
		dc.b	0					;   (right).
		dc.b	0					;   (both).

sound_so_list:	dc.l	0					;off.
sound_so_1:	dc.w	0					;so 1.
		dc.b	0
sound_so_1x:	dc.b	0
sound_so_2:	dc.w	0					;so 2.
		dc.b	0
sound_so_2x:	dc.b	0
sound_so_mix:	dc.w	0					;(so 1+so 2)/2.
		dc.b	0
sound_so_mixx:	dc.b	0

sound_I_v_envelope:
		dc.b	0
sound_I_f_envelope:
		dc.b	0
sound_II_v_envelope:
		dc.b	0
sound_IV_v_envelope:
		dc.b	0
sound_I_v_envelope_initial_volume:
		dc.b	0
sound_II_v_envelope_initial_volume:
		dc.b	0
sound_IV_v_envelope_initial_volume:
		dc.b	0

		even

sound_I_f_envelope_counter_base:
		dc.l	0
sound_I_f_envelope_counter:
		dc.l	0
sound_I_f_initial_frequency:
		dc.l	0

sound_I_v_envelope_counter_base:
		dc.l	0
sound_I_v_envelope_counter:
		dc.l	0
sound_II_v_envelope_counter_base:
		dc.l	0
sound_II_v_envelope_counter:
		dc.l	0
sound_IV_v_envelope_counter_base:
		dc.l	0
sound_IV_v_envelope_counter:
		dc.l	0

sound_length_div:	dc.b	36
sound_guest_only:	dc.b	0
sound_I_length:	dc.b	0
sound_II_length:	dc.b	0
sound_IV_length:	dc.b	0
		even
sound_III_length:	dc.w	0

		IFEQ	Z80_MODE
sound_div_counter: dc.w	0
sound_frame_phase: dc.b	0
sound_div_active: dc.b	0
z80_irq_cycles:	dc.b	0
		even
sound_div_budget: dc.l	0
sound_slice_tail: dc.l	0
z80_slice_debt:	dc.l	0
timer_bit:	dc.w	0
timer_mask:	dc.w	0
timer_shift:	dc.b	0
timer_phase:	dc.b	0			;0 = counting, 1 = overflow, 2 = reload.
sound_sweep_timer: dc.b	0
sound_sweep_negated: dc.b	0
sound_wave_time: dc.l	$40000000
sound_wave_next: dc.l	0
sound_wave_period: dc.l	4096
sound_wave_index: dc.b	0
		even
		ENDIF

sound_I_status:	
sound_I_onf:	dc.b	0
sound_I_onf_vin:dc.b	0
sound_I_onf_master:
		dc.b	0
sound_I_onf_kick:
		dc.b	0

sound_II_status:
sound_II_onf:	dc.b	0
sound_II_onf_vin:
		dc.b	0
sound_II_onf_master:
		dc.b	0
sound_II_onf_kick:
		dc.b	0

sound_III_status:
sound_III_onf:	dc.b	0
sound_III_onf_bit:
		dc.b	0
sound_III_onf_master:
		dc.b	0
sound_III_onf_vin:
		dc.b	0

sound_IV_status:
sound_IV_onf:	dc.b	0
sound_IV_onf_vin:
		dc.b	0
sound_IV_onf_master:
		dc.b	0
sound_IV_onf_kick:
		dc.b	0

old_sound_I_duty:
		dc.b	0
old_sound_II_duty:
		dc.b	0
old_sound_IV_width:
		dc.b	0
		dc.b	0

sound_I_pan:	dc.l	0
sound_II_pan:	dc.l	0
sound_III_pan:	dc.l	0
sound_IV_pan:	dc.l	0

sound_I_gain:	dc.l	0
sound_II_gain:	dc.l	0
sound_III_gain:	dc.l	0
sound_IV_gain:	dc.l	0
sound_I_rate:	dc.l	0
sound_II_rate:	dc.l	0

sound_I_boost:	dc.l	0
sound_II_boost:	dc.l	0
sound_III_boost:dc.l	0
sound_IV_boost:	dc.l	0

sound_III_vol:	dc.l	0
		dc.l	$10000-2
		dc.l	$10000/2
		dc.l	$10000/4

sound_env_volumes:
		dc.l	0
		dc.l	(($10000/15)*1)-2
		dc.l	(($10000/15)*2)-2
		dc.l	(($10000/15)*3)-2
		dc.l	(($10000/15)*4)-2
		dc.l	(($10000/15)*5)-2
		dc.l	(($10000/15)*6)-2
		dc.l	(($10000/15)*7)-2
		dc.l	(($10000/15)*8)-2
		dc.l	(($10000/15)*9)-2
		dc.l	(($10000/15)*10)-2
		dc.l	(($10000/15)*11)-2
		dc.l	(($10000/15)*12)-2
		dc.l	(($10000/15)*13)-2
		dc.l	(($10000/15)*14)-2
		dc.l	(($10000/15)*15)-2

sound_III_lst:	dc.l	0
sound_raw_regs:	ds.b	$26-$10
		even

sound_III_f:	dc.w	0
sound_III_fh:	dc.b	0
sound_III_fl:	dc.b	0

sound_I_v:	dc.l	0
sound_II_v:	dc.l	0
sound_III_v:	dc.l	0
sound_IV_v:	dc.l	0

sound_I_f:	dc.w	0
sound_I_fh:	dc.b	0
sound_I_fl:	dc.b	0

sound_II_f:	dc.w	0
sound_II_fh:	dc.b	0
sound_II_fl:	dc.b	0

env_chnl_I:	dc.w	0
		dc.b	0
env_chnl_I_x:	dc.b	0

sound_II_ven:	dc.l	0
sound_II_ven_con:
		dc.l	0
sound_II_ven_all:
		dc.l	0

env_chnl_II:	dc.w	0
		dc.b	0
env_chnl_II_x:	dc.b	0

sound_IV_ven:	dc.l	0
sound_IV_ven_con:
		dc.l	0
sound_IV_ven_all:
		dc.l	0

env_chnl_IV:	dc.w	0
		dc.b	0
env_chnl_IV_x:	dc.b	0

enve_sweep_tbl:	dc.l	0
		dc.l	$8000/15-2+$8000
		dc.l	$8000/14-2+$8000
		dc.l	$8000/13-2+$8000
		dc.l	$8000/12-2+$8000
		dc.l	$8000/11-2+$8000
		dc.l	$8000/10-2+$8000
		dc.l	$8000/9-2+$8000
		dc.l	$8000/8-2+$8000
		dc.l	$8000/7-2+$8000
		dc.l	$8000/6-2+$8000
		dc.l	$8000/5-2+$8000
		dc.l	$8000/4-2+$8000
		dc.l	$8000/3-2+$8000
		dc.l	$8000/2-2+$8000
		dc.l	$8000-2+$8000

enve_sweep_val:	dc.l	0
		dc.l	(256*1)/60
		dc.l	(256*3)/60
		dc.l	(256*5)/60
		dc.l	(256*7)/60
		dc.l	(256*9)/60
		dc.l	(256*11)/60
		dc.l	(256*13)/60

sound_4_freq_table:
		dc.l	524288
		dc.l	262144
		dc.l	262144/2
		dc.l	262144/3
		dc.l	262144/4
		dc.l	262144/5
		dc.l	262144/6
		dc.l	262144/7
		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		$ffxx memory jump table
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

ffxx_jmp_table:	dc.l	do_joystick
		dc.l	sio_register
		dc.l	sio_control
		dc.l	no_write				;$03.
		dc.l	clear_divider
		IFEQ	Z80_MODE
		dc.l	timer_write_count
		dc.l	timer_write_modulo
		ELSE
		dc.l	gb_mem_wr,gb_mem_wr
		ENDIF
		dc.l	timc_protect
		dc.l	no_write,no_write,no_write,no_write	;$08-$0b.
		dc.l	no_write,no_write,no_write		;$0c-$0e.
		dc.l	irq_protect_0f				;$0f.

		IFEQ	GAMEBOY_USERS
		dc.l	sound_guest_write,sound_guest_write,sound_guest_write,sound_guest_write,sound_guest_write
		dc.l	no_write				;$15.
		dc.l	sound_guest_write,sound_guest_write,sound_guest_write,sound_guest_write
		dc.l	sound_guest_write,sound_guest_write,sound_guest_write,sound_guest_write,sound_guest_write
		dc.l	no_write				;$1f.
		dc.l	sound_guest_write,sound_guest_write,sound_guest_write,sound_guest_write
		dc.l	sound_guest_write,sound_guest_write,sound_guest_write
		ELSE
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	no_write				;$15.
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	no_write				;$1f.

		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		ENDIF
		dc.l	no_write				;$27.
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write				;$2f.

		IFEQ	GAMEBOY_USERS
		IFEQ	Z80_MODE
		dc.l	sound_wave_write,sound_wave_write,sound_wave_write,sound_wave_write
		dc.l	sound_wave_write,sound_wave_write,sound_wave_write,sound_wave_write
		dc.l	sound_wave_write,sound_wave_write,sound_wave_write,sound_wave_write
		dc.l	sound_wave_write,sound_wave_write,sound_wave_write,sound_wave_write
		ELSE
		dc.l	gb_mem_wr,gb_mem_wr,gb_mem_wr,gb_mem_wr
		dc.l	gb_mem_wr,gb_mem_wr,gb_mem_wr,gb_mem_wr
		dc.l	gb_mem_wr,gb_mem_wr,gb_mem_wr,gb_mem_wr
		dc.l	gb_mem_wr,gb_mem_wr,gb_mem_wr,gb_mem_wr
		ENDIF
		ELSE
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write
		dc.l	rom_write				;$3f.
		ENDIF

;		dc.l	sound_I_0
;		dc.l	sound_I_1
;		dc.l	sound_I_2
;		dc.l	sound_I_3
;		dc.l	sound_I_4
;		dc.l	gb_mem_wr
;		dc.l	sound_II_1
;		dc.l	sound_II_2
;		dc.l	sound_II_3
;		dc.l	sound_II_4
;		dc.l	sound_III_0
;		dc.l	sound_III_1
;		dc.l	sound_III_2
;		dc.l	sound_III_3
;		dc.l	sound_III_4
;		dc.l	gb_mem_wr				;$1f.

;		dc.l	sound_IV_1
;		dc.l	sound_IV_2
;		dc.l	sound_IV_3
;		dc.l	sound_IV_4
;		dc.l	sound_V_0
;		dc.l	sound_V_1
;		dc.l	sound_V_2
;		dc.l	gb_mem_wr
;		dc.l	gb_mem_wr
;		dc.l	gb_mem_wr
;		dc.l	gb_mem_wr
;		dc.l	gb_mem_wr
;		dc.l	gb_mem_wr
;		dc.l	gb_mem_wr
;		dc.l	gb_mem_wr
;		dc.l	gb_mem_wr				;$2f.

;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data
;		dc.l	copy_snd_data				;$3f.

		dc.l	lcd_mode_write
		dc.l	lcd_protect
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	ly_write
		dc.l	lyc_write
		dc.l	dma_execute
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write				;$4f.

		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write				;$5f.

		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write				;$6f.

		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write
		dc.l	no_write				;$7f.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr				;$8f.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr				;$9f.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr				;$af.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr				;$bf.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr				;$cf.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr				;$df.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr				;$ef.

		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	gb_mem_wr
		dc.l	irq_protect_ff				;$ff.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		memory lists
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

list_default:	dc.l	0
list_aga:	dc.l	0
list_screen:	dc.l	0
list_window:	dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the memory allocation lists
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

list_default_structure:

		IFGT	GAMEBOY_SERIAL

		dc.l	io_buffer_in,64,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	io_buffer_out,64,MEMF_PUBLIC!MEMF_CLEAR

		ENDIF

		dc.l	info_map_attr,bm_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	about_map_attr,bm_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	back_pattern_map_attr,bm_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	back_pattern_map,function_x/8*function_y*2,MEMF_CHIP!MEMF_CLEAR
		dc.l	info_map,function_x/8*function_y*8,MEMF_CHIP!MEMF_CLEAR
		dc.l	about_map,function_x/8*function_y*8,MEMF_CHIP!MEMF_CLEAR

		dc.l	univ_gadget,gng_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		IFEQ	Z80_MODE
		dc.l	gb_memory,$10002,MEMF_PUBLIC!MEMF_CLEAR
		ELSE
		dc.l	gb_memory,$10000,MEMF_PUBLIC!MEMF_CLEAR
		ENDIF
		dc.l	memory_banks,131072+XPK_MARGIN+$2000,MEMF_PUBLIC
		dc.l	x_flip_table,$10000*2,MEMF_PUBLIC
		dc.l	spr_col_table,64*256*4,MEMF_PUBLIC
		dc.l	snapshot_area,$2000*16+$8000+1024+XPK_MARGIN,MEMF_PUBLIC
		dc.l	gb_mem_jumps,$10000*4,MEMF_PUBLIC

		dc.l	name_ptr,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	dir_n_name_ptr,256*2,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	def_dir,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	def_ss_dir,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	file_info_ptr,fib_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	xpk_names,1024,MEMF_PUBLIC!MEMF_CLEAR

		IFEQ	GAMEBOY_USERS
		dc.l	key_file,1024,MEMF_PUBLIC
		dc.l	ahi_mode_txt,128,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	smpl_mem_1,8*512,MEMF_PUBLIC
		dc.l	smpl_mem_2,8*512,MEMF_PUBLIC
		dc.l	smpl_mem_3,8*512,MEMF_PUBLIC
		dc.l	smpl_mem_4,8*512,MEMF_PUBLIC
		dc.l	smpl_III_mem,32,MEMF_PUBLIC
		dc.l	smpl_IV_mem,32768,MEMF_PUBLIC
		dc.l	smpl_IV_short,128,MEMF_PUBLIC
		dc.l	sound_III_lst,256*2,MEMF_PUBLIC
		dc.l	smpl_info_I,AHISampleInfo_SIZEOF,MEMF_PUBLIC
		dc.l	smpl_info_II,AHISampleInfo_SIZEOF,MEMF_PUBLIC
		dc.l	smpl_info_III,AHISampleInfo_SIZEOF,MEMF_PUBLIC
		dc.l	smpl_info_IV,AHISampleInfo_SIZEOF,MEMF_PUBLIC
		ENDIF

		dc.l	joy_names_list,(LN_SIZE+2)*6,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	prefs_file,2048,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	prefs_file_rom,128,MEMF_PUBLIC
		dc.l	joy_label_list,LH_SIZE,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	xpk_label_list,LH_SIZE,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	gg_label_list,LH_SIZE,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	gg_dummy_item,LN_SIZE+2,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	colour_message,MN_SIZE+8*3,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	colour_message_name,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	menu_favo_nf,32*20,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	gfx_game_still_array,((((304+15)/16)*16)*(39+1)),MEMF_PUBLIC
		dc.l	gfx_game_still_tmp_array,((((304+15)/16)*16)*(39+1)),MEMF_PUBLIC
		dc.l	gfx_game_still_rast_port,rp_SIZEOF,MEMF_PUBLIC
		dc.l	gfx_game_still_tmp_rast_port,rp_SIZEOF,MEMF_PUBLIC
		dc.l	gfx_game_still_map_attr,bm_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	keyboard_io,IOSTD_SIZE,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	keyboard_matrix,16,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	prefs_str_1,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	prefs_str_2,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	prefs_str_3,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	prefs_str_4,256,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	aga_sprs_cI,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	aga_sprs_cII,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	aga_sprs_cxI,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	aga_sprs_cxII,256,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	context_g_menu,gg_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	context_g_sfx,gg_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	context_g_prefs,gg_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	context_g_gfx,gg_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	context_g_misc,gg_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	misc_str_1,32,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	misc_str_2,32,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	misc_str_3,32,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	dimension_info,dim_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	0

list_aga_structure:
		dc.l	copper_I,8192,MEMF_CHIP!MEMF_CLEAR
		dc.l	aga_map_I,320/8*256*8,MEMF_CHIP!MEMF_CLEAR
		dc.l	aga_map_II,320/8*256*8,MEMF_CHIP!MEMF_CLEAR
		dc.l	aga_col_bg,2*2*4*256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	aga_col_sprs,2*2*4*256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	aga_ro_list_I,256,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	aga_ro_list_II,256,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	aga_spr_Ia,sprite_memory,MEMF_CHIP!MEMF_CLEAR
		dc.l	aga_spr_IIa,sprite_memory,MEMF_CHIP!MEMF_CLEAR
		dc.l	aga_spr_IIIa,sprite_memory,MEMF_CHIP!MEMF_CLEAR
		dc.l	aga_spr_Ib,sprite_memory,MEMF_CHIP!MEMF_CLEAR
		dc.l	aga_spr_IIb,sprite_memory,MEMF_CHIP!MEMF_CLEAR
		dc.l	aga_spr_IIIb,sprite_memory,MEMF_CHIP!MEMF_CLEAR
		dc.l	aga_spr_Ix,sprite_memory,MEMF_CHIP!MEMF_CLEAR
		dc.l	aga_spr_IIx,sprite_memory,MEMF_CHIP!MEMF_CLEAR
		dc.l	aga_spr_IIIx,sprite_memory,MEMF_CHIP!MEMF_CLEAR
		dc.l	aga_spr_empty,sprite_memory,MEMF_CHIP!MEMF_CLEAR

		dc.l	0

list_screen_structure:
		dc.l	gb_rport_I,rp_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	gb_rport_II,rp_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	gb_bmap_I,bm_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	gb_bmap_II,bm_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
screen_chip_1:	dc.l	gb_bplanes_I,gb_screen_x/8*gb_screen_y*4,MEMF_CHIP
screen_chip_2:	dc.l	gb_bplanes_II,gb_screen_x/8*gb_screen_y*4,MEMF_CHIP

		dc.l	game_tmp_rast_port,rp_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	game_array,((((160+15)/16)*16)*(144+1)),MEMF_PUBLIC

		dc.l	0

list_window_structure:
		dc.l	wzonka_map_attr,bm_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
window_chip_1:	dc.l	wzonka_map,gb_screen_x/8*gb_screen_y*4,MEMF_CHIP!MEMF_CLEAR

		dc.l	game_rast_port,rp_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	game_tmp_rast_port,rp_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR
		dc.l	game_output_tmp_rast_port,rp_SIZEOF,MEMF_PUBLIC!MEMF_CLEAR

		dc.l	game_array,((((160+15)/16)*16)*(144+1)),MEMF_PUBLIC

		dc.l	pen_conversion_table,$1616*2,MEMF_PUBLIC
		dc.l	window_scale_table,window_max_game_x,MEMF_PUBLIC	;X offsets or 1 KiB pen pairs.

		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		universal window values
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

window_bars_height:
		dc.l	0
window_bars_width:
		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		status texts
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

old_status_text:dc.l	0

emulator_status_text:
		dc.b	0
		dc.b	0
		dc.b	0
		dc.b	0
		dc.w	0				;x is computed.
		dc.w	83+7
		dc.l	font_attr
emulator_status_txt:
		dc.l	0
		dc.l	0

status_waiting_txt:
		dc.b	"> Load a ROM <",0
		even
status_rom_loaded_txt:
		dc.b	"> ROM loaded <",0
		even
status_rom_reset_txt:
		dc.b	"> ROM reset <",0
		even
status_gbs_loaded_txt:
		dc.b	"> RAM snapshot loaded <",0
		even
status_running_txt:
		dc.b	"> Executing ROM <",0
		even
status_paused_txt:
		dc.b	"> Emulation paused <",0
		even
status_file_not_found_txt:
		dc.b	"> File not found <",0
		even
status_xpk_error_txt:
		dc.b	"> XPK error <",0
		even
status_not_enough_memory_txt:
		dc.b	"> Not enough memory <",0
		even
status_too_big_a_file_txt:
		dc.b	"> Too big a file <",0
		even
status_xpk_pack_txt:
		dc.b	"> XPK ("
status_xpk_name_txt:
		dc.b	"NNNN) packing <",0
		even
status_xpk_unpack_txt:
		dc.b	"> XPK ("
status_xpk_name_u_txt:
		dc.b	"NNNN) unpacking <",0
		even
status_file_saved_txt:
		dc.b	"> Data saved <",0
		even
status_file_saved_error_txt:
		dc.b	"> Error in data saving <",0
		even
status_invalid_patch_txt:
		dc.b	"> Invalid GameGenie patch code <",0
		even
status_patch_none_txt:
		dc.b	"> Patch doesn't apply to this ROM <",0
		even
status_rom_patched_txt:
		dc.b	"> ROM patched <",0
		even
status_no_rom_txt:
		dc.b	"> No ROM to patch <",0
		even
status_corrupted_rom_txt:
		dc.b	"> Corrupted ROM file <",0
		even
status_cant_open_window_txt:
		dc.b	"> Can't open auxiliary window <",0
		even
status_unknown_rom_size_txt:
		dc.b	"> Unknown ROM size <",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		gamegenie
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gg_patch:	dc.b	"PATCHME!!"
		even

gg_list:	dc.l	0
gg_list_size:	dc.l	0
gg_linked_list:	dc.l	0
gg_linked_list_last_item:
		dc.l	0

gg_list_name:	dc.b	"PROGDIR:game_genie/game_genie.list",0
		even

gg_dummy_item_txt:
		dc.b	"None",0
		even

gg_dummy_item_register_txt:
		dc.b	"Register Wzonka-Lad!",0
		even

gg_rom_name:	dc.l	0

gg_register_1_txt:
		dc.b	"REG",0
		even

gg_register_2_txt:
		dc.b	"IST",0
		even

gg_register_3_txt:
		dc.b	"ER!",0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		ntsc/pal screen
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

block_screen_taglist:
		dc.l	SA_Width,160
		dc.l	SA_Height,144
		dc.l	SA_Depth,1
		dc.l	SA_BlockPen,1
		dc.l	SA_DetailPen,0
		dc.l	SA_Type,PUBLICSCREEN
		dc.l	SA_AutoScroll,FALSE
		dc.l	SA_ShowTitle,FALSE
		dc.l	SA_Behind,FALSE
		dc.l	SA_Quiet,TRUE
block_screen_id:dc.l	SA_DisplayID,PAL_MONITOR_ID!LORES_KEY
		dc.l	SA_Draggable,FALSE
		dc.l	SA_Interleaved,FALSE
		dc.l	TAG_END,0

block_screen_ptr:
		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		unsorted byte values
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

old_render:	dc.b	0
old_refresh:	dc.b	0
scaling_status:	dc.b	0
refresh_scanline:
		dc.b	0
sfx_volume_value:
		dc.b	0
aga_mode:	dc.b	0
pck_xpk_status:	dc.b	0
pck_method_number:
		dc.b	0
battery_status:	dc.b	0
battery_xpk_status:
		dc.b	0
keystick:	dc.b	0
sfx_y_update:	dc.b	0

old_led:	dc.b	0
back_ground_colour_byte:
		dc.b	0
gfx_values_need_update:
		dc.b	0

		IFEQ	GAMEBOY_USERS
key_status:	dc.b	0
key_size:	dc.l	0
sfx_y_actual_value:
		dc.l	0
sfx_y_adder:	dc.l	0
		ENDIF

cartridge_status:
		dc.b	0
cli_or_wb:	dc.b	0
load_or_reset:	dc.b	0

forbid_permit_status:
		dc.b	0
os_screen_speed_limit:
		dc.b	0
fast_ram_bitmaps:
		dc.b	0
window_direct_readback:
		dc.b	0

obtain_status_counter:
		dc.b	4
colour_load_status:
		dc.b	0

rom_type:	dc.b	0

irq_status_flags:
		dc.b	0
transfer_counter:
		dc.b	0

misc_b_code_list_selected:
		dc.b	0
gg_code_status:	dc.b	0
		even

four_ram_banks_from_gbs:
		dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		debug
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFGT	GAMEBOY_DEBUG

debug_consol_name:
;		dc.b	"CON:0/11/640/200/Wzonka-Lad Debug",0
		dc.b	"T:Wzonka-Lad.DEBUG",0
		even

debug_exit:	dc.b	0
rom_bank_activated:
		dc.b	0
ram_bank_activated:
		dc.b	0
		even

debug_con_handle:
		dc.l	0

gbz80_de:	dc.w	0
gbz80_bc:	dc.w	0
gbz80_hl:	dc.w	0
gbz80_fa:	dc.w	0

debug_message:	dc.b	"AF="
debug_af:	dc.b	"nnnn "
		dc.b	"BC="
debug_bc:	dc.b	"nnnn "
		dc.b	"DE="
debug_de:	dc.b	"nnnn "
		dc.b	"HL="
debug_hl:	dc.b	"nnnn "
		dc.b	"PC="
debug_pc:	dc.b	"nnnn "
		dc.b	"SP="
debug_sp:	dc.b	"nnnn "
		dc.b	"CL="
debug_cycles:	dc.b	"nnnn "
		dc.b	"OC="
debug_oc:	dc.b	"nn   "
debug_flags:	dc.b	"-----",$a			;znhci.
debug_command:	dc.b	"                "
		dc.b	" x="
debug_next_1:	dc.b	"nn   "
		dc.b	"xx="
debug_next_2:	dc.b	"nnnn "
		dc.b	"OB="
debug_rom_bank:	dc.b	"nn   "
		dc.b	"AB="
debug_ram_bank:	dc.b	"nn   ",$a
debug_message_end:
		even

		ds.b	256

debug_scanline_message:
		dc.b	"*** NEXT SCANLINE: "
debug_scanline:	dc.b	"nnnn",$a
debug_scanline_message_end:
		even

debug_vbr_txt:	dc.b	"*** VBR IRQ",$a
debug_vbr_txt_end:
		even

debug_lcd_txt:	dc.b	"*** LCD STATE IRQ",$a
debug_lcd_txt_end:
		even

debug_p10_txt:	dc.b	"*** P10 IRQ",$a
debug_p10_txt_end:
		even

debug_timer_txt:dc.b	"*** TIMER IRQ",$a
debug_timer_txt_end:
		even

debug_blank_txt:dc.b	"*** LCD LINE CMP IRQ",$a
debug_blank_txt_end:
		even

debug_joy_txt:	dc.b	"*** -> $FF00: "
debug_joy:	dc.b	"nn",$a
debug_joy_txt_end:
		even

		include	"debug_optcode_list.i"

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		poitner tags
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

pause_pointer_tags:
		dc.l	WA_Pointer, 0
		dc.l	WA_BusyPointer, TRUE
		dc.l	TAG_END,0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		serial data
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFGT	GAMEBOY_SERIAL

serial_device_name:
		dc.b	"8n1.device",0
		even

io_request_in:	dc.l	0
io_request_out:	dc.l	0
io_buffer_in:	dc.l	0
io_buffer_out:	dc.l	0

input_message_port:
		dc.l	0
output_message_port:
		dc.l	0

serial_device_status:
		dc.b	0
		even

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		EI
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

z80_cycles_left:dc.l	0
z80_ei_return:	dc.b	0				;1 = delayed EI, 2 = cancelled, 3 = IF/IE write.
z80_halt_bug:	dc.b	0
		even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		section	displayable_images,data_c
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gfx_game_still_map:
		incbin	"data/gfx_game_still_map.bn"
		even

		END
