Stairs API
----------

The stairs API lets you register stairs and slabs and ensures that they are registered the same way as those delivered with Minetest Game, to keep them compatible with other mods.

* `stairs.register_stair(subname, recipeitem, groups, images, description, sounds, worldaligntex)`

 * Registers a stair
 * `subname`: Basically the material name (e.g. cobble) used for the stair name. Nodename pattern: "stairs:stair_subname"
 * `recipeitem`: Item used in the craft recipe, e.g. "default:cobble", may be `nil`
 * `groups`: See [Known damage and digging time defining groups]
 * `images`: See [Tile definition]
 * `description`: Used for the description field in the stair's definition
 * `sounds`: See [#Default sounds]
 * `worldaligntex`: A bool to set all textures world-aligned. Default false. See [Tile definition]


* `stairs.register_slab(subname, recipeitem, groups, images, description, sounds, worldaligntex)`

 * Registers a slab
 * `subname`: Basically the material name (e.g. cobble) used for the slab name. Nodename pattern: "stairs:slab_subname"
 * `recipeitem`: Item used in the craft recipe, e.g. "default:cobble"
 * `groups`: See [Known damage and digging time defining groups]
 * `images`: See [Tile definition]
 * `description`: Used for the description field in the slab's definition
 * `sounds`: See [#Default sounds]
 * `worldaligntex`: A bool to set all textures world-aligned. Default false. See [Tile definition]


* `stairs.register_stair_inner(subname, recipeitem, groups, images, description, sounds, worldaligntex)`

 * Registers an inner corner stair
 * `subname`: Basically the material name (e.g. cobble) used for the stair name. Nodename pattern: "stairs:stair_inner_subname"
 * `recipeitem`: Item used in the craft recipe, e.g. "default:cobble", may be `nil`
 * `groups`: See [Known damage and digging time defining groups]
 * `images`: See [Tile definition]
 * `description`: Used for the description field in the stair's definition with "Inner" prepended
 * `sounds`: See [#Default sounds]
 * `worldaligntex`: A bool to set all textures world-aligned. Default false. See [Tile definition]


* `stairs.register_stair_outer(subname, recipeitem, groups, images, description, sounds, worldaligntex)`

 * Registers an outer corner stair
 * `subname`: Basically the material name (e.g. cobble) used for the stair name. Nodename pattern: "stairs:stair_outer_subname"
 * `recipeitem`: Item used in the craft recipe, e.g. "default:cobble", may be `nil`
 * `groups`: See [Known damage and digging time defining groups]
 * `images`: See [Tile definition]
 * `description`: Used for the description field in the stair's definition with "Outer" prepended
 * `sounds`: See [#Default sounds]
 * `worldaligntex`: A bool to set all textures world-aligned. Default false. See [Tile definition]


* `stairs.register_slope(subname, recipeitem, groups, images, description, sounds, worldaligntex)`

 * Registers a slope
 * `subname`: Basically the material name (e.g. cobble) used for the stair name. Nodename pattern: "stairs:stair_outer_subname"
 * `recipeitem`: Item used in the craft recipe, e.g. "default:cobble", may be `nil`
 * `groups`: See [Known damage and digging time defining groups]
 * `images`: See [Tile definition]
 * `description`: Used for the description field in the stair's definition with "Outer" prepended
 * `sounds`: See [#Default sounds]
 * `worldaligntex`: A bool to set all textures world-aligned. Default false. See [Tile definition]


* `stairs.register_stair_and_slab(subname, recipeitem, groups, images, desc_stair, desc_slab, sounds, worldaligntex)`

 * A wrapper for stairs.register_stair, stairs.register_slab, stairs.register_stair_inner, stairs.register_stair_outer
 * Uses almost the same arguments as stairs.register_stair
 * `desc_stair`: Description for stair nodes. For corner stairs 'Inner' or 'Outer' will be prefixed
 * `desc_slab`: Description for slab node


* `stairs.register_all(subname, recipeitem, groups, images, description, sounds, worldaligntex)`

 * A wrapper for stairs.register_stair, stairs.register_slab, stairs.register_stair_inner, stairs.register_stair_outer, stairs.register_slope
 * Uses almost the same arguments as stairs.register_stair
 * `description`: Description for stair nodes. 'stair' 'slab' 'stair_inner' 'stair_outer' 'Slope' will be prefixed
