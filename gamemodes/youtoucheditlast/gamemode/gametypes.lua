ytil_GametypeRules = {
	
	[0] = { -- Used for the F1 menu when no type is marked
		name = "Select a Gametype!",
		desc = "Click on any gametype above to read a short description or cast your vote on which one to play! (Requires that the server allows gametype voting)"
	},
	
	[1] = {
		name = "Free for All",
		desc = "The classic experience. Infinite time, 1 ball, don't touch it! Every time a person touches the ball, the ball will become his, and it will be his job to hit other players with it. A point is given to every player who is NOT hit by the ball whenever someone is hit.",
		texture = Material("youtoucheditlast/freeforall.png"),
		
		OnPlayerHit = function(ball, owner, ply) -- ply = player that was hit
			if ply:Team() == 1 then
				ball:SetNewOwner(ply)
				
				-- Give points to every other runner
				for k,v in pairs(team.GetPlayers(1)) do
					if v != owner and v != ply then
						v:AddFrags(1)
					end
				end
			end
		end,
		
		GetTeleportableBall = function(ply)
			if IsValidBallIndex(ply:GetBallIndex()) then return Entity(ply:GetBallIndex()) end
		end,
		
		CanPickupBall = function(ball, ply)
			if ball.owner == ply then return true end
			return false
		end,
		
		OnRoundStart = function()
			local rply = GetWRPlayer() -- Gets a weighted random player from Runner team (everyone at spawn)
			if IsValid(rply) then
				rply:SetBallOwnerWithBall()
			end
		end,
		
		OnRoundEnd = function()
			-- Nothing special
		end,
		
		OnBallOwner = function(ply)
			-- Don't do the normal here, ball ownership is handled in RoundStart and OnPlayerHit
		end,
		
		OnRunner = function(ply)
			-- Same as above
		end,
		
		OnSpectator = function(ply)
			-- Usually don't do anything here at all
		end
	},
	
	[2] = {
		name = "Bomb",
		desc = "The ball is dangerous! After an unknown time it will explode, taking its owner down with it! Make sure you do not own it when that happens! If you do end up getting it when time runs out, try to take others down with you! A point is given to every player NOT hit by the ball when it changes hands, and 3 points are lost upon exploding. Every player killed in the explosion also loses 1 point.",
		texture = Material("youtoucheditlast/timerbomb.png"),
		
		OnPlayerHit = function(ball, owner, ply) -- ply = player that was hit
			if ply:Team() == 1 then
				ball:SetNewOwner(ply)
				for k,v in pairs(team.GetPlayers(1)) do
					if v != owner and v != ply then
						v:AddFrags(1)
					end
				end
			end
		end,
		
		GetTeleportableBall = function(ply)
			if IsValidBallIndex(ply:GetBallIndex()) then return Entity(ply:GetBallIndex()) end
		end,
		
		CanPickupBall = function(ball, ply)
			if ball.owner == ply then return true end
			return false
		end,
		
		OnRoundStart = function()
			local rply = GetWRPlayer()
			if IsValid(rply) then
				rply:SetBallOwnerWithBall()
			end
			-- No need to create the bomb timer, it is hard coded into the round restart function
		end,
		
		OnRoundEnd = function()
			-- Nothing special, bomb's built into the timer
			-- Bomb is hardcoded due to the manual bomb enable convar
		end,
		
		OnBallOwner = function(ply)
		end,
		
		OnRunner = function(ply)
		end,
		
		OnSpectator = function(ply)
		end
	},
	
	[3] = {
		name = "Infection",
		desc = "The ball is infectious! Getting hit by the ball means that you will be infected! If you infect someone you will get a new ball as a reward, while the newly infected player has to fetch the one that hit him. A point is given to every survivor when someone is infected.",
		texture = Material("youtoucheditlast/infection.png"),
		
		OnPlayerHit = function(ball, owner, ply) -- ply = player that was hit
			if ply:Team() == 1 then
				owner:SetHasBall(true)
				owner:GetViewModel():SetNoDraw(false)
				owner:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW)
				ball:SetNewOwner(ply, true) -- First argument means stay ball owner team
				for k,v in pairs(team.GetPlayers(1)) do
					if v != owner and v != ply then
						v:AddFrags(1)
					end
				end
				
				ply:SetPlayerColor( Vector( ply.YTILColor.x * 0.3, ply.YTILColor.y * 0.3, ply.YTILColor.z * 0.3) )
				if team.NumPlayers(1) <= 0 then
					hook.Call("ytil_RoundEnd")
					for k,v in pairs(player.GetAll()) do
						v:ChatPrint("Everyone was infected! Restarting round ...")
					end
				end
			end
		end,
		
		GetTeleportableBall = function(ply)
			if IsValidBallIndex(ply:GetBallIndex()) then return Entity(ply:GetBallIndex()) end
		end,
		
		CanPickupBall = function(ball, ply)
			if ball.owner == ply then return true end
			return false
		end,
		
		OnRoundStart = function()
			local rply = GetWRPlayer()
			if IsValid(rply) then
				rply:SetBallOwnerWithBall()
			end
		end,
		
		OnRoundEnd = function()
		end,
		
		OnBallOwner = function(ply)
			ply:SetPlayerColor( Vector( ply.YTILColor.x * 0.3, ply.YTILColor.y * 0.3, ply.YTILColor.z * 0.3) )
			-- Infected players are darker
		end,
		
		OnRunner = function(ply)
			ply:SetPlayerColor( ply.YTILColor )
			-- Reset color should they become Runners
		end,
		
		OnSpectator = function(ply)
		
		end
	},
	
	[4] = {
		name = "Infected Bomb",
		desc = "Now the ball is infectious AND dangerous! Getting infected means you're doomed to explode at the end of an unknown timer! Survive until the very end at all costs! A point is given to every survivor upon infection, and 3 points are lost upon explosion. Every player killed in the explosions also lose 1 point.",
		texture = Material("youtoucheditlast/infectionbomb.png"),
		
		OnPlayerHit = function(ball, owner, ply) -- ply = player that was hit
			if ply:Team() == 1 then
				owner:SetHasBall(true)
				owner:GetViewModel():SetNoDraw(false)
				owner:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW)
				ball:SetNewOwner(ply, true)
				for k,v in pairs(team.GetPlayers(1)) do
					if v != owner and v != ply then
						v:AddFrags(1)
					end
				end
				
				ply:SetPlayerColor( Vector( ply.YTILColor.x * 0.3, ply.YTILColor.y * 0.3, ply.YTILColor.z * 0.3) )
				if team.NumPlayers(1) <= 0 then
					hook.Call("ytil_RoundEnd")
					for k,v in pairs(player.GetAll()) do
						v:ChatPrint("Everyone was infected! Restarting round ...")
					end
					BlowUpBalls() -- End Infected Bomb with everyone blowing up!
				end
			end
		end,
		
		GetTeleportableBall = function(ply)
			if IsValidBallIndex(ply:GetBallIndex()) then return Entity(ply:GetBallIndex()) end
		end,
		
		CanPickupBall = function(ball, ply)
			if ball.owner == ply then return true end
			return false
		end,
		
		OnRoundStart = function()
			local rply = GetWRPlayer()
			if IsValid(rply) then
				rply:SetBallOwnerWithBall()
			end
		end,
		
		OnRoundEnd = function()
		end,
		
		OnBallOwner = function(ply)
			ply:SetPlayerColor( Vector( ply.YTILColor.x * 0.3, ply.YTILColor.y * 0.3, ply.YTILColor.z * 0.3) )
		end,
		
		OnRunner = function(ply)
			ply:SetPlayerColor( ply.YTILColor )
		end,
		
		OnSpectator = function(ply)
		end
	},
	
	[5] = {
		name = "Hunt",
		desc = "The opposite of Free for All. 1 player gets marked as the Hunted, and he will be the only player WITHOUT a ball! Hunt him down to acquire his role! Stay in this role for as long as you can! But there is no end to the hunting ... A point is given to the hunted every 10 seconds.",
		texture = Material("youtoucheditlast/hunt.png"),
		
		OnPlayerHit = function(ball, owner, ply) -- ply = player that was hit
			if ply:Team() == 1 then
				ball:SetNewOwner(ply)
			end
		end,
		
		GetTeleportableBall = function(ply)
			if IsValidBallIndex(ply:GetBallIndex()) then return Entity(ply:GetBallIndex()) end
		end,
		
		CanPickupBall = function(ball, ply)
			if ball.owner == ply then return true end
			return false
		end,
		
		OnRoundStart = function()
			local rply = GetWRPlayer() -- Gets a weighted random player from Runner team (everyone at spawn)
			if !IsValid(rply) then return end
			for k,v in pairs(team.GetPlayers(1)) do
				if v != rply then
					v:SetBallOwnerWithBall()	-- Sets every other runner to a ball owner instead
				end
			end
			timer.Create("ytil_HuntTime", ytil_Variables.hunttime, 0, function()
				for k,v in pairs(team.GetPlayers(1)) do
					v:AddFrags(1)
				end
			end)
		end,
		
		OnRoundEnd = function()
			if timer.Exists("ytil_HuntTime") then timer.Remove("ytil_HuntTime") end
		end,
		
		OnBallOwner = function(ply)
		end,
		
		OnRunner = function(ply)
		end,
		
		OnSpectator = function(ply)
		end
	},
	
	[6] = {
		name = "Death",
		desc = "The ball is now lethal! 1 player gets the role as Death, turning black and getting lethal powers! If that's you, use your new deadly ball to kill all survivors! If it's not, you better find a good place to hide! A point is given to every survivor when someone is killed.",
		texture = Material("youtoucheditlast/death.png"),
		
		OnPlayerHit = function(ball, owner, ply) -- ply = player that was hit
			if ply:Team() == 1 then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker(owner)
				dmginfo:SetDamage(100000)
				dmginfo:SetDamageForce( (ply:GetPos() - ball:GetPos()):GetNormal() * 50000 + Vector(0,0,50000) )

				ply:TakeDamageInfo(dmginfo)
				ply:SetTeam(3)
				
				if ytil_BallList[ball:GetTextureId()].killSound != nil then ball:EmitSound( ytil_BallList[ball:GetTextureId()].killSound, 75, 100 ) end
				if team.NumPlayers(1) <= 0 then
					for k,v in pairs(player.GetAll()) do
						v:ChatPrint("Death has killed every Runner!")
					end
					hook.Call("ytil_RoundEnd")
					for k,v in pairs(team.GetPlayers(2)) do
						v:AddFrags(1)
					end
				end
				for k,v in pairs(team.GetPlayers(1)) do
					v:AddFrags(1)
				end
			end
		end,
		
		GetTeleportableBall = function(ply)
			if IsValidBallIndex(ply:GetBallIndex()) then return Entity(ply:GetBallIndex()) end
		end,
		
		CanPickupBall = function(ball, ply)
			if ball.owner == ply then return true end
			return false
		end,
		
		OnRoundStart = function()
			local rply = GetWRPlayer()
			if IsValid(rply) then
				rply:SetBallOwnerWithBall()
			end
		end,
		
		OnRoundEnd = function()
		end,
		
		OnBallOwner = function(ply)
			ply:SetPlayerColor( Vector( ply.YTILColor.x * 0.1, ply.YTILColor.y * 0.1, ply.YTILColor.z * 0.1) )
			-- Even darker for Death
		end,
		
		OnRunner = function(ply)
			ply:SetPlayerColor( ply.YTILColor )
		end,
		
		OnSpectator = function(ply)
		end
	},
	
	[7] = {
		name = "Angelic",
		desc = "Two balls are at play here, a black and a white. The black can only be used by the black player, and will freeze any other player it hits! The white can be used to rescue your teammates and unfreeze them, and can be passed around between you! A point is given to every other Runner when one is frozen, a point for unfreezing a teammate, and a point to Death when he wins.",
		texture = Material("youtoucheditlast/angelic.png"),
		
		OnPlayerHit = function(ball, owner, ply) -- ply = player that was hit
			if ply:Team() == 1 then
				if ball:GetAngelic() then
					if ply:GetFrozen() then
						ply:SetFrozen(false)
						owner:AddFrags(1)
					end
					ball:SetNewOwner(ply, false, true) -- Ownership changes to the last player hit, second argument true means stay runner team
				else
					if !ply:GetFrozen() then
						ply:SetFrozen(true)
						if ply:GetHasBall() then
							ply:GetActiveWeapon():ThrowBall(10)
						end
						if AllPlayersFrozen() then
							for k,v in pairs(player.GetAll()) do
								v:ChatPrint("Death has frozen every Runner!")
							end
							hook.Call("ytil_RoundEnd")
							for k,v in pairs(team.GetPlayers(2)) do
								v:AddFrags(1)
							end
						else
							owner:AddFrags(1)
						end
					end
				end
			end
		end,
		
		GetTeleportableBall = function(ply)
			if ply:GetFrozen() then return end
			if IsValidBallIndex(ply:GetBallIndex()) then return Entity(ply:GetBallIndex()) end
			if ply:Team() == 1 then
				for k,v in pairs(team.GetPlayers(1)) do
					if v:GetFrozen() and IsValidBallIndex(v:GetBallIndex()) then
						return Entity(v:GetBallIndex())
					end
				end
			end
		end,
		
		CanPickupBall = function(ball, ply)
			if ply:GetFrozen() then return false end	-- Frozen players can not pick up any ball
			if IsValid(ply.ball) and ball == ply.ball then return ball end -- If you own a ball, you can only pick that up
			if (!IsValid(ball.owner) or ball.owner:GetFrozen()) and ball:GetAngelic() and ply:Team() == 1 then return true end -- If the owner is frozen then you can pick it up
			return false
		end,
		
		OnRoundStart = function()
			local rply = GetWRPlayer()
			if IsValid(rply) then
				rply:SetBallOwnerWithBall()
			end
			
			local rply2 = table.Random(team.GetPlayers(1))
			if IsValid(rply2) then
				rply2:SetHasBall(true)
				rply2:GetViewModel():SetNoDraw(false)
				rply2:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW)
			end
		end,
		
		OnRoundEnd = function()
		end,
		
		OnBallOwner = function(ply)
			ply:SetPlayerColor( Vector( ply.YTILColor.x * 0.1, ply.YTILColor.y * 0.1, ply.YTILColor.z * 0.1) )
			-- Even darker for Death (Also his name in Angelic)
		end,
		
		OnRunner = function(ply)
			ply:SetPlayerColor( ply.YTILColor )
		end,
		
		OnSpectator = function(ply)
		end
	},
}
