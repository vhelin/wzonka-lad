
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
		move.l	a5,d6					;test cycles left.
		ble.s	f_xit\@
		IFGT	GAMEBOY_DEBUG
		jmp	debug_output
		ELSE
		IFEQ	Z80_MODE
		jmp	z80_fetch_linear
		ELSE
		move.b	(a0)+,d7
		lsl.w	#8,d7					;d7 = d7*256.
		jmp	(a1,d7.l)				;jump and emulate.
		ENDIF
		ENDIF
f_xit\@:	rts
		ENDM

; FAST/WARP only: repair a taken JR below $0000 without taxing other opcodes.
jr_finish:	MACRO
		cmpa.l	z80_pc_base,a0
		blo.w	z80_fetch_jr_wrapped
		fetch_next_i
		ENDM

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
		cmp.b	#3,z80_ei_return
		beq.s	finish_irq_write
		subq.l	#1,d6					;remove the temporary one-cycle budget.
finish_irq_write:
		add.l	z80_cycles_left,d6
		move.l	d6,a5
		cmp.b	#1,z80_ei_return
		bne.s	finish_ei_cancelled
		clr.b	i_flag
finish_ei_cancelled:
		clr.b	z80_ei_return
		IFEQ	GAMEBOY_USERS
		bsr.l	sound_div_sync
		IFLE	Z80_MODE
		bsr.l	timer_replan
		ENDIF
		ENDIF
		bra.w	reti_back

z80_start:	move.l	bank_address,a0				;the rom area.
		lea	z80_optcode_00,a1			;xx optcodes.
		move.l	gb_memory,a2				;pointer to pseudo ram.
		move.l	a0,a3					;a3 = base pointer.
		move.l	a0,z80_pc_base
		IFEQ	Z80_MODE
; The longest instruction can read two operand bytes past $FFFF.
; Every cached ROM bank view starts with the same fixed ROM bank.
		move.w	(a3),$10000(a2)
		ENDIF
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
		clr.b	z80_irq_cycles

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

z80_run_slice_first:
		IFEQ	GAMEBOY_USERS
		bra.l	sound_cpu_lcd_first
		ELSE
		bra.s	z80_run_slice
		ENDIF

z80_run_slice_transfer:
		IFEQ	GAMEBOY_USERS
		move.l	z80_cycles,d6
		subq.l	#1,d6
		bra.l	sound_cpu_begin_slice
		ELSE
		bra.s	z80_run_slice
		ENDIF

z80_run_slice_last:
		IFEQ	GAMEBOY_USERS
		move.l	z80_cycles,d6
		addq.l	#7,d6
		bra.l	sound_cpu_begin_slice
		ELSE
		bra.s	z80_run_slice
		ENDIF
z80_run_slice:
		IFEQ	GAMEBOY_USERS
		bra.l	sound_cpu_slice
		ELSE
		tst.b	z80_halt
		bne.s	cpu_slice_done
		bsr.w	z80_cpu_next_sweep
cpu_slice_ei:	tst.b	z80_ei_return
		beq.s	cpu_slice_done
		bsr.l	finish_ei
		bra.s	cpu_slice_ei
cpu_slice_done:	rts
		ENDIF

; Keep ordinary FAST/WARP loads direct; synchronize only on clock I/O.
CLOCK_READ_A:	MACRO
		IFEQ	GAMEBOY_USERS
		cmp.w	#$ff04,\1
		IFLT	Z80_MODE
		blo.s	clock_read_a_raw\@
		cmp.w	#$ff0f,\1
		bhi.s	clock_read_a_raw\@
		ELSE
		bne.s	clock_read_a_raw\@
		ENDIF
		bsr.l	sound_div_sync
clock_read_a_raw\@:
		ENDIF
		move.b	(a2,\1.l),d3
		ENDM

LDH_READ_A:	MACRO
		IFEQ	GAMEBOY_USERS
		cmp.w	#$ff41,d7
		bne.s	ldh_read_clock\@
		bsr.l	lcd_stat_read
		move.b	d6,d3
		bra.s	ldh_read_done\@
ldh_read_clock\@:
		ENDIF
		CLOCK_READ_A d7
ldh_read_done\@:
		ENDM

z80_fetch_opcode:
		IFEQ	Z80_MODE
		move.l	a0,d6
		sub.l	z80_pc_base,d6
		cmp.l	#$10000,d6
		blo.s	z80_fetch_first_raw
		bsr.s	z80_map_pc
z80_fetch_first_raw:
		ENDIF
		move.b	(a0)+,d7
		tst.b	z80_halt_bug
		beq.s	z80_fetch_dispatch
		clr.b	z80_halt_bug
		subq.l	#1,a0					;HALT bug survives a sweep boundary.
z80_fetch_dispatch:
		lsl.w	#8,d7
		jmp	(a1,d7.l)

		IFEQ	Z80_MODE
z80_fetch_linear:
		move.l	a0,d6
		sub.l	z80_pc_base,d6
		cmp.l	#$10000,d6
		bhs.s	z80_fetch_wrapped
z80_fetch_linear_raw:
		move.b	(a0)+,d7
		lsl.w	#8,d7
		jmp	(a1,d7.l)

z80_fetch_wrapped:
		bsr.s	z80_map_pc
		bra.s	z80_fetch_linear_raw
		ENDIF

z80_map_pc:	and.l	#$ffff,d6
		btst	#15,d6
		beq.s	z80_map_pc_rom
		move.l	a2,z80_pc_base
		lea	(a2,d6.l),a0
		rts
z80_map_pc_rom:	move.l	a3,z80_pc_base
		lea	(a3,d6.l),a0
		rts

		IFEQ	Z80_MODE
; A bank write can occur after reading an operand across $FFFF.
mbc_map_pc:	move.l	a0,d6
		sub.l	z80_pc_base,d6
		bra.s	z80_map_pc
		ELSE
z80_fetch_jr_wrapped:
		move.l	a0,d6
		sub.l	z80_pc_base,d6
		bsr.s	z80_map_pc
		fetch_next_i
		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		push - command memory supervisor
;		INPUT:
;		d6	= h.B, l.B (a 16-bit value to be pushed).
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
write_d6_stack:	bsr.s	write_d6_stackx
		fetch_next_i

		cnop	0,4
write_irq_stack:move.b	#1,i_flag				;disable IME before pushing an interrupt's PC.
		move.b	#5,z80_irq_cycles			;the scanline dispatcher runs before the slice budget is set.
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
lcd_mode_write:	lea	$ff40(a2),a6
		btst	#7,d6
		beq.s	lcd_mode_off
		btst.b	#7,(a6)
		bne.s	lcd_mode_write_done
		move.b	#1,lcd_blank_phase
		st	lcd_start_line
		clr.b	irq_status_flags
; The first line starts in mode 0, but only the LY comparator is active.
		clr.b	4(a6)
		and.b	#$fc,1(a6)
		tst.b	5(a6)
		beq.s	lcd_mode_matching
		bclr.b	#2,1(a6)
		bra.s	lcd_mode_started
lcd_mode_matching:
		bset.b	#2,1(a6)
		bne.s	lcd_mode_started		;the retained match was already set.
		btst.b	#6,1(a6)
		beq.s	lcd_mode_started
		bset.b	#1,$ff0f(a2)
		bset.b	#2,irq_status_flags
lcd_mode_started:
		IFEQ	GAMEBOY_USERS
		move.b	d6,(a6)
		bra.l	lcd_start_request
		ELSE
		bra.s	lcd_mode_write_done
		ENDIF
lcd_mode_off:	st	lcd_blank_phase
		clr.w	window_y_state
		clr.b	lcd_start_line
		clr.b	4(a6)
		and.b	#$fc,1(a6)			;coincidence is retained while off.
lcd_mode_write_done:
		move.b	d6,(a6)
		rts

		cnop	0,4
lcd_protect:	lea	(a2,d7.l),a6
		and.b	#%01111000,d6
		and.b	#%10000111,(a6)
		or.b	d6,(a6)

		btst.b	#7,$ff40(a2)
		beq.s	lcd_write_no_irq
		move.b	(a6),d6
		and.b	#%11,d6
		beq.s	lcd_write_irq
		cmp.b	#1,d6
		bne.s	lcd_write_no_irq

lcd_write_irq:	move.l	a2,a6			;bug in hardware.
		add.l	#$ff0f,a6
		bset.b	#1,(a6)			;lcd irq is about to happen.
		bra.s	irq_check_after_write

lcd_write_no_irq:
		rts

		cnop	0,4
irq_protect_0f:
irq_protect_ff:
		IFEQ	GAMEBOY_USERS
		bsr.l	sound_div_sync
		ENDIF
		or.b	#%11100000,d6
		move.b	d6,(a2,d7.l)
		IFEQ	GAMEBOY_USERS
		IFLE	Z80_MODE
		bsr.s	irq_check_after_write
		bra.l	timer_replan
		ENDIF
		ENDIF

irq_check_after_write:
		tst.b	i_flag
		bne.s	irq_write_done
		tst.b	z80_ei_return			;a deferred check is already armed.
		bne.s	irq_write_done
		move.b	$ff0f(a2),d6
		and.b	$ffff(a2),d6
		and.b	#$1f,d6
		beq.s	irq_write_done
; Let the writing opcode finish, then check IRQs before fetching again.
		move.l	a5,z80_cycles_left
		sub.l	a5,a5
		move.b	#3,z80_ei_return
irq_write_done:
		rts

		cnop	0,4
timc_protect:
		IFLE	Z80_MODE
		IFEQ	GAMEBOY_USERS
		bsr.l	sound_div_sync
		move.w	timer_bit,-(SP)
		bsr.l	timer_configure
		or.b	#$f8,d6
		move.b	d6,(a2,d7.l)
		move.w	(SP)+,d6
		and.w	sound_div_counter,d6
		beq.s	timer_control_done
		move.w	timer_bit,d6
		and.w	sound_div_counter,d6
		bne.s	timer_control_done
		bsr.l	timer_extra_tick
timer_control_done:
		bra.l	timer_replan
		ENDIF
		ENDIF
		or.b	#%11111000,d6
		move.b	d6,(a2,d7.l)
		rts

		IFLE	Z80_MODE
timer_write_count:
		IFEQ	GAMEBOY_USERS
		bsr.l	sound_div_sync
		cmp.b	#2,timer_phase
		beq.s	timer_count_done
		clr.b	timer_phase
		move.b	d6,$ff05(a2)
		bra.l	timer_replan
timer_count_done:
		rts
		ELSE
		bra.w	gb_mem_wr
		ENDIF
timer_write_modulo:
		IFEQ	GAMEBOY_USERS
		bsr.l	sound_div_sync
		move.b	d6,$ff06(a2)
		cmp.b	#2,timer_phase
		bne.s	timer_modulo_done
		move.b	d6,$ff05(a2)
		bra.l	timer_replan
timer_modulo_done:
		rts
		ELSE
		bra.w	gb_mem_wr
		ENDIF
		ENDIF

		cnop	0,4
clear_divider:
		IFEQ	GAMEBOY_USERS
		bsr.l	sound_div_reset
		move.b	#0,(a2,d7.l)
		IFLE	Z80_MODE
		bra.l	timer_replan
		ENDIF
		ENDIF
		move.b	#0,(a2,d7.l)
		rts

		cnop	0,4
sio_register:	move.b	d6,(a2,d7.l)
		rts

		cnop	0,4
sio_control:	or.b	#$7e,d6				;DMG SC bits 1-6 always read high.
		move.b	d6,(a2,d7.l)
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
		move.b	d6,$ff46(a2)
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
; DMG drawing ignores the low attribute bits, but OAM stores them.
dma_execute_mv:	move.l	(a5)+,(a6)+
		dbra	d7,dma_execute_mv		;execute dma move.
		move.l	(SP)+,a5
		rts

		cnop	0,4
do_joystick:
		IFGT	GAMEBOY_DEBUG
		bsr.w	debug_joypad_wanted
		ENDIF

		move.l	a6,-(SP)
		lea	(a2,d7.l),a6
		cmp.b	#$03,d6				;legacy Game Boy type probe.
		beq.s	do_joystick_type_request
		bsr.s	joypad_update
		move.l	(SP)+,a6
		bra.w	irq_check_after_write

do_joystick_type_request:
		move.l	d7,-(SP)
		move.b	#$c0,d6
		bsr.s	joypad_lines
		or.b	#$30,d6
		move.b	d6,(a6)
		move.l	(SP)+,d7
		move.l	(SP)+,a6
		rts

; Compare the visible active-low lines, not the raw host input bytes.
; A falling edge requests IF even when IE masks the interrupt.
joypad_update:	move.l	d7,-(SP)
		bsr.s	joypad_lines
		move.b	(a6),d7
		move.b	d6,(a6)
		not.b	d6
		and.b	d7,d6
		move.l	(SP)+,d7
		and.b	#$0f,d6
		beq.s	joypad_update_done
		bset.b	#4,$0f(a6)
		IFGT	GAMEBOY_DEBUG
		jmp	debug_p10
		ENDIF
joypad_update_done:
		rts

joypad_lines:	or.b	#$cf,d6			;P1 bits 7-6 read high; rebuild bits 3-0 below.
		btst	#5,d6
		bne.s	joypad_directions
		move.b	buttons_byte,d7
		or.b	#$f0,d7
		and.b	d7,d6
joypad_directions:
		btst	#4,d6
		bne.s	joypad_lines_done
		move.b	directions_byte,d7
		or.b	#$f0,d7
		and.b	d7,d6
joypad_lines_done:
		rts

		cnop	0,4
ly_write:	move.b	#0,(a2,d7.l)
		rts

		cnop	0,4
lyc_write:	move.b	d6,(a2,d7.l)

		move.l	a2,a6
		add.l	#$ff00,a6

		btst.b	#7,$40(a6)			;lcd enabled?
		beq.s	lcd_lyc_done
		bsr.s	lcd_lyc_compare
		bra.w	irq_check_after_write

lcd_lyc_compare:
		move.b	$45(a6),d7			;d7 = ly compare / lyc.
		cmp.b	$44(a6),d7
		bne.s	lcd_lyc_clear
		bset.b	#2,$41(a6)			;coincidence occurred.
		bne.s	lcd_lyc_done			;no new edge (e.g. LY stays 0 into line 0).

		btst.b	#6,$41(a6)			;interrupt?
		beq.s	lcd_lyc_done

		IFLE	Z80_MODE
		btst.b	#4,$41(a6)
		beq.s	lcd_lyc_request
		cmp.l	#145,gb_scanlines
		bhs.s	lcd_lyc_done			;enabled mode 1 already holds STAT high.
		ENDIF

lcd_lyc_request:
		IFGT	GAMEBOY_DEBUG
		bsr.w	debug_blank
		ENDIF

		bset.b	#1,$0f(a6)			;lcd occurred.
		bset.b	#2,irq_status_flags		;lyc occurred.
		rts

lcd_lyc_clear:	bclr.b	#2,$41(a6)			;no coincidence.
lcd_lyc_done:	rts

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		mappers
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
mbc1_rom_switch:
		cmp.l	#$3f,rom_banks_mask
		blo.s	mbc1_rom_switch_legacy
		and.l	#$1f,d6
		bne.s	mbc1_rom_low_valid
		moveq.l	#1,d6
mbc1_rom_low_valid:
		bsr.w	mbc1_active_rom_bank
		and.l	#$60,d7
		or.l	d7,d6
		bra.s	mbc1_rom_switch_in_limit

mbc1_rom_switch_legacy:
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

		IFEQ	Z80_MODE
		bra.l	mbc_map_pc
		ELSE
		sub.l	z80_pc_base,a0
		move.w	a0,d7
		blt.s	pc_in_ram_mbc1
		add.l	d6,a0					;new rom address base.
		move.l	d6,z80_pc_base
		rts

		cnop	0,4
pc_in_ram_mbc1:	add.l	a2,a0					;old ram address base.
		rts
		ENDIF

		cnop	0,4
mbc1_rom_mode_select:
		and.b	#%1,d6
		move.b	d6,mbc1_status
		rts

		cnop	0,4
mbc1_rom_switch_two_address_lines:
		cmp.l	#$3f,rom_banks_mask
		blo.s	mbc1_rom_high_done
		and.l	#3,d6
		lsl.w	#5,d6
		bsr.s	mbc1_active_rom_bank
		and.l	#$1f,d7
		bne.s	mbc1_rom_high_low_valid
		moveq.l	#1,d7				;Initial view 0 also shows bank 1 at $4000.
mbc1_rom_high_low_valid:
		or.l	d7,d6
		and.l	rom_banks_mask,d6
		bra.w	mbc1_rom_switch_in_limit
mbc1_rom_high_done:
		rts

; The active view encodes both effective bank fields and is already saved in GBS.
mbc1_active_rom_bank:
		move.l	bank_address,d7
		sub.l	rom_32k,d7
		lsr.l	#8,d7
		lsr.l	#7,d7
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

		IFEQ	Z80_MODE
		bra.l	mbc_map_pc
		ELSE
		sub.l	z80_pc_base,a0
		move.w	a0,d7
		blt.s	pc_in_ram_mbc2
		add.l	d6,a0					;new rom address base.
		move.l	d6,z80_pc_base
		rts

		cnop	0,4
pc_in_ram_mbc2:	add.l	a2,a0					;old ram address base.
		rts
		ENDIF

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		MBC5
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

		cnop	0,4
mbc5_ramg:	rts						;external ram on/off.

		cnop	0,4
mbc5_romb0:	move.b	d6,mbc5_rom_bank0
		bra.s	mbc5_rom_switch

		cnop	0,4
mbc5_romb1:	and.b	#1,d6
		move.b	d6,mbc5_rom_bank1
mbc5_rom_switch:
		move.l	mbc5_rom_bank,d6
		and.l	rom_banks_mask,d6

		IFGT	GAMEBOY_DEBUG
		move.b	d6,rom_bank_activated
		ENDIF

		lsl.l	#8,d6
		lsl.l	#7,d6					;d6 = d6 * $8000.
		add.l	rom_32k,d6				;rom pointer.
		move.l	d6,bank_address
		move.l	d6,a3

		IFEQ	Z80_MODE
		bra.l	mbc_map_pc
		ELSE
		sub.l	z80_pc_base,a0
		move.w	a0,d7
		blt.s	pc_in_ram_mbc5
		add.l	d6,a0
		move.l	d6,z80_pc_base
		rts

		cnop	0,4
pc_in_ram_mbc5:
		add.l	a2,a0
		rts
		ENDIF

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

		IFEQ	Z80_MODE
		bra.l	mbc_map_pc
		ELSE
		sub.l	z80_pc_base,a0
		move.w	a0,d7
		blt.s	pc_in_ram_mbc3
		add.l	d6,a0					;new rom address base.
		move.l	d6,z80_pc_base
		rts

		cnop	0,4
pc_in_ram_mbc3:	add.l	a2,a0					;old ram address base.
		rts
		ENDIF

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
		subq.l	#5,a5
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

		bsr.w	write_d6_stackx

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

		bsr.w	write_d6_stackx

		lea	$40(a3),a0
		move.l	a3,z80_pc_base				;rom base.

		fetch_next_i

		cnop	0,4
irq_ii:		bclr.b	#1,(a6)

		bsr.w	write_d6_stackx

		lea	$48(a3),a0
		move.l	a3,z80_pc_base				;rom base.

		fetch_next_i

		cnop	0,4
irq_iii:	bclr.b	#2,(a6)

		bsr.w	write_d6_stackx

		lea	$50(a3),a0
		move.l	a3,z80_pc_base				;rom base.

		fetch_next_i

		cnop	0,4
irq_iv:		bclr.b	#3,(a6)

		bsr.w	write_d6_stackx

		lea	$58(a3),a0
		move.l	a3,z80_pc_base				;rom base.

		fetch_next_i

;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		misc memory reads
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

; Only FULL RAM data reads need an I/O bus check; ROM reads stay direct.
; The last argument is the number of M-cycles after the read in the opcode.
READ_RAM_BYTE:	MACRO
		IFEQ	Z80_MODE
		cmp.w	#$ff04,\1
		blo.s	read_ram_raw\@
		cmp.w	#$ff42,\1
		bhs.s	read_ram_raw\@
		move.w	\1,d6
		IFGT	\3
		addq.l	#\3,a5
		ENDIF
		bsr.l	cpu_timed_read
		IFGT	\3
		subq.l	#\3,a5
		ENDIF
		move.b	d6,\2
		bra.s	read_ram_done\@
read_ram_raw\@:
		ENDIF
		move.b	(a2,\1.l),\2
read_ram_done\@:
		ENDM

READ_D2_TO_D6:	MACRO
		tst.w	d2
		blt.s	read_to_\@
		move.b	(a3,d2.l),d6
		bra.s	read_to_exit_\@
		cnop	0,4
read_to_\@:	READ_RAM_BYTE d2,d6,\1
read_to_exit_\@:	
		ENDM

READ_RAM_STACK:	MACRO
		IFEQ	Z80_MODE
		cmp.w	#$ff03,d5
		blo.s	read_stack_raw\@
		cmp.w	#$ff42,d5
		bhs.s	read_stack_raw\@
		addq.l	#\2,a5
		bsr.l	cpu_timed_stack
		IFGT	\2-1
		subq.l	#\2-1,a5
		ENDIF
		move.w	d6,\1
		bra.s	read_stack_done\@
read_stack_raw\@:
		ENDIF
		move.w	(a2,d5.l),\1
read_stack_done\@:
		ENDM

READW_D5_TO_D7:	MACRO
		tst.w	d5
		blt.s	readw_to_\@
		move.w	(a3,d5.l),d7
		bra.s	readw_to_exit_\@
		cnop	0,4
readw_to_\@:
		IFEQ	Z80_MODE
		READ_RAM_STACK d7,\1
		ELSE
		move.w	(a2,d5.l),d7
		ENDIF
readw_to_exit_\@:	
		ENDM
