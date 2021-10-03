local helper = include("helper_functions")

-- A 1 in 6 chance of negating damage with the Holy Mantle effect
local Name = "Guppy's Hairball"
local Tag = "guppysHairball"
local Id = Isaac.GetItemIdByName(Name)

local function MC_ENTITY_TAKE_DMG(_, e)
    local p = e:ToPlayer()
    if p:HasCollectible(Id) then
        if helper.PercentageChance(100 / 6 * p:GetCollectibleNum(Id), 50) then
            helper.HolyMantleEffect(p)
            return false
        end
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        }
    }
}