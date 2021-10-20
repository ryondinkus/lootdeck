local helper = include("helper_functions")

-- Spawns a lootcard
local Name = "Loot Deck"
local Tag = "lootDeck"
local Id = Isaac.GetItemIdByName(Name)

local function MC_USE_ITEM(_, type, rng, p)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, helper.GetWeightedLootCardId(), Game():GetRoom():FindFreePickupSpawnPosition(p.Position), Vector.Zero, nil)
    return true
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_USE_ITEM,
            MC_USE_ITEM,
            Id
        }
    }
}
