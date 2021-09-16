local helper = include('helper_functions')

-- A 1 in 3 chance of gaining the book of belial effect for the room,
-- gaining a heart canister for the room, or losing half a heart
local Name = "Pills! Red"
local Tag = "redPill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    local sfx = lootdeck.sfx
	local effect = lootdeck.rng:RandomInt(3)
	local data = p:GetData()
	if effect == 0 then
		if not data.redDamage then data.redDamage = 0 end
		data.redDamage = data.redDamage + 1
		p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		p:EvaluateItems()
		sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
		sfx:Play(SoundEffect.SOUND_DEVIL_CARD,1,0)
		local itemConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL)
		p:AddCostume(itemConfig, true)
	elseif effect == 1 then
		helper.AddTemporaryHealth(p, 2)
		sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
	else
		helper.TakeSelfDamage(p, 1)
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
	end
end

local function MC_POST_NEW_ROOM()
	for i=0,Game():GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
        if data.redDamage then
            data.redDamage = nil
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            p:EvaluateItems()
        end
	end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        },
		{
			ModCallbacks.MC_POST_NEW_ROOM,
			MC_POST_NEW_ROOM
		}
    }
}
