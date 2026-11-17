
		incdir	"binworld:includes/"

		include	"exec/memory.i"
		include	"dos/dos.i"
		include	"exec_lib.i"
		include	"dos_lib.i"
		
		include	"devices/inputevent.i"
		include	"devices/serial.i"
		include	"exec/io.i"


		section	alku,code

		move.l	execbase,exec_base

		move.l	exec_base,a6
		lea	dos_name,a1
		moveq.l	#39,d0
		jsr	OpenLibrary(a6)
		move.l	d0,dos_base
		beq.w	quit

		moveq.l	#64,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1
		jsr	AllocVec(a6)
		move.l	d0,io_buffer
		beq.w	quit

		jsr	CreateMsgPort(a6)
		move.l	d0,input_message_port
		beq.w	quit

		move.l	input_message_port,a0
		move.l	#IOEXTSER_SIZE,d0
		jsr	CreateIORequest(a6)
		move.l	d0,io_request
		beq.w	quit

		lea	serial_device_name,a0
		move.l	io_request,a1
		moveq.l	#0,d0
		moveq.l	#0,d1
		jsr	OpenDevice(a6)
		tst.l	d0
		bne.w	quit

		move.b	#1,serial_device_status

		move.l	io_request,a1
		move.l	#19200,IO_BAUD(a1)
		move.w	#SDCMD_SETPARAMS,IO_COMMAND(a1)
		jsr	DoIO(a6)
		tst.l	d0
		bne.w	quit

		moveq.l	#0,d7

io_connect_check:
		cmp.w	#1000,d7
		beq.w	io_connect_check_abort

		move.l	exec_base,a6
		move.l	io_request,a1
		move.l	#1,IO_LENGTH(a1)
		move.l	io_buffer,IO_DATA(a1)
		move.w	#SDCMD_QUERY,IO_COMMAND(a1)
		jsr	DoIO(a6)
		tst.l	d0
		bne.w	quit

		move.l	dos_base,a6
		move.l	#1,d1
		jsr	Delay(a6)

		addq.w	#1,d7

		move.l	io_request,a0
		move.w	IO_STATUS(a0),d0
		btst	#5,d0
		bne.s	io_connect_check

		move.l	exec_base,a6
		move.l	io_request,a1
		move.l	#13,IO_LENGTH(a1)
		move.l	io_buffer,IO_DATA(a1)
		move.w	#CMD_READ,IO_COMMAND(a1)
		jsr	DoIO(a6)
		tst.l	d0
		bne.w	quit

		move.l	io_request,a1
		jsr	WaitIO(a6)

		move.l	dos_base,a6
		jsr	Output(a6)
		move.l	d0,d1
		move.l	io_buffer,d2
		moveq.l	#13,d3
		jsr	Write(a6)

io_connect_check_abort:
quit:		move.l	exec_base,a6
		move.l	io_request,d0
		beq.s	no_io_request
		move.l	d0,a1
		jsr	_LVOAbortIO(a6)

		tst.b	serial_device_status
		beq.s	no_close_device
		move.l	io_request,a1
		jsr	CloseDevice(a6)

no_close_device:move.l	io_request,a0
		jsr	DeleteIORequest(a6)

no_io_request:	move.l	input_message_port,d0
		beq.s	no_input_message_port
		move.l	d0,a0
		jsr	DeleteMsgPort(a6)

no_input_message_port:
		move.l	io_buffer,d0
		beq.s	no_io_buffer
		move.l	d0,a1
		jsr	FreeVec(a6)

no_io_buffer:	move.l	dos_base,d0
		beq.s	no_dos_base
		move.l	d0,a1
		jsr	CloseLibrary(a6)

no_dos_base:	moveq.l	#0,d0
		rts


		section	loppu,data

exec_base:	dc.l	0
dos_base:	dc.l	0
dos_name:	dc.b	"dos.library",0
		even
serial_device_name:
		dc.b	"serial.device",0
		even

connect_data:	dc.b	"ATA",$d,0
		even

io_request:	dc.l	0
io_buffer:	dc.l	0

input_message_port:
		dc.l	0

serial_device_status:
		dc.b	0
		even

		END
