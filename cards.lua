local K = {}

local helper = include("helper_functions")

local game = lootdeck.game
local rng = lootdeck.rng
local sfx = lootdeck.sfx
local room = lootdeck.room

function K.RedPill(p)
	local effect = rng:RandomInt(3)
	local data = p:GetData()
	if effect == 0 then
		if not data.redDamage then data.redDamage = 0 end
		data.redDamage = data.redDamage + 1
		p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		p:EvaluateItems()
		sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
		sfx:Play(SoundEffect.SOUND_DEVIL_CARD,1,0)
		local itemConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL)
		p:AddCostume(itemConfig, true)
	elseif effect == 1 then
		helper.AddTemporaryHealth(p, 2)
		sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
	else
		-- if player would die, do full health effect instead
		if p:GetHearts() <= 1 and p:GetSoulHearts() <= 1 then
			sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER,1,0)
			p:SetFullHearts()
		else
			sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
			local flags = (DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS | DamageFlag.DAMAGE_NO_PENALTIES)
			p:TakeDamage(1,flags,EntityRef(p),0)
			p:ResetDamageCooldown()
		end
	end
end

function K.BluePill(p)
	local effect = rng:RandomInt(3)
	local sprite = p:GetSprite()
	if effect == 0 then
		sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, lootdeck.room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), p)
	elseif effect == 1 then
		sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
		for i=0,2 do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, lootdeck.room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), p)
		end
	else
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
		if p:GetNumCoins() > 0 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, ev.lostPenny, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
			p:AddCoins(-1)
		end
		if p:GetNumBombs() > 0 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, ev.lostBomb, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
			p:AddBombs(-1)
		end
		if p:GetNumKeys() > 0 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, ev.lostKey, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
			p:AddKeys(-1)
		end
	end
end

return K
