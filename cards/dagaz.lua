local helper = LootDeckAPI

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
local HolographicDescriptions = {
    en_us = "Random chance for either of these effects:# Clear all curses for the floor#{{SoulHeart}} Gain {{ColorRainbow}}2{{CR}} Soul Hearts",
    spa = "Probabilidad de que ocurra uno de los siguientes efectoa aleatorios:#Deshacerse de todas las maldiciones del piso#{{SoulHeart}} Ganar {{ColorRainbow}}2{{CR}} Corazónes de Alma"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers either effect:", "- Clear all curses for the floor. This does not apply to permanent curses in Challenges.", "- Gain a Soul Heart.", "Holographic Effect: Performs the same random effect twice.")

local function MC_USE_CARD(_, c, p, f, shouldDouble, isDouble, rng)
	local sfx = lootdeck.sfx
    local level = Game():GetLevel()

    helper.RunRandomFunction(rng, shouldDouble,
    function()
        sfx:Play(SoundEffect.SOUND_SUPERHOLY,1,0)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GROUND_GLOW, 0, p.Position, Vector.Zero, p)
        level:RemoveCurses(level:GetCurses())
    end,
    function()
        sfx:Play(SoundEffect.SOUND_HOLY,1,0)
        p:AddSoulHearts(2)
    end)
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
	Descriptions = Descriptions,
    HolographicDescriptions = HolographicDescriptions,
	WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
