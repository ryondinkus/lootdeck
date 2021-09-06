-- Spawn a coin, bomb, or key for every enemy in the room
local Name = "VIII. Justice"
local Tag = "justice"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: audio/visual effects, stagger a bit
local function MC_USE_CARD(_, c, p)
    local rng = lootdeck.rng
    for i, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsActiveEnemy() then
            local effect = rng:RandomInt(3)
            if effect == 0 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, entity.Position, Vector.FromAngle(rng:RandomInt(360)), p)
            elseif effect == 1 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, entity.Position, Vector.FromAngle(rng:RandomInt(360)), p)
            else
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, entity.Position, Vector.FromAngle(rng:RandomInt(360)), p)
            end
        end
    end
    lootdeck.sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
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