
local helper = include("helper_functions")
local items = include("items/registry")

local Name = "Curved Horn"
local Tag = "curvedHorn"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: Stacking on a single player = more inital shots that are big, audio/visual indicators
local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.curvedHorn, SoundEffect.SOUND_VAMP_GULP)
end

local function MC_POST_NEW_ROOM()
    local game = Game()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        local data = p:GetData()
        if p:HasCollectible(Id) then
            data.curvedHornTearAmount = p:GetCollectibleNum(Id) or 1
        end
    end
end

local function MC_POST_FIRE_TEAR(_, tear)
    local p = tear:GetLastParent():ToPlayer()
    local data = p:GetData()
    if p:HasCollectible(Id) then
        if data.curvedHornTearAmount > 0 then
            tear.CollisionDamage = tear.CollisionDamage * 4
            tear.Size = tear.Size * 4
            tear.Scale = tear.Scale * 4
            data.curvedHornTearAmount = data.curvedHornTearAmount - 1
            lootdeck.sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK,1,0)
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
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM,
        },
        {
            ModCallbacks.MC_POST_FIRE_TEAR,
            MC_POST_FIRE_TEAR
        }
    }
}