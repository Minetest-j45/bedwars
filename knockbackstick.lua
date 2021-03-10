minetest.register_craftitem("jewelraid:kbstick1", {
	description = "Knockback stick",
	inventory_image = "default_stick.png",
})
minetest.register_craftitem("jewelraid:kbstick2", {
	description = "Knockback stick",
	inventory_image = "default_stick.png",
})
minetest.register_craftitem("jewelraid:kbstick3", {
	description = "Knockback stick",
	inventory_image = "default_stick.png",
})

minetest.calculate_knockback = function(player, hitter, time_from_last_punch, tool_capabilities, dir, distance, damage)
	if hitter:get_wielded_item():get_name() == "jewelraid:kbstick1" then
		return 10
	end
	if hitter:get_wielded_item():get_name() == "jewelraid:kbstick2" then
		return 15
	end
	if hitter:get_wielded_item():get_name() == "jewelraid:kbstick3" then
		return 20
	end
	return 0
end
