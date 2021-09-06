-- Permacharms all enemies in the room
local Name = "IV. The Emperor"
local Tag = "theEmperor"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: audio visual?
local function MC_USE_CARD(_, c, p)
    for i, v in ipairs(Isaac.GetRoomEntities()) do
		local entity = v:ToNPC()
		if entity then
	        if entity:GetBossID() == 0 then
	            entity:AddCharmed(EntityRef(p), -1)
				print(entity:GetBossID())
				print(entity:IsBoss())
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
