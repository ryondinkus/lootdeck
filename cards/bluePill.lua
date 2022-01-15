local entityVariants = include("entityVariants/registry")
local helper = LootDeckAPI

-- A 1 in 3 chance of spawning a tarotcard, thee tarotcards, or losing one coin, bomb, and key
local Names = {
    en_us = "Pills! Blue",
    spa = "¡Píldora! Azul"
}
local Name = Names.en_us
local Tag = "bluePill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
	en_us = "Random chance for any of these effects:#{{LootCard}} Spawn 1 Loot Card#{{LootCard}} Spawn 3 Loot Cards#{{ArrowDown}} Lose a Coin, Bomb, and Key",
	spa = "Probabilidad de que ocurra uno de los siguientes efectos:#{{LootCard}} Genera una carta de loor#{{LootCard}} Genera 3 cartas de loot#Pierdes una moneda, una llave y una bomba"
}
local HolographicDescriptions = {
	en_us = "Random chance for any of these effects:#{{LootCard}} Spawn {{ColorRainbow}}2{{CR}} Loot Cards#{{LootCard}} Spawn {{ColorRainbow}}6{{CR}} Loot Cards#{{ArrowDown}} Lose {{ColorRainbow}}2{{CR}} Coins, Bombs, and Keys",
	spa = "Probabilidad de que ocurra uno de los siguientes efectos:#{{LootCard}} Genera {{ColorRainbow}}2{{CR}} cartas de loot#{{LootCard}} Genera {{ColorRainbow}}6{{CR}} cartas de loot#Pierdes {{ColorRainbow}}2{{CR}} monedas, {{ColorRainbow}}2{{CR}} llaves y {{ColorRainbow}}2{{CR}} bombas"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of three effects:", "- Spawns a Loot Card.", "- Spawns 3 Loot Cards", "- Lose a Coin, Key, and Bomb, if possible.", "Holographic Effect: Performs the same random effect twice.")

local function MC_USE_CARD(_, c, p, f, shouldDouble, isDouble, rng)
	local sfx = lootdeck.sfx
	local room = Game():GetRoom()

	helper.RunRandomFunction(rng, shouldDouble,
	function()
		sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
		local cardId = helper.GetWeightedLootCardId(true, rng)
		helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardId, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
	end,
	function()
		sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
		for i=0,2 do
			local cardId = helper.GetWeightedLootCardId(true, rng)
			helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardId, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
		end
	end,
	function()
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
		if p:GetNumCoins() > 0 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostPenny.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
			p:AddCoins(-1)
		end
		if p:GetNumBombs() > 0 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostBomb.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
			p:AddBombs(-1)
		end
		if p:GetNumKeys() > 0 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostKey.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
			p:AddKeys(-1)
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
    HolographicDescriptions = HolographicDescriptions,
	WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    },
    Tests = {
        {
            action = TestActions.GIVE_CARD,
            arguments = {
                id = Id
            }
        },
		{
            action = TestActions.ENABLE_DEBUG_FLAG,
            arguments = {
                flag = 8
            }
        },
        {
            action = TestActions.GIVE_ITEM,
            arguments = {
				id = CollectibleType.COLLECTIBLE_BLANK_CARD
			}
        },
        {
            action = TestActions.USE_ITEM,
            arguments = {}
        },
        {
            action = TestActions.REPEAT,
            arguments = {
				times = 9
			}
        }
    }
}
