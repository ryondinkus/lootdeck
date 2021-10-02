-- Gives an extra penny for each penny picked up
local Name = "Counterfeit Penny"
local Tag = "counterfeitPenny"
local Id = Isaac.GetItemIdByName(Name)

local function MC_POST_GAME_STARTED()
    lootdeck.f.pennyCount = Isaac.GetPlayer(0):GetNumCoins()
end

local function MC_POST_UPDATE()
    local game = Game()
    local f = lootdeck.f
    for x=0,game:GetNumPlayers() do
        if Isaac.GetPlayer(x):HasCollectible(Id) then
            if Isaac.GetPlayer(0):GetNumCoins() > (f.pennyCount or 0) then
                Isaac.GetPlayer(0):AddCoins(1)
                f.pennyCount = Isaac.GetPlayer(0):GetNumCoins()
            end
        end
    end
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