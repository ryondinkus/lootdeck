local helper = include("helper_functions")

-- Explodes a random enemy or (if there are no enemies in the room) explodes the player
local Name = "Joker"
local Tag = "joker"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
	local rng = lootdeck.rng
	local room = Game():GetRoom()
	local entities = Isaac.GetRoomEntities()
	local itemsList = {}
	for i, entity in ipairs(entities) do
		if entity.Type == EntityType.ENTITY_PICKUP
		and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE
		and entity.SubType ~= 0 then
			table.insert(itemsList, entity)
		end
	end
	if #itemsList > 0 then
		local selectedItem = itemsList[rng:RandomInt(#itemsList)+1]:ToPickup()
		local newItem = Isaac.Spawn(selectedItem.Type, selectedItem.Variant, selectedItem.SubType, room:FindFreePickupSpawnPosition(p.Position, 0, true), Vector.Zero, p):ToPickup()
		newItem.OptionsPickupIndex = selectedItem.OptionsPickupIndex
		selectedItem:Remove()
	end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
