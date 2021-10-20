local helper = include('helper_functions')

-- Rerolls the enemies in the room using the D10
local Name = "Ehwaz"
local Tag = "ehwaz"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "{{Collectible285}} D10 effect on use, rerolling all enemies in the room."
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, triggers the D10 effect, rerolling all enemies in the room."},
						}}

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_D10, SoundEffect.SOUND_LAZARUS_FLIP_DEAD)
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
