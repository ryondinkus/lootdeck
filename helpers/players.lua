local H = {}

-- function to check if player can only use soul/black hearts
function lootdeckHelpers.IsSoulHeartFarty(p)
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

function lootdeckHelpers.RemoveHeartsOnNewRoomEnter(player, hpValue)
    for i=1,hpValue do
		if lootdeckHelpers.GetPlayerHeartTotal(player) > 2 then
        	player:AddMaxHearts(-2)
		end
    end
end

function lootdeckHelpers.GetPlayerHeartTotal(p)
    local heartTotal = p:GetMaxHearts()
    if lootdeckHelpers.IsSoulHeartFarty(p) then heartTotal = heartTotal + p:GetSoulHearts() end
    if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then heartTotal = heartTotal + (p:GetBoneHearts() * 2) end
    return heartTotal
end

function lootdeckHelpers.FindHealthToAdd(p, hp)
    local heartTotal = lootdeckHelpers.GetPlayerHeartTotal(p)
    if heartTotal < p:GetHeartLimit() then
        local remainder = math.floor((p:GetHeartLimit() - heartTotal)/2)
        local amountToAdd = math.floor(hp/2)
        if remainder < amountToAdd then amountToAdd = remainder end
		return amountToAdd
    end
    return 0
end

function lootdeckHelpers.AddTemporaryHealth(p, hp) -- hp is calculated in half hearts
	local data = p:GetData().lootdeck
    local amountToAdd = lootdeckHelpers.FindHealthToAdd(p, hp)
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

function lootdeckHelpers.GetPlayerOrSubPlayerByType(player, type)
    if (player:GetPlayerType() == type) then
        return player
    elseif (player:GetSubPlayer():GetPlayerType() == type) then
        return player:GetSubPlayer()
    end
    return nil
end

function lootdeckHelpers.TakeSelfDamage(p, dmg, canKill, prioritizeRedHearts)
	local flags = (DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS | DamageFlag.DAMAGE_NO_PENALTIES)
	if not canKill then flags = flags | DamageFlag.DAMAGE_NOKILL end
	if prioritizeRedHearts then flags = flags | DamageFlag.DAMAGE_RED_HEARTS end
	p:TakeDamage(dmg,flags,EntityRef(p),0)
	p:ResetDamageCooldown()
end

function lootdeckHelpers.HolyMantleDamage(damageAmount, damageFlags, damageSource)
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

function lootdeckHelpers.HolyMantleEffect(p, sound, effect, effectSubtype)
    lootdeck.sfx:Play(sound or SoundEffect.SOUND_HOLY_MANTLE,1,0)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, effect or EffectVariant.POOF02, effectSubtype or 11, p.Position, Vector.Zero, p)
    p:SetMinDamageCooldown(60)
end

function lootdeckHelpers.RevivePlayerPostPlayerUpdate(p, tag, callback)
    local game = Game()
    local data = p:GetData().lootdeck
    local sprite = p:GetSprite()
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
	local roomDesc = level:GetCurrentRoomDesc()
	local reviveTag = string.format("%sRevive", tag)

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
			if not (roomDesc.Data.Type == RoomType.ROOM_DUNGEON
			and roomDesc.Data.Variant == 666) then
				local enterDoor = level.EnterDoor
				local door = room:GetDoor(enterDoor)
				local direction = door and door.Direction or Direction.NO_DIRECTION
				game:StartRoomTransition(level:GetPreviousRoomIndex(),direction,0)
				level.LeaveDoor = enterDoor
			end
            if callback then
                callback()
            end
		end
    end
end

function lootdeckHelpers.HasActiveItem(p)
    for i=0,3 do
        if p:GetActiveItem(i) ~= 0 then
            return true
        end
    end
    return false
end

function lootdeckHelpers.TriggerOnRoomEntryPEffectUpdate(p, collectibleId, initialize, callback, tag, finishedTag, roomClearedTag, greedModeWaveTag, bossRushBossesTag)
    if not p:HasCollectible(collectibleId) then return end
    local data = p:GetData().lootdeck
    local game = Game()
    if not data[roomClearedTag] and not lootdeckHelpers.AreEnemiesInRoom(game:GetRoom()) then
        data[roomClearedTag] = true
    end

    local isFinished = (data[finishedTag] or data[finishedTag] == nil)
    local isBossRush = game:GetRoom():GetType() == RoomType.ROOM_BOSSRUSH

    local currentBosses = lootdeckHelpers.ListBossesInRoom(p.Position, true)

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

    if p:HasCollectible(collectibleId) and ((not isBossRush and isFinished and (data[roomClearedTag] and lootdeckHelpers.AreEnemiesInRoom(game:GetRoom()))) or (game:IsGreedMode() and data[greedModeWaveTag] ~= game:GetLevel().GreedModeWave) or (isBossRush and shouldInitializeBecauseOfBossRush)) then
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

function lootdeckHelpers.ForEachPlayer(callback, collectibleId)
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

function lootdeckHelpers.GetStartingItemsFromPlayer(p)
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
    local index = p:GetPlayerType() + 1
    return startingItems[index]
end

function lootdeckHelpers.GetPlayerInventory(p, ignoreId, ignoreActives, ignoreStartingItems, ignoreQuestItems)
    local itemConfig = Isaac.GetItemConfig()
    local numCollectibles = #itemConfig:GetCollectibles()
    local inv = {}
    for i = 1, numCollectibles do
        local collectible = itemConfig:GetCollectible(i)
        if collectible
        and (not ignoreActives or collectible.Type ~= ItemType.ITEM_ACTIVE)
        and (not ignoreStartingItems or not lootdeckHelpers.TableContains(lootdeckHelpers.GetStartingItemsFromPlayer(p), i))
		and (not ignoreQuestItems or not collectible:HasTags(ItemConfig.TAG_QUEST)) then
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

function lootdeckHelpers.GetRandomItemIdInInventory(p, ignoreId, ignoreActives)
    local inventory = lootdeckHelpers.GetPlayerInventory(p, ignoreId, ignoreActives)

    local itemIndex = lootdeck.rng:RandomInt(#inventory) + 1

    return inventory[itemIndex]
end

function lootdeckHelpers.GetPlayerSpriteOffset(p)
    local flyingOffset = p:GetFlyingOffset()
	if p.SubType == PlayerType.PLAYER_THEFORGOTTEN_B and p.PositionOffset.Y < -38 then
		flyingOffset = p:GetOtherTwin():GetFlyingOffset() - Vector(0,2)
	end
	local offsetVector = Vector(0,60) - p.PositionOffset - flyingOffset
    return offsetVector
end

function lootdeckHelpers.AddActiveCharge(p, value, animate)
    if animate then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BATTERY, 0, p.Position - lootdeckHelpers.GetPlayerSpriteOffset(p), Vector.Zero, p)
		lootdeck.sfx:Play(SoundEffect.SOUND_BATTERYCHARGE,1,0)
    end
    for i=0,3 do
        if p:GetActiveItem(i) ~= 0 then
            if p:NeedsCharge(i) then
                p:SetActiveCharge(p:GetActiveCharge(i) + value, i)
                if not p:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and p:GetBatteryCharge(i) > 0 then
                    p:SetActiveCharge(p:GetActiveCharge(i), i)
                end
                Game():GetHUD():FlashChargeBar(p, i)
                return true
            end
        end
    end
	return false
end

function lootdeckHelpers.GetPlayerControllerIndex(p)
    local controllerIndexes = {}
    lootdeckHelpers.ForEachPlayer(function(player)
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

return H
