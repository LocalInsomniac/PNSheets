/// @desc Clear the cache, freeing any loaded sprite in the process.
function pns_cache_clear() {
	var cache = global.__pns_cache
	
	repeat ds_stack_size(cache) {
		sprite_delete(ds_stack_pop(cache))
	}
}