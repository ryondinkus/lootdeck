local helper = include("helper_functions")

-- Permacharms all enemies in the room
local Name = "IV. The Emperor"
local Tag = "theEmperor"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Permanently charms every enemy in the room, excluding bosses"
local WikiDescription = helper.GenerateEncyclopediaPage("Permanently charms every enemy in the room. This does not include bosses.")

local function MC_USE_CARD(_, c, p)
	local illegalParents = {
		EntityType.ENTITY_GEMINI, -- gemini's umbilical cord
		EntityType.ENTITY_THE_HAUNT, -- the haunt's minions
		EntityType.ENTITY_FORSAKEN, -- the forsaken's minions
		EntityType.ENTITY_HERETIC, -- the forsaken's minions
	}
	helper.ForEachEntityInRoom(function(entity)
		entity:AddCharmed(EntityRef(p), -1)
	end, nil, nil, nil,
	function(entity)
		local npc = entity:ToNPC()
		return npc and not npc:IsBoss() and npc:IsVulnerableEnemy() and not helper.TableContains(illegalParents, npc.SpawnerType or 0)
	end)
    lootdeck.sfx:Play(SoundEffect.SOUND_HAPPY_RAINBOW, 1, 0)
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
