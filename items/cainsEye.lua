local helper = include("helper_functions")

-- Applies blue map effect with one, compass effect with two, and map effect with three
local Name = "Cain's Eye"
local Tag = "cainsEye"
local Id = Isaac.GetItemIdByName(Name)
local Description = "Gain a random mapping effect ( {{Collectible54}} Treasure Map, {{Collectible21}} The Compass, {{Collectible246}} Blue Map) for each floor"
local WikiDescription = helper.GenerateEncyclopediaPage("On each floor, gain a random effect of either Treasure Map, The Compass, or Blue Map.", "- Additional copies of the passive grant extra mapping effects, avoiding duplicate effects.")

local function MC_POST_NEW_LEVEL()
    local game = Game()
    local rng = lootdeck.rng
    lootdeck.f.blueMap = false
    lootdeck.f.compass = false
    lootdeck.f.map = false
    helper.ForEachPlayer(function(p)
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
    end, Id)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    }
}
