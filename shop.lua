jewelraid.upgrades = {red = {}, blue = {}}

jewelraid.item_shop_fs = "size[6,7]" ..
"item_image_button[3,1;1,1;jewelraid:kbstick;kbstick;]" ..
"item_image_button[1,3;1,1;default:apple;apple;]item_image_button[3,3;1,1;default:pick_diamond;diamondpick;]" ..
"item_image_button[1,5;1,1;jewelraid:speed;speedpotion;]item_image_button[2,5;1,1;jewelraid:jump;jumppotion;]item_image_button[3,5;1,1;jewelraid:antigravity;antigravitypotion;]"

minetest.register_node("jewelraid:shop_item", {
	description = "Item shop",
	drawtype = "nodebox",
	tiles = {"shop_item_side.png", "shop_item_side.png",  "shop_item_side.png",  "shop_item_side.png",  "shop_item_side.png", "shop_item_front.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	sunlight_propagates = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
	},
	groups = {snappy = 3},
	on_construct = function(pos)
		minetest.get_meta(pos):set_string("formspec", jewelraid.item_shop_fs)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local itemstack = ItemStack("")
		local wielded = sender:get_wielded_item()
		if wielded:get_name() == "default:steel_ingot" or wielded:get_name() == "default:gold_ingot" or wielded:get_name() == "default:mese_crystal" then
			minetest.chat_send_player(sender:get_player_name(), "Do not wield currency")
			return
		end
		local reqstack = ItemStack("")
		if fields.steelsword then
			reqstack:set_count(7)
			reqstack:set_name("default:gold_ingot")
			if not sender:get_inventory():contains_item("main", reqstack) then
				minetest.chat_send_player(sender:get_player_name(), "You need 7 gold to buy this item")
				return
			end
			sender:get_inventory():remove_item("main", reqstack)
			itemstack:set_count(1)
			itemstack:set_name("jewelraid:kbstick")
		elseif fields.bow then
			reqstack:set_count(8)
			reqstack:set_name("default:mese_crystal")
			if not sender:get_inventory():contains_item("main", reqstack) then
				minetest.chat_send_player(sender:get_player_name(), "You need 8 mese to buy this item")
				return
			end
			sender:get_inventory():remove_item("main", reqstack)
			itemstack:set_count(1)
			itemstack:set_name("default:apple")
		elseif fields.tnt then
			reqstack:set_count(8)
			reqstack:set_name("default:gold_ingot")
			if not sender:get_inventory():contains_item("main", reqstack) then
				minetest.chat_send_player(sender:get_player_name(), "You need 8 gold to buy this item")
				return
			end
			sender:get_inventory():remove_item("main", reqstack)
			itemstack:set_count(1)
			itemstack:set_name("default:pick_diamond")
		elseif fields.jumppotion then
			reqstack:set_count(3)
			reqstack:set_name("default:mese_crystal")
			if not sender:get_inventory():contains_item("main", reqstack) then
				minetest.chat_send_player(sender:get_player_name(), "You need 3 mese to buy this item")
				return
			end
			sender:get_inventory():remove_item("main", reqstack)
			itemstack:set_count(1)
			itemstack:set_name("potions:speed")
		elseif fields.jumppotion then
			reqstack:set_count(3)
			reqstack:set_name("default:mese_crystal")
			if not sender:get_inventory():contains_item("main", reqstack) then
				minetest.chat_send_player(sender:get_player_name(), "You need 3 mese to buy this item")
				return
			end
			sender:get_inventory():remove_item("main", reqstack)
			itemstack:set_count(1)
			itemstack:set_name("potions:jump")
		elseif fields.antigravitypotion then
			reqstack:set_count(3)
			reqstack:set_name("default:mese_crystal")
			if not sender:get_inventory():contains_item("main", reqstack) then
				minetest.chat_send_player(sender:get_player_name(), "You need 3 mese to buy this item")
				return
			end
			sender:get_inventory():remove_item("main", reqstack)
			itemstack:set_count(1)
			itemstack:set_name("potions:antigravity")
		end
		sender:set_wielded_item(wielded)
		sender:get_inventory():add_item("main", itemstack)
	end,
})

jewelraid.team_shop_fs = "size[5,4]" ..
"item_image_button[1,1;1,1;default:furnace;forge;]item_image_button[2,1;1,1;default:sword_;sharpness;]item_image_button[3,1;1,1;default:flint;dragonbuff;]" ..
"item_image_button[1,2;1,1;default:brick;armour;]item_image_button[2,2;1,1;doors:trapdoor_steel;trap;]item_image_button[3,2;1,1;default:meselamp;healpool;]"

minetest.register_node("jewelraid:shop_team", {
	description = "Team shop",
	drawtype = "nodebox",
	tiles = {"shop_team_side.png",  "shop_team_side.png",  "shop_team_side.png",  "shop_team_side.png",  "shop_team_side.png", "shop_team_front.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	sunlight_propagates = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
	},
	groups = {snappy = 3},
	on_construct = function(pos)
		minetest.get_meta(pos):set_string("formspec", jewelraid.team_shop_fs)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local wielded = sender:get_wielded_item()
		if wielded:get_name() == "default:diamond" then
			minetest.chat_send_player(sender:get_player_name(), "Do not wield currency")
			return
		end
		local team = jewelraid.get_player_team(sender:get_player_name())
		local reqstack = ItemStack("default:diamond")
		if fields.forge then
			if (jewelraid.upgrades[team].forge or 0) >= 4 then
				minetest.chat_send_player(sender:get_player_name(), "The maximum forge upgrade is already active")
				return
			end
			reqstack:set_count(4 * ((jewelraid.upgrades[team].forge or 0) + 1))
			if not sender:get_inventory():contains_item("main", reqstack) then
				minetest.chat_send_player(sender:get_player_name(), "You need " .. tostring(4 * ((jewelraid.upgrades[team].forge or 0) + 1)) .. " diamonds to activate this upgrade")
				return
			end
			sender:get_inventory():remove_item("main", reqstack)
			jewelraid.upgrades[team].forge = (jewelraid.upgrades[team].forge or 0) + 1
		elseif fields.sharpness then
			if jewelraid.upgrades[team].sharpness then
				minetest.chat_send_player(sender:get_player_name(), "The sharpness upgrade is already active")
				return
			end
			reqstack:set_count(8)
			if not sender:get_inventory():contains_item("main", reqstack) then
				minetest.chat_send_player(sender:get_player_name(), "You need 8 diamonds to activate this upgrade")
				return
			end
			sender:get_inventory():remove_item("main", reqstack)
			jewelraid.upgrades[team].sharpness = true
		elseif fields.dragonbuff then
			if jewelraid.upgrades[team].dragonbuff then
				minetest.chat_send_player(sender:get_player_name(), "The dragon buff upgrade is already active")
				return
			end
			reqstack:set_count(5)
			if not sender:get_inventory():contains_item("main", reqstack) then
				minetest.chat_send_player(sender:get_player_name(), "You need 5 diamonds to activate this upgrade")
				return
			end
			sender:get_inventory():remove_item("main", reqstack)
			jewelraid.upgrades[team].dragonbuff = true
		elseif fields.armour then
			if (jewelraid.upgrades[team].armour or 0) >= 4 then
				minetest.chat_send_player(sender:get_player_name(), "The maximum armour upgrade is already active")
				return
			end
			local costs = {5, 10, 20, 30}
			reqstack:set_count(costs[(jewelraid.upgrades[team].armour or 0) + 1])
			if not sender:get_inventory():contains_item("main", reqstack) then
				minetest.chat_send_player(sender:get_player_name(), "You need " .. tostring(costs[(jewelraid.upgrades[team].armour or 0) + 1]) .. " diamonds to activate this upgrade")
				return
			end
			sender:get_inventory():remove_item("main", reqstack)
			jewelraid.upgrades[team].armour = (jewelraid.upgrades[team].armour or 0) + 1
		elseif fields.trap then
			if jewelraid.upgrades[team].trap then
				minetest.chat_send_player(sender:get_player_name(), "The trap upgrade is already active")
				return
			end
			reqstack:set_count(1)
			if not sender:get_inventory():contains_item("main", reqstack) then
				minetest.chat_send_player(sender:get_player_name(), "You need 1 diamond to activate this upgrade")
				return
			end
			sender:get_inventory():remove_item("main", reqstack)
			jewelraid.upgrades[team].trap = true
		elseif fields.healpool then
			if jewelraid.upgrades[team].healpool then
				minetest.chat_send_player(sender:get_player_name(), "The healpool upgrade is already active")
				return
			end
			reqstack:set_count(3)
			if not sender:get_inventory():contains_item("main", reqstack) then
				minetest.chat_send_player(sender:get_player_name(), "You need 3 diamonds to activate this upgrade")
				return
			end
			sender:get_inventory():remove_item("main", reqstack)
			jewelraid.upgrades[team].healpool = true
		end
		sender:set_wielded_item(wielded)
	end,
})

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if newnode and newnode.name == "tnt:tnt" then
		tnt.burn(pos)
	end
end)

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
	if hitter:is_player() and jewelraid.upgrades[jewelraid.get_player_team(hitter:get_player_name())].sharpness then
		player:set_hp(player:get_hp() - damage - 2 + (jewelraid.upgrades[jewelraid.get_player_team(player:get_player_name())].armour or 0))
		return true
	elseif not hitter:is_player() then
		if player:get_hp() - damage + (jewelraid.upgrades[jewelraid.get_player_team(player:get_player_name())].armour or 0) < player:get_hp() then
			player:set_hp(player:get_hp() - damage + (jewelraid.upgrades[jewelraid.get_player_team(player:get_player_name())].armour or 0))
			return true
		end
	end
end)

minetest.register_abm({
	label = "trap",
	nodenames = {"beds:bed_bottom"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local team = jewelraid.get_team_by_pos(pos)
		if not jewelraid.upgrades[team].trap then return end
		local objs = minetest.get_objects_inside_radius(pos, 7)
		for _, obj in ipairs(objs) do
			if obj:is_player() and jewelraid.get_player_team(obj:get_player_name()) ~= team then
				for _, name in ipairs(jewelraid.teams[team]) do
					minetest.chat_send_player(name, "Your trap has been set off")
					jewelraid.upgrades[team].trap = false
				end
			end
		end
	end,
})

minetest.register_abm({
	label = "healpool",
	nodenames = {"beds:bed_bottom"},
	interval = 6,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local team = jewelraid.get_team_by_pos(pos)
		if not jewelraid.upgrades[team].healpool then return end
		local objs = minetest.get_objects_inside_radius(pos, 7)
		for _, obj in ipairs(objs) do
			if obj:is_player() and jewelraid.get_player_team(obj:get_player_name()) == team then
				obj:set_hp(obj:get_hp() + 1)
			end
		end
	end,
})

minetest.register_abm({
	label = "regeneration",
	nodenames = {"beds:bed_bottom"},
	interval = 12,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local objs = minetest.get_objects_inside_radius(pos, 7)
		for _, obj in ipairs(objs) do
			if obj:is_player() then
				obj:set_hp(obj:get_hp() + 1)
			end
		end
	end,
})

local goldtimer = 0
minetest.register_globalstep(function(dtime)
    goldtimer = goldtimer + dtime;
    if goldtimer >= 9 then
        for _,player in ipairs(minetest.get_connected_players()) do
           local itemstack = ItemStack("default:gold_ingot")
           player:get_inventory():add_item("main", itemstack)
           goldtimer = 0
        end
    end
end)
