DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

function PLAYER:SetupDataTables()

	print("Setting up datatables for "..self.Player:Nick())

	self.Player:NetworkVar( "Bool", 0, "HasBall" )
	self.Player:NetworkVar( "Int", 0, "BallID" )
	self.Player:NetworkVar( "Vector", 0, "YTILColor" )
	self.Player:NetworkVar( "Bool", 1, "Frozen" )
	self.Player:NetworkVar( "Bool", 2, "Teleporting" )
	self.Player:NetworkVar( "Int", 1, "BallIndex" )
	--self.Player:NetworkVar( "Int", 3, "ChargeUp" )
	
	-- Setting starting variables here as these NetworkVars aren't created when the player is initially spawning
	if SERVER then
		if self.Player:Team() == 2 then
			self.Player:SetHasBall(true)
			--self.Player:GetViewModel():SetNoDraw(false)
			--self.Player:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW)
		else
			self.Player:SetHasBall(false)
			--self.Player:GetViewModel():SetNoDraw(true)
			--self.Player:GetActiveWeapon():SendWeaponAnim(ACT_VM_THROW)
		end
		print("Player class here")
		self.Player:SetYTILColor( self.Player.YTILColor or Vector(0,0,0) )
		self.Player:SetBallID(1)
	end
	
	self.Player.datatablesup = true

end

player_manager.RegisterClass( "ytil_playerclass", PLAYER, "player_default" )