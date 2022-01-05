local helper = LootDeckHelpers

-- Explodes a random enemy or (if there are no enemies in the room) explodes the player
local Names = {
    en_us = "Bomb!",
    spa = "Bomba"
}
local Name = Names.en_us
local Tag = "bomb"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 2
local Descriptions = {
    en_us = "Explodes on a random enemy, dealing 40 damage#{{Warning}} If no enemies are in the room, this will explode on the player",
    spa = "Un enemigo aleatorio explotará, provocando 40 de daño#{{Warning}} Si no hay enemigos en la sala, el jugador explotará"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, spawns an explosion on a random enemy in the room, dealing 40 damage to it and all enemies around it.", "If used with no targetable enemies in the room, the explosion will spawn on the player instead.", "Holographic Effect: Explodes on two enemies at once, if able.")

local function MC_USE_CARD(_, c, p, f, shouldDouble, isDouble, rng)
	local target = helper.GetRandomEnemy(rng, Tag)
    if not target then
        if not isDouble then
            target = p
        else
            helper.ClearChosenEnemies(Tag)
            return
        end
    end
    Isaac.Explode(target.Position, nil, 40)

    if not shouldDouble then
        helper.ClearChosenEnemies(Tag)
    end

    if target == p then
        return false
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
	Descriptions = Descriptions,
	WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id,
            true
        }
    }
}
