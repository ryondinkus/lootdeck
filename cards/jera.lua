local helper = include('helper_functions')

-- Meat Cleaver effect
local Name = "Jera"
local Tag = "jera"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    if #helper.ListEnemiesInRoom(p.Position, true) > 0 then
       helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_MEAT_CLEAVER) 
    else
        helper.FuckYou(p)
    end
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