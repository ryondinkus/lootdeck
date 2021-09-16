local helper = include('helper_functions')

-- Rerolls the enemies in the room using the D10
local Name = "Ehwaz"
local Tag = "ehwaz"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_D10, SoundEffect.SOUND_LAZARUS_FLIP_DEAD)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
            {
                ModCallbacks.MC_USE_CARD,
                MC_USE_CARD,
                Id
            }
    }
}