minetest.register_craftitem("jewelraid:speed", {
	description = "Speed potion",
	inventory_image = "potion_speed.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		local speed_modifier = user:get_physics_override().speed
		local new_speed_modifier = speed_modifier * 1.5
		user:set_physics_override({
			speed = new_speed_modifier,
		})
		itemstack:take_item()
		minetest.after(30, function(user)
			local latest_speed_modifier = user:get_physics_override().speed
			local reset_speed_modifier = latest_speed_modifier/1.5
			user:set_physics_override({
				speed = reset_speed_modifier,
			})
		end, user)
		return itemstack
	end,
})
minetest.register_craftitem("jewelraid:jump", {
	description = "Jump potion",
	inventory_image = "potion_jump.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		local jump_modifier = user:get_physics_override().jump
		local new_jump_modifier = jump_modifier * 2
		user:set_physics_override({
			jump = new_jump_modifier,
		})
		itemstack:take_item()
		minetest.after(30, function(user)
			local latest_jump_modifier = user:get_physics_override().jump
			local reset_jump_modifier = latest_jump_modifier/2
			user:set_physics_override({
				jump = reset_jump_modifier,
			})
		end, user)
		return itemstack
	end,
})
minetest.register_craftitem("jewelraid:antigravity", {
	description = "Anti-gravity potion",
	inventory_image = "potion_antigravity.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		local antigravity_modifier = user:get_physics_override().gravity
		local new_antigravity_modifier = antigravity_modifier/2
		user:set_physics_override({
			gravity = new_antigravity_modifier,
		})
		itemstack:take_item()
		minetest.after(30, function(user)
			local latest_antigravity_modifier = user:get_physics_override().gravity
			local reset_antigravity_modifier = latest_antigravity_modifier * 2
			user:set_physics_override({
				gravity = reset_antigravity_modifier,
			})
		end, user)
		return itemstack
	end,
})
