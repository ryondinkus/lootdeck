LootDeckHelpers = {}

local helperFiles = {
    include("helpers/data"),
    include("helpers/docs"),
    include("helpers/entities"),
    include("helpers/game"),
    include("helpers/hud"),
    include("helpers/lootcards"),
    include("helpers/pickups"),
    include("helpers/players"),
    include("helpers/utils")
}

for _, file in pairs(helperFiles) do
    for key, func in pairs(file) do
        LootDeckHelpers[key] = func
    end
end
