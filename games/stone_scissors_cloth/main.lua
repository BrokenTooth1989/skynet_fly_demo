local skynet = require "skynet"
local contriner_launcher = require "contriner_launcher"

skynet.start(function()
	skynet.error("start stone_scissors_cloth!!!>>>>>>>>>>>>>>>>>")
	local delay_run = contriner_launcher.run()

	skynet.uniqueservice("room_game_login")

	delay_run()
	skynet.exit()
end)