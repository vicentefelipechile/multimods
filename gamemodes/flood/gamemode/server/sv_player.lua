local PlayerMeta = FindMetaTable("Player")

local q = sql.Query
local qS = sql.SQLStr

local function L(val)
	return FloodLang[GetConVar("flood_lang"):GetString()][val] or FloodLang["es"][val]
end


--[[----------------------------------------------------
                \/ Weapons Database \/
----------------------------------------------------]]--

local BLACKLIST_WPN = {
    ["flood_propseller"] = true,
    ["manhack_welder"] = true,
}

function GM:WeaponExists(str)
	if !str then
		error("bad argument #1 to 'GM:WeaponExists' (string expected, got )" .. type(str) .. ")")
	elseif #str == 0 then
		error("bad argument #1 to 'GM:WeaponExists' (string cannot be empty)")
	end

	return weapons.Get(str) and true or false
end


function GM:CreateWeaponsDatabase()

	if not sql.TableExists("flood_weapons") then
		sql.Query([[ CREATE TABLE IF NOT EXISTS flood_weapons ( class_id INTEGER PRIMARY KEY AUTOINCREMENT, class TEXT PRIMARY KEY ) ]])
	end

    for k, v in ipairs( weapons.GetList() ) do

        local class = v["ClassName"]
        if BLACKLIST_WPN[class] then continue end

        sql.Query( string.format("INSER INTO flood_weapons ( classname ) VALUES ( %s )", class) )

    end

	if not sql.TableExists("flood_weapons_players") then
		sql.Query([[
			CREATE TABLE IF NOT EXISTS flood_weapons_players (
				steam_id TEXT NOT NULL,
				class_id TEXT NOT NULL,
				FOREIGN KEY (steam_id) REFERENCES flood(steamid),
				FOREIGN KEY (class_id) REFERENCES flood_weapons(class_id),
				PRIMARY KEY (steam_id, class_id)
			)
		]])
	end
end


function GM:ResetWeaponsDatabase()
    if sql.TableExists("flood_weapons") or sql.TableExists("flood_weapons") then
        sql.Query("DROP TABLE IF EXISTS flood_weapons")
        sql.Query("DROP TABLE IF EXISTS flood_weapons_players")
    end

    self:CreateWeaponsDatabase()
end

function GM:GetPlayerWeapons(ply)
    local wpns = sql.Query( string.format([[
        SELECT flood.steamid, flood_weapons.class AS class
        FROM flood
        LEFT JOIN flood_weapons_players ON flood_weapons_players.steam_id = flood.steamid
        LEFT JOIN class ON flood_weapons_players.class_id = flood_weapons.class_id
        WHERE flood.steamid = "%s"
    ]], ply:SteamID()))
end


--[[----------------------------------------------------
                /\  Weapons Database  /\
----------------------------------------------------]]--


function GM:PlayerInitialSpawn(ply)

	ply.Allow = false
	ply.Weapons = {}

	local query = sql.Query( string.format([[SELECT * FROM flood WHERE steamid = "%s"]]), ply:SteamID() )
	if not query then
        sql.Query( string.format([[INSERT INTO flood ( steamid, name ) VALUES ( "%s", "%s" )]], ply:SteamID(), ply:Nick()) )
	else
        sql.Query( string.format([[UPDATE flood SET name = "%s" WHERE steamid = "%s"]], ply:Nick(), ply:SteamID()) )
	end
 
	local data = ply:LoadData()

	ply:SetNWInt("flood_cash", data["cash"])
	ply.Weapons = data["weapons"]
	
	ply:SetTeam(TEAM_PLAYER)

	local col = team.GetColor(TEAM_PLAYER)
	ply:SetPlayerColor(Vector(col.r / 255, col.g / 255, col.b / 255))

	if self:GetGameState() >= 2 then
		timer.Simple(0, function ()
			if IsValid(ply) then
				ply:KillSilent()
				ply:SetCanRespawn(false)
			end
		end)
	end
	ply.SpawnTime = CurTime()
	
	PrintMessage(HUD_PRINTCENTER, ply:Nick().." ha entrado al servidor!")
end

function GM:PlayerSpawn( ply )
	hook.Call( "PlayerLoadout", GAMEMODE, ply )
	hook.Call( "PlayerSetModel", GAMEMODE, ply )
	ply:UnSpectate()
	ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
 	ply:SetPlayerColor(ply:GetPlayerColor())
end

function GM:ForcePlayerSpawn()
	for _, ply in pairs(player.GetAll()) do
		if ply:CanRespawn() then
			if ply.NextSpawnTime && ply.NextSpawnTime > CurTime() then return end
			if not ply:Alive() and IsValid(ply) then
				ply:Spawn()	
			end
		end
	end
end

function GM:PlayerLoadout(ply)
	ply:Give("gmod_tool")
	ply:Give("weapon_physgun")
	ply:Give("flood_propseller")

	ply:SelectWeapon("weapon_physgun")
end

function GM:PlayerSetModel(ply)
	ply:SetModel("models/player/Group03/Male_06.mdl")
end

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerDeathThink(ply)
end

------------------------------
------- Shit Prevention ------
------------------------------

function GM:PlayerSpawnProp(ply, model)
	local state = self:GetGameState()

	if state == ( 2 or 3 or 4 ) then
		return ply:IsSuperAdmin()
	end

end

function GM:PlayerSpawnEffect(ply)
	return ply:IsSuperAdmin()
end

function GM:PlayerSpawnNPC(ply)
	return ply:IsSuperAdmin()
end

function GM:PlayerSpawnRagdoll(ply)
	return ply:IsSuperAdmin()
end

function GM:PlayerSpawnSENT(ply)
	return ply:IsSuperAdmin()
end

function GM:PlayerSpawnSWEP(ply)
	return ply:IsSuperAdmin()
end

function GM:PlayerSpawnVehicle(ply)
	return false
end



function GM:PlayerDeath(ply, inflictor, attacker )
	ply.NextSpawnTime = CurTime() + 5
	ply.SpectateTime = CurTime() + 2

	if IsValid(inflictor) && inflictor == attacker && (inflictor:IsPlayer() || inflictor:IsNPC()) then
		inflictor = inflictor:GetActiveWeapon()
		if !IsValid(inflictor) then inflictor = attacker end
	end

	-- Don't spawn for at least 2 seconds
	ply.NextSpawnTime = CurTime() + 2
	ply.DeathTime = CurTime()
	
	if ( IsValid( attacker ) && attacker:GetClass() == "trigger_hurt" ) then attacker = ply end
	
	if ( IsValid( attacker ) && attacker:IsVehicle() && IsValid( attacker:GetDriver() ) ) then
		attacker = attacker:GetDriver()
	end

	if ( !IsValid( inflictor ) && IsValid( attacker ) ) then
		inflictor = attacker
	end

	-- Convert the inflictor to the weapon that they're holding if we can.
	-- This can be right or wrong with NPCs since combine can be holding a 
	-- pistol but kill you by hitting you with their arm.
	if ( IsValid( inflictor ) && inflictor == attacker && ( inflictor:IsPlayer() || inflictor:IsNPC() ) ) then
	
		inflictor = inflictor:GetActiveWeapon()
		if ( !IsValid( inflictor ) ) then inflictor = attacker end

	end

	if ( attacker == ply ) then
	
		net.Start( "PlayerKilledSelf" )
			net.WriteEntity( ply )
		net.Broadcast()
		
		MsgAll( attacker:Nick() .. " suicided!\n" )
		
	return end

	if ( attacker:IsPlayer() ) then
	
		net.Start( "PlayerKilledByPlayer" )
		
			net.WriteEntity( ply )
			net.WriteString( inflictor:GetClass() )
			net.WriteEntity( attacker )
		
		net.Broadcast()
		
		MsgAll( attacker:Nick() .. " killed " .. ply:Nick() .. " using " .. inflictor:GetClass() .. "\n" )
		
	return end
	
	net.Start( "PlayerKilled" )
	
		net.WriteEntity( ply )
		net.WriteString( inflictor:GetClass() )
		net.WriteString( attacker:GetClass() )

	net.Broadcast()
	
	MsgAll( ply:Nick() .. " was killed by " .. attacker:GetClass() .. "\n" )
	
end

function GM:PlayerSwitchWeapon(ply, oldwep, newwep)
end

function GM:PlayerSwitchFlashlight(ply)
	return true
end

function GM:PlayerShouldTaunt( ply, actid )
	return false
end

function GM:CanPlayerSuicide(ply)
	return false
end

-----------------------------------------------------------------------------------------------
----                                 Give the player their weapons                         ----
-----------------------------------------------------------------------------------------------
function GM:GivePlayerWeapons()
	for _, v in pairs(self:GetActivePlayers()) do
		-- Because the player always needs a pistol
		v:Give("weapon_pistol")
		timer.Simple(0, function() 
			v:GiveAmmo(9999, "Pistol") 
		end)


		if v.Weapons and Weapons then
			for __, pWeapon in pairs(v.Weapons) do
				for ___, Weapon in pairs(Weapons) do
					if pWeapon == Weapon.Class then
						v:Give(Weapon.Class)
						timer.Simple(0, function() 
							v:GiveAmmo(Weapon.Ammo, Weapon.AmmoClass)
						end)
					end
				end
			end
		end
	end
end

-----------------------------------------------------------------------------------------------
----                                 Player Data Loading                                   ----
-----------------------------------------------------------------------------------------------
function PlayerMeta:LoadData()
	local data = {}

	local query = q("SELECT * FROM flood WHERE steamid = " .. self:SteamID() .. ";")

	if query then
		data = q("SELECT * FROM flood WHERE steamid = " .. self:SteamID() .. ";")[1]
		self.Allow = true
		return data
	else
		self:Save()
		data = q("SELECT * FROM flood WHERE steamid = " .. self:SteamID() .. ";")[1]

		data["cash"] = 5000

		self:Save()
		self.Allow = true
		return data
	end

end

function PlayerLeft(ply)
	ply:Save()
end
hook.Add("PlayerDisconnected", "PlayerDisconnect", PlayerLeft)

function ServerDown()
	for k, v in pairs(player.GetAll()) do
		v:Save()
	end
end
hook.Add("ShutDown", "ServerShutDown", ServerDown)

-----------------------------------------------------------------------------------------------
----                                 Prop/Weapon Purchasing                                ----
-----------------------------------------------------------------------------------------------
function GM:PurchaseProp(ply, cmd, args)
	if not ply.PropSpawnDelay then ply.PropSpawnDelay = 0 end
	if not IsValid(ply) or not args[1] then return end
	
	local Prop = Props[math.floor(args[1])]
	local tr = util.TraceLine(util.GetPlayerTrace(ply))
	local ct = ChatText()

	if ply.Allow and Prop and self:GetGameState() <= 1 then
		if Prop.DonatorOnly and not ply:IsDonator() then 
			ct:AddText(L"cmd.prefix", Color(158, 49, 49, 255))
			ct:AddText(Prop.Description.." is a donator only item!")
			ct:Send(ply)
			return 
		else
			if ply.PropSpawnDelay <= CurTime() then
				
				-- Checking to see if they can even spawn props.
				if ply:IsAdmin() then
					if ply:GetCount("flood_props") >= GetConVar("flood_max_admin_props"):GetInt() then
						ct:AddText(L"cmd.prefix", Color(158, 49, 49, 255))
						ct:AddText(L"buy.max1" .. L"buy.admin" .. L"buy.max2")
						ct:Send(ply)
						return
					end 
				elseif ply:IsDonator() then
					if ply:GetCount("flood_props") >= GetConVar("flood_max_donator_props"):GetInt() then
						ct:AddText(L"cmd.prefix", Color(158, 49, 49, 255))
						ct:AddText(L"buy.max1" .. L"buy.donator" .. L"buy.max2")
						ct:Send(ply)
						return
					end
				else
					if ply:GetCount("flood_props") >= GetConVar("flood_max_player_props"):GetInt() then 
						ct:AddText(L"cmd.prefix", Color(158, 49, 49, 255))
						ct:AddText(L"buy.max1" .. L"buy.player" .. L"buy.max2")
						ct:Send(ply)
						return
					end
				end

				if ply:CanAfford(Prop.Price) then
					ply:SubCash(Prop.Price)

					local ent = ents.Create("prop_physics")
					ent:SetModel(Prop.Model)
					ent:SetPos(tr.HitPos + Vector(0, 0, (ent:OBBCenter():Distance(ent:OBBMins()) + 5)))
					ent:CPPISetOwner(ply)
					ent:Spawn()
					ent:Activate()
					ent:SetHealth(Prop.Health)
					ent:SetNWInt("CurrentPropHealth", math.floor(Prop.Health))
					ent:SetNWInt("BasePropHealth", math.floor(Prop.Health))

					ct:AddText(L"cmd.prefix", Color(132, 199, 29, 255))
					ct:AddText(L"buy.success" .. Prop.Description)
					ct:Send(ply)
						
					hook.Call("PlayerSpawnedProp", gmod.GetGamemode(), ply, ent:GetModel(), ent)
					ply:AddCount("flood_props", ent)
				else
					ct:AddText(L"cmd.prefix", Color(158, 49, 49, 255))
					ct:AddText(L"buy.no_money" .. Prop["Description"])
					ct:Send(ply)
				end
			else
				ct:AddText(L"cmd.prefix", Color(158, 49, 49, 255))
				ct:AddText(L"buy.no_fast")
				ct:Send(ply)
			end
			ply.PropSpawnDelay = CurTime() + 0.25
		end
	else
		ct:AddText(L"cmd.prefix", Color(158, 49, 49, 255))
		ct:AddText(L"buy.not_now1" .. Prop["Description"] .. L"buy.not_now2")
		ct:Send(ply)
	end
end
concommand.Add("FloodPurchaseProp", function(ply, cmd, args)
	hook.Call("PurchaseProp", GAMEMODE, ply, cmd, args)
end)

function GM:PurchaseWeapon(ply, cmd, args)
	if not ply.PropSpawnDelay then ply.PropSpawnDelay = 0 end
	if not IsValid(ply) or not args[1] then return end
	
	local Weapon = Weapons[math.floor(args[1])]
	local ct = ChatText()

	if ply.Allow and Weapon and self:GetGameState() <= 1 then
		if table.HasValue(ply.Weapons, Weapon.Class) then
			ct:AddText(L"cmd.prefix", Color(158, 49, 49, 255))
			ct:AddText(L"buy.already" .. Weapon.Name)
			ct:Send(ply)
			return
		else
			if Weapon.DonatorOnly == true and not ply:IsDonator() then 
				ct:AddText(L"cmd.prefix", Color(158, 49, 49, 255))
				ct:AddText(Weapon.Name .. L"buy.only_donator")
				ct:Send(ply)
				return 
			else
				if ply:CanAfford(Weapon.Price) then
					ply:SubCash(Weapon.Price)
					table.insert(ply.Weapons, Weapon.Class)
					ply:Save()
					ply:SaveWeapons()

					ct:AddText(L"cmd.prefix", Color(132, 199, 29, 255))
					ct:AddText(L"buy.success"..Weapon.Name..".")
					ct:Send(ply)
				else
					ct:AddText(L"cmd.prefix", Color(158, 49, 49, 255))
					ct:AddText(L"buy.no_money"..Weapon.Name..".")
					ct:Send(ply)
				end
			end
		end
	else
		ct:AddText(L"cmd.prefix", Color(158, 49, 49, 255))
		ct:AddText(L"buy.not_now1" .. Weapon.Name .. L"buy.not_now2")
		ct:Send(ply)
	end
end
concommand.Add("FloodPurchaseWeapon", function(ply, cmd, args)
	hook.Call("PurchaseWeapon", GAMEMODE, ply, cmd, args)
end)