local helper = LootDeckHelpers
local entityVariants = include("entityVariants/registry")

-- 40 damage to all monsters | Spawn a random Card Reading portal | Lose 3 bombs, coins, and keys, spawn 3 chests
local Names = {
    en_us = "Black Rune",
    spa = "Runa Negra"
}
local Name = Names.en_us
local Tag = "blackRune"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
	en_us = "Random chance for any of these effects:# Deals 40 damage to all enemies in room# Spawns a random {{Collectible660}} Card Reading portal# Lose 3 Bombs, Keys, and Coins, then spawn 3 chests",
	spa = "Probabilidad de que ocurra uno de los siguientes efectos:#Hacer 40 de daño a todos los enemigos de la habitación#Generar un portal aleatorio de {{Collectible660}} Lectura de cartas#Perder 3 monedas, llaves y bombas, para generar 3 cofres"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of three effects:", "- Deals 40 damage to all room enemies.","- Spawns a random Card Reading portal, which will warp you to a random room. Higher priority is given to special room warps.", "- Lose 3 Coins, Keys, and Bombs, if possible. Spawn 3 chests.", "Holographic Effect: Performs the same random effect twice.")

local function MC_USE_CARD(_, c, p, f, shouldDouble, rng)
    local sfx = lootdeck.sfx
	local room = Game():GetRoom()
    local tempPickups = {}

	helper.RunRandomFunction(rng, shouldDouble,
	function()
		sfx:Play(SoundEffect.SOUND_DEATH_CARD,1,0)
        Game():ShakeScreen(15)
        helper.ForEachEntityInRoom(function(entity)
    		entity:TakeDamage(40, 0, EntityRef(p), 0)
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, p)
    		poof.Color = Color(0,0,0,1,0,0,0)
    	end, nil, nil, nil,
    	function(entity)
    		local npc = entity:ToNPC()
    		return npc and npc:IsVulnerableEnemy()
    	end)
	end,
	function()
		local subEffect = rng:RandomInt(2)
        local portalType
        if subEffect == 0 then
            portalType = rng:RandomInt(3)
        else
            portalType = 3
        end
        sfx:Play(SoundEffect.SOUND_THUMBSUP,1,0)
        local portalGridIndexes = {}

        helper.ForEachEntityInRoom(function(entity)
            table.insert(portalGridIndexes, room:GetGridIndex(entity.Position))
        end, EntityType.ENTITY_EFFECT, EffectVariant.PORTAL_TELEPORT)

        local spawnPos

        local validSpawnIndex = false
        for i = 0, 10000 do
            if not spawnPos or helper.TableContains(portalGridIndexes, room:GetGridIndex(spawnPos)) or room:GetGridEntity(room:GetGridIndex(spawnPos)) then
                spawnPos = room:FindFreePickupSpawnPosition(p.Position, 0)
            else
                validSpawnIndex = true
                break
            end
        end

        if not validSpawnIndex then
            spawnPos = room:GetRandomPosition(20)
        end

        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PORTAL_TELEPORT, portalType, spawnPos, Vector.Zero, p)
        local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, p)
		poof.Color = Color(0,0,0,1,0,0,0)
        local tempPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, spawnPos, Vector.Zero, p)
        table.insert(tempPickups, tempPickup)
    end,
	function()
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
        for i=1,3 do
            if p:GetNumCoins() > 0 then
    			Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostPenny.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
    			p:AddCoins(-1)
    		end
    		if p:GetNumBombs() > 0 then
    			Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostBomb.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
    			p:AddBombs(-1)
    		end
    		if p:GetNumKeys() > 0 then
    			Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostKey.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
    			p:AddKeys(-1)
    		end
            helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, room:FindFreePickupSpawnPosition(p.Position, 0, true), Vector.Zero, p)
        end
	end)
    if #tempPickups > 0 then
        for _,v in pairs(tempPickups) do
            v:Remove()
        end
    end
    tempPickups = {}
end

return {
    Name = Name,
	Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
