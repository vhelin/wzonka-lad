
;make the keyfiles bigger than 300 bytes or else...

key_name_encode	=0
key_sounds_init	=4
key_serial_area =8

		lea	key_file_name(pc),a3
		moveq.l	#key_file_name_e-key_file_name-1,d0
key_file_decode:move.b	(a3),d1
		rol.b	d0,d1
		move.b	d1,(a3)+
		dbra	d0,key_file_decode

		move.l	#key_file_end-key_file,d0
		rts

key_file:	dc.l	key_file_enc-key_file
		dc.l	key_file_snd-key_file
		dc.l	key_file_ser-key_file

key_file_enc:	move.w	#50,(a2)			;x.
		lea	key_file_name(pc),a3
		moveq.l	#key_file_name_e-key_file_name-1,d0
key_file_encode:move.b	(a3)+,d1
		ror.b	d0,d1
		move.b	d1,(a1)+
		dbra	d0,key_file_encode
		clr.b	(a1)
		rts

key_file_name:	dc.b	"CREEP PUNK",0
key_file_name_e:even

		cnop	0,4
key_file_snd:	tst.b	(a1)+
		bne.w	key_file_no_snd

		add.l	#$10*4,a0
		moveq.l	#0,d1
		moveq.l	#0,d2

		tst.b	(a1)+
		bne.s	no_I

		move.l	(a2),(a0)
		move.l	4(a2),4(a0)
		move.l	8(a2),8(a0)
		move.l	12(a2),12(a0)
		move.l	16(a2),16(a0)
		addq.b	#1,d1

no_I:		add.l	#20+4,a0
		add.l	#20,a2
		tst.b	(a1)+
		bne.s	no_II

		move.l	(a2),(a0)
		move.l	4(a2),4(a0)
		move.l	8(a2),8(a0)
		move.l	12(a2),12(a0)
		addq.b	#1,d1

no_II:		add.l	#16,a0
		add.l	#16,a2
		tst.b	(a1)+
		bne.s	no_III

		move.l	(a2),(a0)
		move.l	4(a2),4(a0)
		move.l	8(a2),8(a0)
		move.l	12(a2),12(a0)
		move.l	16(a2),16(a0)
		addq.b	#1,d1
		move.b	#1,d2

no_III:		add.l	#20+4,a0
		add.l	#20,a2
		tst.b	(a1)
		bne.s	no_IV

		move.l	(a2),(a0)
		move.l	4(a2),4(a0)
		move.l	8(a2),8(a0)
		move.l	12(a2),12(a0)
		addq.b	#1,d1

no_IV:		add.l	#16,a0
		add.l	#16,a2
		tst.b	d1
		beq.s	no_V

		move.l	(a2),(a0)
		move.l	4(a2),4(a0)
		move.l	8(a2),8(a0)

no_V:		add.l	#12,a0
		add.l	#12,a2
		tst.b	d2
		beq.s	key_file_no_snd

		add.l	#9*4,a0
		move.l	(a2),d0
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)
key_file_no_snd:rts

key_file_ser:	moveq.l	#1,d0
		rts

key_file_end:	even

		END
