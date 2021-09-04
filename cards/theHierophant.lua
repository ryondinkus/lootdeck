local Name = "VI. The Hierophant"
local Tag = "theHierophant"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: based on our discoveries with guppy's hairball, emulate a mantle effect
local function MC_USE_CARD(_, c, p)
    -- BUGGED: when AddCollectibleEffect() is fixed, this will give two Holy Mantle effects for the room.
    -- p:GetEffects():AddCollectibleEffect(5, false)
    p:AddSoulHearts(4)
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