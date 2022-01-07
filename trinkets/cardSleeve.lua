local helper = LootDeckAPI

-- Increases lootcard drop percentage by 10% for each trinket held
local Names = {
    en_us = "Card Sleeve",
    spa = "Funda de Tarjeta"
}
local Name = Names.en_us
local Tag = "cardSleeve"
local Id = Isaac.GetTrinketIdByName(Name)
local Descriptions = {
    en_us = "+10% chance to replace a card spawn with a Loot Card",
    spa = "+10% de posibilidad de reemplazar una carta regular con una carta de Loot"
}
local WikiDescription = helper.GenerateEncyclopediaPage("+10% chance to replace a card spawn with a Loot Card.", "- Additional trinket copies grant an extra +10%, up to 100%.")

local function CalculateLootcardPercentage()
    local totalPercentage = 0
    helper.ForEachPlayer(function(p)
        totalPercentage = totalPercentage + (p:GetTrinketMultiplier(Id) * 10)
    end)

    return totalPercentage
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    helpers = {
        CalculateLootcardPercentage = CalculateLootcardPercentage
    }
}
