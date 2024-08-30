#include <sourcemod>
#include <dhooks>

#pragma semicolon 1
#pragma newdecls required

#define VERSION "1.0.1"

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
	// Load gamedata and get the "void _Host_RunFrame(float time)" address.
	Handle game_data = LoadGameConfigFile("any_fps_limiter");
	Address host_runframe = GameConfGetAddress(game_data, "_Host_RunFrame");
	CloseHandle(game_data);
	
	// Create detour and enable pre and post callbacks.
	Handle detour = DHookCreateDetour(host_runframe, CallConv_CDECL, ReturnType_Void, ThisPointer_Ignore);
	DHookEnableDetour(detour, false, host_runframe_pre);
	DHookEnableDetour(detour, true, host_runframe_post);

	// Create convar for easier setup.
	Handle host_runframe_time = CreateConVar("host_runframe_time", "0", "Minimum time in seconds before we can exit void _Host_RunFrame(float time) function");
	HookConVarChange(host_runframe_time, on_host_runframe_time);
}

void on_host_runframe_time(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_host_runframe_time_val = GetConVarFloat(convar);
}

MRESReturn host_runframe_pre()
{
	g_start = GetEngineTime();
	return MRES_Ignored;
}

MRESReturn host_runframe_post()
{
	while (GetEngineTime() - g_start < g_host_runframe_time_val)
		continue;
	return MRES_Ignored;
}