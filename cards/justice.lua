local helper = lootdeckHelpers
local entityVariants = include("entityVariants/registry")

-- Spawn a Justice Haunt that attacks a random enemy and confuses them, steals 4 pickups from them, then dies
local Names = {
    en_us = "VIII. Justice",
    spa = "VIII. Justicia"
}
local Name = Names.en_us
local Tag = "justice"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawn a Justice Haunt familiar, who will attack a random enemy, confusing them and stealing four consumables from them",
    spa = "Genera un pequeño familiar Haunt, que atacará a un enemigo, aplicándole confusión y robándole 4 recolectables"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a Justice Haunt familiar.", "- Justice Haunt will attack a random enemy, adding Confusion to them and dropping four random consumables.", "Holographic Effect: Spawns two Justice Haunts")

local function MC_USE_CARD(_, c, p)
    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.justiceHaunt.Id, 0, p.Position, Vector.Zero, p)
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id,
            true
        }
    }
}
