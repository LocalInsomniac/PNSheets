/// @desc Destroys a sheet, removing any sprite it contains in the process.
/// @param {array} sheet The sheet to destroy.
function pns_sheet_destroy(sheet) {
	if sheet == undefined {
		return false
	}
	
	var pages = sheet[__PNSSheetData.PAGES]
	var i = 0
	
	repeat array_length(pages) {
		sprite_delete(pages[i]);
		++i
	}
	
	var sprites = global.__pns_sprites
	var added_sprites = sheet[__PNSSheetData.SPRITES]
	var i = 0
	
	repeat array_length(added_sprites) {
		var name = added_sprites[i]
		
		ds_map_delete(sprites, name);
		++i
	}
	
	return true
}