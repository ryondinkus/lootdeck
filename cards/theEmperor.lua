-- Permacharms all enemies in the room
local Name = "IV. The Emperor"
local Tag = "theEmperor"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: audio visual?
local function MC_USE_CARD(_, c, p)
    for i, entity in ipairs(Isaac.GetRoomEntities()) do
        if not entity:IsBoss() then
            entity:AddCharmed(EntityRef(p), -1)
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