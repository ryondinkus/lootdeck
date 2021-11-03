local helper = include('helper_functions')

-- Spawns 5-10 shopkeepers around the room
local Names = {
    en_us = "XVIII. The Moon",
    spa = "XVIII. La Luna"
}
local Name = Names.en_us
local Tag = "theMoon"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawns 5-10 Shopkeepers",
    spa = "Genera 5-10 cuidadores de tiendas"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns 5-10 Shopkeepers in the current room.")

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
	data[Tag] = 1
end

local function MC_POST_PEFFECT_UPDATE(_, p)
	helper.StaggerSpawn(Tag, p, 7, lootdeck.rng:RandomInt(6)+5, function()
		local room = Game():GetRoom()
		local spawnPos = room:GetRandomPosition(0)
		Isaac.Spawn(EntityType.ENTITY_SHOPKEEPER, 0, 0, spawnPos, Vector.Zero, nil)
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, nil)
	end)
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
                Id
            },
            {
                ModCallbacks.MC_POST_PEFFECT_UPDATE,
                MC_POST_PEFFECT_UPDATE
            }
    }
}
