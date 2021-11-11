local helper = include("helper_functions")

-- Resets the current room (using the glowing hourglass effect) but spawns you inside the room
-- If not possible, like at the beginning of the level, give the player a penny
local Names = {
    en_us = "Dice Shard",
    spa = "Dado Roto"
}
local Name = Names.en_us
local Tag = "diceShard"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 4
local Descriptions = {
    en_us = "Rewinds the events of the current room, like {{Collectible422}} Glowing Hourglass, but respawns you in the current room instead of the previous#{{Warning}} If used in the starting room of a new floor without visiting any other rooms, the effect will fail",
    spa = "Rebobina los eventos de la habitación, igual que {{Collectible422}} el Reloj de Arena Brillante, pero reapareces en la misma habitación y no en la anterior#{{Warning}} Si se utiliza en el principio de un nuevo piso sin visitar habitaciones, el efecto fallará"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, undoes all of the events of the current room, similar to the Glowing Hourglass effect.", "- Unlike Glowing Hourglass, you will be rewinded to the start of the current room instead of the previous room. As such, this card cannot be used as a teleport.", "- If used in the starting room of a new floor, without visiting any other rooms, the effect will fail and spawn a Penny.")

local blackOverlay = Sprite()
blackOverlay:Load("gfx/coloroverlays/overlay.anm2")
blackOverlay:ReplaceSpritesheet(0, "gfx/coloroverlays/black_overlay.png")
blackOverlay:LoadGraphics()
blackOverlay:Play("Idle", true)

local function MC_USE_CARD(_, c, p, flags)
	local game = Game()
	local level = game:GetLevel()
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
        helper.FuckYou(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY)
    end
end

local function MC_POST_NEW_ROOM()
	local game = Game()
	local level = game:GetLevel()
	local room = game:GetRoom()

    if lootdeck.f.firstEnteredLevel then
        lootdeck.f.firstEnteredLevel = false
    end

    if lootdeck.f.checkEm then
        helper.ForEachPlayer(function(p, data)
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
        end)
        lootdeck.f.checkEm = false
        lootdeck.f.showOverlay = false
    end
    if lootdeck.f.newRoom then
        lootdeck.f.showOverlay = true
        local enterDoor = level.EnterDoor
		local door = room:GetDoor(enterDoor)
		local direction = door and door.Direction or Direction.NO_DIRECTION
        game:StartRoomTransition(lootdeck.f.newRoom,direction,1)
        level.LeaveDoor = enterDoor
        lootdeck.f.newRoom = nil
        lootdeck.f.checkEm = true
    end
end

local function MC_POST_NEW_LEVEL()
    lootdeck.f.firstEnteredLevel = true
end

local function MC_POST_RENDER()
    if lootdeck.f.showOverlay then
         blackOverlay:RenderLayer(0, Vector.Zero)
     end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
	Descriptions = Descriptions,
	WikiDescription = WikiDescription,
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
        },
        {
            ModCallbacks.MC_POST_RENDER,
            MC_POST_RENDER
        }
    }
}
