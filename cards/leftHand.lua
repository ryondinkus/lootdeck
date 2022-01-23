local helper = LootDeckAPI
local items = include("items/registry")

-- trinket; Swap the pools of Red Chests and Gold Chests
local Names = {
    en_us = "The Left Hand",
    spa = "La Mano Izquierda"
}
local Name = Names.en_us
local Tag = "leftHand"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: Swaps the potential drops of Gold Chests and Red Chests",
    spa = "Añade un objeto pasivo al usarla#Efecto pasivo: Cambia las recompensas potenciales de los Cofres Dorados y los Cofres Rojos"
}
local HolographicDescriptions = {
    en_us = "Adds {{ColorRainbow}}2 copies of a{{CR}} unique passive item on use# Passive: Swaps the potential drops of Gold Chests and Red Chests",
    spa = "Añade {{ColorRainbow}}2 copias de un{{CR}} objeto pasivo al usarla#Efecto pasivo: Cambia las recompensas potenciales de los Cofres Dorados y los Cofres Rojos"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: Swaps the potential drops of Gold Chests and Red Chests.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
    helper.GiveItem(p, items.leftHand.Id, SoundEffect.SOUND_VAMP_GULP)
end

local INITIAL_POSITION = Vector(320, 380)

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
                name = Tag.."Locked",
                steps = {
                    {
                        action = "REPEAT",
                        times = 10,
                        steps = {
                            {
                                action = "RESTART",
                                id = PlayerType.PLAYER_ISAAC
                            },
                            {
                                action = "GIVE_ITEM",
                                id = CollectibleType.COLLECTIBLE_SKELETON_KEY
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
                                type = EntityType.ENTITY_PICKUP,
                                variant = PickupVariant.PICKUP_LOCKEDCHEST,
                                position = function()
                                    return Game():GetRoom():GetCenterPos()
                                end
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 0.5
                            },
                            {
                                action = "MOVE_UP",
                                seconds = 0.5
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
                name = Tag.."Red",
                steps = {
                    {
                        action = "REPEAT",
                        times = 10,
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
                                action = "SPAWN",
                                type = EntityType.ENTITY_PICKUP,
                                variant = PickupVariant.PICKUP_REDCHEST,
                                position = function()
                                    return Game():GetRoom():GetCenterPos()
                                end
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 0.5
                            },
                            {
                                action = "MOVE_UP",
                                seconds = 0.5
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
                name = Tag.."LockedBefore",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_ITEM",
                        id = CollectibleType.COLLECTIBLE_SKELETON_KEY
                    },
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_LOCKEDCHEST,
                        position = function()
                            return Game():GetRoom():GetCenterPos()
                        end
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 0.5
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
                        seconds = 0.5
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            },
            {
                name = Tag.."RedBefore",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_REDCHEST,
                        position = function()
                            return Game():GetRoom():GetCenterPos()
                        end
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 0.5
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
                        seconds = 0.5
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            }
        }
    end
}
