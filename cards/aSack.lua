local helper = lootdeckHelpers

-- Spawns 3 loot cards
local Names = {
    en_us = "A Sack",
    spa = "Un Saco"
}
local Name = Names.en_us
local Tag = "aSack"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "{{Card}} Spawns 3 Loot Cards",
    spa = "{{Card}} Genera 3 cartas de loot"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, spawns 3 Loot Cards.", "Holographic Effect: Spawns 6 Loot Cards.")

local function MC_USE_CARD(_, c, p, f, _, rng)
    local game = Game()
    local sfx = lootdeck.sfx
    local room = game:GetRoom()
    for i=0,2 do
        local cardId = helper.GetWeightedLootCardId(true)
        helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardId, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
    end
    sfx:Play(SoundEffect.SOUND_SHELLGAME,1,0)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
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
            Id,
            true
        }
    }
}
