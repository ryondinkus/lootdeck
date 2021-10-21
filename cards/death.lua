local helper = include("helper_functions")

-- Kills the player and revives them in the previous room with 3 bone hearts
local Name = "XIII. Death"
local Tag = "death"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "{{Warning}} Kills you on use#{{EmptyBoneHeart}} Revives you with 3 Empty Bones Hearts"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
                            {str = "Kills you on use."},
                            {str = "You revive with 3 Empty Bones Hearts."}
						}}

local ReviveTag = string.format("%sRevive", Tag)

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    if not data[Tag] then data[Tag] = true end
    Game():ShakeScreen(15)
    lootdeck.sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 0)
    p:Die()
    return false
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
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
    end)
end

local function MC_POST_PLAYER_UPDATE(_, p)
    helper.RevivePlayerPostPlayerUpdate(p, ReviveTag, Tag)
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
            ModCallbacks.MC_POST_PLAYER_UPDATE,
            MC_POST_PLAYER_UPDATE
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}
