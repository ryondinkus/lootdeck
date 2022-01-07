local helper = LootDeckAPI

-- A 1 in 2 chance of losing half a heart and gaining 4 coins or losing a full heart and gaining 8 coins
local Names = {
    en_us = "XVI. Temperance",
    spa = "XIV. Templanza"
}
local Name = Names.en_us
local Tag = "temperance"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Random chance for any of these effects:#{{Warning}} Take 1 Half Heart of damage (fatal), gain 4 Cents#{{Warning}} Take 1 Full Heart of damage (fatal), gain 8 cents",
    spa = "Probabilidad de que ocurra uno de los siguientes efectos:#{{Warning}} Hacer medio corazón de daño (fatal), ganando 4 monedas#{{Warning}} Hace un corazón de daño (fatal), ganando 8 monedas"
}
local HolographicDescriptions = {
    en_us = "Random chance for any of these effects:#{{Warning}} Take {{ColorRainbow}}1 Full Heart{{CR}} of damage (fatal), gain {{ColorRainbow}}8{{CR}} Cents#{{Warning}} Take {{ColorRainbow}}2 Full Hearts{{CR}} of damage (fatal), gain {{ColorRainbow}}16{{CR}} cents",
    spa = "Probabilidad de que ocurra uno de los siguientes efectos:#{{Warning}} Hacer {{ColorRainbow}}un corazón{{CR}} de daño (fatal), ganando {{ColorRainbow}}8{{CR}} monedas#{{Warning}} Hace {{ColorRainbow}}2 corazónes{{CR}} de daño (fatal), ganando {{ColorRainbow}}16{{CR}} monedas"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of either effects:", "- Take 1 Half Heart of damage, gain 4 Coins. This damage can kill the player.", "- Take 1 Full Heart of damage, gain 8 Coins. This damage can kill the player.", "Holographic Effect: Performs the same random effect twice.")

local function MC_USE_CARD(_, c, p, f, shouldDouble, isDouble, rng)
    helper.RunRandomFunction(rng, shouldDouble,
    function()
		helper.TakeSelfDamage(p, 1, true, true)
		for i=0,3 do
            helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, p.Position, Vector.FromAngle(rng:RandomInt(360)), nil)
        end
    end,
    function()
        helper.TakeSelfDamage(p, 2, true, true)
        for i=0,7 do
            helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, p.Position, Vector.FromAngle(rng:RandomInt(360)), nil)
        end
    end)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, p.Position, Vector.Zero, p)
    lootdeck.sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN, 1, 0)
    return false
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
