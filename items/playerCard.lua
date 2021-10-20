-- Doubles the effect of loot cards
local Name = "Player Card"
local Tag = "playerCard"
local Id = Isaac.GetItemIdByName(Name)

local function ShouldRunDouble(p)
    return p:HasCollectible(Id)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    helpers = {
        ShouldRunDouble = ShouldRunDouble
    }
}
