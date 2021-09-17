local helper = include("helper_functions")
local entityVariants = include("entityVariants/registry")

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
		local devilHand = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.devilHand.Id, 0, p.Position, Vector.Zero, p)
		devilHand:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
		poof.Color = Color(0,0,0,1,0,0,0)
		local handData = devilHand:GetData()
		handData.target = selectedItem
		handData.playerPos = p.Position
		-- newItem.OptionsPickupIndex = selectedItem.OptionsPickupIndex
		-- selectedItem:Remove()
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
