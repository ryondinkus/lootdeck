local helper = include("helper_functions")
local entitySubTypes = include("entitySubTypes/registry")

-- Swap the pools of Red Chests and Gold Chests
local Name = "The Left Hand"
local Tag = "leftHand"
local Id = Isaac.GetItemIdByName(Name)
local Description = "Swaps the potential drops of Gold Chests and Red Chests"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "Swaps the potential drops of Gold Chests and Red Chests."},
						}}

local function MC_POST_PICKUP_UPDATE(_, pickup)
    local f = lootdeck.f
    local found = false
    helper.ForEachPlayer(function()
        found = true
    end, Id)

    if found and pickup:GetSprite():IsPlaying("Appear") and not pickup:GetData()[Tag] and pickup.FrameCount == 1 then
        local variant
        local subType
        if pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST and pickup.SubType ~= entitySubTypes.funnyRedChest.Id then
            variant = PickupVariant.PICKUP_REDCHEST
            subType = entitySubTypes.funnyLockedChest.Id
        elseif pickup.Variant == PickupVariant.PICKUP_REDCHEST and pickup.SubType ~= entitySubTypes.funnyLockedChest.Id then
            variant = PickupVariant.PICKUP_LOCKEDCHEST
            subType = entitySubTypes.funnyRedChest.Id
        end

        if variant then
            local newChest = Isaac.Spawn(EntityType.ENTITY_PICKUP, variant, subType, pickup.Position, Vector.Zero, nil)
            newChest:GetData()[Tag] = true
            for _, entity in pairs(Isaac.GetRoomEntities()) do
                if entity:GetLastParent().InitSeed == pickup.InitSeed then
                    entity:Remove()
                end
            end
            pickup:Remove()
        end
    end

    local sprite = pickup:GetSprite()
    if found and not helper.TableContains(f, pickup.InitSeed) and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and sprite:GetOverlayAnimation() == "Alternates" and pickup.FrameCount == 1 then
        if sprite:GetOverlayFrame() == 4 then
            sprite:SetOverlayFrame("Alternates", 5)
        elseif sprite:GetOverlayFrame() == 5 then
            sprite:SetOverlayFrame("Alternates", 4)
        end
        table.insert(f, pickup.InitSeed)
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
            ModCallbacks.MC_POST_PICKUP_UPDATE,
            MC_POST_PICKUP_UPDATE
        }
    }
}
