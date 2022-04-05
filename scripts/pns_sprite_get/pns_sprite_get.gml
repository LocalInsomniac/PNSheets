/// @desc Get the data array of a sprite that was added to a sheet. Return an array, undefined if unsuccessful.
/// @param {string} name The name of the sprite.
function pns_sprite_get(name) {
	gml_pragma("forceinline")
	
	return global.__pns_sprites[? name]
}