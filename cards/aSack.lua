local helper = include('helper_functions')

-- Spawns 3 loot cards
local Name = "A Sack"
local Tag = "aSack"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    local game = Game()
    local sfx = lootdeck.sfx
	local rng = lootdeck.rng
    local room = game:GetRoom()
    for i=0,2 do
        local cardId = helper.GetWeightedLootCardId()
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardId, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
    end
    sfx:Play(SoundEffect.SOUND_SHELLGAME,1,0)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}