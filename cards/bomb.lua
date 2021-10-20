local helper = include("helper_functions")

-- Explodes a random enemy or (if there are no enemies in the room) explodes the player
local Name = "Bomb!"
local Tag = "bomb"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 6
local Description = "Explodes on a random enemy, dealing 40 damage#{{Warning}} If no enemies are in the room, this will explode on the player"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, spawns an explosion on a random enemy in the room, dealing 40 damage to it and all enemies around it."},
                            {str = "If used with no targetable enemies in the room, the explosion will spawn on the player instead."},
						}}

local function MC_USE_CARD(_, c, p)
	local target = helper.FindRandomEnemy(p.Position) or p
    Isaac.Explode(target.Position, nil, 40)
	if target == p then return false end
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
