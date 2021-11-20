local helper = include("helper_functions")
local costumes = include("costumes/registry")

-- Gain two temporary hearts for the room
local Names = {
    en_us = "VI. The Lovers",
    spa = "VI. Los Amantes"
}
local Name = Names.en_us
local Tag = "theLovers"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "{{Heart}} +2 Heart Containers for the room",
    spa = "Otorga 2 contenedores de corazón durante la habitación"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants two temporary Heart Containers for the duration of the room.")

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    helper.AddTemporaryHealth(p, 4)
    if not data[Tag] then data[Tag] = true end
    p:AddNullCostume(costumes.lovers)
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data[Tag] then
            data[Tag] = nil
            p:TryRemoveNullCostume(costumes.lovers)
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
            Id,
            true
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
    }
}
