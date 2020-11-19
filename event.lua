bedraid.events = {3000}
bedraid.event_list = {"game_end"}
bedraid.event_msg = {
	"Game has ended",
}

bedraid.event = 0

bedraid.event_timer_start = function()
	bedraid.timer = 0
	minetest.register_globalstep(function(dtime)
		bedraid.timer = bedraid.timer + dtime
		if bedraid.timer >= bedraid.events[bedraid.event + 1] then
			bedraid.event = bedraid.event + 1
			minetest.chat_send_all(bedraid.event_msg[bedraid.event])
			bedraid.timer = 0
			if bedraid.event_list[bedraid.event] == "game_end" then
				minetest.request_shutdown("Game has ended", false, 1)
			end
		end
		if bedraid.event_list[bedraid.event] ~= "game_end" then
			bedraid.ui_update()
		end
	end)
end