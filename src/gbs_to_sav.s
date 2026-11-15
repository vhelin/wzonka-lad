
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		.gbs to .sav converter
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		incdir	"binworld:includes/"
		include	"exec/memory.i"
		include	"dos/dos.i"
		include	"exec_lib.i"
		include	"dos_lib.i"
		include	"xpkmaster_lib.i"
		include	"xpk/xpk.i"

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		section	juures,code
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

gbs_to_sav:	movem.l	d2-d7/a2-a6,-(SP)		;stack!
		move.l	execbase,exec_base		;cache it locally.

		move.l	a0,cli_input			;store the pointer.

		move.l	exec_base,a6
		lea	dos_name,a1
		moveq.l	#39,d0
		jsr	OpenLibrary(a6)
		move.l	d0,dos_base
		beq.w	quit

		lea	xpk_master_name,a1
		moveq.l	#0,d0
		jsr	OpenLibrary(a6)
		move.l	d0,xpk_master_base

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

load_data:	move.l	xpk_master_base,d0
		beq.w	no_xpk_open

		move.l	d0,a6
		lea	xfh_pointer,a0
		lea	xpk_in_tags,a1
		move.l	name_input,4(a1)
		jsr	XpkOpen(a6)
		tst.l	d0
		bne.w	no_xpk_open

		move.l	xfh_pointer,a0			;a0 = xpkfib structure.
		move.l	xf_Type(a0),d0			;d0 = file type.
		cmp.l	#XPKTYPE_PACKED,d0		;is it packed?
		bne.w	quit_xpk			;no. it's something else.

		move.l	xf_ULen(a0),file_length		;uncompressed length.
		add.l	#XPK_MARGIN,file_length		;xpk margin area.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		cartridge loader memory handler
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	exec_base,a6
		move.l	file_length,d0
		addq.l	#4,d0				;#4 checker.
		moveq.l	#MEMF_PUBLIC,d1			;the system flags.
		jsr	AllocVec(a6)
		move.l	d0,cartridge			;the pointer here.
		beq.w	quit_xpk_e			;not enough memory! quit.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		unpack the rom image
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	xpk_master_base,a6
		move.l	xfh_pointer,a0
		jsr	XpkClose(a6)
		clr.l	xfh_pointer

		move.l	dos_base,a6			;open the data file.
		move.l	name_input,d1			;the name of the file.
		move.l	#Mode_Old,d2
		jsr	Open(a6)			;narsk.
		move.l	d0,file_hd
		beq.w	quit_xpk_e			;file error!

		move.l	xpk_master_base,a6
		lea	xpk_unp_tags,a0
		move.l	file_hd,4(a0)
		move.l	cartridge,12(a0)
		move.l	file_length,20(a0)		;output area length!
		jsr	XpkUnpack(a6)
		tst.l	d0
		bne.s	xpk_argh			;error here!

		move.l	dos_base,a6
		move.l	file_hd,d1
		jsr	Close(a6)			;click.

		bra.w	load_ok

xpk_argh:	move.l	dos_base,a6
		move.l	file_hd,d1
		jsr	Close(a6)			;click.

quit_xpk_e:	move.l	xpk_master_base,a6		;an error occurred!
		move.l	xfh_pointer,d0
		beq.w	error_in_open
		move.l	d0,a0
		jsr	XpkClose(a6)
		clr.l	xfh_pointer
		beq.w	error_in_open

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		normal dos open and loading
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

quit_xpk:	move.l	xpk_master_base,a6
		move.l	xfh_pointer,a0			;it was not packed.
		jsr	XpkClose(a6)
		clr.l	xfh_pointer

no_xpk_open:	move.l	dos_base,a6
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
;		cartridge loader memory handler
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		move.l	exec_base,a6
		move.l	file_length,d0
		addq.l	#4,d0				;#4 checker.
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
;		check the size of RAM
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_ok:	move.l	cartridge,a0
		add.l	#56+$2000,a0
		cmp.l	#4,(a0)				;four banks?
		bne.s	one_bank_out			;nope, only one.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		now save the RAM banks
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

four_banks_out:	move.l	dos_base,a6			;open the data file.
		move.l	name_output,d1			;the name of the file.
		move.l	#Mode_New,d2
		jsr	Open(a6)			;narsk.
		move.l	d0,file_hd
		beq.w	error_in_save			;file error!

		move.l	d0,d1				;file_hd.
		move.l	cartridge,d2			;input address.
		add.l	#56+$10000-$8000+4,d2		;skip the control bytes.
		move.l	#$2000*4,d3			;the length.
		jsr	Write(a6)			;write.

		bra.s	save_exit

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		now save the RAM bank
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

one_bank_out:	move.l	dos_base,a6			;open the data file.
		move.l	name_output,d1			;the name of the file.
		move.l	#Mode_New,d2
		jsr	Open(a6)			;narsk.
		move.l	d0,file_hd
		beq.w	error_in_save			;file error!

		move.l	d0,d1				;file_hd.
		move.l	cartridge,d2			;input address.
		add.l	#56+$A000-$8000,d2		;skip the control bytes.
		move.l	#$2000,d3			;the length.
		jsr	Write(a6)			;write.

save_exit:	move.l	file_hd,d1
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
		move.l	file_info_ptr,d0
		bsr.b	free_vec_sub

		move.l	xpk_master_base,d0
		bsr.b	free_libs
		move.l	dos_base,d0
		bsr.b	free_libs

		movem.l	(SP)+,d2-d7/a2-a6		;unstack!
		moveq.l	#0,d0				;no errors.
		rts

free_vec_sub:	move.l	d0,a1
		beq.s	no_vec				;no vector.
		jsr	FreeVec(a6)			;free the area.
no_vec:		rts

free_libs:	move.l	d0,a1
		beq.s	no_free_libs
		jsr	CloseLibrary(a6)
no_free_libs:	rts

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
xpk_master_name:dc.b	"xpkmaster.library",0
		even

exec_base:	dc.l	0
dos_base:	dc.l	0
xpk_master_base:dc.l	0

cli_input:	dc.l	0

file_length:	dc.l	0
file_hd:	dc.l	0

name_input:	dc.l	0
name_output:	dc.l	0

cartridge:	dc.l	0
file_info_ptr:	dc.l	0

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

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		the syntax message
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

syntax_msg:	dc.b	$A
		dc.b	"      Wzonka-Lad .gbs to VGB .sav file converter v1.0",$A
		dc.b	"          Copyright 1997 Ville Helin (31-May-97)     ",$A,$A
		dc.b	"SYNTAX: gbs_to_sav [INPUT NAME (.GBS)] [OUTPUT NAME (.SAV)]",$A,$A
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

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		no conversion errors message
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

ok_message:	dc.b	"No errors.",$A
		dc.b	0
ok_message_end:	even

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		version string
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

snapshot_to_sav:dc.b	"$VER: .gbs to .sav converter 1.0 (31.05.97)",0
		even

		END
