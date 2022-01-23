local helper = LootDeckAPI
local costumes = include("costumes/registry")

-- Gain two temporary hearts for the room
local Names = {
    en_us = "VI. The Lovers",
    spa = "VI. Los Amantes"
}
local Name = Names.en_us
local Tag = "theLovers"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "{{Heart}} +2 Heart Containers for the room",
    spa = "Otorga 2 contenedores de corazón durante la habitación"
}
local HolographicDescriptions = {
    en_us = "{{Heart}} {{ColorRainbow}}+3{{CR}} Heart Containers for the room",
    spa = "Otorga {{ColorRainbow}}3{{CR}} contenedores de corazón durante la habitación"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants two temporary Heart Containers for the duration of the room.", "Holographic Effect: Grants 3 temporary heart containers.")

local function MC_USE_CARD(_, c, p, f, shouldDouble)
    local data = helper.GetLootDeckData(p)
	local tempHealth = 4
	if shouldDouble then
		tempHealth = tempHealth + 2
	end
    helper.AddTemporaryHealth(p, tempHealth)
    if not data[Tag] then data[Tag] = true end
    p:AddNullCostume(costumes.lovers)
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data[Tag] then
            data[Tag] = nil
            p:TryRemoveNullCostume(costumes.lovers)
        end
    end)
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
    },
    Tests = function()
        return {
            {
                name = Tag.."Use",
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
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
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
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_JACOB
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id,
                        playerIndex = 1
                    },
                    {
                        action = "USE_CARD",
                        playerIndex = 1
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_JACOB
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id,
                        playerIndex = 1
                    },
                    {
                        action = "USE_CARD",
                        playerIndex = 1
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
                    }
                }
            },
            {
                name = Tag.."TaintedForgotten",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_THEFORGOTTEN_B
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_THEFORGOTTEN_B
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id,
                        playerIndex = 1
                    },
                    {
                        action = "USE_CARD",
                        playerIndex = 1
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_THEFORGOTTEN_B
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id,
                        playerIndex = 1
                    },
                    {
                        action = "USE_CARD",
                        playerIndex = 1
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
                    }
                }
            },
            {
                name = Tag.."Forgotten",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_THEFORGOTTEN
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_THEFORGOTTEN
                    },
                    {
                        action = "SWAP_SUB_PLAYERS"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_THEFORGOTTEN
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "SWAP_SUB_PLAYERS"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_THEFORGOTTEN
                    },
                    {
                        action = "SWAP_SUB_PLAYERS"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "SWAP_SUB_PLAYERS"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                }
            },
            {
                name = Tag.."Keeper",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_KEEPER
                    },
                    {
                        action = "REPEAT",
                        times = 5,
                        steps = {
                            {
                                action = "GIVE_CARD",
                                id = Id
                            },
                            {
                                action = "USE_CARD"
                            }
                        }
                    },
                    {
                        action = "GO_TO_DOOR"
                    }
                }
            },
            {
                name = Tag.."TaintedKeeper",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_KEEPER_B
                    },
                    {
                        action = "REPEAT",
                        times = 5,
                        steps = {
                            {
                                action = "GIVE_CARD",
                                id = Id
                            },
                            {
                                action = "USE_CARD"
                            }
                        }
                    },
                    {
                        action = "GO_TO_DOOR"
                    }
                }
            }
        }
    end
}
