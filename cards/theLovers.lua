local helper = include("helper_functions")
local costumes = include("costumes/registry")

-- Gain two temporary hearts for the room
local Name = "VI. The Lovers"
local Tag = "theLovers"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "{{Heart}} +2 Heart Containers for the room"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
                            {str = "Grants two temporary Heart Containers for the duration of the room."},
						}}

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
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
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
