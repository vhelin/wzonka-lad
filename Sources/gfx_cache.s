; Cache allocation lives for one play session. AGA needs only the cache
; for its active renderer.
aga_sprite_cache_size = 160+2*144
aga_sprite_shadow_size = 2*144*112
aga_bg_cache_buffer = 19*5*64
aga_bg_cache_size = 4+2*aga_bg_cache_buffer
aga_layer_slot = 8+160+40*32

gfx_cache_open:
		clr.b	aga_cache_unavailable
		tst.b	cache_graphics
		beq.s	gfx_cache_open_done
		tst.b	old_render
		bne.s	gfx_cache_open_done
		lea	aga_sprite_cache,a0
		move.l	#aga_sprite_cache_size,d0
		tst.b	old_refresh
		bne.s	gfx_cache_open_frame
		bsr.s	gfx_cache_alloc
		beq.s	gfx_cache_open_done
		lea	aga_sprite_shadow,a0
		move.l	#aga_sprite_shadow_size,d0
		bra.s	gfx_cache_alloc
gfx_cache_open_frame:
		lea	aga_bg_cache,a0
		move.l	#aga_bg_cache_size,d0
		bsr.s	gfx_cache_alloc
		beq.s	gfx_cache_open_done
		lea	aga_layer_cache,a0
		move.l	#2*aga_layer_slot,d0
gfx_cache_alloc:
		move.l	a0,-(sp)
		move.l	#MEMF_FAST!MEMF_CLEAR,d1
		move.l	exec_base,a6
		jsr	AllocVec(a6)
		move.l	(sp)+,a0
		move.l	d0,(a0)
		seq	aga_cache_unavailable
		tst.l	d0
gfx_cache_open_done:
		rts

gfx_cache_close:
		move.l	aga_sprite_cache,d0
		bsr.s	gfx_cache_free
		clr.l	aga_sprite_cache
		move.l	aga_bg_cache,d0
		bsr.s	gfx_cache_free
		clr.l	aga_bg_cache
		move.l	aga_sprite_shadow,d0
		bsr.s	gfx_cache_free
		clr.l	aga_sprite_shadow
		move.l	aga_layer_cache,d0
		bsr.s	gfx_cache_free
		clr.l	aga_layer_cache
		clr.l	aga_bg_motion
		clr.l	aga_bg_motion+4
		rts

gfx_cache_free:
		tst.l	d0
		beq.s	gfx_cache_free_done
		move.l	d0,a1
		move.l	exec_base,a6
		jsr	FreeVec(a6)
gfx_cache_free_done:
		rts

; Keep the legacy dirty flags: a row without a known mask gets a full clear.
gfx_cache_invalidate:
		movem.l	d0/a0,-(sp)
		clr.l	aga_bg_motion
		clr.l	aga_bg_motion+4
		move.l	aga_layer_cache,d0
		beq.s	gfx_cache_invalidate_bg
		move.l	d0,a0
		clr.b	(a0)
		clr.b	aga_layer_slot(a0)
gfx_cache_invalidate_bg:
		move.l	aga_bg_cache,d0
		beq.s	gfx_cache_invalidate_sprites
		move.l	d0,a0
		clr.l	(a0)
gfx_cache_invalidate_sprites:
		move.l	aga_sprite_cache,d0
		beq.s	gfx_cache_invalidated
		move.l	d0,a0
		lea	160(a0),a0
		moveq.l	#(2*144)/4-1,d0
gfx_cache_clear_masks:
		clr.l	(a0)+
		dbra	d0,gfx_cache_clear_masks
gfx_cache_invalidated:
		movem.l	(sp)+,d0/a0
		rts

; Return Z on a hit. Each buffer keeps its own exact sprite inputs.
aga_layer_check:
		move.l	aga_layer_cache,a5
		move.l	aga_map_inactive,d0
		cmp.l	aga_map_I,d0
		beq.s	aga_layer_slot_ready
		lea	aga_layer_slot(a5),a5
aga_layer_slot_ready:
		move.l	lcd_control,d7
		and.b	#6,d7
		move.l	gb_memory,a4
		add.l	#$fe00,a4
		tst.b	(a5)
		beq.s	aga_layer_miss
		cmp.b	1(a5),d7
		bne.s	aga_layer_miss
		move.l	bg_scroll_x,d0
		cmp.l	4(a5),d0
		bne.s	aga_layer_miss
		btst	#1,d7
		beq.w	aga_layer_hit
		move.l	a4,a0
		lea	8(a5),a1
		moveq.l	#39,d0
aga_layer_oam_check:
		cmpm.l	(a0)+,(a1)+
		bne.s	aga_layer_miss
		dbra	d0,aga_layer_oam_check
		moveq.l	#0,d6
		bra.s	aga_layer_tiles
aga_layer_miss:
		st	(a5)
		move.b	d7,1(a5)
		move.l	bg_scroll_x,4(a5)
		btst	#1,d7
		beq.s	aga_layer_changed
		move.l	a4,a0
		lea	8(a5),a1
		moveq.l	#39,d0
aga_layer_oam_save:
		move.l	(a0)+,(a1)+
		dbra	d0,aga_layer_oam_save
		moveq.l	#1,d6
aga_layer_tiles:
		move.l	gb_memory,a3
		add.l	#$8000,a3
		lea	8+160(a5),a2
		moveq.l	#39,d0
		moveq.l	#3,d5
		moveq.l	#-1,d4
		btst	#2,d7
		beq.s	aga_layer_tile
		moveq.l	#7,d5
		moveq.l	#-2,d4
aga_layer_tile:
		tst.b	(a4)
		beq.s	aga_layer_tile_next
		tst.b	1(a4)
		beq.s	aga_layer_tile_next
		tst.b	3(a4)
		bpl.s	aga_layer_tile_get
		move.l	lcd_control,d1
		btst	#0,d1
		bne.s	aga_layer_priority
aga_layer_tile_get:
		moveq.l	#0,d1
		move.b	2(a4),d1
		and.b	d4,d1
		lsl.w	#4,d1
		lea	(a3,d1.w),a0
		move.l	a2,a1
		move.w	d5,d2
		tst.b	d6
		bne.s	aga_layer_tile_save
aga_layer_tile_check:
		cmpm.l	(a0)+,(a1)+
		bne.s	aga_layer_reload
		dbra	d2,aga_layer_tile_check
		bra.s	aga_layer_tile_next
aga_layer_tile_save:
		move.l	(a0)+,(a1)+
		dbra	d2,aga_layer_tile_save
aga_layer_tile_next:
		addq.l	#4,a4
		lea	32(a2),a2
		dbra	d0,aga_layer_tile
		tst.b	d6
		rts
aga_layer_reload:
		move.l	gb_memory,a4
		add.l	#$fe00,a4
		bra.w	aga_layer_miss
aga_layer_priority:
		clr.b	(a5)				;the raw BG/window is not in this cache key.
aga_layer_changed:
		moveq.l	#1,d0
		rts
aga_layer_hit:
		moveq.l	#0,d0
		rts
