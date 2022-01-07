local entityVariants = include("entityVariants/registry")
local helper = LootDeckAPI

-- A 1 in 6 chance of gaining 1 coin, deal half a heart of damage (if lethal, heal to full health), spawn 3 tarotcards, lost 4 coins, gain 5 coins, or spawn an item from the arcade list
local Names = {
    en_us = "X. Wheel of Fortune",
    spa = "X. Rueda de la Fortuna"
}
local Name = Names.en_us
local Tag = "wheelOfFortune"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Random chance for any of these effects:#{{Coin}}{{ArrowUp}} Gain 1 Coin#{{Warning}} Take a Half Heart of damage (non-lethal)#{{LootCard}} Spawns 3 Loot Cards#{{Coin}}{{ArrowDown}} Lose 4 Coins#{{Coin}}{{ArrowUp}} Gain 5 Coins#{{ArcadeRoom}} Spawn a random Arcade-exclusive item",
    spa = "Probabilidad de que ocurra uno de los siguientes efectos:#{{ArrowUp}} Ganas una moneda#{{Warning}} recibes medio corazón de daño (no fatal)#{{LootCard}} Genera 3 cartas de Loot#{{Coin}}{{ArrowDown}} Pierdes 4 monedas#{{Coin}}{{ArrowUp}} Ganas 5 monedas#{{ArcadeRoom}} Genera un objeto aleatorio exclusivo del Arcade"
}
local HolographicDescriptions = {
    en_us = "Random chance for any of these effects:#{{Coin}}{{ArrowUp}} Gain {{ColorRainbow}}2{{CR}} Coin#{{Warning}} Take a {{ColorRainbow}}Full Heart{{CR}} of damage (non-lethal)#{{LootCard}} Spawns {{ColorRainbow}}6{{CR}} Loot Cards#{{Coin}}{{ArrowDown}} Lose {{ColorRainbow}}8{{CR}} Coins#{{Coin}}{{ArrowUp}} Gain {{ColorRainbow}}10{{CR}} Coins#{{ArcadeRoom}} Spawn {{ColorRainbow}}2{{CR}} random Arcade-exclusive items",
    spa = "Probabilidad de que ocurra uno de los siguientes efectos:#{{ArrowUp}} Ganas {{ColorRainbow}}2{{CR}} moneda#{{Warning}} recibes {{ColorRainbow}}un corazón{{CR}} de daño (no fatal)#{{LootCard}} Genera {{ColorRainbow}}6{{CR}} cartas de Loot#{{Coin}}{{ArrowDown}} Pierdes {{ColorRainbow}}8{{CR}} monedas#{{Coin}}{{ArrowUp}} Ganas {{ColorRainbow}}10{{CR}} monedas#{{ArcadeRoom}} Genera {{ColorRainbow}}2{{CR}} objetos aleatorios exclusivos del Arcade"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of six effects:", "- Gain 1 Coin", "- Take a Half Heart of damage. The damage will be negated if it would kill the player.", "- Spawns 3 Loot Cards", "- Lose 4 Coins", "- Gain 5 Coins", "- Spawn a random arcade-exclusive item", "Holographic Effect: Performs the same random effect twice.")

local arcadeItems = {
    CollectibleType.COLLECTIBLE_DOLLAR,
    CollectibleType.COLLECTIBLE_SKATOLE,
    CollectibleType.COLLECTIBLE_BLOOD_BAG,
    CollectibleType.COLLECTIBLE_IV_BAG,
    CollectibleType.COLLECTIBLE_BLOOD_BOMBS,
    CollectibleType.COLLECTIBLE_CRYSTAL_BALL
}

local function MC_USE_CARD(_, c, p, f, shouldDouble, isDouble, rng)
    local game = Game()
    local sfx = lootdeck.sfx
    local room = game:GetRoom()

    helper.RunRandomFunction(rng, shouldDouble,
    function()
        p:AddCoins(1)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0)
    end,
    function()
        helper.TakeSelfDamage(p, 1)
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
    end,
    function()
        for j=1,3 do
            local cardId = helper.GetWeightedLootCardId(true, rng)
            helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardId, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
        end
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0)
    end,
    function()
        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 0)
        for i=0,3 do
            if p:GetNumCoins() > 0 then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostPenny.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360)), p)
                p:AddCoins(-1)
            else
                break
            end
        end
    end,
    function()
        p:AddCoins(5)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0)
    end,
    function()
        local collectible = arcadeItems[rng:RandomInt(#arcadeItems)+1]
        local spawnPos = room:FindFreePickupSpawnPosition(p.Position)
        helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible, spawnPos, Vector.Zero, p)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0)
    end)
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
    HolographicDescriptions = HolographicDescriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
