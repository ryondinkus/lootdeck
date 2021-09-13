local helper = include("helper_functions")

-- Gives a chance of reviving in the previous room with half a heart
local Name = "Broken Ankh"
local Tag = "brokenAnkh"
local Id = Isaac.GetItemIdByName(Name)

local ReviveTag = string.format("%sRevive", Tag)

local function MC_POST_NEW_ROOM()
    local game = Game()
    local sfx = lootdeck.sfx
    for i=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()

		if p:HasCollectible(Id) then
			local effectNum = p:GetCollectibleNum(Id)
			local effect = lootdeck.rng:RandomInt(6)
			local threshold = 0
			threshold = threshold + (effectNum - 1)
			if threshold > 2 then threshold = 2 end
			data[ReviveTag] = false
			if effect <= threshold then
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
    end
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
