local helper = LootDeckAPI
local items = include("items/registry")

-- trinket; 50% chance each room to grant a temporary copy of a random passive you already have
local Names = {
    en_us = "Rainbow Tapeworm",
    spa = "Gusano Arcoíris"
}
local Name = Names.en_us
local Tag = "rainbowTapeworm"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: On room entry, 50% chance to temporarily duplicate one of your existing passives",
    spa = "Añade un objeto pasivo al usarla#Efecto pasivo: Al entrar a una habitación, hay un 50% de duplicar uno de tus objetos pasivos temporalmente"
}
local HolographicDescriptions = {
    en_us = "Adds {{ColorRainbow}}2 copies of a{{CR}} unique passive item on use# Passive: On room entry, 50% chance to temporarily duplicate one of your existing passives",
    spa = "Añade {{ColorRainbow}}2 copias de un{{CR}} objeto pasivo al usarla#Efecto pasivo: Al entrar a una habitación, hay un 50% de duplicar uno de tus objetos pasivos temporalmente"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: When entering a room, 50% chance to duplicate one of your passives for the rest of the room.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
    helper.GiveItem(p, items.rainbowTapeworm.Id, SoundEffect.SOUND_VAMP_GULP)
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
                        action = "REPEAT",
                        times = 4,
                        steps = {
                            {
                                action = "GIVE_ITEM",
                                id = function()
                                    local game = Game()
                                    local room = game:GetRoom()
                                    local itemPool = game:GetItemPool()
                                    local currentPool = itemPool:GetPoolForRoom(room:GetType(), lootdeck.rng:GetSeed())
                                    if currentPool == -1 then currentPool = 0 end
                                    return itemPool:GetCollectible(currentPool)
                                end
                            }
                        }
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "REPEAT",
                        times = 10,
                        steps = {
                            {
                                action = "GO_TO_DOOR"
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 2
                            }
                        }
                    }
                }
            },
            {
                name = Tag.."Stacking",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "REPEAT",
                        times = 4,
                        steps = {
                            {
                                action = "GIVE_ITEM",
                                id = function()
                                    local game = Game()
                                    local room = game:GetRoom()
                                    local itemPool = game:GetItemPool()
                                    local currentPool = itemPool:GetPoolForRoom(room:GetType(), lootdeck.rng:GetSeed())
                                    if currentPool == -1 then currentPool = 0 end
                                    return itemPool:GetCollectible(currentPool)
                                end
                            }
                        }
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
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
                        action = "REPEAT",
                        times = 5,
                        steps = {
                            {
                                action = "GO_TO_DOOR"
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 2
                            }
                        }
                    }
                }
            }
        }
    end
}
