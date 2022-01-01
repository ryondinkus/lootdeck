local helper = LootDeckHelpers

-- Reroll a random item from the player's inventory
local Names = {
    en_us = "Perthro",
    spa = "Perthto"
}
local Name = Names.en_us
local Tag = "perthro"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Destroys one of your items at random#{{Collectible}} Grants a new item from the current room pool",
    spa = "Destruye uno de tus objetos aleatoriamente#{{Collectible}} Genera un nuevo objeto basado en la pool de la habitación"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, destroys a random item you possess. This includes passives or actives", "Instantly grants a new item from the current room pool.", "Holographic Effect: Destroys and grants a new item, then destroys and grants another.")

local function MC_USE_CARD(_, c, p, f, _, rng)
    local data = p:GetData().lootdeck
    local inv = helper.GetPlayerInventory(p, false, false, true, true)
    if helper.LengthOfTable(inv) > 0 then
        if not data[Tag] then
            local selectedItem = inv[rng:RandomInt(helper.LengthOfTable(inv))+1]
            p:RemoveCollectible(selectedItem)
            p:AnimateCollectible(selectedItem)
            lootdeck.sfx:Play(SoundEffect.SOUND_DEATH_CARD,1,0)
            data[Tag] = true
        end
        return false
    else
        helper.FuckYou(p)
        local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
        poof.Color = Color(0.6,0,0.6,1,0,0,0)
        return { nil, false }
    end
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    local game = Game()
    local room = game:GetRoom()
    local itemPool = game:GetItemPool()
    local data = p:GetData().lootdeck

    if data[Tag] then
        if p:IsExtraAnimationFinished() then
            local rng = p:GetCardRNG(Id)
            local currentPool = itemPool:GetPoolForRoom(room:GetType(), rng:GetSeed())
            if currentPool == -1 then currentPool = 0 end
            local collectible = itemPool:GetCollectible(currentPool, false, rng:GetSeed())

            local itemConfig = Isaac.GetItemConfig():GetCollectible(collectible)
            if itemConfig.Type == ItemType.ITEM_ACTIVE then
                if p:GetActiveItem() ~= 0 then
                    helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, p:GetActiveItem(), Game():GetRoom():FindFreePickupSpawnPosition(p.Position), Vector(0,0), p)
                    p:RemoveCollectible(p:GetActiveItem(), false, ActiveSlot.SLOT_PRIMARY)
                end
            end
            local hud = Game():GetHUD()
            hud:ShowItemText(p, itemConfig)
            p:AnimateCollectible(collectible)
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
            poof.Color = Color(0.6,0,0.6,1,0,0,0)
            lootdeck.sfx:Play(SoundEffect.SOUND_POWERUP1, 1, 0)
            p:AddCollectible(collectible)
            data[Tag] = nil
        end
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id,
            true,
            3
        },
        {
            ModCallbacks.MC_POST_PEFFECT_UPDATE,
            MC_POST_PEFFECT_UPDATE
        }
    }
}
