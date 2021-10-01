local entityVariants = include("entityVariants/registry")

-- Spawn a coin, bomb, or key for every enemy in the room
local Name = "VIII. Justice"
local Tag = "justice"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

-- TODO: completely rework the bitch
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
