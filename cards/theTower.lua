local helper = LootDeckAPI

-- Explodes each enemy in the room and then the player
local Names = {
    en_us = "XIV. The Tower",
    spa = "XIV. La Torre"
}
local Name = Names.en_us
local Tag = "theTower"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
	en_us = "{{Warning}} On use, explodes on every enemy in the room, then the player",
	spa = "{{Warning}} Al usarla, todos los enemigos en la habitación explotarán luego explotará el jugador"
}
local HolographicDescriptions = {
	en_us = "{{Warning}} On use, explodes on every enemy in the room, then the player#{{ColorRainbow}}All explosions have random bomb effects",
	spa = "{{Warning}} Al usarla, todos los enemigos en la habitación explotarán luego explotará el jugador#{{ColorRainbow}}Todas las explosiones tienen efectos de bomba aleatorios"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, spawns an explosion on every enemy in the room, dealing 40 damage to any enemy in the explosion.", "After exploding on all enemies, it will explode on the player.", "Holographic Effect: All spawned explosions have a random bomb effect. This can be the effect from Sad Bombs, Blood Bombs, Butt Bombs, or Bomber Boy.")

local function MC_USE_CARD(_, c, p, f, shouldDouble)
    local data = helper.GetLootDeckData(p)
	data[Tag] = 1

	if shouldDouble then
        data[Tag .. "Double"] = shouldDouble
	end

	local enemies = helper.ListEnemiesInRoom()
	for _, enemy in ipairs(enemies) do
		enemy:GetData()[Tag] = 1
	end

	return #enemies > 0
end

local function MC_POST_NEW_ROOM()
    LootDeckAPI.ForEachPlayer(function(player)
        helper.StopStaggerSpawn(player, Tag)
    end)
end

local function MC_POST_PEFFECT_UPDATE(_, p)
	local rng = p:GetCardRNG(Id)
    local numberOfEnemies = #helper.ListEnemiesInRoom(true, function(_, eData) return eData[Tag] end) + 1
    helper.StaggerSpawn(Tag, p, 7, numberOfEnemies, function(counterTag, previousResult)

		local data = helper.GetLootDeckData(p)
		if data[counterTag] > numberOfEnemies then
			data[counterTag] = numberOfEnemies
		end
		local target

		if data[counterTag] == 1 then
			target = p
		else
			local enemy = helper.GetRandomEnemy(rng, nil, function(_, eData) return eData[Tag] end)
			if enemy then
				target = enemy
				enemy:GetData()[Tag] = nil
			else
				target = p
			end
		end

		if target ~= p or (not previousResult or previousResult < data[Tag]) then
            local flags
            if data[Tag .. "Double"] then
                local bombFlags = {
                    TearFlags.TEAR_SAD_BOMB,
                    TearFlags.TEAR_BUTT_BOMB,
                    TearFlags.TEAR_CROSS_BOMB,
                    TearFlags.TEAR_BLOOD_BOMB
                }
                flags = bombFlags[rng:RandomInt(#bombFlags) + 1]
            end
			Game():BombExplosionEffects(target.Position, 40, flags)
			data[counterTag] = data[counterTag] - 1
		end

		return (previousResult or 1) + 1
	end,
	function()
		local enemies = helper.ListEnemiesInRoom()
		for _, enemy in ipairs(enemies) do
			enemy:GetData()[Tag] = true
		end
        helper.GetLootDeckData(p)[Tag .. "Double"] = nil
	end,
	true)
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
			ModCallbacks.MC_POST_NEW_ROOM,
			MC_POST_NEW_ROOM
		},
		{
			ModCallbacks.MC_POST_PEFFECT_UPDATE,
			MC_POST_PEFFECT_UPDATE
		}
    },
	Tests = function ()
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
						action = "SPAWN",
						type = EntityType.ENTITY_HORF
					},
					{
						action = "WAIT_FOR_SECONDS",
						seconds = 1
					},
					{
						action = "USE_CARD"
					}
				}
			},
			{
				name = Tag.."Multiple",
				steps = {
					{
						action = "REPEAT",
						times = 2,
						steps = {
							{
								action = "RESTART",
								id = PlayerType.PLAYER_ISAAC,
								seed = "2444 XYSA"
							},
							{
								action = "GIVE_CARD",
								id = Id
							},
							{
								action = "GO_TO_DOOR",
								slot = DoorSlot.UP0
							},
							{
								action = "WAIT_FOR_SECONDS",
								seconds = 1
							},
							{
								action = "USE_CARD"
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
