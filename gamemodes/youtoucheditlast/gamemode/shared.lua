GM.Name = "You Touched it Last"
GM.Author = "Zet0r"
GM.Email = "N/A"
GM.Website = "https://youtube.com/Zet0r"

local CE = ConVarExists
local CC = CreateConVar

local FCVAR = { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE }
local P = "ytil_"

if not CE( P.."bombmanualenable" ) then CE( P.."bombmanualenable", 0, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_REPLICATED } ) end
if not CE( P.."bombshowtime" ) then CE( P.."bombshowtime", 0, FCVAR ) end
if not CE( P.."runnermagic" ) then CE( P.."runnermagic", 0, FCVAR ) end
if not CE( P.."voteallowed" ) then CE( P.."voteallowed", 1, FCVAR ) end
if not CE( P.."ballteletime" ) then CE( P.."ballteletime", 5, FCVAR ) end
if not CE( P.."ballsize" ) then CE( P.."ballsize", 20, FCVAR ) end

ytil_Variables = {
	throwPower = 20,
	maxCatchers = 1,
	bombTime = 0,
	postround = false,
	hunttime = 10,
	roundcount = 0,
	curmode_roundcount = 0,
	cyclemodekey = 1,
	gametype = 1 -- Current default mode
}
local usingmanualbomb = 0

team.SetUp(1, "Jugadores", Color(100,125,255), true)
team.SetUp(2, "Arabes", Color(255,100,100), true)
team.SetUp(3, "Spectators", Color(150,150,150), true)

local playermodels = {
"models/player/group01/female_01.mdl",
"models/player/group01/female_02.mdl",
"models/player/group01/female_03.mdl",
"models/player/group01/female_04.mdl",
"models/player/group01/female_05.mdl",
"models/player/group01/female_06.mdl",
"models/player/group01/male_01.mdl",
"models/player/group01/male_02.mdl",
"models/player/group01/male_03.mdl",
"models/player/group01/male_04.mdl",
"models/player/group01/male_05.mdl",
"models/player/group01/male_06.mdl",
"models/player/group01/male_07.mdl",
"models/player/group01/male_08.mdl",
"models/player/group01/male_09.mdl"
}

function IsValidBallIndex(index)
	if index == 0 then return false end
	
	local ent = Entity(index)
	if IsValid(ent) and ent:GetClass() == "ytil_ball" then return true end
end

function GM:PlayerSwitchFlashlight(ply, SwitchOn)
     return true
end

function GM:PlayerInitialSpawn(ply)

	player_manager.SetPlayerClass( ply, "ytil_playerclass" )

	if ytil_specialrewards[ply:SteamID()] then net.Start("YTILThanks") net.Send(ply) end

	ply:SetModel( playermodels[math.random(1, table.Count(playermodels))] )
	ply:InitYTILColor()
	ply:Give("touchedlast")
	ply:SendLua("CheckGametype("..ytil_Variables.gametype..", "..usingmanualbomb..")")
	ply.WRWeight = 1
	ply.SpectateAlways = false
	ply.charge = 0
	ply.charger = 2
	ply.beginTele = 0
	
	if ytil_Variables.gametype == 5 then
		if team.NumPlayers(1) < ytil_Variables.maxCatchers then 
			ply:SetRunner()
		else 
			ply:SetBallOwner()
		end
	else	
		if team.NumPlayers(2) < ytil_Variables.maxCatchers then 
			ply:SetBallOwner()
		else 
			ply:SetRunner()
		end
	end
	
	if #player.GetAll() == 1 then
		RoundRestart()
	end

end

function GM:PlayerSpawn(ply)

	ply:StripWeapons()
	ply:Give("touchedlast")
	ply:SetWalkSpeed(200)
	if ply:Team() == 2 then
		ply:SetRunSpeed(350)
	elseif ply:Team() == 3 then
		ply:SetRunSpeed(400)
		ply:Spectate( OBS_MODE_ROAMING )
		net.Start("ClientSpectate")
			net.WriteBool(true)
		net.Send(ply)
		ply:SetNoDraw(true)
	else
		ply:SetRunSpeed(300)
	end
	
	ply:SetupHands()
	if ply.datatablesup then
		if ply:GetHasBall() and IsValid(ply:GetActiveWeapon()) then
			ply:GetViewModel():SetNoDraw(false)
			ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW)
		else
			ply:GetViewModel():SetNoDraw(true)
			ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_THROW)
		end
	end
end

function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end

function GetWRPlayer()
	local wRan = GetWRandomTable()
	for k,v in pairs(team.GetPlayers(1)) do
		wRan:Add(v, v.WRWeight)
		v.WRWeight = v.WRWeight + 1
	end
	local rply = wRan:Roll()
	if !IsValid(rply) or !rply:IsPlayer() then rply = team.GetPlayers(1)[math.random(#team.GetPlayers(1))]
		if !IsValid(rply) then return end
		print("Roll failed, selected "..rply:Nick()) 
	end
	rply.WRWeight = 1
	return rply
end

function RoundRestart(mode)

	local oldmode = tonumber(ytil_Variables.gametype)
	if !mode then 
		mode = tonumber(ytil_Variables.gametype)
	else
		ytil_Variables.gametype = mode
	end
	
	if mode != oldmode and SERVER then
		hook.Call("ytil_GametypeChanged", nil, oldmode, mode)
	end
	
	if timer.Exists("RoundRestart") then timer.Remove("RoundRestart") end
	if timer.Exists("ytil_HuntTime") then timer.Remove("ytil_HuntTime") end
	ytil_Variables.postround = false
	game.CleanUpMap()
	print("Modo: ["..mode.."] ["..ytil_GametypeRules[mode].name.."]")
	hook.Remove("Tick", "CheckBombTime")
	
	if #player.GetAll() <= 0 then return end	-- Prevent the rest from running if there are no players on
	
	for k,v in pairs(team.GetPlayers(3)) do
		if v.SpectateAlways == false then
			v:Spectate(OBS_MODE_NONE)
			v:SetNoDraw(false)
			v:SetRunner()
		end
	end
	for k,v in pairs(player.GetAll()) do
		if v.SpectateAlways == false then
			v:Spawn()
			print("spawning")
			v:SetFrozen(false)
			v:SetPlayerColor(v:GetYTILColor())
			v:SetBallIndex(0)
		end
	end
	for k,v in pairs(team.GetPlayers(2)) do
		v:SetRunner()
		v:SetHasBall(false)
		v:GetViewModel():SetNoDraw(true)
		v:GetActiveWeapon():SendWeaponAnim(ACT_VM_THROW)
	end
	for k,v in pairs(team.GetPlayers(1)) do
		v:SetRunner()
		v:SetHasBall(false)
		v:GetViewModel():SetNoDraw(true)
		v:GetActiveWeapon():SendWeaponAnim(ACT_VM_THROW)
	end
	
	ytil_GametypeRules[mode].OnRoundStart()
	
	if mode == 2 or mode == 4 or GetConVar("ytil_bombmanualenable"):GetBool() then
		local ranTime = math.random(GetConVarNumber("ytil_bombmintime"), GetConVarNumber("ytil_bombmaxtime"))
		ytil_Variables.bombTime = math.Round(CurTime() + ranTime)
		net.Start("BombTime")
			net.WriteInt(ranTime, 10)
		net.Broadcast()
		hook.Add("Tick", "CheckBombTime", function()
			if CurTime() >= ytil_Variables.bombTime then
				BlowUpBalls()
				hook.Call("ytil_RoundEnd")
				for k,v in pairs(team.GetPlayers(2)) do
					v:AddFrags(-2)
				end
				hook.Remove("Tick", "CheckBombTime")
			end
		end)
		if GetConVar("ytil_bombmanualenable"):GetBool() then
			usingmanualbomb = 1
		end
	else
		usingmanualbomb = 0
	end
	
	hook.Call("ytil_RoundRestart")
	
	if ytil_Variables.gametype != oldmode and SERVER then
		SetGlobalInt("ytil_Gametype", mode)
		SetGlobalBool("ytil_ManualBombEnable", GetConVar("ytil_bombmanualenable"):GetBool())
		hook.Call("ytil_GametypeChanged", nil, oldmode, ytil_Variables.gametype)
		ytil_Variables.curmode_roundcount = 0
	end
	
	if SERVER then
		BroadcastLua("CheckGametype("..ytil_Variables.gametype..", "..GetConVar("ytil_bombmanualenable"):GetInt()..")")
	end
	
	ytil_Variables.roundcount = ytil_Variables.roundcount + 1
	ytil_Variables.curmode_roundcount = ytil_Variables.curmode_roundcount + 1

end

function BlowUpBalls(ballsonly)

	for k,v in pairs(ents.FindByClass("ytil_ball")) do
		if IsValid(v) and !v:GetAngelic() then
			local expl = ents.Create("ball_explosion_trigger")
			expl:SetPos(v:GetPos())
			expl:SetSoundID( v:GetTextureId() )
			expl:Spawn()
			
			if IsValid(v.owner) then -- v.owner dying just before this may be the cause to the massive explosion glitch
				util.BlastDamage(v, v.owner, v:GetPos(), 750, 500)
			else
				util.BlastDamage(v, v, v:GetPos(), 750, 500)
			end
			v:Remove()
		end
	end
	if ballsonly then return end
	
	for k,v in pairs(team.GetPlayers(2)) do
		if IsValid(v) and v:Alive() then
		
			local expl = ents.Create("ball_explosion_trigger")
			expl:SetPos(v:GetPos())
			if v:GetHasBall() then
				expl:SetSoundID( v:GetBallID() )
			else
				expl:SetPlayerExplosion( true ) -- Player Explosion
			end
			expl:Spawn()
			
			util.BlastDamage(v, v, v:GetPos(), 500, 300)
		end
	end

end

hook.Add("ytil_RoundEnd", "RoundEnd", function()

	if ytil_Variables.postround == true then return end
	-- No restarting twice if it already has ended in another way

	ytil_Variables.postround = true
	ytil_GametypeRules[	ytil_Variables.gametype].OnRoundEnd()
	
	local modechange = false
	if GetConVar("ytil_gametypecycle"):GetBool() then
		if ytil_Variables.curmode_roundcount >= ytil_CycleOrder[ytil_Variables.cyclemodekey].rounds then
			ytil_Variables.cyclemodekey = ytil_Variables.cyclemodekey + 1
			if ytil_Variables.cyclemodekey > #ytil_CycleOrder then ytil_Variables.cyclemodekey = 1 end
			modechange = ytil_CycleOrder[ytil_Variables.cyclemodekey].mode
			
			if ytil_CycleOrder[ytil_Variables.cyclemodekey].bomb and !GetConVar("ytil_bombmanualenable"):GetBool() then
				RunConsoleCommand("ytil_bombmanualenable", 1)
			elseif !ytil_CycleOrder[ytil_Variables.cyclemodekey].bomb and GetConVar("ytil_bombmanualenable"):GetBool() then
				RunConsoleCommand("ytil_bombmanualenable", 0)
			end
			
			if ytil_CycleOrder[ytil_Variables.cyclemodekey].bombmintime then
				RunConsoleCommand("ytil_bombmintime", ytil_CycleOrder[ytil_Variables.cyclemodekey].bombmintime)
			end
			if ytil_CycleOrder[ytil_Variables.cyclemodekey].bombmaxtime then
				RunConsoleCommand("ytil_bombmaxtime", ytil_CycleOrder[ytil_Variables.cyclemodekey].bombmaxtime)
			end
		end
	end
	
	if hook.Call("ytil_MaxRoundsReached") then return end
	
	if modechange then PrintMessage(HUD_PRINTTALK, "Max rounds reached. Changing gametype to "..ytil_GametypeRules[modechange].name) end
	
	timer.Create("RoundRestart", GetConVar("ytil_postroundtime"):GetInt(), 1, function()
		if modechange then
			RoundRestart(modechange)
		else
			RoundRestart()
		end
	end)

end)

function GM:PlayerDeath( ply, inflictor, attacker )
	ply.AutoSpawnTime = CurTime() + 5
end

function GM:PlayerDeathThink( ply )

	if ytil_Variables.postround then return end

	if (  ply.NextSpawnTime && ply.NextSpawnTime > CurTime() ) then return end
	if ( ply:KeyPressed( IN_ATTACK ) || ply:KeyPressed( IN_ATTACK2 ) || ply:KeyPressed( IN_JUMP ) ) then
		if ytil_Variables.gametype == 6 then
			if ply:Team() == 3 and !ply.Spectating then
				ply:SpawnAsSpectator()
			else
				ply:Spawn()
			end
		else
			ply:Spawn()
		end
	end
	
	-- Autospawn after 5 seconds
	if ply.AutoSpawnTime and ply.AutoSpawnTime <= CurTime() and ply:Team() != 3 then
		ply:Spawn()
	end
	
end

function Quit(ent)
	if IsValid( ent ) and ent:IsPlayer() then
		if IsValid(ent.ball) then ent.ball:Remove() return end
	end
end
hook.Add("EntityRemoved", "quit", Quit)

hook.Add( "SetupMove", "FreezePlayersAngelic", function( ply, mv, cmd )
	if ply:GetFrozen() or ply:GetTeleporting() then
		mv:SetUpSpeed( 0 )
		cmd:SetUpMove( 0 )
		mv:SetSideSpeed( 0 )
		cmd:SetSideMove( 0 )
		mv:SetForwardSpeed( 0 )
		cmd:SetForwardMove( 0 )
	end
end )