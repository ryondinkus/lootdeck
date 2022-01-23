local helper = LootDeckAPI
local items = include("items/registry")

-- Gives the bloody penny item
local Names = {
    en_us = "Bloody Penny",
    spa = "Moneda Sangrienta"
}
local Name = Names.en_us
local Tag = "bloodyPenny"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: 5% chance to drop a Loot Card on enemy death",
    spa = "Añade un objeto pasivo tras usarla#Efecto pasivo: Matar a un enemigo otorga un 5% de posibilidad de que suelte una carta de loot"
}
local HolographicDescriptions = {
    en_us = "Adds {{ColorRainbow}}2 copies of a{{CR}} unique passive item on use# Passive: 5% chance to drop a Loot Card on enemy death",
    spa = "Añade {{ColorRainbow}}2 copias de un{{CR}} un objeto pasivo tras usarla#Efecto pasivo: Matar a un enemigo otorga un 5% de posibilidad de que suelte una carta de loot"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: Enemies have a 5% chance to drop a Loot Card on death.", "- Effect stacks +5% for every instance of the passive and caps at 25%.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
	helper.GiveItem(p, items.bloodyPenny.Id, SoundEffect.SOUND_VAMP_GULP)
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
                        action = "ENABLE_DEBUG_FLAG",
                        flag = 4
                    },
                    {
                        action = "ENABLE_DEBUG_FLAG",
                        flag = 3
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
                        times = 20,
                        steps = {
                            {
                                action = "SPAWN",
                                type = EntityType.ENTITY_SPIDER
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
                        action = "ENABLE_DEBUG_FLAG",
                        flag = 4
                    },
                    {
                        action = "ENABLE_DEBUG_FLAG",
                        flag = 3
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
                        times = 12,
                        steps = {
                            {
                                action = "SPAWN",
                                type = EntityType.ENTITY_SPIDER
                            }
                        }
                    }
                }
            },
            {
                name = Tag.."InvEnemies",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "ENABLE_DEBUG_FLAG",
                        flag = 4
                    },
                    {
                        action = "ENABLE_DEBUG_FLAG",
                        flag = 3
                    },
                    {
                        action = "GIVE_ITEM",
                        id = CollectibleType.COLLECTIBLE_SOY_MILK
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
                        action = "SPAWN",
                        type = EntityType.ENTITY_STONEHEAD
                    },
                    {
                        action = "SHOOT_UP",
                        seconds = 10
                    }
                }
            },
            {
                name = Tag.."Rng",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "BWD6 Y8BM"
                    },
                    {
                        action = "ENABLE_DEBUG_FLAG",
                        flag = 4
                    },
                    {
                        action = "ENABLE_DEBUG_FLAG",
                        flag = 3
                    },
                    {
                        action = "GIVE_ITEM",
                        id = CollectibleType.COLLECTIBLE_SOY_MILK
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
                    },
                    {
                        action = "WAIT_FOR_KEY"
                    },
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS
                    },
                    {
                        action = "GO_TO_DOOR"
                    }
                }
            }
        }
    end
}
