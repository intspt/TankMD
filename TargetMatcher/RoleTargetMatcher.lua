local _, addon = ...
local RoleTargetMatcherPrototype = setmetatable({}, addon.TargetMatcherPrototype)
addon.RoleTargetMatcherPrototype = RoleTargetMatcherPrototype
RoleTargetMatcherPrototype.__index = RoleTargetMatcherPrototype

local LGIST = LibStub("LibGroupInSpecT-1.1")

function addon:CreateRoleTargetMatcher(role)
	local targetMatcher = setmetatable({}, RoleTargetMatcherPrototype)
	targetMatcher.role = role
	return targetMatcher
end

function RoleTargetMatcherPrototype:Matches(unit)
	local role = UnitGroupRolesAssigned(unit)
	if role ~= "NONE" then
		return self.role == role
	else
		local guid = UnitGUID(unit)
		local inspectInfo = LGIST:GetCachedInfo(guid)
		if inspectInfo then
			return self.role == inspectInfo.spec_role
		end
	end
end
