local helper = include("helper_functions")

-- Gives a chance for a coin to spawn when the player takes damage
local Name = "Swallowed Penny"
local Tag = "swallowedPenny"
local Id = Isaac.GetItemIdByName(Name)
local Description = "50% chance to drop a penny after taking damage"
local WikiDescription = helper.GenerateEncyclopediaPage("50% chance to drop a penny after taking damage.", "- Increased chance to drop a penny for every extra copy of Swallowed Penny.")

local function MC_ENTITY_TAKE_DMG(_, e)
    local rng = lootdeck.rng
    local p = e:ToPlayer()
    if p:HasCollectible(Id) then
        for i=1,p:GetCollectibleNum(Id) do
            local effect = rng:RandomInt(2)
            if effect == 0 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, p.Position, Vector.FromAngle(rng:RandomInt(360)), nil)
				break
			end
        end
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        }
    }
}
