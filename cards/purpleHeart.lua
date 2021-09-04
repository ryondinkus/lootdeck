
local helper = include("helper_functions")
local items = include("items/registry")

local Name = "Purple Heart"
local Tag = "purpleHeart"
local Id = Isaac.GetCardIdByName(Name)

-- BUG: Our standard helper.findRandomEnemy(_, noDupes) doesn't work here since rerolled enemies don't preserve their data tables
-- can't really think of a good way to track rerolled enemies right now
local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.purpleHeart, SoundEffect.SOUND_VAMP_GULP)
end

local function MC_POST_NEW_ROOM()
    local game = Game()
    local room = game:GetRoom()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        if p:HasCollectible(items.purpleHeart) and not room:IsClear() then
            for y=1,p:GetCollectibleNum(items.purpleHeart) do
                lootdeck.f.rerollEnemy = lootdeck.f.rerollEnemy + 1
                if room:GetType() ~= RoomType.ROOM_BOSS then
                    lootdeck.f.spawnExtraReward = lootdeck.f.spawnExtraReward + 1
                end
            end
        end
    end
end

local function MC_POST_UPDATE(_, e)
    local game = Game()
    local room = game:GetRoom()
    if lootdeck.f.rerollEnemy > 0 then
        local p = Isaac.GetPlayer(0)
        for i=1,lootdeck.f.rerollEnemy do
            local target = helper.findRandomEnemy(p.Position, false) or 0
            if target ~= 0 then
                game:RerollEnemy(target)
            end
        end
        lootdeck.f.rerollEnemy = 0
    end
    if lootdeck.f.spawnExtraReward > 0 and room:GetAliveEnemiesCount() == 0 then
        for i=1,lootdeck.f.spawnExtraReward do
    		room:SpawnClearAward()
        end
        lootdeck.f.spawnExtraReward = 0
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
        },
        {
            ModCallbacks.MC_POST_UPDATE,
            MC_POST_UPDATE
        }
    }
}