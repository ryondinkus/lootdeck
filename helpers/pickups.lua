local H = {}

function LootDeckHelpers.FeckDechoEdmundMcmillen(player, pickup)
    return not (pickup.Variant == 90 and not (player:NeedsCharge(0) or player:NeedsCharge(1) or player:NeedsCharge(2) or player:NeedsCharge(3)))
    and not (pickup.Variant == 10 and (pickup.SubType == 1 or pickup.SubType == 2 or pickup.SubType == 5 or pickup.SubType == 9) and not player:CanPickRedHearts())
    and not (pickup.Variant == 10 and (pickup.SubType == 3 or pickup.SubType == 8 or pickup.SubType == 10) and not player:CanPickSoulHearts())
    and not (pickup.Variant == 10 and pickup.SubType == 6 and not player:CanPickBlackHearts())
    and not (pickup.Variant == 10 and pickup.SubType == 7 and not player:CanPickGoldenHearts())
    and not (pickup.Variant == 10 and pickup.SubType == 11 and not player:CanPickBoneHearts())
    and not (pickup.Variant == 10 and pickup.SubType == 12 and not player:CanPickRottenHearts())
end

function LootDeckHelpers.CanBuyPickup(player, pickup)
	if pickup.Price > -6 and pickup.Price ~= 0 and not player:IsHoldingItem() then
        if (pickup.Price == -1 and player:GetMaxHearts() >= 2)
        or (pickup.Price == -2 and player:GetMaxHearts() >= 4)
        or (pickup.Price == -3 and player:GetSoulHearts() >= 6)
        or (pickup.Price == -4 and player:GetMaxHearts() >= 2 and player:GetSoulHearts() >= 4)    -- this devil deal is affordable--and player:GetDamageCooldown() <= 0)
		then
            return true
        elseif pickup.Price > 0 and player:GetNumCoins() >= pickup.Price    -- this shop item is affordable
        and LootDeckHelpers.FeckDechoEdmundMcmillen(player, pickup) then
            return true
        end
    end
	return false
end

function LootDeckHelpers.CalculateRefund(price)
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

function LootDeckHelpers.CustomCoinPrePickupCollision(pi, e, amount, sfx, isFinished)
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

function LootDeckHelpers.CustomCoinPickupUpdate(pi, sfx)
    local data = pi:GetData()
    local sprite = pi:GetSprite()
    if sfx and sprite:IsEventTriggered("DropSound") then
        lootdeck.sfx:Play(sfx)
    end
    if not sprite:IsPlaying("Collect") and not sprite:IsFinished("Collect") and (((sprite:IsPlaying("Appear") or sprite:IsPlaying("Reappear")) and sprite:IsEventTriggered("DropSound")) or sprite:IsPlaying("Idle")) and not data.canTake then
        data.canTake = true
    end
end

-- function that returns a consumable based on what glyph of balance would drop
function LootDeckHelpers.GlyphOfBalance(p, rng)
    if p:GetMaxHearts() <= 0 and p:GetSoulHearts() <= 4 and p:GetPlayerType() ~= PlayerType.PLAYER_THELOST and p:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}
    elseif p:GetHearts() <= 1 and p:GetMaxHearts() > 0 then
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
    elseif p:GetTrinket(0) == 0 and not LootDeckHelpers.AreTrinketsOnGround() then
        return {PickupVariant.PICKUP_TRINKET, 0}
    elseif p:GetHearts() + p:GetSoulHearts() < 12 and p:GetPlayerType() ~= PlayerType.PLAYER_THELOST and p:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}
    else
        return {(rng:RandomInt(4) + 1) * 10, 1}
    end
end

function LootDeckHelpers.IsCoin(pi, customOnly)
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
	if customOnly then
		table.remove(customCoinVariants, 1)
	end
	for k,v in pairs(customCoinVariants) do
		if pi.Variant == v then
			return true
		end
	end
	return false
end

return H
