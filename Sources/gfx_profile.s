		include	"devices/timer.i"
		include	"lvo/timer_lib.i"

; dos/dos_lib.i only declares the older DOS entry points.
		IFND	_LVOVFPrintf
_LVOVFPrintf	equ	-354
		ENDC

gfx_profile_open:
		move.l	exec_base,a6
		jsr	CreateMsgPort(a6)
		move.l	d0,gfx_profile_port
		beq.s	gfx_profile_open_failed
		move.l	d0,a0
		moveq.l	#IOTV_SIZE,d0
		jsr	CreateIORequest(a6)
		move.l	d0,gfx_profile_io
		beq.s	gfx_profile_open_failed
		move.l	d0,a1
		lea	gfx_profile_timer,a0
		moveq.l	#UNIT_ECLOCK,d0
		moveq.l	#0,d1
		jsr	OpenDevice(a6)
		tst.l	d0
		bne.s	gfx_profile_open_failed
		move.l	gfx_profile_io,a0
		move.l	IO_DEVICE(a0),gfx_profile_base
		move.l	gfx_profile_base,a6
		lea	gfx_profile_clock,a0
		jsr	_LVOReadEClock(a6)
		move.l	d0,gfx_profile_rate
		beq.s	gfx_profile_open_failed

		moveq.l	#0,d0
		move.b	old_render,d0
		move.l	d0,gfx_profile_driver
		move.b	old_refresh,d0
		move.l	d0,gfx_profile_refresh
		move.l	wzonka_game_x,gfx_profile_width
		move.l	wzonka_game_y,gfx_profile_height
		moveq.l	#0,d0
		cmp.b	#2,old_render
		bne.s	gfx_profile_read_mode_ready
		IFNE	GFX_COMPARE_READBACK
		moveq.l	#1,d0
		ELSE
		tst.b	window_direct_readback
		beq.s	gfx_profile_read_mode_ready
		moveq.l	#2,d0
		ENDC
gfx_profile_read_mode_ready:
		move.l	d0,gfx_profile_read_mode
		clr.l	gfx_profile_checked
		clr.l	gfx_profile_mismatches
		clr.l	gfx_profile_aga_rows
		clr.l	gfx_profile_line
		clr.b	gfx_profile_aga_sample
		lea	gfx_profile_counts,a0
		moveq.l	#gfx_prof_stages*3-1,d0
gfx_profile_clear:
		clr.l	(a0)+
		dbra	d0,gfx_profile_clear
gfx_profile_open_done:
		rts
gfx_profile_open_failed:
		bsr.w	gfx_profile_close
		lea	gfx_profile_timer_error,a0
		bra.w	gfx_profile_error

gfx_profile_report:
		tst.l	gfx_profile_base
		beq.s	gfx_profile_report_done
		bsr.w	gfx_profile_close
		move.l	dos_base,a6
		move.l	#gfx_profile_path,d1
		move.l	#MODE_NEWFILE,d2
		jsr	Open(a6)
		move.l	d0,d4
		beq.s	gfx_profile_report_failed
		move.l	d4,d1
		move.l	#gfx_profile_format,d2
		move.l	#gfx_profile_rate,d3
		jsr	_LVOVFPrintf(a6)
		move.l	d0,d5
		move.l	d4,d1
		jsr	Close(a6)
		tst.l	d5
		bmi.s	gfx_profile_report_failed
		tst.l	d0
		beq.s	gfx_profile_report_failed
gfx_profile_report_done:
		rts
gfx_profile_report_failed:
		lea	gfx_profile_file_error,a0
gfx_profile_error:
		bsr.w	console_error
		sub.l	a0,a0
		move.l	intuition_base,a6
		jsr	_LVODisplayBeep(a6)
		rts

gfx_profile_close:
		move.l	exec_base,a6
		tst.l	gfx_profile_base
		beq.s	gfx_profile_delete_io
		clr.l	gfx_profile_base
		move.l	gfx_profile_io,a1
		jsr	CloseDevice(a6)
gfx_profile_delete_io:
		tst.l	gfx_profile_io
		beq.s	gfx_profile_delete_port
		move.l	gfx_profile_io,a0
		clr.l	gfx_profile_io
		jsr	DeleteIORequest(a6)
gfx_profile_delete_port:
		tst.l	gfx_profile_port
		beq.s	gfx_profile_close_done
		move.l	gfx_profile_port,a0
		clr.l	gfx_profile_port
		jsr	DeleteMsgPort(a6)
gfx_profile_close_done:
		rts

; Nested regions must save the outer start timestamp. Each measurement must
; be shorter than one low-word rollover; totals are 64-bit.
gfx_profile_start:
		move.w	ccr,-(SP)
		tst.l	gfx_profile_base
		beq.s	gfx_profile_start_done
		movem.l	d0-d1/a0-a1/a6,-(SP)
		move.l	gfx_profile_base,a6
		lea	gfx_profile_clock,a0
		jsr	_LVOReadEClock(a6)
		move.l	gfx_profile_clock_lo,gfx_profile_start_lo
		movem.l	(SP)+,d0-d1/a0-a1/a6
gfx_profile_start_done:
		move.w	(SP)+,ccr
		rts

gfx_profile_end:
		tst.l	gfx_profile_base
		beq.s	gfx_profile_end_done
		movem.l	d0/d2/a0-a1/a6,-(SP)
		move.l	d1,d2
		move.l	gfx_profile_base,a6
		lea	gfx_profile_clock,a0
		jsr	_LVOReadEClock(a6)
		move.l	gfx_profile_clock_lo,d0
		sub.l	gfx_profile_start_lo,d0
		lea	gfx_profile_counts,a0
		lea	(a0,d2.w),a0
		addq.l	#1,(a0)
		add.l	d0,8(a0)
		bcc.s	gfx_profile_end_restore
		addq.l	#1,4(a0)
gfx_profile_end_restore:
		movem.l	(SP)+,d0/d2/a0-a1/a6
gfx_profile_end_done:
		rts

		even
gfx_profile_base:	dc.l	0
gfx_profile_port:	dc.l	0
gfx_profile_io:	dc.l	0
gfx_profile_clock:	dc.l	0
gfx_profile_clock_lo:	dc.l	0
gfx_profile_start_lo:	dc.l	0
gfx_profile_line:	dc.l	0
gfx_profile_aga_sample:	dc.b	0
		even

gfx_profile_rate:	dc.l	0
gfx_profile_driver:	dc.l	0
gfx_profile_refresh:	dc.l	0
gfx_profile_width:	dc.l	0
gfx_profile_height:	dc.l	0
gfx_profile_read_mode:	dc.l	0
gfx_profile_checked:	dc.l	0
gfx_profile_mismatches:	dc.l	0
gfx_profile_aga_rows:	dc.l	0
gfx_profile_counts:	ds.l	gfx_prof_stages*3	;per stage: samples, ticks high, ticks low.

gfx_profile_timer:	dc.b	"timer.device",0
gfx_profile_path:	dc.b	"T:Wzonka-GFX.txt",0
gfx_profile_timer_error:
		dc.b	"GFX profiling: could not open timer.device.",10,0
gfx_profile_file_error:
		dc.b	"GFX profiling: could not write T:Wzonka-GFX.txt.",10,0
gfx_profile_format:
		dc.b	"EClock Hz: %lu, driver: %lu, refresh: %lu, window: %lux%lu",10
		dc.b	"Window readback mode: %lu, checked: %lu, mismatched: %lu",10
		IFNE	AGA_FULL_REGISTER_MERGE
		dc.b	"AGA Full sprite merge: register",10
		ELSE
		dc.b	"AGA Full sprite merge: memory",10
		ENDC
		dc.b	"AGA Full sprite rows composited: %lu",10
		dc.b	"stage samples ticks_hi ticks_lo",10
		dc.b	"planar %lu %lu %lu",10
		dc.b	"readback %lu %lu %lu",10
		dc.b	"pens %lu %lu %lu",10
		dc.b	"scaling %lu %lu %lu",10
		dc.b	"wait %lu %lu %lu",10
		dc.b	"upload %lu %lu %lu",10
		dc.b	"aga_bg %lu %lu %lu",10
		dc.b	"aga_window %lu %lu %lu",10
		dc.b	"aga_sprites %lu %lu %lu",10
		dc.b	"aga_oam %lu %lu %lu",10
		dc.b	"aga_sprite_clear %lu %lu %lu",10,0
		even
