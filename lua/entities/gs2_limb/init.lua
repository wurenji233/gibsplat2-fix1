AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local invis = Color(0,0,0,0)

local function CheckShouldRemove(self, _, _, new)
	if (bit.band(new, bit.lshift(1, self:GetTargetBone())) != 0) then
		self:Remove()
	end
end

function ENT:Initialize()
	local body = self:GetBody()
	self:SetModel(body:GetModel())
	self:SetSkin(body:GetSkin())
	self:SetPos(body:GetPos())
	self:SetParent(body)
	self:AddEffects(EF_BONEMERGE)
	
	-- Copy facial expression data from source model

	self:SetFlexScale(body:GetFlexScale())
	for i = 0, body:GetFlexNum() - 1 do
		self:SetFlexWeight(i, body:GetFlexWeight(i))
	end



	self:SetLightingOriginEntity(body.GS2LimbRelays[self:GetTargetBone()])

	self:SetTransmitWithParent(true)
	self:DrawShadow(false)
	body:DrawShadow(false)
	body:SetColor(invis)

	for _, data in pairs(body:GetBodyGroups()) do
		local bg = body:GetBodygroup(data.id)
		self:SetBodygroup(data.id, bg)
	end	

	self:NetworkVarNotify("GibMask", CheckShouldRemove)
	

	-- Add Think function to update facial expressions


	self.Think = function()
		if IsValid(body) then
			-- Update FlexScale
			local flexScale = body:GetFlexScale()
			if flexScale != self.LastFlexScale then
				self:SetFlexScale(flexScale)
				self.LastFlexScale = flexScale
			end
			
			-- Update flex weights
			for i = 0, body:GetFlexNum() - 1 do
				local weight = body:GetFlexWeight(i)
				if weight != self.LastFlexWeights[i] then
					self:SetFlexWeight(i, weight)
					self.LastFlexWeights[i] = weight
				end
			end
		end
		
		self:NextThink(CurTime())
		return true
	end
	
	-- Initialize last facial expression data for change detection
	self.LastFlexScale = body:GetFlexScale()
	self.LastFlexWeights = {}
	for i = 0, body:GetFlexNum() - 1 do
		self.LastFlexWeights[i] = body:GetFlexWeight(i)
	end
end