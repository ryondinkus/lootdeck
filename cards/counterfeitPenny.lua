
local helper = include("helper_functions")
local items = include("items/registry")

local Name = "Counterfeit Penny"
local Tag = "counterfeitPenny"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: Stacking support? extra pennies
local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.counterfeitPenny, SoundEffect.SOUND_VAMP_GULP)
end

local function MC_POST_UPDATE()
    local game = Game()
    for x=0,game:GetNumPlayers() do
        if Isaac.GetPlayer(x):HasCollectible(items.counterfeitPenny) then
            lootdeck.f.newPennies = Isaac.GetPlayer(0):GetNumCoins()
            if Isaac.GetPlayer(0):GetNumCoins() > lootdeck.f.pennyCount then
                Isaac.GetPlayer(0):AddCoins(1)
                lootdeck.f.pennyCount = Isaac.GetPlayer(0):GetNumCoins()
            end
        end
    end
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
            ModCallbacks.MC_POST_UPDATE,
            MC_POST_UPDATE,
        }
    }
}