
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		.sav to .gbs converter
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		incdir	"binworld:includes/"
		include	"exec/memory.i"
		include	"dos/dos.i"
		include	"exec_lib.i"
		include	"dos_lib.i"

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		section	juures,code
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

sav_to_gbs:	movem.l	d2-d7/a2-a6,-(SP)		;stack!
		move.l	execbase,exec_base		;cache it locally.

		move.l	a0,cli_input			;store the pointer.

		move.l	exec_base,a6
		lea	dos_name,a1
		moveq.l	#39,d0
		jsr	OpenLibrary(a6)
		move.l	d0,dos_base
		beq.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate some memory
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	exec_base,a6
		move.l	#256,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1	;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,name_input			;the pointer here.
		beq.w	quit

		move.l	#256,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1	;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,name_output			;the pointer here.
		beq.w	quit

		move.l	#256,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1	;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,file_info_ptr		;the pointer here.
		beq.w	quit

		move.l	#$10000,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1	;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,cartridge_ram		;the pointer here.
		beq.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		empty input?
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	cli_input,a0
		cmp.b	#$A,(a0)
		beq.w	show_syntax

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		read input and output names
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	cli_input,a0
		move.l	name_input,a1
		bsr.b	get_name
		tst.l	d0
		bne.w	quit

		subq.l	#1,a0				;back one step.
		move.l	name_output,a1
		bsr.b	get_name
		tst.l	d0
		bne.w	quit

		bra.w	load_data

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get name
;		INPUT:
;		a0	= input.
;		a1	= output.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_name:	move.w	#256-1,d0
get_name_start:	move.b	(a0)+,d1
		beq.s	get_name_error
		cmp.b	#" ",d1
		bne.s	get_name_get
		dbra	d0,get_name_start
		bra.s	get_name_error

get_name_get:	move.b	d1,(a1)+
get_name_data:	move.b	(a0)+,d1
		beq.s	get_name_end
		cmp.b	#" ",d1
		beq.s	get_name_end
		cmp.b	#$A,d1
		beq.s	get_name_end
		move.b	d1,(a1)+
		dbra	d0,get_name_data
		bra.s	get_name_error

get_name_end:	clr.b	(a1)
		moveq.l	#0,d0				;no errors.
		rts

get_name_error:	moveq.l	#1,d0				;error!
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		find out if the file can be unpacked with xpk master
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_data:	move.l	dos_base,a6
		move.l	name_input,d1			;the name.
		moveq.l	#ACCESS_READ,d2
		jsr	Lock(a6)
		move.l	d0,file_hd
		beq.w	error_in_open			;en error occurred!

		move.l	file_info_ptr,d2
		move.l	file_hd,d1
		jsr	Examine(a6)			;load file info.

		move.l	file_hd,d1
		jsr	UnLock(a6)			;unlock it.

take_the_length:move.l	file_info_ptr,a0
		move.l	124(a0),file_length		;store the length.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		check the file size
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cmp.l	#8192,file_length
		beq.s	l_is_ok
		cmp.l	#8192*4,file_length
		bne.w	error_in_size
l_is_ok:	

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		cartridge loader memory handler
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	exec_base,a6
		move.l	file_length,d0
		moveq.l	#MEMF_PUBLIC,d1			;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,cartridge			;the pointer here.
		beq.w	quit				;not enough memory! quit.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		now load the file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	dos_base,a6			;open the data file.
		move.l	name_input,d1			;the name of the file.
		move.l	#Mode_Old,d2
		jsr	Open(a6)			;narsk.
		move.l	d0,file_hd
		beq.w	quit				;file error!

		move.l	d0,d1				;file_hd.
		move.l	cartridge,d2			;output address.
		move.l	file_length,d3			;the length.
		jsr	Read(a6)			;read.

		move.l	file_hd,d1
		jsr	Close(a6)			;click.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		prepare the values
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	cartridge_ram,a0
		clr.l	(a0)+				;z80_halt.B, 3x.B 0.
		move.l	#$00D80013,(a0)+		;bcde.
		move.l	#$100,(a0)+			;pc.
		move.l	#$0000014D,(a0)+		;hl.
		move.l	#$0000B001,(a0)+		;fa.
		clr.l	(a0)+				;ccr.
		move.l	#$0000FFFE,(a0)+		;sp.

		clr.l	(a0)+				;compability.
		clr.l	(a0)+
		clr.l	(a0)+
		clr.l	(a0)+

		move.l	#453/5,(a0)+			;z80_cycles.
		clr.l	(a0)+				;bank_address-rom_32k.
		clr.l	(a0)				;ram_bank_no.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		now save the RAM banks as a .gbs file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	dos_base,a6			;open the data file.
		move.l	name_output,d1			;the name of the file.
		move.l	#Mode_New,d2
		jsr	Open(a6)			;narsk.
		move.l	d0,file_hd
		beq.w	error_in_save			;file error!

		move.l	d0,d1				;file_hd.
		move.l	cartridge_ram,d2		;input address.
		moveq.l	#56,d3				;the length.
		jsr	Write(a6)			;write.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		now save out the RAM
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	file_hd,d1
		move.l	cartridge_ram,d2
		add.l	#56,d2
		move.l	#$A000-$8000,d3			;video ram.
		jsr	Write(a6)

		move.l	file_hd,d1
		move.l	cartridge,d2
		move.l	#$2000,d3			;ram bank 0.
		jsr	Write(a6)

		move.l	file_hd,d1
		move.l	cartridge_ram,d2
		add.l	#56,d2
		move.l	#$FF00-$C000,d3			;upper ram.
		jsr	Write(a6)

		move.l	cartridge_ram,a0
		add.l	#56,a0
		move.l	a0,a1
		addq.l	#7,a1
		move.b	#$F8,(a1)			;TIMCONT = $f8!
		subq.l	#1,a1
		move.b	#1,(a1)				;TIMEMOD = 1.
		subq.l	#1,a1
		move.b	#1,(a1)				;TIMECNT = 1.
		move.l	a0,a2
		add.l	#$40,a2				;a2 = LCDCONT.
		move.b	#$81,(a2)
		addq.l	#1,a2				;a2 = LCDSTAT.
		clr.b	(a2)
		addq.l	#4,a2				;a2 = CMPLINE.
		move.b	#$ff,(a2)

		move.b	#%11111111,(a0)			;reset the buttons.

		move.l	file_hd,d1
		move.l	cartridge_ram,d2
		add.l	#56,d2
		move.l	#$10000-$FF00,d3		;upmost ram.
		jsr	Write(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		now many banks must be saved?
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	cartridge_ram,a0
		add.l	#56,a0

		cmp.l	#8192,file_length
		beq.s	l_8192

l_32768:	move.l	#4,(a0)				;four banks.
		
		move.l	file_hd,d1
		move.l	cartridge_ram,d2
		add.l	#56,d2
		moveq.l	#4,d3				;misc bytes.
		jsr	Write(a6)

		move.l	file_hd,d1
		move.l	cartridge,d2
		move.l	#$2000*4,d3			;the four ram banks.
		jsr	Write(a6)

		move.l	cartridge_ram,a0
		add.l	#56,a0
		clr.b	(a0)				;i_flag.

		move.l	file_hd,d1
		move.l	cartridge_ram,d2
		add.l	#56,d2
		moveq.l	#1,d3				;i_flag.
		jsr	Write(a6)

		bra.s	exit_save

l_8192:		clr.l	(a0)+				;no banks saved.
		clr.b	(a0)				;i_flag.

		move.l	file_hd,d1
		move.l	cartridge_ram,d2
		add.l	#56,d2
		moveq.l	#5,d3				;misc bytes.
		jsr	Write(a6)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		close the output
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

exit_save:	move.l	file_hd,d1
		jsr	Close(a6)			;click.

		bsr.w	get_output
		move.l	#ok_message,d2
		move.l	#ok_message_end-ok_message,d3
		bsr.w	print_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		quit / exit
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

quit:		move.l	exec_base,a6

		move.l	cartridge,d0
		bsr.b	free_vec_sub
		move.l	name_input,d0
		bsr.b	free_vec_sub
		move.l	name_output,d0
		bsr.b	free_vec_sub
		move.l	cartridge_ram,d0
		bsr.b	free_vec_sub
		move.l	file_info_ptr,d0
		bsr.b	free_vec_sub

		move.l	dos_base,d0
		move.l	d0,a1
		beq.s	no_free_dos
		jsr	CloseLibrary(a6)

no_free_dos:	movem.l	(SP)+,d2-d7/a2-a6		;unstack!
		moveq.l	#0,d0				;no errors.
		rts

free_vec_sub:	move.l	d0,a1
		beq.s	no_vec				;no vector.
		jsr	FreeVec(a6)			;free the area.
no_vec:		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		(error) messages
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

error_in_open:	bsr.b	get_output
		move.l	#e_open_msg,d2
		move.l	#e_open_msg_end-e_open_msg,d3
		bsr.b	print_message
		bra.b	quit

error_in_save:	bsr.b	get_output
		move.l	#e_save_msg,d2
		move.l	#e_save_msg_end-e_save_msg,d3
		bsr.b	print_message
		bra.b	quit

error_in_size:	bsr.b	get_output
		move.l	#e_size_msg,d2
		move.l	#e_size_msg_end-e_size_msg,d3
		bsr.b	print_message
		bra.w	quit

show_syntax:	bsr.b	get_output
		move.l	#syntax_msg,d2
		move.l	#syntax_msg_end-syntax_msg,d3
		bsr.b	print_message
		bra.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		get the output pointer / print an message
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

get_output:	move.l	dos_base,a6
		jsr	Output(a6)
		rts

print_message:	move.l	d0,d1
		jsr	Write(a6)
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		section	murrr,data
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

dos_name:	dc.b	"dos.library",0
		even

exec_base:	dc.l	0
dos_base:	dc.l	0

cli_input:	dc.l	0

file_length:	dc.l	0
file_hd:	dc.l	0

name_input:	dc.l	0
name_output:	dc.l	0

cartridge:	dc.l	0
cartridge_ram:	dc.l	0
file_info_ptr:	dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the syntax message
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

syntax_msg:	dc.b	$A
		dc.b	"      VGB .sav to Wzonka-Lad .gbs file converter v1.0",$A
		dc.b	"          Copyright 1997 Ville Helin (01-Jun-97)     ",$A,$A
		dc.b	"SYNTAX: sav_to_gbs [INPUT NAME (.SAV)] [OUTPUT NAME (.GBS)]",$A,$A
		dc.b	0
syntax_msg_end:	even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		error messages
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

e_save_msg:	dc.b	"Error in output.",$A
		dc.b	0
e_save_msg_end:	even

e_open_msg:	dc.b	"Error in input.",$A
		dc.b	0
e_open_msg_end:	even

e_size_msg:	dc.b	"Error in size. Must be 8192/32768 bytes.",$A
		dc.b	0
e_size_msg_end:	even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		no conversion errors message
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

ok_message:	dc.b	"No errors.",$A
		dc.b	0
ok_message_end:	even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		version string
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

snapshot_to_sav:dc.b	"$VER: .sav to .gbs converter 1.0 (01.06.97)",0
		even

		END
