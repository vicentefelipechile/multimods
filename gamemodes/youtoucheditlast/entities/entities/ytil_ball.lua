
AddCSLuaFile()

local BounceSound = Sound( "garrysmod/balloon_pop_cute.wav" )

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "You Touched it Last Bouncy Ball"
ENT.Author			= "Zet0r"
ENT.Information		= "An edible bouncy ball that will haunt you if you touch it"
ENT.Category		= "Fun + Games"

ENT.Editable		= true
ENT.Spawnable		= true
ENT.AdminOnly		= false
ENT.RenderGroup		= RENDERGROUP_BOTH

ENT.TextureId 		= 1

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "BallSize", { KeyName = "ballsize", Edit = { type = "Float", min = 4, max = 128, order = 1 } } )
	self:NetworkVar( "Vector", 0, "BallColor", { KeyName = "ballcolor", Edit = { type = "VectorColor", order = 2 } } )
	self:NetworkVar( "Int", 0, "TextureId", { KeyName = "textureid", Edit = {  } } )
	self:NetworkVar( "Bool", 0, "Angelic" )

end

-- This is the spawn function. It's called when a client calls the entity to be spawned.
-- If you want to make your SENT spawnable you need one of these functions to properly create the entity
--
-- ply is the name of the player that is spawning it
-- tr is the trace from the player's eyes 
--
function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end
	
	local size = math.random( 16, 48 )
	local SpawnPos = tr.HitPos + tr.HitNormal * size
	
	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:SetBallSize( size )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	self.owner = nil

	if ( SERVER ) then

		local size = self:GetBallSize() / 2
	
		-- Use the helibomb model just for the shadow (because it's about the same size)
		self:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
		
		-- Don't use the model's physics - create a sphere instead
		self:PhysicsInitSphere( size, "metal_bouncy" )
		
		-- Wake the physics object up. It's time to have fun!
		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:Wake()
		end
		
		-- Set collision bounds exactly
		self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )
		
		self:NetworkVarNotify( "BallSize", self.OnBallSizeChanged )
		
	else 
	
		self.LightColor = Vector( 0, 0, 0 )
	
	end
	
end

function ENT:OnBallSizeChanged( varname, oldvalue, newvalue )

	local delta = oldvalue - newvalue

	local size = self:GetBallSize() / 2.1
	self:PhysicsInitSphere( size, "metal_bouncy" )
	
	size = self:GetBallSize() / 2.6
	self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )

	self:PhysWake()

end

if ( CLIENT ) then

	function ENT:Draw()
		local pos = self:GetPos()
		local vel = self:GetVelocity()

		render.SetMaterial( ytil_BallList[self:GetTextureId()].texture )
		if ytil_Variables.gametype == 7 then
			if self:GetAngelic() then
				render.DrawSprite( pos, self:GetBallSize(), self:GetBallSize(), Color( 255, 255, 255, 255 ) )
			else
				render.DrawSprite( pos, self:GetBallSize(), self:GetBallSize(), Color( 50, 50, 50, 255) )
			end
		else
			local c = self:GetBallColor()
			render.DrawSprite( pos, self:GetBallSize(), self:GetBallSize(), Color( c.x * 255, c.y * 255, c.z * 255, 255 ) )
		end
		
	end

end


--[[---------------------------------------------------------
   Name: PhysicsCollide
-----------------------------------------------------------]]
function ENT:PhysicsCollide( data, physobj )
	
	-- Play sound on bounce
	if ( data.Speed > 60 && data.DeltaTime > 0.2 ) then

		local pitch = 32 + 128 - self:GetBallSize()
		self:EmitSound( ytil_BallList[self:GetTextureId()].sound, 75, math.random( pitch - 10, pitch + 10 ) )

	end
	
	-- Bounce like a crazy bitch
	local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	
	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	
	local TargetVelocity = NewVelocity * LastSpeed * 0.7
	
	physobj:SetVelocity( TargetVelocity )
	
end

--[[---------------------------------------------------------
   Name: OnTakeDamage
-----------------------------------------------------------]]
function ENT:OnTakeDamage( dmginfo )

	-- React physically when shot/getting blown
	self:TakePhysicsDamage( dmginfo )
	
end


--[[---------------------------------------------------------
   Name: Use
-----------------------------------------------------------]]
function ENT:Use( activator, caller )
	
	if ytil_GametypeRules[ytil_Variables.gametype].CanPickupBall(self, activator) then
		self.owner:SetHasBall(true)
		self.owner:GetViewModel():SetNoDraw(false)
		self.owner:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW)
		self.owner.ball = nil
		self.owner:SetBallIndex(0)
		self:Remove()
	end

end

--[[---------------------------------------------------------
   Name: StartTouch
-----------------------------------------------------------]]
function ENT:StartTouch( ent )
	
	if IsValid(ent) and ent:IsPlayer() and ent:Alive() and ent:Team() != 3 then
		ytil_GametypeRules[ytil_Variables.gametype].OnPlayerHit(self, self.owner, ent)
	end

end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:SetNewOwner(new, stayowner, stayrunner)

	if !stayowner then self.owner:SetRunner() end
	if !stayrunner then new:SetBallOwner() end
	
	if IsValid(new.ball) then return end -- Do not change ownership if they already have a ball, only teams
	
	self.owner.ball = nil
	self.owner:SetBallIndex(0)	-- 0 for it to not be a ball
	-- Changes owner here --			Normal ball ownership change
	self.owner = new
	new.ball = self
	self:SetBallColor(new:GetYTILColor())
	new:SetBallIndex(self:EntIndex())

end

function ENT:OnRemove()
	if SERVER and IsValid(self.owner) then self.owner:SetBallIndex(0) end
end