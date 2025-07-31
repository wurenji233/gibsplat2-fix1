include("shared.lua")

function ENT:Initialize()
	-- initialize flex data in client
	self.LastFlexScale = 1
	self.LastFlexWeights = {}
end

function ENT:Think()
	local body = self:GetBody()
	if !IsValid(body) then return end
	
	-- ungrade FlexScale
	local flexScale = self:GetFlexScale()
	if flexScale != self.LastFlexScale then
		body:SetFlexScale(flexScale)
		self.LastFlexScale = flexScale
	end
	
	-- update Flex weights
	local weightsData = self:GetFlexWeights()
	if weightsData != "" then
		local weights = util.JSONToTable(weightsData) or {}
		for flexID, weight in pairs(weights) do
			if weight != self.LastFlexWeights[flexID] then
				body:SetFlexWeight(flexID, weight)
				self.LastFlexWeights[flexID] = weight
			end
		end
	end
	
	-- ensure animation system is working
	self:NextThink(CurTime())
	return true
end