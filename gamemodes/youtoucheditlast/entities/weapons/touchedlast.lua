if SERVER then
	AddCSLuaFile("touchedlast.lua")
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo	= true
	SWEP.AutoSwitchFrom	= false	
end

print("Touched Last [weapon] loads")

if CLIENT then

	SWEP.PrintName     	    = "Hands"			
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true

end

local charger = 2

SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Throws the ball if you own it"
SWEP.Instructions	= "Let the gamemode give you it"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.HoldType = "normal"

SWEP.ViewModel	= "models/weapons/c_grenade.mdl"
SWEP.WorldModel	= "models/weapons/w_grenade.mdl"
SWEP.UseHands = true
SWEP.vModel = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.NextReload				= 1

if SERVER then 
	util.AddNetworkString("HasBall")
	util.AddNetworkString("ThrowBall")
	util.AddNetworkString("ActiveBall")
end

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "HasBall", { KeyName = "hasball"} )
	self:NetworkVar( "Int", 0, "BallID" )
	self:NetworkVar( "Vector", 0, "YTILColor" )

end

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )
	self:NetworkVarNotify( "HasBall", self.OnHasBallChanged )
	
	if SERVER and GetConVarNumber("ytil_afktime") != 0 then
		timer.Create("AFKTime", GetConVarNumber("ytil_afktime"), 1, function()
			if self.Owner:Alive() then
				self.Owner:SpawnAsSpectator()
				if IsValid(self.Owner.ball) then self.Owner.ball:Remove() end
				self.Owner:SetHasBall(false)
				if IsValid(self.Owner:GetViewModel()) then self.Owner:GetViewModel():SetNoDraw(true) end
				if IsValid(self.Owner:GetActiveWeapon()) then self.Owner:GetActiveWeapon():SendWeaponAnim(ACT_VM_THROW) end
				self.Owner.SpectateAlways = true
				self.Owner:ChatPrint("You were moved to Spectators for being AFK.")
				hook.Remove("KeyPress", "AFKManager")
			end
		end)
		hook.Add("KeyPress", "AFKManager", function(ply, key)
			if key == IN_ATTACK or key == IN_FORWARD or key == IN_LEFT or key == IN_RIGHT or key == IN_DUCK or key == IN_ATTACK2
			or key == IN_RELOAD or key == IN_BACK then
				timer.Remove("AFKTime")
				hook.Remove("KeyPress", "AFKManager")
			end
		end)
	end

end

function SWEP:Deploy()

	if self.Owner.datatablesup and self.Owner:GetHasBall() then
		if IsValid(self.Owner:GetViewModel()) then self.Owner:GetViewModel():SetNoDraw(false) end
		self:SendWeaponAnim(ACT_VM_DRAW)
	else
		if IsValid(self.Owner:GetViewModel()) then self.Owner:GetViewModel():SetNoDraw(true) end
		self:SendWeaponAnim(ACT_VM_THROW)
	end
	
	self:CheckUnlockedBalls()
	
	if self.Owner.ActiveBall == nil or self.Owner.ActiveBall > #ytil_BallList then
		self:SetBallID(1)
	else
		self:SetBallID(self.Owner.ActiveBall)
	end
	
end

function SWEP:CheckUnlockedBalls()

	self.UnlockedBalls = {}
	
	for k,v in pairs(ytil_BallList) do
		if v.condition(self.Owner) then
			print(v.name.." is unlocked for "..self.Owner:Nick())
			table.insert(self.UnlockedBalls, k)
		end
	end
	
	if self.Owner.ActiveBallKey == nil then self.Owner.ActiveBallKey = 1 end
	self.Owner.ActiveBall = self.UnlockedBalls[self.Owner.ActiveBallKey]

end

function SWEP:OnHasBallChanged(key, oldval, newval)
	if key != "HasBall" then return end
	if tobool(newval) then 
		self:SendWeaponAnim(ACT_VM_DRAW) 
		if IsValid(self.Owner:GetViewModel()) then self.Owner:GetViewModel():SetNoDraw(false) end
	end
	self.Owner.HasBall = newval
end

function SWEP:PrimaryAttack()

	local traceBreak = util.TraceLine( {
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 100,
		filter = self.Owner
	} )
	if traceBreak.Hit == true and IsValid(traceBreak.Entity) and (traceBreak.Entity:GetClass() == "func_breakable" or traceBreak.Entity:GetClass() == "func_breakable_surf") then
		if SERVER then traceBreak.Entity:Fire("Break") end
		self.Owner:ViewPunch( Angle(-10, 0, 0) )
		return 
	end

	--[[if not self.Owner:GetHasBall() then
		local targetball = self.Owner.ball
		if IsValid(targetball) then
			if IsValid(targetball.owner) then 
				targetball.owner.ball = nil
			end
			targetball:Remove()
			self.Owner:SetHasBall(true)
			self:SendWeaponAnim(ACT_VM_DRAW)
			self.Owner:GetViewModel():SetNoDraw(false)
		end
	end]]
	if self.Owner:GetHasBall() then
		--if SERVER then self:ThrowBall(100) end
		self:SetHoldType( "grenade" )
		
		if CLIENT then 
			hook.Add("Tick", "ChargeUp"..self.Owner:EntIndex(), function() self:ChargeUp() end)
			hook.Add("HUDPaint", "debugDrawCharge", function()
				draw.SimpleText(LocalPlayer().charge, "DebugFixed", ScrW() / 2, ScrH() / 4 * 3, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end)
		end
	end
	
end

function SWEP:ChargeUp()
	
	LocalPlayer().charge = LocalPlayer().charge + charger
	if LocalPlayer().charge >= 100 then
		charger = -2
	elseif LocalPlayer().charge <= 0 then
		charger = 2
	end
	
	if input.IsMouseDown(MOUSE_RIGHT) then
		hook.Remove("Tick", "ChargeUp"..self.Owner:EntIndex())
		hook.Remove("HUDPaint", "debugDrawCharge")
		LocalPlayer().charge = 0
		charger = 2
		return false
	end
	
	if !input.IsMouseDown(MOUSE_LEFT) then
		hook.Remove("Tick", "ChargeUp"..self.Owner:EntIndex())
		hook.Remove("HUDPaint", "debugDrawCharge")
		net.Start("ThrowBall")
			net.WriteInt(LocalPlayer().charge, 8)
		net.SendToServer()
		LocalPlayer().charge = 0
		charger = 2
		self.Owner.HasBall = false
		return true
	end

end

function SWEP:ThrowBall(force)

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_THROW)

	timer.Create("rHoldT"..self:EntIndex(), 0.7, 1, function() 
		if IsValid(self) then self:SetHoldType( self.HoldType ) end
	end)
	timer.Simple(0.3, function()
		if IsValid(self) and !self.Owner:GetHasBall() then self.Owner:GetViewModel():SetNoDraw(true) end
	end)
	
	self.Owner.ball = ents.Create("ytil_ball")
		if ytil_Variables.gametype == 7 then
			if self.Owner:Team() == 1 then
				self.Owner.ball:SetAngelic(true)
				self.Owner.ball:SetBallColor(self.Owner:GetYTILColor())
			else
				self.Owner.ball:SetBallColor(Vector(0.5, 0.5, 0.5))
			end
		else
			self.Owner.ball:SetBallColor(self.Owner:GetYTILColor())
		end
		
		self.Owner.ball:SetBallSize(GetConVar("ytil_ballsize"):GetInt())
		self.Owner.ball:SetTextureId(self.Owner.ActiveBall)
		self.Owner.ball:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 40))
		self.Owner.ball:Spawn()
		self.Owner.ball:Activate()
		self.Owner.ball.owner = self.Owner
		
		local ballPhys = self.Owner.ball:GetPhysicsObject()
			if !(ballPhys && IsValid( ballPhys )) then self.Owner.ball:Remove() return end
		ballPhys:ApplyForceCenter(self.Owner:GetAimVector():GetNormalized() *  ytil_Variables.throwPower * force)

		self.Owner:SetHasBall(false)
		self.Owner:SetBallIndex(self.Owner.ball:EntIndex())

end

net.Receive("ThrowBall", function(len, ply)
	if ply:Alive() and ply:GetHasBall() and IsValid(ply:GetActiveWeapon()) then
		ply:GetActiveWeapon():ThrowBall(net.ReadInt(8))
	end
end)

function SWEP:SecondaryAttack()
	
	self:SetHoldType( self.HoldType )
	
	if self.Owner:GetHasBall() then return end
	
	self.Owner.beginTele = CurTime()
	self:SetHoldType( "magic" )
	if timer.Exists("rHoldT"..self:EntIndex()) then timer.Remove("rHoldT"..self:EntIndex()) end
	
	self.Owner:SetTeleporting(true)	
	
	if CLIENT then
		ytil_ballTeleCharge = 0.0000001
	end
	
	hook.Add("Think", "TeleportBall"..self:EntIndex(), function()
		if !IsValid(self) then
			hook.Remove("Tick", "TeleportBall"..self:EntIndex()) 
			if CLIENT then
				ytil_ballTeleCharge = 0
			end
			return end
		if !self.Owner:KeyDown(IN_ATTACK2) then
			hook.Remove("Think", "TeleportBall"..self:EntIndex())
			if CLIENT then
				ytil_ballTeleCharge = 0
			end
			self:SetHoldType( self.HoldType )	
			self.Owner:SetTeleporting(false)
		end
		
		if IsValid(ytil_GametypeRules[ytil_Variables.gametype].GetTeleportableBall(self.Owner)) then
			local targetball = ytil_GametypeRules[ytil_Variables.gametype].GetTeleportableBall(self.Owner)
			if CLIENT and ytil_ballTeleCharge != 0 then
				ytil_ballTeleCharge = (CurTime() - self.Owner.beginTele)/GetConVar("ytil_ballteletime"):GetInt()
			end
			if CurTime() - self.Owner.beginTele >= GetConVar("ytil_ballteletime"):GetInt() then
				hook.Remove("Think", "TeleportBall"..self:EntIndex())
				if CLIENT then
					ytil_ballTeleCharge = 0
				end
				self:SetHoldType( self.HoldType )
				
				if SERVER then
					self.Owner:SetTeleporting(false)
					if IsValid(targetball) then
						if IsValid(targetball.owner) then 
							targetball.owner.ball = nil
						end
						targetball:Remove()
						self.Owner:SetHasBall(true)
						self:SendWeaponAnim(ACT_VM_DRAW)
						self.Owner:GetViewModel():SetNoDraw(false)
					else
						self.Owner:ChatPrint("Your targeted ball is not valid.")
					end
				end
			end
		end
	end)
	
end

function SWEP:DrawHUD()

	

end


function SWEP:Reload()
	
	if CurTime() < self.NextReload then return end
	self.NextReload = CurTime() + 0.25

	if self.Owner:GetHasBall() and SERVER then
		if #self.UnlockedBalls == 1 then return end
		local newBallKey = self.Owner.ActiveBallKey + 1
		local newBall = self.UnlockedBalls[newBallKey]
		if newBall == nil then 
			newBall = self.UnlockedBalls[1]
			newBallKey = 1
		end
		
		self.Owner.ActiveBallKey = newBallKey
		self.Owner.ActiveBall = newBall
		
		self.Owner:SetBallID(newBall)
		
	return end

end


function SWEP:DrawWorldModel()
end

function SWEP:OnRemove()
	if CLIENT then
		hook.Remove("Tick", "ChargeUp"..self.Owner:EntIndex())
		LocalPlayer().charge = 0
		charger = 2
	end
end

function SWEP:PreDrawViewModel(vm, ply, wep)
end