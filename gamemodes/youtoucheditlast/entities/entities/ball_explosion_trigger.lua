
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Explosion Trigger"
ENT.Author			= "Zet0r"
ENT.Information		= "Used in You Touched it Last to spawn Explosions"
ENT.Category		= "Fun + Games"

ENT.Editable		= false
ENT.Spawnable		= false
ENT.AdminOnly		= false
ENT.RenderGroup		= RENDERGROUP_BOTH

ENT.SoundID 		= 1
ENT.Delay			= 0
ENT.SoundPlayed		= false

local playerExplosion = {effect = "ball_explosion_player", sound = false, delay = false, shakedur = 0, shakeamp = 0, shakefreq = 0}

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "PlayerExplosion")
	self:NetworkVar( "Int", 0, "SoundID", { KeyName = "soundid", Edit = {  } } )
end

function ENT:Initialize()

	--print("SPAWNED")
	if SERVER then
		if self:GetPlayerExplosion() then
			ParticleEffect(playerExplosion.effect, self:GetPos(), Angle(0,0,0), nil)
		else
			ParticleEffect(ytil_BallList[self:GetSoundID()].effect, self:GetPos(), Angle(0,0,0), nil)
		end
	end
	
	self:SetNoDraw(true)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	
	if CLIENT then
		local dist = self:GetPos():Distance(LocalPlayer():GetPos())
		--print(dist)
		if !self:GetPlayerExplosion() then
			self.Delay = ytil_BallList[self:GetSoundID()].delay and CurTime() + (dist/7500) + ytil_BallList[self:GetSoundID()].delay or 0
		end
	end
	
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

if ( CLIENT ) then

	function ENT:Draw()
		return
	end

end

function ENT:Think()
	if CLIENT and !self.SoundPlayed and !self:GetPlayerExplosion() and ytil_BallList[self:GetSoundID()].delay then -- A false delay makes no sound and shake but still particles
		if CurTime() >= self.Delay then
			local ID = self:GetSoundID()
			surface.PlaySound(ytil_BallList[ID].explosionsound)
			util.ScreenShake(LocalPlayer():GetPos(), ytil_BallList[ID].shakeamp, ytil_BallList[ID].shakefreq, ytil_BallList[ID].shakedur, 5000)
			self.SoundPlayed = true
			--print("boom")
		else
			--print(self.Delay - CurTime())
		end
	end
end