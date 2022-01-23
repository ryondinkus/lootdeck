local helper = LootDeckAPI
local costumes = include("costumes/registry")

local Names = {
    en_us = "V. The Hierophant",
    spa = "V. El Hierofante"
}
-- Gives two Holy Mantle effects for the room (negates damage twice with minimal cooldown)
local Name = Names.en_us
local Tag = "theHierophant"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Grants a {{Collectible313}} Holy Mantle effect that can absorb two hits",
    spa = "Otorga un efecto del {{Collectible313}} Manto Sagrado que puede absorber dos golpes"
}
local HolographicDescriptions = {
    en_us = "Grants a {{Collectible313}} Holy Mantle effect that can absorb {{ColorRainbow}}three{{CR}} hits",
    spa = "Otorga un efecto del {{Collectible313}} Manto Sagrado que puede absorber {{ColorRainbow}}tres{{CR}} golpes"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants a unique Holy Mantle that can absorb two hits.", "Holographic Effect: The Holy Mantle can absorb three hits.")

local function MC_USE_CARD(_, c, p, f, shouldDouble)
    local data = helper.GetLootDeckData(p)
    if data[Tag] then
        data[Tag] = data[Tag] + 2
    else
        data[Tag] = 2
    end
    if shouldDouble then
        data[Tag] = data[Tag] + 1
    end
	p:AddNullCostume(costumes.mantle)
end

local function MC_ENTITY_TAKE_DMG(_, e, damageAmount, damageFlags, damageSource)
    local p = e:ToPlayer()
    local data = helper.GetLootDeckData(p)
    if data[Tag] then
        if helper.CheckHolyMantleDamage(damageAmount, damageFlags, damageSource) then
            helper.HolyMantleEffect(p)
            data[Tag] = data[Tag] - 1
    		if data[Tag] == 1 then
                p:TryRemoveNullCostume(costumes.mantle)
    			p:AddNullCostume(costumes.mantleBroken)
    		end
            if data[Tag] <= 0 then
                p:TryRemoveNullCostume(costumes.mantleBroken)
                data[Tag] = nil
            end
            return false
        end
    end
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data[Tag] then
            data[Tag .. "KeepCostume"] = true
        end
    end)
end

local function MC_POST_UPDATE()
    helper.ForEachPlayer(function(p, data)
        if data[Tag .. "KeepCostume"] then
            if data[Tag] == 2 then
                p:AddNullCostume(costumes.mantle)
            elseif data[Tag] == 1 then
                p:AddNullCostume(costumes.mantleBroken)
            end
            data[Tag .. "KeepCostume"] = false
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
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
		},
        {
            ModCallbacks.MC_POST_UPDATE,
            MC_POST_UPDATE
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
                        action = "SPAWN",
                        type = EntityType.ENTITY_HORF
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 5
                    }
                }
            },
            {
                name = Tag.."BloodBank",
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
                        type = EntityType.ENTITY_SLOT,
                        variant = 2 -- blood bank
                    },
                    {
                        action = "MOVE_UP",
                        seconds = 5
                    }
                }
            },
            {
                name = Tag.."DullRazor",
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
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_DULL_RAZOR
                    }
                }
            },
            {
                name = Tag.."IvBag",
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
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_IV_BAG
                    }
                }
            },
            {
                name = Tag.."CurseRoom",
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
                    }
                }
            },
            {
                name = Tag.."SacrificeRoom",
                steps = {
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
                    }
                }
            },
            {
                name = Tag.."PoundOfFlesh",
                steps = {
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
                    }
                }
            },
            {
                name = Tag.."HolyMantle",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
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
                        id = PlayerType.PLAYER_ISAAC
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
            }
        }
    end
}
