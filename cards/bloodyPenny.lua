
local helper = include("helper_functions")
local items = include("items/registry")

local Name = "Bloody Penny"
local Tag = "bloodyPenny"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: Base on loot deck weights, support stacking with multiple players and items, cap at 50% droprate
local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.bloodyPenny, SoundEffect.SOUND_VAMP_GULP)
end

local function MC_POST_ENTITY_KILL(_, e)
    local game = Game()
    local rng = lootdeck.rng
    local effectNum = 0
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        effectNum = effectNum + p:GetCollectibleNum(items.bloodyPenny)
    end
    local effect = rng:RandomInt(10)

    local threshold = 0
    if effectNum > 0 then threshold = 1 end
    threshold = threshold + (effectNum - 1)
    if threshold >= 5 then threshold = 4 end
    if effect <= threshold then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, (e.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
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
            ModCallbacks.MC_POST_ENTITY_KILL,
            MC_POST_ENTITY_KILL
        }
    }
}