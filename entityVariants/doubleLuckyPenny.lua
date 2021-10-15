local Name = "Double Lucky Penny"
local Tag = "doubleLuckyPenny"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
    local p = e:ToPlayer() or 0
    local playerData = p:GetData()
    local data = pi:GetData()
    local sprite = pi:GetSprite()
    if p ~= 0 then
         if data.canTake then
            p:AddCoins(2)
            local hud = Game():GetHUD()
            hud:ShowItemText("Lucky Penny", "Luck Up")
            p:PlayExtraAnimation("Happy")
            lootdeck.sfx:Play(SoundEffect.SOUND_LUCKYPICKUP)
            lootdeck.sfx:Play(SoundEffect.SOUND_THUMBSUP)
            if playerData[Tag] then playerData[Tag] = playerData[Tag] + 1
            else playerData[Tag] = 1 end
            p:AddCacheFlags(CacheFlag.CACHE_LUCK)
            p:EvaluateItems()
            pi.Velocity = Vector.Zero
            pi.Touched = true
            pi.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            sprite:Play("Collect", true)
            pi:Die()
        end
    end
end

local function MC_POST_PICKUP_UPDATE(_, pi)
    local data = pi:GetData()
    local sprite = pi:GetSprite()
    if sprite:IsEventTriggered("DropSound") then
        lootdeck.sfx:Play(SoundEffect.SOUND_PENNYDROP)
    end
    if not sprite:IsPlaying("Collect") and not sprite:IsFinished("Collect") and sprite:IsEventTriggered("DropSound") and not data.canTake then
        data.canTake = true
    end
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = p:GetData()
    print(data[Tag])
    if data[Tag] then
        print("hehe")
        p.Luck = p.Luck + (2 * data[Tag])
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_PRE_PICKUP_COLLISION,
            MC_PRE_PICKUP_COLLISION,
            Id
        },
        {
            ModCallbacks.MC_POST_PICKUP_UPDATE,
            MC_POST_PICKUP_UPDATE,
            Id
        },
        {
            ModCallbacks.MC_EVALUATE_CACHE,
            MC_EVALUATE_CACHE,
            CacheFlag.CACHE_LUCK
        }
    }
}
