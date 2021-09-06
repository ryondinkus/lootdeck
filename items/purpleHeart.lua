local helper = include("helper_functions")

-- Rerolls an enemy in a room and drops an extra reward per room
local Name = "Purple Heart"
local Tag = "purpleHeart"
local Id = Isaac.GetItemIdByName(Name)

local function MC_POST_NEW_ROOM()
    local game = Game()
    local room = game:GetRoom()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        if p:HasCollectible(Id) and not room:IsClear() then
            for y=1,p:GetCollectibleNum(Id) do
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
            local target = helper.FindRandomEnemy(p.Position, false) or 0
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
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
        {
            ModCallbacks.MC_POST_UPDATE,
            MC_POST_UPDATE
        }
    }
}