minetest.register_craftitem("jewelraid:speed", {
	description = "Speed potion",
	inventory_image = "potion_speed.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		user:set_physics_override({
			speed = 1.5,
		})
		itemstack:take_item()
		minetest.after(30, function(user)
			user:set_physics_override({
				speed = 1,
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
		user:set_physics_override({
			jump = 2,
		})
		itemstack:take_item()
		minetest.after(30, function(user)
			user:set_physics_override({
				jump = 1,
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
		user:set_physics_override({
			gravity = 0.5,
		})
		itemstack:take_item()
		minetest.after(30, function(user)
			user:set_physics_override({
				gravity = 1,
			})
		end, user)
		return itemstack
	end,
})
