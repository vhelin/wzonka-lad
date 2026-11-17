
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		keyboard.device test
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		incdir	"binworld:includes/"
		include	"exec/memory.i"
		include	"exec_lib.i"

		include	"devices/inputevent.i"
		include	"devices/keyboard.i"
		include	"exec/io.i"

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
		section	kawaii,code
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	execbase,exec_base

		move.l	exec_base,a6
		move.l	#IOSTD_SIZE,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1
		jsr	AllocVec(a6)
		move.l	d0,keyboard_io

		move.l	exec_base,a6
		move.l	#ie_SIZEOF,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1
		jsr	AllocVec(a6)
		move.l	d0,keyboard_ie_data

		move.l	exec_base,a6
		move.l	keyboard_io,a1
		moveq.l	#0,d0
		moveq.l	#0,d1
		lea	keyboard_device_name,a0
		jsr	OpenDevice(a6)

		move.l	keyboard_io,a1
		move.w	#KBD_READEVENT,IO_COMMAND(a1)	;read events.
		move.b	#IOB_QUICK,IO_FLAGS(a1)
		move.l	keyboard_ie_data,IO_DATA(a1)
		move.l	#ie_SIZEOF,IO_LENGTH(a1)	;one ie.

		move.l	keyboard_ie_data,a0
		move.b	#IECLASS_RAWKEY,ie_Class(a0)

		jsr	SendIO(a6)

		move.l	keyboard_ie_data,a0
		move.w	ie_Qualifier(a0),d0

		move.l	keyboard_io,a1
		jsr	_LVOAbortIO(a6)

		move.l	exec_base,a6
		move.l	keyboard_io,a1
		jsr	CloseDevice(a6)

		move.l	exec_base,a6
		move.l	keyboard_io,a1
		jsr	FreeVec(a6)

		move.l	exec_base,a6
		move.l	keyboard_ie_data,a1
		jsr	FreeVec(a6)

		moveq.l	#0,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		section	josei,data
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

exec_base:	dc.l	0

keyboard_device_name:
		dc.b	"keyboard.device",0
		even

keyboard_io:	dc.l	0
keyboard_ie_data:
		dc.l	0

		END
