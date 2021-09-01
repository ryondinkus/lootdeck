local H = {}
local registry = include("registry")

local game = lootdeck.game
local rng = lootdeck.rng
local sfx = lootdeck.sfx

function H.PlayQuick(sound)
	sfx:Play(sound, 1, 0)
end

-- helper function for using findRandomEnemy with noDupes, resets chosen enemy counter in case of multiple uses of tower card, for example
function H.clearChosens(pos)
    local entities = Isaac.FindInRadius(pos, 875, EntityPartition.ENEMY)
    for i, entity in pairs(entities) do
        local data = entity:GetData()
        if data.chosen then
            data.chosen = nil
        end
    end
end

-- function for finding target enemy, then calculating the angle/position the fire will spawn
function H.findRandomEnemy(pos, noDupes)
    local entities = Isaac.FindInRadius(pos, 875, EntityPartition.ENEMY)
    local enemies = {}
    local key = 1;
    for i, entity in pairs(entities) do
        if entity:IsVulnerableEnemy() and not entity:GetData().chosen then
            enemies[key] = entities[i]
            key = key + 1;
        end
    end
    local chosenEnt = enemies[rng:RandomInt(#enemies)+1]
    if chosenEnt then chosenEnt:GetData().chosen = noDupes end
    return chosenEnt
end

-- function for registering basic loot cards that spawn items
function H.SimpleLootCardSpawn(cardID, spawnType, spawnVariant, spawnSubtype, uses, position, sound, effect, effectAmount)
    lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
        room = game:GetRoom()
        for i = 1,(uses or 1) do
            Isaac.Spawn(spawnType, spawnVariant or 0, spawnSubtype or 0, position or p.Position, Vector.FromAngle(rng:RandomInt(360)), p)
        end
        if effect then
            for i=1,(effectAmount or 1) do
                Isaac.Spawn(EntityType.ENTITY_EFFECT, effect, 0, position or p.Position, Vector.FromAngle(rng:RandomInt(360)), p)
            end
        end
        if sound then
            sfx:Play(sound)
        end
    end, cardID)
end

-- function for registering basic loot cards that copy item effects
function H.SimpleLootCardEffect(cardID, itemEffect, sound)
    lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
        p:UseActiveItem(itemEffect, false)
        if sound then
            sfx:Play(sound,1,0)
        end
    end, cardID)
end

-- function for registering basic loot cards that give items
function H.SimpleLootCardItem(cardID, itemID, sound)
    lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
        p:AddCollectible(itemID)
        if sound then
            sfx:Play(sound,1,0)
        end
    end, cardID)
end

-- function to convert tearflags to new BitSet128
function H.NewTearflag(x)
    return x >= 64 and BitSet128(0,1<<(x - 64)) or BitSet128(1<<x,0)
end

-- function to check if player can only use soul/black hearts
function H.IsSoulHeartMarty(p)
    for i,v in ipairs(registry.soulHeartMarties) do
        if p:GetPlayerType() == v then
            return true
        end
    end
    return false
end

-- helper function for glyphOfBalance(), makes shit less ocopmlicationsed
function H.trinketsOnGround()
    local entities = Isaac.GetRoomEntities()
    for i, entity in pairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP
        and entity.Variant == PickupVariant.PICKUP_TRINKET then
            return true
        end
    end
    return false
end

-- function that returns a consumable based on what glyph of balance would drop
function H.glyphOfBalance(p)
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
    elseif p:GetTrinket(0) == 0 and not trinketsOnGround() then
        return {PickupVariant.PICKUP_TRINKET, 0}
    elseif p:GetHearts() + p:GetSoulHearts() < 12 then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}
    else
        return {(rng:RandomInt(4)+1)*10, 1}
    end
end

function H.RemoveHeartsOnNewRoomEnter(player, hpValue)
    for i=1,hpValue do
		if GetPlayerHeartTotal(player) > 2 then
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
    if IsSoulHeartMarty(p) then heartTotal = heartTotal + p:GetSoulHearts() end
    if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then heartTotal = heartTotal + (p:GetBoneHearts() * 2) end
    return heartTotal
end

function H.FindHealthToAdd(p, hp)
    local heartTotal = GetPlayerHeartTotal(p)
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
    local amountToAdd = FindHealthToAdd(p, hp)
    if p:GetPlayerType() == PlayerType.PLAYER_THESOUL then
        if not data.soulHp then data.soulHp = 0 end
        data.soulHp = data.soulHp + amountToAdd
    else
        if not data.redHp then data.redHp = 0 end
        data.redHp = data.redHp + amountToAdd
    end
    p:AddMaxHearts(hp)
    p:AddHearts(hp)
    sfx:Play(SoundEffect.SOUND_VAMP_GULP,1,0)
end

return H
