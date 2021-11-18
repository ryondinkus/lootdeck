local json = include("json")
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

function H.ListEnemiesInRoom(pos, ignoreChosen, tag, ignoreVulnerability, chosenTag, filter)
	local entities = Isaac.FindInRadius(pos, 1875, EntityPartition.ENEMY)
	local enemies = {}
	local key = 1;
	for i, entity in pairs(entities) do
		if (ignoreVulnerability or entity:IsVulnerableEnemy()) and (ignoreChosen or not entity:GetData()[chosenTag or "chosen"]) then
            if not tag or entity:GetData()[tag] then
                if not filter or filter(entity) then
                    enemies[key] = entities[i]
                    key = key + 1;
                end
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
function H.FindRandomEnemy(pos, noDupes, ignoreChosen, tag, filter)
	local enemies = H.ListEnemiesInRoom(pos, ignoreChosen, tag, false, nil, filter)
    local chosenEnt = enemies[lootdeck.rng:RandomInt(#enemies)+1]
    if chosenEnt then chosenEnt:GetData().chosen = noDupes end
    return chosenEnt
end

function H.StaggerSpawn(key, p, interval, occurences, callback, onEnd, noAutoDecrement)
	local data = p:GetData()
    if data[key] and data[key] > 0 then
		local timerName = key.."Timer"
		local counterName = key.."Counter"
		if not data[timerName] then data[timerName] = 0 end
		if not data[counterName] then data[counterName] = occurences end

        data[timerName] = data[timerName] - 1
        if data[timerName] <= 0 then
			callback(p, counterName)
            if data[key] >= 2 then
                callback(p, counterName)
            end
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
function H.IsSoulHeartFarty(p)
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
    if H.IsSoulHeartFarty(p) then heartTotal = heartTotal + p:GetSoulHearts() end
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
    if table then
        for _, value in pairs(table) do
            if value == element then
                return true
            end
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

function H.HolyMantleDamage(damageAmount, damageFlags, damageSource)
    local ignoreFlags = DamageFlag.DAMAGE_DEVIL | DamageFlag.DAMAGE_IV_BAG | DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_RED_HEARTS
    local includeFlags = DamageFlag.DAMAGE_CURSED_DOOR
    if (Game():GetRoom():GetType() == RoomType.ROOM_SACRIFICE and damageSource.Type == 0) then
        includeFlags = includeFlags | DamageFlag.DAMAGE_SPIKES
    end
    if (Game():GetRoom():GetType() == RoomType.ROOM_SHOP and damageSource.Type == 0 and (damageFlags & (DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_SPIKES) ~= 0)) then
        ignoreFlags = ignoreFlags | DamageFlag.DAMAGE_SPIKES
    end
    if damageAmount > 0
    and ((damageSource and damageSource.Type ~= EntityType.ENTITY_SLOT) or not damageSource)
    and ((damageFlags & ignoreFlags == 0) or (damageFlags & includeFlags ~= 0)) then
        return true
    end
    return false
end

function H.HolyMantleEffect(p, sound, effect, effectSubtype)
    lootdeck.sfx:Play(sound or SoundEffect.SOUND_HOLY_MANTLE,1,0)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, effect or EffectVariant.POOF02, effectSubtype or 11, p.Position, Vector.Zero, p)
    p:SetMinDamageCooldown(60)
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
            H.SpawnEntity(type, variant or 0, subtype or 0, Game():GetRoom():FindFreePickupSpawnPosition(p.Position), Vector.Zero, p)
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
    local shouldReturn = nil
    for x = 0, Game():GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(x)
        if not collectibleId or (collectibleId and p:HasCollectible(collectibleId)) then
            local p = Isaac.GetPlayer(x)
            if callback(p, p:GetData()) == false then
                shouldReturn = false
            end
        end
    end
    return shouldReturn
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
        return entity:GetData()[hitTag] == true
    end)
end

function H.PercentageChance(percent, max)
    local value
    if percent > (max or 100) then
        value = max or 100
    else
        value = percent
    end
    return lootdeck.rng:RandomInt(99) <= value
end

function H.GetLootcardById(id)
    for _, card in pairs(lootcards) do
        if card.Id == id then
            return card
        end
    end
end

function H.GetPlayerInventory(p, ignoreId, ignoreActives)
    local itemConfig = Isaac.GetItemConfig()
    local numCollectibles = #itemConfig:GetCollectibles()
    local inv = {}
    for i = 1, numCollectibles do
        local collectible = itemConfig:GetCollectible(i)
        if collectible and (not ignoreActives or collectible.Type ~= ItemType.ITEM_ACTIVE) then
            inv[i] = p:GetCollectibleNum(i)
        end
    end
    local allHeld = {}
	for id, numOwned in pairs(inv) do
		if numOwned > 0 then
			for i = 1, numOwned do
                if not ignoreId or ignoreId ~= id then
				    allHeld[#allHeld + 1] = id
                end
			end
		end
	end
    return allHeld
end

function H.GetRandomItemIdInInventory(p, ignoreId, ignoreActives)
    local inventory = H.GetPlayerInventory(p, ignoreId, ignoreActives)

    local itemIndex = lootdeck.rng:RandomInt(#inventory) + 1

    return inventory[itemIndex]
end

function H.sign(x)
  return x > 0 and 1 or x < 0 and -1 or 0
end

function H.CustomCoinPrePickupCollision(pi, e, amount, sfx, isFinished)
    local p = e:ToPlayer() or 0
    local data = pi:GetData()
    local sprite = pi:GetSprite()
    if p ~= 0 then
         if data.canTake then
            p:AddCoins(amount)
            if sfx then
               lootdeck.sfx:Play(sfx)
            end
            pi.Velocity = Vector.Zero
            pi.Touched = true
            pi.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            sprite:Play("Collect", true)
            if isFinished then
                isFinished(p)
            end
            pi:Die()
        end
    end
end

function H.CustomCoinPickupUpdate(pi, sfx)
    local data = pi:GetData()
    local sprite = pi:GetSprite()
    if sfx and sprite:IsEventTriggered("DropSound") then
        lootdeck.sfx:Play(sfx)
    end
    if not sprite:IsPlaying("Collect") and not sprite:IsFinished("Collect") and (((sprite:IsPlaying("Appear") or sprite:IsPlaying("Reappear")) and sprite:IsEventTriggered("DropSound")) or sprite:IsPlaying("Idle")) and not data.canTake then
        data.canTake = true
    end
end

function H.GetPlayerSpriteOffset(p)
    local flyingOffset = p:GetFlyingOffset()
	if p.SubType == PlayerType.PLAYER_THEFORGOTTEN_B and p.PositionOffset.Y < -38 then
		flyingOffset = p:GetOtherTwin():GetFlyingOffset() - Vector(0,2)
	end
	local offsetVector = Vector(0,60) - p.PositionOffset - flyingOffset
    return offsetVector
end

function H.AddActiveCharge(p, value, animate)
    if animate then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BATTERY, 0, p.Position - H.GetPlayerSpriteOffset(p), Vector.Zero, p)
    end
    lootdeck.sfx:Play(SoundEffect.SOUND_BATTERYCHARGE,1,0)
    for i=0,3 do
        if p:GetActiveItem(i) ~= 0 then
            if p:NeedsCharge(i) then
                p:SetActiveCharge(p:GetActiveCharge(i) + value, i)
                if not p:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and p:GetBatteryCharge(i) > 0 then
                    p:SetActiveCharge(p:GetActiveCharge(i), i)
                end
                Game():GetHUD():FlashChargeBar(p, i)
                return
            end
        end
    end
end

function H.GenerateEncyclopediaPage(...)
    local output = {
        {str = "Effect", fsize = 2, clr = 3, halign = 0}
    }

    for _, description in pairs({...}) do
        table.insert(output, {str = description})
    end

    return {output}
end

function H.SaveData(data)
    lootdeck:SaveData(json.encode(data))
end

function H.LoadData()
    if lootdeck:HasData() then
        return json.decode(lootdeck:LoadData())
    end
end

function H.SaveKey(key, value)
    local savedData = {}
    if lootdeck:HasData() then
        savedData = json.decode(lootdeck:LoadData())
    end
    savedData[key] = value
    lootdeck:SaveData(json.encode(savedData))
end

function H.LoadKey(key)
    if lootdeck:HasData() then
        return json.decode(lootdeck:LoadData())[key]
    end
end

function H.AddExternalItemDescriptionCard(card)
	if EID and card.Descriptions then
        H.RegisterExternalItemDescriptionLanguages(card, EID.addCard)
		local cardFrontPath = string.format("gfx/ui/lootcard_fronts/%s.png", card.Tag)
		local cardFrontSprite = Sprite()
        cardFrontSprite:Load("gfx/ui/eid_lootcard_fronts.anm2", true)
		cardFrontSprite:ReplaceSpritesheet(0, cardFrontPath)
		cardFrontSprite:LoadGraphics()
		EID:addIcon("Card"..card.Id, "Idle", -1, 8, 8, 0, 1, cardFrontSprite)
	end
end

function H.AddExternalItemDescriptionItem(item)
	if EID and item.Descriptions then
        H.RegisterExternalItemDescriptionLanguages(item, EID.addCollectible)
	end
end

function H.AddExternalItemDescriptionTrinket(trinket)
	if EID and trinket.Descriptions then
        H.RegisterExternalItemDescriptionLanguages(trinket, EID.addTrinket)
	end
end

function H.RegisterExternalItemDescriptionLanguages(obj, func)
    for language, description in pairs(obj.Descriptions) do
        func(EID, obj.Id, description, obj.Names[language], language)
    end
end

function H.IsInChallenge(challengeName)
    local challengeId = Isaac.GetChallengeIdByName(challengeName)
    return Isaac.GetChallenge() == challengeId
end

function H.Spawn(type, variant, subType, position, velocity, spawner)
    local entity = Isaac.Spawn(type, variant or 0, subType or 0, position, velocity, spawner)
    if Isaac.GetChallenge() == lootdeckChallenges.gimmeTheLoot.Id then
        entity:GetData()[lootdeckChallenges.gimmeTheLoot.Tag] = true
    end

    return entity
end

-- function for registering basic loot cards that spawn items
function H.SpawnEntity(p, spawnType, spawnVariant, spawnSubtype, uses, position, sound, effect, effectAmount)
    local output = {
        effects = {},
        entities = {}
    }
    if effect then
        for i=1,(effectAmount or 1) do
            local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, effect, 0, position or p.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), p)
            table.insert(output.effects, effect)
        end
    end
    if sound then
        lootdeck.sfx:Play(sound)
    end
    for i = 1,(uses or 1) do
        local entity = H.Spawn(spawnType, spawnVariant or 0, spawnSubtype or 0, position or p.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), p)

        table.insert(output.entities, entity)
    end

    return output
end

function H.RandomChance(shouldDouble, ...)
    local functions = {...}

    local effectIndex = lootdeck.rng:RandomInt(#functions) + 1

    if shouldDouble then
        functions[effectIndex]()
    end

    return functions[effectIndex]()
end

function H.GetEntityByInitSeed(initSeed)
    local entities = Isaac.GetRoomEntities()

    for _, entity in pairs(entities) do
        if tostring(entity.InitSeed) == tostring(initSeed) then
            return entity
        end
    end
end

function H.ConvertUserDataToInitSeeds(userData)
    if type(userData) == "table" then
        local output = {}
        for key, value in pairs(userData) do
            output[key] = H.ConvertUserDataToInitSeeds(value)
        end
        return output
    elseif type(userData) == "userdata" then
        return { type = "userdata", initSeed = tostring(userData.InitSeed) }
    else
        return userData
    end
end

function H.SaveGame()
    local data = {
        seed = Game():GetSeeds():GetPlayerInitSeed(),
        players = {},
        familiars = {},
        global = lootdeck.f,
        mcmOptions = lootdeck.mcmOptions or {},
        unlocks = lootdeck.unlocks or {}
    }

    H.ForEachPlayer(function(p, pData)
        local output = H.ConvertUserDataToInitSeeds(pData)
        data.players[tostring(p.InitSeed)] = output
    end)

    H.ForEachEntityInRoom(function(familiar)
        local eData = familiar:GetData()

        local output = H.ConvertUserDataToInitSeeds(eData)

        data.familiars[tostring(familiar.InitSeed)] = output
    end, EntityType.ENTITY_FAMILIAR)

    H.SaveData(data)
end

function H.IsArray(t)
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then return false end
    end
    return true
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

local FIRST_PLAYER_HUD_OFFSET_VECTORS = {
    [0] = Vector(0, 0),
    [1] = Vector(1.5, 0.5),
    [2] = Vector(3, 1),
    [3] = Vector(5, 2),
    [4] = Vector(6.5, 2.5),
    [5] = Vector(8, 3),
    [6] = Vector(9.5, 3.5),
    [7] = Vector(11, 4),
    [8] = Vector(13, 5),
    [9] = Vector(14.5, 5.5),
    [10] = Vector(16, 6)
}

local SECOND_PLAYER_HUD_OFFSET_VECTORS = {
    [0] = Vector(0, 0),
    [1] = Vector(-2.5, 1),
    [2] = Vector(-5, 2.5),
    [3] = Vector(-7, 3.5),
    [4] = Vector(-9.5, 5),
    [5] = Vector(-12, 6),
    [6] = Vector(-14.5, 7),
    [7] = Vector(-17, 8.5),
    [8] = Vector(-19, 9.5),
    [9] = Vector(-21.5, 11),
    [10] = Vector(-24, 12)
}

local THIRD_PLAYER_HUD_OFFSET_VECTORS = {
    [0] = Vector(0, 0),
    [1] = Vector(2.5, -0.5),
    [2] = Vector(5, -1),
    [3] = Vector(7, -2),
    [4] = Vector(9.5, -2.5),
    [5] = Vector(11.5, -3),
    [6] = Vector(13.5, -3.5),
    [7] = Vector(16, -4),
    [8] = Vector(18, -5),
    [9] = Vector(20.5, -5.5),
    [10] = Vector(22.5, -6)
}

local FOURTH_PLAYER_HUD_OFFSET_VECTORS = {
    [0] = Vector(0, 0),
    [1] = Vector(2.5, 1),
    [2] = Vector(4, 1.5),
    [3] = Vector(6, 2.5),
    [4] = Vector(7.5, 3),
    [5] = Vector(9, 3.5),
    [6] = Vector(10.5, 4),
    [7] = Vector(12, 4.5),
    [8] = Vector(14, 5.5),
    [9] = Vector(15.5, 6),
    [10] = Vector(17, 6.5)
}

local JACOB_HUD_OFFSET_VECTORS = {
    [0] = Vector(0, 0),
    [1] = Vector(2, 1),
    [2] = Vector(4, 2.5),
    [3] = Vector(6, 3.5),
    [4] = Vector(8, 5),
    [5] = Vector(10, 6),
    [6] = Vector(12, 7),
    [7] = Vector(14, 8.5),
    [8] = Vector(16, 9.5),
    [9] = Vector(18, 11),
    [10] = Vector(20, 12)
}

local ESAU_HUD_OFFSET_VECTORS = {
    [0] = Vector(0, 0),
    [1] = Vector(1.5, 0.5),
    [2] = Vector(3, 1),
    [3] = Vector(5, 2),
    [4] = Vector(6.5, 2.5),
    [5] = Vector(8, 3),
    [6] = Vector(9.5, 3.5),
    [7] = Vector(11, 4),
    [8] = Vector(13, 5),
    [9] = Vector(14.5, 5.5),
    [10] = Vector(16, 6)
}

function H.GetCardPositionWithHUDOffset(p, sprite)
    local controllerIndex = H.GetPlayerControllerIndex(p)
    local BottomRight = H.GetScreenSize()
    local BottomLeft = H.GetScreenSize(0)
    local TopRight = H.GetScreenSize(nil, 0)
    local fuckOffVector = Vector(5000, 5000)

    local hudOffset = math.floor((Options.HUDOffset * 10) + 0.5)

    local hudOffsetVector = Vector.Zero

    if controllerIndex ~= 0 and p.SubType == PlayerType.PLAYER_ESAU then
        return fuckOffVector
    end

    -- Jacob in first player slot
    if controllerIndex == 0 and p.SubType == PlayerType.PLAYER_JACOB then
        hudOffsetVector = JACOB_HUD_OFFSET_VECTORS[hudOffset]
        return Vector(11, 41) + hudOffsetVector
    end

    -- Esau in second player slot
    if controllerIndex == 0 and p.SubType == PlayerType.PLAYER_ESAU then
        hudOffsetVector = ESAU_HUD_OFFSET_VECTORS[hudOffset]
        return Vector(BottomRight.X - 10, BottomRight.Y - 44) - hudOffsetVector
    end

    -- Player 2 (top right)
    if controllerIndex == 1 and p.SubType ~= PlayerType.PLAYER_ESAU then
        sprite.Scale = Vector(0.5, 0.5)
        hudOffsetVector = SECOND_PLAYER_HUD_OFFSET_VECTORS[hudOffset]
        return Vector(TopRight.X - 147, TopRight.Y + 44) + hudOffsetVector
    end

    -- Player 3 (bottom left)
    if controllerIndex == 2 and p.SubType ~= PlayerType.PLAYER_ESAU then
        sprite.Scale = Vector(0.5, 0.5)
        hudOffsetVector = THIRD_PLAYER_HUD_OFFSET_VECTORS[hudOffset]
        return Vector(BottomLeft.X + 21.5, BottomLeft.Y + 5) + hudOffsetVector
    end

    -- Player 4 (bottom right)
    if controllerIndex == 3 and p.SubType ~= PlayerType.PLAYER_ESAU then
        sprite.Scale = Vector(0.5, 0.5)
        hudOffsetVector = FOURTH_PLAYER_HUD_OFFSET_VECTORS[hudOffset]
        return Vector(BottomRight.X - 154, BottomRight.Y + 5.5) - hudOffsetVector
    end

    hudOffsetVector = FIRST_PLAYER_HUD_OFFSET_VECTORS[hudOffset]

    return Vector(BottomRight.X - 15, BottomRight.Y - 12) - hudOffsetVector
end

function H.RegisterAnimation(animationContainer, animationPath, animationName, callback)
    if not animationContainer then
        animationContainer = H.RegisterSprite(animationPath, nil, animationName)
        if callback then
            callback(animationContainer)
        end
    end
    return animationContainer
end

function H.StartLootcardAnimation(lootcardAnimationContainer, lootcardTag, animationName)
    lootcardAnimationContainer:ReplaceSpritesheet(0, string.format("gfx/ui/lootcard_fronts/%s.png", lootcardTag))
    lootcardAnimationContainer:LoadGraphics()
    lootcardAnimationContainer:Play(animationName, true)
end

function H.StartLootcardPickupAnimation(data, tag, animationName)
    if Game():GetRoom():HasWater() then
        animationName = animationName .. "Water"
    end
    data.lootcardPickupAnimation = H.RegisterAnimation(data.lootcardPickupAnimation, "gfx/ui/item_dummy_animation.anm2", animationName)

    H.StartLootcardAnimation(data.lootcardPickupAnimation, tag, animationName)
    data.isHoldingLootcard = true
end

return H
