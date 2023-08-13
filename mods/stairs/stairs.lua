
local grp = {} -- Helper

--= Default Minetest

-- Wood types

stairs.register_all("wood", "default:wood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"default_wood.png"},
	"Wooden",
	stairs.wood, false)

stairs.register_all("junglewood", "default:junglewood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"default_junglewood.png"},
	"Jungle Wood",
	stairs.wood, false)

stairs.register_all("pine_wood", "default:pinewood",
	{choppy = 3, oddly_breakable_by_hand = 1, flammable = 3},
	{"default_pine_wood.png"},
	"Pine Wood",
	stairs.wood, false)

-- Register aliases for new pine node names
minetest.register_alias("stairs:stair_pinewood", "stairs:stair_pine_wood")
minetest.register_alias("stairs:slab_pinewood", "stairs:slab_pine_wood")

stairs.register_all("acacia_wood", "default:acacia_wood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
	{"default_acacia_wood.png"},
	"Acacia Wood",
	stairs.wood, false)

stairs.register_all("aspen_wood", "default:aspen_wood",
	{choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
	{"default_aspen_wood.png"},
	"Aspen Wood",
	stairs.wood, false)

-- Stone types

stairs.register_all("stone", "default:stone",
	{cracky = 3},
	{"default_stone.png"},
	"Stone",
	stairs.stone, true)

stairs.register_all("stonebrick", "default:stonebrick",
	{cracky = 2},
	{"default_stone_brick.png"},
	"Stone Brick",
	stairs.stone, false)

stairs.register_all("stone_block", "default:stone_block",
	{cracky = 2},
	{"default_stone_block.png"},
	"Stone Block",
	stairs.stone, true)

stairs.register_all("cobble", "default:cobble",
	{cracky = 3},
	{"default_cobble.png"},
	"Cobble",
	stairs.stone, true)

stairs.register_all("mossycobble", "default:mossycobble",
	{cracky = 3},
	{"default_mossycobble.png"},
	"Mossy Cobble",
	stairs.stone, true)

stairs.register_all("desert_stone", "default:desert_stone",
	{cracky = 3},
	{"default_desert_stone.png"},
	"Desert Stone",
	stairs.stone, true)

stairs.register_all("desert_stonebrick", "default:desert_stonebrick",
	{cracky = 2},
	{"default_desert_stone_brick.png"},
	"Desert Stone Brick",
	stairs.stone, false)

stairs.register_all("desert_stone_block", "default:desert_stone_block",
	{cracky = 2},
	{"default_desert_stone_block.png"},
	"Desert Stone Block",
	stairs.stone, true)

stairs.register_all("desert_cobble", "default:desert_cobble",
	{cracky = 3},
	{"default_desert_cobble.png"},
	"Desert Cobble",
	stairs.stone, true)

-- Sandstone types

stairs.register_all("sandstone", "default:sandstone",
	{crumbly = 1, cracky = 3},
	{"default_sandstone.png"},
	"Sandstone",
	stairs.stone, true)

stairs.register_all("sandstonebrick", "default:sandstonebrick",
	{cracky = 2},
	{"default_sandstone_brick.png"},
	"Sandstone Brick",
	stairs.stone, false)

stairs.register_all("sandstone_block", "default:sandstone_block",
	{cracky = 2},
	{"default_sandstone_block.png"},
	"Sandstone Block",
	stairs.stone, true)

stairs.register_all("desert_sandstone", "default:desert_sandstone",
	{crumbly = 1, cracky = 3},
	{"default_desert_sandstone.png"},
	"Desert Sandstone",
	stairs.stone, true)

stairs.register_all("desert_sandstone_brick", "default:desert_sandstone_brick",
	{cracky = 2},
	{"default_desert_sandstone_brick.png"},
	"Desert Sandstone Brick",
	stairs.stone, false)

stairs.register_all("desert_sandstone_block", "default:desert_sandstone_block",
	{cracky = 2},
	{"default_desert_sandstone_block.png"},
	"Desert Sandstone Block",
	stairs.stone, true)

stairs.register_all("silver_sandstone", "default:silver_sandstone",
	{crumbly = 1, cracky = 3},
	{"default_silver_sandstone.png"},
	"Silver Sandstone",
	stairs.stone, true)

stairs.register_all("silver_sandstone_brick", "default:silver_sandstone_brick",
	{cracky = 2},
	{"default_silver_sandstone_brick.png"},
	"Silver Sandstone Brick",
	stairs.stone, false)

stairs.register_all("silver_sandstone_block", "default:silver_sandstone_block",
	{cracky = 2},
	{"default_silver_sandstone_block.png"},
	"Silver Sandstone Block",
	stairs.stone, true)

-- Obsidian

stairs.register_all("obsidian", "default:obsidian",
	{cracky = 1, level = 2},
	{"default_obsidian.png"},
	"Obsidian",
	stairs.stone, true)

stairs.register_all("obsidianbrick", "default:obsidianbrick",
	{cracky = 1, level = 2},
	{"default_obsidian_brick.png"},
	"Obsidian Brick",
	stairs.stone, false)

stairs.register_all("obsidian_block", "default:obsidian_block",
	{cracky = 1, level = 2},
	{"default_obsidian_block.png"},
	"Obsidian block",
	stairs.stone, true)

-- Cloud (with overrides)

stairs.register_stair("cloud", "default:cloud",
	{unbreakable = 1, not_in_creative_inventory = 1},
	{"default_cloud.png"},
	"Cloud Stair",
	stairs.wool)

minetest.override_item("stairs:stair_cloud", {
	on_blast = function() end,
	on_drop = function(itemstack, dropper, pos) end,
	drop = {},
})

stairs.register_slab("cloud", "default:cloud",
	{unbreakable = 1, not_in_creative_inventory = 1},
	{"default_cloud.png"},
	"Cloud Slab",
	stairs.wool)

minetest.override_item("stairs:slab_cloud", {
	on_blast = function() end,
	on_drop = function(itemstack, dropper, pos) end,
	drop = {},
})

-- Ores

stairs.register_all("coal", "default:coalblock",
	{cracky = 3},
	{"default_coal_block.png"},
	"Coal",
	stairs.stone, true)

stairs.register_all("steelblock", "default:steelblock",
	{cracky = 1, level = 2},
	{"default_steel_block.png"},
	"Steel",
	stairs.metal, true)

stairs.register_all("copperblock", "default:copperblock",
	{cracky = 1, level = 2},
	{"default_copper_block.png"},
	"Copper",
	stairs.metal, true)

stairs.register_all("bronzeblock", "default:bronzeblock",
	{cracky = 1, level = 2},
	{"default_bronze_block.png"},
	"Bronze",
	stairs.metal, true)

stairs.register_all("tinblock", "default:tinblock",
	{cracky = 1, level = 2},
	{"default_tin_block.png"},
	"Tin",
	stairs.metal, true)

stairs.register_all("mese", "default:mese",
	{cracky = 1, level = 2},
	{"default_mese_block.png"},
	"Mese",
	stairs.stone)

stairs.register_all("goldblock", "default:goldblock",
	{cracky = 1},
	{"default_gold_block.png"},
	"Gold",
	stairs.metal)

stairs.register_all("diamondblock", "default:diamondblock",
	{cracky = 1, level = 3},
	{"default_diamond_block.png"},
	"Diamond",
	stairs.stone)

-- Glass types

stairs.register_all("glass", "default:glass",
	{cracky = 3, oddly_breakable_by_hand = 3},
	{"default_glass.png"},
	"Glass",
	stairs.glass)

stairs.register_all("obsidian_glass", "default:obsidian_glass",
	{cracky = 2},
	{"default_obsidian_glass.png"},
	"Obsidian Glass",
	stairs.glass)

-- Brick, Snow and Ice

stairs.register_all("brick", "default:brick",
	{cracky = 3},
	{"default_brick.png"},
	"Brick",
	stairs.stone, false)

stairs.register_all("snowblock", "default:snowblock",
	{crumbly = 3, cools_lava = 1, snowy = 1},
	{"default_snow.png"},
	"Snow Block",
	stairs.node_sound_snow_defaults(), true)

stairs.register_all("ice", "default:ice",
	{cracky = 3, cools_lava = 1},
	{"default_ice.png"},
	"Ice",
	default.node_sound_glass_defaults(), true)

--= More Ores Mod

if minetest.get_modpath("moreores") then

grp = {cracky = 1, level = 2}

stairs.register_all("silver_block", "moreores:silver_block",
	grp,
	{"moreores_silver_block.png"},
	"Silver",
	stairs.metal, true)

stairs.register_all("mithril_block", "moreores:mithril_block",
	grp,
	{"moreores_mithril_block.png"},
	"Mithril",
	stairs.metal, true)

end

--= Mobs Mod

if minetest.registered_nodes["mobs:cheeseblock"] then

grp = {crumbly = 3, flammable = 2}

stairs.register_all("cheeseblock", "mobs:cheeseblock",
	grp,
	{"mobs_cheeseblock.png"},
	"Cheese Block",
	stairs.dirt)

stairs.register_all("honey_block", "mobs:honey_block",
	grp,
	{"mobs_honey_block.png"},
	"Honey Block",
	stairs.dirt)

end

--= Lapis Mod

if minetest.get_modpath("lapis") then

grp = {cracky = 3}

stairs.register_all("lapis_block", "lapis:lapis_block",
	grp,
	{"lapis_block_side.png"},
	"Lapis",
	stairs.stone)

stairs.register_all("lapis_brick", "lapis:lapis_brick",
	grp,
	{"lapis_brick.png"},
	"Lapis Brick",
	stairs.stone)

stairs.register_all("lapis_cobble", "lapis:lapis_cobble",
	grp,
	{"lapis_cobble.png"},
	"Lapis Cobble",
	stairs.stone)

end

--= Homedecor Mod

if minetest.get_modpath("homedecor") then

local grp = {snappy = 3}

stairs.register_all("shingles_asphalt", "homedecor:shingles_asphalt",
	grp,
	{"homedecor_shingles_asphalt.png"},
	"Asphalt Shingle",
	stairs.leaves)

stairs.register_all("shingles_terracotta", "homedecor:roof_tile_terracotta",
	grp,
	{"homedecor_shingles_terracotta.png"},
	"Terracotta Shingle",
	stairs.leaves)

stairs.register_all("shingles_wood", "homedecor:shingles_wood",
	grp,
	{"homedecor_shingles_wood.png"},
	"Wooden Shingle",
	stairs.leaves)

end

--= Xanadu Mod

if minetest.get_modpath("xanadu") then

grp = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3}

stairs.register_all("stained_wood_white", "xanadu:stained_wood_white",
	grp,
	{"stained_wood_white.png"},
	"White Wooden",
	stairs.wood, false)

stairs.register_all("stained_wood_red", "xanadu:stained_wood_red",
	grp,
	{"stained_wood_red.png"},
	"Red Wooden",
	stairs.wood, false)

-- Decorative blocks

grp = {cracky = 3}

stairs.register_all("stone1", "xanadu:stone1",
	grp,
	{"stone1.png"},
	"Decorative Stone 1",
	stairs.stone)

stairs.register_all("stone2", "xanadu:stone2",
	grp,
	{"stone2.png"},
	"Decorative Stone 2",
	stairs.stone)

stairs.register_all("stone3", "xanadu:stone3",
	grp,
	{"stone3.png"},
	"Decorative Stone 3",
	stairs.stone)

stairs.register_all("stone4", "xanadu:stone4",
	grp,
	{"stone4.png"},
	"Decorative Stone 4",
	stairs.stone)

stairs.register_all("stone5", "xanadu:stone5",
	grp,
	{"stone5.png"},
	"Decorative Stone 5",
	stairs.stone)

stairs.register_all("stone6", "xanadu:stone6",
	grp,
	{"stone6.png"},
	"Decorative Stone 6",
	stairs.stone)

stairs.register_all("sandstonebrick1", "xanadu:sandstonebrick1",
	grp,
	{"sandstonebrick1.png"},
	"Decorative Sandstone 1",
	stairs.stone)

stairs.register_all("sandstonebrick2", "xanadu:sandstonebrick2",
	grp,
	{"sandstonebrick2.png"},
	"Decorative Sandstone 2",
	stairs.stone)

stairs.register_all("sandstonebrick4", "xanadu:sandstonebrick4",
	grp,
	{"sandstonebrick4.png"},
	"Decorative Sandstone 4",
	stairs.stone)

stairs.register_slab("desert_cobble1", "xanadu:desert_cobble1",
	grp,
	{"desert_cobble1.png"},
	"Decorative desert cobble 1 slab",
	stairs.stone)

stairs.register_slab("desert_cobble5", "xanadu:desert_cobble5",
	grp,
	{"desert_cobble5.png"},
	"Decorative desert cobble 5 slab",
	stairs.stone)

stairs.register_slab("desert_stone1", "xanadu:desert_stone1",
	grp,
	{"desert_stone1.png"},
	"Decorative desert stone 1 slab",
	stairs.stone)

stairs.register_slab("desert_stone3", "xanadu:desert_stone3",
	grp,
	{"desert_stone3.png"},
	"Decorative desert stone 3 slab",
	stairs.stone)

stairs.register_slab("desert_stone4", "xanadu:desert_stone4",
	grp,
	{"desert_stone4.png"},
	"Decorative desert stone 4 slab",
	stairs.stone)

stairs.register_stair("desert_stone4", "xanadu:desert_stone4",
	grp,
	{"desert_stone4.png"},
	"Decorative desert stone 4 stair",
	stairs.stone)

stairs.register_slab("desert_stone5", "xanadu:desert_stone5",
	grp,
	{"desert_stone5.png"},
	"Decorative desert stone 5 slab",
	stairs.stone)

stairs.register_slab("red1", "xanadu:red1",
	grp,
	{"baked_clay_red1.png"},
	"Decorative baked red clay 1 slab",
	stairs.stone)

stairs.register_all("bred2", "xanadu:red2",
	grp,
	{"baked_clay_red2.png"},
	"Decorative baked red clay 2",
	stairs.stone)

stairs.register_all("compressed_cobble", "xanadu:compressed_cobble",
	{cracky = 3, level = 2},
	{"compressed_cobble.png"},
	"Compressed Cobble",
	stairs.stone)

stairs.register_all("compressed_dirt", "xanadu:compressed_dirt",
	{crumbly = 2},
	{"compressed_dirt.png"},
	"Compressed Dirt",
	stairs.stone)

stairs.register_slope("steelblock1", "xanadu:steelblock1",
	{cracky = 1, level = 2},
	{"steel_block1.png"},
	"Decorative Steelblock 1",
	stairs.steel)

stairs.register_slab("steelblock3", "xanadu:steelblock3",
	{cracky = 1, level = 2},
	{"steel_block3.png"},
	"Decorative Steelblock 3",
	stairs.steel)

stairs.register_slope("steelblock5", "xanadu:steelblock5",
	{cracky = 1, level = 2},
	{"steel_block5.png"},
	"Decorative Steelblock 5",
	stairs.steel)
end


--= Castle Mod

if minetest.get_modpath("castle") then

grp = {cracky = 2}

stairs.register_all("dungeon_stone", "castle:dungeon_stone",
	grp,
	{"castle_dungeon_stone.png"},
	"Dungeon",
	stairs.stone)

stairs.register_all("stonewall", "castle:stonewall",
	grp,
	{"castle_stonewall.png"},
	"Castle Wall",
	stairs.stone)

end

--= Wool Mod

if minetest.get_modpath("wool") then

local colours = {
	{"black",      "Black",      "#000000b0"},
	{"blue",       "Blue",       "#015dbb70"},
	{"brown",      "Brown",      "#a78c4570"},
	{"cyan",       "Cyan",       "#01ffd870"},
	{"dark_green", "Dark Green", "#005b0770"},
	{"dark_grey",  "Dark Grey",  "#303030b0"},
	{"green",      "Green",      "#61ff0170"},
	{"grey",       "Grey",       "#5b5b5bb0"},
	{"magenta",    "Magenta",    "#ff05bb70"},
	{"orange",     "Orange",     "#ff840170"},
	{"pink",       "Pink",       "#ff65b570"},
	{"red",        "Red",        "#ff000070"},
	{"violet",     "Violet",     "#2000c970"},
	{"white",      "White",      "#abababc0"},
	{"yellow",     "Yellow",     "#e3ff0070"},
}

for i = 1, #colours, 1 do

stairs.register_all("wool_" .. colours[i][1], "wool:" .. colours[i][1],
	{snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3},
	{"wool_" .. colours[i][1] .. ".png"},
	colours[i][2] .. " Wool",
	stairs.wool)

end -- END for

end
