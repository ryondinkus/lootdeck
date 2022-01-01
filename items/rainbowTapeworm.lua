local helper = LootDeckHelpers

-- 50% chance each room to grant a temporary copy of a random passive you already have
local Names = {
    en_us = "Rainbow Tapeworm",
    spa = "Gusano Arcoíris"
}
local Name = Names.en_us
local Tag = "rainbowTapeworm"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "On room entry, 50% chance to temporarily duplicate one of your existing passives",
    spa = "Al entrar a una habitación, hay un 50% de duplicar uno de tus objetos pasivos temporalmente"
}
local WikiDescription = helper.GenerateEncyclopediaPage("When entering a room, 50% chance to duplicate one of your passives for the rest of the room.")

local function MC_POST_NEW_ROOM()
    if lootdeck.f.isGameStarted then
        helper.ForEachPlayer(function(p, data)

            if data[Tag] then
                for _, id in pairs(data[Tag]) do
                    p:RemoveCollectible(id)
                end
                data[Tag] = nil
            end

            for i=1,p:GetCollectibleNum(Id) do
                if helper.PercentageChance(50) then
                    local itemId = helper.GetRandomItemIdInInventory(p, Id, true)
                    if itemId then
                        p:AddCollectible(itemId, 0, false)
                        p:AnimateCollectible(itemId, "UseItem")
                        lootdeck.sfx:Play(SoundEffect.SOUND_1UP, 1, 0)
                        if data[Tag] then
                            table.insert(data[Tag], itemId)
                        else
                            data[Tag] = { itemId }
                        end
                    end
                end
            end
        end, Id)
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}
