local H = {}

function LootDeckHelpers.GenerateHolographicCard(card)
    card.HUDAnimationName = "Idle"
    card.PickupAnimationName = "Idle"
    card.UseAnimationName = "IdleFast"

    local holoCard = table.deepCopy(card)
    holoCard.IsHolographic = true
    holoCard.HUDAnimationName = "IdleHolo"
    holoCard.PickupAnimationName = "IdleHolo"
    holoCard.UseAnimationName = "IdleFastHolo"

    local callbacks = {}

    for _, callback in pairs(card.callbacks) do
        if callback[1] == ModCallbacks.MC_USE_CARD then
            table.insert(callbacks, callback)
            break
        end
    end

    holoCard.callbacks = callbacks

    local holographicCardName = "Holographic "..card.Name
    local holographicCardId = Isaac.GetCardIdByName(holographicCardName)

    holoCard.Tag = "holographic"..card.Tag
    holoCard.Id = holographicCardId
	holoCard.Descriptions.en_us = card.Descriptions.en_us .. "#{{ColorRainbow}}HOLOGRAPHIC: Effect doubled!"
	holoCard.Descriptions.spa = card.Descriptions.spa .. "#{{ColorRainbow}}HOLOGRÁFICA: ¡Efecto doble!"

	return holoCard
end

function LootDeckHelpers.GetWeightedLootCardId(includeHolos, rng)
    local cards = {}
    for _ ,card in pairs(lootcards) do
        if not card.IsHolographic then
            table.insert(cards, card)
        end
    end
    if LootDeckHelpers.LengthOfTable(cards) > 0 then
        local csum = 0
        local outcome = cards[0]
        for _, card in pairs(cards) do
            local weight = card.Weight
            local r
            if rng ~= nil then
                r = rng:RandomInt(csum + weight)
            else
                r = lootdeck.rng:RandomInt(csum + weight)
            end
            if r >= csum then
                outcome = card
            end
            csum = csum + weight
        end
        if lootdeck.unlocks.gimmeTheLoot and includeHolos and LootDeckHelpers.PercentageChance(lootdeck.mcmOptions.HoloCardChance) then
            return lootcardKeys["holographic"..outcome.Tag].Id
        else
            return outcome.Id
        end
    end
end

function LootDeckHelpers.GetLootcardById(id)
    return lootcards[id]
end

function LootDeckHelpers.IsHolographic(id)
    return lootcards[id] and lootcards[id].IsHolographic
end

-- function for registering basic loot cards that copy item effects
function LootDeckHelpers.UseItemEffect(p, itemEffect, sound)
    p:UseActiveItem(itemEffect, false)
    if sound then
        lootdeck.sfx:Play(sound,1,0)
    end
end

-- function for registering basic loot cards that give items
function LootDeckHelpers.GiveItem(p, itemID, sound)
    p:AddCollectible(itemID)
    if sound then
        lootdeck.sfx:Play(sound,1,0)
    end
end

function LootDeckHelpers.FuckYou(p, type, variant, subtype, uses)
    lootdeck.sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,1,0)
    if type then
        for i = 1,(uses or 1) do
            LootDeckHelpers.SpawnEntity(p, type, variant or 0, subtype or 0, 1, Game():GetRoom():FindFreePickupSpawnPosition(p.Position))
        end
    end
end

return H
