local helper = LootDeckAPI

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
local HolographicDescriptions = {
    en_us = "Spawns {{ColorRainbow}}10-20{{CR}} Shopkeepers",
    spa = "Genera {{ColorRainbow}}10-20{{CR}} cuidadores de tiendas"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns 5-10 Shopkeepers in the current room.", "Holographic Effect: Spawns twice as many shopkeepers, two at at time.")

local function MC_USE_CARD(_, c, p, f, shouldDouble)
    local data = p:GetData().lootdeck
	data[Tag] = 1
    if shouldDouble then
        data[Tag] = data[Tag] + 1
    end
end

local function MC_POST_NEW_ROOM()
    LootDeckAPI.ForEachPlayer(function(player)
        helper.StopStaggerSpawn(player, Tag)
    end)
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    if p:GetData().lootdeck[Tag] then
        local rng = p:GetCardRNG(Id)
    	helper.StaggerSpawn(Tag, p, 7, (rng:RandomInt(6) + 5) * (p:GetData().lootdeck[Tag] or 0), function()
    		local room = Game():GetRoom()
    		local spawnPos = room:GetRandomPosition(0)
    		Isaac.Spawn(EntityType.ENTITY_SHOPKEEPER, 0, 0, spawnPos, Vector.Zero, nil)
    		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, nil)
    	end)
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
    HolographicDescriptions = HolographicDescriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
            {
                ModCallbacks.MC_USE_CARD,
                MC_USE_CARD,
                Id
            },
            {
                ModCallbacks.MC_POST_NEW_ROOM,
                MC_POST_NEW_ROOM
            },
            {
                ModCallbacks.MC_POST_PEFFECT_UPDATE,
                MC_POST_PEFFECT_UPDATE
            }
    }
}
