DeriveGamemode("sandbox")

GM.Name 	= "Flood"
GM.Author 	= "Mythikos & Freezebug"
GM.Version  = "2.0.1"
GM.Website 	= "www.mapping-latam.cl"

GM.VIP = {
	["vip"] = true,
	["donator"] = true,
}

-- Include Shared files
for _, file in pairs (file.Find("flood/gamemode/shared/*.lua", "LUA")) do
   include("flood/gamemode/shared/"..file); 
end

TEAM_PLAYER = 2

team.SetUp(TEAM_PLAYER, "Player", Color(16, 153, 156))

-- Format coloring because garry likes vectors for playermodels
function GM:FormatColor(col)
	col = Color(col.r * 255, col.g * 255, col.b * 255)
	return col
end