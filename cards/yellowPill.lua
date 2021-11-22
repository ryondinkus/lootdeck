local helper = include("helper_functions")

local entityVariants = include("entityVariants/registry")

-- A 1 in 3 chance of gaining 4 coins, gaining 7 coins, or losing 4 coins
local Names = {
    en_us = "Pills! Yellow",
    spa = "¡Píldora! Amarilla"
}
local Name = Names.en_us
local Tag = "yellowPill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
	en_us = "Random chance for any of these effects:#{{Coin}}{{ArrowUp}} +4 Coins#{{Coin}}{{ArrowUp}} +7 Coins#{{Coin}}{{ArrowDown}} -4 Coins",
	spa = "Probabilidad de que ocurra uno de los siguientes efectos:#{{Coin}}{{ArrowUp}} +4 monedas#{{Coin}}{{ArrowUp}} +7 monedas#{{Coin}}{{ArrowDown}} -4 monedas"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of three effects:", "- Gain 4 Coins", "- Gain 7 Coins", "- Lose 4 Coins, if able.", "Holographic Effect: Performs the same random effect twice.")

local function MC_USE_CARD(_, c, p, f, shouldDouble)
	local sfx = lootdeck.sfx
	local rng = lootdeck.rng

	local function coinPickup()
		sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
		sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
	end

	helper.RandomChance(shouldDouble,
	function ()
		coinPickup()
		p:AddCoins(4)
	end,
	function ()
		coinPickup()
		p:AddCoins(7)
	end,
	function ()
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
		for i=1,4 do
			if p:GetNumCoins() > 0 then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostPenny.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, nil)
				p:AddCoins(-1)
			end
		end
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
