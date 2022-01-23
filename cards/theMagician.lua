local helper = LootDeckAPI
local costumes = include("costumes/registry")

-- Temporary tears up and brain worm effect for the room, as well as a brain costume
local Names = {
    en_us = "I. The Magician",
    spa = "I. El Mago"
}
local Name = Names.en_us
local Tag = "theMagician"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "{{ArrowUp}} +0.27 Tears Up for the room# Grants the {{Trinket144}} Brain Worm effect for the room, causing your tears to turn 90 degrees and hit enemies",
    spa = "{{ArrowUp}} +0.27 de lágrimas durante la habitación#Otorga el efecto de {{Trinket144}} Gusano del cerebro"
}
local HolographicDescriptions = {
    en_us = "{{ArrowUp}} {{ColorRainbow}}+0.61{{CR}} Tears Up for the room# Grants the {{Trinket144}} Brain Worm effect for the room, causing your tears to turn 90 degrees and hit enemies",
    spa = "{{ArrowUp}} {{ColorRainbow}}+0.61{{CR}} de lágrimas durante la habitación#Otorga el efecto de {{Trinket144}} Gusano del cerebro"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants a +0.31 Tears Up and the Brain Worm effect for the room, which causes your tears to turn 90 degrees to hit enemies.", "Holographic Effect: Grants an additional tears up.")

-- If it ever gets fixed, AddTrinketEffect() would be better here
local function MC_USE_CARD(_, c, p)
    local data = helper.GetLootDeckData(p)
    if not data.magician then data.magician = 1
    else data.magician = data.magician + 1 end
	p:AddNullCostume(costumes.magician)
    p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARCOLOR | CacheFlag.CACHE_TEARFLAG)
    p:EvaluateItems()
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = helper.GetLootDeckData(p)
    if f == CacheFlag.CACHE_FIREDELAY then
        if data.magician then
            p.MaxFireDelay = p.MaxFireDelay - (data.magician)
        end
    end
    if f == CacheFlag.CACHE_TEARCOLOR then
        if data.magician then
            local tearColor = Color(1,1,1,1,0,0,0)
            tearColor:SetColorize(1,1,1,1)
			local laserColor = Color(1,1,1,1,1,1,1)
            p.TearColor = tearColor
			p.LaserColor = laserColor
        end
    end
	if f == CacheFlag.CACHE_TEARFLAG then
        if data.magician then
            p.TearFlags = p.TearFlags | helper.ConvertBitSet64ToBitSet128(71)
        end
    end
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data.magician then
            data.magician = nil
			p:TryRemoveNullCostume(costumes.magician)
            p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARCOLOR | CacheFlag.CACHE_TEARFLAG)
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
                        action = "REPEAT",
                        times = 2,
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
                        type = EntityType.ENTITY_HORF
                    },
                    {
                        action = "MOVE_RIGHT",
                        seconds = 0.2
                    },
                    {
                        action = "SHOOT_UP",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "SHOOT_DOWN",
                        seconds = 2
                    }
                }
            }
        }
    end
}
