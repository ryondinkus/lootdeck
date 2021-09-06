local Name = "Lost Soul"
local Tag = "lostSoul"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: Implement
local function MC_USE_CARD(_, c, p)
	print("poggie woggie")
    -- BUG: Purgatory ghost crashes on spawn, need API update to fix
    --Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, p.Position, Vector.Zero, nil)
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