local helper = lootdeckHelpers

-- Applies blue map effect with one, compass effect with two, and map effect with three
local Names = {
    en_us = "Cain's Eye",
    spa = "Ojo de Cain"
}
local Name = Names.en_us
local Tag = "cainsEye"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "Gain a random mapping effect ( {{Collectible54}} Treasure Map, {{Collectible21}} The Compass, {{Collectible246}} Blue Map) for each floor",
    spa = "Gana efectos de mapas ({{Collectible54}} Mapa del Tesoro, {{Collectible21}} La Brújula, {{Collectible}}) por cada piso"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On each floor, gain a random effect of either Treasure Map, The Compass, or Blue Map.", "- Additional copies of the passive grant extra mapping effects, avoiding duplicate effects.")

local function MC_POST_NEW_LEVEL()
    local game = Game()
    local rng = lootdeck.rng
    helper.ForEachPlayer(function(p)
        local level = game:GetLevel()
        local effects = 0
        local effectAmount = p:GetCollectibleNum(Id)
        if effectAmount > 3 then effectAmount = 3 end
        while effects < effectAmount do
            local effect = rng:RandomInt(3)
            if effect == 0 and not level:GetStateFlag(LevelStateFlag.STATE_BLUE_MAP_EFFECT) then
                level:ApplyBlueMapEffect()
            elseif effect == 1 and not level:GetStateFlag(LevelStateFlag.STATE_COMPASS_EFFECT) then
                level:ApplyCompassEffect(true)
            elseif effect == 2 and not level:GetStateFlag(LevelStateFlag.STATE_MAP_EFFECT) then
                level:ApplyMapEffect()
            else
                effects = effects - 1
            end
            effects = effects + 1
        end
    end, Id)
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    }
}
