
local helper = include("helper_functions")
local items = include("items/registry")

local Name = "Cain's Eye"
local Tag = "cainsEye"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: Stacking support adds multiple mapping effects
local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.cainsEye, SoundEffect.SOUND_VAMP_GULP)
end

local function MC_POST_NEW_LEVEL()
    local game = Game()
    local rng = lootdeck.rng
    lootdeck.f.blueMap = false
    lootdeck.f.compass = false
    lootdeck.f.map = false
    local f = lootdeck.f
    for x=0,game:GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(x)
        local data = p:GetData()
        if p:HasCollectible(items.cainsEye) then
            local level = game:GetLevel()
            local effects = 0
            local effectAmount = p:GetCollectibleNum(items.cainsEye)
            if effectAmount > 3 then effectAmount = 3 end
            while effects < effectAmount do
                local effect = rng:RandomInt(3)
                if effect == 0 and not f.blueMap then
                    level:ApplyBlueMapEffect()
                    f.blueMap = true
                    effects = effects + 1
                elseif effect == 1 and not f.compass then
                    level:ApplyCompassEffect(true)
                    f.compass = true
                    effects = effects + 1
                elseif effect == 2 and not f.map then
                    level:ApplyMapEffect()
                    f.map = true
                    effects = effects + 1
                end
            end
        end
        if data.strength then
            data.strength = nil
            local color = Color(1,1,1,1,0,0,0)
            p.Color = color
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            p:EvaluateItems()
        end
    end
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
        },
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL,
        }
    }
}