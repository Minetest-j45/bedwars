jewelraid.beds = {red = 20, blue = 20} -- 20 is initial number of beds

jewelraid.str_to_colour = function(str)
	local codes = {red = "#FF0000", blue = "#0000FF"}
	return codes[str]
end

minetest.register_on_dieplayer(function(player)
	minetest.chat_send_all(minetest.colorize(jewelraid.str_to_colour(jewelraid.get_player_team(player:get_player_name())), player:get_player_name()) .. " died")
	jewelraid.beds[jewelraid.get_player_team(player:get_player_name())] = jewelraid.beds[jewelraid.get_player_team(player:get_player_name())] - 1
end)

minetest.register_on_respawnplayer(function(player)
	local itemstack = ItemStack("default:pick_steel")
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

minetest.register_node("jewelraid:jewel", {
   description = "Jewel",
   tiles = {"jewel.png"},
   wield_image = "jewel.png",
   groups = {cracky =1},
   on_rightclick = function(pos, node, player, itemstack, pointed_thing)
    local nodename = node.name
    if not nodename == "jewelraid:jewel" or not itemstack:get_name() == "jewelraid:jewel" then return end
    if nodename == "jewelraid:jewel"  and itemstack:get_name() == "jewelraid:jewel" then
      local posteam = jewelraid.get_team_by_pos(pos)
      local placerteam = jewelraid.get_player_team(player:get_player_name())
      if not posteam or not placerteam then return end
      if posteam == placerteam then
        jewelraid.beds[jewelraid.get_team_by_pos(pos)] = jewelraid.beds[jewelraid.get_team_by_pos(pos)] + 1
        itemstack:take_item()
        return itemstack
      else
        minetest.chat_send_player(player:get_player_name(), "You can't give the enemy more jewels!")
      end
    end
   end,
})

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if newnode.name == "jewelraid:jewel" then
    	if minetest.check_player_privs(placer:get_player_name(), {jewelraid_maps=true}) then return end
    	minetest.set_node(pos, {name=oldnode.name})
    	minetest.chat_send_player(placer:get_player_name(), "You arent allowed to place jewels")
	end
end)


minetest.register_on_dignode(function(pos, oldnode, digger)
	if oldnode.name == "jewelraid:jewel" then
		minetest.set_node(pos, {name = "jewelraid:jewel"})
		local inv = digger:get_inventory()
		for k, v in pairs(inv:get_lists()) do
			minetest.after(0, function(t)
				local itemstack = ItemStack("jewelraid:jewel")
				itemstack:set_count(99)
				t.inv:remove_item(t.k, itemstack)
			end, {k = k, inv = inv})
		end
		if jewelraid.get_team_by_pos(pos) == jewelraid.get_player_team(digger:get_player_name()) then
			minetest.chat_send_player(digger:get_player_name(), "You can't destroy your own jewel")
			return
		end
		if not jewelraid.beds[jewelraid.get_team_by_pos(pos)] then return end
		jewelraid.beds[jewelraid.get_team_by_pos(pos)] = jewelraid.beds[jewelraid.get_team_by_pos(pos)] - 1
		minetest.add_item(pos, "jewelraid:jewel")
		minetest.chat_send_all("Team " .. minetest.colorize(jewelraid.str_to_colour(jewelraid.get_team_by_pos(pos)), jewelraid.get_team_by_pos(pos)) .. "'s jewel has been destroyed by " .. digger:get_player_name())
		minetest.sound_play("bed_destruction", {
			pos = pos,
			max_hear_distance = 100,
			gain = 2.0,
		})
		jewelraid.ui_update()
	end
end)
