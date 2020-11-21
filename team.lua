jewelraid.teams = {red = {}, blue = {}}

jewelraid.get_biggest_team = function()
	local teamnames = {"red", "blue"}
	local lengths = {#jewelraid.teams.red, #jewelraid.teams.blue}
	local greatest = 1
	for k, v in ipairs(lengths) do
		if v > greatest then greatest = v end
	end
	for k, v in ipairs(lengths) do
		if v == greatest then return teamnames[k] end
	end
end

jewelraid.get_smallest_team = function()
	local teamnames = {"red", "blue"}
	local lengths = {#jewelraid.teams.red, #jewelraid.teams.blue}
	local smallest = 2
	for k, v in ipairs(lengths) do
		if v < smallest then smallest = v end
	end
	for k, v in ipairs(lengths) do
		if v == smallest then return teamnames[k] end
	end
end

jewelraid.assign_team = function(name)
	local team = jewelraid.get_smallest_team()
	table.insert(jewelraid.teams[team], name)
	local player = minetest.get_player_by_name(name)
	if player then
		player:set_pos(minetest.string_to_pos(jewelraid.get_map_by_name(jewelraid.current_map)[jewelraid.get_player_team(player:get_player_name())]))
	end
end

jewelraid.get_player_team = function(name)
	for k, team in pairs(jewelraid.teams) do
		for _, pname in ipairs(team) do
			if name == pname then return k end
		end
	end
end

minetest.register_on_joinplayer(function(player)
	jewelraid.assign_team(player:get_player_name())
	jewelraid.ui_update()
end)

minetest.register_on_leaveplayer(function(player)
	local team = jewelraid.teams[jewelraid.get_player_team(player:get_player_name())]
	for k, pname in ipairs(team) do
		if player:get_player_name() == pname then team[k] = nil end
	end
	jewelraid.ui_update()
end)

jewelraid.get_team_by_pos = function(pos)
	local pos_str = minetest.pos_to_string(pos)
	local map = jewelraid.get_map_by_name(jewelraid.current_map)
	local team_pos_table = {red = minetest.string_to_pos(map.red), blue = minetest.string_to_pos(map.blue)}
	local diffs = {}
	for team, teampos in pairs(team_pos_table) do
		local diff = {x = math.abs(math.abs(pos.x) - math.abs(teampos.x)), y = math.abs(math.abs(pos.y) - math.abs(teampos.y)), z = math.abs(math.abs(pos.z) - math.abs(teampos.z))}
		diffs[team] = diff
	end
	local smallest = {x = 300, z = 300}
	for team, diff in pairs(diffs) do
		if diff.x + diff.z < smallest.x + smallest.z then
			smallest.x = diff.x
			smallest.z = diff.z
		end
	end
	for team, diff in pairs(diffs) do
		if smallest.x == diff.x and smallest.z == diff.z then
			return team
		end
	end
end
