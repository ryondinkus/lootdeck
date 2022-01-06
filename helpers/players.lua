local H = {}

-- function to check if player can only use soul/black hearts
function LootDeckAPI.IsSoulHeartBart(player)
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
        if player:GetPlayerType() == v then
            return true
        end
    end
    return false
end

function LootDeckAPI.RemoveMaxHearts(player, hp)
    for i=1, hp do
		if LootDeckAPI.GetPlayerMaxHeartTotal(player) > 2 then
			if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN and i % 2 == 0 then
        		player:AddMaxHearts(-2)
			else
				player:AddMaxHearts(-1)
			end
		end
    end
end

function LootDeckAPI.GetPlayerMaxHeartTotal(player)
    local heartTotal = player:GetMaxHearts()
    if LootDeckAPI.IsSoulHeartBart(player) then
        heartTotal = heartTotal + player:GetSoulHearts()
    end
    if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
        heartTotal = heartTotal + (player:GetBoneHearts())
    end
    return heartTotal
end

function LootDeckAPI.FindHealthToAdd(player, hp)
    local heartTotal = LootDeckAPI.GetPlayerMaxHeartTotal(player)
	local heartLimit = player:GetHeartLimit()
	if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
        heartLimit = heartLimit / 2
    end
    if heartTotal < heartLimit then
        local remainder = math.floor(heartLimit - heartTotal)
        local amountToAdd = math.floor(hp)
        if remainder < amountToAdd then
            amountToAdd = remainder
        end
		return amountToAdd
    end
    return 0
end

function LootDeckAPI.AddTemporaryHealth(player, hp) -- hp is calculated in half hearts
	local data = player:GetData().lootdeck
    local amountToAdd = LootDeckAPI.FindHealthToAdd(player, hp)
    if player:GetPlayerType() == PlayerType.PLAYER_THESOUL then
        if not data.soulHp then
            data.soulHp = 0
        end
        data.soulHp = data.soulHp + amountToAdd
    else
        if not data.redHp then
            data.redHp = 0
        end
        data.redHp = data.redHp + amountToAdd
    end
    player:AddMaxHearts(hp)
    player:AddHearts(hp)
    lootdeck.sfx:Play(SoundEffect.SOUND_VAMP_GULP,1,0)
end

function LootDeckAPI.GetPlayerOrSubPlayerByType(player, type)
    if (player:GetPlayerType() == type) then
        return player
    elseif (player:GetSubPlayer():GetPlayerType() == type) then
        return player:GetSubPlayer()
    end
    return nil
end

function LootDeckAPI.TakeSelfDamage(player, damage, canKill, prioritizeRedHearts)
	local flags = (DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS | DamageFlag.DAMAGE_NO_PENALTIES)
	if not canKill then
        flags = flags | DamageFlag.DAMAGE_NOKILL
    end
	if prioritizeRedHearts then
        flags = flags | DamageFlag.DAMAGE_RED_HEARTS
    end
	player:TakeDamage(damage,flags,EntityRef(player),0)
	player:ResetDamageCooldown()
end

function LootDeckAPI.CheckHolyMantleDamage(damageAmount, damageFlags, damageSource)
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

function LootDeckAPI.HolyMantleEffect(player, sfx, effectVariant, effectSubType)
    lootdeck.sfx:Play(sfx or SoundEffect.SOUND_HOLY_MANTLE,1,0)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, effectVariant or EffectVariant.POOF02, effectSubType or 11, player.Position, Vector.Zero, player)
    player:SetMinDamageCooldown(60)
end

function LootDeckAPI.RevivePlayerPostPlayerUpdate(player, tag, callback)
    local game = Game()
    local data = player:GetData().lootdeck
    local sprite = player:GetSprite()
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
	  local roomDesc = level:GetCurrentRoomDesc()
	  local reviveTag = string.format("%sRevive", tag)

    if (sprite:IsPlaying("Death") and sprite:GetFrame() == 55)
	or (sprite:IsPlaying("LostDeath") and sprite:GetFrame() == 37)
	or (sprite:IsPlaying("ForgottenDeath") and sprite:GetFrame() == 19) then
        if data[reviveTag] then
            if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                player:AddBoneHearts(1)
            end
            player:Revive()
			player:SetMinDamageCooldown(60)
			if player:GetOtherTwin() then
				player:GetOtherTwin():Revive()
				player:GetOtherTwin():SetMinDamageCooldown(60)
			end
      
			if not (roomDesc.Data.Type == RoomType.ROOM_DUNGEON
			and roomDesc.Data.Variant == 666) then
				local enterDoor = level.EnterDoor
				local door = room:GetDoor(enterDoor)
				local direction = door and door.Direction or Direction.NO_DIRECTION
				game:StartRoomTransition(level:GetPreviousRoomIndex(),direction,0)
				level.LeaveDoor = enterDoor
			elseif callback then
				callback()
			end
			data[reviveTag] = nil
		end
    end
end

function LootDeckAPI.HasActiveItem(player)
    for i=0,3 do
        if player:GetActiveItem(i) ~= 0 then
            return true
        end
    end
    return false
end

function LootDeckAPI.TriggerOnRoomEntryPEffectUpdate(player, collectibleId, initialize, callback, tag)
	local finishedTag = string.format("%sFinished", tag)
	local roomClearedTag = string.format("%sRoomCleared", tag)
	local greedModeWaveTag = string.format("%sGreedModeWave", tag)
	local bossRushBossesTag = string.format("%sBossRushBosses", tag)

	if not player:HasCollectible(collectibleId) then return end
    local data = player:GetData().lootdeck
    local game = Game()
    if not data[roomClearedTag] and not LootDeckAPI.AreEnemiesInRoom(game:GetRoom()) then
        data[roomClearedTag] = true
    end

    local isFinished = (data[finishedTag] or data[finishedTag] == nil)
    local isBossRush = game:GetRoom():GetType() == RoomType.ROOM_BOSSRUSH

    local currentBosses = LootDeckAPI.ListBossesInRoom(true)

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

    if player:HasCollectible(collectibleId) and ((not isBossRush and isFinished and (data[roomClearedTag] and LootDeckAPI.AreEnemiesInRoom(game:GetRoom()))) or (game:IsGreedMode() and data[greedModeWaveTag] ~= game:GetLevel().GreedModeWave) or (isBossRush and shouldInitializeBecauseOfBossRush)) then
        initialize(player)
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

function LootDeckAPI.ForEachPlayer(callback, collectibleId)
    local shouldReturn = nil
    for x = 0, Game():GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(x)
        if not collectibleId or (collectibleId and p:HasCollectible(collectibleId)) then
            if callback(p, p:GetData().lootdeck) == false then
                shouldReturn = false
            end
        end
    end
    return shouldReturn
end

function LootDeckAPI.GetStartingItemsFromPlayer(player)
    local startingItems =
    {
        {CollectibleType.COLLECTIBLE_D6},
        {CollectibleType.COLLECTIBLE_YUM_HEART},
        {CollectibleType.COLLECTIBLE_LUCKY_FOOT},
        {CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, 59}, -- 59: Passive Book of Belial from Birthright (no enum exists)
        {CollectibleType.COLLECTIBLE_POOP},
        {CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON, CollectibleType.COLLECTIBLE_DEAD_BIRD, CollectibleType.COLLECTIBLE_RAZOR_BLADE},
        {CollectibleType.COLLECTIBLE_BLOODY_LUST},
        {},
        {CollectibleType.COLLECTIBLE_ANEMIC},
        {},
        {CollectibleType.COLLECTIBLE_HOLY_MANTLE, CollectibleType.COLLECTIBLE_ETERNAL_D6},
        {CollectibleType.COLLECTIBLE_ANEMIC},
        {},
        {CollectibleType.COLLECTIBLE_INCUBUS, CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS, CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION},
        {CollectibleType.COLLECTIBLE_WOODEN_NICKEL},
        {CollectibleType.COLLECTIBLE_VOID},
        {},
        {},
        {CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES},
        {},
        {},
        {},
        {CollectibleType.COLLECTIBLE_YUM_HEART},
        {CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING},
        {CollectibleType.COLLECTIBLE_DARK_ARTS},
        {CollectibleType.COLLECTIBLE_HOLD},
        {CollectibleType.COLLECTIBLE_SUMPTORIUM},
        {},
        {},
        {CollectibleType.COLLECTIBLE_FLIP},
        {},
        {},
        {},
        {},
        {CollectibleType.COLLECTIBLE_ABYSS},
        {CollectibleType.COLLECTIBLE_RECALL},
        {CollectibleType.COLLECTIBLE_LEMEGETON},
        {CollectibleType.COLLECTIBLE_ANIMA_SOLA},
        {CollectibleType.COLLECTIBLE_FLIP},
        {CollectibleType.COLLECTIBLE_ANIMA_SOLA},
        {CollectibleType.COLLECTIBLE_RECALL}
    }
    local index = player:GetPlayerType() + 1
    return startingItems[index]
end

function LootDeckAPI.GetPlayerInventory(player, blacklist, ignoreId, ignoreActives, ignoreStartingItems, ignoreQuestItems)
    local itemConfig = Isaac.GetItemConfig()
    local numCollectibles = #itemConfig:GetCollectibles()
    local inv = {}
    for i = 1, numCollectibles do
        local collectible = itemConfig:GetCollectible(i)
        if collectible
		and (not lootdeckHelpers.TableContains(blacklist, collectible.ID))
        and (not ignoreActives or collectible.Type ~= ItemType.ITEM_ACTIVE)
        and (not ignoreStartingItems or not LootDeckAPI.TableContains(LootDeckAPI.GetStartingItemsFromPlayer(player), i))
		and (not ignoreQuestItems or not collectible:HasTags(ItemConfig.TAG_QUEST)) then
            inv[i] = player:GetCollectibleNum(i)
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

function LootDeckAPI.GetRandomItemIdInInventory(player, blackList, ignoreId, ignoreActives, ignoreStartingItems, ignoreQuestItems)
    local inventory = LootDeckAPI.GetPlayerInventory(player, blackList, ignoreId, ignoreActives, ignoreStartingItems, ignoreQuestItems)

    local itemIndex = lootdeck.rng:RandomInt(#inventory) + 1

    return inventory[itemIndex]
end

function LootDeckAPI.GetPlayerSpriteOffset(p)
    local flyingOffset = p:GetFlyingOffset()
	if p.SubType == PlayerType.PLAYER_THEFORGOTTEN_B and p.PositionOffset.Y < -38 then
		flyingOffset = p:GetOtherTwin():GetFlyingOffset() - Vector(0,2)
	end
	local offsetVector = Vector(0,60) - p.PositionOffset - flyingOffset
    return offsetVector
end

function LootDeckAPI.AddActiveCharge(player, value, animate)
    if animate then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BATTERY, 0, player.Position - LootDeckAPI.GetPlayerSpriteOffset(player), Vector.Zero, player)
		lootdeck.sfx:Play(SoundEffect.SOUND_BATTERYCHARGE,1,0)
    end
    for i=0,3 do
        if player:GetActiveItem(i) ~= 0 then
            if player:NeedsCharge(i) then
                player:SetActiveCharge(player:GetActiveCharge(i) + value, i)
                if not player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and player:GetBatteryCharge(i) > 0 then
                    player:SetActiveCharge(player:GetActiveCharge(i), i)
                end
                Game():GetHUD():FlashChargeBar(player, i)
                return true
            end
        end
    end
	return false
end

function LootDeckAPI.GetPlayerControllerIndex(player)
    local controllerIndexes = {}
    LootDeckAPI.ForEachPlayer(function(player)
        for _, index in pairs(controllerIndexes) do
            if index == player.ControllerIndex then
                return
            end
        end
        table.insert(controllerIndexes, player.ControllerIndex)
    end)
    for i, index in pairs(controllerIndexes) do
        if index == player.ControllerIndex then
            return i - 1
        end
    end
end

return H
