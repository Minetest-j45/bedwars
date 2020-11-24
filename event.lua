jewelraid.events = {3000}
jewelraid.event_list = {"game_end"}
jewelraid.event_msg = {
	"Game has ended",
}

jewelraid.event = 0
jewelraid.event_timer_start = function()
	jewelraid.timer = 0
	minetest.register_globalstep(function(dtime)
		jewelraid.timer = jewelraid.timer + dtime
		if jewelraid.timer >= 3000 then
			jewelraid.event = jewelraid.event + 1
			minetest.chat_send_all(jewelraid.event_msg[jewelraid.event])
			jewelraid.timer = 0
			if jewelraid.event_list[jewelraid.event] == "game_end" then
				minetest.request_shutdown("Game has ended", false, 1)
			end
		end
		if jewelraid.event_list[jewelraid.event] ~= "game_end" then
			jewelraid.ui_update()
		end
	end)
end
