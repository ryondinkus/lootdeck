local helper = lootdeckHelpers

local MenuName = "Lootdeck"
local SubMenuName = "Settings"

local function InitializeMCM(defaultMcmOptions)
	if not lootdeck.mcmOptions then
		lootdeck.mcmOptions = table.deepCopy(defaultMcmOptions)
	else
		for key, value in pairs(defaultMcmOptions) do
			if not lootdeck.mcmOptions[key] then
				lootdeck.mcmOptions[key] = value
			end
		end
	end
	local mcmOptions = lootdeck.mcmOptions
	if ModConfigMenu then
		ModConfigMenu.RemoveSetting(MenuName, SubMenuName, "LootCardChance")
		ModConfigMenu.RemoveSetting(MenuName, SubMenuName, "HoloCardChance")
		ModConfigMenu.RemoveSetting(MenuName, SubMenuName, "ClearData")
		ModConfigMenu.AddSetting(
			MenuName,
			SubMenuName,
			{
				Attribute = "LootCardChance",
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function()
					return mcmOptions.LootCardChance
				end,
				Minimum = 0,
				Maximum = 100,
				ModifyBy = 5,
				Display = function()
					if mcmOptions.LootCardChance == 0 then
						return "Loot Card Chance: 1%"
					end
					return "Loot Card Chance: " .. mcmOptions.LootCardChance .. "%"
				end,
				OnChange = function(currentNum)
					mcmOptions.LootCardChance = currentNum
					helper.SaveKey("mcmOptions.LootCardChance", currentNum)
				end,
				Info = {"Chance for Loot Cards to replace normal card drops (Default: 20%)"}
			}
		)
	
		ModConfigMenu.AddSetting(
			MenuName,
			SubMenuName,
			{
				Attribute = "HoloCardChance",
				Type = ModConfigMenu.OptionType.NUMBER,
				CurrentSetting = function()
					return mcmOptions.HoloCardChance
				end,
				Minimum = 0,
				Maximum = 100,
				ModifyBy = 5,
				Display = function()
					local output = "Holo Card Chance: "

					if lootdeck.unlocks.gimmeTheLoot then
						output = output .. mcmOptions.HoloCardChance .. "%"
					else
						output = output .. "Locked"
					end

					return output
				end,
				OnChange = function(currentNum)
					if lootdeck.unlocks.gimmeTheLoot then
						mcmOptions.HoloCardChance = currentNum
						helper.SaveKey("mcmOptions.HoloCardChance", currentNum)
					end
				end,
				Info = {"Chance for Holographic Loot Cards to replace normal Loot Card drops (Default: 10%)",
						"Unlocked with Gimme The Loot challenge completion"}
			}
		)
	
		ModConfigMenu.AddSetting(
			MenuName,
			SubMenuName,
			{
				Attribute = "ClearData",
				Type = ModConfigMenu.OptionType.BOOLEAN,
				CurrentSetting = function() return true end,
				Display = function() return "[ Clear Loot Deck save data ]" end,
				OnChange = function()
					helper.SaveData({
						players = {},
						familiars = {},
						global = {},
						mcmOptions = table.deepCopy(defaultMcmOptions),
						unlocks = {}
					})
					lootdeck.mcmOptions = table.deepCopy(defaultMcmOptions)
					lootdeck.f = {}
					lootdeck.unlocks = {}
					InitializeMCM(defaultMcmOptions)
				end,
				Info = "Clear all achievement unlocks, Mod Config Menu settings, and run progress. THIS WILL BREAK YOUR CURRENT RUN."
			}
		)
	end
end

return InitializeMCM