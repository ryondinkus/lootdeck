local Name = "Soul Heart"
local Tag = "soulHeart"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: based on our discoveries with guppy's hairball, emulate a mantle effect
local function MC_USE_CARD(_, c, p)
	-- BUGGED: when AddCollectibleEffect() is fixed, this will give Holy Mantle effect for the room.
    -- p:GetEffects():AddCollectibleEffect(5, false)
	p:AddSoulHearts(2)
    lootdeck.sfx:Play(SoundEffect.SOUND_HOLY,1,0)
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