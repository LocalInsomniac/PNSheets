/// @desc Alias for pns_cache_add_from_file. Add an external sprite to the cache. Return a boolean.
/// @param {string} filename The filename of the sprite to add.
/// @param {real} frames The amount of frames included in the image.
/// @param {bool} no_background Whether or not the color of the bottom-left corner of the image should be transparent.
/// @param {bool} smooth_edges Whether or not to smooth the edges around the transparent image.
/// @param {real} x_offset The X offset for each frame of the sprite.
/// @param {real} y_offset The Y offset for each frame of the sprite.
function pns_cache_add(filename, frames, no_background, smooth_edges, x_offset, y_offset) {
	return pns_cache_add_from_file(filename, frames, no_background, smooth_edges, x_offset, y_offset)
}