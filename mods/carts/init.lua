-- carts/init.lua

-- translation support
local S
if minetest.get_translator ~= nil then
	S = minetest.get_translator("carts") -- 5.x translation function
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

carts = {}
carts.modpath = minetest.get_modpath("carts")
carts.railparams = {}
carts.get_translator = S

-- Maximal speed of the cart in m/s (min = -1)
carts.speed_max = 7
-- Set to -1 to disable punching the cart from inside (min = -1)
carts.punch_speed_max = 5
-- Maximal distance for the path correction (for dtime peaks)
carts.path_distance_max = 3


dofile(carts.modpath.."/functions.lua")
dofile(carts.modpath.."/rails.lua")
dofile(carts.modpath.."/cart_entity.lua")

-- Register rails as dungeon loot
if minetest.global_exists("dungeon_loot") then
	dungeon_loot.register({
		name = "carts:rail", chance = 0.35, count = {1, 6}
	})
end
