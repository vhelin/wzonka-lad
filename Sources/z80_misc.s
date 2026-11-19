
output_d0_to_a1:MACRO

		and.w	#$ff,d0
		move.w	d0,d1
		lsr.b	#4,d0
		cmp.w	#$A,d0
		blt.s	too_a\@
		add.b	#'A'-$a,d0
		bra.s	joo_a\@
too_a\@:	add.b	#'0',d0
joo_a\@:	move.b	d0,(a1)+

		and.b	#%1111,d1
		cmp.w	#$A,d1
		blt.s	too_b\@
		add.b	#'A'-$a,d1
		bra.s	joo_b\@
too_b\@:	add.b	#'0',d1
joo_b\@:	move.b	d1,(a1)+

		ENDM

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		output debug data
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		IFGT	GAMEBOY_DEBUG

debug_output:	;btst.b	#6,$bfe001
		;bne.s	debug_output_no_output

		bra.s	debug_output_ok

		movem.l	d0-d7/a0-a6,-(SP)

		move.l	gb_memory,a6
		add.l	#$fe00,a6
		lea	debug_message,a1
		move.w	#$A0-1,d7

debug_output_oam:
		move.b	(a6)+,d0
		output_d0_to_a1
		dbra	d7,debug_output_oam

		move.b	#$A,(a1)+
		move.b	#0,(a1)+
		move.l	#$a2,d3

		bra.w	debug_output_output_size

debug_output_no_output:
		jmp	z80_fetch_opcode

debug_output_ok:movem.l	d0-d7/a0-a6,-(SP)

		move.w	d0,gbz80_de
		move.w	d1,gbz80_bc
		move.w	d2,gbz80_hl
		move.w	d3,gbz80_fa

		lea	debug_flags,a1

		move.l	#"----",(a1)
		move.b	#"-",4(a1)
		btst	#0,d4
		beq.s	debug_output_c
		move.b	#"C",3(a1)
debug_output_c:	btst	#2,d4
		beq.s	debug_output_z
		move.b	#"Z",(a1)
debug_output_z:	btst	#8,d3
		beq.s	debug_output_n
		move.b	#"N",1(a1)
debug_output_n:	tst.b	h_the_flag
		beq.s	debug_output_h
		move.b	#"H",2(a1)
debug_output_h:	tst.b	i_flag
		bne.s	debug_output_i
		move.b	#"I",4(a1)
debug_output_i:	

		lea	debug_oc,a1
		move.b	(a0),d7
		move.b	d7,d0
		output_d0_to_a1

		lea	debug_cycles,a1
		move.l	a5,d0
		lsr.w	#8,d0
		output_d0_to_a1
		move.l	a5,d0
		output_d0_to_a1

		lea	debug_list,a1
		cmp.b	#$cb,d7
		bne.s	debug_output_no_cb

		lea	debug_list_cb,a1
		addq.l	#1,a0

debug_output_no_cb:
		moveq.l	#0,d7
		move.b	(a0),d7
		lsl.l	#4,d7
		add.l	d7,a1
		lea	debug_command,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+

		lea	debug_pc,a1				;pc.
		move.l	a0,d0
		sub.l	z80_pc_base,d0
		lsr.w	#8,d0
		output_d0_to_a1
		move.l	a0,d0
		sub.l	z80_pc_base,d0
		output_d0_to_a1

		lea	debug_next_1,a1				;x.
		move.b	1(a0),d0
		output_d0_to_a1

		lea	debug_next_2,a1				;xx.
		move.b	2(a0),d0
		output_d0_to_a1
		move.b	1(a0),d0
		output_d0_to_a1

		lea	debug_rom_bank,a1			;rom bank.
		move.b	rom_bank_activated,d0
		output_d0_to_a1

		lea	debug_ram_bank,a1			;ram bank.
		move.l	ram_bank_no,d0
		output_d0_to_a1

		lea	debug_de,a1				;de.
		move.w	gbz80_de,d0
		lsr.w	#8,d0
		output_d0_to_a1
		move.w	gbz80_de,d0
		output_d0_to_a1

		lea	debug_bc,a1				;bc.
		move.w	gbz80_bc,d0
		lsr.w	#8,d0
		output_d0_to_a1
		move.w	gbz80_bc,d0
		output_d0_to_a1

		lea	debug_hl,a1				;hl.
		move.w	gbz80_hl,d0
		lsr.w	#8,d0
		output_d0_to_a1
		move.w	gbz80_hl,d0
		output_d0_to_a1

		lea	debug_af,a1				;af.
		move.w	gbz80_fa,d0
		output_d0_to_a1
		move.w	gbz80_fa,d0
		lsr.w	#8,d0
		output_d0_to_a1

		lea	debug_sp,a1				;sp.
		move.w	d5,d0
		lsr.w	#8,d0
		output_d0_to_a1
		move.w	d5,d0
		output_d0_to_a1

debug_output_output:
		move.l	#debug_message_end-debug_message,d3
debug_output_output_size:
		move.l	#debug_message,d2
		move.l	dos_base,a6
		move.l	debug_con_handle,d1
		jsr	Write(a6)

		move.b	$bfec01,d6
		not.b	d6
		ror.b	#1,d6
		cmp.b	#$45,d6
		bne.s	debug_output_exit

		movem.l	(SP)+,d0-d7/a0-a6

		sub.l	a5,a5
		move.b	#1,debug_exit

		jmp	z80_fetch_opcode

debug_output_exit:
		movem.l	(SP)+,d0-d7/a0-a6

		jmp	z80_fetch_opcode

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		memory write debug routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

debug_joypad_wanted:
		movem.l	d0-d7/a0-a6,-(SP)

		lea	debug_joy,a1
		move.b	d6,d0
		output_d0_to_a1

		move.l	#debug_joy_txt,d2
		move.l	#debug_joy_txt_end-debug_joy_txt,d3
		move.l	dos_base,a6
		move.l	debug_con_handle,d1
		jsr	Write(a6)

		movem.l	(SP)+,d0-d7/a0-a6
		rts

		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		fetch the next z80 optcode
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

fetch_next_i:	MACRO
;		jmp	jesus
		move.l	a5,d6					;test cycles left.
		ble.s	f_xit\@
		IFGT	GAMEBOY_DEBUG
		jmp	debug_output
		ELSE
		move.b	(a0)+,d7
		lsl.w	#8,d7					;d7 = d7*256.
		jmp	(a1,d7.l)				;jump and emulate.
		ENDIF
f_xit\@:	rts
		ENDM


jesus:		move.l	a5,d6					;test cycles left.
		ble.s	f_xita

		IFGT	GAMEBOY_DEBUG
		jmp	debug_output
		ELSE
		move.b	(a0)+,d7
		lsl.w	#8,d7					;d7 = d7*256.
		jmp	(a1,d7.l)				;jump and emulate.
		ENDIF

f_xita:		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		z80 emulator, %1011 = znhc
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

add_sp_offset:	move.b	(a0)+,d6
		move.w	d5,d7
		add.b	d6,d7
		move.w	CCR,d4
		and.b	#1,d4
		move.w	d5,d7
		ext.w	d6
		add.w	d6,d7
		IFEQ	Z80_MODE
		eor.w	d7,d6
		eor.w	d5,d6
		lsr.w	#4,d6
		and.b	#1,d6
		move.b	d6,h_the_flag
		and.w	#$ff,d3
		ENDIF
		rts

finish_ei:	move.l	a5,d6
		subq.l	#1,d6					;remove the temporary one-cycle budget.
		add.l	z80_cycles_left,d6
		move.l	d6,a5
		cmp.b	#1,z80_ei_return
		bne.s	finish_ei_cancelled
		clr.b	i_flag
finish_ei_cancelled:
		clr.b	z80_ei_return
		bra.w	reti_back

z80_start:	move.l	bank_address,a0				;the rom area.
		lea	z80_optcode_00,a1			;xx optcodes.
		move.l	gb_memory,a2				;pointer to pseudo ram.
		move.l	a0,a3					;a3 = base pointer.
		move.l	a0,z80_pc_base
		lea	z80_optc_CB00,a4			;cbxx optcodes.
		add.l	#$100,a0				;the beginning.

		move.l	#$00D8,d0
		move.l	#$0013,d1
		move.l	#$014D,d2
		move.l	#$0101,d3				;n = 1!
		move.l	#%00000101,d4
		move.l	#$fffe,d5				;the stack pointer.
		moveq.l	#0,d7

		move.b	#1,h_the_flag				;h = 1!
		clr.b	z80_ei_return
		clr.b	z80_halt_bug

		move.b	#%0,mbc1_status
		move.l	#1,mbc5_rom_bank			;b0, b1.
		rts						;exit init.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		x/5 sweep
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
z80_cpu_next_sweep:
		moveq.l	#0,d7
		move.l	z80_cycles,a5

		IFGT	GAMEBOY_DEBUG
		jmp	debug_output
		ELSE
		bra.w	z80_fetch_opcode
		ENDIF

z80_fetch_opcode:
		move.b	(a0)+,d7
		tst.b	z80_halt_bug
		beq.s	z80_fetch_dispatch
		clr.b	z80_halt_bug
		subq.l	#1,a0					;HALT bug survives a sweep boundary.
z80_fetch_dispatch:
		lsl.w	#8,d7
		jmp	(a1,d7.l)

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		push - command memory supervisor
;		INPUT:
;		d6	= h.B, l.B (a 16-bit value to be pushed).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
write_d6_stack:	bsr.s	write_d6_stackx
		fetch_next_i

		cnop	0,4
; Test the original SP: both bytes must belong to one ordinary RAM range.
; SP=$de01 crosses the WRAM echo boundary; $ff81 crosses into I/O.
write_d6_stackx:cmp.w	#$ff82,d5
		bhs.s	write_stack_word
		cmp.w	#$c002,d5
		blo.s	write_stack_bytes
		cmp.w	#$e000,d5
		bhi.s	write_stack_bytes
		cmp.w	#$de01,d5
		blo.s	write_stack_mirrored
		bhi.s	write_stack_word

write_stack_bytes:
		subq.w	#1,d5
		move.l	d6,-(SP)
		move.l	d5,d7
		lsr.w	#8,d6					;d6 = upper data (h.B).

		move.l	gb_mem_jumps,a6
		jsr	([a6,d5.l*4])				;memory write.

		subq.w	#1,d5
		move.l	(SP)+,d6
		move.l	d5,d7					;d7 = 00BB, because
								;d5 = 00BB.
		move.l	gb_mem_jumps,a6
		jsr	([a6,d5.l*4])				;memory write.
		rts

write_stack_word:
		subq.w	#2,d5
		ror.w	#8,d6					;Game Boy stack is little-endian.
		move.w	d6,(a2,d5.l)
		move.l	d5,d7					;keep the dispatch index zero-extended.
		rts

write_stack_mirrored:
		subq.w	#2,d5
		ror.w	#8,d6
		move.w	d6,(a2,d5.l)
		move.w	d6,$2000(a2,d5.l)
		move.l	d5,d7
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		memory related subroutines and checks
;		INPUT:
;		d6	= the data (.B).
;		d7	= address for the write.
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
echo_down:	lea	(a2,d7.l),a6
		move.b	d6,(a6)
		sub.l	#$2000,a6
		move.b	d6,(a6)
		rts

		cnop	0,4
echo_up:	lea	(a2,d7.l),a6
		move.b	d6,(a6)
		add.l	#$2000,a6
		move.b	d6,(a6)
		rts

		cnop	0,4
gb_mem_wr:	move.b	d6,(a2,d7.l)
		rts

		cnop	0,4
gb_mem_wr_denied:
		rts						;no write.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		misc memory protection writes
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
lcd_mode_write:	;btst	#7,d6
		;bne.s	lcd_mode_write_done

		;cmp.l	#144,gb_scanlines
		;blt.s	lcd_mode_write_done

		;or.b	#%10000000,d6

lcd_mode_write_done:
		move.b	d6,(a2,d7.l)
		rts

		cnop	0,4
lcd_protect:	lea	(a2,d7.l),a6
		and.b	#%01111000,d6
		and.b	#%10000111,(a6)
		or.b	d6,(a6)

		move.b	(a6),d6
		and.b	#%11,d6
		beq.s	lcd_write_irq
		cmp.b	#1,d6
		bne.s	lcd_write_no_irq

lcd_write_irq:	move.l	a2,a6			;bug in hardware.
		add.l	#$ff0f,a6
		bset.b	#1,(a6)			;lcd irq is about to happen.

lcd_write_no_irq:
		rts

		cnop	0,4
irq_protect_0f:	or.b	#%11100000,d6
;		cmp.b	(a2,d7.l),d6
;		beq.s	irq_protect_0f_exit
		move.b	d6,(a2,d7.l)
;		tst.b	i_flag
;		beq.s	irq_protect_ff_wowza
irq_protect_0f_exit:
		rts

		cnop	0,4
irq_protect_ff:	or.b	#%11100000,d6
;		cmp.b	(a2,d7.l),d6
;		beq.s	irq_protect_ff_exit
		move.b	d6,(a2,d7.l)
;		tst.b	i_flag
;		beq.s	irq_protect_ff_wowza
irq_protect_ff_exit:
		rts

		cnop	0,4
irq_protect_ff_wowza:
		move.l	a5,z80_cycles_left		;CHECK THIS ONE OUT WITH
		move.b	#1,z80_ei_return		;KIRBY 2!!!
		move.l	#1,a5
;		bchg.b	#1,$bfe001
		rts

		cnop	0,4
timc_protect:	or.b	#%11111000,d6
		move.b	d6,(a2,d7.l)
		rts

		cnop	0,4
clear_divider:	move.b	#0,(a2,d7.l)
		rts

		cnop	0,4
sio_register:	move.b	d6,(a2,d7.l)
		rts

		cnop	0,4
sio_control:	move.b	d6,(a2,d7.l)
		btst	#7,d6
		bne.s	sio_control_start
		rts

		cnop	0,4
sio_control_start:
		btst	#0,d6
		beq.s	sio_control_start_external

;		move.b	#$ff,-1(a2,d7.l)			;serial off!
		move.b	#8,transfer_counter
		rts

sio_control_start_external:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		a rom write has occurred! 8O
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
no_write:
rom_write:	rts					;exit the rom write.

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		memory related routines
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
dma_execute:	move.l	a5,-(SP)
		and.l	#$ff,d6				;d6 = the address (.B).
		cmp.w	#$f1,d6
		ble.s	dma_start_ok
		sub.b	#$f1,d6

dma_start_ok:
;		bchg.b	#1,$bfe001

		tst.b	d6
		bge.s	dma_rom
dma_ram:	move.l	a2,a5				;do a ram read.
		bra.s	dma_move
dma_rom:	move.l	a3,a5				;do a rom read.

dma_move:	lsl.l	#8,d6				;input fixed.
		add.l	d6,a5				;a5 = input.
		move.l	a2,a6				;output is in ram.
		add.l	#$fe00,a6			;a6 = output (oam).
		moveq.l	#40-1,d7
dma_execute_mv:	move.l	(a5)+,d6
		and.l	#$fffffff0,d6
		and.l	#$0000000f,(a6)
		or.l	d6,(a6)
		addq.l	#4,a6
		dbra	d7,dma_execute_mv		;execute dma move.
		move.l	(SP)+,a5
		rts

		cnop	0,4
do_joystick:
		IFGT	GAMEBOY_DEBUG
		bsr.w	debug_joypad_wanted
		ENDIF

		cmp.b	#$03,d6				;type request?
		beq.s	do_joystick_type_request	;yes.

		btst	#5,d6
		beq.s	do_joystick_but
		btst	#4,d6
		beq.s	do_joystick_dir

		or.b	#%00001111,d6			;both keylines are disabled.
		move.b	d6,(a2,d7.l)
		rts

		cnop	0,4
do_joystick_but:btst	#4,d6
		beq.s	do_joystick_both

		move.l	d5,-(SP)
		move.b	buttons_byte,d5
		and.b	#%11110000,d6
		and.b	#%00001111,d5
		or.b	d6,d5
		move.b	d5,(a2,d7.l)
		move.l	(SP)+,d5
		rts

		cnop	0,4
do_joystick_type_request:
		move.b	#$f0,d6				;normal gameboy.

do_joystick_both:
		movem.l	d5/d4,-(SP)
		move.b	directions_byte,d4
		move.b	buttons_byte,d5
		eor.b	#%11111111,d4
		eor.b	#%11111111,d5
		and.b	#%11110000,d6
		or.b	d4,d5
		or.b	d6,d5
		eor.b	#%00001111,d5
		move.b	d5,(a2,d7.l)
		movem.l	(SP)+,d5/d4
		rts

		cnop	0,4
do_joystick_dir:btst	#5,d6
		beq.s	do_joystick_both

		move.l	d5,-(SP)
		move.b	directions_byte,d5
		and.b	#%11110000,d6
		and.b	#%00001111,d5
		or.b	d6,d5
		move.b	d5,(a2,d7.l)
		move.l	(SP)+,d5
		rts

		cnop	0,4
ly_write:	move.b	#0,(a2,d7.l)
		rts

		cnop	0,4
lyc_write:	move.b	d6,(a2,d7.l)

		move.l	a2,a6
		add.l	#$ff00,a6

		btst.b	#7,$40(a6)			;lcd enabled?
		beq.s	kcmp_up				;no.

		btst.b	#1,irq_status_flags		;vbr effect?
		beq.s	kcmp_blank_no_filtering
		move.l	gb_scanlines,d7
;		beq.s	kcmp_up				;$00 is off limits.
		cmp.l	#$91,d7
		bge.s	kcmp_up				;$91-$99 are off limits, too.

kcmp_blank_no_filtering:
		move.b	$45(a6),d7			;d7 = ly compare / lyc.
		cmp.b	$44(a6),d7
		bne.s	klyc_clear			;not the same.
		bset.b	#2,$41(a6)			;coincidence occurred.

		btst.b	#6,$41(a6)			;interrupt?
		beq.s	kcmp_up				;nope. disabled.

		btst.b	#1,$ff(a6)			;lcd controller irq enabled?
		beq.s	kcmp_up				;no.

kcmp_starts:
		IFGT	GAMEBOY_DEBUG
		bsr.w	debug_blank
		ENDIF

		bset.b	#1,$0f(a6)			;lcd occurred.
		bset.b	#2,irq_status_flags		;lyc occurred.
		bra.s	kcmp_up				;skip vbr.

klyc_clear:	bclr.b	#2,$41(a6)			;no coincidence.
kcmp_up:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		mappers
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
mbc1_rom_switch:
;		tst.b	mbc1_status
;		bne.s	mbc1_in_4_32

		and.l	#$ff,d6
mbc1_in_16_8:	cmp.l	rom_banks_mask,d6
		ble.s	mbc1_rom_switch_in_limit
		sub.l	rom_banks_mask,d6
		bra.s	mbc1_in_16_8

mbc1_rom_switch_in_limit:

		IFGT	GAMEBOY_DEBUG
		move.b	d6,rom_bank_activated
		ENDIF

		lsl.l	#8,d6
		lsl.l	#7,d6					;d6 = d6 * $8000.
		add.l	rom_32k,d6				;rom pointer.
		move.l	d6,bank_address
		move.l	d6,a3					;update rom pointer.

		sub.l	z80_pc_base,a0
		move.w	a0,d7
		blt.s	pc_in_ram_mbc1
		add.l	d6,a0					;new rom address base.
		move.l	d6,z80_pc_base
		rts

		cnop	0,4
pc_in_ram_mbc1:	add.l	a2,a0					;old ram address base.
		rts

		cnop	0,4
mbc1_in_4_32:	rts

		cnop	0,4
mbc1_rom_mode_select:
		and.b	#%1,d6
		move.b	d6,mbc1_status
		rts

		cnop	0,4
mbc1_rom_switch_two_address_lines:
		tst.b	mbc1_status
		bne.s	mbc1_rom_switch_two_address_lines_4_32

								;support for 1 & 2
								;MB cartridges!!!
		rts						;not here. ;)

		cnop	0,4
mbc1_rom_switch_two_address_lines_4_32:
		rts

		cnop	0,4
mbc1_ram_protection:
		tst.b	mbc1_status
		beq.s	mbc1_ram_protection_no_changes

		and.b	#%00001111,d6
		move.b	d6,mbc1_ram_protection_status
		rts

		cnop	0,4
mbc1_ram_protection_no_changes:
		rts

		cnop	0,4
mbc1_ram_switch_with_two_rom_address_lines:
;		tst.b	mbc1_status
;		bne.s	mbc1_ram_switch_with_two_rom_address_lines_change_ram_bank
;								;support for 1 & 2
;								;MB cartridges!!!
;		rts						;not here. ;)

mbc1_ram_switch_with_two_rom_address_lines_change_ram_bank:
		and.l	ram_banks_mask,d6

		move.l	ram_bank_no,d7
		cmp.b	d6,d7
		beq.s	mbc1_exit

		lsl.l	#8,d7
		lsl.l	#5,d7					;8kb banks.
		add.l	memory_banks,d7				;base address.
		move.l	d6,ram_bank_no				;new bank number.

		move.l	d7,a6					;a6 = output.
		move.l	a5,-(SP)
		move.l	a2,a5
		add.l	#$A000,a5				;a5 = input.
		move.w	#$2000/4/4/2-1,d7
backup_ram:	move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		dbra	d7,backup_ram

		move.l	a2,a6
		add.l	#$A000,a6				;a6 = output.
		lsl.l	#8,d6
		lsl.l	#5,d6					;8kb banks.
		add.l	memory_banks,d6
		move.l	d6,a5					;a5 = input.

		move.w	#$2000/4/4/2-1,d7
restore_ram:	move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		dbra	d7,restore_ram

		moveq.l	#0,d7
		move.l	(SP)+,a5
mbc1_exit:	rts

		cnop	0,4
mbc2_ram_protection:
		and.b	#%1,d6
		move.b	d6,mbc2_ram_protection_status
		rts

		cnop	0,4
mbc2_rom_switch:and.l	#$ff,d6
		cmp.l	rom_banks_mask,d6
		ble.s	mbc2_rom_switch_in_limit
		sub.l	rom_banks_mask,d6
		bra.s	mbc2_rom_switch

mbc2_rom_switch_in_limit:

		IFGT	GAMEBOY_DEBUG
		move.b	d6,rom_bank_activated
		ENDIF

		lsl.l	#8,d6
		lsl.l	#7,d6					;d6 = d6 * $8000.
		add.l	rom_32k,d6				;rom pointer.
		move.l	d6,bank_address
		move.l	d6,a3					;update rom pointer.

		sub.l	z80_pc_base,a0
		move.w	a0,d7
		blt.s	pc_in_ram_mbc2
		add.l	d6,a0					;new rom address base.
		move.l	d6,z80_pc_base
		rts

		cnop	0,4
pc_in_ram_mbc2:	add.l	a2,a0					;old ram address base.
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		MBC5
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
mbc5_ramg:	rts						;external ram on/off.

		cnop	0,4
mbc5_romb0:	move.b	d6,mbc5_rom_bank0
		move.l	mbc5_rom_bank,d6

mbc5_romb0_switch:
		cmp.l	rom_banks_mask,d6
		ble.s	mbc5_romb0_switch_in_limit
		sub.l	rom_banks_mask,d6
		bra.s	mbc5_romb0_switch

mbc5_romb0_switch_in_limit:

		IFGT	GAMEBOY_DEBUG
		move.b	d6,rom_bank_activated
		ENDIF

		lsl.l	#8,d6
		lsl.l	#7,d6					;d6 = d6 * $8000.
		add.l	rom_32k,d6				;rom pointer.
		move.l	d6,bank_address
		move.l	d6,a3

		sub.l	z80_pc_base,a0
		move.w	a0,d7
		blt.s	pc_in_ram_mbc5_0
		add.l	d6,a0
		move.l	d6,z80_pc_base
		rts

		cnop	0,4
pc_in_ram_mbc5_0:
		add.l	a2,a0
		rts

		cnop	0,4
mbc5_romb1:	move.b	d6,mbc5_rom_bank1
		move.l	mbc5_rom_bank,d6

mbc5_romb1_switch:
		cmp.l	rom_banks_mask,d6
		ble.s	mbc5_romb1_switch_in_limit
		sub.l	rom_banks_mask,d6
		bra.s	mbc5_romb1_switch

mbc5_romb1_switch_in_limit:

		IFGT	GAMEBOY_DEBUG
		move.b	d6,rom_bank_activated
		ENDIF

		lsl.l	#8,d6
		lsl.l	#7,d6					;d6 = d6 * $8000.
		add.l	rom_32k,d6				;rom pointer.
		move.l	d6,bank_address
		move.l	d6,a3

		sub.l	z80_pc_base,a0
		move.w	a0,d7
		blt.s	pc_in_ram_mbc5_1
		add.l	d6,a0
		move.l	d6,z80_pc_base
		rts

		cnop	0,4
pc_in_ram_mbc5_1:
		add.l	a2,a0
		rts

		cnop	0,4
mbc5_ramb:	and.l	ram_banks_mask,d6
		move.l	ram_bank_no,d7
		cmp.b	d6,d7
		beq.s	mbc5_exit

		lsl.l	#8,d7
		lsl.l	#5,d7					;8kb banks.
		add.l	memory_banks,d7				;base address.
		move.l	d6,ram_bank_no				;new bank number.

		move.l	d7,a6					;a6 = output.
		move.l	a5,-(SP)
		move.l	a2,a5
		add.l	#$A000,a5				;a5 = input.
		move.w	#$2000/4/4/2-1,d7
backup_ram_x:	move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		dbra	d7,backup_ram_x

		move.l	a2,a6
		add.l	#$A000,a6				;a6 = output.
		lsl.l	#8,d6
		lsl.l	#5,d6					;8kb banks.
		add.l	memory_banks,d6
		move.l	d6,a5					;a5 = input.

		move.w	#$2000/4/4/2-1,d7
restore_ram_x:	move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		dbra	d7,restore_ram_x

		moveq.l	#0,d7
		move.l	(SP)+,a5
mbc5_exit:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		MBC3
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
mbc3_rom_switch:and.l	#$ff,d6
		cmp.l	rom_banks_mask,d6
		ble.s	mbc3_rom_switch_in_limit
		sub.l	rom_banks_mask,d6
		bra.s	mbc3_rom_switch

mbc3_rom_switch_in_limit:

		IFGT	GAMEBOY_DEBUG
		move.b	d6,rom_bank_activated
		ENDIF

		lsl.l	#8,d6
		lsl.l	#7,d6					;d6 = d6 * $8000.
		add.l	rom_32k,d6				;rom pointer.
		move.l	d6,bank_address
		move.l	d6,a3					;update rom pointer.

		sub.l	z80_pc_base,a0
		move.w	a0,d7
		blt.s	pc_in_ram_mbc3
		add.l	d6,a0					;new rom address base.
		move.l	d6,z80_pc_base
		rts

		cnop	0,4
pc_in_ram_mbc3:	add.l	a2,a0					;old ram address base.
		rts

		cnop	0,4
mbc3_ram_protection:
		move.b	d6,mbc3_ram_protection_status
mbc3_exit:	rts

		cnop	0,4
mbc3_ram_switch_change_ram_bank:
		and.l	ram_banks_mask,d6
		move.l	ram_bank_no,d7
		cmp.b	d7,d6
		beq.s	mbc3_exit

		lsl.l	#8,d7
		lsl.l	#5,d7					;8kb banks.
		add.l	memory_banks,d7				;base address.
		move.l	d6,ram_bank_no				;new bank number.

		move.l	d7,a6					;a6 = output.
		move.l	a5,-(SP)
		move.l	a2,a5
		add.l	#$A000,a5				;a5 = input.
		move.w	#$2000/4/4/2-1,d7
backup_ram_n:	move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		dbra	d7,backup_ram_n

		move.l	a2,a6
		add.l	#$A000,a6				;a6 = output.
		lsl.l	#8,d6
		lsl.l	#5,d6					;8kb banks.
		add.l	memory_banks,d6
		move.l	d6,a5					;a5 = input.

		move.w	#$2000/4/4/2-1,d7
restore_ram_n:	move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		move.l	(a5)+,(a6)+
		dbra	d7,restore_ram_n

		moveq.l	#0,d7
		move.l	(SP)+,a5
		rts

		cnop	0,4
mbc3_no_ram_switch:
		cmp.w	#$8,d6
		blt.s	mbc3_no_ram_switch_exit
		cmp.w	#$c,d6
		bgt.s	mbc3_no_ram_switch_exit

		sub.b	#$8,d6
		lea	mbc3_latched_sec,a6
		move.b	(a6,d6.w),d7
		move.w	#$2000-1,d6
		move.l	a2,a6
		add.l	#$a000,a6

mbc3_output_clock_data:
		move.b	d7,(a6)+
		dbra	d6,mbc3_output_clock_data

mbc3_no_ram_switch_exit:
		rts

		cnop	0,4
mbc3_latch_clock_counter_data:
		move.b	mbc3_latch_b,mbc3_latch_a
		move.b	d6,mbc3_latch_b

		tst.b	mbc3_latch_a
		bne.s	mbc3_latch_clock_counter_data_exit
		cmp.b	#1,d6
		bne.s	mbc3_latch_clock_counter_data_exit

mbc3_latch_clock_counter_data_execute_latch:
		move.b	mbc3_sec,mbc3_latched_sec
		move.b	mbc3_min,mbc3_latched_min
		move.b	mbc3_hrs,mbc3_latched_hrs
		move.b	mbc3_dayl,mbc3_latched_dayl
		move.b	mbc3_dayh,mbc3_latched_dayh

mbc3_latch_clock_counter_data_exit:
		rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		RETI back
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
reti_back:	tst.b	i_flag
		bne.w	no_more_irqs
		cmp.b	#1,z80_halt
		beq.w	no_more_irqs
		move.l	a2,a6
		add.l	#$ff0f,a6				;(interrupt flags).
		move.b	(a6),d7
		and.b	$f0(a6),d7				;IE & IF.
		and.b	#%11111,d7
		beq.s	no_more_irqs

		clr.b	z80_halt
		tst.b	z80_halt_bug
		beq.s	reti_stack_pc
		clr.b	z80_halt_bug
		subq.l	#1,a0					;EI; HALT returns to HALT.
reti_stack_pc:
		move.l	a0,d6					;stack the pc.
		sub.l	z80_pc_base,d6
		move.b	#1,i_flag				;disable interrupts.
		tst.b	z80_ei_return
		beq.s	reti_choose_irq
		move.b	#2,z80_ei_return			;RETI after EI may have already accepted an IRQ.

reti_choose_irq:
		btst	#0,d7
		bne.s	irq_i
		btst	#1,d7
		bne.s	irq_ii
		btst	#2,d7
		bne.s	irq_iii
		btst	#3,d7
		bne.w	irq_iv

irq_v:		bclr.b	#4,(a6)

		IFEQ	Z80_MODE
		bsr.w	write_d6_stackx
		ELSE
		subq.w	#2,d5
		ror.w	#8,d6
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$60(a3),a0
		move.l	a3,z80_pc_base				;rom base.

no_more_irqs:
		tst.b	z80_halt
		bne.s	reti_still_halted
		fetch_next_i
reti_still_halted:
		rts

		cnop	0,4
irq_i:		bclr.b	#0,(a6)

		IFEQ	Z80_MODE
		bsr.w	write_d6_stackx
		ELSE
		subq.w	#2,d5
		ror.w	#8,d6
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$40(a3),a0
		move.l	a3,z80_pc_base				;rom base.

		fetch_next_i

		cnop	0,4
irq_ii:		bclr.b	#1,(a6)

		IFEQ	Z80_MODE
		bsr.w	write_d6_stackx
		ELSE
		subq.w	#2,d5
		ror.w	#8,d6
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$48(a3),a0
		move.l	a3,z80_pc_base				;rom base.

		fetch_next_i

		cnop	0,4
irq_iii:	bclr.b	#2,(a6)

		IFEQ	Z80_MODE
		bsr.w	write_d6_stackx
		ELSE
		subq.w	#2,d5
		ror.w	#8,d6
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$50(a3),a0
		move.l	a3,z80_pc_base				;rom base.

		fetch_next_i

		cnop	0,4
irq_iv:		bclr.b	#3,(a6)

		IFEQ	Z80_MODE
		bsr.w	write_d6_stackx
		ELSE
		subq.w	#2,d5
		ror.w	#8,d6
		move.w	d6,(a2,d5.l)
		ENDIF

		lea	$58(a3),a0
		move.l	a3,z80_pc_base				;rom base.

		fetch_next_i

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		misc memory reads
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

READ_D2_TO_D6:	MACRO
		tst.w	d2
		blt.s	read_to_\@
		move.b	(a3,d2.l),d6
		bra.s	read_to_exit_\@
		cnop	0,4
read_to_\@:	move.b	(a2,d2.l),d6
read_to_exit_\@:	
		ENDM

READW_D5_TO_D7:	MACRO
		tst.w	d5
		blt.s	readw_to_\@
		move.w	(a3,d5.l),d7
		bra.s	readw_to_exit_\@
		cnop	0,4
readw_to_\@:	move.w	(a2,d5.l),d7
readw_to_exit_\@:	
		ENDM
