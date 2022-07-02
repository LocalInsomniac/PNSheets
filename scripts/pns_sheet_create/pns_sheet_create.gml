/// @desc Create a sheet using the current cache, clearing it in the process. Return said sheet, undefined if unsuccessful.
/// @param {real} width The width of the sheet.
/// @param {real} height The height of the sheet.
function pns_sheet_create(width, height) {
	static sheet_id = 0
	
	var time = get_timer()
	var cache = global.__pns_cache
	
	if width <= 0 or height <= 0 or not ds_priority_size(cache) {
		// Invalid, abort.
		return undefined
	}
	
	// Reset GPU state.
    var _gpu_blend = gpu_get_blendenable()
	var _gpu_blendmode = gpu_get_blendmode_ext_sepalpha()
	var _gpu_colorwrite = gpu_get_colorwriteenable()
	var _gpu_alphatest = gpu_get_alphatestenable()
	var _gpu_texfilter = gpu_get_texfilter()
	var _gpu_fog = gpu_get_fog()
	var _gpu_lighting = draw_get_lighting()
	var _gpu_color = draw_get_color()
	var _gpu_alpha = draw_get_alpha()
	var _gpu_zwrite = gpu_get_zwriteenable()
	var _gpu_ztest = gpu_get_ztestenable()
	var _gpu_cullmode = gpu_get_cullmode()
	var _gpu_zfunc = gpu_get_zfunc()
	var _gpu_tex_mip = gpu_get_tex_mip_enable()
	var _matrix_world = matrix_get(matrix_world)
	var _matrix_view = matrix_get(matrix_view)
	var _matrix_proj = matrix_get(matrix_projection)
	var _shader = shader_current()
	var _surface_depth = surface_get_depth_disable()
    var _matrix_default = matrix_build_identity()
	
	gpu_set_blendenable(false)
	gpu_set_blendmode(bm_normal)
    gpu_set_colourwriteenable(true, true, true, true)
    gpu_set_alphatestenable(false)
    gpu_set_texfilter(false)
    gpu_set_fog(false, c_black, 0, 1)
    draw_set_colour(c_white)
    draw_set_alpha(1)
    gpu_set_zwriteenable(false)
    gpu_set_ztestenable(false)
    gpu_set_cullmode(cull_noculling)
    gpu_set_zfunc(cmpfunc_lessequal)
    gpu_set_tex_mip_enable(false)
    matrix_set(matrix_world, _matrix_default)
    matrix_set(matrix_view, _matrix_default)
    matrix_set(matrix_projection, _matrix_default)
    shader_reset()
	surface_depth_disable(true)
	
	// Prepare the sprite sheet.
	var sheet = []
	
	// Prepare texture pages for the sprite sheet.
	var sprites = global.__pns_sprites
	var added_sprites = []
	
	var pages = []
	var textures = []
	var page_size = width * height
	var page_areas = buffer_create(page_size, buffer_fast, 1)
	
	buffer_fill(page_areas, 0, buffer_u8, false, page_size)
	
	var surface_width = __pns_ceil_power2(width)
	var surface_height = __pns_ceil_power2(height)
	var current_page = surface_create(surface_width, surface_height)
	
	sheet[@ __PNSSheetData.PAGES] = pages
	sheet[@ __PNSSheetData.SPRITES] = added_sprites
	sheet[@ __PNSSheetData.TEXTURES] = textures
	surface_set_target(current_page)
	draw_clear_alpha(c_black, 0)
	
	/* Loop through the cache and add every sprite (from largest to smallest) into
	   the current texture page. */
	repeat ds_priority_size(cache) {
		var cache_sprite = ds_priority_delete_max(cache)
		
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
							__pns_area_fill(page_areas, page_x, page_y, spr_width, spr_height, width)
							occupied = false;
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
				
				var page_sprite = sprite_create_from_surface(current_page, 0, 0, width, height, false, false, 0, 0)
				
				array_push(pages, page_sprite)
				array_push(textures, sprite_get_texture(page_sprite, 0))
				surface_free(current_page)
				buffer_fill(page_areas, 0, buffer_u8, false, page_size)
				current_page = surface_create(surface_width, surface_height)
				surface_set_target(current_page)
				draw_clear_alpha(c_black, 0)
			}
		}
		
		array_push(added_sprites, name)
		ds_map_add(sprites, name, current_sprite)
	}
	
	surface_reset_target()
	
	var page_sprite = sprite_create_from_surface(current_page, 0, 0, width, height, false, false, 0, 0)
				
	array_push(pages, page_sprite)
	array_push(textures, sprite_get_texture(page_sprite, 0))
	surface_free(current_page)
	buffer_delete(page_areas)
	
	// Revert GPU state.
	gpu_set_blendenable(_gpu_blend)
	gpu_set_blendmode_ext_sepalpha(_gpu_blendmode)
	gpu_set_colorwriteenable(_gpu_colorwrite)
	gpu_set_alphatestenable(_gpu_alphatest)
	gpu_set_texfilter(_gpu_texfilter)
	gpu_set_fog(_gpu_fog)
	draw_set_lighting(_gpu_lighting)
	draw_set_color(_gpu_color)
	draw_set_alpha(_gpu_alpha)
	gpu_set_zwriteenable(_gpu_zwrite)
	gpu_set_ztestenable(_gpu_ztest)
	gpu_set_cullmode(_gpu_cullmode)
	gpu_set_zfunc(_gpu_zfunc)
	gpu_set_tex_mip_enable(_gpu_tex_mip)
	matrix_set(matrix_world, _matrix_world)
	matrix_set(matrix_view, _matrix_view)
	matrix_set(matrix_projection, _matrix_proj)
	
	if _shader != -1 {
		shader_set(_shader)
	}
	
	surface_depth_disable(_surface_depth)
	
	// Delete original copies of the sprites if needed.
	var added_sprites_n = array_length(added_sprites)
	
	if not __PNS_ALLOW_TEXTURES {
		var i = 0
		
		repeat added_sprites_n {
			var sprite = sprites[? added_sprites[i]]
			
			sprite_delete(sprite[__PNSSpriteData.SPRITE])
			sprite[@ __PNSSpriteData.SPRITE] = undefined;
			++i
		}
	}
	
	show_debug_message("PNSheets: Created sheet " + string(sheet_id) + " (" + string(width) + "x" + string(height) + ") with " + string(array_length(pages)) + " pages and " + string(added_sprites_n) + " sprites in " + string(get_timer() - time) + " microseconds");
	++sheet_id
	
	return sheet
}
