-- Spawns a permacharmed void portal
local Name = "Gold Key"
local Tag = "goldKey"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    local enemy = Isaac.Spawn(EntityType.ENTITY_PORTAL, 0, 0, Game():GetRoom():FindFreePickupSpawnPosition(p.Position, 0, true), Vector.Zero, p)
    enemy:AddCharmed(EntityRef(p), -1)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
