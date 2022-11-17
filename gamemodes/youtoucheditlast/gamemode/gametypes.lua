ytil_GametypeRules = {
	
	[0] = { -- Used for the F1 menu when no type is marked
		name = "Selecciona un tipo de juego!",
		desc = "¡Haz clic en cualquier tipo de juego de arriba para leer una breve descripción o votar sobre cuál jugar!"
	},
	
	[1] = {
		name = "Todos Contra Todos",
		desc = "La experiencia clásica. ¡Tiempo infinito, 1 bola, no la toques! Cada vez que una persona toque la pelota, la pelota se volverá suya y será su trabajo golpear a otros jugadores con ella. Se otorga un punto a cada jugador que NO es golpeado por la pelota cada vez que alguien es golpeado.",
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
		name = "Papa Caliente",
		desc = "¡La Papa es peligrosa! ¡Después de un tiempo indeterminado, explotará, llevándose a su dueño con él! ¡Asegúrate de no tenerla cuando eso suceda! Si terminas consiguiéndola cuando se acabe el tiempo, ¡intenta llevartelos contigo! Se otorga un punto a todo jugador que NO toque la pelota cuando ésta cambie de dueño, y se pierden 3 puntos al explotar. Cada jugador muerto en la explosión también pierde 1 punto.",
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
		name = "Infeccion",
		desc = "¡La pelota es contagiosa! ¡Ser golpeado por la pelota significa que estarás infectado! Si infectas a alguien, obtendrás una nueva bola como recompensa, mientras que el jugador recién infectado tiene que buscar la que le golpeó. Se otorga un punto a cada sobreviviente cuando alguien se infecta.",
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
						v:ChatPrint("Todos fueron infectados! Reiniciando juego...")
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
		name = "Bomba infectada",
		desc = "¡Ahora la pelota es infecciosa Y peligrosa! ¡Infectarse significa que estás condenado a explotar al final de un tiempo desconocido! ¡Sobrevive hasta el final a toda costa! Se otorga un punto a cada superviviente tras la infección y se pierden 3 puntos tras la explosión. Cada jugador muerto en las explosiones también pierde 1 punto.",
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
						v:ChatPrint("Todos fueron infectados! Reiniciando juego...")
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
		name = "Cazeria",
		desc = "Lo contrario de Todos contra Todos. 1 jugador se marca como el \"Cazado\", ¡y será el único jugador SIN balón! ¡Cázalo para adquirir su rol y estar todo lo que puedas! Pero la caza no tiene fin... Se otorga un punto al cazado cada 10 segundos.",
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
		name = "Muerte",
		desc = "¡La pelota ahora es letal! ¡1 jugador es la Parca, se vuelve negro y obtiene poderes letales! ¡Si ese eres tú, usa tu nueva Bola Letal para matar a todos los jugadores! ¡Si no es así, será mejor que encuentres un buen lugar para esconderte! Se otorga un punto a cada sobreviviente cuando alguien muere.",
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
						v:ChatPrint("La muerte ha matado a todos los jugadores!")
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
		name = "Atrapa uno Atrapa todos",
		desc = "Dos bolas están en juego aquí, una negra y una blanca. ¡El negro solo puede ser usado por el jugador negro y congelará a cualquier otro jugador que golpee! ¡El blanco se puede usar para rescatar a tus compañeros de equipo y descongelarlos, y se puede pasar entre ustedes! Se otorga un punto a todos los demás Corredores cuando uno está congelado, un punto por descongelar a un compañero de equipo y un punto a la Muerte cuando gana.",
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
