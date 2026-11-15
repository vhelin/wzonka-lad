
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		wzonka-lad the emulator - sega pad tester
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		incdir	"binworld:includes/"
		include	"exec/memory.i"
		include	"dos/dos.i"
		include	"exec_lib.i"
		include	"dos_lib.i"
		include	"controlpad.i"

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		section	juures,code
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gb_emu:		movem.l	d2-d7/a2-a6,-(SP)		;stack!
		move.l	execbase,exec_base		;cache it locally.

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

		lea	low_level_name,a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		move.l	d0,low_level_base

		lea	control_pad_name,a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		move.l	d0,control_pad_base

		lea	xpk_master_name,a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		move.l	d0,xpk_master_base

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate controller port for sega if needed
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	control_pad_base,d0
		beq.s	no_sc_alloc

		move.l	d0,a6
		move.b	#CPU_JOYPORT,d0			;joyport only.
		jsr	cpAlloc(a6)			;allocate the port.
		move.l	d0,muna

		move.b	#CPU_JOYPORT,d0
		move.l	muna,a0
		jsr	cpGet(a6)

		move.b	#CPU_JOYPORT,d0
		move.l	muna,a0
		jsr	cpGet(a6)

		move.b	#CPU_JOYPORT,d0
		move.l	muna,a0
		jsr	cpGet(a6)

		move.b	#CPU_JOYPORT,d0
		move.l	muna,a0
		jsr	cpGet(a6)

		move.b	#CPU_JOYPORT,d0
		move.l	muna,a0
		jsr	cpGet(a6)

		move.b	#CPU_JOYPORT,d0
		move.l	muna,a0
		jsr	cpGet(a6)

		move.b	#CPU_JOYPORT,d0
		move.l	muna,a0
		jsr	cpGet(a6)

no_sc_alloc:	





quit:		move.l	exec_base,a6
		move.l	xpk_master_base,d1
		beq.s	no_xpk_master			;no xpk master library open.
		move.l	d1,a1
		jsr	CloseLibrary(a6)

no_xpk_master:	move.l	low_level_base,d1
		beq.s	no_low_level			;no low level library open.
		move.l	d1,a1
		jsr	CloseLibrary(a6)

no_low_level:	move.l	control_pad_base,d1
		beq.s	no_control_pad
		move.l	d1,a1
		jsr	CloseLibrary(a6)

no_control_pad:	move.l	req_tools_base,d1
		beq.s	no_req_tools
		move.l	d1,a1
		jsr	CloseLibrary(a6)

no_req_tools:	move.l	graphics_base,d1
		beq.s	no_gfx_base
		move.l	d1,a1
		jsr	CloseLibrary(a6)

no_gfx_base:	move.l	dos_base,d1
		beq.s	no_dos_base
		move.l	d1,a1
		jsr	CloseLibrary(a6)

no_dos_base:	move.l	disk_font_base,d1
		beq.s	no_font_base
		move.l	d1,a1
		jsr	CloseLibrary(a6)

no_font_base:	movem.l	(SP)+,d2-d7/a2-a6		;unstack!
		moveq.l	#0,d0				;no errors.
		rts

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
xpk_master_name:dc.b	"xpkmaster.library",0
		even

exec_base:	dc.l	0
intuition_base:	dc.l	0
graphics_base:	dc.l	0
dos_base:	dc.l	0
disk_font_base:	dc.l	0
low_level_base:	dc.l	0
control_pad_base:
		dc.l	0
req_tools_base:	dc.l	0
xpk_master_base:dc.l	0

muna:		dc.l	0

		END
