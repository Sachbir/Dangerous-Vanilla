----------------------------------------------------------------------------------------------------------------------------------------
-- Create Polls for your Factory Workers                                
-- by MewMew -- with some help from RedLabel, Klonan, Morcup, BrainClot   
----------------------------------------------------------------------------------------------------------------------------------------


local function create_poll_gui(event)
	local player = game.players[event.player_index]
	
	if player.gui.top.poll == nil then
		local button = player.gui.top.add { name = "poll", type = "sprite-button", sprite = "item/programmable-speaker" }
		button.style.font = "default-bold"
		button.style.minimal_height = 38
		button.style.minimal_width = 38
		button.style.top_padding = 2
		button.style.left_padding = 4
		button.style.right_padding = 4
		button.style.bottom_padding = 2
	end
end

local function poll_show(player)
	
	local frame = player.gui.left.add { type = "frame", name = "poll-panel", direction = "vertical" }		
		frame.add { type = "table", name = "poll_panel_table", colspan = 2 }
		
		local poll_panel_table = frame.poll_panel_table
		
		if not (global.poll_question == "") then
			poll_panel_table.add { type = "label", caption = global.poll_question, single_line = false, name = "question_label" }
			poll_panel_table.question_label.style.maximal_width = 250
			poll_panel_table.question_label.style.maximal_height = 180
			poll_panel_table.question_label.style.font = "default-listbox"
			poll_panel_table.add { type = "label" }
		end
		
		local y = 1
		while (y < 4) do
	
			if not (global.poll_answers[y] == "") then		
			
				local z = tostring(y)
				
				poll_panel_table.add { type = "label", caption = global.poll_answers[y], single_line = false, name = "answer_label_" .. z }
				local answer_label = poll_panel_table["answer_label_" .. z]
				answer_label.style.maximal_width = 220
				answer_label.style.minimal_width = 140
				answer_label.style.maximal_height = 170
				answer_label.style.font = "default"
				
				poll_panel_table.add  { type = "button", caption = global.poll_button_votes[y], name = "answer_button_" .. z }	
			
			end
			y = y + 1
		end
		
		frame.add { type = "table", name = "poll_panel_button_table", colspan = 2 }
		local poll_panel_button_table = frame.poll_panel_button_table
		if player.admin then
			poll_panel_button_table.add { type = "button", caption = "New Poll", name = "new_poll_assembler_button" }
		end
		poll_panel_button_table.add { type = "button", caption = "Hide", name = "poll_hide_button" }	
		poll_panel_button_table.new_poll_assembler_button.style.font = "default-bold"
		poll_panel_button_table.new_poll_assembler_button.style.minimal_height = 38
		poll_panel_button_table.poll_hide_button.style.font = "default-bold"		
		poll_panel_button_table.poll_hide_button.style.minimal_height = 38
	
end

local function poll(player)
	
	local frame = player.gui.left["poll-assembler"]
	frame = frame.table_poll_assembler
	
	global.poll_question = ""
	global.poll_question = frame.textfield_question.text
	if (global.poll_question == "") then
		return
	end
	
	
	global.poll_answers = {"","",""}
	global.poll_answers[1] = frame.textfield_answer_1.text
	global.poll_answers[2] = frame.textfield_answer_2.text
	global.poll_answers[3] = frame.textfield_answer_3.text
	if (global.poll_answers[3] .. global.poll_answers[2] .. global.poll_answers[1] == "") then
		return
	end
	
	local msg = player.name
	msg = msg .. " has created a new Poll!"
	
	local frame = player.gui.left["poll-assembler"]
	frame.destroy()
	
	global.poll_voted = nil		
	global.poll_voted  = {}
	global.poll_button_votes = {0,0,0}
	
	local x = 1
	
	while (game.players[x] ~= nil) do
	
		local player = game.players[x]
		
		local frame = player.gui.left["poll-panel"]	
	
		if (frame) then
				frame.destroy()
		end
		
		poll_show(player)
		
		player.print(msg)
		
		x = x + 1
	end
	
end


local function poll_refresh()
	
	local x = 1
	
	while (game.players[x] ~= nil) do
	
		local player = game.players[x]
		
		if (player.gui.left["poll-panel"]) then		
			local frame = player.gui.left["poll-panel"]
			frame = frame.poll_panel_table
		
				if not (frame.answer_button_1 == nil) then		
					frame.answer_button_1.caption = global.poll_button_votes[1]
				end
				if not (frame.answer_button_2 == nil) then		
					frame.answer_button_2.caption = global.poll_button_votes[2]
				end
				if not (frame.answer_button_3 == nil) then		
					frame.answer_button_3.caption = global.poll_button_votes[3]
				end										
		end
		x = x + 1
	end
		
end

local function poll_assembler(player)				
	local frame = player.gui.left.add { type = "frame", name = "poll-assembler", caption = "" }	
	local frame_table = frame.add { type = "table", name = "table_poll_assembler", colspan = 2 }
	frame_table.add { type = "label", caption = "Question:" }
	frame_table.add { type = "textfield", name = "textfield_question", text = "" }
	frame_table.add { type = "label", caption = "Answer #1:" }
	frame_table.add { type = "textfield", name = "textfield_answer_1", text = "" }
	frame_table.add { type = "label", caption = "Answer #2:" }
	frame_table.add { type = "textfield", name = "textfield_answer_2", text = "" }
	frame_table.add { type = "label", caption = "Answer #3:" }
	frame_table.add { type = "textfield", name = "textfield_answer_3", text = "" }
	frame_table.add { type = "label", caption = "" }
	frame_table.add { type = "button", name = "create_new_poll_button", caption = "Create" }

end

function poll_sync_for_new_joining_player(event)
	
	if not global.poll_voted then
	
		global.poll_question = ""
		global.poll_answers = {"","",""}
		global.poll_button_votes = {0,0,0}
		global.poll_voted = {}
	
	else
		local player = game.players[event.player_index]
		if (player.gui.top.poll-panel == nil) then
			poll_show(player)
			--poll_refresh()
		end	
	
	end
end

local function on_gui_click(event)
	if not (event and event.element and event.element.valid) then return end
		local player = game.players[event.element.player_index]
		local name = event.element.name
		
		if (name == "poll") then
			local frame = player.gui.left["poll-panel"]
			if (frame) then
				frame.destroy()
			else
				poll_show(player)
			end
			
			local frame = player.gui.left["poll-assembler"]
			if (frame) then
				frame.destroy()
			end
		end
		
		if (name == "new_poll_assembler_button") then
			local frame = player.gui.left["poll-assembler"]
			if (frame) then
				frame.destroy()
			else
				poll_assembler(player)
			end
		end
		
		if (name == "poll_hide_button") then
			local frame = player.gui.left["poll-panel"]
			if (frame) then
				frame.destroy()
			end
			local frame = player.gui.left["poll-assembler"]
			if (frame) then
				frame.destroy()
			end
		end
		
		if (name == "create_new_poll_button") then			
				poll(player)
		end		
		
		if global.poll_voted[event.player_index] == nil then		
			
			if(name == "answer_button_1") then
				global.poll_button_votes[1] = global.poll_button_votes[1] + 1
				global.poll_voted[event.player_index] = player.name
				poll_refresh()
			end
				
			if(name == "answer_button_2") then
				global.poll_button_votes[2] = global.poll_button_votes[2] + 1
				global.poll_voted[event.player_index] = player.name
				poll_refresh()
			end
				
			if(name == "answer_button_3") then
				global.poll_button_votes[3] = global.poll_button_votes[3] + 1
				global.poll_voted[event.player_index] = player.name
				poll_refresh()
			end
			
		end					
end



Event.register(defines.events.on_gui_click, on_gui_click)
Event.register(defines.events.on_player_joined_game, create_poll_gui)
Event.register(defines.events.on_player_joined_game, poll_sync_for_new_joining_player)