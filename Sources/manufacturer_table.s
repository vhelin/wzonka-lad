
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
;		a list of cartridge manufacturers
;		.B	= the manufacturer id (0 = the end of the list).
;		.B	= name.
;		.B	= 0. the end of the name... etc...
;««««««««««««««««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

manufac_table:	DC.B	$3E
		DC.B	"GREMLIN GRAPHICS",0
		DC.B	$1A
		DC.B	"YANOMAN",0
		DC.B	$E3
		DC.B	"VARIE",0
		DC.B	$79
		DC.B	"ACCOLADE",0
		DC.B	$78
		DC.B	"T·HQ INC",0
		DC.B	$BA
		DC.B	"CULTURE BRAIN",0
		DC.B	$19
		DC.B	"S. C. P.",0
		DC.B	$8C
		DC.B	"VIC TOKAI",0
		DC.B	$00
		DC.B	"INFOCOM",0
		DC.B	$0C
		DC.B	"COCONUTS JAPAN",0
		DC.B	$6E
		DC.B	"ELITE",0
		DC.B	$9A
		DC.B	"NIHON BUSSAN CO., LTD",0
		DC.B	$4D
		DC.B	"MALIBU GAMES",0
		DC.B	$E9
		DC.B	"NATSUME",0
		DC.B	$5C
		DC.B	"TAXAN",0
		DC.B	$C8
		DC.B	"KOEI",0
		DC.B	$E2
		DC.B	"YUTAKA",0
		DC.B	$FB
		DC.B	"PSYGNOSIS",0
		DC.B	$41
		DC.B	"UBISOFT",0
		DC.B	$D7
		DC.B	"COPYA SYSTEM",0
		DC.B	$5B
		DC.B	"ROMSTAR INC",0
		DC.B	$AD
		DC.B	"TOHO CO., LTD",0
		DC.B	$B7
		DC.B	"SNK CORP",0
		DC.B	$71
		DC.B	"INTERPLAY",0
		DC.B	$CF
		DC.B	"ANGEL",0
		DC.B	$9B
		DC.B	"TECMO",0
		DC.B	$8E
		DC.B	"APE INC",0
		DC.B	$29
		DC.B	"SETA",0
		DC.B	$A4
		DC.B	"KONAMI",0
		DC.B	$B2
		DC.B	"BANDAI",0
		DC.B	$67
		DC.B	"OCEAN",0
		DC.B	$56
		DC.B	"LJN",0
		DC.B	$99
		DC.B	"ARC?",0
		DC.B	$01
		DC.B	"NINTENDO",0
		DC.B	$08
		DC.B	"CAPCOM",0
		DC.B	$38
		DC.B	"LAGUNA GMBH",0
		DC.B	$AF
		DC.B	"NAMCOT",0
		DC.B	$49
		DC.B	"IREM",0
		DC.B	$9C
		DC.B	"IMAGINEER",0
		DC.B	$A6
		DC.B	"KAWADA?",0
		DC.B	$B1
		DC.B	"NEXOFT",0
		DC.B	$51
		DC.B	"ACCLAIM",0
		DC.B	$60
		DC.B	"TITUS",0
		DC.B	$B6
		DC.B	"HAL",0
		DC.B	$0B
		DC.B	"COCONUTS",0
		DC.B	$54
		DC.B	"GAMETEK",0
		DC.B	$7F
		DC.B	"KEMCO",0
		DC.B	$C0
		DC.B	"TAITO",0
		DC.B	$E8
		DC.B	"ASMIK",0
		DC.B	$DA
		DC.B	"TOMY",0
		DC.B	$B1
		DC.B	"ASCII",0
		DC.B	$EB
		DC.B	"ATLUS",0
		DC.B	$9C
		DC.B	"IMAGINEER",0
		DC.B	$C2
		DC.B	"KEMCO",0
		DC.B	$D1
		DC.B	"SOFEL CO., LTD",0
		DC.B	$61
		DC.B	"VIRGIN",0
		DC.B	$BB
		DC.B	"SUNSOFT",0
		DC.B	$CE
		DC.B	"FCI",0
		DC.B	$B4
		DC.B	"ENIX",0
		DC.B	$BD
		DC.B	"IMAGESOFT",0
		DC.B	$0A
		DC.B	"JALECO",0
		DC.B	$DF
		DC.B	"ALTRON?",0
		DC.B	$A7
		DC.B	"TAKARA",0
		DC.B	$EE
		DC.B	"IGS?",0
		DC.B	$83
		DC.B	"LOZC?",0
		DC.B	$50
		DC.B	"ABSOLUTE ENTERTAINMENT",0
		DC.B	$DD
		DC.B	"NCS",0
		DC.B	$E5
		DC.B	"EPOCH CO., LTD",0
		DC.B	$CB
		DC.B	"VAP?",0
		DC.B	$C2
		DC.B	"KEMCO?",0
		DC.B	$BF
		DC.B	"SAMMY?",0
		DC.B	$18
		DC.B	"HUDSON SOFT",0
		DC.B	$CA
		DC.B	"PALCOM/ULTRA",0
		DC.B	$C5
		DC.B	"DATA EAST",0
		DC.B	$A9
		DC.B	"TECHNOS JAPAN",0
		DC.B	$D9
		DC.B	"BANPRESTO",0
		DC.B	$72
		DC.B	"BRODERBUND?",0
		DC.B	$7A
		DC.B	"TRIFFIX ENT?",0
		DC.B	$E1
		DC.B	"TOWACHIKI",0
		DC.B	$93
		DC.B	"TSUBURAVA",0
		DC.B	$C6
		DC.B	"TONKIN HOUSE",0
		DC.B	$CE
		DC.B	"PONY CANYON",0
		DC.B	$70
		DC.B	"INFOGRAMES",0
		DC.B	$8B
		DC.B	"BULLET-PROOF SOFTWARE",0
		DC.B	$55
		DC.B	"PARK PLACE?",0
		DC.B	$EA
		DC.B	"KING RECORDS?",0
		DC.B	$5D
		DC.B	"TRADEWEST",0
		DC.B	$6F
		DC.B	"ELECTROBRAIN",0
		DC.B	$AC
		DC.B	"ELECTROBRAIN",0
		DC.B	$AA
		DC.B	"BRODERBUND?",0
		DC.B	$C3
		DC.B	"SQUARESOFT",0
		DC.B	$52
		DC.B	"ACTIVISION?",0
		DC.B	$5A
		DC.B	"BITMAP BROTHERS",0
		DC.B	$53
		DC.B	"AMERICAN SAMMY",0
		DC.B	$47
		DC.B	"SPECTRUM HOLOBYTE",0

manufac_table_end:
		even
