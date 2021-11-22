local helper = include("helper_functions")
local costumes = include("costumes/registry")

local Names = {
    en_us = "V. The Hierophant",
    spa = "V. El Hierofante"
}
-- Gives two Holy Mantle effects for the room (negates damage twice with minimal cooldown)
local Name = Names.en_us
local Tag = "theHierophant"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Grants a {{Collectible313}} Holy Mantle effect that can absorb two hits",
    spa = "Otorga un efecto del {{Collectible313}} Manto Sagrado que puede absorber dos golpes"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants a unique Holy Mantle that can absorb two hits.", "Holographic Effect: The Holy Mantle can absorb three hits.")

local function MC_USE_CARD(_, c, p, f, shouldDouble)
    local data = p:GetData()
    data[Tag] = 2
    if shouldDouble then
        data[Tag] = data[Tag] + 1
    end
	p:AddNullCostume(costumes.mantle)
end

local function MC_ENTITY_TAKE_DMG(_, e, damageAmount, damageFlags, damageSource)
    local p = e:ToPlayer()
    local data = p:GetData()
    if data[Tag] then
        if helper.HolyMantleDamage(damageAmount, damageFlags, damageSource) then
            helper.HolyMantleEffect(p)
            data[Tag] = data[Tag] - 1
    		if data[Tag] == 1 then
                p:TryRemoveNullCostume(costumes.mantle)
    			p:AddNullCostume(costumes.mantleBroken)
    		end
            if data[Tag] <= 0 then
                p:TryRemoveNullCostume(costumes.mantleBroken)
                data[Tag] = nil
            end
            return false
        end
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
		},
        {
            ModCallbacks.MC_POST_UPDATE,
            MC_POST_UPDATE
		},
    }
}
