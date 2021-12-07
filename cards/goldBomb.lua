local helper = lootdeckHelpers

-- Explodes three random enemies in the room
local Names = {
    en_us = "Gold Bomb!!",
    spa = "¡¡Bomba Dorada!!"
}
local Name = Names.en_us
local Tag = "goldBomb"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
	en_us = "Explodes on three random enemies, dealing 40 damage to each#{{Warning}} If no enemies are in the room initally, this will explode on the player",
	spa = "Tres enemigos aleatorios explotan, provocando 40 de daño#{{Warning}} Si no hay enemigos en la sala, el jugador explotará"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, spawns an explosion on three random enemies in the room, dealing 40 damage to each enemy and all enemies around them.", "If used with no targetable enemies in the room, an explosion will spawn on the player instead.", "- This only applies to the inital explosion. If the first or second explosion wipes out all enemies in the room, any subsequent explosions will simply not happen.", "Holographic Effect: Creates 6 explosions, two at a time, if able.")

local function MC_USE_CARD(_, c, p, f, shouldDouble, rng)
	local data = p:GetData().lootdeck
	if not helper.AreEnemiesInRoom(Game():GetRoom()) then
        for i=0,4 do
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GOLD_PARTICLE, 0, p.Position, Vector.FromAngle(rng:RandomInt(360)) * 5, nil)
        end
		Isaac.Explode(p.Position, nil, 40)
        lootdeck.sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY, 1, 0)

        return false
	else
		data[Tag] = 1
        if shouldDouble then
            data[Tag] = data[Tag] + 1
        end
	end
end

local function MC_POST_NEW_ROOM()
    helper.ClearStaggerSpawn(Tag)
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    local rng = p:GetCardRNG(Id)
	helper.StaggerSpawn(Tag, p, 15, 3, function(player, _, pastInitSeed)
		local target = helper.FindRandomEnemy(player.Position, rng, nil, function(entity) return entity.InitSeed ~= pastInitSeed end) or 0
		if target ~= 0 then
            for i=0,4 do
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GOLD_PARTICLE, 0, target.Position, Vector.FromAngle(rng:RandomInt(360)) * 5, nil)
            end
            Isaac.Explode(target.Position, nil, 40)
            lootdeck.sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY, 1, 0)
            return target.InitSeed
		end
	end)
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
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
		{
			ModCallbacks.MC_POST_PEFFECT_UPDATE,
			MC_POST_PEFFECT_UPDATE
		}
    }
}
