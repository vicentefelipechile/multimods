-- Include everything
CreateConVar("flood_lang", "es", {FCVAR_ARCHIVE}, "Set the language of the gamemode")

FloodLang = {}

local PREFIX = "[Flood]"

local function mCL(str)
    MsgC( Color(255, 235, 56, 200), PREFIX, " ", Color(184, 246, 255, 200), tostring(str).."\n")
end

local function mSH(str)
    MsgC( Color(167, 255, 167, 200), PREFIX, " ", Color(184, 246, 255, 200), tostring(str).."\n")
end
 
print("-----------------------------------------")
print("------------ Flood Gamemode -------------")
print("-----------------------------------------")

MsgC( Color(56, 228, 255, 200), "\n - Loading Language Files - \n")
for _, file in pairs (file.Find("flood/gamemode/language/*lua", "LUA")) do
	mSH(file)
	include("flood/gamemode/language/"..file)
end

MsgC( Color(56, 228, 255, 200), "\n - Loading Shared Files - \n")
include("flood/gamemode/shared.lua") mSH("shared.lua")
for _, file in pairs (file.Find("flood/gamemode/shared/*.lua", "LUA")) do
	mSH(file)
	include("flood/gamemode/shared/"..file)
end

MsgC( Color(56, 228, 255, 200), "\n - Loading Clientside Files - \n")
for _, file in pairs (file.Find("flood/gamemode/client/*.lua", "LUA")) do
	mCL(file)
	include("flood/gamemode/client/"..file)
end

MsgC( Color(56, 228, 255, 200), "\n - Loading Clientside VGUI Files - \n")
for _, file in pairs (file.Find("flood/gamemode/client/vgui/*.lua", "LUA")) do
	mCL(file)
	include("flood/gamemode/client/vgui/"..file)
end

function GM:SpawnMenuOpen(ply)
	return false
end

function GM:ContextMenuOpen(ply)
	return false
end

function GM:CanProperty(ply, property, ent)
	return false
end