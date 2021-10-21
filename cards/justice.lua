local entityVariants = include("entityVariants/registry")

-- Spawn a Justice Haunt that attacks a random enemy and confuses them, steals 4 pickups from them, then dies
local Name = "VIII. Justice"
local Tag = "justice"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Spawn a Justice Haunt familiar, who will attack a random enemy, confusing them and stealing four consumables from them"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
                            {str = "Spawns a Justice Haunt familiar."},
                            {str = "- Justice Haunt will attack a random enemy, adding Confusion to them and dropping four random consumables."},
						}}

local function MC_USE_CARD(_, c, p)
    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.justiceHaunt.Id, 0, p.Position, Vector.Zero, p)
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
