local helper = include('helper_functions')
local entityVariants = include("entityVariants/registry")

-- Spawns a mega battery
local Name = "Holy Card"
local Tag = "holyCard"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardSpawn(p, EntityType.ENTITY_FAMILIAR, entityVariants.holyShield.Id, 0, 15, p.Position, SoundEffect.SOUND_SUPERHOLY)
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
