local helper = include("helper_functions")
local costumes = include("costumes/registry")

-- Gives the Holy Mantle effect for the room (negates damage once with minimal cooldown)
local Names = {
    en_us = "Soul Heart",
    spa = "Corazón de Alma"
}
local Name = Names.en_us
local Tag = "soulHeart"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 3
local Descriptions = {
    en_us = "Grants a {{Collectible313}} Holy Mantle shield for the room, negating damage once.",
    spa = "Otorga un escudo del {{Collectible313}} Mando Sagrado durante la habitación, negando el daño una vez"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a temporary Holy Mantle shield for the room. This shield negates the next instance of damage you take in the room.")

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    data[Tag] = 1
	p:AddNullCostume(costumes.mantle)
end

local function MC_ENTITY_TAKE_DMG(_, e)
    local p = e:ToPlayer()
    local data = p:GetData()
    if data[Tag] then
		p:TryRemoveNullCostume(costumes.mantle)
        helper.HolyMantleEffect(p)
        data[Tag] = nil
        return false
    end
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p)
        local data = p:GetData()
		p:TryRemoveNullCostume(costumes.mantle)
        data[Tag] = nil
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
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
		}
    }
}
