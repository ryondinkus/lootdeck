-- A 1 in 2 chance of removing curses for the floor or gaining a soul heart
local Name = "Dagaz"
local Tag = "dagaz"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

-- TODO: Audio/visual indicators
local function MC_USE_CARD(_, c, p)
	local sfx = lootdeck.sfx
	local rng = lootdeck.rng
    local level = Game():GetLevel()
    local effect = rng:RandomInt(2)
    if effect == 0 then
        sfx:Play(SoundEffect.SOUND_SUPERHOLY,1,0)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GROUND_GLOW, 0, p.Position, Vector.Zero, p)
        level:RemoveCurses(level:GetCurses())
    else
        sfx:Play(SoundEffect.SOUND_HOLY,1,0)
        p:AddSoulHearts(2)
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