local helper = include("helper_functions")

-- Gives the Holy Mantle effect for the room (negates damage once with minimal cooldown)
local Names = {
    en_us = "Soul Heart",
    spa = "Corazón de Alma"
}
local Name = Names.en_us
local Tag = "soulHeart"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 2
local Description = {
        en_us = "Grants a {{Collectible313}} Holy Mantle shield for the room, negating damage once",
        spa = "Otorga un escudo del {{Collectible313}} Mando Sagrado durante la habitación, negando el daño una vez"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a temporary Holy Mantle shield for the room. This shield negates the next instance of damage you take in the room.")

local function MC_USE_CARD(_, c, p)
    p:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
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
