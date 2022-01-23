local helper = LootDeckAPI
local items = include("items/registry")

-- Gives the Purple Heart item
local Names = {
    en_us = "Purple Heart",
    spa = "Corazón Purputa"
}
local Name = Names.en_us
local Tag = "purpleHeart"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: 25% chance to reroll a random enemy in the room# Rerolled enemies drop a consumable on death",
    spa = "Añade un objeto pasivo al usarla#Efecto pasivo: 25% de rerolear a un enemigo aleatorio en la habitación#Los enemigos reroleados sueltan un recolectable al derrolatolos"
}
local HolographicDescriptions = {
    en_us = "Adds {{ColorRainbow}}2 copies of a{{CR}} unique passive item on use# Passive: 25% chance to reroll a random enemy in the room# Rerolled enemies drop a consumable on death",
    spa = "Añade {{ColorRainbow}}2 copias de un{{CR}} objeto pasivo al usarla#Efecto pasivo: 25% de rerolear a un enemigo aleatorio en la habitación#Los enemigos reroleados sueltan un recolectable al derrolatolos"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: 25% chance to reroll a random enemy in the room.", "- Additional copies of the passive add an additional 25% chance, up to 100%.", "Rerolled enemies drop an extra consumable on death.", "- Consumables spawned are based on the algorithm from Glyph of Balance, granting a consumable you have the least of.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
	helper.GiveItem(p, items.purpleHeart.Id, SoundEffect.SOUND_VAMP_GULP)
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
                        action = "REPEAT",
                        steps = {
                            {
                                action = "RESTART",
                                id = 0
                            },
                            {
                                action = "GIVE_CARD",
                                id = Id
                            },
                            {
                                action = "USE_CARD"
                            },
                            {
                                action = "GO_TO_DOOR"
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 2
                            }
                        },
                        times = 10
                    }
                }
            },
            {
                name = Tag.."Stacking",
                steps = {
                    {
                        action = "REPEAT",
                        steps = {
                            {
                                action = "RESTART",
                                id = 0
                            },
                            {
                                action = "REPEAT",
                                steps = {
                                    {
                                        action = "GIVE_CARD",
                                        id = Id
                                    },
                                    {
                                        action = "USE_CARD"
                                    }
                                },
                                times = 4
                            },
                            {
                                action = "GO_TO_DOOR"
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 2
                            },
                            {
                                action = "USE_CARD",
                                id = Card.CARD_DEATH
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 2
                            },
                        },
                        times = 5
                    }
                }
            },
            {
                name = Tag.."Rng",
                steps = {
                    {
                        action = "REPEAT",
                        times = 2,
                        steps = {
                            {
                                action = "RESTART",
                                id = PlayerType.PLAYER_ISAAC,
                                seed = "2L6V G6XJ"
                            },
                            {
                                action = "GIVE_CARD",
                                id = Id
                            },
                            {
                                action = "USE_CARD"
                            },
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
        }
    end
}
