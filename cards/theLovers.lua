local helper = LootDeckHelpers
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
local WikiDescription = helper.GenerateEncyclopediaPage("Grants two temporary Heart Containers for the duration of the room.", "Holographic Effect: Grants 3 temporary heart containers.")

local function MC_USE_CARD(_, c, p, f, shouldDouble)
    local data = p:GetData().lootdeck
	local tempHealth = 4
	if shouldDouble then
		tempHealth = tempHealth + 2
	end
    helper.AddTemporaryHealth(p, tempHealth)
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
    }
}
