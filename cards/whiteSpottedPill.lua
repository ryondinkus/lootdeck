local helper = LootDeckHelpers

-- Shuffle values of coins, keys, and bombs | reroll all items in room | reroll all of your passives
local Names = {
    en_us = "Pills! White Spotted",
    spa = "¡Píldora! con Puntos Blancos"
}
local Name = Names.en_us
local Tag = "whiteSpottedPill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Random chance for any of these effects:# Swaps the amounts of your coins, keys, and bombs# Rerolls all item pedestals in the room# Rerolls all of your passives",
    spa = "Probabilidad de que ocurra uno de los siguientes efectos:#Pone de revés tu cantidad de monedas, llaves y bombas#Rerolea todos los objetos de pedestales#Rerolea todos tus objetos pasivos"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of three effects:", "- Swaps the amounts of your coins, keys, and bombs.", "- Rerolls all pedestals in the room.", "- Rerolls all of your passive items.", "Holographic Effect: Performs the same random effect twice.")

local function MC_USE_CARD(_, c, p, f, shouldDouble, rng)
    local sfx = lootdeck.sfx

    return helper.RandomChance(rng, shouldDouble,
        function()
            sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
            local coins = p:GetNumCoins()
            local bombs = p:GetNumBombs()
            local keys = p:GetNumKeys()
            p:AddCoins(bombs - coins)
            p:AddBombs(keys - bombs)
            p:AddKeys(coins - keys)
        end,
        function()
            helper.UseItemEffect(p, CollectibleType.COLLECTIBLE_D6, SoundEffect.SOUND_EDEN_GLITCH)
        end,
        function()
            p:PlayExtraAnimation("Glitch")
            helper.UseItemEffect(p, CollectibleType.COLLECTIBLE_D4, SoundEffect.SOUND_EDEN_GLITCH)
            return false
        end)
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
