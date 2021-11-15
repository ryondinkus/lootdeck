local helper = include("helper_functions")
local entityVariants = include("entityVariants/registry")

-- Drops 1-6 Mom's Fingers on random enemies in the room
local Names = {
    en_us = "II. The High Priestess",
    spa = "II. La Gran Sacerdotiza"
}
local Name = Names.en_us
local Tag = "theHighPriestess"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Drops 1-6 Mom's Fingers onto enemies, dealing 40 damage to each enemy hit",
    spa = "Suelta 1-6 dedos de Mamá en los enemigos, provocando 40 de daño a cada enemigo golpeado"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Drops 1-6 Mom's Fingers onto enemies, dealing 40 damage to each enemy hit.", "- The same enemy cannot be hit by multiple fingers.")

local function SpawnFinger(target)
    if target ~= 0 then
        local finger = Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.momsFinger.Id, 0, target.Position, Vector(0,0), target)
        local fingerData = finger:GetData()
        fingerData.target = target
    end
end

local function MC_USE_CARD(_, c, p)
	local data = p:GetData()

    if #helper.ListEnemiesInRoom(p.Position) > 0 then
        data[Tag] = 1
    else
        SpawnFinger(p)
    end
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    local rng = lootdeck.rng
	helper.StaggerSpawn(Tag, p, 15, rng:RandomInt(6) + 1, function(player)
		SpawnFinger(helper.FindRandomEnemy(player.Position))
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
