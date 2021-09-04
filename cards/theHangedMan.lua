local Name = "XII. The Hanged Man"
local Tag = "theHangedMan"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    local magnetoConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_MAGNETO)
    local soulConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_SOUL)
    p:AddCollectible(CollectibleType.COLLECTIBLE_MAGNETO)
    if not data.hangedMan then data.hangedMan = 1
    else data.hangedMan = data.hangedMan + 1 end
    if data.hangedMan >= p:GetCollectibleNum(CollectibleType.COLLECTIBLE_MAGNETO) then
        p:RemoveCostume(magnetoConfig)
    end
    if not p:HasCollectible(CollectibleType.COLLECTIBLE_SOUL) then
        p:AddCostume(soulConfig, true)
    end
end

local function MC_POST_NEW_ROOM()
    for i=0,Game():GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
        if data.hangedMan then
            for j=1,data.hangedMan do
                p:RemoveCollectible(CollectibleType.COLLECTIBLE_MAGNETO)
            end
            data.hangedMan = nil
        end
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
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}