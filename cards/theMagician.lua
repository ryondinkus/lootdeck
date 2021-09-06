local helper = include("helper_functions")

-- Temporary tears up and brain worm effect for the room, as well as a brain costume
local Name = "I. The Magician"
local Tag = "theMagician"
local Id = Isaac.GetCardIdByName(Name)

-- If it ever gets fixed, AddTrinketEffect() would be better here
local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    if not data.magician then data.magician = 1
    else data.magician = data.magician + 1 end
    local itemConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_MIND)
    if not p:HasCollectible(CollectibleType.COLLECTIBLE_MIND) then
        p:AddCostume(itemConfig, true)
    end
    p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARCOLOR)
    p:EvaluateItems()
end

local function MC_POST_FIRE_TEAR(_, t)
    local p = t:GetLastParent():ToPlayer()
    local data = p:GetData()
    if data.magician then
        t:AddTearFlags(helper.NewTearflag(71)) -- brain worm effect
    end
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = p:GetData()
    if f == CacheFlag.CACHE_FIREDELAY then
        if data.magician then
            p.MaxFireDelay = p.MaxFireDelay - (data.magician)
        end
    end
    if f == CacheFlag.CACHE_TEARCOLOR then
        if data.magician then
            local color = Color(1,1,1,1,0,0,0)
            color:SetColorize(1,1,1,1)
            p.TearColor = color
        end
        if data.empress then
            local color = Color(1,1,1,1,0,0,0)
            color:SetColorize(0.8,0,0,1)
            p.TearColor = color
        end
    end
end

local function MC_POST_NEW_ROOM()
    for i=0,Game():GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
        if data.magician then
            data.magician = nil
            p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARCOLOR)
            p:EvaluateItems()
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
            ModCallbacks.MC_POST_FIRE_TEAR,
            MC_POST_FIRE_TEAR
        },
        {
            ModCallbacks.MC_EVALUATE_CACHE,
            MC_EVALUATE_CACHE
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}