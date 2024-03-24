---@class AddonNamespace
local addon = select(2, ...)

local L = LibStub("AceLocale-3.0"):GetLocale("TankMD")

addon.defaultProfile = {
	profile = {
		tankSelectionStrategy = "ignoreMainTanks",
	},
}

---@type AceConfig.OptionsTable
addon.optionsTable = {
	name = L.title,
	type = "group",
	childGroups = "tab",
	order = 1,
	get = function(info)
		return addon.db.profile[info[#info]]
	end,
	set = function(info, value)
		addon.db.profile[info[#info]] = value
	end,
	args = {
		general = {
			type = "group",
			name = L.general,
			order = 1,
			args = {
				tankSelectionStrategy = {
					type = "select",
					name = L.tank_selection,
					order = 1,
					width = "full",
					values = {
						ignoreMainTanks = L.ignore_main_tank_assignment,
						includeMainTanks = L.include_main_tanks,
						prioritizeMainTanks = L.prioritize_main_tanks,
						mainTanksOnly = L.main_tanks_only,
					},
					sorting = { "ignoreMainTanks", "includeMainTanks", "prioritizeMainTanks", "mainTanksOnly" },
					disabled = function()
						local _, class = UnitClass("player")
						return class ~= "HUNTER" and class ~= "ROGUE"
					end,
				},
			},
		},
	},
}
