local helper = include('helper_functions')

local Name = "Ehwaz"
local Tag = "ehwaz"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_D10, SoundEffect.SOUND_LAZARUS_FLIP_DEAD)
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