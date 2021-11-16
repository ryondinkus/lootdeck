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
local Description = {
    en_us = "Grants a {{Collectible313}} Holy Mantle effect that can absorb two hits",
    spa = "Otorga un efecto del {{Collectible313}} Manto Sagrado que puede absorber dos golpes"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants a unique Holy Mantle that can absorb two hits.")

local function MC_USE_CARD(_, c, p, f, shouldDouble)
    local data = p:GetData()
    data[Tag] = 2
    if shouldDouble then
        data[Tag] = data[Tag] + 1
    end
    p:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, false)
	p:AddNullCostume(costumes.mantle)
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data[Tag] then
            p:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, false)
            data[Tag .. "KeepCostume"] = true
        end
    end)
end

local function MC_POST_UPDATE()
    helper.ForEachPlayer(function(p, data)
        local data = p:GetData()
        local effects = p:GetEffects()
        if data[Tag] and not effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
            data[Tag] = data[Tag] - 1
    		if data[Tag] == 1 then
                p:TryRemoveNullCostume(costumes.mantle)
    			p:AddNullCostume(costumes.mantleBroken)
    		end
            if data[Tag] <= 0 then
                p:TryRemoveNullCostume(costumes.mantleBroken)
                data[Tag] = nil
            else
                effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, false)
            end
        end
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
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
		},
        {
            ModCallbacks.MC_POST_UPDATE,
            MC_POST_UPDATE
		},
    }
}
