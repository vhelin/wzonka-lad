
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		set bitplane pointers
;		d0 - view area's beginning.
;		d1 - the number of planes.
;		d2 - modulus.
;		a0 - copper list's beginning.
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

load_bitplanes:	
LoadBitplanes:	move.w	d0,6(a0)			;load pointers into.
		swap	d0				;the given list.
		move.w	d0,2(a0)
		swap	d0
		add.l	d2,d0				;next plane.
		addq.l	#8,a0				;next in copper list.
		dbra	d1,LoadBitplanes
		rts
