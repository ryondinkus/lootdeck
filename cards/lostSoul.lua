local entityVariants = include("entityVariants/registry")

local Name = "Lost Soul"
local Tag = "lostSoul"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

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
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
