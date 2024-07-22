hook.Add("TTTBeginRound", "SpawnCoinsAndArmorBeginRound", function()
	spawnItemsAroundMap("credit_coin")
	spawnItemsAroundMap("armor_plate")
end)

local function spawnItemsAroundMap(itemToSpawn)
	-- limit by defined max and found items
	local amount = math.min(#ents.FindByClass("item_*"), 3)

	-- make sure more than 0 items can be spawned
	if amount == 0 then return end

	local spawns = ents.FindByClass("item_*")
	for i = 1, amount do
		local index = math.random(#spawns)
		local spwn = spawns[index]
		local spwn_name = spwn:GetClass()
		local thing = ents.Create(itemToSpawn)

		thing:SetPos(spwn:GetPos())
		thing:Spawn()
		spwn:Remove()
		table.remove(spawns, index)
		local newSpwn = ents.Create(spwn_name)

		newSpwn:SetPos(thing:GetPos() + Vector(20, 20, 0))
		newSpwn:Spawn()
	end
end