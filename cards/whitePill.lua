local helper = include('helper_functions')

-- Poison fart | weaken all enemies (they take 2x damage) | do nothing
local Name = "Pills! White"
local Tag = "whitePill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    local sfx = lootdeck.sfx
    local effect = lootdeck.rng:RandomInt(3)
    local data = p:GetData()
    if effect == 0 then
        helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_BEAN)
    elseif effect == 1 then
        local useFlags = UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOCOSTUME
        p:UseCard(Card.CARD_REVERSE_STRENGTH, useFlags)
        local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, p.Position, Vector.Zero, p)
        fart.Color = Color(1,0,1,1,0,0,0)
        sfx:Play(SoundEffect.SOUND_FART,1,0)
        sfx:Play(SoundEffect.SOUND_DEATH_CARD,1,0)
    else
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_PLOP,1,0)
    end
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
