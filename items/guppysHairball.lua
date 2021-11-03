local helper = include("helper_functions")

-- A 1 in 6 chance of negating damage with the Holy Mantle effect
local Name = "Guppy's Hairball"
local Tag = "guppysHairball"
local Id = Isaac.GetItemIdByName(Name)
local Description = "Every instance of damage taken has a 1/6 chance to be blocked"
local WikiDescription = helper.GenerateEncyclopediaPage("Every instance of damage taken has a 1/6 chance to be blocked.", "- Additional copies of the passive add an extra 1/6 chance, up to 3/6.")

local function MC_ENTITY_TAKE_DMG(_, e, damageAmount, damageFlags, damageSource)
    local p = e:ToPlayer()
    if p:HasCollectible(Id) then
        if helper.PercentageChance(100 / 6 * p:GetCollectibleNum(Id), 50) then
            if helper.HolyMantleDamage(damageAmount, damageFlags, damageSource) then
                helper.HolyMantleEffect(p)
                return false
            end
        end
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        }
    }
}
