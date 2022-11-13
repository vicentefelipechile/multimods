local plymeta = FindMetaTable("Player")

-- Handy function just for you, use to check if player is in steam group
function plymeta:IsInSteamGroup( id )
	http.Fetch( "http://steamcommunity.com/groups/"..id.."/memberslistxml/?xml=1",
		function(body) -- On Success
			local playerIDStartIndex = string.find( tostring(body), "<steamID64>"..ply:SteamID64().."</steamID64>" )
			if playerIDStartIndex == nil then return false else
				return true
			end
		end,
		function() -- On fail
			print("Couldn't get it the data from the Steam Group with the id: "..id.."!")
			return false
		end
	)
end

ytil_BallList = {
	[1] = {
		name = "Bouncy Ball",
		condition = function(ply)
			return true -- Always unlocked
		end,
		texture = Material( "sprites/sent_ball" ), 
		sound = Sound( "garrysmod/balloon_pop_cute.wav" ), 
		offsetX = -4, 
		offsetY = 1,
		killSound = nil,
		effect = "ball_explosion_main",
		explosionsound = "youtoucheditlast/ball_explosion.wav",
		delay = 0,
		shakedur = 2,
		shakeamp = 20,
		shakefreq = 5
	},
	[2] = {	-- This ball is made to be exclusively for OUR steam group and I kindly ask of you that you do not reuse its texture and sounds in your own balls, thank you :)
		name = "Pixel",
		condition = function(ply)
			return ply.inYTLGroup -- Do NOT change the condition of this ball!
		end,
		texture = Material( "youtoucheditlast/ytil_ball_pixel" ), 
		sound = Sound( "youtoucheditlast/ball_pixel_bounce.wav" ), 
		offsetX = -4.5, 
		offsetY = 1,
		killSound = Sound("youtoucheditlast/pixelkill.wav"),
		effect = "ball_explosion_main",
		explosionsound = "youtoucheditlast/ball_explosion.wav",
		delay = 0,
		shakedur = 2,
		shakeamp = 20,
		shakefreq = 5
	},
	
	[3] = {	-- This ball is made to be exclusive and I kindly ask of you that you do not reuse ANY of its resources in your own balls, thank you :)
		name = "Black Hole",
		condition = function(ply)
			return ytil_specialrewards[ply:SteamID()] -- Do NOT change the condition of this ball!
		end,
		texture = Material( "youtoucheditlast/blackholeball" ), 
		sound = Sound( "youtoucheditlast/balloon_pop_reverse.wav" ), 
		offsetX = -0.5, 
		offsetY = 1,
		killSound = Sound("youtoucheditlast/blackholekill.wav"),
		effect = "blackhole_main",
		explosionsound = "youtoucheditlast/ball_explosion_blackhole.wav",
		delay = 1,
		shakedur = 5,
		shakeamp = 50,
		shakefreq = 5
	}
}


ytil_CycleOrder = {
	{mode = 2, rounds = 5, bomb = false, bombmintime = 60, bombmaxtime = 120},
	{mode = 3, rounds = 2, bomb = false},
	{mode = 4, rounds = 4, bomb = false},
	{mode = 5, rounds = 2, bomb = true, bombmintime = 180, bombmaxtime = 300},
	{mode = 6, rounds = 3, bomb = true},  -- Has same bomb time as last set
	{mode = 7, rounds = 3, bomb = true}
}

-- Here is the admin check used in the gamemode. Add your own checks to here
function plymeta:ytil_HasAdminPriviledges()
	if self:IsSuperAdmin() then return true end
	--if self:IsAdmin() then return true end
	
	return false
end