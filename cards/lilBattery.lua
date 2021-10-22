local helper = include('helper_functions')

-- Spawns a little battery
local Name = "Lil Battery"
local Tag = "lilBattery"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 5
local Description = "Spawns a Lil' Battery"
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a Lil' Battery on use.")

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardSpawn(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_NORMAL)
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
