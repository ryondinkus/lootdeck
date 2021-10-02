local helper = include("helper_functions")

-- Gives an extra penny for each penny picked up
local Name = "Counterfeit Penny"
local Tag = "counterfeitPenny"
local Id = Isaac.GetItemIdByName(Name)

local function MC_POST_GAME_STARTED()
    lootdeck.f.pennyCount = Isaac.GetPlayer(0):GetNumCoins()
end

local function MC_POST_UPDATE()
    local f = lootdeck.f
    helper.ForEachPlayer(function(p)
        if p:GetNumCoins() > (f.pennyCount or 0) then
            p:AddCoins(1)
            f.pennyCount = p:GetNumCoins()
        end
    end, Id)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_POST_GAME_STARTED,
            MC_POST_GAME_STARTED
        },
        {
            ModCallbacks.MC_POST_UPDATE,
            MC_POST_UPDATE
        }
    }
}