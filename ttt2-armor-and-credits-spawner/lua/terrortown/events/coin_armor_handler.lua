if SERVER then
	local function spawnItemsAroundMap(itemToSpawn)
		-- limit by defined max and found items
		local amount = math.min(#ents.FindByClass("item_*"), 3)

		local spawns = ents.FindByClass("item_*")
		for i = 1, amount do
			local index = math.random(#spawns)
			local spwn = spawns[index]
			local spwn_name = spwn:GetClass()
			local ent = ents.Create(itemToSpawn)

			ent:SetPos(spwn:GetPos())
			
			local ang = ent:GetAngles() -- Get the current angles of the entity
			ang:RotateAroundAxis(ang:Up(), 90) -- Rotate 90 degrees around the Up axis
			ent:SetAngles(ang) -- Set the new angles
			
			ent:Spawn()
			ent:PhysicsInit(SOLID_VPHYSICS)
			spwn:Remove()
			table.remove(spawns, index)
			local newSpwn = ents.Create(spwn_name)

			newSpwn:SetPos(ent:GetPos() + Vector(0, 200, 0))
			newSpwn:Spawn()
		end
	end
	
	hook.Add("TTTBeginRound", "SpawnCoinsAndArmorBeginRound", function()
		spawnItemsAroundMap("credit_coin")
		spawnItemsAroundMap("armor_plate")
	end)
end