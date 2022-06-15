-- boats/init.lua

local is_pa = minetest.get_modpath("player_api")

-- translation support and 5.x version check
local S, is_50, is_53
if minetest.get_translator ~= nil then
	S = minetest.get_translator("boats") -- 5.x translation function
else
	if minetest.get_modpath("intllib") then
		dofile(minetest.get_modpath("intllib") .. "/init.lua")
		if intllib.make_gettext_pair then
			gettext, ngettext = intllib.make_gettext_pair() -- new gettext method
		else
			gettext = intllib.Getter() -- old text file method
		end
		S = gettext
	else -- boilerplate function
		S = function(str, ...)
			local args = {...}
			return str:gsub("@%d+", function(match)
				return args[tonumber(match:sub(2))]
			end)
		end
	end
end
-- check for minetest 5.x compatibility
is_50 = has_feature("httpfetch_binary_data")
is_53 = minetest.has_feature("direct_velocity_on_players") or minetest.has_feature("is_creative_enabled") of false

--
-- Helper functions
--

local function is_water(pos)
	local nn = minetest.get_node(pos).name
	return minetest.get_item_group(nn, "water") ~= 0
end


local function get_velocity(v, yaw, y)
	local x = -math.sin(yaw) * v
	local z =  math.cos(yaw) * v
	return {x = x, y = y, z = z}
end


local function get_v(v)
	return math.sqrt(v.x ^ 2 + v.z ^ 2)
end

local creative = minetest.settings:get_bool("creative_mode")

function is_creative_enabled(name)

	if creative or minetest.check_player_privs(name, {creative = true}) then
		if is_53 then
			return minetest.is_creative_enabled(name)
		else
			return true
		end
	end

	return false
end

--
-- Boat entity
--

local boat = {
	initial_properties = {
		physical = true,
		-- Warning: Do not change the position of the collisionbox top surface,
		-- lowering it causes the boat to fall through the world if underwater
		collisionbox = {-0.5, -0.35, -0.5, 0.5, 0.3, 0.5},
		visual = "mesh",
		mesh = "boats_boat.obj",
		textures = {"default_wood.png"}
	},

	driver = nil,
	v = 0,
	last_v = 0,
	removed = false,
	auto = false
}


function boat.on_rightclick(self, clicker)
	if not clicker or not clicker:is_player() then
		return
	end
	local name = clicker:get_player_name()
	if self.driver and name == self.driver then
		-- Cleanup happens in boat.on_detach_child
		clicker:set_detach()
		if is_pa then
			player_api.set_animation(clicker, "stand", 30)
		else
			default.player_set_animation(clicker, "stand", 30)
		end
		local pos = clicker:get_pos()
		pos = {x = pos.x, y = pos.y + 0.2, z = pos.z}
		minetest.after(0.1, function()
			clicker:set_pos(pos)
		end)
	elseif not self.driver then
		clicker:set_attach(self.object, "",
			{x = 0.5, y = 1, z = -3}, {x = 0, y = 0, z = 0})

		self.driver = name
		if is_pa then
			player_api.player_attached[name] = true
		else
			default.player_attached[name] = true
		end

		minetest.after(0.2, function()
			if is_pa then
				player_api.set_animation(clicker, "sit", 30)
			else
				default.player_set_animation(clicker, "sit", 30)
			end
		end)
		clicker:set_look_horizontal(self.object:get_yaw())
	end
end


-- If driver leaves server while driving boat
function boat.on_detach_child(self, child)
	if child and child:get_player_name() == self.driver then
		if is_pa then
			player_api.player_attached[child:get_player_name()] = false
		else
			default.player_attached[child:get_player_name()] = false
		end
		self.driver = nil
		self.auto = false
	end
end


function boat.on_activate(self, staticdata, dtime_s)
	self.object:set_armor_groups({fleshy = 100})
	if staticdata then
		self.v = tonumber(staticdata)
	end
	self.last_v = self.v
end


function boat.get_staticdata(self)
	return tostring(self.v)
end


function boat.on_punch(self, puncher)
	if not puncher or not puncher:is_player() or self.removed then
		return
	end

	local name = puncher:get_player_name()
	if self.driver and name == self.driver then
		self.driver = nil
		puncher:set_detach()
		if is_pa then
			player_api.player_attached[name] = false
		else
			default.player_attached[name] = false
		end
	end
	if not self.driver then
		self.removed = true
		local inv = puncher:get_inventory()
		if not is_creative_enabled(name)
				or not inv:contains_item("main", "boats:boat") then
			local leftover = inv:add_item("main", "boats:boat")
			-- if no room in inventory add a replacement boat to the world
			if not leftover:is_empty() then
				minetest.add_item(self.object:get_pos(), leftover)
			end
		end
		-- delay remove to ensure player is detached
		minetest.after(0.1, function()
			self.object:remove()
		end)
	end
end


function boat.on_step(self, dtime)

	-- after 10 seconds remove boat and drop as item if not boarded
	self.count = (self.count or 0) + dtime

	if self.count > 10 then
		minetest.add_item(self.object:get_pos(), "boats:boat")
		self.object:remove()
		return
	end

	self.v = get_v(self.object:get_velocity()) * math.sign(self.v)
	if self.driver then
		self.count = 0 -- reset 10 second drop counter
		local driver_objref = minetest.get_player_by_name(self.driver)
		if driver_objref then
			local ctrl = driver_objref:get_player_control()
			if ctrl.up and ctrl.down then
				if not self.auto then
					self.auto = true
					minetest.chat_send_player(self.driver, S("Boat cruise mode on"))
				end
			elseif ctrl.down then
				self.v = self.v - dtime * 2.0
				if self.auto then
					self.auto = false
					minetest.chat_send_player(self.driver, S("Boat cruise mode off"))
				end
			elseif ctrl.up or self.auto then
				self.v = self.v + dtime * 2.0
			end
			if ctrl.left then
				if self.v < -0.001 then
					self.object:set_yaw(self.object:get_yaw() - dtime * 0.9)
				else
					self.object:set_yaw(self.object:get_yaw() + dtime * 0.9)
				end
			elseif ctrl.right then
				if self.v < -0.001 then
					self.object:set_yaw(self.object:get_yaw() + dtime * 0.9)
				else
					self.object:set_yaw(self.object:get_yaw() - dtime * 0.9)
				end
			end
		else
			-- If driver leaves server while driving 'driver' is present
			-- but driver objectref is nil. Reset boat properties.
			self.driver = nil
			self.auto = false
		end
	end
	local velo = self.object:get_velocity()
	if not self.driver and
			self.v == 0 and velo.x == 0 and velo.y == 0 and velo.z == 0 then
		self.object:set_pos(self.object:get_pos())
		return
	end
	-- We need to preserve velocity sign to properly apply drag force
	-- while moving backward
	local drag = dtime * math.sign(self.v) * (0.01 + 0.0796 * self.v * self.v)
	-- If drag is larger than velocity, then stop horizontal movement
	if math.abs(self.v) <= math.abs(drag) then
		self.v = 0
	else
		self.v = self.v - drag
	end

	local p = self.object:get_pos()
	p.y = p.y - 0.5
	local new_velo
	local new_acce = {x = 0, y = 0, z = 0}
	if not is_water(p) then
		local nodedef = minetest.registered_nodes[minetest.get_node(p).name]
		if (not nodedef) or nodedef.walkable then
			self.v = 0
			new_acce = {x = 0, y = 1, z = 0}
		else
			new_acce = {x = 0, y = -9.8, z = 0}
		end
		new_velo = get_velocity(self.v, self.object:get_yaw(),
			self.object:get_velocity().y)
		self.object:set_pos(self.object:get_pos())
	else
		p.y = p.y + 1
		if is_water(p) then
			local y = self.object:get_velocity().y
			if y >= 5 then
				y = 5
			elseif y < 0 then
				new_acce = {x = 0, y = 20, z = 0}
			else
				new_acce = {x = 0, y = 5, z = 0}
			end
			new_velo = get_velocity(self.v, self.object:get_yaw(), y)
			self.object:set_pos(self.object:get_pos())
		else
			new_acce = {x = 0, y = 0, z = 0}
			if math.abs(self.object:get_velocity().y) < 1 then
				local pos = self.object:get_pos()
				pos.y = math.floor(pos.y) + 0.5
				self.object:set_pos(pos)
				new_velo = get_velocity(self.v, self.object:get_yaw(), 0)
			else
				new_velo = get_velocity(self.v, self.object:get_yaw(),
					self.object:get_velocity().y)
				self.object:set_pos(self.object:get_pos())
			end
		end
	end
	self.object:set_velocity(new_velo)
	self.object:set_acceleration(new_acce)

	-- if boat comes to sudden stop then destroy boat and drop 3x wood
	if (self.v2 or 0) - self.v >= 3 then

		if self.driver then
--print ("Crash! with driver", self.v2 - self.v)
			local driver_objref = minetest.get_player_by_name(self.driver)
			default.player_attached[self.driver] = false
			driver_objref:set_detach()
			if is_pa then
				player_api.set_animation(driver_objref, "stand" , 30)
			else
				default.player_set_animation(driver_objref, "stand" , 30)
			end
		else
--print ("Crash! no driver")
		end

		minetest.add_item(self.object:get_pos(), "default:wood 3")
		self.object:remove()
		return
	end

	self.v2 = self.v
end


minetest.register_entity("boats:boat", boat)


minetest.register_craftitem("boats:boat", {
	description = S("Boat"),
	inventory_image = "boats_inventory.png",
	wield_image = "boats_wield.png",
	wield_scale = {x = 2, y = 2, z = 1},
	liquids_pointable = true,
	groups = {flammable = 2},

	on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local udef = minetest.registered_nodes[node.name]
		if udef and udef.on_rightclick and
				not (placer and placer:is_player() and
				placer:get_player_control().sneak) then
			return udef.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		if pointed_thing.type ~= "node" then
			return itemstack
		end
		if not is_water(pointed_thing.under) then
			return itemstack
		end
		pointed_thing.under.y = pointed_thing.under.y + 0.5
		boat = minetest.add_entity(pointed_thing.under, "boats:boat")
		if boat then
			if placer then
				boat:set_yaw(placer:get_look_horizontal())
			end
			local player_name = placer and placer:get_player_name() or ""
			if not is_creative_enabled(player_name) then
				itemstack:take_item()
			end
		end
		return itemstack
	end,
})


minetest.register_craft({
	output = "boats:boat",
	recipe = {
		{"",           "",           ""          },
		{"group:wood", "",           "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
	},
})

minetest.register_craft({
	type = "fuel",
	recipe = "boats:boat",
	burntime = 20,
})


print ("[MOD] Boats loaded")
