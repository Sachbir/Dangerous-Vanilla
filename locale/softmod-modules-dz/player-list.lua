-- Player List Soft Mod
-- Adds a player list sidebar that displays online players along with their online time.
-- @author Denis Zholob (DDDGamer)
-- github: https://github.com/DDDGamer/factorio-dz-softmod
-- ======================================================= --

-- Dependencies
require "locale/softmod-modules-util/GUI"
require "locale/softmod-modules-util/Time"
require "locale/softmod-modules-util/Time_Rank"
require "locale/softmod-modules-util/Colors"
require "locale/softmod-modules-util/Playtime_Log"

local OWNER = "UberJuice"

-- Roles
local ROLES = {
  owner =   { tag = "Owner",  color = Colors.red    }, -- server owner
  admin =   { tag = "Admin",  color = Colors.orange }, -- server admin
}


-- When new player joins add the playerlist btn to their GUI
-- Redraw the playerlist frame to update with the new player
-- @param event on_player_joined_game
function on_player_join(event)
  local player = game.players[event.player_index]
  draw_playerlist_btn(player)
  draw_playerlist_frame()
end


-- On Player Leave
-- Clean up the GUI in case this mod gets removed next time
-- Redraw the playerlist frame to update
-- @param event on_player_left_game
function on_player_leave(event)
  local player = game.players[event.player_index]
  if player.gui.left["frame_playerlist"] ~= nil then
    player.gui.left["frame_playerlist"].destroy()
  end
  if player.gui.top["btn_menu_playerlist"] ~= nil then
    player.gui.top["btn_menu_playerlist"].destroy()
  end
  draw_playerlist_frame()
end


-- Does things if a gui element is clicked
-- @param event on_gui_click
local function on_gui_click(event)
  local player = game.players[event.player_index]
  local el_name = event.element.name

  if el_name == "btn_menu_playerlist" then
    GUI.toggle_element(player.gui.left["frame_playerlist"])
  end

  if el_name == "save_playtimes" then
    Playtime_Log.generate_log()
  end
end


-- Create button for player if doesnt exist already
-- @param player
function draw_playerlist_btn(player)
  if player.gui.top["btn_menu_playerlist"] == nil then
    player.gui.top.add { type = "button", name = "btn_menu_playerlist", caption = "Online Players", tooltip = "Shows who is on the server" }
  end
end


-- Draws a pane on the left listing all of the players currentely on the server, and a save button for admins
function draw_playerlist_frame()
  for i, player in pairs(game.players) do
    -- Draw the vertical frame on the left if its not drawn already
    if player.gui.left["frame_playerlist"] == nil then
      player.gui.left.add { type = "frame", name = "frame_playerlist", direction = "vertical" }
    end
    -- Clear and repopulate player list
    GUI.clear_element(player.gui.left["frame_playerlist"])
    for j, p_online in pairs(game.connected_players) do
      -- Admins
      if p_online.admin == true then
        if p_online.name == OWNER then
          add_player_to_list(player, p_online, ROLES.owner.color, ROLES.owner.tag)
        else
          add_player_to_list(player, p_online, ROLES.admin.color, ROLES.admin.tag)
        end
      -- Players
      else
        local player_rank = Time_Rank.get_rank(p_online)
        add_player_to_list(player, p_online, player_rank.color, player_rank.tag)
      end
    end
    if player.admin then
      player.gui.left["frame_playerlist"].add { type = "button", caption = "Save Times", name = "save_playtimes", tooltip = "Saves played time to a file" }
    end
  end
end


-- Add a player to the GUI list
-- @param player
-- @param p_online
-- @param color
-- @param tag
function add_player_to_list(player, p_online, color, tag)
  local played_hrs = tostring(Time.tick_to_hour(Playtime_Log.get_total_ticks(p_online)))  
  if (tag == "") then
    player.gui.left["frame_playerlist"].add {
      type = "label", style = "caption_label_style", name = p_online.name,
      caption = { "", played_hrs, " hr - ", p_online.name }
    }
    player.gui.left["frame_playerlist"][p_online.name].style.font_color = color
    p_online.tag = ""
  else
    player.gui.left["frame_playerlist"].add {
      type = "label", style = "caption_label_style", name = p_online.name,
      caption = { "", played_hrs, " hr - ", p_online.name, " ", "[" .. tag .. "]" }
    }
    player.gui.left["frame_playerlist"][p_online.name].style.font_color = color
    p_online.tag = "[" .. tag .. "]"
  end
end


-- Refresh the playerlist after 10 min
-- @param event on_tick
function on_tick(event)
  global.last_refresh = global.last_refresh or 0
  local cur_time = game.tick / 60
  local refresh_period = 10 -- 600 seconds (10 min)
  local refresh_time_passed = cur_time - global.last_refresh
  if refresh_time_passed > refresh_period then
    draw_playerlist_frame()
    global.last_refresh = cur_time
  end
end


-- Event Handlers
Event.register(defines.events.on_gui_click, on_gui_click)
Event.register(defines.events.on_player_joined_game, on_player_join)
Event.register(defines.events.on_player_left_game, on_player_leave)
Event.register(defines.events.on_tick, on_tick)
