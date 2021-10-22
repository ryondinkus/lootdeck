local helper = include("helper_functions")

-- Spawns a permacharmed void portal
local Name = "Gold Key"
local Tag = "goldKey"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Spawns a permanently charmed Portal enemy, who spawns other permanently charmed enemies until disappearing"
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a permanently charmed Portal enemy. Portal will spawn other permanently charmed enemies until it disappears.")

local function MC_USE_CARD(_, c, p)
    local enemy = Isaac.Spawn(EntityType.ENTITY_PORTAL, 0, 0, Game():GetRoom():FindFreePickupSpawnPosition(p.Position, 0, true), Vector.Zero, p)
    enemy:AddCharmed(EntityRef(p), -1)
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
