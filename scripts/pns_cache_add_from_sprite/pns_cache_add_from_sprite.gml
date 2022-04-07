/// @desc Add a built-in sprite to the cache. Return a boolean.
/// @param {string} name The name of the sprite to add.
/// @param {real} sprite Sprite index of the sprite to add.
function pns_cache_add_from_sprite(name, sprite) {
	if not sprite_exists(sprite) {
		// The sprite doesn't exist, abort.
		return false
	}
	
	ds_stack_push(global.__pns_cache, [name, sprite, sprite_get_xoffset(sprite), sprite_get_yoffset(sprite)])
	// Reset the sprite's offset, so we can easily add it to the sheets.
	sprite_set_offset(sprite, 0, 0)
	show_debug_message("PNSheets: Added sprite '" + name + "' to cache")
	
	return true
}