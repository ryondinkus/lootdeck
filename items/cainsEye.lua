-- Applies blue map effect with one, compass effect with two, and map effect with three
local Name = "Cain's Eye"
local Tag = "cainsEye"
local Id = Isaac.GetItemIdByName(Name)

local function MC_POST_NEW_LEVEL()
    local game = Game()
    local rng = lootdeck.rng
    lootdeck.f.blueMap = false
    lootdeck.f.compass = false
    lootdeck.f.map = false
    for x=0,game:GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(x)
        local data = p:GetData()
        if p:HasCollectible(Id) then
            local level = game:GetLevel()
            local effects = 0
            local effectAmount = p:GetCollectibleNum(Id)
            if effectAmount > 3 then effectAmount = 3 end
            while effects < effectAmount do
                local effect = rng:RandomInt(3)
                if effect == 0 and not lootdeck.f.blueMap then
                    level:ApplyBlueMapEffect()
                    lootdeck.f.blueMap = true
                elseif effect == 1 and not lootdeck.f.compass then
                    level:ApplyCompassEffect(true)
                    lootdeck.f.compass = true
                elseif effect == 2 and not lootdeck.f.map then
                    level:ApplyMapEffect()
                    lootdeck.f.map = true
                else
					effects = effects - 1
				end
				effects = effects + 1
            end
        end
        -- TODO move to own file
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
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    }
}
