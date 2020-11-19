jewelraid.beds = {red = true, blue = true}

jewelraid.str_to_colour = function(str)
	local codes = {red = "#FF0000", blue = "#0000FF"}
	return codes[str]
end

minetest.register_on_dignode(function(pos, oldnode, digger)
	if oldnode.name == "beds:bed_bottom" then
		minetest.set_node(pos, {name = "beds:bed_bottom", param2 = oldnode.param2})
		local inv = digger:get_inventory()
		for k, v in pairs(inv:get_lists()) do
			minetest.after(0, function(t)
				local itemstack = ItemStack("beds:bed")
				itemstack:set_count(99)
				t.inv:remove_item(t.k, itemstack)
			end, {k = k, inv = inv})
		end
		if jewelraid.get_team_by_pos(pos) == jewelraid.get_player_team(digger:get_player_name()) then
			minetest.chat_send_player(digger:get_player_name(), "You can't destroy your own bed")
			return
		end
		if not jewelraid.beds[jewelraid.get_team_by_pos(pos)] then return end
		jewelraid.beds[jewelraid.get_team_by_pos(pos)] = false
		minetest.chat_send_all("Team " .. minetest.colorize(jewelraid.str_to_colour(jewelraid.get_team_by_pos(pos)), jewelraid.get_team_by_pos(pos)) .. "'s bed has been destroyed by " .. digger:get_player_name())
		minetest.sound_play("bed_destruction", {
			pos = pos,
			max_hear_distance = 100,
			gain = 2.0,
		})
		jewelraid.ui_update()
	end
end)

minetest.register_on_dieplayer(function(player)
	minetest.chat_send_all(minetest.colorize(jewelraid.str_to_colour(jewelraid.get_player_team(player:get_player_name())), player:get_player_name()) .. " died")
end)

minetest.register_on_respawnplayer(function(player)
	local itemstack = ItemStack("default:sword_stone")
	player:set_wielded_item(itemstack)
	if not jewelraid.beds[jewelraid.get_player_team(player:get_player_name())] then
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
		if not jewelraid.beds[jewelraid.get_player_team(player:get_player_name())] then
			minetest.kick_player(player:get_player_name(), "You cannot respawn because your bed has been destroyed. Please wait for a new game to start.")
		end
	end)
end)
