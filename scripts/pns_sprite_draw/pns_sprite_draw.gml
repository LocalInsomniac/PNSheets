/// @desc Draw a sprite directly from its sheet.
/// @param {array} sprite The data array of the sprite to draw.
/// @param {real} frame The frame of the sprite.
/// @param {real} x The X position to draw at.
/// @param {real} y The Y position to draw at.
function pns_sprite_draw(sprite, frame, x, y) {
	gml_pragma("forceinline")
	
	var sheet = sprite[__PNSSpriteData.SHEET]
	var get_frame = sprite[__PNSSpriteData.FRAMES][frame]
	
	draw_sprite_general(
		sheet[__PNSSheetData.PAGES][get_frame[__PNSFrameData.PAGE]],
		0,
		get_frame[__PNSFrameData.X],
		get_frame[__PNSFrameData.Y],
		sprite[__PNSSpriteData.WIDTH],
		sprite[__PNSSpriteData.HEIGHT],
		x - sprite[__PNSSpriteData.X_OFFSET],
		y - sprite[__PNSSpriteData.Y_OFFSET],
		1,
		1,
		0,
		c_white,
		c_white,
		c_white,
		c_white,
		1
	)
}