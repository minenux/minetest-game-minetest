-- Minetest 0.4 mod: player
-- See README.txt for licensing and other information.

player_api = {}

-- Player animation blending
-- Note: This is currently broken due to a bug in Irrlicht, leave at 0
local animation_blend = 0

player_api.modelchar = "character.b3d"
player_api.eyeheithg = 1.5
player_api.collsibox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3}

local is_50 = minetest.has_feature("object_use_texture_alpha") or nil

function  player_api.dynamicmodel(player_name)

	if not player_name then
		if is_50 then
			player_api.modelchar = "character50.b3d"
			player_api.eyeheithg = 1.625
		else
			player_api.modelchar = "character40.b3d"
			player_api.eyeheithg = 1.47
		end
		return
	end

	local engineold = is_50
	local info = minetest.get_player_information(player_name)
	-- ugly hack due mixed protocols:
	if info then
		local test = info.version_string or "5.0"
		if test:find("0.4.") or test:find("4.0.")  or test:find("4.1.") then
			engineold = true
			player_api.modelchar = "character40.b3d"
			player_api.eyeheithg = 1.47
			player_api.collsibox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3}
		else
			engineold = false
			player_api.modelchar = "character50.b3d"
			player_api.eyeheithg = 1.625
			player_api.collsibox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3}
		end
		-- only refix register model when protocols are mixed, will slow down server
		if engineold == true and is_50 == true then
			minetest.log("warning", "[default/player_api] performance impact: mixed protocols DETECTED on player .. "..player_name.." doin re-register model hack")
			player_api.register_model( player_api.modelchar, {
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
				collisionbox = player_api.collsibox,
				stepheight = 0.6,
				eye_height = eyeheithg,
			})
		end
	end
end

player_api.registered_models = { }

-- Local for speed.
local models = player_api.registered_models

function player_api.register_model(name, def)
	models[name] = def
end

-- Player stats and animations
local player_model = {}
local player_textures = {}
local player_anim = {}
local player_sneak = {}
player_api.player_attached = {}

function player_api.get_animation(player)
	local name = player:get_player_name()
	return {
		model = player_model[name],
		textures = player_textures[name],
		animation = player_anim[name],
	}
end

-- Called when a player's appearance needs to be updated
function player_api.set_model(player, model_name)
	local name = player:get_player_name()
	local model = models[model_name]
	if model then
		if player_model[name] == model_name then
			return
		end
		player:set_properties({
			mesh = model_name,
			textures = player_textures[name] or model.textures,
			visual = "mesh",
			visual_size = model.visual_size or {x = 1, y = 1},
			collisionbox = model.collisionbox or {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
			stepheight = model.stepheight or 0.6,
			eye_height = model.eye_height or player_api.eyeheithg,
		})
		player_api.set_animation(player, "stand")
	else
		player:set_properties({
			textures = {"player.png", "player_back.png"},
			visual = "upright_sprite",
			visual_size = {x = 1, y = 2},
			collisionbox = player_api.collsibox,
			stepheight = 0.6,
			eye_height = player_api.eyeheithg,
		})
	end
	player_model[name] = model_name
end

function player_api.set_textures(player, textures)
	local name = player:get_player_name()
	local model = models[player_model[name]]
	local model_textures = model and model.textures or nil
	player_textures[name] = textures or model_textures
	player:set_properties({textures = textures or model_textures,})
end

function player_api.set_animation(player, anim_name, speed)
	local name = player:get_player_name()
	if player_anim[name] == anim_name then
		return
	end
	local model = player_model[name] and models[player_model[name]]
	if not (model and model.animations[anim_name]) then
		return
	end
	local anim = model.animations[anim_name]
	player_anim[name] = anim_name
	player:set_animation(anim, speed or model.animation_speed, animation_blend)
end

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	player_model[name] = nil
	player_anim[name] = nil
	player_textures[name] = nil
end)

-- Localize for better performance.
local player_set_animation = player_api.set_animation
local player_attached = player_api.player_attached

-- Prevent knockback for attached players
local old_calculate_knockback = minetest.calculate_knockback
function minetest.calculate_knockback(player, ...)
	if player_attached[player:get_player_name()] then
		return 0
	end
	return old_calculate_knockback(player, ...)
end

-- Check each player and apply animations
minetest.register_globalstep(function(dtime)
	for _, player in pairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local model_name = player_model[name]
		local model = model_name and models[model_name]
		if model and not player_attached[name] then
			local controls = player:get_player_control()
			local walking = false
			local animation_speed_mod = model.animation_speed or 30

			-- Determine if the player is walking
			if controls.up or controls.down or controls.left or controls.right then
				walking = true
			end

			-- Determine if the player is sneaking, and reduce animation speed if so
			if controls.sneak then
				animation_speed_mod = animation_speed_mod / 2
			end

			-- Apply animations based on what the player is doing
			if player:get_hp() == 0 then
				player_set_animation(player, "lay")
			elseif walking then
				if player_sneak[name] ~= controls.sneak then
					player_anim[name] = nil
					player_sneak[name] = controls.sneak
				end
				if controls.LMB then
					player_set_animation(player, "walk_mine", animation_speed_mod)
				else
					player_set_animation(player, "walk", animation_speed_mod)
				end
			elseif controls.LMB then
				player_set_animation(player, "mine")
			else
				player_set_animation(player, "stand", animation_speed_mod)
			end
		end
	end
end)
