local helper = include("helper_functions")
local costumes = include("costumes/registry")

-- Gives the Holy Mantle effect for the room (negates damage once with minimal cooldown)
local Name = "Soul Heart"
local Tag = "soulHeart"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 3

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
    Tag = Tag,
	Id = Id,
    Weight = Weight,
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
