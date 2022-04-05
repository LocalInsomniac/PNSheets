/// @desc Draw a sprite directly from a sheet.
/// @param {array} sprite The data array of the sprite to draw.
/// @param {real} frame The frame of the sprite.
/// @param {real} x The X position to draw at.
/// @param {real} y The Y position to draw at.
/// @param {real} x_scale The X scale of the sprite.
/// @param {real} y_scale The Y scale of the sprite.
/// @param {real} angle The amount of degrees to rotate the sprite.
/// @param {real} color The color to tint the sprite with.
/// @param {real} alpha The alpha transparency of the sprite.
function pns_sprite_draw_ext(sprite, frame, x, y, x_scale, y_scale, angle, color, alpha) {
	gml_pragma("forceinline")
	
	var sheet = sprite[__PNSSpriteData.SHEET]
	var get_frame = sprite[__PNSSpriteData.FRAMES][frame]
	
	var angle_y = angle - 90
	var x_offset = sprite[__PNSSpriteData.X_OFFSET]
	var y_offset = sprite[__PNSSpriteData.Y_OFFSET]
	
	draw_sprite_general(
		sheet[__PNSSheetData.PAGES][get_frame[__PNSFrameData.PAGE]],
		0,
		get_frame[__PNSFrameData.X],
		get_frame[__PNSFrameData.Y],
		sprite[__PNSSpriteData.WIDTH],
		sprite[__PNSSpriteData.HEIGHT],
		x - lengthdir_x(x_offset, angle) * x_scale - lengthdir_x(y_offset, angle_y) * y_scale,
		y - lengthdir_y(x_offset, angle) * x_scale - lengthdir_y(y_offset, angle_y) * y_scale,
		x_scale,
		y_scale,
		angle,
		color,
		color,
		color,
		color,
		alpha
	)
}