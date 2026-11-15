
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;			rle algorithm based data unpacker
;
;		$VER: rle unpacker v0.1 by teuvo tursas (20-Dec-96)
;
;		v0.1		-	the first attempt, fully working
;				-	.L = unpacked size, .L = packed size,
;					.B = byte, .B = amount of it (0<x<255)...
;				-	packed size = the output data size
;					excluding the two first .Ls.
;
;				input
;
;		a0	=	input data (rle packed) area.
;		a1	=	output data area.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

rle_unpack:	addq.l	#4,a0				;skip the unpacked size.
		move.l	(a0)+,d0			;d0 = packed data area size.
rle_unpack_core:move.b	(a0)+,d2			;d2 = output byte.
		moveq.l	#0,d1
		move.b	(a0)+,d1			;d1 = output amount.
		subq.w	#1,d1				;dbra correction.
rle_unpack_un:	move.b	d2,(a1)+			;one byte output.
		dbra	d1,rle_unpack_un		;next byte.
		subq.l	#2,d0				;two bytes less.
		bne.s	rle_unpack_core			;next byte.
rle_unpack_exit:rts
