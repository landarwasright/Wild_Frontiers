local H = wesnoth.require "~add-ons/Wild_Frontiers/lua/wf_helper.lua"

-- force_gamestate_change 1.14 by mattsc
local AH = wesnoth.require "ai/lua/ai_helper.lua"
local utils = wesnoth.require "wml-utils"
function utils.force_gamestate_change(ai)
	-- Can be done using any unit of the AI side with moves
	--local unit = wesnoth.get_units { side = wesnoth.current.side }[1]
	local unit = AH.get_units_with_moves { side = wesnoth.current.side }[1]
	local cfg_reset_moves = { id = unit.id, moves = unit.moves, resting = unit.resting, attacks_left = unit.attacks_left }
	ai.stopunit_all(unit)
	wesnoth.sync.invoke_command('reset_moves', cfg_reset_moves)
end

-- reset_moves 1.14 by mattsc
function wesnoth.custom_synced_commands.reset_moves(cfg)
	local unit = wesnoth.units.find_on_map { id = cfg.id }[1]
	unit.resting = cfg.resting
	unit.attacks_left = cfg.attacks_left
	unit.moves = cfg.moves
end

-- force_gamestate_change 1.16 by mattsc
--function utils.force_gamestate_change(ai)
--	-- Can be done using any unit of the AI side; works even if the unit already has 0 moves
--	local unit = wesnoth.units.find_on_map { side = wesnoth.current.side }[1]
--	local cfg_reset_moves = { id = unit.id, moves = unit.moves }
--	ai.stopunit_moves(unit)
--	wesnoth.sync.invoke_command('reset_moves', cfg_reset_moves)
--end

-- reset_moves 1.16 by mattsc
--function wesnoth.custom_synced_commands.reset_moves(cfg)
--	local unit = wesnoth.units.find_on_map { id = cfg.id }[1]
--	unit.moves = cfg.moves
--end

function wesnoth.micro_ais.wf_zone_guardian(cfg)
	if (cfg.action ~= 'delete') and (not cfg.id) and (not wml.get_child(cfg, "filter")) then
		H.wml_error("WF Zone Guardian [micro_ai] tag requires either id= key or [filter] tag")
	end
	local required_keys = { filter_location = 'tag' }
	local optional_keys = { id = 'string', filter = 'tag', filter_location_enemy = 'tag', station_x = 'integer', station_y = 'integer' }
	local CA_parms = {
		ai_id = 'mai_wf_zone_guardian',
		{ ca_id = 'move', location = '~add-ons/Wild_Frontiers/ai/ca_wf_zone_guardian.lua', score = cfg.ca_score or 300000 }
	}
    return required_keys, optional_keys, CA_parms
end

function wesnoth.micro_ais.wf_loiter_guardian(cfg)
	if (cfg.action ~= 'delete') and (not cfg.id) and (not wml.get_child(cfg, "filter")) then
		H.wml_error("WF Loiter Guardian [micro_ai] tag requires either id= key or [filter] tag")
	end
	local required_keys = { filter_location = 'tag' }
	local optional_keys = { id = 'string', filter = 'tag', stationary = 'boolean' }
	local CA_parms = {
		ai_id = 'mai_wf_loiter_guardian',
		{ ca_id = 'move', location = '~add-ons/Wild_Frontiers/ai/ca_wf_loiter_guardian.lua', score = cfg.ca_score or 99900 }
	}
    return required_keys, optional_keys, CA_parms
end

function wesnoth.micro_ais.wf_curse_guardian(cfg)
	if (cfg.action ~= 'delete') and (not cfg.id) and (not wml.get_child(cfg, "filter")) then
		H.wml_error("WF Curse Guardian [micro_ai] tag requires either id= key or [filter] tag")
	end
	local required_keys = { filter_second = 'tag' }
	local optional_keys = { id = 'string', filter = 'tag' }
	local CA_parms = {
		ai_id = 'mai_wf_curse_guardian',
		{ ca_id = 'move', location = '~add-ons/Wild_Frontiers/ai/ca_wf_curse_guardian.lua', score = cfg.ca_score or 99900 }
	}
    return required_keys, optional_keys, CA_parms
end

function wesnoth.micro_ais.wf_goto(cfg)
	local required_keys = { filter_location = 'tag' }
	local optional_keys = {
		avoid_enemies = 'float', filter = 'tag', ignore_units = 'boolean', ignore_enemy_at_goal = 'boolean',
		release_all_units_at_goal = 'boolean', release_unit_at_goal = 'boolean', remove_movement = 'boolean',
		unique_goals = 'boolean', use_straight_line = 'boolean'
	}
	local CA_parms = {
		ai_id = 'mai_wf_goto',
		{ ca_id = 'move', location = '~add-ons/Wild_Frontiers/ai/ca_wf_goto.lua', score = cfg.ca_score or 300000 }
	}
    return required_keys, optional_keys, CA_parms
end

function wesnoth.micro_ais.wf_move_last(cfg)
        if (cfg.action ~= 'delete') and (not cfg.id) and (not wml.get_child(cfg, "filter")) then
                H.wml_error("WF Move Last [micro_ai] tag requires either id= key or [filter] tag")
        end
        local required_keys = {}
        local optional_keys = { id = 'string', filter = 'tag' }
	local score = cfg.ca_score or 300000
        local CA_parms = {
                ai_id = 'mai_wf_move_last',
                { ca_id = 'move', location = '~add-ons/Wild_Frontiers/ai/ca_wf_move_last.lua', score = score }
        }
    return required_keys, optional_keys, CA_parms
end
