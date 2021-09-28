-- Gives massive firerate increase on room entry, quickly decreases over time
local Name = "Cancer"
local Tag = "cancer"
local Id = Isaac.GetItemIdByName(Name)

local function MC_POST_NEW_ROOM()
    local game = Game()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        local data = p:GetData()
        if p:HasCollectible(Id) then
            data.cancer = 0
            data.originalFireDelay = p.MaxFireDelay
            p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            p:EvaluateItems()
        end
    end
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    local data = p:GetData()
    if data.cancer then
        data.cancer = data.cancer + 1
        p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        p:EvaluateItems()
    end
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = p:GetData()
    if f == CacheFlag.CACHE_FIREDELAY then
        if data.cancer then
            local newDelay = p.MaxFireDelay - 10 + (data.cancer/(p.MaxFireDelay))
            if newDelay < data.originalFireDelay then
                -- print(p.MaxFireDelay)
                -- print(data.originalFireDelay)
                p.MaxFireDelay = newDelay
            else
                data.cancer = nil
            end
        end
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
        {
            ModCallbacks.MC_POST_PEFFECT_UPDATE,
            MC_POST_PEFFECT_UPDATE
        },
        {
            ModCallbacks.MC_EVALUATE_CACHE,
            MC_EVALUATE_CACHE
        }
    }
}
