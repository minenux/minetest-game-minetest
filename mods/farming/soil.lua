
local S = farming.intllib


-- default dry soil node
local dry_soil = "farming:soil"


-- add soil types to existing dirt blocks
minetest.override_item("default:dirt", {
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_grass", {
	soil = {
		base = "default:dirt_with_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_dry_grass", {
	soil = {
		base = "default:dirt_with_dry_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_rainforest_litter", {
	soil = {
		base = "default:dirt_with_rainforest_litter",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

if not minetest.registered_nodes[":default:dirt_with_coniferous_litter"] then
	minetest.register_alias("default:dirt_with_coniferous_litter", "default:dirt_with_dry_grass")
end
minetest.override_item("default:dirt_with_coniferous_litter", {
	soil = {
		base = "default:dirt_with_dry_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

if not minetest.registered_nodes[":default:dry_dirt"] then
	minetest.register_alias("default:dry_dirt", "default:dirt")
end
minetest.override_item("default:dry_dirt", {
	soil = {
		base = "default:dirt",
		dry = "farming:dry_soil",
		wet = "farming:dry_soil_wet"
	}
})

if not minetest.registered_nodes[":default:dry_dirt_with_dry_grass"] then
	minetest.register_alias("default:dry_dirt_with_dry_grass", "default:dirt_with_dry_grass")
end
minetest.override_item("default:dry_dirt_with_dry_grass", {
	soil = {
		base = "default:dirt_with_dry_grass",
		dry = "farming:dry_soil",
		wet = "farming:dry_soil_wet"
	}
})

-- normal soil
minetest.register_node("farming:soil", {
	description = S("Soil"),
	tiles = {"default_dirt.png^farming_soil.png", "default_dirt.png"},
	drop = "default:dirt",
	groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 2, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

-- wet soil
minetest.register_node("farming:soil_wet", {
	description = S("Wet Soil"),
	tiles = {
		"default_dirt.png^farming_soil_wet.png",
		"default_dirt.png^farming_soil_wet_side.png"
	},
	drop = "default:dirt",
	groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 3, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})


-- sand is not soil, change existing sand-soil to use dry soil
minetest.register_alias("farming:desert_sand_soil", dry_soil)
minetest.register_alias("farming:desert_sand_soil_wet", dry_soil .. "_wet")


-- if water near soil then change to wet soil
minetest.register_abm({
	label = "Soil changes",
	nodenames = {"group:field"},
	interval = 15,
	chance = 4,
	catch_up = false,

	action = function(pos, node)

		local ndef = minetest.registered_nodes[node.name]
		if not ndef or not ndef.soil or not ndef.soil.wet
		or not ndef.soil.base or not ndef.soil.dry then return end

		pos.y = pos.y + 1
		local nn = minetest.get_node_or_nil(pos)
		pos.y = pos.y - 1

		if nn then nn = nn.name else return end

		-- what's on top of soil, if solid/not plant change soil to dirt
		if minetest.registered_nodes[nn]
		and minetest.registered_nodes[nn].walkable
		and minetest.get_item_group(nn, "plant") == 0
		and minetest.get_item_group(nn, "growing") == 0 then

			minetest.set_node(pos, {name = ndef.soil.base})

			return
		end

		-- check if water is within 3 nodes
		if minetest.find_node_near(pos, 3, {"group:water"}) then

			-- only change if it's not already wet soil
			if node.name ~= ndef.soil.wet then
				minetest.set_node(pos, {name = ndef.soil.wet})
			end

		-- only dry out soil if no unloaded blocks nearby, just incase
		elseif not minetest.find_node_near(pos, 3, {"ignore"}) then

			if node.name == ndef.soil.wet then
				minetest.set_node(pos, {name = ndef.soil.dry})

			-- if crop or seed found don't turn to dry soil
			elseif node.name == ndef.soil.dry
			and minetest.get_item_group(nn, "plant") == 0
			and minetest.get_item_group(nn, "growing") == 0 then
				minetest.set_node(pos, {name = ndef.soil.base})
			end
		end
	end
})
