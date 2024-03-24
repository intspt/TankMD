---@class AddonNamespace
local addon = select(2, ...)

local ClassTargetSelectors = {}
addon.ClassTargetSelectors = ClassTargetSelectors

local TargetSelector = addon.TargetSelector
local TargetSelectionStrategy = addon.TargetSelectionStrategy

local tankSelectionFactories = {
	tankRoleOnly = function()
		return TargetSelector.PartyOrRaid(TargetSelectionStrategy.Role("TANK"))
	end,
	tanksAndMainTanks = function()
		return TargetSelector.PartyOrRaid(
			TargetSelectionStrategy.Any({
				TargetSelectionStrategy.MainTank(),
				TargetSelectionStrategy.Role("TANK"),
			})
		)
	end,
	prioritizeMainTanks = function()
		return TargetSelector.Chain({
			TargetSelector.PartyOrRaid(TargetSelectionStrategy.MainTank()),
			TargetSelector.PartyOrRaid(TargetSelectionStrategy.Role("TANK")),
		})
	end,
	mainTanksOnly = function()
		return TargetSelector.PartyOrRaid(TargetSelectionStrategy.MainTank())
	end,
}

function ClassTargetSelectors.HUNTER()
	return TargetSelector.Chain({
		tankSelectionFactories[addon.db.profile.tankSelectionStrategy]() or tankSelectionFactories.tankRoleOnly(),
		TargetSelector.Pet(),
	})
end

function ClassTargetSelectors.ROGUE()
	return tankSelectionFactories[addon.db.profile.tankSelectionStrategy]() or tankSelectionFactories.tankRoleOnly()
end

function ClassTargetSelectors.EVOKER()
	return TargetSelector.Chain({
		TargetSelector.PartyOrRaid(TargetSelectionStrategy.Role("TANK")),
		TargetSelector.Player(),
	})
end

function ClassTargetSelectors.DRUID()
	return TargetSelector.PartyOrRaid(TargetSelectionStrategy.Role("TANK"))
end
