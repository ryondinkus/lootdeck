local helper = include('helper_functions')

-- Reroll a random item from the player's inventory
local Name = "Perthro"
local Tag = "perthro"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    local rng = lootdeck.rng
    local game = Game()
    local room = game:GetRoom()
    local roomType = room:GetType()
    local itemPool = game:GetItemPool()
    local inv = helper.GetPlayerInventory(p)
    for i,v in pairs(inv) do
        print(i .. " " .. v)
    end
    if helper.LengthOfTable(inv) > 0 then
        local selectedItem = inv[rng:RandomInt(helper.LengthOfTable(inv))+1]
        p:RemoveCollectible(selectedItem)
        local currentPool = itemPool:GetPoolForRoom(room:GetType(), lootdeck.rng:GetSeed())
        if currentPool == -1 then currentPool = 4 end
        local collectible = itemPool:GetCollectible(currentPool)
        local itemConfig = Isaac.GetItemConfig():GetCollectible(collectible)
        local hud = game:GetHUD()
        hud:ShowItemText(p, itemConfig)
        p:AnimateCollectible(collectible)
        lootdeck.sfx:Play(SoundEffect.SOUND_POWERUP1, 1, 0)
        p:AddCollectible(collectible)
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
