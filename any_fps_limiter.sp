#include <sourcemod>
#include <dhooks>

#pragma semicolon 1
#pragma newdecls required

#define VERSION "2.0.0"

float g_host_runframe_time_val;
float g_start;

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
	Handle host_runframe_time = CreateConVar("host_runframe_time", "0", "Minimum time in seconds before we can exit CEngine::Frame function");
	HookConVarChange(host_runframe_time, on_host_runframe_time);
}

void on_host_runframe_time(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_host_runframe_time_val = GetConVarFloat(convar);
}

MRESReturn engine_frame_pre()
{
	g_start = GetEngineTime();
	return MRES_Ignored;
}

MRESReturn engine_frame_post()
{
	while (GetEngineTime() - g_start < g_host_runframe_time_val)
		continue;
	return MRES_Ignored;
}