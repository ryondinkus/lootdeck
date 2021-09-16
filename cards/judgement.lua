local helper = include("helper_functions")

-- Spawns 1-3 of a pickup determined by the Glyph of Balance algorithm
local Name = "XX. Judgement"
local Tag = "judgement"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    local reward = helper.GlyphOfBalance(p)
    local room = Game():GetRoom()
    for i=0,lootdeck.rng:RandomInt(3) do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, reward[1], reward[2], room:FindFreePickupSpawnPosition(p.Position), Vector.Zero, nil)
    end
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