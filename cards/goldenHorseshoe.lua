
local helper = include("helper_functions")
local items = include("items/registry")

local Name = "Golden Horseshoe"
local Tag = "goldenHorseshoe"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.goldenHorseshoe, SoundEffect.SOUND_VAMP_GULP)
    lootdeck.spawnGlitchItem = true
end

local function MC_POST_NEW_ROOM()
    local game = Game()
    local room = game:GetRoom()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        if p:HasCollectible(items.goldenHorseshoe) and room:GetType() == RoomType.ROOM_TREASURE and lootdeck.f.spawnGlitchItem then
            p:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
            p:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
            lootdeck.f.spawnGlitchItem = false
        end
    end
end

local function MC_POST_NEW_LEVEL()
    if not lootdeck.f.spawnGlitchItem then lootdeck.f.spawnGlitchItem = true end
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
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    }
}