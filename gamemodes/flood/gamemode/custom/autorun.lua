--------------------------
---- Custom Lua Files ----
--------------------------
GM_Name = "flood"

GM_Path = GM_Name .. "/gamemode/custom/"

local function incl(file) include(GM_Path .. file) AddCSLuaFile(GM_Path .. file) end