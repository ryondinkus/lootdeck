local helper = include('helper_functions')
local entityVariants = include("entityVariants/registry")

-- 40 damage to all monsters | Spawn a random Card Reading portal | Lose 3 bombs, coins, and keys, spawn 3 chests
local Name = "Black Rune"
local Tag = "blackRune"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Random chance for any of these effects:# Deals 40 damage to all enemies in room# Spawns a random {{Collectible660}} Card Reading portal# Lose 3 Bombs, Keys, and Coins, then spawn 3 chests"
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of three effects:", "- Deals 40 damage to all room enemies.","- Spawns a random Card Reading portal, which will warp you to a random room. Higher priority is given to special room warps.", "- Lose 3 Coins, Keys, and Bombs, if possible. Spawn 3 chests.")

local function MC_USE_CARD(_, c, p)
    local sfx = lootdeck.sfx
	local rng = lootdeck.rng
	local effect = rng:RandomInt(3)
	local room = Game():GetRoom()
	if effect == 0 then
		sfx:Play(SoundEffect.SOUND_DEATH_CARD,1,0)
        helper.ForEachEntityInRoom(function(entity)
    		entity:TakeDamage(40, 0, EntityRef(p), 0)
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, p)
    		poof.Color = Color(0,0,0,1,0,0,0)
    	end, nil, nil, nil,
    	function(entity)
    		local npc = entity:ToNPC()
    		return npc and npc:IsVulnerableEnemy()
    	end)
	elseif effect == 1 then
		local subEffect = rng:RandomInt(2)
        local portalType
        if subEffect == 0 then
            portalType = rng:RandomInt(3)
        else
            portalType = 3
        end
        sfx:Play(SoundEffect.SOUND_THUMBSUP,1,0)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PORTAL_TELEPORT, portalType, room:FindFreePickupSpawnPosition(p.Position, 0, true), Vector.Zero, p)
	else
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
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, room:FindFreePickupSpawnPosition(p.Position, 0, true), Vector.Zero, p)
        end
	end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
