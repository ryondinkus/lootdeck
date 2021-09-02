local helper = include('helper_functions')

local Name = "Pills! Red"
local Tag = "redPill"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
    local sfx = lootdeck.sfx
	local effect = lootdeck.rng:RandomInt(3)
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

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}