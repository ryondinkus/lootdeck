local helper = include('helper_functions')

-- Farts
local Names = {
    en_us = "Butter Bean!",
    spa = "Frijol de Mantquilla"
}
local Name = Names.en_us
local Tag = "butterBean"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 4
local Descriptions = {
    en_us = "Creates a {{Collectible294}} Butter Bean fart, which knocks back enemies.",
    spa = "Crea un pedo de {{Collectible294}} frijol de mantequilla, puede empujar a los enemigos"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Does a Butter Bean fart on use, which knocks back enemies and deals damage if they hit walls.")

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_BUTTER_BEAN)
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
