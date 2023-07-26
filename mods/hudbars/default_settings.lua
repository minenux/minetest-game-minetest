-- (Hardcoded) default settings

hb.settings.max_bar_length = 160
hb.settings.statbar_length = 20

-- Statbar positions
hb.settings.pos_left = {}
hb.settings.pos_right = {}
hb.settings.start_offset_left = {}
hb.settings.start_offset_right= {}
hb.settings.pos_left.x = hb.load_setting("hudbars_pos_left_x", "number", 0.5)
hb.settings.pos_left.y = hb.load_setting("hudbars_pos_left_y", "number", 1)
hb.settings.pos_right.x = hb.load_setting("hudbars_pos_right_x", "number", 0.5)
hb.settings.pos_right.y = hb.load_setting("hudbars_pos_right_y", "number", 1)
hb.settings.bar_type = hb.load_setting("hudbars_bar_type", "string", "progress_bar", {"progress_bar", "statbar_classic", "statbar_modern"})
if hb.settings.bar_type == "progress_bar" then
	hb.settings.start_offset_left.x = hb.load_setting("hudbars_start_offset_left_x", "number", -175)
	hb.settings.start_offset_left.y = hb.load_setting("hudbars_start_offset_left_y", "number", -86)
	hb.settings.start_offset_right.x = hb.load_setting("hudbars_start_offset_right_x", "number", 15)
	hb.settings.start_offset_right.y = hb.load_setting("hudbars_start_offset_right_y", "number", -86)
else
	hb.settings.start_offset_left.x = hb.load_setting("hudbars_start_statbar_offset_left_x", "number", -265)
	hb.settings.start_offset_left.y = hb.load_setting("hudbars_start_statbar_offset_left_y", "number", -90)
	hb.settings.start_offset_right.x = hb.load_setting("hudbars_start_statbar_offset_right_x", "number", 25)
	hb.settings.start_offset_right.y = hb.load_setting("hudbars_start_statbar_offset_right_y", "number", -90)
end
hb.settings.vmargin  = hb.load_setting("hudbars_vmargin", "number", 24)
hb.settings.tick = hb.load_setting("hudbars_tick", "number", 0.3)

-- Experimental setting: Changing this setting is not officially supported, do NOT rely on it!
hb.settings.forceload_default_hudbars = hb.load_setting("hudbars_forceload_default_hudbars", "bool", true)

-- Misc. settings
hb.settings.alignment_pattern = hb.load_setting("hudbars_alignment_pattern", "string", "zigzag", {"zigzag", "stack_up", "stack_down"})
hb.settings.autohide_breath = hb.load_setting("hudbars_autohide_breath", "bool", (true and not hb.settings.forceload_default_hudbars))

local sorting = minetest.settings:get("hudbars_sorting")
if sorting ~= nil then
	hb.settings.sorting = {}
	hb.settings.sorting_reverse = {}
	for k,v in string.gmatch(sorting, "(%w+)=(%w+)") do
		hb.settings.sorting[k] = tonumber(v)
		hb.settings.sorting_reverse[tonumber(v)] = k
	end
else
	hb.settings.sorting = { ["health"] = 0, ["breath"] = 1 }
	hb.settings.sorting_reverse = { [0] = "health", [1] = "breath" }
end

hb.settings.hp_player_maximun = hb.load_setting("hudbars_hp_player_maximun", "number", 40)
hb.settings.br_player_maximun = hb.load_setting("hudbars_br_player_maximun", "number", 20)

hbarmor.autohide = (true and not hb.settings.forceload_default_hudbars)

hbhunger.HUD_TICK = 0.2

hbhunger.HUNGER_TICK = 800 -- time in seconds after that 1 hunger point is taken
hbhunger.EXHAUST_DIG = 3  -- exhaustion increased this value after digged node
hbhunger.EXHAUST_PLACE = 1 -- exhaustion increased this value after placed
hbhunger.EXHAUST_MOVE = 0.2 -- exhaustion increased this value if player movement detected
hbhunger.EXHAUST_LVL = 160 -- at what exhaustion player satiation gets lowerd
hbhunger.SAT_MAX = 30 -- maximum satiation points
hbhunger.SAT_INIT = 20 -- initial satiation points
hbhunger.SAT_HEAL = 15 -- required satiation points to start healing

local set

set = minetest.settings:get_bool("hbarmor_autohide") if set ~= nil then hbarmor.autohide = set end
set = minetest.settings:get("hbhunger_satiation_tick") if set ~= nil then hbhunger.HUNGER_TICK = tonumber(set) end
set = minetest.settings:get("hbhunger_satiation_dig") if set ~= nil then hbhunger.HUNGER_DIG = tonumber(set) end
set = minetest.settings:get("hbhunger_satiation_place") if set ~= nil then hbhunger.HUNGER_PLACE = tonumber(set) end
set = minetest.settings:get("hbhunger_satiation_move") if set ~= nil then hbhunger.HUNGER_MOVE = tonumber(set) end
set = minetest.settings:get("hbhunger_satiation_lvl") if set ~= nil then hbhunger.HUNGER_LVL = tonumber(set) end
