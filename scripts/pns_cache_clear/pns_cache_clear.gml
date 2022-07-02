/// @desc Clear the cache, freeing any loaded sprite in the process.
function pns_cache_clear() {
	var cache = global.__pns_cache
	
	repeat ds_priority_size(cache) {
		sprite_delete(ds_priority_delete_min(cache))
	}
}