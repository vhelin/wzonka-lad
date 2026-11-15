
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		menu items for menu window
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

menu_favourite:	dc.l	0				;pointer to next menu.
		dc.w	240				;x.
		dc.w	0				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	1				;1 = on / 0 = off.
		dc.l	menu_favo_name			;name.
		dc.l	menu_f_I
		dc.w	0,0,0,0

menu_favo_name:	dc.b	"Favourites",0
		even

menu_f_I:	dc.l	menu_f_II			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	0				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_I_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_II:	dc.l	menu_f_III			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*1				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_II_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_III:	dc.l	menu_f_IV			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*2				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_III_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_IV:	dc.l	menu_f_V			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*3				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_IV_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_V:	dc.l	menu_f_VI			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*4				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_V_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_VI:	dc.l	menu_f_VII			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*5				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_VI_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_VII:	dc.l	menu_f_VIII			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*6				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_VII_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_VIII:	dc.l	menu_f_IX			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*7				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_VIII_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_IX:	dc.l	zenu_f_X			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*8				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_IX_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
zenu_f_X:	dc.l	menu_f_1I			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*9				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_X_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_1I:	dc.l	menu_f_1II			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*10				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_1I_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_1II:	dc.l	menu_f_1III			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*11				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_1II_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_1III:	dc.l	menu_f_1IV			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*12				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_1III_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_1IV:	dc.l	menu_f_1V			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*13				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_1IV_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_1V:	dc.l	menu_f_1VI			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*14				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_1V_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_1VI:	dc.l	menu_f_1VII			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*15				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_1VI_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_1VII:	dc.l	menu_f_1VIII			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*16				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_1VII_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_1VIII:	dc.l	menu_f_1IX			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*17				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_1VIII_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
menu_f_1IX:	dc.l	zenu_f_1X			;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*18				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_1IX_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0
zenu_f_1X:	dc.l	0				;pointer to next menu item.
		dc.w	0				;x.
		dc.w	9*19				;y.
		dc.w	240				;dx.
		dc.w	9				;dy.
		dc.w	ITEMTEXT!ITEMENABLED!HIGHCOMP
		dc.l	0
		dc.l	menu_f_1X_text
		dc.l	0
		dc.b	0
		even
		dc.l	0				;submenu.
		dc.l	0

menu_f_I_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_I_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_II_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_II_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_III_text:dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_III_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_IV_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_IV_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_V_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_V_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_VI_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_VI_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_VII_text:dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_VII_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_VIII_text:
		dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_VIII_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_IX_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_IX_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_X_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_X_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_1I_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_1I_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_1II_text:dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_1II_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_1III_text:
		dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_1III_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_1IV_text:dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_1IV_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_1V_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_1V_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_1VI_text:dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_1VI_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_1VII_text:
		dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_1VII_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_1VIII_text:
		dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_1VIII_txt:dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_1IX_text:dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_1IX_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
menu_f_1X_text:	dc.b	1				;text colour.
		dc.b	2				;background colour.
		dc.b	0				;draw mode.
		dc.b	0				;even.
		dc.w	0				;x.
		dc.w	1				;y.
		dc.l	font_attr			;text font.
men_f_1X_txt:	dc.l	0				;the text.
		dc.l	0				;pointer to next text.
