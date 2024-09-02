# ANY FpsLimiter
 
An FPS limiter for Source Engine game servers. Recommended to set `fps_max 0`.

Provides convar: `"host_runframe_time", "0", "Minimum time in seconds before we can exit CEngine::Frame function""`.

## Supported games
If the game server that you need is not yet supported, you can provide a signatrue of the `void CEngine::Frame(void)` function from the game server that you need.

- Left 4 Dead 2 (windows server).

## Compilation
If you don't know how to compile it into SourceMod plugin (.smx) see https://wiki.alliedmods.net/Compiling_SourceMod_Plugins

## Changelog

Version 2.0.0
- Apply limit on CEngine::Frame function now.
- Change gamedata.

Version 1.0.1
- Simplify.