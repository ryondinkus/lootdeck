local H = {}

-- helper function for using FindRandomEnemy with noDupes, resets chosen enemy counter in case of multiple uses of tower card, for example
function H.ClearChosens(pos)
    local entities = Isaac.FindInRadius(pos, 875, EntityPartition.ENEMY)
    for i, entity in pairs(entities) do
        local data = entity:GetData()
        if data.chosen then
            data.chosen = nil
        end
    end
end

function H.ListEnemiesInRoom(pos, ignoreChosen, tag, ignoreVulnerability, chosenTag)
	local entities = Isaac.FindInRadius(pos, 1875, EntityPartition.ENEMY)
	local enemies = {}
	local key = 1;
	for i, entity in pairs(entities) do
		if (ignoreVulnerability or entity:IsVulnerableEnemy()) and (ignoreChosen or not entity:GetData()[chosenTag or "chosen"]) then
            if not tag or entity:GetData()[tag] then
                enemies[key] = entities[i]
                key = key + 1;
            end
		end
	end
	return enemies
end

function H.ListBossesInRoom(pos, ignoreMiniBosses)
	local enemies = H.ListEnemiesInRoom(pos, true, nil, true)
    local bosses = {}

    for _, enemy in pairs(enemies) do
        if enemy:IsBoss() and (enemy.Type == EntityType.ENTITY_THE_HAUNT or enemy.Type == EntityType.ENTITY_MASK_OF_INFAMY or enemy:IsVulnerableEnemy()) and (not ignoreMiniBosses or (ignoreMiniBosses and (enemy.SpawnerType == 0 or enemy.SpawnerType == EntityType.ENTITY_MASK_OF_INFAMY or enemy.SpawnerType == EntityType.ENTITY_THE_HAUNT))) then
            table.insert(bosses, enemy)
        end
    end

    return bosses
end

-- function for finding random enemy in the room
function H.FindRandomEnemy(pos, noDupes, ignoreChosen, tag)
	local enemies = H.ListEnemiesInRoom(pos, ignoreChosen, tag)
    local chosenEnt = enemies[lootdeck.rng:RandomInt(#enemies)+1]
    if chosenEnt then chosenEnt:GetData().chosen = noDupes end
    return chosenEnt
end

-- function for registering basic loot cards that spawn items
function H.SimpleLootCardSpawn(p, spawnType, spawnVariant, spawnSubtype, uses, position, sound, effect, effectAmount)
    if effect then
        for i=1,(effectAmount or 1) do
            Isaac.Spawn(EntityType.ENTITY_EFFECT, effect, 0, position or p.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), p)
        end
    end
    if sound then
        lootdeck.sfx:Play(sound)
    end
    for i = 1,(uses or 1) do
        Isaac.Spawn(spawnType, spawnVariant or 0, spawnSubtype or 0, position or p.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), p)
    end
end

function H.StaggerSpawn(key, p, interval, occurences, callback, onEnd, noAutoDecrement)
	local data = p:GetData()
    if data[key] == 1 then
		local timerName = string.format("%sTimer", key)
		local counterName = string.format("%sCounter", key)
		if not data[timerName] then data[timerName] = 0 end
		if not data[counterName] then data[counterName] = occurences end

        data[timerName] = data[timerName] - 1
        if data[timerName] <= 0 then
			callback(p, counterName)
            data[timerName] = interval
			if noAutoDecrement ~= 1 then
				data[counterName] = data[counterName] - 1
			end
            if data[counterName] <= 0 then
                data[key] = nil
				data[timerName] = nil
				data[counterName] = nil
				if onEnd then
					onEnd(p)
				end
            end
        end
    end
end

-- function for registering basic loot cards that copy item effects
function H.SimpleLootCardEffect(p, itemEffect, sound)
    p:UseActiveItem(itemEffect, false)
    if sound then
        lootdeck.sfx:Play(sound,1,0)
    end
end

-- function for registering basic loot cards that give items
function H.SimpleLootCardItem(p, itemID, sound)
    p:AddCollectible(itemID)
    if sound then
        lootdeck.sfx:Play(sound,1,0)
    end
end

-- function to convert tearflags to new BitSet128
function H.NewTearflag(x)
    return x >= 64 and BitSet128(0,1<<(x - 64)) or BitSet128(1<<x,0)
end

-- function to check if player can only use soul/black hearts
function H.IsSoulHeartMarty(p)
    local soulHeartMarties = {
        PlayerType.PLAYER_XXX,
        PlayerType.PLAYER_BLACKJUDAS,
        PlayerType.PLAYER_THELOST,
        PlayerType.PLAYER_THESOUL,
        PlayerType.PLAYER_JUDAS_B,
        PlayerType.PLAYER_XXX_B,
        PlayerType.PLAYER_THELOST_B,
        PlayerType.PLAYER_THESOUL_B,
        PlayerType.PLAYER_BETHANY_B,
    }
    for i,v in ipairs(soulHeartMarties) do
        if p:GetPlayerType() == v then
            return true
        end
    end
    return false
end

-- function that returns a consumable based on what glyph of balance would drop
function H.GlyphOfBalance(p)
    if p:GetMaxHearts() <= 0 and p:GetSoulHearts() <= 4 then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}
    elseif p:GetHearts() <= 1 then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL}
    elseif p:GetNumKeys() <= 0 then
        return {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL}
    elseif p:GetNumBombs() <= 0 then
        return {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL}
    elseif p:GetHearts() < p:GetMaxHearts() then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL}
    elseif p:GetNumCoins() < 15 then
        return {PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY}
    elseif p:GetNumKeys() < 5 then
        return {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL}
    elseif p:GetNumBombs() < 5 then
        return {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL}
    elseif p:GetTrinket(0) == 0 and not H.AreTrinketsOnGround() then
        return {PickupVariant.PICKUP_TRINKET, 0}
    elseif p:GetHearts() + p:GetSoulHearts() < 12 then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}
    else
        return {(lootdeck.rng:RandomInt(4)+1)*10, 1}
    end
end

function H.RemoveHeartsOnNewRoomEnter(player, hpValue)
    for i=1,hpValue do
		if H.GetPlayerHeartTotal(player) > 2 then
        	player:AddMaxHearts(-2)
		end
    end
end

function H.GetPlayerOrSubPlayerByType(player, type)
    if (player:GetPlayerType() == type) then
        return player
    elseif (player:GetSubPlayer():GetPlayerType() == type) then
        return player:GetSubPlayer()
    end
    return nil
end

function H.GetPlayerHeartTotal(p)
    local heartTotal = p:GetMaxHearts()
    if H.IsSoulHeartMarty(p) then heartTotal = heartTotal + p:GetSoulHearts() end
    if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then heartTotal = heartTotal + (p:GetBoneHearts() * 2) end
    return heartTotal
end

function H.FindHealthToAdd(p, hp)
    local heartTotal = H.GetPlayerHeartTotal(p)
    if heartTotal < p:GetHeartLimit() then
        local remainder = math.floor((p:GetHeartLimit() - heartTotal)/2)
        local amountToAdd = math.floor(hp/2)
        if remainder < amountToAdd then amountToAdd = remainder end
		return amountToAdd
    end
    return 0
end

function H.AddTemporaryHealth(p, hp) -- hp is calculated in half hearts
	local data = p:GetData()
    local amountToAdd = H.FindHealthToAdd(p, hp)
    if p:GetPlayerType() == PlayerType.PLAYER_THESOUL then
        if not data.soulHp then data.soulHp = 0 end
        data.soulHp = data.soulHp + amountToAdd
    else
        if not data.redHp then data.redHp = 0 end
        data.redHp = data.redHp + amountToAdd
    end
    p:AddMaxHearts(hp)
    p:AddHearts(hp)
    lootdeck.sfx:Play(SoundEffect.SOUND_VAMP_GULP,1,0)
end

function H.TableContains(table, element)
	for _, value in pairs(table) do
		if value == element then
	    	return true
	    end
	end
	return false
end

function H.TakeSelfDamage(p, dmg, canKill)
	local flags = (DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS | DamageFlag.DAMAGE_NO_PENALTIES)
	if not canKill then flags = flags | DamageFlag.DAMAGE_NOKILL end
	p:TakeDamage(dmg,flags,EntityRef(p),0)
	p:ResetDamageCooldown()
end

function H.IsEntityInTable(table, entity)
	for _,v in pairs(table) do
		if entity.Type == v[1]
		and entity.Variant == v[2] or nil
		and entity.SubType == v[3] or nil then
			return true
		end
	end
	return false
end

function H.HolyMantleEffect(p, damageCooldown)
    lootdeck.sfx:Play(SoundEffect.SOUND_HOLY_MANTLE,1,0)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 11, p.Position, Vector.Zero, p)
    p:SetMinDamageCooldown(damageCooldown or 30)
end

function H.CheckFinalFloorBossKilled()
	local level = Game():GetLevel()
	local labyrinth = level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH > 0
	if (lootdeck.f.floorBossCleared == 1 and not labyrinth)
	or (lootdeck.f.floorBossCleared == 2 and labyrinth) then
		return true
	end
	return false
end

function H.LengthOfTable(t)
    local num = 0
    for _ in pairs(t) do
        num = num + 1
    end
    return num
end

function H.FindItemInTableByKey(table, key, value)
    for _, item in pairs(table) do
        if item[key] == value then
            return item
        end
    end
end

function H.RevivePlayerPostPlayerUpdate(p, tag, reviveTag, callback)
    local game = Game()
    local data = p:GetData()
    local sprite = p:GetSprite()
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    if (sprite:IsPlaying("Death") and sprite:GetFrame() == 55)
	or (sprite:IsPlaying("LostDeath") and sprite:GetFrame() == 37)
	or (sprite:IsPlaying("ForgottenDeath") and sprite:GetFrame() == 19) then
        if data[reviveTag] then
            if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                p:AddBoneHearts(1)
            end
            p:Revive()
			p:SetMinDamageCooldown(60)
			if p:GetOtherTwin() then
				p:GetOtherTwin():Revive()
				p:GetOtherTwin():SetMinDamageCooldown(60)
			end
            data[tag] = true
            local enterDoor = level.EnterDoor
            local door = room:GetDoor(enterDoor)
            local direction = door and door.Direction or Direction.NO_DIRECTION
            game:StartRoomTransition(level:GetPreviousRoomIndex(),direction,0)
            level.LeaveDoor = enterDoor
            if callback then
                callback()
            end
        end
    end
end

function H.GetWeightedLootCardId()
    local cards = lootcards
    if H.LengthOfTable(cards) > 0 then
        local csum = 0
        local outcome = cards[0]
        for _, card in pairs(cards) do
            local weight = card.Weight
            local r = lootdeck.rng:RandomInt(csum + weight)
            if r >= csum then
                outcome = card
            end
            csum = csum + weight
        end
        return outcome.Id
    end
end

function H.FuckYou(p, type, variant, subtype, uses)
    lootdeck.sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,1,0)
    if type then
        for i = 1,(uses or 1) do
            Isaac.Spawn(type, variant or 0, subtype or 0, Game():GetRoom():FindFreePickupSpawnPosition(p.Position), Vector.Zero, p)
        end
    end
end

function H.FeckDechoEdmundMcmillen(player, pickup)
    return not (pickup.Variant == 90 and not (player:NeedsCharge(0) or player:NeedsCharge(1) or player:NeedsCharge(2) or player:NeedsCharge(3)))
    and not (pickup.Variant == 10 and (pickup.SubType == 1 or pickup.SubType == 2 or pickup.SubType == 5 or pickup.SubType == 9) and not player:CanPickRedHearts())
    and not (pickup.Variant == 10 and (pickup.SubType == 3 or pickup.SubType == 8 or pickup.SubType == 10) and not player:CanPickSoulHearts())
    and not (pickup.Variant == 10 and pickup.SubType == 6 and not player:CanPickBlackHearts())
    and not (pickup.Variant == 10 and pickup.SubType == 7 and not player:CanPickGoldenHearts())
    and not (pickup.Variant == 10 and pickup.SubType == 11 and not player:CanPickBoneHearts())
    and not (pickup.Variant == 10 and pickup.SubType == 12 and not player:CanPickRottenHearts())
end

function H.CanBuyPickup(player, pickup)
	if pickup.Price > -6 and pickup.Price ~= 0 and not player:IsHoldingItem() then
        if (pickup.Price == -1 and player:GetMaxHearts() >= 2)
        or (pickup.Price == -2 and player:GetMaxHearts() >= 4)
        or (pickup.Price == -3 and player:GetSoulHearts() >= 6)
        or (pickup.Price == -4 and player:GetMaxHearts() >= 2 and player:GetSoulHearts() >= 4)    -- this devil deal is affordable--and player:GetDamageCooldown() <= 0)
		then
            return true
        elseif pickup.Price > 0 and player:GetNumCoins() >= pickup.Price    -- this shop item is affordable
        and H.FeckDechoEdmundMcmillen(player, pickup) then
            return true
        end
    end
	return false
end

function H.CalculateRefund(price)
	if price == -1 then
		return {
			EntityType.ENTITY_PICKUP,
			PickupVariant.PICKUP_PILL,
			Isaac.AddPillEffectToPool(PillEffect.PILLEFFECT_HEALTH_UP),
			1
		}
	end
	if price == -2 then
		return {
			EntityType.ENTITY_PICKUP,
			PickupVariant.PICKUP_PILL,
			Isaac.AddPillEffectToPool(PillEffect.PILLEFFECT_HEALTH_UP),
			2
		}
	end
	if price == -3 then
		return {
			EntityType.ENTITY_PICKUP,
			PickupVariant.PICKUP_HEART,
			HeartSubType.HEART_SOUL,
			3
		}
	end
	if price == -4 then
		return {
			EntityType.ENTITY_PICKUP,
			PickupVariant.PICKUP_PILL,
			Isaac.AddPillEffectToPool(PillEffect.PILLEFFECT_HEALTH_UP),
			1,
			EntityType.ENTITY_PICKUP,
			PickupVariant.PICKUP_HEART,
			HeartSubType.HEART_SOUL,
			2
		}
	end
	if price == -5 then
		return {
			EntityType.ENTITY_PICKUP,
			PickupVariant.PICKUP_HEART,
			HeartSubType.HEART_BLENDED,
			1
		}
	end
	return {
		EntityType.ENTITY_PICKUP,
		PickupVariant.PICKUP_COIN,
		CoinSubType.COIN_PENNY,
		price
	}
end

function H.AreEnemiesInRoom(room)
    return room:GetAliveEnemiesCount() ~= 0
end

function H.HasActiveItem(p)
    for i=0,3 do
        if p:GetActiveItem(i) ~= 0 then
            return true
        end
    end
    return false
end

function H.CheckForSecretRooms(room)
    for i=0,7 do
        local door = room:GetDoor(i)
        if door ~= nil then
            if (door:IsRoomType(RoomType.ROOM_SECRET) or door:IsRoomType(RoomType.ROOM_SUPERSECRET)) and door:GetSprite():GetAnimation() == "Hidden" then
                return door.Position
            end
        end
    end
end

function H.CheckForTintedRocks(room)
    for i=0,room:GetGridSize() do
        local rock = room:GetGridEntity(i)
        if rock then
            if rock.CollisionClass ~= 0 and (rock:GetType() == GridEntityType.GRID_ROCKT or rock:GetType() == GridEntityType.GRID_ROCK_SS) then
                return room:GetGridPosition(i)
            end
        end
    end
end

function H.TriggerOnRoomEntryPEffectUpdate(p, collectibleId, initialize, callback, tag, finishedTag, roomClearedTag, greedModeWaveTag, bossRushBossesTag)
    local data = p:GetData()
    local game = Game()
    if not data[roomClearedTag] and not H.AreEnemiesInRoom(game:GetRoom()) then
        data[roomClearedTag] = true
    end

    local isFinished = (data[finishedTag] or data[finishedTag] == nil)
    local isBossRush = game:GetRoom():GetType() == RoomType.ROOM_BOSSRUSH

    local currentBosses = H.ListBossesInRoom(p.Position, true)

    local shouldInitializeBecauseOfBossRush = true

    if isBossRush and (data[bossRushBossesTag] == nil or (data[bossRushBossesTag] and data[bossRushBossesTag] == 0)) and #currentBosses ~= 0 then
        for _, boss in pairs(currentBosses) do
            local bossData = boss:GetData()
            if bossData[tag] == true then
                shouldInitializeBecauseOfBossRush = false
                break
            end
        end
    else
        shouldInitializeBecauseOfBossRush = false
    end

    if p:HasCollectible(collectibleId) and ((not isBossRush and isFinished and (data[roomClearedTag] and H.AreEnemiesInRoom(game:GetRoom()))) or (game:IsGreedMode() and data[greedModeWaveTag] ~= game:GetLevel().GreedModeWave) or (isBossRush and shouldInitializeBecauseOfBossRush)) then
        initialize(p)
    end

    if game:IsGreedMode() then
        data[greedModeWaveTag] = game:GetLevel().GreedModeWave
    end

    if isBossRush then
        data[bossRushBossesTag] = #currentBosses
        for _, boss in pairs(currentBosses) do
            local bossData = boss:GetData()
            bossData[tag] = true
        end
    end

    callback()
end

function H.ForEachPlayer(callback, collectibleId)
    for x = 0, Game():GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(x)
        if not collectibleId or (collectibleId and p:HasCollectible(collectibleId)) then
            local p = Isaac.GetPlayer(x)
            callback(p, p:GetData())
        end
    end
end

function H.ForEachEntityInRoom(callback, entityType, entityVariant, entitySubType, extraFilters)
    local filters = {
        Type = entityType,
        Variant = entityVariant,
        SubType = entitySubType
    }

    local initialEntities = Isaac.GetRoomEntities()

    for _, entity in ipairs(initialEntities) do
        local shouldReturn = true
        for entityKey, filter in pairs(filters) do
            if not shouldReturn then
                break
            end

            if filter ~= nil then
                if type(filter) == "function" then
                    shouldReturn = filter(entity[entityKey])
                else
                    shouldReturn = entity[entityKey] == filter
                end
            end
        end

        if shouldReturn and extraFilters ~= nil then
            shouldReturn = extraFilters(entity)
        end

        if shouldReturn then
            callback(entity)
        end
	  end
end

-- helper function for GlyphOfBalance(), makes shit less ocopmlicationsed
function H.AreTrinketsOnGround()
    local isTrinketOnGround = false
    H.ForEachEntityInRoom(function()
        isTrinketOnGround = true
    end, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)
    return isTrinketOnGround
end

function H.RemoveHitFamiliars(id, hitTag)
    H.ForEachEntityInRoom(function(entity)
        entity:Remove()
    end, EntityType.ENTITY_FAMILIAR, id, nil, function(entity)
        return entity:GetData()[hitTag or 'hit'] == true
    end)
end

function H.PercentageChance(percent, max)
    local value
    if percent > (max or 100) then
        value = max
    else
        value = percent
    end
    return lootdeck.rng:RandomInt(99) <= value
end

-- https://github.com/IsaacScript/isaacscript-common/blob/main/src/functions/ui.ts#L7-L49
function H.GetHUDOffsetVector()
    local defaultVector = Vector.Zero

    if ModConfigMenu and ModConfigMenu.Config and ModConfigMenu.Config.General then
        local hudOffset = ModConfigMenu.Config.General.HudOffset

        if hudOffset and type(hudOffset) == "number" and hudOffset >= 1 and hudOffset <= 10 then
            local x  = hudOffset * 2
            local y = hudOffset

            if y >= 4 then
                y = y + 1
            end
            if y >= 9 then
                y = y + 1
            end

            return Vector(x, y)
        end
    end
    return defaultVector
end

function H.GetLootcardById(id)
    for _, card in pairs(lootcards) do
        if card.Id == id then
            return card
        end
    end
end

function H.RegisterSprite(anm2Root, sprRoot, anmName)
	local sprite = Sprite()
	sprite:Load(anm2Root, true)
	sprite:Play(anmName and anmName or sprite:GetDefaultAnimationName(), true)
	sprite:Update()
	if sprRoot then sprite:ReplaceSpritesheet(0, sprRoot) end
	sprite:LoadGraphics()

	return sprite
end

function H.GetScreenSize(customX, customY)
    local room = Game():GetRoom()
    local pos = Isaac.WorldToScreen(Vector.Zero) - room:GetRenderScrollOffset() - Game().ScreenShakeOffset

    local rx = pos.X + 60 * 26 / 40
    local ry = pos.Y + 140 * (26 / 40)

    return Vector(customX or rx*2 + 13*26, customY or ry*2 + 7*26)
end

function H.GetPlayerControllerIndex(p)
    local controllerIndexes = {}
    H.ForEachPlayer(function(player)
        for _, index in pairs(controllerIndexes) do
            if index == player.ControllerIndex then
                return
            end
        end
        table.insert(controllerIndexes, player.ControllerIndex)
    end)
    for i, index in pairs(controllerIndexes) do
        if index == p.ControllerIndex then
            return i - 1
        end
    end
end

function H.GetCardPositionWithHUDOffset(p, sprite)
    local controllerIndex = H.GetPlayerControllerIndex(p)
    local BottomRight = H.GetScreenSize()
    local BottomLeft = H.GetScreenSize(0)
    local TopRight = H.GetScreenSize(nil, 0)
    local fuckOffVector = Vector(5000, 5000)

    local hudOffset = nil

    if ModConfigMenu and ModConfigMenu.Config and ModConfigMenu.Config.General then
        hudOffset = ModConfigMenu.Config.General.HudOffset

        if not hudOffset or type(hudOffset) ~= "number" or hudOffset < 1 or hudOffset > 10 then
            hudOffset = nil
        end
    end

    local hudOffsetVector = Vector.Zero

    if controllerIndex ~= 0 and p.SubType == PlayerType.PLAYER_ESAU then
        return fuckOffVector
    end

    -- Jacob in first player slot
    if controllerIndex == 0 and p.SubType == PlayerType.PLAYER_JACOB then
        if hudOffset then
            if hudOffset == 1 then
                hudOffsetVector = Vector(2, 1)
            elseif hudOffset == 2 then
                hudOffsetVector = Vector(4, 2.5)
            elseif hudOffset == 3 then
                hudOffsetVector = Vector(6, 3.5)
            elseif hudOffset == 4 then
                hudOffsetVector = Vector(8, 5)
            elseif hudOffset == 5 then
                hudOffsetVector = Vector(10, 6)
            elseif hudOffset == 6 then
                hudOffsetVector = Vector(12, 7)
            elseif hudOffset == 7 then
                hudOffsetVector = Vector(14, 8.5)
            elseif hudOffset == 8 then
                hudOffsetVector = Vector(16, 9.5)
            elseif hudOffset == 9 then
                hudOffsetVector = Vector(18, 11)
            elseif hudOffset == 10 then
                hudOffsetVector = Vector(20, 12)
            end
        end
        return Vector(11, 41) + hudOffsetVector
    end

    -- Esau in second player slot
    if controllerIndex == 0 and p.SubType == PlayerType.PLAYER_ESAU then
        if hudOffset then
            if hudOffset == 1 then
                hudOffsetVector = Vector(1.5, 0.5)
            elseif hudOffset == 2 then
                hudOffsetVector = Vector(3, 1)
            elseif hudOffset == 3 then
                hudOffsetVector = Vector(5, 2)
            elseif hudOffset == 4 then
                hudOffsetVector = Vector(6.5, 2.5)
            elseif hudOffset == 5 then
                hudOffsetVector = Vector(8, 3)
            elseif hudOffset == 6 then
                hudOffsetVector = Vector(9.5, 3.5)
            elseif hudOffset == 7 then
                hudOffsetVector = Vector(11, 4)
            elseif hudOffset == 8 then
                hudOffsetVector = Vector(13, 5)
            elseif hudOffset == 9 then
                hudOffsetVector = Vector(14.5, 5.5)
            elseif hudOffset == 10 then
                hudOffsetVector = Vector(16, 6)
            end
        end
        return Vector(BottomRight.X - 10, BottomRight.Y - 44) - hudOffsetVector
    end

    -- Player 2 (top right)
    if controllerIndex == 1 and p.SubType ~= PlayerType.PLAYER_ESAU then
        sprite.Scale = Vector(0.5, 0.5)
        if hudOffset then
            if hudOffset == 1 then
                hudOffsetVector = Vector(-2.5, 1)
            elseif hudOffset == 2 then
                hudOffsetVector = Vector(-5, 2.5)
            elseif hudOffset == 3 then
                hudOffsetVector = Vector(-7, 3.5)
            elseif hudOffset == 4 then
                hudOffsetVector = Vector(-9.5, 5)
            elseif hudOffset == 5 then
                hudOffsetVector = Vector(-12, 6)
            elseif hudOffset == 6 then
                hudOffsetVector = Vector(-14.5, 7)
            elseif hudOffset == 7 then
                hudOffsetVector = Vector(-17, 8.5)
            elseif hudOffset == 8 then
                hudOffsetVector = Vector(-19, 9.5)
            elseif hudOffset == 9 then
                hudOffsetVector = Vector(-21.5, 11)
            elseif hudOffset == 10 then
                hudOffsetVector = Vector(-24, 12)
            end
        end
        return Vector(TopRight.X - 147, TopRight.Y + 44) + hudOffsetVector
    end

    -- Player 3 (bottom left)
    if controllerIndex == 2 and p.SubType ~= PlayerType.PLAYER_ESAU then
        sprite.Scale = Vector(0.5, 0.5)
        if hudOffset then
            if hudOffset == 1 then
                hudOffsetVector = Vector(2.5, -0.5)
            elseif hudOffset == 2 then
                hudOffsetVector = Vector(5, -1)
            elseif hudOffset == 3 then
                hudOffsetVector = Vector(7, -2)
            elseif hudOffset == 4 then
                hudOffsetVector = Vector(9.5, -2.5)
            elseif hudOffset == 5 then
                hudOffsetVector = Vector(11.5, -3)
            elseif hudOffset == 6 then
                hudOffsetVector = Vector(13.5, -3.5)
            elseif hudOffset == 7 then
                hudOffsetVector = Vector(16, -4)
            elseif hudOffset == 8 then
                hudOffsetVector = Vector(18, -5)
            elseif hudOffset == 9 then
                hudOffsetVector = Vector(20.5, -5.5)
            elseif hudOffset == 10 then
                hudOffsetVector = Vector(22.5, -6)
            end
        end
        return Vector(BottomLeft.X + 21.5, BottomLeft.Y + 5) + hudOffsetVector
    end

    -- Player 4 (bottom right)
    if controllerIndex == 3 and p.SubType ~= PlayerType.PLAYER_ESAU then
        sprite.Scale = Vector(0.5, 0.5)
        if hudOffset then
            if hudOffset == 1 then
                hudOffsetVector = Vector(2.5, 1)
            elseif hudOffset == 2 then
                hudOffsetVector = Vector(4, 1.5)
            elseif hudOffset == 3 then
                hudOffsetVector = Vector(6, 2.5)
            elseif hudOffset == 4 then
                hudOffsetVector = Vector(7.5, 3)
            elseif hudOffset == 5 then
                hudOffsetVector = Vector(9, 3.5)
            elseif hudOffset == 6 then
                hudOffsetVector = Vector(10.5, 4)
            elseif hudOffset == 7 then
                hudOffsetVector = Vector(12, 4.5)
            elseif hudOffset == 8 then
                hudOffsetVector = Vector(14, 5.5)
            elseif hudOffset == 9 then
                hudOffsetVector = Vector(15.5, 6)
            elseif hudOffset == 10 then
                hudOffsetVector = Vector(17, 6.5)
            end
        end
        return Vector(BottomRight.X - 154, BottomRight.Y + 5.5) - hudOffsetVector
    end

    if hudOffset then
        if hudOffset == 1 then
            hudOffsetVector = Vector(1.5, 0.5)
        elseif hudOffset == 2 then
            hudOffsetVector = Vector(3, 1)
        elseif hudOffset == 3 then
            hudOffsetVector = Vector(5, 2)
        elseif hudOffset == 4 then
            hudOffsetVector = Vector(6.5, 2.5)
        elseif hudOffset == 5 then
            hudOffsetVector = Vector(8, 3)
        elseif hudOffset == 6 then
            hudOffsetVector = Vector(9.5, 3.5)
        elseif hudOffset == 7 then
            hudOffsetVector = Vector(11, 4)
        elseif hudOffset == 8 then
            hudOffsetVector = Vector(13, 5)
        elseif hudOffset == 9 then
            hudOffsetVector = Vector(14.5, 5.5)
        elseif hudOffset == 10 then
            hudOffsetVector = Vector(16, 6)
        end
    end
    return Vector(BottomRight.X - 15, BottomRight.Y - 12) - hudOffsetVector
end

function H.GetPlayerInventory(p)
    local itemConfig = Isaac.GetItemConfig()
    local numCollectibles = #itemConfig:GetCollectibles()
    local inv = {}
    for i = 1, numCollectibles do
        if itemConfig:GetCollectible(i) then
            inv[i] = p:GetCollectibleNum(i)
        end
    end
    local allHeld = {}
	for id, numOwned in pairs(inv) do
		if numOwned > 0 then
			for i = 1, numOwned do
				allHeld[#allHeld + 1] = id
			end
		end
	end
    return allHeld
end

return H
