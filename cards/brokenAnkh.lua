
local helper = include("helper_functions")
local items = include("items/registry")

local Name = "Broken Ankh"
local Tag = "brokenAnkh"
local Id = Isaac.GetCardIdByName(Name)

-- BUG: When you revive, your streak is still lost, and saving/continuing is disabled. this is because Revive() is bugged and the game still thinks you're dead
-- due to how poorly extra lives are supported in the API, this is probably the best we're getting without massive overcomplications
local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.brokenAnkh, SoundEffect.SOUND_VAMP_GULP)
end

local function MC_POST_PLAYER_UPDATE(_, p)
    local game = Game()
    local data = p:GetData()
    local sprite = p:GetSprite()
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    if ( sprite:IsPlaying("Death") and sprite:GetFrame() >= 55) or (sprite:IsPlaying("LostDeath") and sprite:GetFrame() >= 37) or (sprite:IsPlaying("ForgottenDeath") and sprite:GetFrame() >= 19) then
        if p:HasCollectible(Id) then
            local effectNum = p:GetCollectibleNum(Id)
            local effect = 0--rng:RandomInt(6)
            local threshold = 0
            if effectNum > 0 then threshold = 1 end
            threshold = threshold + (effectNum - 1)
            if threshold > 2 then threshold = 2 end
            if effect <= threshold then
                if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                    p:AddBoneHearts(1)
                end
                p:Revive()
                if p:GetOtherTwin() then p:GetOtherTwin():Revive() end
                data.reviveAnkh = true
                local enterDoor = level.EnterDoor
                local door = room:GetDoor(enterDoor)
                local direction = door and door.Direction or Direction.NO_DIRECTION
                game:StartRoomTransition(level:GetPreviousRoomIndex(),direction,0)
                level.LeaveDoor = enterDoor
            end
        end
    end
end

local function MC_POST_NEW_ROOM()
    local game = Game()
    local sfx = lootdeck.sfx
    for i=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
        if data.reviveAnkh then
            if p:GetPlayerType() == PlayerType.PLAYER_KEEPER or p:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
                p:AddHearts(-1)
                p:AddHearts(1)
            end
            if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                while p:GetBoneHearts() > 1 do
                    p:AddBoneHearts(-1)
                end
            end
            p:AnimateCard(Id)
            sfx:Play(SoundEffect.SOUND_HOLY,1,0)
            data.reviveAnkh = nil
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
            ModCallbacks.MC_POST_PLAYER_UPDATE,
            MC_POST_PLAYER_UPDATE,
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}