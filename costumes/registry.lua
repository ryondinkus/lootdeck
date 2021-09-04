local function CostumePathToId(path)
    return Isaac.GetCostumeIdByPath(string.format("gfx/%s.anm2", path))
end

return {
    empress = CostumePathToId("empress"),
    sun = CostumePathToId("sun")
}