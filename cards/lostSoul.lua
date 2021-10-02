local entityVariants = include("entityVariants/registry")

local Name = "Lost Soul"
local Tag = "lostSoul"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

-- TODO: Implement
local function MC_USE_CARD(_, c, p)
    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.lostSoulBaby.Id, 0, p.Position, Vector.Zero, p)
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
