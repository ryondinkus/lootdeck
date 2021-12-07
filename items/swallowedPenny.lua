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
    en_us = "50% chance to drop a penny after taking damage",
    spa = "50% de posibilidad de generar un penny al recibir daño"
}
local WikiDescription = helper.GenerateEncyclopediaPage("50% chance to drop a penny after taking damage.", "- Increased chance to drop a penny for every extra copy of Swallowed Penny.")

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
