local MetaPlayer = FindMetaTable("Player")
local EntityMeta = FindMetaTable("Entity")

local q = sql.Query
local qS = sql.SQLStr
local TTJ = util.TableToJSON
local JTT = util.JSONToTable


local Donators = { 
	["vip"] = true,
	["admin"] = true,
	["superadmin"] = true,
}

function MetaPlayer:IsDonator()
	return Donators[self:GetUserGroup()] or false
end

-- Player Scores
function MetaPlayer:GetScore()
	return self:GetNWInt("flood_score") or 0
end

function MetaPlayer:SetScore(score)
	self:SetNWInt("flood_score", score)
end

-- Player Color
function EntityMeta:GetPlayerColor()
	return self:GetNWVector("playerColor") or Vector()
end

function EntityMeta:SetPlayerColor(vec)
	self:SetNWVector("playerColor", vec)
end

-- Can Respawn
function MetaPlayer:CanRespawn()
	return self:GetNWBool("flood_canrespawn")
end

function MetaPlayer:SetCanRespawn(bool)
	self:SetNWBool("flood_canrespawn", bool)
end

-- Currency 
function MetaPlayer:AddCash(amount)
	if amount then
		self:SetNWInt("flood_cash", self:GetNWInt("flood_cash") + tonumber(amount))
		self:Save()
	else
		print("Flood: Error occured in AddCash function - No amount was passed.")
		return
	end
end

function MetaPlayer:SubCash(amount)
	if amount then 
		self:SetNWInt("flood_cash", self:GetNWInt("flood_cash") - tonumber(amount))
		self:Save()
	else
		print("Flood: Error occured in SubCash function - No amount was passed.")
		return
	end
end

function MetaPlayer:SetCash(amount)
	self:SetNWInt("flood_cash", tonumber(amount))
end

function MetaPlayer:GetCash()
	return tonumber(self:GetNWInt("flood_cash"))
end

function MetaPlayer:CanAfford(price)
	return tonumber(self:GetNWInt("flood_cash")) >= tonumber(price)
end

function MetaPlayer:Save()
	q("UPDATE flood SET cash = " .. self:GetNWInt("flood_cash") .. " WHERE steamid = " .. self:SteamID64() .. ";")
end

function MetaPlayer:SaveWeapons()
	
	if not self.Weapons then
		self.Weapons = {}
		table.insert(self.Weapons, "weapon_pistol")
	end

	q("UPDATE flood SET weapons = " .. qS(TTJ(self.Weapons)) .. " WHERE steamid = " .. self:SteamID64() .. ";")
end