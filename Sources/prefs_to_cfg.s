
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		.prefs to .cfg colour converter
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		incdir	"binworld:includes/"
		include	"exec/memory.i"
		include	"exec_lib.i"
		include	"dos_lib.i"

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		section converter,code
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

prefs_to_cfg:	movem.l	d2-d7/a2-a6,-(SP)		;stack!
		move.l	execbase,exec_base		;cache it locally.

		move.l	a0,command_line

		move.l	exec_base,a6
		lea	dos_name,a1
		moveq.l	#39,d0
		jsr	OpenLibrary(a6)
		move.l	d0,dos_base
		beq.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate buffers
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	exec_base,a6
		move.l	#1024,d0
		moveq.l	#MEMF_PUBLIC,d1			;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,cfg_file			;the pointer here.
		beq.w	quit

		move.l	#1024,d0
		moveq.l	#MEMF_PUBLIC,d1			;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,prefs_file			;the pointer here.
		beq.w	quit

		move.l	#1024,d0
		moveq.l	#MEMF_PUBLIC,d1			;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,in_name			;the pointer here.
		beq.w	quit

		move.l	#1024,d0
		moveq.l	#MEMF_PUBLIC,d1			;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,out_name			;the pointer here.
		beq.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		locate and copy the input name
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	command_line,a0
		cmp.b	#$A,(a0)
		beq.w	show_syntax			;no inputs.

		move.l	in_name,a1
		move.l	out_name,a2
		moveq.l	#120-1,d0
find_in_name:	move.b	(a0)+,d1
		cmp.b	#'"',d1
		beq.s	begin_found
		dbra	d0,find_in_name
		bra.w	error_in

begin_found:	moveq.l	#120-1,d0
copy_in_name:	move.b	(a0)+,d1
		cmp.b	#'"',d1
		beq.s	end_in
		move.b	d1,(a1)+
		dbra	d0,copy_in_name
		bra.w	error_in

end_in:		clr.b	(a1)				;end of in name.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		locate and copy the output name
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		addq.l	#1,a0				;skip a " ".
		moveq.l	#120-1,d0
copy_out_name:	move.b	(a0)+,d1
		cmp.b	#$A,d1
		beq.s	end_out
		move.b	d1,(a2)+
		dbra	d0,copy_out_name
		bra.w	error_out

end_out:	clr.b	(a2)				;end of out name.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		read data from the .prefs file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	dos_base,a6			;open the data file.
		move.l	in_name,d1			;the name of the file.
		move.l	#Mode_Old,d2
		jsr	Open(a6)			;narsk.
		move.l	d0,file_hd
		beq.w	error_in_open			;file error!

		move.l	d0,d1				;file_hd.
		move.l	prefs_file,d2			;input address.
		move.l	#3*4*2,d3			;the length.
		jsr	Read(a6)			;read.

		move.l	file_hd,d1
		jsr	Close(a6)			;click.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		create the .cfg file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	cfg_file,a0
		move.l	prefs_file,a1

		move.l	#"-bc0",(a0)+			;background 0.
		move.w	#" #",(a0)+
		bsr.w	hex_to_ascii
		move.b	#$A,(a0)+			;enter.

		move.l	#"-bc1",(a0)+			;background 1.
		move.w	#" #",(a0)+
		bsr.w	hex_to_ascii
		move.b	#$A,(a0)+			;enter.

		move.l	#"-bc2",(a0)+			;background 2.
		move.w	#" #",(a0)+
		bsr.w	hex_to_ascii
		move.b	#$A,(a0)+			;enter.

		move.l	#"-bc3",(a0)+			;background 3.
		move.w	#" #",(a0)+
		bsr.w	hex_to_ascii
		move.b	#$A,(a0)+			;enter.

		sub.l	#4*3,a1				;bc -> wc.
		move.l	#"-wc0",(a0)+			;window 0.
		move.w	#" #",(a0)+
		bsr.w	hex_to_ascii
		move.b	#$A,(a0)+			;enter.

		move.l	#"-wc1",(a0)+			;window 1.
		move.w	#" #",(a0)+
		bsr.w	hex_to_ascii
		move.b	#$A,(a0)+			;enter.

		move.l	#"-wc2",(a0)+			;window 2.
		move.w	#" #",(a0)+
		bsr.w	hex_to_ascii
		move.b	#$A,(a0)+			;enter.

		move.l	#"-wc3",(a0)+			;window 3.
		move.w	#" #",(a0)+
		bsr.w	hex_to_ascii
		move.b	#$A,(a0)+			;enter.

		move.l	#"-sc0",(a0)+			;sprite 0.
		move.w	#" #",(a0)+
		bsr.w	hex_to_ascii
		move.b	#$A,(a0)+			;enter.

		move.l	#"-sc1",(a0)+			;sprite 1.
		move.w	#" #",(a0)+
		bsr.w	hex_to_ascii
		move.b	#$A,(a0)+			;enter.

		move.l	#"-sc2",(a0)+			;sprite 2.
		move.w	#" #",(a0)+
		bsr.w	hex_to_ascii
		move.b	#$A,(a0)+			;enter.

		move.l	#"-sc3",(a0)+			;sprite 3.
		move.w	#" #",(a0)+
		bsr.w	hex_to_ascii
		move.b	#$A,(a0)+			;enter.

		sub.l	cfg_file,a0			;a0 = the length.
		move.l	a0,file_length

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		save the .cfg file
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	dos_base,a6			;open the data file.
		move.l	out_name,d1			;the name of the file.
		move.l	#Mode_New,d2
		jsr	Open(a6)			;narsk.
		move.l	d0,file_hd
		beq.w	error_in_save			;file error!

		move.l	d0,d1				;file_hd.
		move.l	cfg_file,d2			;input address.
		move.l	file_length,d3			;the length.
		jsr	Write(a6)			;write.

		move.l	file_hd,d1
		jsr	Close(a6)			;click.

		bsr.w	get_output
		move.l	#ok_message,d2
		move.l	#ok_message_end-ok_message,d3
		bsr.w	print_message
		bra.w	quit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		error messages
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

error_in_save:	bsr.w	get_output
		move.l	#e_save,d2
		move.l	#e_save_end-e_save,d3
		bsr.w	print_message
		bra.s	quit

error_in_open:	bsr.w	get_output
		move.l	#e_open,d2
		move.l	#e_open_end-e_open,d3
		bsr.w	print_message
		bra.s	quit

error_in:	bsr.w	get_output
		move.l	#e_in_name,d2
		move.l	#e_in_name_end-e_in_name,d3
		bsr.w	print_message
		bra.s	quit

error_out:	bsr.w	get_output
		move.l	#e_out_name,d2
		move.l	#e_out_name_end-e_out_name,d3
		bsr.w	print_message
		bra.s	quit

show_syntax:	bsr.w	get_output
		move.l	#syntax_msg,d2
		move.l	#syntax_msg_end-syntax_msg,d3
		bsr.w	print_message

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		quit
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

quit:		move.l	exec_base,a6
		move.l	dos_base,d1
		beq.s	no_dos
		move.l	d1,a1
		jsr	CloseLibrary(a6)

no_dos:		move.l	prefs_file,d0
		beq.s	no_prefs
		move.l	d0,a1
		jsr	FreeVec(a6)

no_prefs:	move.l	cfg_file,d0
		beq.s	no_cfg
		move.l	d0,a1
		jsr	FreeVec(a6)

no_cfg:		move.l	in_name,d0
		beq.s	no_in_name
		move.l	d0,a1
		jsr	FreeVec(a6)

no_in_name:	move.l	out_name,d0
		beq.s	no_out_name
		move.l	d0,a1
		jsr	FreeVec(a6)

no_out_name:	movem.l	(SP)+,d2-d7/a2-a6
		moveq.l	#0,d0
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		convert a hex value to ascii letter
;		INPUT:
;		a0	= output (ascii).
;		a1	= input (hex).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

hex_to_ascii:	moveq.l	#3-1,d2
hex_to_ascii_I:	move.b	(a1)+,d0
		move.b	d0,d1
		lsr.b	#4,d1
		cmp.b	#9,d1
		ble.s	ascii_number_I
ascii_letter_I:	sub.b	#$A,d1
		add.b	#"A",d1
		bra.s	hex_to_ascii_II
ascii_number_I:	add.b	#"0",d1

hex_to_ascii_II:move.b	d1,(a0)+
		and.b	#%1111,d0
		cmp.b	#$9,d0
		ble.s	ascii_number_II
ascii_letter_II:sub.b	#$A,d0
		add.b	#"A",d0
		move.b	d0,(a0)+
		dbra	d2,hex_to_ascii_I
		rts
ascii_number_II:add.b	#"0",d0
		move.b	d0,(a0)+
		dbra	d2,hex_to_ascii_I
		rts

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
;		section	stuff,data
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

exec_base:	dc.l	0
dos_base:	dc.l	0
dos_name:	dc.b	"dos.library",0
		even

command_line:	dc.l	0

prefs_file:	dc.l	0
cfg_file:	dc.l	0

in_name:	dc.l	0
out_name:	dc.l	0

file_hd:	dc.l	0
file_length:	dc.l	0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		error messages
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

e_save:		dc.b	"Unable to open the output file.",$A,0
e_save_end:	even

e_open:		dc.b	"Unable to open the input file.",$A,0
e_open_end:	even

e_in_name:	dc.b	"Error in input name.",$A,0
e_in_name_end:	even

e_out_name:	dc.b	"Error in output name.",$A,0
e_out_name_end:	even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		no conversion errors message
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

ok_message:	dc.b	"No errors.",$A,0
ok_message_end:	even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the syntax message
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

syntax_msg:	dc.b	$A
		dc.b	"       Wzonka-Lad .prefs to VGB .cfg file converter v1.01",$A
		dc.b	"             Copyright 1997 Ville Helin (30-May-97)",$A,$A
		dc.b	'SYNTAX: prefs_to_cfg "[INPUT NAME (.PREFS)]" [OUTPUT NAME (.CFG)]',$A,$A
		dc.b	0
syntax_msg_end:	even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the version string
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

version_string:	dc.b	"$VER: .prefs to .cfg converter 1.01 (30.05.97)",0
		even

		END
