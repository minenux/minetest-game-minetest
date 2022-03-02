
function beds.register_bed(name, def)

	local new_tiles
	local new_mesh = "beds_simple_bed.obj"

	-- old api texture check
	if def.tiles and def.tiles.bottom then

		new_tiles = "beds_simple_bed.png" -- default

		-- check for fancy bed
		if def.nodebox and def.nodebox.bottom and #def.nodebox.bottom > 3 then
			new_tiles = "beds_fancy_bed.png"
			new_mesh = "beds_fancy_bed.obj"
		end
	end

	-- register bed node
	minetest.register_node(name, {
		description = def.description,
		inventory_image = def.inventory_image,
		wield_image = def.wield_image,
		drawtype = "mesh",
		mesh = def.mesh or new_mesh,
		tiles = new_tiles or def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		stack_max = 1,
		groups = {
			choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 1,
			fall_damage_add_percent = -40, bouncy = 85
		},
		sounds = default.node_sound_wood_defaults(),
		selection_box = {
			type = "fixed",
			fixed = def.selectionbox
		},
		collision_box = {
			type = "fixed",
			fixed = def.collisionbox
		},

		on_place = function(itemstack, placer, pointed_thing)

			local under = pointed_thing.under
			local node = minetest.get_node(under)
			local udef = minetest.registered_nodes[node.name]

			if udef and udef.on_rightclick
			and not (placer and placer:is_player()
			and placer:get_player_control().sneak) then

				return udef.on_rightclick(under, node, placer, itemstack,
					pointed_thing) or itemstack
			end

			local pos

			if udef and udef.buildable_to then
				pos = under
			else
				pos = pointed_thing.above
			end

			local player_name = placer and placer:get_player_name() or ""

			if minetest.is_protected(pos, player_name)
			and not minetest.check_player_privs(player_name, "protection_bypass") then

				minetest.record_protection_violation(pos, player_name)

				return itemstack
			end

			local node_def = minetest.registered_nodes[minetest.get_node(pos).name]

			if not node_def or not node_def.buildable_to then
				return itemstack
			end

			local dir = placer and placer:get_look_dir() and
				minetest.dir_to_facedir(placer:get_look_dir()) or 0
			local botpos = vector.add(pos, minetest.facedir_to_dir(dir))

			if minetest.is_protected(botpos, player_name)
			and not minetest.check_player_privs(player_name, "protection_bypass") then

				minetest.record_protection_violation(botpos, player_name)

				return itemstack
			end

			local botdef = minetest.registered_nodes[minetest.get_node(botpos).name]

			if not botdef or not botdef.buildable_to then
				return itemstack
			end

			minetest.set_node(pos, {name = name, param2 = dir})

			if not beds.is_creative(player_name) then
				itemstack:take_item()
			end

			return itemstack
		end,

		on_rightclick = function(pos, node, clicker)
			beds.on_rightclick(pos, clicker)
		end,

		on_destruct = function(pos)
			beds.remove_spawns_at(pos)
		end,

		can_dig = function(pos, player)
			return beds.can_dig(pos)
		end
	})

	minetest.register_alias(name .. "_bottom", name)
	minetest.register_alias(name .. "_top", "air")

	-- register recipe
	minetest.register_craft({
		output = name,
		recipe = def.recipe
	})
end
