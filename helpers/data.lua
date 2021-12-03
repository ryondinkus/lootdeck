local json = include("json")

local H = {}

function lootdeckHelpers.SaveData(data)
    lootdeck:SaveData(json.encode(data))
end

function lootdeckHelpers.LoadData()
    if lootdeck:HasData() then
        return json.decode(lootdeck:LoadData())
    end
end

function lootdeckHelpers.SaveKey(key, value)
    local savedData = {}
    if lootdeck:HasData() then
        savedData = json.decode(lootdeck:LoadData())
    end
    lootdeckHelpers.SetNestedValue(savedData, key, value)
    lootdeck:SaveData(json.encode(savedData))
end

function lootdeckHelpers.LoadKey(key)
    if lootdeck:HasData() then
        return json.decode(lootdeck:LoadData())[key]
    end
end

function lootdeckHelpers.SaveDataFromEntities(data)
    if data ~= nil then
        if type(data) == "userdata" then
            if data.InitSeed then
                return { savedType = "userdata", initSeed = tostring(data.InitSeed) }
            end
        elseif type(data) == "table" then
            local output = {}
            for key, item in pairs(data) do
                output[key] = lootdeckHelpers.SaveDataFromEntities(item)
            end
            return output
        else
            return data
        end
    end
end

function lootdeckHelpers.LoadEntitiesFromSaveData(data)
    if data ~= nil and type(data) == "table" then
        if lootdeckHelpers.IsArray(data) or data.savedType ~= "userdata" then
            local output = {}
            for key, item in pairs(data) do
                output[key] = lootdeckHelpers.LoadEntitiesFromSaveData(item)
            end
            return output
        else
            return lootdeckHelpers.GetEntityByInitSeed(data.initSeed)
        end
    else
        return data
    end
end

function lootdeckHelpers.SaveGame()
    local data = {
        seed = Game():GetSeeds():GetPlayerInitSeed(),
        players = {},
        familiars = {},
        global = lootdeck.f,
        mcmOptions = lootdeck.mcmOptions or {},
        unlocks = lootdeck.unlocks or {}
    }

    lootdeckHelpers.ForEachPlayer(function(p)
        data.players[tostring(p.InitSeed)] = p:GetData().lootdeck
    end)

    lootdeckHelpers.ForEachEntityInRoom(function(familiar)
        data.familiars[tostring(familiar.InitSeed)] = familiar:GetData()
    end, EntityType.ENTITY_FAMILIAR)

    lootdeckHelpers.SaveData(lootdeckHelpers.SaveDataFromEntities(data))
end

return H