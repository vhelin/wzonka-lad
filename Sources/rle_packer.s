
		lea	jorma,a0
		lea	jeppe,a1
		move.l	#18528,d0

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;			rle algorithm based data packer
;
;		$VER: rle packer v0.1 by teuvo tursas (20-Dec-96)
;
;		v0.1		-	the first attempt, fully working
;				-	.L = unpacked size, .L = packed size,
;					.B = byte, .B = amount of it (0<x<255)...
;				-	packed size = the output data size
;					excluding the two first .Ls.
;
;				input
;
;		d0	=	input data size in bytes.
;		a0	=	input data area.
;		a1	=	output data area.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

rle_pack:	moveq.l	#0,d1				;output size in bytes.
							;excluding the sizes.
		lea	8(a1),a2			;a2 = output for data.
		move.l	d0,(a1)+			;store the unpacked size.
rle_pack_core:	move.b	(a0)+,d3
		move.b	d3,(a2)+			;store byte.
		moveq.l	#1,d2				;output rle byte size.
		addq.l	#1,d1				;one byte larger.
		subq.l	#1,d0				;one byte smaller.
		beq.s	rle_pack_end			;end of input.
rle_pack_more:	move.b	(a0)+,d4			;next byte.
		cmp.b	d4,d3				;same thing?
		bne.s	rle_pack_miss			;no. next one.
		addq.b	#1,d2				;one byte bigger rle size.
		subq.l	#1,d0				;one byte smaller.
		cmp.b	#$ff,d2				;the max?
		beq.s	rle_pack_next			;yes. close this packet.
		tst.l	d0
		beq.s	rle_pack_end			;end of input.
		bra.s	rle_pack_more
rle_pack_miss:	subq.l	#1,a0				;the previous byte.
rle_pack_next:	move.b	d2,(a2)+			;store the rle size byte.
		addq.l	#1,d1				;one byte larger.
		bra.s	rle_pack_core			;pack it again.

rle_pack_end:	addq.l	#1,d1				;the last store.
		move.l	d1,(a1)+			;store the packed length.
		move.b	d2,(a2)+			;store the last rle size.
rle_pack_exit:	lea	jeppe,a3
		sub.l	a3,a2
		move.l	a2,d0
		rts

		section	mur,data

jorma:		incbin	"binworld:gameboy/windows/prefs.bn"
		even
		
jeppe:		ds.b	81920

