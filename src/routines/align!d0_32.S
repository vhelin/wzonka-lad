
;««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		align the register d0 by thirtytwo
;««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

align_d0:	move.l	d0,d1				;align the memory.
		and.l	#%11111,d1
		beq.s	align_done
		eor.b	#%11111,d1
		add.l	d1,d0
		addq.l	#1,d0				;aligned by thirtytwo.
align_done:	rts					;return.
