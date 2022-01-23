local helper = LootDeckAPI
local costumes = include("costumes/registry")

-- Gain .50 damage for the room for each heart
local Names = {
    en_us = "VII. The Chariot",
    spa = "VII. El carro"
}
local Name = Names.en_us
local Tag = "theChariot"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "{{Heart}} +1 Heart Container for the room# {{ArrowUp}} +0.5 damage for every Heart Container you have",
    spa = "{{Heart}} +1 contenedor de corazón durante la habitación# {{ArrowUp}} +0.5 de daño por cada contenedor de corazón que tengas"
}
local HolographicDescriptions = {
    en_us = "{{Heart}} {{ColorRainbow}}+2{{CR}} Heart Containers for the room# {{ArrowUp}} +0.5 damage for every Heart Container you have",
    spa = "{{Heart}} {{ColorRainbow}}+2{{CR}} contenedores de corazón durante la habitación# {{ArrowUp}} +0.5 de daño por cada contenedor de corazón que tengas"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants a temporary Heart Container for the room.", "Adds +0.5 Damage for every Heart Container you have for the duration of the room.", "Holographic Effect: Grants an extra Heart Container.")

local function MC_USE_CARD(_, c, p)
    helper.AddTemporaryHealth(p, 2)
    local data = helper.GetLootDeckData(p)
    if not data.chariot then data.chariot = true end
    p:AddNullCostume(costumes.chariot)
    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    p:EvaluateItems()
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = helper.GetLootDeckData(p)
    if f == CacheFlag.CACHE_DAMAGE then
        if data.chariot then
            if helper.IsSoulHeartBart(p) or p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B then
                p.Damage = p.Damage + (0.25 * p:GetSoulHearts())
            else
                p.Damage = p.Damage + (0.25 * p:GetHearts())
            end
        end
    end
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data.chariot then
            data.chariot = nil
            p:TryRemoveNullCostume(costumes.chariot)
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            p:EvaluateItems()
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
            Id,
            true
        },
        {
            ModCallbacks.MC_EVALUATE_CACHE,
            MC_EVALUATE_CACHE
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
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
                        id = Id,
                        playerIndex = 1
                    },
                    {
                        action = "USE_CARD",
                        playerIndex = 1
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
