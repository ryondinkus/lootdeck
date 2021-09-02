local Name = "Dice Shard"
local Tag = "diceShard"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p, flags)
	local game = Game()
	local sfx = lootdeck.sfx
    local f = lootdeck.f
    if not f.firstEnteredLevel then
        local level = game:GetLevel()
        local data = p:GetData()
        Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)
        f.newRoom = level:GetCurrentRoomIndex()
        if (flags & UseFlag.USE_MIMIC == 0) then
            print("running")
            data.removeCard = true
        else
            data.dischargeMimic = true
        end
        if (flags & UseFlag.USE_VOID == 0) then
            data.dischargeVoid = true
        end
    else
        local room = game:GetRoom()
        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ	,1,0)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, room:FindFreePickupSpawnPosition(p.Position), Vector.Zero, p)
    end
end

local function MC_POST_NEW_ROOM()
	local game = Game()
	local f = lootdeck.f
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
        local level = game:GetLevel()
        local enterDoor = level.EnterDoor
        local direction = Direction.NO_DIRECTION
        game:StartRoomTransition(f.newRoom,direction,0)
        level.LeaveDoor = enterDoor
        f.newRoom = nil
        f.checkEm = true
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
		}
    }
}