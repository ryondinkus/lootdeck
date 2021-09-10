-- Resets the current room (using the glowing hourglass effect) but spawns you inside the room
-- If not possible, like at the beginning of the level, give the player a penny
local Name = "Dice Shard"
local Tag = "diceShard"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p, flags)
	local game = Game()
	local level = game:GetLevel()
	local room = game:GetRoom()
	local sfx = lootdeck.sfx
    local f = lootdeck.f
    if not f.firstEnteredLevel then
        local data = p:GetData()
        Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)
        f.newRoom = level:GetCurrentRoomIndex()
        if (flags & UseFlag.USE_MIMIC == 0) then
            data.removeCard = true
        else
            data.dischargeMimic = true
        end
        if (flags & UseFlag.USE_VOID == 0) then
            data.dischargeVoid = true
        end
    else
        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ	,1,0)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, room:FindFreePickupSpawnPosition(p.Position), Vector.Zero, p)
    end
end

local function MC_POST_NEW_ROOM()
	local game = Game()
	local level = game:GetLevel()
	local room = game:GetRoom()
	local f = lootdeck.f

    if f.firstEnteredLevel then
        f.firstEnteredLevel = false
    end

    if f.checkEm then
        for i=0,game:GetNumPlayers()-1 do
            local p = Isaac.GetPlayer(i)
            local data = p:GetData()
            for j=0,3 do
                if p:GetCard(j) == Id and data.removeCard then
                    p:SetCard(j, 0)
                    data.removeCard = nil
                end
            end
            if data.dischargeMimic then
                for j=0,3 do
                    if p:GetActiveItem(j) == CollectibleType.COLLECTIBLE_BLANK_CARD then
                        p:DischargeActiveItem(j)
                        data.dischargeMimic = nil
                    end
                end
            end
            if data.dischargeVoid then
                for j=0,3 do
                    if p:GetActiveItem(j) == CollectibleType.COLLECTIBLE_VOID then
                        p:DischargeActiveItem(j)
                        data.dischargeVoid = nil
                    end
                end
            end
        end
        f.checkEm = false
        f.showOverlay = false
    end
    if f.newRoom then
        f.showOverlay = true
        local enterDoor = level.EnterDoor
		local door = room:GetDoor(enterDoor)
		local direction = door and door.Direction or Direction.NO_DIRECTION
        game:StartRoomTransition(f.newRoom,direction,1)
        level.LeaveDoor = enterDoor
        f.newRoom = nil
        f.checkEm = true
    end
end

local function MC_POST_NEW_LEVEL()
    lootdeck.f.firstEnteredLevel = true
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
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    }
}
