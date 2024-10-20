# ANY FpsLimiter
 
An FPS limiter for Source Engine game servers. Recommended to set `fps_max 0`.

Provides convar: `"fps_limit", "1000.0"`. Set desired FPS limit via convar `fps_limit`.

Requires [PreciseTime](https://github.com/garamond13/ANY-PreciseTime) extension. Note that plugin uses `GlobalPreciseTimer`.

## Supported games
If the game server that you need is not yet supported, you can provide a signatrue of the `void CEngine::Frame(void)` function from the game server that you need.

- Left 4 Dead 2

## Compilation
If you don't know how to compile it into SourceMod plugin (.smx) see https://wiki.alliedmods.net/Compiling_SourceMod_Plugins

## Changelog

Version 4.0.0
- Remove `engine_frame_time` convar.
- Add new convar `fps_limit`.
- Add L4D2 linux signature.

Version 3.0.0
- Start using PreciseTime extension for timing.
- Change convar `host_runframe_time` to `engine_frame_time`. Should multiply old value with 1000 in order to get very much the same results.

Version 2.0.0
- Apply limit on CEngine::Frame function now.
- Change gamedata.

Version 1.0.1
- Simplify.