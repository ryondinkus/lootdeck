-- Doubles the effect of loot cards
local Name = "Player Card"
local Tag = "playerCard"
local Id = Isaac.GetItemIdByName(Name)
local Description = "{{Card}} Spawns a Loot Card on pickup# All Loot Card effects are doubled, similar to {{Collectible451}} Tarot Cloth"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "Spawns a Loot Card."},
                            {str = "All Loot Card effects are now doubled, similar to the effect of Tarot Cloth."},
						}}

local function ShouldRunDouble(p)
    return p:HasCollectible(Id)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Description = Description,
    WikiDescription = WikiDescription,
    helpers = {
        ShouldRunDouble = ShouldRunDouble
    }
}
