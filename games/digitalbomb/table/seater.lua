local SEAT_STATE = require "enum.SEAT_STATE"
local log = require "skynet-fly.log"
local setmetatable = setmetatable
local assert = assert

local M = {}

local meta = {__index = M}

function M:new()
	local t = {
		player = nil,
		state = SEAT_STATE.empty,
	}

	setmetatable(t,meta)
	return t
end

function M:enter(player_id)
	self.player = {
		player_id = player_id
	}
	self.state = SEAT_STATE.waitting
end

function M:leave()
	self.player = nil
	self.state = SEAT_STATE.empty
end

function M:is_empty()
	return self.state == SEAT_STATE.empty
end

function M:is_can_leave()
	return self.state ~= SEAT_STATE.playing
end

function M:get_player()
	return self.player
end

function M:game_start()
	self.state = SEAT_STATE.playing
end

function M:game_over()
	self.state = SEAT_STATE.waitting
end

return M