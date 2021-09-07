local helper = include("helper_functions")

-- Gives the Holy Mantle effect for the room (negates damage once with minimal cooldown)
local Name = "Soul Heart"
local Tag = "soulHeart"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    data[Tag] = 1
end

local function MC_ENTITY_TAKE_DMG(_, e)
    local p = e:ToPlayer()
    local data = p:GetData()
    if data[Tag] then
        helper.HolyMantleEffect(p)
        data[Tag] = nil
        return false
    end
end

local function MC_POST_NEW_ROOM()
    for i=0,Game():GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
        data[Tag] = nil
    end
end

local function MC_POST_NEW_LEVEL()
    for i=0,Game():GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
        data[Tag] = nil
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
        },
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    }
}