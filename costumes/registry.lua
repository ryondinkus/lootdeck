local function CostumePathToId(path)
    return Isaac.GetCostumeIdByPath(string.format("gfx/characters/%s.anm2", path))
end

return {
    empress = CostumePathToId("empress"),
    sun = CostumePathToId("sun"),
	magician = CostumePathToId("magician"),
	hangedMan = CostumePathToId("hangedMan"),
	mantle = CostumePathToId("mantle"),
	mantleBroken = CostumePathToId("mantleBroken"),
    chariot = CostumePathToId("chariot"),
    strengthFire = CostumePathToId("strength fire"),
	strengthGlow = CostumePathToId("strength glow")
}
