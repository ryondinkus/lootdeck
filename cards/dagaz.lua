-- A 1 in 2 chance of removing curses for the floor or gaining a soul heart
local Name = "Dagaz"
local Tag = "dagaz"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Random chance for either of these effects:# Clear all curses for the floor#{{SoulHeart}} Gain a Soul Heart"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, triggers either effect:"},
                            {str = "- Clear all curses for the floor. This does not apply to permanent curses in Challenges."},
                            {str = "- Gain a Soul Heart."},
						}}

local function MC_USE_CARD(_, c, p)
	local sfx = lootdeck.sfx
	local rng = lootdeck.rng
    local level = Game():GetLevel()
    local effect = rng:RandomInt(2)
    if effect == 0 then
        sfx:Play(SoundEffect.SOUND_SUPERHOLY,1,0)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GROUND_GLOW, 0, p.Position, Vector.Zero, p)
        level:RemoveCurses(level:GetCurses())
    else
        sfx:Play(SoundEffect.SOUND_HOLY,1,0)
        p:AddSoulHearts(2)
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
	Description = Description,
	WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
