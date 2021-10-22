local helper = include('helper_functions')

-- Shuffle values of coins, keys, and bombs | reroll all items in room | reroll all of your passives
local Name = "Pills! White Spotted"
local Tag = "whiteSpottedPill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Random chance for any of these effects:# Swaps the amounts of your coins, keys, and bombs# Rerolls all item pedestals in the room# Rerolls all of your passives"
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of three effects:", "- Swaps the amounts of your coins, keys, and bombs.", "- Rerolls all pedestals in the room.", "- Rerolls all of your passive items.")

local function MC_USE_CARD(_, c, p)
    local sfx = lootdeck.sfx
    local effect = lootdeck.rng:RandomInt(3)
    if effect == 0 then
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
        local coins = p:GetNumCoins()
        local bombs = p:GetNumBombs()
        local keys = p:GetNumKeys()
        p:AddCoins(bombs - coins)
        p:AddBombs(keys - bombs)
        p:AddKeys(coins - keys)
    elseif effect == 1 then
        helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_D6, SoundEffect.SOUND_EDEN_GLITCH)
    else
        p:PlayExtraAnimation("Glitch")
        helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_D4, SoundEffect.SOUND_EDEN_GLITCH)
        return false
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
