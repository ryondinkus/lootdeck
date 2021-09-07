local helper = include("helper_functions")

-- A 1 in 6 chance of negating damage with the Holy Mantle effect
local Name = "Guppy's Hairball"
local Tag = "guppysHairball"
local Id = Isaac.GetItemIdByName(Name)

local function MC_ENTITY_TAKE_DMG(_, e)
    local p = e:ToPlayer()
    if p:HasCollectible(Id) then
        local effectNum = p:GetCollectibleNum(Id)
        local effect = lootdeck.rng:RandomInt(6)
        local threshold = 0
        if effectNum > 0 then threshold = 1 end
        threshold = threshold + (effectNum - 1)
        if threshold > 2 then threshold = 2 end
        if effect <= threshold then
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