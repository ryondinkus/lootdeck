local helper = include("helper_functions")

-- Gives a chance of reviving in the previous room with half a heart
local Name = "Broken Ankh"
local Tag = "brokenAnkh"
local Id = Isaac.GetItemIdByName(Name)
local Description = "On death, 1/6 chance to revive with half a heart"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On player death, you have a 1/6 chance of reviving with half a heart."},
							{str = "- Additional copies of the passive grant an extra revival chance up to 3/6."},
						}}

local ReviveTag = string.format("%sRevive", Tag)

local function MC_POST_NEW_ROOM()
    local sfx = lootdeck.sfx
    helper.ForEachPlayer(function(p, data)
		if p:HasCollectible(Id) then
			data[ReviveTag] = false
			if helper.PercentageChance(100 / 6 * p:GetCollectibleNum(Id), 50) then
				data[ReviveTag] = true
			end
		end

        if data[Tag] then
            if p:GetPlayerType() == PlayerType.PLAYER_KEEPER or p:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
                p:AddHearts(-1)
                p:AddHearts(1)
            end
            p:AnimateCollectible(Id)
            sfx:Play(SoundEffect.SOUND_HOLY,1,0)
            data[Tag] = nil
        end
    end)
end

local function MC_POST_PLAYER_UPDATE(_, p)
    helper.RevivePlayerPostPlayerUpdate(p, Tag, ReviveTag, function()
        local data = p:GetData()
        data[ReviveTag] = nil
    end)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
		{
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
        {
            ModCallbacks.MC_POST_PLAYER_UPDATE,
            MC_POST_PLAYER_UPDATE
        }
    }
}
