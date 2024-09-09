#include <sourcemod>
#include <dhooks>
#include <precise_time>

#pragma semicolon 1
#pragma newdecls required

#define VERSION "3.0.0"

float g_engine_frame_time_val;

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
	DHookEnableDetour(detour, true, engine_frame_post);

	// Create convar for easier setup.
	// Keep the convar name for legacy reasons.
	Handle engine_frame_time = CreateConVar("engine_frame_time", "0", "Minimum time in miliseconds before we can exit CEngine::Frame function");
	HookConVarChange(engine_frame_time, on_engine_frame_time);
}

void on_engine_frame_time(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_engine_frame_time_val = GetConVarFloat(convar);
}

MRESReturn engine_frame_pre()
{
	StartGlobalPreciseTimer();
	return MRES_Ignored;
}

MRESReturn engine_frame_post()
{
	PreciseThreadSleep(g_engine_frame_time_val - GetGlobalPreciseTimeInterval());
	return MRES_Ignored;
}