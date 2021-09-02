local helper = include('helper_functions')

local Name = "XI. Strength"
local Tag = "strength"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_D7)

    local data = p:GetData()
    local sprite = p:GetSprite()
    if not data.strength then data.strength = 1
    else
        data.strength = data.strength + 1
    end
    for i=1,data.strength or 0 do
        local color = Color(1,1,1,1,data.strength/10,0,0)
        --color:SetColorize(0.1,0,0,1)
        sprite.Color = color
    end
    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    p:EvaluateItems()
    lootdeck.sfx:Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE, 1, 0)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}