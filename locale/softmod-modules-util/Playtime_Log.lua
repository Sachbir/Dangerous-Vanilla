-- Playtime_Log Module
-- Manages the total time a player has online and in the records
-- ============================================================= --


-- Dependencies
require "log-playtime"

Playtime_Log = {}

-- Import log-playtime into class
Playtime_Log.playtime = log_playtime


-- Returns the cumulative time of a player if appropriate
-- @param	player: luaPlayer
-- @return 	number: ticks a player has spent on this server plus ticks on record
function Playtime_Log.get_total_ticks(player) 
	-- cumulative_ticks: ticks a player has spent on this server plus ticks on record
	local cumulative_ticks = player.online_time
	if Playtime_Log.playtime[player.name] ~= nil then
		cumulative_ticks = cumulative_ticks + Playtime_Log.playtime[player.name]
	end
	return cumulative_ticks
end

-- Creates a log of the total time players have spent across saves on the server
-- Write player names and times to a variable in a lua-readable format
function Playtime_Log.generate_log()
	output = "log_playtime = {\n"
	-- For players in this game
	for i, player in pairs(game.players) do 
		if Playtime_Log.playtime[player.name] ~= nil then
			output = output .. log_entry_format(player.name, player.online_time+Playtime_Log.playtime[player.name])
		else 
			output = output .. log_entry_format(player.name, player.online_time)
		end
	end
	-- For players in the records, but not in this game
	for player_name, time in pairs(Playtime_Log.playtime) do
		if game.players[player_name] == nil then
			output = output .. log_entry_format(player_name, time)
		end 
	end
	output = output .. "}"
	-- Write variable to a file
	game.write_file("log-playtime.lua", output, false, 0)
	-- Confirmation message in console
	game.players[1].print("Player times saved")
end

-- Returns an entry for the log in a lua-readable format
function log_entry_format(key, value)
	return "[\"" .. key .. "\"]" .. " " .. "=" .. " " .. value .. "," .. "\n"	
end