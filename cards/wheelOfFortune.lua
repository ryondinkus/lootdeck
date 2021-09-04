local entityVariants = include("entityVariants/registry")

local Name = "X. Wheel of Fortune"
local Tag = "wheelOfFortune"
local Id = Isaac.GetCardIdByName(Name)

local arcadeItems = {
    CollectibleType.COLLECTIBLE_DOLLAR,
    CollectibleType.COLLECTIBLE_SKATOLE,
    CollectibleType.COLLECTIBLE_BLOOD_BAG,
    CollectibleType.COLLECTIBLE_IV_BAG,
    CollectibleType.COLLECTIBLE_BLOOD_BOMBS,
    CollectibleType.COLLECTIBLE_CRYSTAL_BALL
}

local function MC_USE_CARD(_, c, p)
    local game = Game()
    local sfx = lootdeck.sfx
    local rng = lootdeck.rng
    local room = game:GetRoom()
    local effect = rng:RandomInt(6)
    if effect == 0 then
        p:AddCoins(1)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
    elseif effect == 1 then
        if p:GetHearts() <= 2 and p:GetSoulHearts() <= 2 then
            p:SetFullHearts()
            sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER, 1, 0)
        else
            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
            local flags = (DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS | DamageFlag.DAMAGE_NO_PENALTIES)
            p:TakeDamage(1,flags,EntityRef(p),0)
            p:ResetDamageCooldown()
        end
    elseif effect == 2 then
        for j=1,3 do
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), p)
        end
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
    elseif effect == 3 then
        p:AddCoins(-4)
        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 0)
        for i=0,3 do
            Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostPenny.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360)), p)
        end
    elseif effect == 4 then
        p:AddCoins(5)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
    elseif effect == 5 then
        local room = game:GetRoom()
        local collectible = arcadeItems[rng:RandomInt(#arcadeItems)+1]
        local spawnPos = room:FindFreePickupSpawnPosition(p.Position)
        local spawnedItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible, spawnPos, Vector.Zero, p)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
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