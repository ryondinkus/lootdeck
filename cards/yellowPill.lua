local entityVariants = include("entityVariants/registry")

local Name = "Pills! Yellow"
local Tag = "yellowPill"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
	local sfx = lootdeck.sfx
	local rng = lootdeck.rng
	local effect = 5--rng:RandomInt(3)
	if effect == 0 then
		sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
		sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
		p:AddCoins(4)
	elseif effect == 1 then
		sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
		sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
		p:AddCoins(7)
	else
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
		for i=1,4 do
			if p:GetNumCoins() > 0 then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostPenny.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, nil)
				p:AddCoins(-1)
			end
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