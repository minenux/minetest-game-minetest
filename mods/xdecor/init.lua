--local t = os.clock()

xdecor = {}
local modpath = minetest.get_modpath("xdecor")
local ar_api = minetest.get_modpath("3d_armor")

-- Intllib
local S
if minetest.get_translator ~= nil then
	S = minetest.get_translator("xdecor") -- 5.x translation function
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

xdecor.S = S
xdecor.reparaible_tools = {"pick", "axe", "shovel", "hoe"}

dofile(modpath .. "/handlers/animations.lua")
dofile(modpath .. "/handlers/helpers.lua")
dofile(modpath .. "/handlers/nodeboxes.lua")
dofile(modpath .. "/handlers/registration.lua")

if ar_api then  xdecor.repairable_tools = {"pick", "axe", "shovel", "sword", "hoe", "armor", "shield"}
else  xdecor.repairable_tools = {"pick", "axe", "shovel", "hoe"} end

dofile(modpath .. "/src/nodes.lua")
dofile(modpath .. "/src/recipes.lua")

local subpart = {
	"chess",
	"cooking",
	"enchanting",
	"hive",
	"itemframe",
	"mailbox",
	"mechanisms",
	"rope",
	"workbench",
}

for _, name in ipairs(subpart) do
	local enable = minetest.settings:get_bool("enable_xdecor_" .. name)
	if enable or enable == nil then
		dofile(modpath .. "/src/" .. name .. ".lua")
	end
end

--print(string.format("[xdecor] loaded in %.2f ms", (os.clock()-t)*1000))
