ENT.Type = "anim"
ENT.Base = "base_anim"
 
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Body")
	self:NetworkVar("Float", 0, "Duration")
	self:NetworkVar("Int", 0, "Mode")
	self:NetworkVar("Float", 1, "FlexScale")
	self:NetworkVar("String", 0, "FlexWeights")
end