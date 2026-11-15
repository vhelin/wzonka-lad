
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu items for menu window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_recent:	dc.l	0				;pointer to next menu.
		dc.w	0				;x.
		dc.w	0				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	1				;1 = on / 0 = off.
		dc.l	menu_recn_name			;name.
		dc.l	menu_I
		dc.w	0,0,0,0

menu_recn_name:	dc.b	"Recent",0
		even

menu_I:		dc.l	menu_II				;pointer to next menu item.
		dc.w	0				;x.
		dc.w	0				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_I_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_II:	dc.l	menu_III			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*1				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_II_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_III:	dc.l	menu_IV				;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*2				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_III_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_IV:	dc.l	menu_V				;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*3				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_IV_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_V:		dc.l	menu_VI				;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*4				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_V_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_VI:	dc.l	menu_VII			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*5				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_VI_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_VII:	dc.l	menu_VIII			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*6				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_VII_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_VIII:	dc.l	menu_IX				;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*7				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_VIII_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_IX:	dc.l	zenu_X				;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*8				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_IX_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
zenu_X:		dc.l	menu_1I				;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*9				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_X_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_1I:	dc.l	menu_1II			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*10				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_1I_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_1II:	dc.l	menu_1III			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*11				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_1II_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_1III:	dc.l	menu_1IV			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*12				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_1III_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_1IV:	dc.l	menu_1V				;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*13				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_1IV_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_1V:	dc.l	menu_1VI			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*14				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_1V_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_1VI:	dc.l	menu_1VII			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*15				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_1VI_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_1VII:	dc.l	menu_1VIII			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*16				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_1VII_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_1VIII:	dc.l	menu_1IX			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*17				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_1VIII_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_1IX:	dc.l	zenu_1X				;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*18				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_1IX_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
zenu_1X:	dc.l	0				;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*19				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_1X_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0

menu_I_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_I_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_II_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_II_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_III_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_III_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_IV_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_IV_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_V_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_V_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_VI_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_VI_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_VII_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_VII_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_VIII_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_VIII_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_IX_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_IX_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_X_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_X_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_1I_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_1I_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_1II_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_1II_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_1III_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_1III_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_1IV_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_1IV_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_1V_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_1V_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_1VI_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_1VI_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_1VII_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_1VII_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_1VIII_text:dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_1VIII_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_1IX_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_1IX_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_1X_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_1X_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.

load_menu_tag:	dc.l	0
