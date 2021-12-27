local helper = lootdeckHelpers
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
    en_us = "When picking up a coin of any type, there is a low chance for the coin to respawn, similar to a Golden Penny# Rarer coin types have a lower chance to respawn",
    spa = "Al tomar una moneda de cualquier tipo, hay una posibilidad de que esta moneda reaparazca, de forma similar a una moneda dorada#Mayor rareza = menor posibilidad de aparición"
}
local WikiDescription = helper.GenerateEncyclopediaPage("When picking up a coin of any type, there is a low chance for the coin to respawn, similar to a Golden Penny.", "- Penny: 40%", "- Nickel: 33%", "- Dime: 33%", "- Double Penny: 33%", "- Lucky Penny: 25%", "- Charged Penny: 25%", "- Double Coins (except Double Pennies) are half as likely to respawn as their single counterpart.", "- Additional copies increase the respawn chance by 25%, up to 90%")

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
