local helper = include("helper_functions")

-- Increases lootcard drop percentage by 10% for each trinket held
local Name = "Card Sleeve"
local Tag = "cardSleeve"
local Id = Isaac.GetTrinketIdByName(Name)
local Description = "+10% chance to replace a card spawn with a Loot Card"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "+10% chance to replace a card spawn with a Loot Card."},
                            {str = "- Additional trinket copies grant an extra +10%, up to 100%."},
						}}

local function CalculateLootcardPercentage()
    local totalPercentage = 0
    helper.ForEachPlayer(function(p)
        totalPercentage = totalPercentage + (p:GetTrinketMultiplier(Id) * 10)
    end)

    return totalPercentage
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Description = Description,
    WikiDescription = WikiDescription,
    helpers = {
        CalculateLootcardPercentage = CalculateLootcardPercentage
    }
}
