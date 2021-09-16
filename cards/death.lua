local helper = include("helper_functions")

-- Kills the player and revives them in the previous room with 3 bone hearts
local Name = "XIII. Death"
local Tag = "death"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local ReviveTag = string.format("%sRevive", Tag)

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    if not data[Tag] then data[Tag] = true end
    Game():ShakeScreen(15)
    lootdeck.sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 0)
    p:Die()
end

local function MC_POST_NEW_ROOM()
    for i=0,Game():GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
        if data[ReviveTag] then
            p:AddMaxHearts(-24)
            p:AddSoulHearts(-24)
            p:AddBoneHearts(-12)
            p:AddBoneHearts(3)
            if p:GetOtherTwin() then
                p:GetOtherTwin():AddMaxHearts(-24)
                p:GetOtherTwin():AddSoulHearts(-24)
                p:GetOtherTwin():AddBoneHearts(-12)
                p:GetOtherTwin():AddBoneHearts(3)
            end
            if p:GetPlayerType() == PlayerType.PLAYER_KEEPER or p:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
                p:AddMaxHearts(2, false)
                p:AddHearts(2)
            end
            if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN or p:GetPlayerType() == PlayerType.PLAYER_THESOUL then
                while p:GetBoneHearts() > 3 do
                    p:AddBoneHearts(-1)
                end
                p:AddSoulHearts(1)
            end
			p:AnimateCard(Id)
            lootdeck.sfx:Play(SoundEffect.SOUND_UNHOLY,1,0)
            data[Tag] = nil
            data[ReviveTag] = nil
        end
    end
end

-- TODO: add visual/audio indicators
-- keeper should revive with one coin heart and the flies of 3 bone hearts
local function MC_POST_PLAYER_UPDATE(_, p)
    helper.RevivePlayerPostPlayerUpdate(p, ReviveTag, Tag)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        },
        {
            ModCallbacks.MC_POST_PLAYER_UPDATE,
            MC_POST_PLAYER_UPDATE
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}
