--------------------------
---- Custom Lua Files ----
--------------------------
GM_Name = "flood"

GM_Path = GM_Name .. "/gamemode/custom/"

local function incl(file) include(GM_Path .. file) end

incl("pointshop2_build.lua")
incl("pointshop2_init.lua")
incl("ps2_kinv_init.lua")