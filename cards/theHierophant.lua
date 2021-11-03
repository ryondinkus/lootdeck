local helper = include("helper_functions")
local costumes = include("costumes/registry")

-- Gives two Holy Mantle effects for the room (negates damage twice with minimal cooldown)
local Name = "V. The Hierophant"
local Tag = "theHierophant"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Grants a {{Collectible313}} Holy Mantle effect that can absorb two hits for the room"
local WikiDescription = helper.GenerateEncyclopediaPage("Grants a unique Holy Mantle that can absorb two hits for the duration of the room.")

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    data[Tag] = 2
	p:AddNullCostume(costumes.mantle)
end

local function MC_ENTITY_TAKE_DMG(_, e, damageAmount, damageFlags, damageSource)
    local p = e:ToPlayer()
    local data = p:GetData()
    print(damageSource.Type)
    if data[Tag] and data[Tag] > 0 then
        if helper.HolyMantleDamage(damageAmount, damageFlags, damageSource) then
            helper.HolyMantleEffect(p)
            data[Tag] = data[Tag] - 1
    		p:TryRemoveNullCostume(costumes.mantle)
    		p:TryRemoveNullCostume(costumes.mantleBroken)
    		if data[Tag] == 1 then
    			p:AddNullCostume(costumes.mantleBroken)
    		end
            return false
        end
    else
        data[Tag] = nil
    end
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data[Tag] then
            data[Tag .. "KeepCostume"] = true
        end
    end)
end

local function MC_POST_UPDATE()
    helper.ForEachPlayer(function(p, data)
        if data[Tag .. "KeepCostume"] then
            if data[Tag] == 2 then
                p:AddNullCostume(costumes.mantle)
            elseif data[Tag] == 1 then
                p:AddNullCostume(costumes.mantleBroken)
            end
            data[Tag .. "KeepCostume"] = false
        end
    end)
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
            ModCallbacks.MC_POST_UPDATE,
            MC_POST_UPDATE
		},
    }
}
