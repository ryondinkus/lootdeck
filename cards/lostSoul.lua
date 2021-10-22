local helper = include("helper_functions")

local entityVariants = include("entityVariants/registry")

local Name = "Lost Soul"
local Tag = "lostSoul"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Spawns a Lost Soul familiar, who will discover Tinted Rocks and Secret Rooms and blow them up# If used while a Lost Soul already exists, it will spawn a Found Soul instead. The two souls will fall in love, spawn a Red Heart, and fly away."
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a Lost Soul familiar, who will discover Tinted Rocks and Secret Rooms and blow them up.", "- Lost Soul will prioritize Secret Rooms over Tinted Rocks.", "If used while a Lost Soul familiar already exists, it will instead spawn a Found Soul in the center of the room. The two souls will fall in love and fly away, spawning one Red Heart.")

local function MC_USE_CARD(_, c, p)
    local room = Game():GetRoom()
    local f = lootdeck.f
    if not f.lostSoul then
        local soul = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.lostSoulBaby.Id, 0, p.Position, Vector.Zero, p)
        f.lostSoul = true
    else
        local soul = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.lostSoulLove.Id, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, p)
        f.lostSoul = false
    end
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
