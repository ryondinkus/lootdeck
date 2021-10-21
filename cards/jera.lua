local helper = include('helper_functions')

-- Meat Cleaver effect
local Name = "Jera"
local Tag = "jera"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Triggers the {{Collectible631}} Meat Cleaver effect, splitting all room enemies in half with half their respective HP"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, triggers the Meat Cleaver effect, which splits all room enemies in half with half of their respective HP."},
						}}

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
