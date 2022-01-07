local H = {}

function LootDeckAPI.CanPickupPickup(player, pickup)
    return not (pickup.Variant == 90 and not (player:NeedsCharge(0) or player:NeedsCharge(1) or player:NeedsCharge(2) or player:NeedsCharge(3)))
    and not (pickup.Variant == 10 and (pickup.SubType == 1 or pickup.SubType == 2 or pickup.SubType == 5 or pickup.SubType == 9) and not player:CanPickRedHearts())
    and not (pickup.Variant == 10 and (pickup.SubType == 3 or pickup.SubType == 8 or pickup.SubType == 10) and not player:CanPickSoulHearts())
    and not (pickup.Variant == 10 and pickup.SubType == 6 and not player:CanPickBlackHearts())
    and not (pickup.Variant == 10 and pickup.SubType == 7 and not player:CanPickGoldenHearts())
    and not (pickup.Variant == 10 and pickup.SubType == 11 and not player:CanPickBoneHearts())
    and not (pickup.Variant == 10 and pickup.SubType == 12 and not player:CanPickRottenHearts())
end

function LootDeckAPI.CanBuyPickup(player, pickup)
	if pickup.Price > -6 and pickup.Price ~= 0 and not player:IsHoldingItem() then
        if (pickup.Price == -1 and player:GetMaxHearts() >= 2)
        or (pickup.Price == -2 and player:GetMaxHearts() >= 4)
        or (pickup.Price == -3 and player:GetSoulHearts() >= 6)
        or (pickup.Price == -4 and player:GetMaxHearts() >= 2 and player:GetSoulHearts() >= 4)    -- this devil deal is affordable--and player:GetDamageCooldown() <= 0)
		then
            return true
        elseif pickup.Price > 0 and player:GetNumCoins() >= pickup.Price    -- this shop item is affordable
        and LootDeckAPI.CanPickupPickup(player, pickup) then
            return true
        end
    end
	return false
end

function LootDeckAPI.CalculateRefund(price)
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

function LootDeckAPI.CustomCoinPrePickupCollision(pickup, collidingEntity, numberOfCoins, sfx, isFinished)
    local player = collidingEntity:ToPlayer() or 0
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()
    if player ~= 0 then
         if data.canTake then
            player:AddCoins(numberOfCoins)
            if sfx then
               lootdeck.sfx:Play(sfx)
            end
            pickup.Velocity = Vector.Zero
            pickup.Touched = true
            pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            sprite:Play("Collect", true)
            if isFinished then
                isFinished(player)
            end
            pickup:Die()
        end
    end
end

function LootDeckAPI.CustomCoinPickupUpdate(pickup, sfx)
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()
    if sfx and sprite:IsEventTriggered("DropSound") then
        lootdeck.sfx:Play(sfx)
    end
    if not sprite:IsPlaying("Collect") and not sprite:IsFinished("Collect") and (((sprite:IsPlaying("Appear") or sprite:IsPlaying("Reappear")) and sprite:IsEventTriggered("DropSound")) or sprite:IsPlaying("Idle")) and not data.canTake then
        data.canTake = true
    end
end

-- function that returns a consumable based on what glyph of balance would drop
function LootDeckAPI.GlyphOfBalance(player, rng)
    if player:GetMaxHearts() <= 0 and player:GetSoulHearts() <= 4 and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}
    elseif player:GetHearts() <= 1 and player:GetMaxHearts() > 0 then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL}
    elseif player:GetNumKeys() <= 0 then
        return {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL}
    elseif player:GetNumBombs() <= 0 then
        return {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL}
    elseif player:GetHearts() < player:GetMaxHearts() then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL}
    elseif player:GetNumCoins() < 15 then
        return {PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY}
    elseif player:GetNumKeys() < 5 then
        return {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL}
    elseif player:GetNumBombs() < 5 then
        return {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL}
    elseif player:GetTrinket(0) == 0 and not LootDeckAPI.AreTrinketsOnGround() then
        return {PickupVariant.PICKUP_TRINKET, 0}
    elseif player:GetHearts() + player:GetSoulHearts() < 12 and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}
    else
        return {(rng:RandomInt(4) + 1) * 10, 1}
    end
end

function LootDeckAPI.IsCoin(pickup, onlyCustom)
	local customCoinVariants = {
		20,
		2252, -- double nickel
		2253, -- double dime
		2254, -- double lucky penny
		2255, -- double sticky nickel
		2256, -- double golden penny
		2257, -- double charged penny
		9192  -- charged penny
	}
	if onlyCustom then
		table.remove(customCoinVariants, 1)
	end
	for k,v in pairs(customCoinVariants) do
		if pickup.Variant == v then
			return true
		end
	end
	return false
end

return H
