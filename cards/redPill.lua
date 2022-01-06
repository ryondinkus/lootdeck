local helper = LootDeckAPI
local costumes = include("costumes/registry")

-- A 1 in 3 chance of gaining the book of belial effect for the room,
-- gaining a heart canister for the room, or losing half a heart
local Names = {
    en_us = "Pills! Red",
    spa = "¡Píldora! Roja"
}
local Name = Names.en_us
local Tag = "redPill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
	en_us = "Random chance for any of these effects:#{{ArrowUp}} +2 Damage for the room#{{Heart}} +1 Heart Container for the room#{{Warning}} Take 1 Half Heart of damage (non-fatal)",
	spa = "Probabilidad de que ocurra uno de los siguientes efectos:#{{ArrowUp}} +2 de daño durante la habitación#{{Heart}} +1 contenedor de corazón durante la habitación#{{Warning}} Recibir medio corazón de daño (no fatal)"
}
local HolographicDescriptions = {
	en_us = "Random chance for any of these effects:#{{ArrowUp}} {{ColorRainbow}}+4{{CR}} Damage for the room#{{Heart}} {{ColorRainbow}}+2{{CR}} Heart Container for the room#{{Warning}} Take {{ColorRainbow}}1 Full Heart{{CR}} of damage (non-fatal)",
	spa = "Probabilidad de que ocurra uno de los siguientes efectos:#{{ArrowUp}} {{ColorRainbow}}+4{{CR}} de daño durante la habitación#{{Heart}} {{ColorRainbow}}+2{{CR}} contenedor de corazón durante la habitación#{{Warning}} Recibir {{ColorRainbow}}un corazón{{CR}} de daño (no fatal)"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of three effects:", "- +1 Damage up for the room", "- +1 filled Heart Container for the room", "- Take 1 Half Heart of damage. The damage will be negated if it would kill the player.", "Holographic Effect: Performs the same random effect twice.")

local function MC_USE_CARD(_, c, p, f, shouldDouble, isDouble, rng)
    local sfx = lootdeck.sfx
	local data = p:GetData().lootdeck

	return helper.RunRandomFunction(rng, shouldDouble,
		function()
			if not data[Tag] then data[Tag] = 0 end
			data[Tag] = data[Tag] + 1
			p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			p:EvaluateItems()
			sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
			sfx:Play(SoundEffect.SOUND_DEVIL_CARD, 1, 0)
			Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL)
			p:AddNullCostume(costumes.redPill)
		end,
		function()
			helper.AddTemporaryHealth(p, 2)
			sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
		end,
		function()
			helper.TakeSelfDamage(p, 1)
			sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
			return false
		end)
end

local function MC_POST_NEW_ROOM()
	helper.ForEachPlayer(function(p, data)
        if data[Tag] then
            data[Tag] = nil
            p:TryRemoveNullCostume(costumes.redPill)
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            p:EvaluateItems()
        end
    end)
end

local function MC_EVALUATE_CACHE(_, p, f)
	local data = p:GetData().lootdeck
    if not data[Tag] then data[Tag] = 0 end
    if f == CacheFlag.CACHE_DAMAGE then
        if data[Tag] then
            p.Damage = p.Damage + (2 * data[Tag])
        end
    end
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
        },
		{
			ModCallbacks.MC_POST_NEW_ROOM,
			MC_POST_NEW_ROOM
		},
		{
			ModCallbacks.MC_EVALUATE_CACHE,
			MC_EVALUATE_CACHE
		}
    }
}
