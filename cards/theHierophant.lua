local helper = include("helper_functions")
local costumes = include("costumes/registry")

-- Gives two Holy Mantle effects for the room (negates damage twice with minimal cooldown)
local Name = "V. The Hierophant"
local Tag = "theHierophant"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    data[Tag] = 2
	p:AddNullCostume(costumes.mantle)
end

local function MC_ENTITY_TAKE_DMG(_, e)
    local p = e:ToPlayer()
    local data = p:GetData()
    if data[Tag] and data[Tag] > 0 then
        helper.HolyMantleEffect(p)
        data[Tag] = data[Tag] - 1
		p:TryRemoveNullCostume(costumes.mantle)
		p:TryRemoveNullCostume(costumes.mantleBroken)
		if data[Tag] == 1 then
			p:AddNullCostume(costumes.mantleBroken)
		end
        return false
    else
        data[Tag] = nil
    end
end

local function MC_POST_NEW_ROOM()
    for i=0,Game():GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
        data[Tag] = nil
		p:TryRemoveNullCostume(costumes.mantle)
		p:TryRemoveNullCostume(costumes.mantleBroken)
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
		}
    }
}
