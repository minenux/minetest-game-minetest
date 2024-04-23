
local is_54 = minetest.has_feature("direct_velocity_on_players") or false

-- wool sounds
function default.node_sound_wool_defaults(table)

	table = table or {}

	table.footstep = table.footstep or 	{name = "wool_coat_movement", gain = 1.0}
	table.dug = table.dug or {name = "wool_coat_movement", gain = 0.25}
	table.place = table.place or {name = "default_place_node", gain = 1.0}

	return table
end


stairs = {
	mod = "redo",
	wood = default.node_sound_wood_defaults(),
	dirt = default.node_sound_dirt_defaults(),
	stone = default.node_sound_stone_defaults(),
	glass = default.node_sound_glass_defaults(),
	leaves = default.node_sound_leaves_defaults(),
	metal = default.node_sound_metal_defaults(),
	wool = default.node_sound_wool_defaults()
}

-- add new 5.x snow sounds to 0.4.x client
if not stairs.node_sound_snow_defaults then
	function stairs.node_sound_snow_defaults(table)

		table = table or {}

		table.footstep = table.footstep or {name = "default_snow_footstep", gain = 0.1}
		table.dug = table.dug or {name = "default_snow_footstep", gain = 0.3}
		table.place = table.place or {name = "default_place_node", gain = 1.0}

		return table
	end
end


-- cache creative
local creative = minetest.settings:get_bool("creative_mode")

function is_creative_enabled_for(name)

	if creative or minetest.check_player_privs(name, {creative = true}) then
		return true
	end

	return false
end


-- process textures
local set_textures = function(images, worldaligntex)

	local stair_images = {}

	for i, image in ipairs(images) do

		if type(image) == "string" then

			stair_images[i] = {
				name = image,
				backface_culling = true
			}

			if worldaligntex then
				stair_images[i].align_style = "world"
			end
		else
			stair_images[i] = table.copy(image)

			if stair_images[i].backface_culling == nil then
				stair_images[i].backface_culling = true
			end

			if worldaligntex and stair_images[i].align_style == nil then
				stair_images[i].align_style = "world"
			end
		end
	end

	return stair_images
end


-- placement helper
local stair_place = function(itemstack, placer, pointed_thing, stair_node)

	-- if sneak pressed then use param2 in node pointed at when placing
	if placer:is_player() and placer:get_player_control().sneak then

		local name  = placer:get_player_name()
		local pos_a = pointed_thing.above
		local node_a = minetest.get_node(pos_a)
		local def_a = minetest.registered_nodes[node_a.name]

		if not def_a.buildable_to
		or minetest.is_protected(pos_a, name) then
			return itemstack
		end

		local pos_u = pointed_thing.under
		local node_u = minetest.get_node(pos_u)

		if minetest.get_item_group(node_u.name, "stair") > 0
		or minetest.get_item_group(node_u.name, "slab") > 0 then

			minetest.set_node(pos_a, {
				name = stair_node,
				param2 = node_u.param2
			})

			if not is_creative_enabled_for(name) then
				itemstack:take_item()
			end

			return itemstack
		end
	end

	core.rotate_and_place(itemstack, placer, pointed_thing,
			is_creative_enabled_for(placer:get_player_name()),
			{invert_wall = placer:get_player_control().sneak})

	return itemstack
end


-- get node settings to use for stairs
local function get_node_vars(nodename)

	local def = minetest.registered_nodes[nodename]

	if def then
		return def.light_source, def.use_texture_alpha, def.sunlight_propagates
	end

	if is_54 then return 0, "clip", nil end

	return false, true, false
end


-- if recipeitem can be burned then stair can be as well
local function set_burn(recipeitem, stair_name, v)

	local burntime = minetest.get_craft_result({
		method = "fuel", width = 1, items = {recipeitem} }).time

	if burntime > 0 then

		minetest.register_craft({
			type = "fuel",
			recipe = stair_name,
			burntime = math.floor(burntime * v)
		})
	end
end


-- Node will be called stairs:stair_<subname>
function stairs.register_stair(
		subname, recipeitem, groups, images, description, snds, wat)

	local stair_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.stair = 1

	local light, alpha, propa = get_node_vars(recipeitem)

	minetest.register_node(":stairs:stair_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		light_source = light,
		sunlight_propagates = propa,
		groups = new_groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5}
			}
		},

		on_place = function(itemstack, placer, pointed_thing)

			return stair_place(itemstack, placer, pointed_thing,
					"stairs:stair_" .. subname)
		end
	})

	-- if no recipe item provided then skip craft recipes
	if not recipeitem then
		return
	end

	-- stair recipes
	minetest.register_craft({
		output = "stairs:stair_" .. subname .. " 8",
		recipe = {
			{recipeitem, "", ""},
			{recipeitem, recipeitem, ""},
			{recipeitem, recipeitem, recipeitem}
		}
	})

	minetest.register_craft({
		output = "stairs:stair_" .. subname .. " 8",
		recipe = {
			{"", "", recipeitem},
			{"", recipeitem, recipeitem},
			{recipeitem, recipeitem, recipeitem}
		}
	})

	-- stair to original material recipe
	minetest.register_craft({
		output = recipeitem .. " 3",
		recipe = {
			{"stairs:stair_" .. subname, "stairs:stair_" .. subname},
			{"stairs:stair_" .. subname, "stairs:stair_" .. subname}
		}
	})

	set_burn(recipeitem, "stairs:stair_" .. subname, 0.75)
end


-- Node will be called stairs:slab_<subname>
function stairs.register_slab(
		subname, recipeitem, groups, images, description, snds, wat)

	local slab_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.slab = 1

	local light, alpha, propa = get_node_vars(recipeitem)

	minetest.register_node(":stairs:slab_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = slab_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		light_source = light,
		sunlight_propagates = propa,
		groups = new_groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5}
		},

		on_place = function(itemstack, placer, pointed_thing)

			return stair_place(itemstack, placer, pointed_thing,
					"stairs:slab_" .. subname)
		end
	})

	-- if no recipe item provided then skip craft recipes
	if not recipeitem then
		return
	end

	-- slab recipe
	minetest.register_craft({
		output = "stairs:slab_" .. subname .. " 6",
		recipe = {
			{recipeitem, recipeitem, recipeitem}
		}
	})

	-- slab to original material recipe
	minetest.register_craft({
		output = recipeitem,
		recipe = {
			{"stairs:slab_" .. subname},
			{"stairs:slab_" .. subname}
		}
	})

	set_burn(recipeitem, "stairs:slab_" .. subname, 0.5)
end


-- Node will be called stairs:stair_outer_<subname>
function stairs.register_stair_outer(
		subname, recipeitem, groups, images, description, snds, wat, fdesc)

	local stair_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.stair = 1

	local light, alpha, propa = get_node_vars(recipeitem)

	minetest.register_node(":stairs:stair_outer_" .. subname, {
		description = fdesc or "Outer " .. description,
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		light_source = light,
		sunlight_propagates = propa,
		groups = new_groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0, 0.5, 0.5}
			},
		},

		on_place = function(itemstack, placer, pointed_thing)

			return stair_place(itemstack, placer, pointed_thing,
					"stairs:stair_outer_" .. subname)
		end
	})

	-- add alias for old stairs redo name
	minetest.register_alias("stairs:corner_" .. subname,
			"stairs:stair_outer_" .. subname)

	-- if no recipe item provided then skip craft recipes
	if not recipeitem then
		return
	end

	-- corner stair recipe
	minetest.register_craft({
		output = "stairs:stair_outer_" .. subname .. " 6",
		recipe = {
			{"", "", ""},
			{"", recipeitem, ""},
			{recipeitem, recipeitem, recipeitem}
		},
	})

	-- corner stair to original material recipe
	minetest.register_craft({
		output = recipeitem .. " 2",
		recipe = {
			{"stairs:stair_outer_" .. subname,
					"stairs:stair_outer_" .. subname},
			{"stairs:stair_outer_" .. subname,
					"stairs:stair_outer_" .. subname}
		}
	})

	set_burn(recipeitem, "stairs:stair_outer_" .. subname, 0.625)
end


-- Node will be called stairs:stair_inner_<subname>
function stairs.register_stair_inner(
		subname, recipeitem, groups, images, description, snds, wat, fdesc)

	local stair_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.stair = 1

	local light, alpha, propa = get_node_vars(recipeitem)

	minetest.register_node(":stairs:stair_inner_" .. subname, {
		description = fdesc or "Inner " .. description,
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		light_source = light,
		sunlight_propagates = propa,
		groups = new_groups,
		sounds = snds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.5, 0, 0.5, 0}
			}
		},

		on_place = function(itemstack, placer, pointed_thing)

			return stair_place(itemstack, placer, pointed_thing,
					"stairs:stair_inner_" .. subname)
		end,
	})

	-- add alias for old stairs redo name
	minetest.register_alias("stairs:invcorner_" .. subname,
			"stairs:stair_inner_" .. subname)

	-- if no recipe item provided then skip craft recipes
	if not recipeitem then
		return
	end

	-- inside corner stair recipe
	minetest.register_craft({
		output = "stairs:stair_inner_" .. subname .. " 9",
		recipe = {
			{recipeitem, recipeitem, ""},
			{recipeitem, recipeitem, recipeitem},
			{recipeitem, recipeitem, recipeitem},
		}
	})

	-- inside corner stair to original material recipe
	minetest.register_craft({
		output = recipeitem .. " 3",
		recipe = {
			{"stairs:stair_inner_" .. subname,
					"stairs:stair_inner_" .. subname},
			{"stairs:stair_inner_" .. subname,
					"stairs:stair_inner_" .. subname}
		}
	})

	set_burn(recipeitem, "stairs:stair_inner_" .. subname, 0.875)
end


-- Node will be called stairs:slope_<subname>
function stairs.register_slope(
		subname, recipeitem, groups, images, description, snds, wat)

	local stair_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.stair = 1

	local light, alpha, propa = get_node_vars(recipeitem)

	minetest.register_node(":stairs:slope_" .. subname, {
		description = description,
		drawtype = "mesh",
		mesh = "stairs_slope.obj",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		light_source = light,
		sunlight_propagates = propa,
		groups = new_groups,
		sounds = snds,
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5}
			},
		},

		on_place = function(itemstack, placer, pointed_thing)
			return stair_place(itemstack, placer, pointed_thing,
					"stairs:slope_" .. subname)
		end
	})

	-- slope recipe
	minetest.register_craft({
		output = "stairs:slope_" .. subname .. " 6",
		recipe = {
			{recipeitem, "", ""},
			{recipeitem, recipeitem, ""}
		}
	})

	-- slope to original material recipe
	minetest.register_craft({
		output = recipeitem,
		recipe = {
			{"stairs:slope_" .. subname, "stairs:slope_" .. subname}
		}
	})

	set_burn(recipeitem, "stairs:slope_" .. subname, 0.5)
end


-- Node will be called stairs:slope_inner_<subname>
function stairs.register_slope_inner(
		subname, recipeitem, groups, images, description, snds, wat)

	local stair_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.stair = 1

	local light, alpha, propa = get_node_vars(recipeitem)

	minetest.register_node(":stairs:slope_inner_" .. subname, {
		description = description,
		drawtype = "mesh",
		mesh = "stairs_slope_inner.obj",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		light_source = light,
		sunlight_propagates = propa,
		groups = new_groups,
		sounds = snds,
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.5, 0, 0.5, 0}
			}
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.5, 0, 0.5, 0}
			}
		},

		on_place = function(itemstack, placer, pointed_thing)
			return stair_place(itemstack, placer, pointed_thing,
					"stairs:slope_inner_" .. subname)
		end
	})

	-- slope recipe
	minetest.register_craft({
		output = "stairs:slope_inner_" .. subname .. " 6",
		recipe = {
			{"", recipeitem, recipeitem},
			{recipeitem, recipeitem, recipeitem}
		}
	})

	-- slope to original material recipe
	minetest.register_craft({
		output = recipeitem,
		recipe = {
			{"stairs:slope_inner_" .. subname, "stairs:slope_inner_" .. subname}
		}
	})

	set_burn(recipeitem, "stairs:slope_inner_" .. subname, 0.5)
end


-- Node will be called stairs:slope_outer_<subname>
function stairs.register_slope_outer(
		subname, recipeitem, groups, images, description, snds, wat)

	local stair_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.stair = 1

	local light, alpha, propa = get_node_vars(recipeitem)

	minetest.register_node(":stairs:slope_outer_" .. subname, {
		description = description,
		drawtype = "mesh",
		mesh = "stairs_slope_outer.obj",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = alpha,
		light_source = light,
		sunlight_propagates = propa,
		groups = new_groups,
		sounds = snds,
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0, 0.5, 0.5}
			},
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0, 0.5, 0.5}
			},
		},

		on_place = function(itemstack, placer, pointed_thing)
			return stair_place(itemstack, placer, pointed_thing,
					"stairs:slope_outer_" .. subname)
		end
	})

	-- slope recipe
	minetest.register_craft({
		output = "stairs:slope_outer_" .. subname .. " 6",
		recipe = {
			{"", "", recipeitem},
			{"", recipeitem, recipeitem}
		}
	})

	-- slope to original material recipe
	minetest.register_craft({
		output = recipeitem,
		recipe = {
			{"stairs:slope_outer_" .. subname, "stairs:slope_outer_" .. subname}
		}
	})

	set_burn(recipeitem, "stairs:slope_outer_" .. subname, 0.5)
end


-- Nodes will be called stairs:{stair,slab}_<subname>
function stairs.register_stair_and_slab(
		subname, recipeitem, groups, images, desc_stair, desc_slab, sounds, wat)

	stairs.register_stair(
			subname, recipeitem, groups, images, desc_stair, sounds, wat)

	stairs.register_stair_inner(
			subname, recipeitem, groups, images, desc_stair, sounds, wat)

	stairs.register_stair_outer(
			subname, recipeitem, groups, images, desc_stair, sounds, wat)

	stairs.register_slab(
			subname, recipeitem, groups, images, desc_slab, sounds, wat)
end


-- Nodes will be called stairs:{stair,slab,corner,invcorner,slope}_<subname>
function stairs.register_all(
		subname, recipeitem, groups, images, desc, snds, wat)

	stairs.register_stair(
			subname, recipeitem, groups, images, desc .. " Stair", snds, wat)

	stairs.register_slab(
			subname, recipeitem, groups, images, desc .. " Slab", snds, wat)

	stairs.register_stair_inner(
			subname, recipeitem, groups, images, desc .. " Stair", snds, wat)

	stairs.register_stair_outer(
			subname, recipeitem, groups, images, desc .. " Stair", snds, wat)

	stairs.register_slope(
			subname, recipeitem, groups, images, desc .. " Slope", snds, wat)

	stairs.register_slope_inner(
			subname, recipeitem, groups, images, desc .. " Slope", snds, wat)

	stairs.register_slope_outer(
			subname, recipeitem, groups, images, desc .. " Slope", snds, wat)
end


-- compatibility function for previous stairs:invcorner_<subname>
function stairs.register_invcorner(
		subname, recipeitem, groups, images, desc, snds, wat)

	stairs.register_stair_inner(
			subname, recipeitem, groups, images, desc .. " Stair", snds, wat)
end


-- compatibility function for previous stairs:corner_<subname>
function stairs.register_corner(
		subname, recipeitem, groups, images, desc, snds, wat)

	stairs.register_stair_outer(
			subname, recipeitem, groups, images, desc .. " Stair", snds, wat)
end


-- Register stairs
dofile(minetest.get_modpath("stairs") .. "/stairs.lua")


print ("[MOD] Stairs Redo loaded")
