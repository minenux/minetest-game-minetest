-- player/init.lua

dofile(minetest.get_modpath("player_api") .. "/api.lua")

player_api.dynamicmodel(nil)

-- Default player appearance
player_api.register_model(player_api.modelchar, {
	animation_speed = 30,
	textures = {"character.png", },
	animations = {
		-- Standard animations.
		stand     = {x = 0,   y = 79},
		lay       = {x = 162, y = 166},
		walk      = {x = 168, y = 187},
		mine      = {x = 189, y = 198},
		walk_mine = {x = 200, y = 219},
		sit       = {x = 81,  y = 160},
	},
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	stepheight = 0.6,
	eye_height = player_api.eyeheithg,
})

-- Update appearance when the player joins
minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	player_api.dynamicmodel(player_name)
	player_api.player_attached[player_name] = false
	player_api.set_model(player, player_api.modelchar)
	player:set_local_animation(
		{x = 0,   y = 79},
		{x = 168, y = 187},
		{x = 189, y = 198},
		{x = 200, y = 219},
		30
	)
end)
