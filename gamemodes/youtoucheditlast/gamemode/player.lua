local ply = FindMetaTable("Player")

local ranColors = {
	-- Pure colors
	Vector(1, 0, 0), -- Red (1)
	Vector(0, 1, 0), -- Green (2)
	Vector(0, 0, 1), -- Blue (3)
	
	-- Two 1's, one 0
	Vector(1, 1, 0), -- Yellow (4)
	Vector(1, 0, 1), -- Purple (5)
	Vector(0, 1, 1), -- Ice (6)
	
	-- 0.5 Green
	Vector(1, 0.5, 0), -- Orange (7)
	Vector(0, 0.5, 1), -- Sky (8)
	Vector(1, 0.5, 1), -- Pink (9)
	
	-- 0.5 Red
	Vector(0.5, 0, 1), -- Dark Purple (10)
	Vector(0.5, 1, 0), -- Lime (11)
	--Vector(0.5, 1, 1), -- Bright Ice (DISABLED: Too close to Ice)
	
	-- 0.5 Blue
	Vector(1, 0, 0.5), -- Rose (12)
	Vector(0, 1, 0.5) -- Turquoise (13)
	--Vector(1, 1, 0.5), -- Lemon (DISABLED: Too close to Yellow)
}
local remainingColors = {1,2,3,4,5,6,7,8,9,10,11,12,13}


function ply:InitYTILColor( color )

	if self.YTILColor != nil and table.HasValue(ranColors, self.YTILColor) then
		print("Rerolling "..self:Nick().."'s color")
		self:RestockColor()
	end

	if table.Count(remainingColors) < 1 then
		local color = table.Random(ranColors)
		self:SetPlayerColor( color )
		self.YTILColor = color
		print("No more free colors, picked a random")
	else
		local color = table.Random(remainingColors)
		self:SetPlayerColor( ranColors[color] )
		table.RemoveByValue( remainingColors, color)
		self.YTILColor = ranColors[color]
		print(self:Nick().." has joined, set color to "..color)
		print(self.datatablesup)
	end
	
	print("color init here")
	if self.datatablesup then
		self:SetYTILColor( self.YTILColor )
	end
	
	if IsValid(self.ball) then self.ball:SetBallColor( self:GetYTILColor() ) end
	
	--[[timer.Simple(0.1, function()
		net.Start("YTILColor")
			net.WriteVector(self.YTILColor)
			net.WriteEntity(self)
		net.Broadcast()
	end)]]

end

function ply:RestockColor()
	if !table.HasValue(remainingColors, table.KeyFromValue(ranColors, self.YTILColor)) then
		table.insert(remainingColors, table.KeyFromValue(ranColors, self.YTILColor))
		--print("Restocked ", self.YTILColor)
	end
end

-- Function to set player as Ball Owner
function ply:SetBallOwner( )
	self:SetTeam( 2 )
	--self:SetHealth( 100 )
	self:SetRunSpeed(350)
	
	self:SetObserverMode(OBS_MODE_NONE)
	self:SetNoDraw(false)
	net.Start("ClientSpectate")
		net.WriteBool(false)
	net.Send(self)
	self.Spectating = false
	
	ytil_GametypeRules[ytil_Variables.gametype].OnBallOwner(self)

	-- Alert that the player touched it last
	print( self:GetName() .. " has been hit by the ball!")
end

-- Function to set player as Runner
function ply:SetRunner()
	self:SetTeam( 1 )
	--self:SetHealth( 100 )
	self:SetRunSpeed(300)
	self:SetPlayerColor(self.YTILColor)
	--self:SetBallIndex(0)
	
	self:SetObserverMode(OBS_MODE_NONE)
	self:SetNoDraw(false)
	net.Start("ClientSpectate")
		net.WriteBool(false)
	net.Send(self)
	self.Spectating = false
	
	ytil_GametypeRules[ytil_Variables.gametype].OnRunner(self)

	-- Alert that the player is runner
	print( self:GetName() .. " has been assigned as runner!")
end

-- Function to set player as Spectator
function ply:SpawnAsSpectator()
	self:SetTeam( 3 )
	self:SetHealth( 10000 )
	self:SetRunSpeed(400)
	self:StripWeapons()
	
	self:Spectate( OBS_MODE_ROAMING )
	self:SetNoDraw(true)
	net.Start("ClientSpectate")
		net.WriteBool(true)
	net.Send(self)
	
	self:SetPlayerColor(Vector(1,1,1))
	self.Spectating = true
	
	ytil_GametypeRules[ytil_Variables.gametype].OnSpectator(self)

	-- Alert that the player is runner
	print( self:GetName() .. " has been assigned as spectator!")
end

function ply:SetBallOwnerWithBall()
	self:SetBallOwner()
	self:SetHasBall(true)
	self:GetViewModel():SetNoDraw(false)
	self:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW)
	print(self:Nick().." was set as the ball owner!")
end

net.Receive("ClientSpectate", function()

	local bool = net.ReadBool()
	if !IsValid(LocalPlayer()) then return end
	
	if bool then
		LocalPlayer():SetObserverMode( OBS_MODE_ROAMING )
	else
		LocalPlayer():SetObserverMode( OBS_MODE_NONE )
	end
end)