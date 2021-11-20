local helper = include("helper_functions")
local costumes = include("costumes/registry")

-- Gives magneto effect for the room and a glowing costume
local Names = {
    en_us = "XII. The Hanged Man",
    spa = "XII. El Colgado"
}
local Name = Names.en_us
local Tag = "theHangedMan"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Grants the {{Collectible53}} Magneto effect for the room, causing pickups to be drawn towards you",
    spa = "Otorga el efecto del {{Collectible53}} Imán durante la habitación"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants the Magneto effect for the room, which causes pickups to be drawn toward your position.")

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    local magnetoConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_MAGNETO)
    p:AddCollectible(CollectibleType.COLLECTIBLE_MAGNETO, 0, false)
    if not data.hangedMan then data.hangedMan = 1
    else data.hangedMan = data.hangedMan + 1 end
    if data.hangedMan >= p:GetCollectibleNum(CollectibleType.COLLECTIBLE_MAGNETO) then
        p:RemoveCostume(magnetoConfig)
    end
	p:AddNullCostume(costumes.hangedMan)
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data.hangedMan then
            for j=1,data.hangedMan do
				p:RemoveCollectible(CollectibleType.COLLECTIBLE_MAGNETO)
            end
			p:TryRemoveNullCostume(costumes.hangedMan)
            data.hangedMan = nil
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
            Id,
            true
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}
