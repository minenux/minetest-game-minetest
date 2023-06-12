-- sfinv/init.lua

dofile(minetest.get_modpath("sfinv") .. "/api.lua")

-- Load support for MT game translation.
local S = minetest.get_translator("sfinv")

sfinv.register_page("sfinv:crafting", {
	title = S("Crafting"),
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
				list[current_player;craft;1.75,0.5;3,3;]
				list[current_player;craftpreview;5.75,1.5;1,1;]
				image[4.75,1.5;1,1;sfinv_crafting_arrow.png]
				listring[current_player;main]
				listring[current_player;craft]
			]], true)
	end
})

local home = minetest.get_modpath("sethome") or false
local sfinvhome = minetest.get_modpath("sfinv_home") or false

if home and not sfinvhome then
	local get_formspec = function(name)

		local formspec = "size[6,2]"
			.. "button_exit[2,2.5;4,1;home_gui_go;" .. "-> Home" .. "]"
			.. "button_exit[2,4.5;4,1;home_gui_set;" .. "!! Home <-" .. "]"
		--	.. "button_exit[2,6.5;4,1;home_gui_spawn;" .. S("Spawn") .. "]"

		local home = sethome.get(name)

		if home then
			formspec = formspec
				.. "label[2,1.5;" .. "Home:" .. "  "
				.. minetest.pos_to_string(vector.round(home)) .. "]"
		else
			formspec = formspec
				.. "label[2,1.5;" .. "Invalid: no home!" .. "]"
		end

		return formspec
	end

	sfinv.register_page("sfinv:home", {
		title = "Home",
		get = function(self, player, context)
				local name = player:get_player_name()
				return sfinv.make_formspec(player, context, get_formspec(name))
			end,
		is_in_nav = function(self, player, context)
				local name = player:get_player_name()
				return minetest.get_player_privs(name).home
			end,
		on_enter = function(self, player, context) end,
		on_leave = function(self, player, context) end,
		on_player_receive_fields = function(self, player, context, fields)
				local name = player:get_player_name()
				if not minetest.get_player_privs(name).home then
					return
				end
				if fields.home_gui_set then
					sethome.set(name, player:get_pos())
					sfinv.set_player_inventory_formspec(player)
				elseif fields.home_gui_go then
					sethome.go(name)
		--		elseif fields.home_gui_spawn then
		--			player:set_pos(statspawn)
				end
			end
	})

end

