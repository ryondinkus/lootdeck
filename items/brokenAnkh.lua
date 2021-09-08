-- Gives a chance of reviving in the previous room with half a heart
local Name = "Broken Ankh"
local Tag = "brokenAnkh"
local Id = Isaac.GetItemIdByName(Name)

local function MC_POST_PLAYER_RENDER(_, p)
    local game = Game()
    local data = p:GetData()
    local sprite = p:GetSprite()
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    if (sprite:IsPlaying("Death") and sprite:GetFrame() == 55)
	or (sprite:IsPlaying("LostDeath") and sprite:GetFrame() == 37)
	or (sprite:IsPlaying("ForgottenDeath") and sprite:GetFrame() == 19) then
        if data.chancePassed then
            if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                p:AddBoneHearts(1)
            end
            p:Revive()
			p:SetMinDamageCooldown(60)
			if p:GetOtherTwin() then
				p:GetOtherTwin():Revive()
				p:GetOtherTwin():SetMinDamageCooldown(60)
			end
			data.reviveAnkh = true
            local enterDoor = level.EnterDoor
            local door = room:GetDoor(enterDoor)
            local direction = door and door.Direction or Direction.NO_DIRECTION
            game:StartRoomTransition(level:GetPreviousRoomIndex(),direction,0)
            level.LeaveDoor = enterDoor
			data.chancePassed = nil
        end
    end
end

local function MC_POST_NEW_ROOM()
    local game = Game()
    local sfx = lootdeck.sfx
    for i=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()

		if p:HasCollectible(Id) then
			local effectNum = p:GetCollectibleNum(Id)
			local effect = lootdeck.rng:RandomInt(6)
			local threshold = 0
			threshold = threshold + (effectNum - 1)
			if threshold > 2 then threshold = 2 end
			data.chancePassed = false
			if effect <= threshold then
				data.chancePassed = true
			end
		end

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
            p:AnimateCollectible(Id)
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
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
        {
            ModCallbacks.MC_POST_PLAYER_RENDER,
            MC_POST_PLAYER_RENDER
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}
