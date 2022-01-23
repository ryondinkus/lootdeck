
local helper = LootDeckAPI
local items = include("items/registry")

-- Gives the Guppy's Hairball item
local Names = {
    en_us = "Guppy's Hairball",
    spa = "Bola de Pelo de Guppy"
}
local Name = Names.en_us
local Tag = "guppysHairball"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: Every instance of damage taken has a 1/6 chance to be blocked",
    spa = "Añade un objeto pasivo tras usarla#Efecto pasivo: Cada vez que se reciba daño, hay una posibilidad de 1/6 de bloquearlo"
}
local HolographicDescriptions = {
    en_us = "Adds {{ColorRainbow}}2 copies of a{{CR}} unique passive item on use# Passive: Every instance of damage taken has a 1/6 chance to be blocked",
    spa = "Añade {{ColorRainbow}}2 copias de un{{CR}} objeto pasivo tras usarla#Efecto pasivo: Cada vez que se reciba daño, hay una posibilidad de 1/6 de bloquearlo"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: Every instance of damage taken has a 1/6 chance to be blocked.", "- Additional copies of the passive add an extra 1/6 chance, up to 3/6.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
	helper.GiveItem(p, items.guppysHairball.Id, SoundEffect.SOUND_VAMP_GULP)
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
                    LootDeckAPI.SetDebugFlagStep(Tag, true),
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
                        action = "SPAWN",
                        type = EntityType.ENTITY_HORF
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 5
                    },
                    LootDeckAPI.ClearDebugFlagStep(Tag)
                }
            },
            {
                name = Tag.."BloodBank",
                steps = {
                    LootDeckAPI.SetDebugFlagStep(Tag, true),
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
                        action = "SPAWN",
                        type = EntityType.ENTITY_SLOT,
                        variant = 2 -- blood bank
                    },
                    {
                        action = "MOVE_UP",
                        seconds = 5
                    },
                    LootDeckAPI.ClearDebugFlagStep(Tag)
                }
            },
            {
                name = Tag.."DullRazor",
                steps = {
                    LootDeckAPI.SetDebugFlagStep(Tag, true),
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
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_DULL_RAZOR
                    },
                    LootDeckAPI.ClearDebugFlagStep(Tag)
                }
            },
            {
                name = Tag.."IvBag",
                steps = {
                    LootDeckAPI.SetDebugFlagStep(Tag, true),
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
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_IV_BAG
                    },
                    LootDeckAPI.ClearDebugFlagStep(Tag)
                }
            },
            {
                name = Tag.."CurseRoom",
                steps = {
                    LootDeckAPI.SetDebugFlagStep(Tag, true),
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
                        action = "RUN_COMMAND",
                        command = "goto s.curse"
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "debug 10"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    LootDeckAPI.ClearDebugFlagStep(Tag)
                }
            },
            {
                name = Tag.."SacrificeRoom",
                steps = {
                    LootDeckAPI.SetDebugFlagStep(Tag, true),
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "ZS3Z VJ1D"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "MOVE_UP",
                        seconds = 3
                    },
                    LootDeckAPI.ClearDebugFlagStep(Tag)
                }
            },
            {
                name = Tag.."PoundOfFlesh",
                steps = {
                    LootDeckAPI.SetDebugFlagStep(Tag, true),
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "GIVE_ITEM",
                        id = CollectibleType.COLLECTIBLE_POUND_OF_FLESH
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "goto s.shop"
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "debug 10"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 5
                    },
                    LootDeckAPI.ClearDebugFlagStep(Tag)
                }
            },
            {
                name = Tag.."Stacking",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "GQYG CK7B"
                    },
                    {
                        action = "REPEAT",
                        times = 3,
                        steps = {
                            {
                                action = "GIVE_CARD",
                                id = Id
                            },
                            {
                                action = "USE_CARD"
                            },
                        }
                    },
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_HORF
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 5
                    },
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "GQYG CK7B"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_HORF
                    }
                }
            }
        }
    end
}
