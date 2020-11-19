bedraid.maps = minetest.deserialize(bedraid.storage:get_string("maps")) or {}

minetest.register_privilege("bedraid_maps", {
	description = "Player can manage maps.",
})

bedraid.map_exists = function(name)
	for _, map in ipairs(bedraid.maps) do
		if map.name == name then return true end
	end
	return false
end

bedraid.map_add = function(def)
	table.insert(bedraid.maps, def)
end

bedraid.map_remove = function(name)
	for k, map in ipairs(bedraid.maps) do
		if map.name == name then bedraid.maps[k] = nil end
	end
end

bedraid.get_map_by_name = function(name)
	for _, map in ipairs(bedraid.maps) do
		if map.name == name then return map end
	end
end

minetest.register_chatcommand("map_default", {
	description = "Add map with default attribs",
	params = "<name>",
	privs = {bedraid_maps = true},
	func = function(name, param)
		if not param or param == "" then return false, "Invalid arguments" end
		if bedraid.map_exists(param) then return false, "Map with same name already exists" end
		local template = {
			name = param,
			red = "100,100,100",
			green = "100,100,100",
			blue = "100,100,100",
			yellow = "100,100,100",
			diamond1 = "100,100,100",
			diamond2 = "100,100,100",
			diamond3 = "100,100,100",
			diamond4 = "100,100,100",
			mese1 = "100,100,100",
			mese2 = "100,100,100",
			mese3 = "100,100,100",
			mese4 = "100,100,100",
		}
		bedraid.map_add(template)
		return true, "Map added, please modify the attributes now with /map_modify"
	end,
})

minetest.register_chatcommand("map_modify", {
	description = "Modify map attributes",
	params = "<map_name> <attrib_name> [<x>,<y>,<z>]",
	privs = {bedraid_maps = true},
	func = function(name, param)
		local map_name = param:split(" ")[1]
		local key = param:split(" ")[2]
		local value = param:split(" ")[3]
		if value and value ~= "" and not minetest.string_to_pos(value) then return false, "Invalid arguments" end
		if not map_name or not key then return false, "Invalid arguments" end
		local valid = false
		local valid_attribs = {"red", "blue"}
		for _, v in ipairs(valid_attribs) do
			if key == v then
				valid = true
				break
			end
		end
		bedwars.get_map_by_name(map_name)[key] = value or minetest.pos_to_string(minetest.get_player_by_name(name):get_pos())
		return true, "Attribute changed to current position"
	end,
})

minetest.register_chatcommand("map_add", {
	description = "Add a map",
	params = "<name> <red_x,red_y,red_z> <blue_x,blue_y,blue_z>",
	privs = {bedraid_maps = true},
	func = function(name, param)
		local params = {}
		local paramnames = {
			"name",
			"red",
			"blue",
		}
		if #param:split(" ") ~= 13 then return false, "Invalid arguments" end
		for k, v in ipairs(param:split(" ")) do
			params[paramnames[k]] = v
		end
		if bedraid.map_exists(params.name) then return false, "Map with same name already exists" end
		bedraid.map_add(params)
		return true, "Map added"
	end,
})

minetest.register_chatcommand("map_remove", {
	description = "Remove a map",
	params = "<name>",
	privs = {bedraid_maps = true},
	func = function(name, param)
		if param == "" then return false, "Invalid arguments" end
		bedraid.map_remove(param)
		return true, "Map removed"
	end,
})

minetest.register_chatcommand("map_list", {
	description = "List all maps",
	params = "",
	privs = {bedraid_maps = true},
	func = function(name, param)
		return true, dump(bedraid.maps)
	end,
})

minetest.register_on_shutdown(function()
	bedraid.storage:set_string("maps", minetest.serialize(bedraid.maps))
end)

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 2 then
		local players = minetest.get_connected_players()
		for _, player in ipairs(players) do
			if player:get_pos().y < 80 then
				player:set_hp(0)
			end
		end
		timer = 0
	end
end)