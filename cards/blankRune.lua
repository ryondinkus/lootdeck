local helper = LootDeckHelpers

-- A 1 in 6 chance of each player gaining a penny, spawning 2 tarotcards, take one heart of damage, gain 4 coins, spawn 5 tarotcards, or gain 6 coins
local Names = {
    en_us = "Blank Rune",
    spa = "Runa Vacía"
}
local Name = Names.en_us
local Tag = "blankRune"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Random chance for any of these effects:#{{Coin}} Gain 1 Coin#{{Card}} Spawn 2 Loot Cards#{{Warning}} Take a Full Heart of damage (non-lethal)#{{Coin}} Gain 4 Coins#{{Card}} Spawns 5 Loot Cards#{{Coin}} Gain 6 Coins# The rolled effect multiplies for each player!",
    spa = "Probabilidad de que ocurra uno de los siguientes efectos:#{{Coin}} Ganar una moneda#{{Card}}Generar 2 cartas de loot#{{Warning}}Recibir un corazón de daño (no fatal)#{{Coin}}Ganar 6 monedas#¡El efecto se multiplica para cada jugador!"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of six effects:", "- Gain 1 Coin", "- Spawns 2 Loot Cards", "- Take a Full Heart of damage. The damage will be negated if it would kill the player.", "- Gain 4 Coins", "- Spawns 5 Loot Cards", "- Gain 6 Coins", "The triggered effect will be multiplied for each player.", "- This applies to Twin Characters, such as Jacob and Esau and The Forgotten", "Holographic Effect: Performs the same random effect twice.")

local function MC_USE_CARD(_, c, p, f, shouldDouble, isDouble, rng)
	local game = Game()
	local sfx = lootdeck.sfx
    local room = game:GetRoom()

    helper.ForEachPlayer(function(player)
        local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player)
        poof.Color = Color(0.6,0,0.6,1,0,0,0)
    end)

    return helper.RunRandomFunction(rng, shouldDouble,
        function()
            helper.ForEachPlayer(function(player)
                sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
                sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, player.Position, Vector.Zero, p)
                player:AddCoins(1)
            end)
        end,
        function()
            helper.ForEachPlayer(function(player)
                sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
                for j=1,2 do
                    local cardId = helper.GetWeightedLootCardId(true, rng)
                    helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardId, room:FindFreePickupSpawnPosition(player.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
                end
            end)
        end,
        function()
            helper.ForEachPlayer(function(player)
                helper.TakeSelfDamage(player, 2)
                sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
            end)
            return false
        end,
        function()
            helper.ForEachPlayer(function(player)
                sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
                sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, player.Position, Vector.Zero, player)
                player:AddCoins(4)
            end)
        end,
        function()
            helper.ForEachPlayer(function(player)
                sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
                for j=1,5 do
                    local cardId = helper.GetWeightedLootCardId(true, rng)
                    helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardId, room:FindFreePickupSpawnPosition(player.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
                end
            end)
        end,
        function()
            helper.ForEachPlayer(function(player)
                sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
                sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, player.Position, Vector.Zero, player)
                player:AddCoins(6)
            end)
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
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
