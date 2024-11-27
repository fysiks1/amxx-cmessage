// vim: set ts=4 sw=4 tw=99 noet:
//
// AMX Mod X, based on AMX Mod by Aleksander Naszko ("OLO").
// Copyright (C) The AMX Mod X Development Team.
//
// This software is licensed under the GNU General Public License, version 3 or higher.
// Additional exceptions apply. For full license details, see LICENSE.txt or visit:
//     https://alliedmods.net/amxmodx-license

//
// Chat Messages Plugin
//

#include <amxmodx>
#include <amxmisc>

#define X_POS         -1.0
#define Y_POS         0.20
#define HOLD_TIME     12.0

new Array:g_Messages
new g_MessagesNum
new g_Current

new amx_freq_cmessage;

public plugin_init()
{
	g_Messages=ArrayCreate(384);
	register_plugin("Chat Messages", "1.0", "fysiks & AMXX Dev Team")
	register_dictionary("imessage.txt")
	register_dictionary("common.txt")
	register_srvcmd("amx_cmessage", "setMessage")
	amx_freq_cmessage=register_cvar("amx_freq_cmessage", "10")
	
	new lastinfo[8]
	get_localinfo("lastinfomsg_chat", lastinfo, charsmax(lastinfo))
	g_Current = str_to_num(lastinfo)
	set_localinfo("lastinfomsg_chat", "")
}

public infoMessage()
{
	if (g_Current >= g_MessagesNum)
		g_Current = 0
		
	// No messages, just get out of here
	if (g_MessagesNum==0)
	{
		return;
	}
	
	new Message[384];
	
	ArrayGetString(g_Messages, g_Current, Message, charsmax(Message));
	
	client_print(0, print_chat, Message)
	
	++g_Current;
	
	new Float:freq_im = get_pcvar_float(amx_freq_cmessage);
	
	if (freq_im > 0.0)
		set_task(freq_im, "infoMessage", 12345);
}

public setMessage()
{

	new Message[384];
	
	remove_task(12345)
	read_argv(1, Message, charsmax(Message))
	
	while (replace(Message, charsmax(Message), "\n", "^n")) {}
	
	g_MessagesNum++
	
	new Float:freq_im = get_pcvar_float(amx_freq_cmessage)
	
	ArrayPushString(g_Messages, Message);
	
	if (freq_im > 0.0)
		set_task(freq_im, "infoMessage", 12345)
	
	return PLUGIN_HANDLED
}

public plugin_end()
{
	new lastinfo[8]

	num_to_str(g_Current, lastinfo, charsmax(lastinfo))
	set_localinfo("lastinfomsg_chat", lastinfo)

	ArrayDestroy(g_Messages)
}
