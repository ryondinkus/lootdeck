local Name = "XIII. Death"
local Tag = "death"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    if not data.death then data.death = true end
    Game():ShakeScreen(15)
    lootdeck.sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 0)
    p:Die()
end

local function MC_POST_NEW_ROOM()
    for i=0,Game():GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
        if data.reviveDeath then
            p:AddMaxHearts(-24)
            p:AddSoulHearts(-24)
            p:AddBoneHearts(-12)
            p:AddBoneHearts(3)
            if p:GetOtherTwin() then
                p:GetOtherTwin():AddMaxHearts(-24)
                p:GetOtherTwin():AddSoulHearts(-24)
                p:GetOtherTwin():AddBoneHearts(-12)
                p:GetOtherTwin():AddBoneHearts(3)
            end
            if p:GetPlayerType() == PlayerType.PLAYER_KEEPER or p:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
                p:AddMaxHearts(2, false)
                p:AddHearts(2)
            end
            if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN or p:GetPlayerType() == PlayerType.PLAYER_THESOUL then
                while p:GetBoneHearts() > 3 do
                    p:AddBoneHearts(-1)
                end
                p:AddSoulHearts(1)
            end
            p:AnimateCard(Id)
            lootdeck.sfx:Play(SoundEffect.SOUND_UNHOLY,1,0)
            data.death = nil
            data.reviveDeath = nil
        end
    end
end

-- TODO: add visual/audio indicators
-- keeper should revive with one coin heart and the flies of 3 bone hearts
local function MC_POST_PLAYER_UPDATE(_, p)
    local game = Game()
    local room = game:GetRoom()
    local data = p:GetData()
    local sprite = p:GetSprite()
    local level = game:GetLevel()
    if ( sprite:IsPlaying("Death") and sprite:GetFrame() >= 55) or (sprite:IsPlaying("LostDeath") and sprite:GetFrame() >= 37) or (sprite:IsPlaying("ForgottenDeath") and sprite:GetFrame() >= 19) then
        if data.death then
            if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                p:AddBoneHearts(1)
            end
            p:Revive()
            if p:GetOtherTwin() then p:GetOtherTwin():Revive() end
            data.reviveDeath = true
            local enterDoor = level.EnterDoor
            local door = room:GetDoor(enterDoor)
            local direction = door and door.Direction or Direction.NO_DIRECTION
            game:StartRoomTransition(level:GetPreviousRoomIndex(),direction,0)
            level.LeaveDoor = enterDoor
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
            MC_POST_PLAYER_UPDATE
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}