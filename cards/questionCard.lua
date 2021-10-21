local helper = include('helper_functions')

-- Spawns a permacharmed copy of an enemy in the room, spawns a random permacharmed enemy if no enemies in room
local Name = "? Card"
local Tag = "questionCard"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Spawns a permanently charmed clone of a random enemy in the room# If there are no enemies, spawns a permanently charmed Gaper"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "Spawns a permanently charmed copy of a random enemy in the room."},
                            {str = "If no enemies are in the room on use, spawns a permanently charmed Smiling Gaper."}
						}}

local function MC_USE_CARD(_, c, p)
    local enemy = helper.FindRandomEnemy(p.Position, nil, true, nil, function(entity) return not entity:IsBoss() end)

    if enemy then
        local friend = Isaac.Spawn(enemy.Type, enemy.Variant, enemy.SubType, p.Position, Vector.Zero, p)
        friend:AddCharmed(EntityRef(p), -1)
    else
        local friend = Isaac.Spawn(EntityType.ENTITY_GAPER, 1, 0, p.Position, Vector.Zero, p)
        friend:AddCharmed(EntityRef(p), -1)
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
