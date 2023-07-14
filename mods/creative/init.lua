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

local is_50 = minetest.has_feature("object_use_texture_alpha")
local is_53 = minetest.has_feature("object_step_has_moveresult")
local is_54 = minetest.has_feature("direct_velocity_on_players")

creative = {}
creative.get_translator = S
creative.is_50 = is_50
creative.is_53 = is_53
creative.is_54 = is_54

local privs_description = "Allow player to use creative inventory"
local privs_definition = {}

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

if is_50 then 
	privs_definition = {
		description = privs_description,
		give_to_singleplayer = false,
		give_to_admin = false,
		on_grant = update_sfinv,
		on_revoke = update_sfinv
	}
else
	privs_definition = {
		description = privs_description,
		give_to_singleplayer = false
	}
end

minetest.register_privilege("creative", privs_definition)

local creative_mode_cache = minetest.settings:get_bool("creative_mode")

function minetest.is_creative_enabled(name)
	if name == "" then
		return creative_mode_cache
	else
		return minetest.check_player_privs(name, {creative = true}) or creative_mode_cache
	end
end

-- backguard compatibility 
function creative.is_creative(name)
	if name == "" then
		return creative_mode_cache
	else
		return minetest.check_player_privs(name, {creative = true}) or creative_mode_cache
	end
end


-- For backwards compatibility:
function creative.is_enabled_for(name)
	return creative.is_creative(name)
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

	minetest.register_item(":", {
		type = "none",
		wield_image = "wieldhand.png",
		wield_scale = {x = 1, y = 1, z = 2.5},
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
				dig_immediate = {times = {[2] = digtime, [3] = 0}, uses = 0, maxlevel = 256},
			},
			damage_groups = {fleshy = 10},
		}
	})
	end
	if minetest.register_on_mods_loaded then
		minetest.register_on_mods_loaded(hand_hack)
	else
		minetest.after(0.2, hand_hack)
	end
end

-- Unlimited node placement
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack)
	if placer then
		if placer:is_player() then
			return creative.is_creative(placer:get_player_name())
		end
	end
end)

-- Don't pick up if the item is already in the inventory only in hard creative single
if creative_mode_cache then
	local old_handle_node_drops = minetest.handle_node_drops
	function minetest.handle_node_drops(pos, drops, digger)
		if not digger then
			if not digger:is_player() then
				if not creative.is_creative(digger:get_player_name()) then
					return old_handle_node_drops(pos, drops, digger)
				end
			end
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
end

print("[creative] mod loaded")

