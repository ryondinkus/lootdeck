local entityVariants = include("entityVariants/registry")
local helper = include('helper_functions')

-- A 1 in 6 chance of gaining 1 coin, deal half a heart of damage (if lethal, heal to full health), spawn 3 tarotcards, lost 4 coins, gain 5 coins, or spawn an item from the arcade list
local Name = "X. Wheel of Fortune"
local Tag = "wheelOfFortune"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Random chance for any of these effects:#{{Coin}}{{ArrowUp}} Gain 1 Coin#{{Warning}} Take a Half Heart of damage (non-lethal)#{{Card}} Spawns 3 Loot Cards#{{Coin}}{{ArrowDown}} Lose 4 Coins#{{Coin}}{{ArrowUp}} Gain 5 Coins#{{ArcadeRoom}} Spawn a random Arcade-exclusive item"
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of six effects:", "- Gain 1 Coin", "- Take a Half Heart of damage. The damage will be negated if it would kill the player.", "- Spawns 3 Loot Cards", "- Lose 4 Coins", "- Gain 5 Coins", "- Spawn a random arcade-exclusive item")

local arcadeItems = {
    CollectibleType.COLLECTIBLE_DOLLAR,
    CollectibleType.COLLECTIBLE_SKATOLE,
    CollectibleType.COLLECTIBLE_BLOOD_BAG,
    CollectibleType.COLLECTIBLE_IV_BAG,
    CollectibleType.COLLECTIBLE_BLOOD_BOMBS,
    CollectibleType.COLLECTIBLE_CRYSTAL_BALL
}

local function MC_USE_CARD(_, c, p)
    local game = Game()
    local sfx = lootdeck.sfx
    local rng = lootdeck.rng
    local room = game:GetRoom()
    local effect = rng:RandomInt(6)
    if effect == 0 then
        p:AddCoins(1)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
    elseif effect == 1 then
		helper.TakeSelfDamage(p, 1)
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
        return false
    elseif effect == 2 then
        for j=1,3 do
            local cardId = helper.GetWeightedLootCardId()
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardId, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
        end
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
    elseif effect == 3 then
        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 0)
        for i=0,3 do
            if p:GetNumCoins() > 0 then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostPenny.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360)), p)
                p:AddCoins(-1)
            else
                break
            end
        end
    elseif effect == 4 then
        p:AddCoins(5)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
    elseif effect == 5 then
        local room = game:GetRoom()
        local collectible = arcadeItems[rng:RandomInt(#arcadeItems)+1]
        local spawnPos = room:FindFreePickupSpawnPosition(p.Position)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible, spawnPos, Vector.Zero, p)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
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
