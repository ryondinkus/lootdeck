local helper = include("helper_functions")

-- A 1 in 6 chance of negating damage with the Holy Mantle effect
local Names = {
    en_us = "Guppy's Hairball",
    spa = "Bola de Pelo de Guppy"
}
local Name = Names.en_us
local Tag = "guppysHairball"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "Every instance of damage taken has a 1/6 chance to be blocked",
    spa = "Cada vez que se reciba daño, hay una posibilidad de 1/6 de bloquearlo"
}
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
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        }
    }
}
