local helper = include("helper_functions")

local Name = "XX. Judgement"
local Tag = "judgement"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
    local reward = helper.glyphOfBalance(p)
    local room = Game():GetRoom()
    for i=0,lootdeck.rng:RandomInt(3) do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, reward[1], reward[2], room:FindFreePickupSpawnPosition(p.Position), Vector.Zero, nil)
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}