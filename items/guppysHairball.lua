-- A 1 in 6 chance of negating damage
local Name = "Guppy's Hairball"
local Tag = "guppysHairball"
local Id = Isaac.GetItemIdByName(Name)

local function MC_ENTITY_TAKE_DMG(_, e)
    local p = e:ToPlayer()
    if p:HasCollectible(Id) then
        local effectNum = p:GetCollectibleNum(Id)
        local effect = lootdeck.rng:RandomInt(6)
        local threshold = 0
        if effectNum > 0 then threshold = 1 end
        threshold = threshold + (effectNum - 1)
        if threshold > 2 then threshold = 2 end
        if effect <= threshold then
            lootdeck.sfx:Play(SoundEffect.SOUND_HOLY_MANTLE,1,0)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 11, p.Position, Vector.Zero, p)
            p:SetMinDamageCooldown(30)
            return false
        end
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        }
    }
}