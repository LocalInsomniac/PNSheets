#macro __PNS_VERSION "1.0"
#macro __PNS_DATE "2022.4.4"

enum __PNSCacheData {
	NAME,
	SPRITE,
	X_OFFSET,
	Y_OFFSET,
}

enum __PNSSheetData {
	PAGES,
	SPRITES,
}

enum __PNSSpriteData {
	SHEET,
	FRAMES,
	FRAME_AMOUNT,
	X_OFFSET,
	Y_OFFSET,
	WIDTH,
	HEIGHT,
	SPRITE,
}

enum __PNSFrameData {
	PAGE,
	X,
	Y,
}

global.__pns_cache = ds_stack_create()
global.__pns_sprites = ds_map_create()

// Startup
show_debug_message("PNSheets " + __PNS_VERSION + " by Can't Sleep (" + __PNS_DATE + ")")
