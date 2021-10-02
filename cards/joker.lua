local helper = include("helper_functions")
local entityVariants = include("entityVariants/registry")

-- Spawns a Devil Hand that "steals" any item and brings it next to the player
local Name = "Joker"
local Tag = "joker"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
	local rng = lootdeck.rng
	local itemsList = {}

	helper.ForEachEntityInRoom(function(entity)
		table.insert(itemsList, entity)
	end,
	EntityType.ENTITY_PICKUP,
	PickupVariant.PICKUP_COLLECTIBLE,
	function(entitySubType) return entitySubType ~= 0 end,
	function(entity) return not entity:GetData().selected end)

	if #itemsList > 0 then
		local selectedItem = itemsList[rng:RandomInt(#itemsList)+1]:ToPickup()
		selectedItem:GetData().selected = true
		local devilHand = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.devilHand.Id, 0, p.Position, Vector.Zero, p)
		devilHand:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
		poof.Color = Color(0,0,0,1,0,0,0)
		local handData = devilHand:GetData()
		handData.target = selectedItem
		handData.jokerPlayerIndex = p.Index
	else
		helper.FuckYou(p)
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
