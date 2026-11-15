
		incdir	"binworld:includes/"

		include	"exec/memory.i"
		include	"dos/dos.i"
		include	"exec_lib.i"
		include	"dos_lib.i"
		
		include	"devices/inputevent.i"
		include	"devices/timer.i"
		include	"exec/io.i"


		section	alku,code

		move.l	execbase,exec_base

		move.l	exec_base,a6
		lea	dos_name,a1
		moveq.l	#39,d0
		jsr	OpenLibrary(a6)
		move.l	d0,dos_base
		beq.w	quit

		move.l	d0,a6
		move.l	#nil_name,d1
		move.l	#MODE_READWRITE,d2
		jsr	Open(a6)
		move.l	d0,output_file

		move.l	d0,d1
		move.l	#10000000,d2
		jsr	WaitForChar(a6)

quit:		move.l	output_file,d1
		jsr	Close(a6)

		move.l	dos_base,d0
		beq.s	no_dos_base
		move.l	d0,a1
		jsr	CloseLibrary(a6)

no_dos_base:	moveq.l	#0,d0
		rts


		section	loppu,data

output_file:	dc.l	0
exec_base:	dc.l	0
dos_base:	dc.l	0
dos_name:	dc.b	"dos.library",0
		even
nil_name:	dc.b	"q:dhdh",0
		even

		END
