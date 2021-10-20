local helper = include("helper_functions")

-- Increases lootcard drop percentage by 10% for each trinket held
local Name = "Card Sleeve"
local Tag = "cardSleeve"
local Id = Isaac.GetTrinketIdByName(Name)
local Description = "me me me twinket"

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
    helpers = {
        CalculateLootcardPercentage = CalculateLootcardPercentage
    }
}
