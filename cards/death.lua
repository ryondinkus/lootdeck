local helper = LootDeckHelpers

-- Kills the player and revives them in the previous room with 3 bone hearts
local Names = {
    en_us = "XIII. Death",
    spa = "XIII. Muerte"
}
local Name = Names.en_us
local Tag = "death"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "{{Warning}} Kills you on use#{{EmptyBoneHeart}} Revives you with 3 Empty Bones Hearts",
    spa = "{{Warning}} Mueres al utilizarla#{{EmptyBoneHeart}} Revives con 3 Corazones de Hueso vacíos"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Kills you on use.", "You revive with 3 Empty Bones Hearts.", "Holographic Effect: You revive with 4 Empty Bones Hearts.")

local ReviveTag = string.format("%sRevive", Tag)

local function MC_USE_CARD(_, c, p, f, shouldDouble)
    local data = p:GetData().lootdeck
    if not data[Tag] then
        data[Tag] = 3
        if shouldDouble then
            data[Tag] = data[Tag] + 1
        end
    end
	data[ReviveTag] = true
    Game():ShakeScreen(15)
    lootdeck.sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 0)
    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
    poof.Color = Color(0,0,0,1,0,0,0)
    p:Die()
    return false
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data[Tag] then
            p:AddMaxHearts(-24)
            p:AddSoulHearts(-24)
            p:AddBoneHearts(-12)
            p:AddBoneHearts(data[Tag])
            if p:GetOtherTwin() then
                p:GetOtherTwin():AddMaxHearts(-24)
                p:GetOtherTwin():AddSoulHearts(-24)
                p:GetOtherTwin():AddBoneHearts(-12)
                p:GetOtherTwin():AddBoneHearts(data[Tag])
            end
            if p:GetPlayerType() == PlayerType.PLAYER_KEEPER or p:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
                p:AddMaxHearts(2, false)
                p:AddHearts(2)
            end
            if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN or p:GetPlayerType() == PlayerType.PLAYER_THESOUL then
                while p:GetBoneHearts() > data[Tag] do
                    p:AddBoneHearts(-1)
                end
                p:AddSoulHearts(1)
            end
            lootdeck.sfx:Play(SoundEffect.SOUND_UNHOLY,1,0)
            data[Tag] = nil
            data[ReviveTag] = nil

            p:AnimateCard(Id, "UseItem")
            helper.PlayLootcardUseAnimation(data, Id)
        end
    end)
end

local function MC_POST_PLAYER_UPDATE(_, p)
    helper.RevivePlayerPostPlayerUpdate(p, Tag)
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
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
