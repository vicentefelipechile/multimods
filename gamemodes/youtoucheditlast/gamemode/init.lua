Msg("Init.lua loads!")


MsgC( Color( 255, 150, 150 ), "\n\n          ---------------- You Touched it Last ----------------\n" )
MsgC( Color( 255, 150, 150 ), "                  Important information to server owners:      \n\n" )
MsgC( Color( 255, 200, 200 ), "          You Touched it Last has been made with private servers in mind\n" )
MsgC( Color( 255, 200, 200 ), "          As such, many of the settings are not optimized for a dedicated server\n" )
MsgC( Color( 255, 200, 200 ), "          I therefore recommend you to make sure you have done the following:\n" )
MsgC( Color( 200, 255, 200 ), "          - Enabled either gametype voting or gametype cycling\n" )
MsgC( Color( 200, 255, 200 ), "          - Turn on ytil_preventsuicide\n" )
MsgC( Color( 200, 255, 200 ), "          - Set ytil_startgametype so it doesn't always start in Free-for-All\n" )
MsgC( Color( 200, 255, 200 ), "          - !! Checked to make sure the gamemode actually works for you !!\n" )
MsgC( Color( 200, 255, 200 ), "          - Set a fitting ytil_votepct\n" )
MsgC( Color( 200, 255, 200 ), "          - If with cycling, enabled manual bomb for gametypes that are otherwise infinite (see costumizeserver.lua)\n" )
MsgC( Color( 255, 200, 200 ), "          Please take a look at the FAQ on the workshop for a list of commands\n" )
MsgC( Color( 255, 200, 200 ), "          Thank you for being considerate of your community\n" )
MsgC( Color( 255, 150, 150 ), "\n          ---------------- You Touched it Last ----------------\n\n" )

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "player.lua" )
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("ytil_playerclass.lua")
AddCSLuaFile("customizeserver.lua")
AddCSLuaFile("gametypes.lua")

include( "gametypes.lua" )
include( "shared.lua" )
include( "player.lua" )
include( "weightedrandom.lua" )
include( "ytil_playerclass.lua" )
include( "customizeserver.lua" )

resource.AddFile("materials/youtoucheditlast/death.png")
resource.AddFile("materials/youtoucheditlast/angelic.png")
resource.AddFile("materials/youtoucheditlast/freeforall.png")
resource.AddFile("materials/youtoucheditlast/gameshower.png")
resource.AddFile("materials/youtoucheditlast/hunt.png")
resource.AddFile("materials/youtoucheditlast/infection.png")
resource.AddFile("materials/youtoucheditlast/infectionbomb.png")
resource.AddFile("materials/youtoucheditlast/powerbar.png")
resource.AddFile("materials/youtoucheditlast/powerbarblue.png")
resource.AddFile("materials/youtoucheditlast/powerbarcharger.png")
resource.AddFile("materials/youtoucheditlast/timerbomb.png")
resource.AddFile("materials/youtoucheditlast/manualbomb.png")

SetGlobalInt("ytil_Gametype", GetConVar("ytil_startgametype"):GetInt())
SetGlobalBool("ytil_VoteAllowed", GetConVar("ytil_voteallowed"):GetBool())
SetGlobalBool("ytil_ShowBombTime", GetConVar("ytil_bombshowtime"):GetBool())
SetGlobalBool("ytil_RunnerMagic", GetConVar("ytil_runnermagic"):GetBool())

if not ConVarExists( "ytil_bombmintime" ) then CreateConVar( "ytil_bombmintime", 60, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE } ) end
if not ConVarExists( "ytil_bombmaxtime" ) then CreateConVar( "ytil_bombmaxtime", 180, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE } ) end
if not ConVarExists( "ytil_gametypecycle" ) then CreateConVar( "ytil_gametypecycle", 0, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE } ) end
if not ConVarExists( "ytil_postroundtime" ) then CreateConVar( "ytil_postroundtime", 10, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE } ) end
if not ConVarExists( "ytil_votepct" ) then CreateConVar( "ytil_votepct", 0.4, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE } ) end
if not ConVarExists( "ytil_afktime" ) then CreateConVar( "ytil_afktime", 30, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE } ) end
if not ConVarExists( "ytil_startgametype" ) then CreateConVar( "ytil_startgametype", 1, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE } ) end
if not ConVarExists( "ytil_preventsuicide" ) then CreateConVar( "ytil_preventsuicide", 0, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE } ) end

if GetConVar("ytil_startgametype"):GetInt() <= (#ytil_GametypeRules) and GetConVar("ytil_startgametype"):GetInt() > 0 then
	ytil_Variables.gametype = GetConVar("ytil_startgametype"):GetInt()
else
	print("The set start gametype does not exist, set gametype to Free For All.") 
end

local modeVotes = {
	{}, -- Free for All
	{}, -- Bomb
	{}, -- Infection
	{}, -- Infected Bomb
	{}, -- Hunt
	{}, -- Death
	{}, -- Angelic
	nil
}

-- This is a list of Beta Testers. Please do not change this, as this is used for a special ball skin exclusive to those who helped
ytil_specialrewards = {
["STEAM_0:1:40695593"] = true,
["STEAM_0:1:47290837"] = true,
["STEAM_0:1:35905306"] = true,
["STEAM_0:0:34174736"] = true,					-- DO NOT change or add to these!
["STEAM_0:1:42043955"] = true,
["STEAM_0:1:99771088"] = true,
["STEAM_0:0:36791203"] = true,
["STEAM_0:1:39810154"] = true,
["STEAM_0:1:107405769"] = true,
["STEAM_0:0:52531688"] = true,
["STEAM_0:1:67644745"] = true,
["STEAM_0:1:49721574"] = true
}

util.AddNetworkString("PlayerLoaded")
net.Receive("PlayerLoaded", function(len, ply)
	
	net.Start("BombTime")
		net.WriteInt(ytil_Variables.bombTime - CurTime(), 10)
	net.Send(ply)
	
end)

net.Receive("RoundRestart", function(len, ply)

	if !ply:ytil_HasAdminPriviledges() then return end

	local mode = net.ReadInt(4)
	
	if mode == 0 then
		RoundRestart()
	else
		RoundRestart(mode)
	end
	
end)

net.Receive("RerollC", function(len, ply)

	if !ply:ytil_HasAdminPriviledges() then return end

	local ent = net.ReadEntity()
	
	if IsValid(ent) then
		ent:InitYTILColor()
	end
	
end)

net.Receive("Force", function(len, ply)

	if !ply:ytil_HasAdminPriviledges() then return end

	local ent = net.ReadEntity()
	local mode = net.ReadInt(4)
	
	if !IsValid(ent) or !ent:IsPlayer() then return end
	
	if mode == 1 then
		if ent:Team() == 1 then
			print(ent:Nick().." is already a Runner. Respawned him.")
			ent:Spawn()
		else
			ent:SetRunner()
			if IsValid(ent.ball) then ent.ball:Remove() end
			ent:SetHasBall(false)
			if IsValid(ent:GetActiveWeapon()) then ent:GetActiveWeapon():SendWeaponAnim(ACT_VM_THROW) end
			if IsValid(ent:GetViewModel()) then ent:GetViewModel():SetNoDraw(true) end
			ent:Spawn()
		end
	elseif mode == 2 then
		if ent:Team() == 2 then
			print(ent:Nick().." is already a Ball Owner. Respawned him.")
			ent:Spawn()
		else
			ent:SetBallOwner()
			if IsValid(ent.ball) then ent.ball:Remove() end
			ent:SetHasBall(true)
			if IsValid(ent:GetViewModel()) then ent:GetViewModel():SetNoDraw(false) end
			if IsValid(ent:GetActiveWeapon()) then ent:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW) end
			ent:Spawn()
		end
	elseif mode == 3 then
		if ent:Team() == 3 then
			print(ent:Nick().." is already a Spectator.")
		else
			ent:SpawnAsSpectator()
			if IsValid(ent.ball) then ent.ball:Remove() end
			ent:SetHasBall(false)
			if IsValid(ent:GetActiveWeapon()) then ent:GetActiveWeapon():SendWeaponAnim(ACT_VM_THROW) end
			if IsValid(ent:GetViewModel()) then ent:GetViewModel():SetNoDraw(true) end
		end
	elseif mode == 4 then
		if ent:Team() != 2 then
			print(ent:Nick().." is not a Ball Owner.")
		else
			if ent:GetHasBall() then
				print(ent:Nick().." already have his/her ball.")
			else
				if IsValid(ent.ball) then ent.ball:Remove() end
				ent:SetHasBall(true)
				if IsValid(ent:GetViewModel()) then ent:GetViewModel():SetNoDraw(false) end
				if IsValid(ent:GetActiveWeapon()) then ent:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW) end
			end
		end
	else Error("Admin Panel Force returned an invalid mode!") end
	
end)

net.Receive("Vote", function(len, ply)

	if !GetConVar("ytil_voteallowed"):GetBool() then return end

	local mode = net.ReadInt(4)
	
	if mode == 0 and ply.vote != 0 then
		table.RemoveByValue( modeVotes[ply.vote], ply)
		ply.vote = 0
		for k,v in pairs(player.GetAll()) do
			v:ChatPrint(ply:Nick().." has cancelled his vote.")
		end
		return
	end
	
	print(ply:Nick().." has voted on "..ytil_GametypeRules[mode].name)
	table.insert(modeVotes[mode], ply)
	ply.vote = mode
	
	CalculateVotes(mode, ply)
	
end)

net.Receive("Spectate", function(len, ply)

	if ply:Team() == 3 then
		if ytil_Variables.gametype == 6 then
			if ply.SpectateAlways then
				ply.SpectateAlways = false
				ply:ChatPrint("You will join back in next round")
			else
				ply.SpectateAlways = true
				ply:ChatPrint("You will stay spectator")
				ply:Spawn()
			end
		else
			DecideSpawningTeam(ply)
			ply:Spawn()
			ply:SetPlayerColor(ply:GetYTILColor())
			ply.SpectateAlways = false
		end
	else
		ply:SpawnAsSpectator()
		if IsValid(ply.ball) then ply.ball:Remove() end
		ply:SetHasBall(false)
		if IsValid(ply:GetViewModel()) then ply:GetViewModel():SetNoDraw(true) end
		if IsValid(ply:GetActiveWeapon()) then ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_THROW) end
		ply.SpectateAlways = true
	end
	
	if ytil_Variables.gametype == 5 then
		if team.NumPlayers(1) <= 0 then
			for k,v in pairs(player.GetAll()) do
				v:ChatPrint("The Hunted player was turned Spectator. Restarting round ...")
			end
			hook.Call("ytil_RoundEnd")
		end
	else
		if team.NumPlayers(2) <= 0 then
			for k,v in pairs(player.GetAll()) do
				v:ChatPrint("The Ball Owner was turned Spectator. Restarting round ...")
			end
			hook.Call("ytil_RoundEnd")
		end
	end
	
end)

net.Receive("ShowBombTime", function(len, ply)
	if !ply:ytil_HasAdminPriviledges() then return end
	local bool = net.ReadBit()
	RunConsoleCommand("ytil_bombshowtime", bool)
end)

net.Receive("RunnerMagic", function(len, ply)
	if !ply:ytil_HasAdminPriviledges() then return end
	local bool = net.ReadBit()
	RunConsoleCommand("ytil_runnermagic", bool)
end)

net.Receive("MaxTime", function(len, ply)
	if !ply:ytil_HasAdminPriviledges() then return end
	local time = net.ReadInt(10)
	RunConsoleCommand("ytil_bombmaxtime", math.Round(time))
end)

net.Receive("MinTime", function(len, ply)
	if !ply:ytil_HasAdminPriviledges() then return end
	local time = net.ReadInt(10)
	RunConsoleCommand("ytil_bombmintime", math.Round(time))
end)

net.Receive("ManualBomb", function(len, ply)
	if !ply:ytil_HasAdminPriviledges() then return end
	local bool = net.ReadBit()
	RunConsoleCommand("ytil_bombmanualenable", bool)
end)

net.Receive("BallSize", function(len, ply)
	if !ply:ytil_HasAdminPriviledges() then return end
	local size = net.ReadInt(10)
	RunConsoleCommand("ytil_ballsize", size)
end)


util.AddNetworkString("BombTime")
util.AddNetworkString("RoundRestart")
util.AddNetworkString("RerollC")
util.AddNetworkString("Popup")
util.AddNetworkString("Force")
util.AddNetworkString("Vote")
util.AddNetworkString("Spectate")
util.AddNetworkString("ShowBombTime")
util.AddNetworkString("RunnerMagic")
util.AddNetworkString("MaxTime")
util.AddNetworkString("MinTime")
util.AddNetworkString("ClientSpectate")
util.AddNetworkString("YTILThanks")
util.AddNetworkString("ManualBomb")
util.AddNetworkString("BallSize")

function GM:PlayerDisconnected( ply )
	
	ply:RestockColor()
	
	if team.NumPlayers(2) <= 0 and ply:Team() == 2 then
		if ytil_Variables.gametype == 1 or ytil_Variables.gametype == 3 then
			if #player:GetAll() > 0 then 
				-- choose a random player from the server to be assigned as a ball owner
				local Rand = player.GetAll()[math.random(1, #player:GetAll())]
				print("Disconnected player was a ball owner, assigning random player as the ball owner.")
				Rand:SetBallOwner()
				Rand:SetHasBall(true)
				Rand:SetBallIndex(0)

			else print("Last player on server disconnected.") end
		else
			RoundRestart()
		end
	end
	
	if ply.vote and ply.vote != 0 then
		table.RemoveByValue( modeVotes[ply.vote], ply)
		ply.vote = 0
	end
end

function GM:ShowHelp(ply)
	net.Start("Popup")
		net.WriteBit( ply:ytil_HasAdminPriviledges() )
	net.Send(ply)
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
	return true
end

function CalculateVotes(mode, ply)

	local threshold = math.ceil(#player.GetAll() * GetConVar("ytil_votepct"):GetFloat())
	local count = table.Count(modeVotes[mode])
	local curModeCount = table.Count(modeVotes[ytil_Variables.gametype])

	if count >= threshold + curModeCount then
		for k,v in pairs(player.GetAll()) do
			v:ChatPrint("Mode vote has reached the threshold! Changing mode ...")
		end
		hook.Call("ytil_VotePassed", nil, ytil_Variables.gametype, mode)
		timer.Simple(5, function() RoundRestart(mode) end)
	else
		if mode == ytil_Variables.gametype then
			for k,v in pairs(player.GetAll()) do
				v:ChatPrint(ply:Nick().." has voted on the current mode. 1 more vote will be needed to change to another.")
			end
		else
			for k,v in pairs(player.GetAll()) do
				v:ChatPrint(ply:Nick().." has voted on mode "..ytil_GametypeRules[mode].name..". "..threshold + curModeCount -count.." more votes needed on this mode to change.")
			end
		end
	end

end


function DecideSpawningTeam(ply)

	if ytil_Variables.gametype == 5 then
		if team.NumPlayers(1) <= 0 then
			ply:SetRunner()
			if IsValid(ply:GetViewModel()) then ply:GetViewModel():SetNoDraw(true) end
			if IsValid(ply:GetActiveWeapon()) then ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_THROW) end
		else
			ply:SetBallOwner()
			ply:SetHasBall(true)
			if IsValid(ply:GetViewModel()) then ply:GetViewModel():SetNoDraw(false) end
			if IsValid(ply:GetActiveWeapon()) then ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW) end
		end
	elseif ytil_Variables.gametype == 6 then
		if team.NumPlayers(2) <= 0 then
			ply:SetBallOwner()
			ply:SetHasBall(true)
			if IsValid(ply:GetViewModel()) then ply:GetViewModel():SetNoDraw(false) end
			if IsValid(ply:GetActiveWeapon()) then ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW) end
		else
			ply:SpawnAsSpectator()
			if IsValid(ply:GetViewModel()) then ply:GetViewModel():SetNoDraw(true) end
			if IsValid(ply:GetActiveWeapon()) then ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_THROW) end
		end
	else
		if team.NumPlayers(2) <= 0 then
			ply:SetBallOwner()
			ply:SetHasBall(true)
			if IsValid(ply:GetViewModel()) then ply:GetViewModel():SetNoDraw(false) end
			if IsValid(ply:GetActiveWeapon()) then ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW) end
		else
			ply:SetRunner()
			if IsValid(ply:GetViewModel()) then ply:GetViewModel():SetNoDraw(true) end
			if IsValid(ply:GetActiveWeapon()) then ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_THROW) end
		end
	end

end

function GM:PlayerCanPickupWeapon( ply, wep )
	return ( wep:GetClass() == "touchedlast" )
end

function GM:GetFallDamage( ply, speed )
	return ( speed / 20 )
end

function AllPlayersFrozen()
	for k,v in pairs(team.GetPlayers(1)) do
		if !v:GetFrozen() then return false end
	end
	return true
end

function ytil_GetNonSpectatingPlayers()
	local teamtbl = {}
	for k,v in pairs(team.GetPlayers(1)) do
		table.insert(teamtbl, v)
	end
	for k,v in pairs(team.GetPlayers(2)) do
		table.insert(teamtbl, v)
	end
	return teamtbl
end

function GM:KeyPress(ply, key)
	if ply:Team() == 3 then
		if !ply.SpectatorTarget then ply.SpectatorTarget = 0 end
		if ply:GetObserverMode() == OBS_MODE_ROAMING and ply.Spectating then
			if key == IN_ATTACK then
				ply.SpectatorTarget = ply.SpectatorTarget + 1
				if ply.SpectatorTarget > #ytil_GetNonSpectatingPlayers() then ply.SpectatorTarget = 1 end
				
				if ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget] == ply then ply.SpectatorTarget = ply.SpectatorTarget + 1 end
				if !IsValid(ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget]) then return end
				
				ply:SetPos(ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget]:GetPos() + Vector(0,0,50))
			elseif key == IN_ATTACK2 then
				ply.SpectatorTarget = ply.SpectatorTarget - 1
				if ply.SpectatorTarget < 0 then ply.SpectatorTarget = #ytil_GetNonSpectatingPlayers() end
				
				if ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget] == ply then ply.SpectatorTarget = ply.SpectatorTarget - 1 end
				if !IsValid(ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget]) then return end
				
				ply:SetPos(ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget]:GetPos() + Vector(0,0,50))
			elseif key == IN_JUMP then
				ply:SetObserverMode(OBS_MODE_CHASE)
				if ply.SpectatorTarget == 0 then ply.SpectatorTarget = 1 end
				
				if ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget] == ply then ply.SpectatorTarget = ply.SpectatorTarget + 1 end
				if !IsValid(ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget]) then return end
				
				ply:SpectateEntity(ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget])
			end
		else
			if key == IN_ATTACK then
				ply.SpectatorTarget = ply.SpectatorTarget + 1
				if ply.SpectatorTarget > #ytil_GetNonSpectatingPlayers() then ply.SpectatorTarget = 1 end
				
				if ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget] == ply then ply.SpectatorTarget = ply.SpectatorTarget + 1 end
				if !IsValid(ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget]) then return end
				
				ply:SpectateEntity(ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget])
			elseif key == IN_ATTACK2 then
				ply.SpectatorTarget = ply.SpectatorTarget - 1
				if ply.SpectatorTarget > #ytil_GetNonSpectatingPlayers() then ply.SpectatorTarget = #ytil_GetNonSpectatingPlayers() end
				
				if ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget] == ply then ply.SpectatorTarget = ply.SpectatorTarget - 1 end
				if !IsValid(ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget]) then return end
				
				ply:SpectateEntity(ytil_GetNonSpectatingPlayers()[ply.SpectatorTarget])
			elseif key == IN_JUMP then
				ply:SetObserverMode(OBS_MODE_ROAMING)
			end
		end
	end
end

concommand.Add("ytil_gametype", function(ply, cmd, args)
	if ply == NULL or ply:ytil_HasAdminPriviledges() then
		local mode = tonumber(args[1])
		if mode <= #ytil_GametypeRules and mode > 0 then
			RoundRestart(mode)
		else
			print("That mode does not exist!")
		end
	end
end)

function GM:CanPlayerSuicide(ply)
	if GetConVar("ytil_preventsuicide"):GetBool() then return false end
	return true
end

hook.Add("PlayerUse", "PreventSpectatorsFromInteracting", function(ply)
	if ply:Team() == 3 then return false end
end)
