local helper = include("helper_functions")
local sounds = include("sounds/registry")

-- Gives an extra penny for each penny picked up
local Names = {
    en_us = "Counterfeit Penny",
    spa = "Moneda Falsificada"
}
local Name = Names.en_us
local Tag = "counterfeitPenny"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "Get an additional +1 Coin every time you gain Coins",
    spa = "Recibes una moneda adicional cada vez que consigues monedas"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Gain an additional +1 Coin whenever you gain coins.")

local function MC_POST_GAME_STARTED()
    lootdeck.f.pennyCount = Isaac.GetPlayer(0):GetNumCoins()
end

local function MC_POST_UPDATE()
    local f = lootdeck.f
    helper.ForEachPlayer(function(p)
        if f.pennyCount and p:GetNumCoins() > f.pennyCount then
            p:AddCoins(1)
            lootdeck.sfx:Stop(SoundEffect.SOUND_PENNYPICKUP)
            lootdeck.sfx:Play(sounds.counterfeitPenny, 1, 0)
        end
    end, Id)
    lootdeck.f.pennyCount = Isaac.GetPlayer(0):GetNumCoins()
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_POST_GAME_STARTED,
            MC_POST_GAME_STARTED
        },
        {
            ModCallbacks.MC_POST_UPDATE,
            MC_POST_UPDATE
        }
    }
}
