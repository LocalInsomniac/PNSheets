/// @desc Create a sheet using the current cache, clearing it in the process. Return said sheet, undefined if unsuccessful.
/// @param {real} width The width of the sheet.
/// @param {real} height The height of the sheet.
function pns_sheet_create(width, height) {
	static sheet_id = 0
	
	var time = get_timer()
	var cache = global.__pns_cache
	
	if width <= 0 or height <= 0 or not ds_stack_size(cache) {
		// Invalid, abort.
		return undefined
	}
	
	var sheet = []
	
	// Prepare texture pages for the sprite sheet.
	var sprites = global.__pns_sprites
	var added_sprites = []
	
	var pages = []
	var page_size = width * height
	var page_areas = buffer_create(page_size, buffer_fast, 1)
	
	buffer_fill(page_areas, 0, buffer_u8, false, page_size)
	
	var current_page = surface_create(width, height)
	
	sheet[@ __PNSSheetData.PAGES] = pages
	sheet[@ __PNSSheetData.SPRITES] = added_sprites
	surface_set_target(current_page)
	draw_clear_alpha(c_black, 0)
	
	// Loop through the cache and pop every sprite into the current texture page.
	repeat ds_stack_size(cache) {
		var cache_sprite = ds_stack_pop(cache)
		
		var name = cache_sprite[__PNSCacheData.NAME]
		var sprite = cache_sprite[__PNSCacheData.SPRITE]
		
		if ds_map_exists(sprites, name) {
			// This sprite already exists on a different sprite sheet, skip it.
			sprite_delete(sprite)
			
			continue
		}
		
		var spr_width = sprite_get_width(sprite)
		var spr_height = sprite_get_height(sprite)
		
		if spr_width > width or spr_height > height {
			// This sprite exceeds the texture page size, abort.
			show_error("!!! PNSheets: Sprite '" + name + "' is too large for sheet " + string(sheet_id) + "!", true)
			
			return undefined
		}
		
		// Find an empty area in the texture page and place the sprite's frames in it.
		var current_sprite = []
		var current_frames = []
		
		current_sprite[@ __PNSSpriteData.SHEET] = sheet
		current_sprite[@ __PNSSpriteData.FRAMES] = current_frames
		
		var frames = sprite_get_number(sprite)
		
		current_sprite[@ __PNSSpriteData.FRAME_AMOUNT] = frames
		
		var x_offset = cache_sprite[__PNSCacheData.X_OFFSET]
		var y_offset = cache_sprite[__PNSCacheData.Y_OFFSET]
		
		current_sprite[@ __PNSSpriteData.X_OFFSET] = x_offset
		current_sprite[@ __PNSSpriteData.Y_OFFSET] = y_offset
		current_sprite[@ __PNSSpriteData.WIDTH] = spr_width
		current_sprite[@ __PNSSpriteData.HEIGHT] = spr_height
		current_sprite[@ __PNSSpriteData.SPRITE] = sprite
		
		var frame = 0
		var occupied
		var area_width = spr_width - 1
		var area_height = spr_height - 1
		
		while frame < frames {
			// Brute force through the page until we find an empty area.
			var page_y = 0
			
			repeat height - area_height {
				var page_x = 0
				
				occupied = false
				
				repeat width - area_width {
					if __pns_area_free(page_areas, page_x, page_y, spr_width, spr_height, width) {
						// The image fits in this area, occupy it.
						if frame < frames {
							draw_sprite(sprite, frame, page_x, page_y)
							array_push(current_frames, [array_length(pages), page_x, page_y])
							__pns_area_fill(page_areas, page_x, page_y, spr_width, spr_height, width);
							++frame
						}
						
						break
					} else {
						// The image doesn't fit in this area, increment its position.
						occupied = true;
						++page_x
					}
				}
				
				if not occupied {
					break
				}
				
				++page_y
			}
			
			if occupied {
				// There's no space left in the texture page, create a new one.
				surface_reset_target()
				array_push(pages, sprite_create_from_surface(current_page, 0, 0, width, height, false, false, 0, 0))
				surface_free(current_page)
				buffer_fill(page_areas, 0, buffer_u8, false, page_size)
				current_page = surface_create(width, height)
				surface_set_target(current_page)
				draw_clear_alpha(c_black, 0)
			}
		}
		
		array_push(added_sprites, name)
		ds_map_add(sprites, name, current_sprite)
	}
	
	surface_reset_target()
	array_push(pages, sprite_create_from_surface(current_page, 0, 0, width, height, false, false, 0, 0))
	surface_free(current_page)
	buffer_delete(page_areas)
	
	var added_sprites_n = array_length(added_sprites)
	
	if not __PNS_ALLOW_TEXTURES {
		var i = 0
		
		repeat added_sprites_n {
			sprite_delete(sprites[? added_sprites[i]][__PNSSpriteData.SPRITE]);
			++i
		}
	}
	
	show_debug_message("PNSheets: Created sheet " + string(sheet_id) + " (" + string(width) + "x" + string(height) + ") with " + string(array_length(pages)) + " pages and " + string(added_sprites_n) + " sprites in " + string(get_timer() - time) + " us");
	++sheet_id
	
	return sheet
}