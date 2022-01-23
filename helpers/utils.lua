local json = include("json")

function LootDeckAPI.ConvertBitSet64ToBitSet128(x)
    return x >= 64 and BitSet128(0,1<<(x - 64)) or BitSet128(1<<x,0)
end

function LootDeckAPI.TableContains(t, element)
    if t then
        for _, value in pairs(t) do
            if value == element then
                return true
            end
        end
    end
	return false
end

function LootDeckAPI.LengthOfTable(t)
    local num = 0
    for _ in pairs(t) do
        num = num + 1
    end
    return num
end

function LootDeckAPI.Sign(x)
  return x > 0 and 1 or x < 0 and -1 or 0
end

function LootDeckAPI.SetNestedValue(t, key, value)
    if t and type(t) == "table" then
        if key:find("%.") then
            local levelKey, nextLevelKey = key:match('([^.]+)%.(.*)')
            if t[levelKey] == nil and nextLevelKey then
                t[levelKey] = {}
            end
            return LootDeckAPI.SetNestedValue(t[levelKey], nextLevelKey, value)
        else
            t[key] = value
        end
    end
end

function LootDeckAPI.IsArray(t)
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then return false end
    end
    return true
end

function LootDeckAPI.RunRandomFunction(rng, shouldDouble, ...)
    local functions = {...}

    local effectIndex

    if not rng then
        rng = lootdeck.rng
    else
        if type(rng) == "number" then
            effectIndex = math.min(#functions, math.max(rng, 1))
        end
    end

    if not effectIndex then
        effectIndex = rng:RandomInt(#functions) + 1
    end

    if shouldDouble then
        functions[effectIndex]()
    end

    return functions[effectIndex]()
end

function LootDeckAPI.PercentageChance(percent, max, rng)
    local value
    if percent > (max or 100) then
        value = max or 100
    else
        value = percent
    end

    if not rng then
        rng = lootdeck.rng
    end

    return rng:RandomInt(99) + 1 <= value
end

function LootDeckAPI.DumpTable(t)
    print(json.encode(t))
end
