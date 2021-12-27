local helper = lootdeckHelpers

-- Gives a chance for a coin to spawn when the player takes damage
local Names = {
    en_us = "Swallowed Penny",
    spa = "Moneda Tragada"
}
local Name = Names.en_us
local Tag = "swallowedPenny"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "On damage taken, lose 1 cent and fire a penny tear in a random direction# The penny tear has 2x damage and drops a Penny and a puddle of creep when it makes contact",
    spa = "50% de posibilidad de generar un penny al recibir daño"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On damage taken, lose 1 cent and fire a penny tear in a random direction", "- The penny tear will have 2x damage.", "- On contact with enemies, obstacles, or the floor, penny tears will turn into a normal Penny (or rarely, other coin types) and leave a puddle of creep behind.", "- Additional copies will fire extra penny tears in random directions, at the cost of additional cents.")

local function MC_ENTITY_TAKE_DMG(_, e)
    local p = e:ToPlayer()
    local rng = p:GetCollectibleRNG(Id)
    if p:HasCollectible(Id) then
        for i=1,p:GetCollectibleNum(Id) do
            local effect = rng:RandomInt(2)
            if effect == 0 then
                helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, p.Position, Vector.FromAngle(rng:RandomInt(360)), nil)
				break
			end
        end
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        }
    }
}
