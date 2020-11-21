jewelraid.huds = {}

jewelraid.std_hud = {
	hud_elem_type = "text",
	position = {x = 0.85, y = 0.3},
	offset = {x = 20, y = 20},
	text = "Current map: -",
	alignment = {x = 1, y = 1},
	scale = {x = 100, y = 100},
	number = 0xFFFFFF,
}

minetest.register_on_joinplayer(function(player)
	jewelraid.huds[player:get_player_name()] = player:hud_add(jewelraid.std_hud)
	minetest.after(1, jewelraid.ui_update, nil)
end)

jewelraid.ui_update = function()
        local red, bluebed
        if jewelraid.beds.red then redbed = tostring(#jewelraid.beds.red).."jewels" end
        if jewelraid.beds.blue then bluebed = tostring(#jewelraid.beds.blue).."jewels" end

	local text = "Current map: " .. jewelraid.current_map .. "\n" ..
	jewelraid.next_event_msg[jewelraid.event + 1] .. ": " .. tostring(math.floor(jewelraid.events[jewelraid.event + 1] - (jewelraid.timer or 0))) .. "\n\n" ..
	"R: " .. (redbed or #jewelraid.teams.red) .. "\n" ..
	"B: " .. (bluebed or #jewelraid.teams.blue)
	
	local players = minetest.get_connected_players()
	for _, player in ipairs(players) do
		player:hud_change(jewelraid.huds[player:get_player_name()], "text", text)
	end
end
