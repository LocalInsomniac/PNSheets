# PNSheets
PNSheets is a compact texture page library for GameMaker, intended as the 
modern equivalent of Braffolk's [Custom Sprite Framework](https://github.com/GameMakerDiscord/custom-sprite-framework/) 
for GameMaker Studio 1.4.

By using `sprite_add`, GameMaker creates an extra texture page for every sprite 
and subimage the user loads into their game. This often results in performance 
issues due to numerous texture swaps caused by drawing external sprites. 
PNSheets was made to work around this issue using the bare essentials.

External sprites are added to a cache using `pns_cache_add`. The cache is then 
pushed to a new sprite sheet using `pns_sheet_create`, which generates texture 
pages based on the amount of sprites and the size of each page. These sprites 
can then be retrieved using `pns_sprite_get` and drawn with the 
`pns_sprite_draw*` functions.

Special thanks to **TabularElf** for giving tips throughout research.

# Functions
## Cache
| Function                                                                                       | Returns | Description                                                 |
| ---------------------------------------------------------------------------------------------- |:-------:| -----------------------------------------------------------:|
| `pns_cache_add_from_file(filename, frames, no_background, smooth_edges, x_offset, y_offset)`   | `bool`  | Adds an external sprite to the cache.                       |
| `pns_cache_add(filename, frames, no_background, smooth_edges, x_offset, y_offset)`             | `bool`  | Alias for pns_cache_add_from_file.                          |
| `pns_cache_add_from_sprite(filename, frames, no_background, smooth_edges, x_offset, y_offset)` | `bool`  | Adds a sprite from any source to the cache.                 |
| `pns_cache_clear()`                                                                            | `N/A`   | Clears the cache, freeing any loaded sprite in the process. |

## Sheets
| Function                          | Returns                | Description                                                          |
| --------------------------------- |:----------------------:| --------------------------------------------------------------------:|
| `pns_sheet_create(width, height)` | `array` or `undefined` | Creates a sheet using the current cache, clearing it in the process. |
| `pns_sheet_destroy(sheet)`        | `N/A`                  | Destroys a sheet, removing any sprite it contains in the process.    |

## Sprites
| Function                                                                          | Returns                | Description                                                |
| --------------------------------------------------------------------------------- |:----------------------:| ----------------------------------------------------------:|
| `pns_sprite_get(name)`                                                            | `array` or `undefined` | Gets the data array of a sprite that was added to a sheet. |
| `pns_sprite_draw(sprite, frame, x, y)`                                            | `N/A`                  | Draws a sprite directly from its sheet.                    |
| `pns_sprite_draw_ext(sprite, frame, x, y, x_scale, y_scale, angle, color, alpha)` | `N/A`                  | Draws a sprite directly from its sheet.                    |

# Settings
The settings can be changed in `__pns_config`.

| Macro                  | Type   | Description                                                                                                             |
| ---------------------- |:------:| -----------------------------------------------------------------------------------------------------------------------:|
| `__PNS_ALLOW_TEXTURES` | `bool` | Whether or not to keep original copies of texture paged sprites for getting textures. Reduces memory usage if disabled. |