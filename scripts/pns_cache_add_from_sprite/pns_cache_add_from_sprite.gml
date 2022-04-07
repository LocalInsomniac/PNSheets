/// @desc Add a sprite to the cache. Return a boolean.
/// @param {string} filename The filename of the sprite to add.
/// @param {real} sprite Sprite index of sprite to add.
/// @param {real} x_offset The X offset for each frame of the sprite.
/// @param {real} y_offset The Y offset for each frame of the sprite.
function pns_cache_add_from_sprite(name, sprite, x_offset, y_offset) {
	if not sprite_exists(sprite) {
		// The file doesn't exist, abort.
		return false
	}
	
	// Setting the sprite offset to 0 for better handling
	if sprite_get_xoffset(sprite) != 0 or sprite_get_yoffset(sprite) != 0 {
		sprite_set_offset(sprite, 0, 0);
	}
	
	ds_stack_push(global.__pns_cache, [name, sprite, x_offset, y_offset])
	show_debug_message("PNSheets: Added sprite '" + name + "' to cache")
	
	return true
}