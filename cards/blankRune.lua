local Name = "Blank Rune"
local Tag = "blankRune"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: Visual and audio indicator for results, card spawns based on lootdeck weights
local function MC_USE_CARD(_, c, p)
	local game = Game()
	local sfx = lootdeck.sfx
	local rng = lootdeck.rng
    local room = game:GetRoom()
    local effect = rng:RandomInt(6)
    for i=1,game:GetNumPlayers() do
        if effect == 0 then
            sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
            sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
            p:AddCoins(1)
        elseif effect == 1 then
            sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
            for j=1,2 do
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
            end
        elseif effect == 2 then
            -- if player would die, do full health effect instead
            if p:GetHearts() <= 2 and p:GetSoulHearts() <= 2 then
                sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER,1,0)
                p:SetFullHearts()
            else
                sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
                local flags = (DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS | DamageFlag.DAMAGE_NO_PENALTIES)
                p:TakeDamage(2,flags,EntityRef(p),0)
                p:ResetDamageCooldown()
            end
        elseif effect == 3 then
            sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
            sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
            p:AddCoins(4)
        elseif effect == 4 then
            sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
            for j=1,5 do
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
            end
        elseif effect == 5 then
            sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
            sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
            p:AddCoins(6)
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