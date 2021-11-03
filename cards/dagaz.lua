local helper = include("helper_functions")

-- A 1 in 2 chance of removing curses for the floor or gaining a soul heart
local Names = {
    en_us = "Dagaz",
    spa = "Dagaz"
}
local Name = Names.en_us
local Tag = "dagaz"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Random chance for either of these effects:# Clear all curses for the floor#{{SoulHeart}} Gain a Soul Heart",
    spa = "Probabilidad de que ocurra uno de los siguientes efectoa aleatorios:#Deshacerse de todas las maldiciones del piso#{{SoulHeart}} Ganar un Corazón de Alma"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers either effect:", "- Clear all curses for the floor. This does not apply to permanent curses in Challenges.", "- Gain a Soul Heart.")

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
