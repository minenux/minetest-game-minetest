local S = beds.get_translator

-- Fancy shaped bed

beds.register_bed("beds:fancy_bed", {
	description = S("Red Fancy Bed"),
	inventory_image = "beds_bed_fancy.png",
	wield_image = "beds_bed_fancy.png",
	tiles = {"beds_fancy_bed.png", "default_wood.png"},
	mesh = "beds_fancy_bed.obj",
	selectionbox = {-0.5, -0.5, -0.5, 0.5, -0.06, 1.5},
	collisionbox = {-0.5, -0.5, -0.5, 0.5, -0.06, 1.5},
	recipe = {
		{"", "", "group:stick"},
		{"wool:red", "wool:red", "wool:white"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

beds.register_bed("beds:fancy_bed_pink", {
	description = S("Pink Fancy Bed"),
	inventory_image = "beds_bed_fancy_pink.png",
	wield_image = "beds_bed_fancy_pink.png",
	tiles = {"beds_fancy_bed_pink.png", "default_wood.png"},
	mesh = "beds_fancy_bed.obj",
	selectionbox = {-0.5, -0.5, -0.5, 0.5, -0.06, 1.5},
	collisionbox = {-0.5, -0.5, -0.5, 0.5, -0.06, 1.5},
	recipe = {
		{"", "", "group:stick"},
		{"wool:pink", "wool:pink", "wool:white"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

-- Simple shaped bed

beds.register_bed("beds:bed_white", {
	description = S("White Simple Bed"),
	inventory_image = "beds_bed_white.png",
	wield_image = "beds_bed_white.png",
	tiles = {"beds_simple_bed_white.png"},
	mesh = "beds_simple_bed.obj",
	selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
	recipe = {
		{"wool:white", "wool:white", "wool:white"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

beds.register_bed("beds:bed", {
	description = S("Red Simple Bed"),
	inventory_image = "beds_bed.png",
	wield_image = "beds_bed.png",
	tiles = {"beds_simple_bed.png"},
	mesh = "beds_simple_bed.obj",
	selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
	recipe = {
		{"wool:red", "wool:red", "wool:white"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

beds.register_bed("beds:bed_blue", {
	description = S("Blue Simple Bed"),
	inventory_image = "beds_bed_blue.png",
	wield_image = "beds_bed_blue.png",
	tiles = {"beds_simple_bed_blue.png"},
	mesh = "beds_simple_bed.obj",
	selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
	recipe = {
		{"wool:blue", "wool:blue", "wool:white"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

-- Aliases for PilzAdam's beds mod

minetest.register_alias("beds:bed_bottom_red", "beds:bed_bottom")
minetest.register_alias("beds:bed_top_red", "beds:bed_top")

-- Fuel

minetest.register_craft({
	type = "fuel",
	recipe = "beds:fancy_bed",
	burntime = 13
})

minetest.register_craft({
	type = "fuel",
	recipe = "beds:fancy_bed_pink",
	burntime = 13
})

minetest.register_craft({
	type = "fuel",
	recipe = "beds:bed",
	burntime = 12
})

minetest.register_craft({
	type = "fuel",
	recipe = "beds:bed_blue",
	burntime = 12
})

minetest.register_craft({
	type = "fuel",
	recipe = "beds:bed_white",
	burntime = 12
})
