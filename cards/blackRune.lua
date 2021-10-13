local helper = include('helper_functions')

-- 40 damage to all monsters | Lose your newest item, spawn one from the current pool | Lose 3 bombs, coins, and keys, spawn 3 chests
local Name = "Black Rune"
local Tag = "blackRune"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)

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
