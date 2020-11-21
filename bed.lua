jewelraid.beds = {red = 20, blue = 20} -- 20 is initial number of beds

jewelraid.str_to_colour = function(str)
	local codes = {red = "#FF0000", blue = "#0000FF"}
	return codes[str]
end

minetest.register_on_dieplayer(function(player)
	minetest.chat_send_all(minetest.colorize(jewelraid.str_to_colour(jewelraid.get_player_team(player:get_player_name())), player:get_player_name()) .. " died")
	jewelraid.beds[jewelraid.get_player_team(player:get_player_name())] = jewelraid.beds[jewelraid.get_player_team(player:get_player_name())] - 1
	if jewelraid.get_player_team(player:get_player_name()) == "red" then
		jewelraid.beds.blue = jewelraid.beds.blue + 1
	elseif jewelraid.get_player_team(player:get_player_name()) == "blue" then
		jewelraid.beds.red = jewelraid.beds.red + 1
	end
end)

minetest.register_on_respawnplayer(function(player)
	local itemstack = ItemStack("default:sword_stone")
	player:set_wielded_item(itemstack)
	if jewelraid.beds[jewelraid.get_player_team(player:get_player_name())] <= 0 then
		minetest.kick_player(player:get_player_name(), "You cannot respawn because your bed has been destroyed. Please wait for a new game to start.")
		minetest.after(1, function()
			local empty_teams = 0
			local alive = {red = true, blue = true}
			for k, v in pairs(jewelraid.teams) do
				if #v == 0 then
					empty_teams = empty_teams + 1
					alive[k] = false
			end
			end
			local last_team
			for k, v in pairs(alive) do
				if v then
					last_team = k
				end
			end
			if empty_teams == 1 then
				minetest.chat_send_all("Team " .. minetest.colorize(jewelraid.str_to_colour(last_team), last_team) .. " has won!")
				minetest.request_shutdown("Game has ended", false, 10) 
			end
		end, nil)
	else
		minetest.after(0, function(player)
			player:set_pos(minetest.string_to_pos(jewelraid.get_map_by_name(jewelraid.current_map)[jewelraid.get_player_team(player:get_player_name())]))
		end, player)
	end
	return true
end)

minetest.register_on_joinplayer(function(player)
	minetest.after(1, function()
		if jewelraid.beds[jewelraid.get_player_team(player:get_player_name())] <= 0 then
			minetest.kick_player(player:get_player_name(), "You cannot respawn because your bed has been destroyed. Please wait for a new game to start.")
		end
	end)
end)
