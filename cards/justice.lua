local entityVariants = include("entityVariants/registry")

-- Spawn a Justice Haunt that attacks a random enemy and confuses them, steals 4 pickups from them, then dies
local Name = "VIII. Justice"
local Tag = "justice"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.justiceHaunt.Id, 0, p.Position, Vector.Zero, p)
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
