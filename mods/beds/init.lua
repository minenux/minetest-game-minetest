local is_50 = nil
local is_53 = minetest.has_feature("object_step_has_moveresult")
local is_54 = minetest.has_feature("direct_velocity_on_players")

 -- Load support for MT game translation.
local S
if minetest.get_translator ~= nil then
	S = minetest.get_translator("beds") -- 5.x translation function
	is_50 = true
else
	if minetest.get_modpath("intllib") then
		dofile(minetest.get_modpath("intllib") .. "/init.lua")
		if intllib.make_gettext_pair then
			gettext, ngettext = intllib.make_gettext_pair() -- new gettext method
		else
			gettext = intllib.Getter() -- old text file method
		end
		S = gettext
	else -- boilerplate function for 0.4
		S = function(str, ...)
			local args = {...}
			return str:gsub("@%d+", function(match)
				return args[tonumber(match:sub(2))]
			end)
		end
	end
end

beds = {
	player = {},
	bed_position = {},
	pos = {},
	spawn = {},
	get_translator = S,
	formspec = "size[8,11;true]"
	.. "no_prepend[]"
	.. "bgcolor[#080808BB;true]"
	.. "button_exit[2,10;4,0.75;leave;" .. minetest.formspec_escape(S("Leave Bed")) .. "]"
}
beds.is_50 = is_50
beds.is_53 = is_53
beds.is_54 = is_54

beds.day_interval = {
	start = 0.2,
	finish = 0.805,
}

local modpath = minetest.get_modpath("beds")

-- check for minetest 5.x/0.4 compatibility
function beds.is_creative(name)
	if is_53 then
		return minetest.is_creative_enabled(name)
	else
		return creative.is_enabled_for(name) or minetest.settings:get_bool("creative_mode")
	end
end
-- Load files

dofile(modpath .. "/functions.lua")
dofile(modpath .. "/api.lua")
dofile(modpath .. "/beds.lua")
dofile(modpath .. "/spawns.lua")


print("[MOD] Beds loaded")
