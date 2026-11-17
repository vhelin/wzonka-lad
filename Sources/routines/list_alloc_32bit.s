
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		allocate a memory block and align it by 32
;		add the pointer to the list and return the aligned
;		pointer to the memory area. this is the vector list allocation
;		version. it allocates loads of memory and all the needed information
;		is stored in a special block, memory list, which ends to 0.L
;		INPUT:
;		a4	= the memory list.
;		a5	= pointer to a .L where the list ptr will be held.
;		OUTPUT:
;		d0	= 1 = no errors / 0 = error!
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

allocate_list:	move.l	a4,a0
		moveq.l	#4,d0
allocate_list_get_length:
		tst.l	(a0)
		beq.s	allocate_list_length_found
		addq.l	#4,d0
		add.l	#3*4,a0
		bra.s	allocate_list_get_length

allocate_list_length_found:
		move.l	exec_base,a6
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1
		jsr	AllocVec(a6)

		move.l	d0,(a5)
		move.l	d0,a5
		beq.s	v_allocation_er			;error!

alloc_list_loop:tst.l	(a4)				;end?
		beq.s	end_of_vctrlst			;yes. the list ends here. exit.
		move.l	4(a4),d0			;the amount.
		move.l	8(a4),d1			;the system flags.
		add.l	#32,d0				;the max align fix.
		jsr	AllocVec(a6)

		move.l	d0,(a5)+			;store the pointer.
		beq.s	v_allocation_er			;not enough memory.

		bsr.w	align_d0			;align the pointer.

		move.l	(a4),a1				;load the pointer.
		move.l	d0,(a1)				;store the aligned pointer.
		add.l	#3*4,a4				;next entry.
		bra.s	alloc_list_loop			;next allocation.

end_of_vctrlst:	clr.l	(a5)
		jsr	CacheClearU(a6)
		moveq.l	#1,d0				;no errors.
		rts

v_allocation_er:moveq.l	#0,d0				;error.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		free memory using the list created by the code
;		up there ;)
;		INPUT:
;		a5	= pointer to a pointer of the memory list.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

free_vectors:	tst.l	(a5)
		beq.s	exit_free_quit
		move.l	(a5),a4				;the list.
		move.l	exec_base,a6
free_vectors_n:	move.l	(a4),d0
		beq.s	exit_free			;yes. exit.
		clr.l	(a4)+
		move.l	d0,a1
		jsr	FreeVec(a6)			;free the area.
		bra.s	free_vectors_n			;free them all.

exit_free:	move.l	(a5),a1
		jsr	FreeVec(a6)			;free the list.
		clr.l	(a5)
		jsr	CacheClearU(a6)
exit_free_quit:	rts					;exit.

		include	'binworld:Wzonka-Lad/Sources/routines/align!d0_32.S'
