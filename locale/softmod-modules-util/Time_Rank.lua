-- Time_Rank Helper Module
-- Assigns rank to player base on time played
-- @author Denis Zholob (DDDGamer)
-- github: https://github.com/DDDGamer/factorio-dz-softmod
-- ======================================================= --

-- Dependencies
require "locale/softmod-modules-util/Time"
require "locale/softmod-modules-util/Colors"

Time_Rank = {}

-- Regular player ranks (time in hrs)
Time_Rank.RANKS = {
  lvl1 = { time = 0,   color = Colors.lightgrey,   tag = "Newcomer", },
  lvl2 = { time = 0.16, color = Colors.lightyellow, tag = "Newcomer", },
  lvl3 = { time = 1,   color = Colors.green,       tag = "", },
  lvl4 = { time = 3,  color = Colors.cyan,        tag = "", },
  lvl5 = { time = 9,  color = Colors.blue,        tag = "", },
  lvl6 = { time = 10,  color = Colors.purple,      tag = "", },
}


-- Return a rank obj based on the players time on the server
-- @param player
-- @return Rank obj (time, color, tag)
function Time_Rank.get_rank(player)
  if Time.tick_to_hour(player.online_time) >= Time_Rank.RANKS.lvl6.time then
      return Time_Rank.RANKS.lvl6
  elseif Time.tick_to_hour(player.online_time) >= Time_Rank.RANKS.lvl5.time then
      return Time_Rank.RANKS.lvl5
  elseif Time.tick_to_hour(player.online_time) >= Time_Rank.RANKS.lvl4.time then
      return Time_Rank.RANKS.lvl4
  elseif Time.tick_to_hour(player.online_time) >= Time_Rank.RANKS.lvl3.time then
      return Time_Rank.RANKS.lvl3
  elseif Time.tick_to_hour(player.online_time) >= Time_Rank.RANKS.lvl2.time then
      return Time_Rank.RANKS.lvl2
  elseif Time.tick_to_hour(player.online_time) < Time_Rank.RANKS.lvl2.time then
      return Time_Rank.RANKS.lvl1
  end
  -- Default return
  return Time_Rank.RANKS.lvl1
end

return Time_Rank
