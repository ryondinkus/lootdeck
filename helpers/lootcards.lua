local H = {}

function lootdeckHelpers.GetWeightedLootCardId(includeHolos)
    local cards = {}
    for _ ,card in pairs(lootcards) do
        if not card.Holographic then
            table.insert(cards, card)
        end
    end
    if lootdeckHelpers.LengthOfTable(cards) > 0 then
        local csum = 0
        local outcome = cards[0]
        for _, card in pairs(cards) do
            local weight = card.Weight
            local r = lootdeck.rng:RandomInt(csum + weight)
            if r >= csum then
                outcome = card
            end
            csum = csum + weight
        end
        if lootdeck.unlocks.gimmeTheLoot and includeHolos and lootdeckHelpers.PercentageChance(lootdeck.mcmOptions.HoloCardChance) then
            return lootcardKeys["holographic"..outcome.Tag].Id
        else
            return outcome.Id
        end
    end
end

function lootdeckHelpers.GetLootcardById(id)
    return lootcards[id]
end

function lootdeckHelpers.IsHolographic(id)
    return lootcards[id] and lootcards[id].Holographic
end

-- function for registering basic loot cards that copy item effects
function lootdeckHelpers.UseItemEffect(p, itemEffect, sound)
    p:UseActiveItem(itemEffect, false)
    if sound then
        lootdeck.sfx:Play(sound,1,0)
    end
end

-- function for registering basic loot cards that give items
function lootdeckHelpers.GiveItem(p, itemID, sound)
    p:AddCollectible(itemID)
    if sound then
        lootdeck.sfx:Play(sound,1,0)
    end
end

function lootdeckHelpers.FuckYou(p, type, variant, subtype, uses)
    lootdeck.sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,1,0)
    if type then
        for i = 1,(uses or 1) do
            lootdeckHelpers.SpawnEntity(p, type, variant or 0, subtype or 0, 1, Game():GetRoom():FindFreePickupSpawnPosition(p.Position))
        end
    end
end

return H