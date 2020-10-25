bedwars.item_shop_fs = "size[7,9]" ..
"item_image_button[1,1;1,1;default:sword_steel;steelsword;]item_image_button[3,1;1,1;default:sword_diamond;diamondsword;]" ..
"item_image_button[1,3;1,1;bow:bow;bow;]item_image_button[3,3;1,1;bow:arrow;arrow;]" ..
"item_image_button[1,5;1,1;default:apple;apple;]item_image_button[3,5;1,1;tnt:tnt;tnt;]item_image_button[5,5;1,1;default:pick_steel;steelpick;]" ..
"item_image_button[1,7;1,1;wool:white;wool;]item_image_button[3,7;1,1;default:tinblock;tin;]"

minetest.register_node("bedwars:shop_item", {
	description = "Item shop",
	drawtype = "nodebox",
	tiles = {"shop_item.lua"},
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
	groups = {},
	on_construct = function(pos)
		minetest.get_meta(pos):set_string("formspec", bedwars.item_shop_fs)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local itemstack = ItemStack()
		if fields.steelsword then
			local wielded = sender:get_wielded_item()
			if wielded:get_name() ~= "default:gold_ingot" or wielded:get_count() < 3 then
				minetest.chat_send_player(sender:get_player_name(), "Wield 3 gold to buy this item")
				return
			end
			itemstack:set_count(1)
			itemstack:set_name("default:sword_steel")
		elseif fields.diamondsword then
			local wielded = sender:get_wielded_item()
			if wielded:get_name() ~= "default:mese_crystal" or wielded:get_count() < 3 then
				minetest.chat_send_player(sender:get_player_name(), "Wield 3 mese to buy this item")
				return
			end
			itemstack:set_count(1)
			itemstack:set_name("default:sword_diamond")
		elseif fields.bow then
			local wielded = sender:get_wielded_item()
			if wielded:get_name() ~= "default:mese_crystal" or wielded:get_count() < 8 then
				minetest.chat_send_player(sender:get_player_name(), "Wield 8 mese to buy this item")
				return
			end
			itemstack:set_count(1)
			itemstack:set_name("bow:bow")
		elseif fields.arrow then
			local wielded = sender:get_wielded_item()
			if wielded:get_name() ~= "default:gold_ingot" or wielded:get_count() < 4 then
				minetest.chat_send_player(sender:get_player_name(), "Wield 4 gold to buy this item")
				return
			end
			itemstack:set_count(16)
			itemstack:set_name("bow:arrow")
		elseif fields.apple then
			local wielded = sender:get_wielded_item()
			if wielded:get_name() ~= "default:gold_ingot" or wielded:get_count() < 2 then
				minetest.chat_send_player(sender:get_player_name(), "Wield 2 gold to buy this item")
				return
			end
			itemstack:set_count(1)
			itemstack:set_name("default:apple")
		elseif fields.tnt then
			local wielded = sender:get_wielded_item()
			if wielded:get_name() ~= "default:gold_ingot" or wielded:get_count() < 5 then
				minetest.chat_send_player(sender:get_player_name(), "Wield 5 gold to buy this item")
				return
			end
			itemstack:set_count(1)
			itemstack:set_name("tnt:tnt")
		elseif fields.steelpick then
			local wielded = sender:get_wielded_item()
			if wielded:get_name() ~= "default:gold_ingot" or wielded:get_count() < 10 then
				minetest.chat_send_player(sender:get_player_name(), "Wield 10 gold to buy this item")
				return
			end
			itemstack:set_count(1)
			itemstack:set_name("default:pick_steel")
		elseif fields.wool then
			local wielded = sender:get_wielded_item()
			if wielded:get_name() ~= "default:steel_ingot" or wielded:get_count() < 4 then
				minetest.chat_send_player(sender:get_player_name(), "Wield 4 steel to buy this item")
				return
			end
			itemstack:set_count(16)
			itemstack:set_name("wool:" .. bedwars.get_player_team(sender:get_player_name()))
		elseif fields.tin then
			local wielded = sender:get_wielded_item()
			if wielded:get_name() ~= "default:mese_crystal" or wielded:get_count() < 4 then
				minetest.chat_send_player(sender:get_player_name(), "Wield 4 mese to buy this item")
				return
			end
			itemstack:set_count(8)
			itemstack:set_name("default:tinblock")
		end
	end,
})

minetest.register_node("bedwars:shop_team", {
	description = "Team shop",
	drawtype = "nodebox",
	tiles = {"shop_team.lua"},
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
	groups = {},
	on_construct = function(pos)
		minetest.get_meta(pos):set_string("formspec", bedwars.team_shop_fs)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		
	end,
})