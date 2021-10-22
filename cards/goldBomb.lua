local helper = include("helper_functions")

-- Explodes three random enemies in the room
local Name = "Gold Bomb!!"
local Tag = "goldBomb"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Explodes on three random enemies, dealing 40 damage to each#{{Warning}} If no enemies are in the room initally, this will explode on the player"
local WikiDescription = helper.GenerateEncyclopediaPage("On use, spawns an explosion on three random enemies in the room, dealing 40 damage to each enemy and all enemies around them.", "If used with no targetable enemies in the room, an explosion will spawn on the player instead.", "- This only applies to the inital explosion. If the first or second explosion wipes out all enemies in the room, any subsequent explosions will simply not happen.")

local function MC_USE_CARD(_, c, p)
	local data = p:GetData()
	if not helper.AreEnemiesInRoom(Game():GetRoom()) then
		Isaac.Explode(p.Position, nil, 40)
		return false
	else
		data[Tag] = 1
	end
end

local function MC_POST_PEFFECT_UPDATE(_, p)
	helper.StaggerSpawn(Tag, p, 15, 3, function(p)
		local target = helper.FindRandomEnemy(p.Position) or 0
		if target ~= 0 then
			Isaac.Explode(target.Position, nil, 40)
		end
	end)
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
        },
		{
			ModCallbacks.MC_POST_PEFFECT_UPDATE,
			MC_POST_PEFFECT_UPDATE
		}
    }
}
