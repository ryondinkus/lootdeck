local helper = LootDeckAPI

-- Resets the current room (using the glowing hourglass effect) but spawns you inside the room
-- If not possible, like at the beginning of the level, give the player a penny
local Names = {
    en_us = "Dice Shard",
    spa = "Dado Roto"
}
local Name = Names.en_us
local Tag = "diceShard"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 2
local Descriptions = {
    en_us = "Rewinds the events of the current room, like {{Collectible422}} Glowing Hourglass, but respawns you in the current room instead of the previous#{{Warning}} If used in the starting room of a new floor without visiting any other rooms, the effect will fail",
    spa = "Rebobina los eventos de la habitación, igual que {{Collectible422}} el Reloj de Arena Brillante, pero reapareces en la misma habitación y no en la anterior#{{Warning}} Si se utiliza en el principio de un nuevo piso sin visitar habitaciones, el efecto fallará"
}
local HolographicDescriptions = {
    en_us = "Rewinds the events of the current room, like {{Collectible422}} Glowing Hourglass, but respawns you in the current room instead of the previous#{{Warning}} If used in the starting room of a new floor without visiting any other rooms, the effect will fail#{{ColorRainbow}}The reset room will have all of its doors opened",
    spa = "Rebobina los eventos de la habitación, igual que {{Collectible422}} el Reloj de Arena Brillante, pero reapareces en la misma habitación y no en la anterior#{{Warning}} Si se utiliza en el principio de un nuevo piso sin visitar habitaciones, el efecto fallará#{{ColorRainbow}}La habitación reiniciada tendrá las puertas abiertas"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, undoes all of the events of the current room, similar to the Glowing Hourglass effect.", "- Unlike Glowing Hourglass, you will be rewinded to the start of the current room instead of the previous room. As such, this card cannot be used as a teleport.", "- If used in the starting room of a new floor, without visiting any other rooms, the effect will fail and spawn a Penny.", "Holographic Effect: The reset room will have all of its doors opened.")

local blackOverlay = Sprite()
blackOverlay:Load("gfx/coloroverlays/overlay.anm2")
blackOverlay:ReplaceSpritesheet(0, "gfx/coloroverlays/black_overlay.png")
blackOverlay:LoadGraphics()
blackOverlay:Play("Idle", true)

local function MC_USE_CARD(_, c, p, flags, shouldDouble)
	local game = Game()
	local level = game:GetLevel()
    local f = lootdeck.f
    if not f.firstEnteredLevel then
        local data = helper.GetLootDeckData(p)
        Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)
        f.newRoom = level:GetCurrentRoomIndex()
        if (flags & UseFlag.USE_MIMIC == 0) then
            data[Tag .. "RemoveCard"] = true
        else
            data[Tag .. "DischargeMimic"] = true
        end

        -- this doesnt work because cards cannot get the USE_VOID flag LOL XD
        -- if (flags & UseFlag.USE_VOID == 0) then
        --     data[Tag .. "DischargeVoid"] = true
        -- end

		if shouldDouble then
			data[Tag .. "Double"] = true
		end

        return false
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
				local currentCard = p:GetCard(j)
                if (currentCard == Id or currentCard == lootcardKeys.holographicdiceShard.Id) and data[Tag .. "RemoveCard"] then
                    LootDeckAPI.RemoveCard(p, j)
                    data[Tag .. "RemoveCard"] = nil
                end
            end
            if data[Tag .. "DischargeMimic"] then
                for j=0,3 do
                    if p:GetActiveItem(j) == CollectibleType.COLLECTIBLE_BLANK_CARD or p:GetActiveItem(j) == CollectibleType.COLLECTIBLE_VOID then
                        p:DischargeActiveItem(j)
                        data[Tag .. "DischargeMimic"] = nil
                    end
                end
            end
            -- *folds hands on desk* *tilts head* *smiles* voidy no worky
            -- if data[Tag .. "DischargeVoid"] then
            --     for j=0,3 do
            --         if p:GetActiveItem(j) == CollectibleType.COLLECTIBLE_VOID then
            --             p:DischargeActiveItem(j)
            --             data[Tag .. "DischargeVoid"] = nil
            --         end
            --     end
            -- end
			if data[Tag .. "Double"] then
				helper.OpenAllDoors(p)
				data[Tag .. "Double"] = nil
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
    HolographicDescriptions = HolographicDescriptions,
	WikiDescription = WikiDescription,
    Callbacks = {
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
    },
    Tests = function()
        return {
            {
                name = Tag.."NewLevel",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "USE_CARD"
                    }
                }
            },
            {
                name = Tag.."Regular",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "USE_CARD"
                    }
                }
            },
            {
                name = Tag.."BlankCard",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "GIVE_ITEM",
                        id = CollectibleType.COLLECTIBLE_BLANK_CARD,
                        charged = true
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "USE_ITEM"
                    }
                }
            },
            {
                name = Tag.."Void",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COLLECTIBLE,
                        subType = CollectibleType.COLLECTIBLE_BLANK_CARD
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "GIVE_ITEM",
                        id = CollectibleType.COLLECTIBLE_VOID,
                        charged = true
                    },
                    {
                        action = "USE_ITEM"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "CHARGE_ACTIVE_ITEM"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "USE_ITEM",
                        force = true
                    }
                }
            },
            {
                name = Tag.."JandE",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_JACOB
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id,
                        playerIndex = 1
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "REPEAT",
                        times = 3,
                        steps = {
                            {
                                action = "USE_CARD"
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 1
                            },
                            {
                                action = "USE_CARD",
                                playerIndex = 1
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 1
                            }
                        }
                    }
                }
            },
            {
                name = Tag.."StarterDeck",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_ITEM",
                        id = CollectibleType.COLLECTIBLE_STARTER_DECK
                    },
                    {
                        action = "REPEAT",
                        times = 2,
                        steps = {
                            {
                                action = "GIVE_CARD",
                                id = Id
                            }
                        }
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "USE_CARD"
                    }
                }
            },
            {
                name = Tag.."Beast",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "stage 13"
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "goto x.itemdungeon.666"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "USE_CARD"
                    }
                }
            }
        }
    end
}
