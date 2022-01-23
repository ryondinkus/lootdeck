local helper = LootDeckAPI
local items = include("items/registry")

-- Gives the Golden Horseshoe item
local Names = {
    en_us = "Golden Horseshoe",
    spa = "Herradura Dorada"
}
local Name = Names.en_us
local Tag = "goldenHorseshoe"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: Every Treasure room has an additional {{Collectible721}} TMTRAINER item",
    spa = "Añade un objeto pasivo tras usarla#Efecto pasivo: Cada sala del tesoro tiene un objeto adicional de {{Collectible721}} ENTRENADOR TM"
}
local HolographicDescriptions = {
    en_us = "Adds {{ColorRainbow}}2 copies of a{{CR}} unique passive item on use# Passive: Every Treasure room has an additional {{Collectible721}} TMTRAINER item",
    spa = "Añade {{ColorRainbow}}2 copias de un{{CR}} objeto pasivo tras usarla#Efecto pasivo: Cada sala del tesoro tiene un objeto adicional de {{Collectible721}} ENTRENADOR TM"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: Every Treasure room has an additional TMTRAINER item.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
	helper.GiveItem(p, items.goldenHorseshoe.Id, SoundEffect.SOUND_VAMP_GULP)
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
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "REPEAT",
                        steps =
                        {
                            {
                                action = "USE_CARD",
                                id = Card.CARD_STARS
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
                                seconds = 1
                            },
                        },
                        times = 3
                    }
                }
            },
            {
                name = Tag.."Labyrinth",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "curse 2"
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "stage 1"
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
                        steps =
                        {
                            {
                                action = "USE_CARD",
                                id = Card.CARD_STARS
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 2
                            },
                        },
                        times = 2
                    }
                }
            }
        }
    end
}
