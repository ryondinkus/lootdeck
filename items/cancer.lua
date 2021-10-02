local helper = include("helper_functions")

-- Gives massive firerate increase on room entry, quickly decreases over time
local Name = "Cancer!"
local Tag = "cancer"
local Id = Isaac.GetItemIdByName(Name)

local originalFireDelayTag = string.format("%sOriginalFireDelay", Tag)
local finishedTag = string.format("%sFinished", Tag)
local roomClearedTag = string.format("%sRoomCleared", Tag)
local greedModeWaveTag = string.format("%sGreedModeWave", Tag)
local bossRushBossesTag = string.format("%sBossRushBosses", Tag)

local function Initialize(p)
    local game = Game()
    if helper.AreEnemiesInRoom(game:GetRoom()) then
        local data = p:GetData()
        if data[finishedTag] or data[finishedTag] == nil then
            data[originalFireDelayTag] = p.MaxFireDelay
        end
        data[Tag] = 0
        data[finishedTag] = false
        data[roomClearedTag] = nil
        if game:IsGreedMode() then
            data[greedModeWaveTag] = 0
        end
        p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        p:EvaluateItems()
    end
end

local function MC_POST_NEW_ROOM()
    local game = Game()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        if p:HasCollectible(Id) then
            local data = p:GetData()
            data[Tag] = nil
            data[finishedTag] = nil
            data[roomClearedTag] = not helper.AreEnemiesInRoom(game:GetRoom())
            p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            p:EvaluateItems()
            Initialize(p)
        end
    end
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    local data = p:GetData()
    local game = Game()
    if not data[roomClearedTag] and not helper.AreEnemiesInRoom(game:GetRoom()) then
        data[roomClearedTag] = true
    end

    local isFinished = (data[finishedTag] or data[finishedTag] == nil)
    local isBossRush = game:GetRoom():GetType() == RoomType.ROOM_BOSSRUSH

    local currentBosses = helper.ListBossesInRoom(p.Position)

    local shouldInitializeBecauseOfBossRush = true

    if isBossRush and (data[bossRushBossesTag] == nil or (data[bossRushBossesTag] and data[bossRushBossesTag] == 0)) and #currentBosses ~= 0 then
        for _, boss in pairs(currentBosses) do
            local bossData = boss:GetData()
            if bossData[Tag] == true then
                shouldInitializeBecauseOfBossRush = false
                break
            end
        end
    else
        shouldInitializeBecauseOfBossRush = false
    end

    if p:HasCollectible(Id) and ((not isBossRush and isFinished and (data[roomClearedTag] and helper.AreEnemiesInRoom(game:GetRoom()))) or (game:IsGreedMode() and data[greedModeWaveTag] ~= game:GetLevel().GreedModeWave) or (isBossRush and shouldInitializeBecauseOfBossRush)) then
        Initialize(p)
    end

    if game:IsGreedMode() then
        data[greedModeWaveTag] = game:GetLevel().GreedModeWave
    end

    if isBossRush then
        data[bossRushBossesTag] = #currentBosses
        for _, boss in pairs(currentBosses) do
            local bossData = boss:GetData()
            bossData[Tag] = true
        end
    end

    if data[Tag] then
        data[Tag] = data[Tag] + 1
        p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        p:EvaluateItems()
    end
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = p:GetData()
    if f == CacheFlag.CACHE_FIREDELAY then
        if data[Tag] then
            local newDelay = p.MaxFireDelay - 10 + (data[Tag]/(p.MaxFireDelay))
            if newDelay < data[originalFireDelayTag] then
                p.MaxFireDelay = newDelay
            else
                data[Tag] = nil
                data[finishedTag] = true
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
