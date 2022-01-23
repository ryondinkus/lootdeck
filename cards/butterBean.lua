local helper = LootDeckAPI

-- Farts
local Names = {
    en_us = "Butter Bean!",
    spa = "Frijol de Mantquilla"
}
local Name = Names.en_us
local Tag = "butterBean"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 2
local Descriptions = {
    en_us = "Creates a {{Collectible294}} Butter Bean fart, which knocks back enemies.",
    spa = "Crea un pedo de {{Collectible294}} frijol de mantequilla, puede empujar a los enemigos"
}
local HolographicDescriptions = {
    en_us = "Creates {{ColorRainbow}}2{{CR}} {{Collectible294}} Butter Bean farts, which knock back enemies.",
    spa = "Crea {{ColorRainbow}}2{{CR}} pedos de {{Collectible294}} frijol de mantequilla, puede empujar a los enemigos"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Does a Butter Bean fart on use, which knocks back enemies and deals damage if they hit walls.", "Holographic Effect: Creates two Butter Bean farts in quick succession.")

local function MC_USE_CARD(_, c, p)
	helper.UseItemEffect(p, CollectibleType.COLLECTIBLE_BUTTER_BEAN)
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
            Id,
            true,
			0.5
        }
    },
    Tests = function()
        return {
            {
                action = "RESTART",
                id = 0
            },
            {
                action = "GIVE_CARD",
                id = Id
            },
            {
                action = "USE_CARD"
            }
        }
    end
}
