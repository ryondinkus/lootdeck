local helper = include("helper_functions")

-- Gives massive firerate increase on room entry, quickly decreases over time
local Name = "Cancer!"
local Tag = "cancer"
local Id = Isaac.GetItemIdByName(Name)

local function Initialize(p)
    if helper.AreEnemiesInRoom(Game():GetRoom()) then
        local data = p:GetData()
        data.originalFireDelay = p.MaxFireDelay
        data.cancer = 0
        data.finishedCancer = false
        data.roomCleared = nil
        p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        p:EvaluateItems()
    end
end

local function MC_POST_NEW_ROOM()
    local game = Game()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        if p:HasCollectible(Id) then
            Initialize(p)
        end
    end
end

-- TODO check when a wave in greed mode starts
local function MC_POST_PEFFECT_UPDATE(_, p)
    local data = p:GetData()
    if not data.roomCleared and not helper.AreEnemiesInRoom(Game():GetRoom()) then
        data.roomCleared = true
    end
    if p:HasCollectible(Id) and (data.finishedCancer or data.finishedCancer == nil) and data.roomCleared and helper.AreEnemiesInRoom(Game():GetRoom()) then
        print("I'm shitting my panties rn lol")
        Initialize(p)
    end
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
                p.MaxFireDelay = newDelay
            else
                data.cancer = nil
                data.finishedCancer = true
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
    },
    helpers = {
        Initialize = Initialize
    }
}
