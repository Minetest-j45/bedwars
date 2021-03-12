minetest.register_craftitem("jewelraid:kbstickup", {
	description = "Knockback stick upgrade",
	inventory_image = "default_stick.png",
})
minetest.register_craftitem("jewelraid:kbstick1", {
	description = "Knockback stick, Power:10",
	inventory_image = "default_stick.png",
})
minetest.register_craftitem("jewelraid:kbstick2", {
	description = "Knockback stick, Power:15",
	inventory_image = "default_stick.png",
})
minetest.register_craftitem("jewelraid:kbstick3", {
	description = "Knockback stick, Power:20",
	inventory_image = "default_stick.png",
})

minetest.register_on_respawnplayer(function(player)
    if not player then return end
    local meta = player:get_meta()
    meta:set_string("respawn_kb_immunity", "true")
    minetest.after(5, function()
		minetest.chat_send_player(player:get_player_name(), "Your respawn knockback immunity ended")
		meta:set_string("respawn_kb_immunity", "false")
    end)
end)

minetest.calculate_knockback = function(player, hitter, time_from_last_punch, tool_capabilities, dir, distance, damage)
	local meta = player:get_meta()
	local knockback_adaptor_respawn
	if meta:get_string("respawn_kb_immunity") == "true" then
		knockback_adaptor_respawn = 0
	else
		knockback_adaptor_respawn = 1
	end
	local hittermeta = hitter:get_meta()
	if hittermeta:get_string("respawn_kb_immunity") == "true" then
		hittermeta:set_string("respawn_kb_immunity", "false")
		minetest.chat_send_player(hitter:get_player_name(), "Your respawn knockback immunity ended as you attacked someone")
	end
	
	local final_knockback
	if hitter:get_wielded_item():get_name() == "jewelraid:kbstick1" then
		final_knockback = 10 * knockback_adaptor_respawn
		return final_knockback
	end
	if hitter:get_wielded_item():get_name() == "jewelraid:kbstick2" then
		final_knockback = 15 * knockback_adaptor_respawn
		return final_knockback
	end
	if hitter:get_wielded_item():get_name() == "jewelraid:kbstick3" then
		final_knockback = 20 * knockback_adaptor_respawn
		return final_knockback
	end
	return 0
end
