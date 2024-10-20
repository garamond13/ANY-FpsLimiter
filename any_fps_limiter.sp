#include <sourcemod>
#include <dhooks>
#include <precise_time>

#pragma semicolon 1
#pragma newdecls required

#define VERSION "4.0.0"

float frame_interval = 1.0; // ms

public Plugin myinfo = {
	name = "ANY FpsLimiter",
	author = "Garamond",
	description = "FPS limiter.",
	version = VERSION,
	url = "https://github.com/garamond13/ANY-FpsLimiter"
};

public void OnPluginStart()
{
	// Load gamedata and get CEngine::Frame address.
	Handle game_data = LoadGameConfigFile("any_fps_limiter");
	Address engine_frame = GameConfGetAddress(game_data, "CEngine::Frame");
	CloseHandle(game_data);
	
	// Create detour and enable pre and post callbacks.
	Handle detour = DHookCreateDetour(engine_frame, CallConv_THISCALL, ReturnType_Void, ThisPointer_Ignore);
	DHookEnableDetour(detour, false, engine_frame_pre);

	// Create convar for easier setup.
	Handle fps_limit = CreateConVar("fps_limit", "1000.0");
	HookConVarChange(fps_limit, on_fps_limit);
}

void on_fps_limit(ConVar convar, const char[] oldValue, const char[] newValue)
{
	frame_interval = 1000.0 / GetConVarFloat(convar);
}

MRESReturn engine_frame_pre()
{
	PreciseThreadSleep(frame_interval - GetGlobalPreciseTimeInterval());
	StartGlobalPreciseTimer();
	return MRES_Ignored;
}