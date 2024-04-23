
local S
-- Intllib
if minetest.get_translator ~= nil then
	S = minetest.get_translator("hudbars") -- 5.x translation function
else
	if minetest.get_modpath("intllib") then
		dofile(minetest.get_modpath("intllib") .. "/init.lua")
		if intllib.make_gettext_pair then
			gettext, ngettext = intllib.make_gettext_pair() -- new gettext method
		else
			gettext = intllib.Getter() -- old text file method
		end
		S = gettext
	else -- boilerplate function
		S = function(str, ...)
			local args = {...}
			return str:gsub("@%d+", function(match)
				return args[tonumber(match:sub(2))]
			end)
		end
	end
end

local N = function(s) return s end

local modarmors = minetest.get_modpath("3d_armor")
local modhbarm = minetest.get_modpath("hbarmor")
local modhbhung = minetest.get_modpath("hbhunger")

if modarmors then
	if (not armor) or (not armor.def) then
		minetest.log("error", "[hbarmor] Outdated 3d_armor version. Please update your version of 3d_armor!")
	end
end

hb = {}
hb.version = "2.3.5.0"
hb.redo = true

hb.hudtables = {}

-- number of registered HUD bars
hb.hudbars_count = 0

-- table which records which HUD bar slots have been “registered” so far; used for automatic positioning
hb.registered_slots = {}

-- Table which contains all players with active default HUD bars (only for internal use)
hb.players = {}

hbarmor = {}
hbhunger = {}

-- HUD item ids
local hunger_hud = {}

-- Stores if player's HUD bar has been initialized so far.
hbarmor.player_active = {}

-- HUD statbar values
hbarmor.armor = {}
hbhunger.food = {}
hbhunger.hunger = {}
hbhunger.hunger_out = {}
hbhunger.poisonings = {}
hbhunger.exhaustion = {} -- Exhaustion is experimental!

-- If true, the armor bar is hidden when the player does not wear any armor
hbarmor.autohide = true

hb.settings = {}

function hb.load_setting(sname, stype, defaultval, valid_values)
	local sval
	if stype == "string" then
		sval = minetest.settings:get(sname)
	elseif stype == "bool" then
		sval = minetest.settings:get_bool(sname)
	elseif stype == "number" then
		sval = tonumber(minetest.settings:get(sname))
	end
	if sval ~= nil then
		if valid_values ~= nil then
			local valid = false
			for i=1,#valid_values do
				if sval == valid_values[i] then
					valid = true
				end
			end
			if not valid then
				minetest.log("error", "[hudbars] Invalid value for "..sname.."! Using default value ("..tostring(defaultval)..").")
				return defaultval
			else
				return sval
			end
		else
			return sval
		end
	else
		return defaultval
	end
end

-- Load default settings
dofile(minetest.get_modpath("hudbars").."/default_settings.lua")

local serverinfo = minetest.get_version()
local statusinfo = serverinfo.string

if string.find(statusinfo,"0.4.1") and not string.find(statusinfo,"0.4.18") and not string.find(statusinfo,"0.4.17.3") then
	hb.settings.hp_player_maximun = 20
	hb.settings.br_player_maximun = 10
	minetest.log("error","[hudbars] minetest version do not support customization of hp_max healt player values")
	minetest.PLAYER_MAX_HP = hb.settings.hp_player_maximun
else
	minetest.PLAYER_MAX_HP_DEFAULT = hb.settings.hp_player_maximun
end
-- all settings configured

if not modhbhung then

	-- due lackof global hbhunger these need to be first
	hbhunger.get_hunger_raw = function(player)
		local inv = player:get_inventory()
		if not inv then return nil end
		local hgp = inv:get_stack("hunger", 1):get_count()
		if hgp == 0 then
			hgp = 21
			inv:set_stack("hunger", 1, ItemStack({name=":", count=hgp}))
		else
			hgp = hgp
		end
		return hgp-1
	end

	hbhunger.set_hunger_raw = function(player)
		local inv = player:get_inventory()
		local name = player:get_player_name()
		local value = hbhunger.hunger[name]
		if not inv  or not value then return nil end
		if value > hbhunger.SAT_MAX then value = hbhunger.SAT_MAX end
		if value < 0 then value = 0 end
		
		inv:set_stack("hunger", 1, ItemStack({name=":", count=value+1}))

		return true
	end

	-- Load hunger management function for food and mod handling
	dofile(minetest.get_modpath("hudbars").."/hunger.lua")
	dofile(minetest.get_modpath("hudbars").."/register_foods.lua")

end

local function player_exists(player)
	return player ~= nil and (type(player) == "userdata") 
end

local must_hide = function(playername, arm)
	if modarmors then
		return ((not armor.def[playername].count or armor.def[playername].count == 0 or not hb.settings.forceload_default_hudbars) and arm == 0)
	end
	return (modarmors and hbarmor.autohide)
end

local arm_printable = function(arm)
	return math.ceil(math.floor(arm+0.5))
end


local function make_label(format_string, format_string_config, label, start_value, max_value)
	local params = {}
	local order = format_string_config.order
	for o=1, #order do
		if order[o] == "label" then
			table.insert(params, label)
		elseif order[o] == "value" then
			if format_string_config.format_value then
				table.insert(params, string.format(format_string_config.format_value, start_value))
			else
				table.insert(params, start_value)
			end
		elseif order[o] == "max_value" then
			if format_string_config.format_max_value then
				table.insert(params, string.format(format_string_config.format_max_value, max_value))
			else
				table.insert(params, max_value)
			end
		end
	end
	local ret
	if format_string_config.textdomain and minetest.translate ~= nil then
		ret = minetest.translate(format_string_config.textdomain, format_string, unpack(params))
	else
		ret = S(format_string, unpack(params))
	end
	return ret
end

function hb.value_to_barlength(value, max)
	if max == 0 then
		return 0
	else
		if hb.settings.bar_type == "progress_bar" then
			local x
			if value < 0 then x=-0.5 else x = 0.5 end
			local ret = math.modf((value/max) * hb.settings.max_bar_length + x)
			return ret
		else
			local x
			if value < 0 then x=-0.5 else x = 0.5 end
			local ret = math.modf((value/max) * hb.settings.statbar_length + x)
			return ret
		end
	end
end

function hb.get_hudtable(identifier)
	return hb.hudtables[identifier]
end

function hb.get_hudbar_position_index(identifier)
	if hb.settings.sorting[identifier] ~= nil then
		return hb.settings.sorting[identifier]
	else
		local i = 0
		while true do
			if hb.registered_slots[i] ~= true and hb.settings.sorting_reverse[i] == nil then
				return i
			end
			i = i + 1
		end
	end
end

function hb.register_hudbar(identifier, text_color, label, textures, default_start_value, default_start_max, default_start_hidden, format_string, format_string_config)
	minetest.log("action", "hb.register_hudbar: "..tostring(identifier))
	local hudtable = {}
	local pos, offset
	local index = math.floor(hb.get_hudbar_position_index(identifier))
	hb.registered_slots[index] = true
	if hb.settings.alignment_pattern == "stack_up" then
		pos = hb.settings.pos_left
		offset = {
			x = hb.settings.start_offset_left.x,
			y = hb.settings.start_offset_left.y - hb.settings.vmargin * index
		}
	elseif hb.settings.alignment_pattern == "stack_down" then
		pos = hb.settings.pos_left
		offset = {
			x = hb.settings.start_offset_left.x,
			y = hb.settings.start_offset_left.y + hb.settings.vmargin * index
		}
	else
		if index % 2 == 0 then
			pos = hb.settings.pos_left
			offset = {
				x = hb.settings.start_offset_left.x,
				y = hb.settings.start_offset_left.y - hb.settings.vmargin * (index/2)
			}
		else
			pos = hb.settings.pos_right
			offset = {
				x = hb.settings.start_offset_right.x,
				y = hb.settings.start_offset_right.y - hb.settings.vmargin * ((index-1)/2)
			}
		end
	end
	if format_string == nil then
		format_string = N("@1: @2/@3")
	end
	if format_string_config == nil then
		format_string_config = {}
	end
	if format_string_config.order == nil then
		format_string_config.order = { "label", "value", "max_value" }
	end
	if format_string_config.format_value == nil then
		format_string_config.format_value = "%02d"
	end
	if format_string_config.format_max_value == nil then
		format_string_config.format_max_value = "%02d"
	end

	hudtable.add_all = function(player, hudtable, start_value, start_max, start_hidden)
		if start_value == nil then start_value = hudtable.default_start_value end
		if start_max == nil then start_max = hudtable.default_start_max end
		if start_hidden == nil then start_hidden = hudtable.default_start_hidden end
		local ids = {}
		local state = {}
		local name = player:get_player_name()
		local bgscale, iconscale, text, barnumber, bgiconnumber
		if start_max == 0 or start_hidden then
			bgscale = { x=0, y=0 }
		else
			bgscale = { x=1, y=1 }
		end
		if start_hidden then
			iconscale = { x=0, y=0 }
			barnumber = 0
			bgiconnumber = 0
			text = ""
		else
			iconscale = { x=1, y=1 }
			barnumber = hb.value_to_barlength(start_value, start_max)
			bgiconnumber = hb.settings.statbar_length
			text = make_label(format_string, format_string_config, label, start_value, start_max)
		end
		if hb.settings.bar_type == "progress_bar" then
			ids.bg = player:hud_add({
				hud_elem_type = "image",
				position = pos,
				scale = bgscale,
				text = "",
				alignment = {x=1,y=1},
				offset = { x = offset.x - 1, y = offset.y - 1 },
				z_index = 0,
			})
			if textures.icon ~= nil then
				ids.icon = player:hud_add({
					hud_elem_type = "image",
					position = pos,
					scale = iconscale,
					text = textures.icon,
					alignment = {x=-1,y=1},
					offset = { x = offset.x - 3, y = offset.y },
					z_index = 1,
				})
			end
		elseif hb.settings.bar_type == "statbar_modern" then
			if textures.bgicon ~= nil then
				ids.bg = player:hud_add({
					hud_elem_type = "statbar",
					position = pos,
					text = textures.bgicon,
					number = bgiconnumber,
					alignment = {x=-1,y=-1},
					offset = { x = offset.x, y = offset.y },
					direction = 0,
					size = {x=24, y=24},
					z_index = 0,
				})
			end
		end
		local bar_image, bgicon, bar_size
		if hb.settings.bar_type == "progress_bar" then
			bar_image = textures.bar
			-- NOTE: Intentionally set to nil. For some reason, on some systems,
			-- the progress bar is displaced when the bar_size is set explicitly here.
			-- On the other hand, setting this to nil is deprecated in MT 5.0.0 due to
			-- a debug log warning, but nothing is explained in lua_api.txt.
			-- This section is a potential bug magnet, please watch with care!
			-- The size of the bar image is expected to be exactly 2×16 pixels.
			bar_size = nil
		elseif hb.settings.bar_type == "statbar_classic" or hb.settings.bar_type == "statbar_modern" then
			bar_image = textures.icon
			if textures.bgicon then bgicon = textures.bgicon end
			bar_size = {x=24, y=24}
		end
		ids.bar = player:hud_add({
			hud_elem_type = "statbar",
			position = pos,
			text = bar_image,
			text2 = bgicon,
			number = barnumber,
			item = bgiconnumber,
			alignment = {x=-1,y=-1},
			offset = offset,
			direction = 0,
			size = bar_size,
			z_index = 1,
		})
		if hb.settings.bar_type == "progress_bar" then
			ids.text = player:hud_add({
				hud_elem_type = "text",
				position = pos,
				text = text,
				alignment = {x=1,y=1},
				number = text_color,
				direction = 0,
				offset = { x = offset.x + 2,  y = offset.y - 1},
				z_index = 2,
		})
		end
		-- Do not forget to update hb.get_hudbar_state if you add new fields to the state table
		state.hidden = start_hidden
		state.value = start_value
		state.max = start_max
		state.text = text
		state.barlength = hb.value_to_barlength(start_value, start_max)

		local main_error_text =
			"[hudbars] Bad initial values of HUD bar identifier “"..tostring(identifier).."” for player "..name..". "

		if start_max < start_value then
			minetest.log("error", main_error_text.."start_max ("..start_max..") is smaller than start_value ("..start_value..")!")
		end
		if start_max < 0 then
			minetest.log("error", main_error_text.."start_max ("..start_max..") is smaller than 0!")
		end
		if start_value < 0 then
			minetest.log("error", main_error_text.."start_value ("..start_value..") is smaller than 0!")
		end

		hb.hudtables[identifier].hudids[name] = ids
		hb.hudtables[identifier].hudstate[name] = state
	end

	hudtable.identifier = identifier
	hudtable.format_string = format_string
	hudtable.format_string_config = format_string_config
	hudtable.label = label
	hudtable.hudids = {}
	hudtable.hudstate = {}
	hudtable.default_start_hidden = default_start_hidden
	hudtable.default_start_value = default_start_value
	hudtable.default_start_max = default_start_max

	hb.hudbars_count= hb.hudbars_count + 1
	
	hb.hudtables[identifier] = hudtable
end

function hb.init_hudbar(player, identifier, start_value, start_max, start_hidden)
	if not player_exists(player) then return false end
	local hudtable = hb.get_hudtable(identifier)
	hb.hudtables[identifier].add_all(player, hudtable, start_value, start_max, start_hidden)
	return true
end

function hb.change_hudbar(player, identifier, new_value, new_max_value, new_icon, new_bgicon, new_bar, new_label, new_text_color)
	if new_value == nil and new_max_value == nil and new_icon == nil and new_bgicon == nil and new_bar == nil and new_label == nil and new_text_color == nil then
		return true
	end
	if not player_exists(player) then
		return false
	end

	local name = player:get_player_name()
	local hudtable = hb.get_hudtable(identifier)
	if not hudtable.hudstate[name] then
		return false
	end
	local value_changed, max_changed = false, false

	if new_value ~= nil then
		if new_value ~= hudtable.hudstate[name].value then
			hudtable.hudstate[name].value = new_value
			value_changed = true
		end
	else
		new_value = hudtable.hudstate[name].value
	end
	if new_max_value ~= nil then
		if new_max_value ~= hudtable.hudstate[name].max then
			hudtable.hudstate[name].max = new_max_value
			max_changed = true
		end
	else
		new_max_value = hudtable.hudstate[name].max
	end

	if hb.settings.bar_type == "progress_bar" then
		if new_icon ~= nil and hudtable.hudids[name].icon ~= nil then
			player:hud_change(hudtable.hudids[name].icon, "text", new_icon)
		end
		if new_bgicon ~= nil and hudtable.hudids[name].bgicon ~= nil then
			player:hud_change(hudtable.hudids[name].bgicon, "text", new_bgicon)
		end
		if new_bar ~= nil then
			player:hud_change(hudtable.hudids[name].bar , "text", new_bar)
		end
		if new_label ~= nil then
			hudtable.label = new_label
			local new_text = make_label(hudtable.format_string, hudtable.format_string_config, new_label, hudtable.hudstate[name].value, hudtable.hudstate[name].max)
			player:hud_change(hudtable.hudids[name].text, "text", new_text)
		end
		if new_text_color ~= nil then
			player:hud_change(hudtable.hudids[name].text, "number", new_text_color)
		end
	else
		if new_icon ~= nil and hudtable.hudids[name].bar ~= nil then
			player:hud_change(hudtable.hudids[name].bar, "text", new_icon)
		end
		if new_bgicon ~= nil and hudtable.hudids[name].bg ~= nil then
			player:hud_change(hudtable.hudids[name].bg, "text", new_bgicon)
		end
	end

	local main_error_text =
		"[hudbars] Bad call to hb.change_hudbar, identifier: “"..tostring(identifier).."”, player name: “"..name.."”. "
	if new_max_value < new_value then
		minetest.log("error", main_error_text.."new_max_value ("..new_max_value..") is smaller than new_value ("..new_value..")!")
	end
	if new_max_value < 0 then
		minetest.log("error", main_error_text.."new_max_value ("..new_max_value..") is smaller than 0!")
	end
	if new_value < 0 then
		minetest.log("error", main_error_text.."new_value ("..new_value..") is smaller than 0!")
	end

	if hudtable.hudstate[name].hidden == false then
		if max_changed and hb.settings.bar_type == "progress_bar" then
			if hudtable.hudstate[name].max == 0 then
				player:hud_change(hudtable.hudids[name].bg, "scale", {x=0,y=0})
			else
				player:hud_change(hudtable.hudids[name].bg, "scale", {x=1,y=1})
			end
		end

		if value_changed or max_changed then
			local new_barlength = hb.value_to_barlength(new_value, new_max_value)
			if new_barlength ~= hudtable.hudstate[name].barlength then
				player:hud_change(hudtable.hudids[name].bar, "number", hb.value_to_barlength(new_value, new_max_value))
				hudtable.hudstate[name].barlength = new_barlength
			end

			if hb.settings.bar_type == "progress_bar" then
				local new_text = make_label(hudtable.format_string, hudtable.format_string_config, hudtable.label, new_value, new_max_value)
				if new_text ~= hudtable.hudstate[name].text then
					player:hud_change(hudtable.hudids[name].text, "text", new_text)
					hudtable.hudstate[name].text = new_text
				end
			end
		end
	end
	return true
end

function hb.hide_hudbar(player, identifier)
	if not player_exists(player) then return false end
	local name = player:get_player_name()
	local hudtable = hb.get_hudtable(identifier)
	if hudtable == nil then return false end
	if not hudtable.hudstate[name] then return false end
	if not hudtable.hudstate[name].hidden then return false end
	if hudtable.hudstate[name].hidden == true then return true end
	if hb.settings.bar_type == "progress_bar" then
		if hudtable.hudids[name].icon ~= nil then
			player:hud_change(hudtable.hudids[name].icon, "scale", {x=0,y=0})
		end
		player:hud_change(hudtable.hudids[name].bg, "scale", {x=0,y=0})
		player:hud_change(hudtable.hudids[name].text, "text", "")
	end
	player:hud_change(hudtable.hudids[name].bar, "number", 0)
	player:hud_change(hudtable.hudids[name].bar, "item", 0)
	hudtable.hudstate[name].hidden = true
	return true
end

function hb.unhide_hudbar(player, identifier)
	if not player_exists(player) then return false end
	local name = player:get_player_name()
	local hudtable = hb.get_hudtable(identifier)
	if hudtable == nil then return false end
	if not hudtable.hudstate[name] then return false end
	if not hudtable.hudstate[name].hidden then return false end
	local value = hudtable.hudstate[name].value
	local max = hudtable.hudstate[name].max
	if hb.settings.bar_type == "progress_bar" then
		if hudtable.hudids[name].icon ~= nil then
			player:hud_change(hudtable.hudids[name].icon, "scale", {x=1,y=1})
		end
		if hudtable.hudstate[name].max ~= 0 then
			player:hud_change(hudtable.hudids[name].bg, "scale", {x=1,y=1})
		end
		player:hud_change(hudtable.hudids[name].text, "text", make_label(hudtable.format_string, hudtable.format_string_config, hudtable.label, value, max))
	elseif hb.settings.bar_type == "statbar_modern" then
		player:hud_change(hudtable.hudids[name].bar, "scale", {x=1,y=1})
	end
	player:hud_change(hudtable.hudids[name].bar, "number", hb.value_to_barlength(value, max))
	player:hud_change(hudtable.hudids[name].bar, "item", hb.value_to_barlength(max, max))
	hudtable.hudstate[name].hidden = false
	return true
end

function hb.get_hudbar_state(player, identifier)
	if not player_exists(player) then return nil end
	local ref = hb.get_hudtable(identifier).hudstate[player:get_player_name()]
	if not ref then return nil end
	-- Do not forget to update this chunk of code in case the state changes
	local copy = {
		hidden = ref.hidden,
		value = ref.value,
		max = ref.max,
		text = ref.text,
		barlength = ref.barlength,
	}
	return copy
end

function hb.get_hudbar_identifiers()
	local ids = {}
	for id, _ in pairs(hb.hudtables) do
		table.insert(ids, id)
	end
	return ids
end

--register built-in HUD bars and armor HUD bar
if minetest.settings:get_bool("enable_damage") or hb.settings.forceload_default_hudbars then
	local hicon = "hudbars_icon_health.png"
	local bicon = "hudbars_icon_breath.png"
	local aicon = "hbarmor_icon.png"
	local sicon = "hbhunger_icon.png"
	hb.register_hudbar("health",    0xFFFFFF, S("Health"),    { bar = "hudbars_bar_health.png", icon = hicon, bgicon = nil }, hb.settings.hp_player_maximun, hb.settings.hp_player_maximun, false)
	hb.register_hudbar("breath",    0xFFFFFF, S("Breath"),    { bar = "hudbars_bar_breath.png", icon = bicon, bgicon = nil }, hb.settings.br_player_maximun, hb.settings.br_player_maximun, false)
	if not modhbarm then
		hb.register_hudbar("armor",     0xFFFFFF, S("Armor"),     { bar = "hbarmor_bar.png",        icon = aicon, bgicon = nil }, 0, 100, hbarmor.autohide, N("@1: @2%"), { order = { "label", "value" } } )
	end
	if not modhbhung then
		hb.register_hudbar("satiation", 0xFFFFFF, S("Satiation"), { bar = "hbhunger_bar.png",       icon = sicon, bgicon = nil }, hbhunger.SAT_INIT, hbhunger.SAT_MAX, false, nil, { format_value = "%02.0f", format_max_value = "%02.0f" })
	end
end

local function hide_builtin(player)
	local flags = player:hud_get_flags()
	flags.healthbar = false
	flags.breathbar = false
	player:hud_set_flags(flags)
end

if not modhbarm and modarmors then

	function hbarmor.get_armor(player)
		if not player or not armor.def then
			return false
		end
		local name = player:get_player_name()

		local def = armor.def[name] or nil
		if def and def.state and def.count then
			hbarmor.set_armor(name, def.state, def.count)
		else
			minetest.log("error", "[hudbars] Call to hbarmor.get_armor returned with false!")
			return false
		end
		return true
	end

	function hbarmor.set_armor(player_name, ges_state, items)
		local max_items = 4
		if items == 5 then max_items = items end
		local max = max_items * 65535
		local lvl = max - ges_state
		lvl = lvl/max
		if ges_state == 0 and items == 0 then lvl = 0 end

		hbarmor.armor[player_name] = math.max(0, math.min(lvl* (items * (100 / max_items)), 100))
	end

end

local function custom_hud(player)
	local name = player:get_player_name()

	if minetest.settings:get_bool("enable_damage") or hb.settings.forceload_default_hudbars then

		local hp = player:get_hp()
		local hp_max = hb.settings.hp_player_maximun
		local hide_hp = not minetest.settings:get_bool("enable_damage") or true
		if player:get_properties().hp_max then player:set_properties({hp_max = hb.settings.hp_player_maximun}) end
		hb.init_hudbar(player, "health", math.min(hp, hp_max), hp_max, hide_hp)

		local breath = player:get_breath()
		local breath_max = hb.settings.br_player_maximun
		local hide_breath
		if player:get_properties().breath_max then player:set_properties({breath_max = hb.settings.br_player_maximun}) end
		if breath >= breath_max and hb.settings.autohide_breath == true then hide_breath = true else hide_breath = false end
		hb.init_hudbar(player, "breath", math.min(breath, breath_max), breath_max, hide_breath)

		if not modhbarm and modarmors then
			local arm = tonumber(hbarmor.armor[name])
			if not arm then arm = 0 end
			local hide_ar = hbarmor.autohide and must_hide(name, arm)
			hbarmor.get_armor(player)
			arm = tonumber(hbarmor.armor[name])
			hb.init_hudbar(player, "armor", arm_printable(arm), 100, hide_ar)
		end
		
		if not modhbhung then
			hb.init_hudbar(player, "satiation", hbhunger.get_hunger_raw(player), nil, (not hb.settings.forceload_default_hudbars) )
		end
	end
end

local function update_health(player)
	local hp_max = hb.settings.hp_player_maximun
	local hp = math.min(player:get_hp(), hp_max)
	hb.change_hudbar(player, "health", hp, hp_max)
end

-- update built-in HUD bars
local function update_hud(player)

	local name = player:get_player_name() -- player checks are already made before call this function
	if not name then return end

	-- loading only if need or force loading
	if minetest.settings:get_bool("enable_damage") then
		if hb.settings.forceload_default_hudbars then
			hb.unhide_hudbar(player, "health")
		end
		--air
		local breath_max = player:get_properties().breath_max or hb.settings.br_player_maximun
		local breath = player:get_breath()
		if breath >= breath_max and hb.settings.autohide_breath == true then
			hb.hide_hudbar(player, "breath")
		else
			hb.unhide_hudbar(player, "breath")
			hb.change_hudbar(player, "breath", math.min(breath, breath_max), breath_max)
		end
		--health
		update_health(player)
		-- armor
		if not modhbarm and modarmors then
			local larmor = hbarmor.armor[name]
			local arm = tonumber(larmor)
			if not arm then arm = 0; hbarmor.armor[name] = 0 end
			if hbarmor.autohide then
				if must_hide(name, arm) then
					hb.hide_hudbar(player, "armor")
				else
					hb.change_hudbar(player, "armor", arm_printable(arm))
					hb.unhide_hudbar(player, "armor")
				end
			else
				hb.change_hudbar(player, "armor", arm_printable(arm))
				hb.unhide_hudbar(player, "armor")
			end
		end
		-- hunger
		if not modhbhung then
			local h_out = tonumber(hbhunger.hunger_out[name])
			local h = tonumber(hbhunger.hunger[name])
			if h_out ~= h then
				hbhunger.hunger_out[name] = h
				hb.change_hudbar(player, "satiation", h)
			end
		end
	elseif hb.settings.forceload_default_hudbars then
		update_health(player)
		hb.hide_hudbar(player, "health")
		hb.hide_hudbar(player, "breath")
		hb.hide_hudbar(player, "armor")
		hb.hide_hudbar(player, "satiation")
	end
end

minetest.register_on_player_hpchange(function(player)
	if hb.players[player:get_player_name()] ~= nil then
		update_health(player)
	end
end)

minetest.register_on_respawnplayer(function(player)
	if not player_exists(player) then return end

	local name = player:get_player_name()
	update_health(player)
	if not modhbhung then
		hbhunger.hunger[name] = hbhunger.SAT_INIT
		hbhunger.set_hunger_raw(player)
		hbhunger.exhaustion[name] = 0
	end
	hb.hide_hudbar(player, "breath")
end)

minetest.register_on_joinplayer(function(player)
	if not player_exists(player) then return end

	local name = player:get_player_name()
	local inv = player:get_inventory()
	if not modhbhung then
		inv:set_size("hunger",1)
		hbhunger.hunger[name] = hbhunger.get_hunger_raw(player)
		hbhunger.hunger_out[name] = hbhunger.hunger[name]
		hbhunger.exhaustion[name] = 0
		hbhunger.poisonings[name] = 0
	end
	hide_builtin(player)
	custom_hud(player)
	hb.players[name] = player
	if not modhbarm then
		hbarmor.player_active[name] = true
	end
	if not modhbhung then
		hbhunger.set_hunger_raw(player)
	end
end)

minetest.register_on_leaveplayer(function(player)
	if not player_exists(player) then return end

	local name = player:get_player_name()
	hb.players[name] = nil
	if not modhbarm then
		hbarmor.player_active[name] = false
	end
end)

if modhbarm then
	minetest.log("warning","[hudbars] not using build-in hbarmor")
end

if modhbhung then
	minetest.log("warning","[hudbars] not using build-in hbarmor")
end

minetest.log("[MOD] hudbars loaded" )

local main_timer = 0
local timer = 0
local timer2 = 0
minetest.register_globalstep(function(dtime)
	main_timer = main_timer + dtime
	timer = timer + dtime
	timer2 = timer2 + dtime
	-- main timer are for healt and breath, separate satiation cos needs aditional timers
	if main_timer > hb.settings.tick or timer > 4 then
		if main_timer > hb.settings.tick then main_timer = 0 end
		-- only proceed if damage is enabled
		if minetest.settings:get_bool("enable_damage") or hb.settings.forceload_default_hudbars then
			-- update hud for healt
			for _, player in pairs(hb.players) do
				update_hud(player)
			end
			if not modhbarm and modarmors then
				-- update all hud elements
				for _,player in ipairs(minetest.get_connected_players()) do
					if player_exists(player) then
						local name = player:get_player_name()
						if hbarmor.player_active[name] == true then
							hbarmor.get_armor(player)
							update_hud(player)
						end
					end
				end
			end
		end
	end
	if not modhbhung then
		-- satiaton are internal properties, so update live (not hb) player properties
		if timer > 4 or timer2 > hbhunger.HUNGER_TICK then
			for _,player in ipairs(minetest.get_connected_players()) do
				if player_exists(player) then
					local name = player:get_player_name()
					local h = tonumber(hbhunger.hunger[name])
					local hp = player:get_hp()
					if timer > 4 then
						if h > hbhunger.SAT_HEAL and hp > 0 and player:get_breath() > 0 then
							player:set_hp(hp+1) -- heal player by 1 hp if not dead and satiation is > hbhunger.SAT_HEAL
						elseif h <= 1 then
							if hp-1 >= 0 then player:set_hp(hp-1) end -- or damage player by 1 hp if satiation is < 2
						end
					end
					if timer2 > hbhunger.HUNGER_TICK then
						if h > 0 then
							h = h-1 -- lower satiation by 1 point after xx seconds
							hbhunger.hunger[name] = h
							hbhunger.set_hunger_raw(player)
						end
					end
					-- still do not update all hud elements cos we have 2 loops
					local controls = player:get_player_control()
					if controls.up or controls.down or controls.left or controls.right then
						hbhunger.handle_node_actions(nil, nil, player) -- Determine if the player is walking
					end
				end
			end
		end
	end
	if timer > 4 then timer = 0 end
	if timer2 > hbhunger.HUNGER_TICK then timer2 = 0 end
end)


