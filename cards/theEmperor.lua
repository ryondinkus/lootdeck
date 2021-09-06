local helper = include("helper_functions")

-- Permacharms all enemies in the room
local Name = "IV. The Emperor"
local Tag = "theEmperor"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: audio visual?
local function MC_USE_CARD(_, c, p)
	local illegalParents = {
		EntityType.ENTITY_GEMINI, -- gemini's umbilical cord
		EntityType.ENTITY_THE_HAUNT, -- the haunt's minions
		EntityType.ENTITY_FORSAKEN, -- the forsaken's minions
		EntityType.ENTITY_HERETIC, -- the forsaken's minions
	}
    for i, v in ipairs(Isaac.GetRoomEntities()) do
		local entity = v:ToNPC()
		if entity then
			local parent = entity.SpawnerType or 0
			print(parent)
	        if entity:GetBossID() == 0 and not helper.TableContains(illegalParents, parent) then
				entity:AddCharmed(EntityRef(p), -1)
	        end
		end
    end
    lootdeck.sfx:Play(SoundEffect.SOUND_HAPPY_RAINBOW, 1, 0)
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
