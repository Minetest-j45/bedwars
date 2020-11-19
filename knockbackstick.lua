minetest.register_craftitem("jewelraid:kbstick", {
	description = "Knockback stick",
	inventory_image = "default_stick.png",
})

minetest.calculate_knockback = function(player, hitter, time_from_last_punch, tool_capabilities, dir, distance, damage)
	if hitter:get_wielded_item():get_name() == "jewelraid:stick" then
		return 20
	end
	return 0
end
