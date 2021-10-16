local helper = include('helper_functions')

-- Reroll a random item from the player's inventory
local Name = "Perthro"
local Tag = "perthro"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    local rng = lootdeck.rng
    local game = Game()
    local room = game:GetRoom()
    local itemPool = game:GetItemPool()
    local inv = helper.GetPlayerInventory(p)
    if helper.LengthOfTable(inv) > 0 then
        local selectedItem = inv[rng:RandomInt(helper.LengthOfTable(inv))+1]
        p:RemoveCollectible(selectedItem)
        p:AnimateCollectible(selectedItem)
        lootdeck.sfx:Play(SoundEffect.SOUND_DEATH_CARD,1,0)
        local currentPool = itemPool:GetPoolForRoom(room:GetType(), lootdeck.rng:GetSeed())
        if currentPool == -1 then currentPool = 0 end
        local collectible = itemPool:GetCollectible(currentPool)
        data[Tag .. "Collectible"] = collectible
        data[Tag] = true
        return false
    else
        helper.FuckYou(p)
    end
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    local data = p:GetData()
    if data[Tag] then
        if p:IsExtraAnimationFinished() then
            local collectible = data[Tag .. "Collectible"]
            local itemConfig = Isaac.GetItemConfig():GetCollectible(collectible)
            local hud = Game():GetHUD()
            hud:ShowItemText(p, itemConfig)
            p:AnimateCollectible(collectible)
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
            poof.Color = Color(0.6,0,0.6,1,0,0,0)
            lootdeck.sfx:Play(SoundEffect.SOUND_POWERUP1, 1, 0)
            p:AddCollectible(collectible)
            data[Tag .. "Collectible"] = nil
            data[Tag] = nil
        end
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
        },
        {
            ModCallbacks.MC_POST_PEFFECT_UPDATE,
            MC_POST_PEFFECT_UPDATE
        }
    }
}
