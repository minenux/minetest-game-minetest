-- creative/init.lua

-- Load support for MT game translation.
local S

if minetest.get_translator ~= nil then
	S = minetest.get_translator("creative") -- 5.x translation function
else
	if minetest.get_modpath("intllib") then
		dofile(minetest.get_modpath("intllib") .. "/init.lua")
		if intllib.make_gettext_pair then
			S = intllib.make_gettext_pair() -- new gettext method
		else
			S = intllib.Getter() -- old text file method
		end
	else -- boilerplate function
		S = function(str, ...)
			local args = {...}
			return str:gsub("@%d+", function(match)
				return args[tonumber(match:sub(2))]
			end)
		end
	end
end

local is_53 = minetest.has_feature("object_step_has_moveresult")
local is_54 = minetest.has_feature("direct_velocity_on_players")

creative = {}
creative.get_translator = S
creative.is_53 = is_53
creative.is_54 = is_54

local function update_sfinv(name)
	minetest.after(0, function()
		local player = minetest.get_player_by_name(name)
		if player then
			if sfinv.get_page(player):sub(1, 9) == "creative:" then
				sfinv.set_page(player, sfinv.get_homepage_name(player))
			else
				sfinv.set_player_inventory_formspec(player)
			end
		end
	end)
end

minetest.register_privilege("creative", {
	description = S("Allow player to use creative inventory"),
	give_to_singleplayer = false,
	give_to_admin = false,
	on_grant = update_sfinv,
	on_revoke = update_sfinv,
})

local creative_mode_cache = minetest.settings:get_bool("creative_mode")

-- backguard compatibility 
function creative.is_creative(name)
	if is_53 then
		return minetest.is_creative_enabled(name)
	else
		return minetest.check_player_privs(name, {creative = true}) or creative_mode_cache
	end
end

-- Override the engine's creative mode function
local old_is_creative_enabled = creative.is_creative
function minetest.is_creative_enabled(name)
	if name == "" then
		return old_is_creative_enabled(name)
	end
	return minetest.check_player_privs(name, {creative = true}) or old_is_creative_enabled(name)
end

-- For backwards compatibility:
function creative.is_enabled_for(name)
	return minetest.is_creative_enabled(name)
end

dofile(minetest.get_modpath("creative") .. "/inventory.lua")

if minetest.is_creative_enabled("") then
	local hand_hack = function()
		-- Dig time is modified according to difference (leveldiff) between tool
		-- 'maxlevel' and node 'level'. Digtime is divided by the larger of
		-- leveldiff and 1.
		-- To speed up digging in creative, hand 'maxlevel' and 'digtime' have been
		-- increased such that nodes of differing levels have an insignificant
		-- effect on digtime.
		local digtime = 42
		local caps = {times = {digtime, digtime, digtime}, uses = 0, maxlevel = 256}

		-- Override the hand tool
		minetest.override_item("", {
			range = 10,
			tool_capabilities = {
				full_punch_interval = 0.5,
				max_drop_level = 3,
				groupcaps = {
					crumbly = caps,
					cracky  = caps,
					snappy  = caps,
					choppy  = caps,
					oddly_breakable_by_hand = caps,
					-- dig_immediate group doesn't use value 1. Value 3 is instant dig
					dig_immediate =
						{times = {[2] = digtime, [3] = 0}, uses = 0, maxlevel = 256},
				},
				damage_groups = {fleshy = 10},
			}
		})
	end
	if minetest.register_on_mods_loaded then
		minetest.register_on_mods_loaded(hand_hack)
	else
		minetest.after(0, hand_hack)
	end
end

-- Unlimited node placement
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack)
	if placer and placer:is_player() then
		return minetest.is_creative_enabled(placer:get_player_name())
	end
end)

--[[ Don't pick up if the item is already in the inventory
local old_handle_node_drops = minetest.handle_node_drops
function minetest.handle_node_drops(pos, drops, digger)
	if not digger or not digger:is_player() or
		not minetest.is_creative_enabled(digger:get_player_name()) then
		return old_handle_node_drops(pos, drops, digger)
	end
	local inv = digger:get_inventory()
	if inv then
		for _, item in ipairs(drops) do
			if not inv:contains_item("main", item, true) then
				inv:add_item("main", item)
			end
		end
	end
end
]]
