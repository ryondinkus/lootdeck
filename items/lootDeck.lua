local helper = include("helper_functions")

-- Spawns a lootcard
local Name = "Loot Deck"
local Tag = "lootDeck"
local Id = Isaac.GetItemIdByName(Name)

local function MC_USE_ITEM(_, type, rng, p)
    local lootCard = helper.GetWeightedLootCardId()
    p:AddCard(lootCard)

    local heldLootcard = helper.GetLootcardById(p:GetCard(0))
    local data = p:GetData()
    if data.lootcardPickupAnimation then
        data.lootcardPickupAnimation:SetLastFrame()
    end
    if heldLootcard then
        helper.StartLootcardPickupAnimation(data, heldLootcard.Tag, "IdleSparkle")
    end
    p:PlayExtraAnimation("UseItem")
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_USE_ITEM,
            MC_USE_ITEM,
            Id
        }
    }
}
