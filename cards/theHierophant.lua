local helper = include("helper_functions")
local costumes = include("costumes/registry")

-- Gives two Holy Mantle effects for the room (negates damage twice with minimal cooldown)
local Names = {
    en_us = "V. The Hierophant",
    spa = "V. EL Hierofante"
}
local Name = Names.en_us
local Tag = "theHierophant"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Grants a {{Collectible313}} Holy Mantle effect that can absorb two hits for the room",
    spa = "Otorga el efecto del {{Collectible313}} Manto Sagrado"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants a unique Holy Mantle that can absorb two hits for the duration of the room.")

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
    helper.ForEachPlayer(function(p, data)
        data[Tag] = nil
		p:TryRemoveNullCostume(costumes.mantle)
		p:TryRemoveNullCostume(costumes.mantleBroken)
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
