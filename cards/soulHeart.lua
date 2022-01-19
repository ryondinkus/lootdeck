local helper = LootDeckAPI

-- Gives the Holy Mantle effect for the room (negates damage once with minimal cooldown)
local Names = {
    en_us = "Soul Heart",
    spa = "Corazón de Alma"
}
local Name = Names.en_us
local Tag = "soulHeart"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 2
local Descriptions = {
        en_us = "Grants a {{Collectible313}} Holy Mantle shield for the room, negating damage once",
        spa = "Otorga un escudo del {{Collectible313}} Mando Sagrado durante la habitación, negando el daño una vez"
}
local HolographicDescriptions = {
        en_us = "Grants {{ColorRainbow}}2{{CR}} {{Collectible313}} Holy Mantle shields for the room, negating damage twice",
        spa = "Otorga {{ColorRainbow}}2{{CR}} escudos del {{Collectible313}} Mando Sagrado durante la habitación, negando el daño dos veces"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a temporary Holy Mantle shield for the room. This shield negates the next instance of damage you take in the room.", "Holographic Effect: Grants two Holy Mantle shields for the room.")

local function MC_USE_CARD(_, c, p)
    p:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
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
    Tests = {
        {
            name = Tag.."Use",
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
                    action = "WAIT_FOR_SECONDS",
                    seconds = 1
                },
                {
                    action = "SPAWN",
                    type = EntityType.ENTITY_HORF
                }
            }
        },
        {
            name = Tag.."Remove",
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
                    action = "WAIT_FOR_SECONDS",
                    seconds = 1
                },
                {
                    action = "GO_TO_DOOR"
                }
            }
        },
        {
            name = Tag.."HolyMantle",
            steps = {
                {
                    action = "RESTART",
                    id = 0
                },
                {
                    action = "GIVE_ITEM",
                    id = CollectibleType.COLLECTIBLE_HOLY_MANTLE
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
        },
        {
            name = Tag.."HolyCard",
            steps = {
                {
                    action = "RESTART",
                    id = 0
                },
                {
                    action = "USE_CARD",
                    id = Card.CARD_HOLY
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
        },
        {
            name = Tag.."Hierophant",
            steps = {
                {
                    action = "RESTART",
                    id = 0
                },
                {
                    action = "USE_CARD",
                    id = lootcardKeys.theHierophant.Id
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
}
