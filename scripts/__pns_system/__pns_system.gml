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

/// @desc Check if the area within the current texture page is unoccupied. Return a boolean.
/// @param {buffer} buffer The page area buffer to check.
/// @param {real} x The X position of the area.
/// @param {real} y The Y position of the area.
/// @param {real} width The width of the area.
/// @param {real} height The height of the area.
/// @param {real} page_width The width of the current texture page.
function __pns_area_free(buffer, x, y, width, height, page_width) {
	gml_pragma("forceinline")
	
	var j = y
	
	repeat height {
		var i = x
		
		repeat width {
			if buffer_peek(buffer, (j * page_width) + i, buffer_u8) {
				return false
			}
			
			++i
		}
		
		++j
	}
	
	return true
}

/// @desc Occupy an area in the current texture page.
/// @param {buffer} buffer The page area buffer to fill.
/// @param {real} x The X position of the area.
/// @param {real} y The Y position of the area.
/// @param {real} width The width of the area.
/// @param {real} height The height of the area.
/// @param {real} page_width The width of the current texture page.
function __pns_area_fill(buffer, x, y, width, height, page_width) {
	gml_pragma("forceinline")
	
	var j = y
	
	repeat height {
		var i = x
		
		repeat width {
			buffer_poke(buffer, (j * page_width) + i, buffer_u8, true);
			++i
		}
		
		++j
	}
}

// Startup
show_debug_message("PNSheets " + __PNS_VERSION + " by Can't Sleep (" + __PNS_DATE + ")")
