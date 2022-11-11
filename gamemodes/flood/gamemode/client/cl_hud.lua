surface.CreateFont( "Flood_HUD_Small", {
	 font = "Tahoma",
	 size = 14,
	 weight = 500,
	 antialias = true
})

surface.CreateFont( "Flood_HUD", {
	 font = "Tahoma",
	 size = 16,
	 weight = 500,
	 antialias = true
})

surface.CreateFont( "Flood_HUD_Large", {
	 font = "Tahoma",
	 size = 30,
	 weight = 500,
	 antialias = true
})

surface.CreateFont( "Flood_HUD_B", {
	 font = "Tahoma",
	 size = 18,
	 weight = 600,
	 antialias = true
})

------------------------------
------- Alias Functions ------
------------------------------
local SE = draw.SimpleText
local RB = draw.RoundedBox
local RBE = draw.RoundedBoxEx



local lang = {
	["state0"] = "Waiting for players",
	["state1"] = "Build a boat.",
	["state2"] = "Get on your boat!",
	["state3"] = "Destroy enemy boats!",
	["state4"] = "Restarting the round.",
}

------------------------------
-------- Hud Settings --------
------------------------------
local color_grey = Color(120, 120, 120, 100)
local color_black = Color(0, 0, 0, 200)
local active_color = Color(24, 24, 24, 255)
local outline_color = Color(0, 0, 0, 255)
local x = ScrW()
local y = ScrH()


------------------------------
-------- Hud Position --------
------------------------------

local Spacer = y * 0.006
local xSize = x * 0.2
local ySize = y * 0.04
local bWidth = Spacer + xSize + Spacer
local bHeight = Spacer + ySize + Spacer

------------------------------
------- Timer Settings -------
------------------------------
local GameState = 0
local BuildTimer = -1
local FloodTimer = -1
local FightTimer = -1
local ResetTimer = -1

local xPos = x * 0.0025
local yPos = y * 0.005



net.Receive("RoundState", function(len)
	GameState = net.ReadFloat()
	BuildTimer = net.ReadFloat()
	FloodTimer = net.ReadFloat()
	FightTimer = net.ReadFloat()
	ResetTimer = net.ReadFloat()
end)

function GM:HUDPaint()

	if BuildTimer and FloodTimer and FightTimer and ResetTimer then
		if GameState == 0 then
			RBE(6, xPos, y * 0.005, x * 0.175,  x * 0.018, active_color, true, true, false, false)
			
			SE(lang["state0"], "Flood_HUD", x * 0.01, y * 0.01, color_white, 0, 0)
			SE(lang["state1"], "Flood_HUD", x * 0.01, y * 0.044, color_grey, 0, 0)
			SE(lang["state2"], "Flood_HUD", x * 0.01, y * 0.078, color_grey, 0, 0)
			SE(lang["state3"], "Flood_HUD", x * 0.01, y * 0.115, color_grey, 0, 0)
			SE(lang["state4"], "Flood_HUD", x * 0.01, y * 0.151, color_grey, 0, 0)
		else
			RBE(6, xPos, y * 0.005, x * 0.175,  x * 0.018, color_grey, true, true, false, false)
		end
		
		if GameState == 1 then
			RB(0, xPos, yPos + (Spacer * 6), x * 0.175,  x * 0.018, active_color)
			SE(BuildTimer, "Flood_HUD", x * 0.15, y * 0.044, color_white, 0, 0)

			SE(lang["state0"], "Flood_HUD", x * 0.01, y * 0.01, color_grey, 0, 0)
			SE(lang["state1"], "Flood_HUD", x * 0.01, y * 0.044, color_white, 0, 0)
			SE(lang["state2"], "Flood_HUD", x * 0.01, y * 0.078, color_grey, 0, 0)
			SE(lang["state3"], "Flood_HUD", x * 0.01, y * 0.115, color_grey, 0, 0)
			SE(lang["state4"], "Flood_HUD", x * 0.01, y * 0.151, color_grey, 0, 0)
		else
			RB(0, xPos, yPos + (Spacer * 6), x * 0.175,  x * 0.018, color_grey)
			SE(BuildTimer, "Flood_HUD", x * 0.15, y * 0.044, color_grey, 0, 0)
		end

		if GameState == 2 then
			RB(0, xPos, yPos + (Spacer * 12), x * 0.175,  x * 0.018, active_color)
			SE(FloodTimer, "Flood_HUD", x * 0.15, y * 0.078, color_white, 0, 0)

			SE(lang["state0"], "Flood_HUD", x * 0.01, y * 0.01, color_grey, 0, 0)
			SE(lang["state1"], "Flood_HUD", x * 0.01, y * 0.044, color_grey, 0, 0)
			SE(lang["state2"], "Flood_HUD", x * 0.01, y * 0.078, color_white, 0, 0)
			SE(lang["state3"], "Flood_HUD", x * 0.01, y * 0.115, color_grey, 0, 0)
			SE(lang["state4"], "Flood_HUD", x * 0.01, y * 0.151, color_grey, 0, 0)
		else
			RB(0, xPos, yPos + (Spacer * 12), x * 0.175,  x * 0.018, color_grey)
			SE(FloodTimer, "Flood_HUD", x * 0.15, y * 0.078, color_grey, 0, 0)
		end
		
		if GameState == 3 then
			RB(0, xPos, yPos + (Spacer * 18), x * 0.175,  x * 0.018, active_color)

			SE(FightTimer, "Flood_HUD", x * 0.15, y * 0.115, color_white, 0, 0)
			SE(lang["state0"], "Flood_HUD", x * 0.01, y * 0.01, color_grey, 0, 0)
			SE(lang["state1"], "Flood_HUD", x * 0.01, y * 0.044, color_grey, 0, 0)
			SE(lang["state2"], "Flood_HUD", x * 0.01, y * 0.078, color_grey, 0, 0)
			SE(lang["state3"], "Flood_HUD", x * 0.01, y * 0.115, color_white, 0, 0)
			SE(lang["state4"], "Flood_HUD", x * 0.01, y * 0.151, color_grey, 0, 0)
		else
			RB(0, xPos, yPos + (Spacer * 18), x * 0.175,  x * 0.018, color_grey)
			SE(FightTimer, "Flood_HUD", x * 0.15, y * 0.115, color_grey, 0, 0)
		end

		if GameState == 4 then
			RBE(6, xPos, yPos + (Spacer * 24), x * 0.175,  x * 0.018, active_color, false, false, true, true)
			
			SE(ResetTimer, "Flood_HUD", x * 0.15, y * 0.151, color_white, 0, 0)
			SE(lang["state0"], "Flood_HUD", x * 0.01, y * 0.01, color_grey, 0, 0)
			SE(lang["state1"], "Flood_HUD", x * 0.01, y * 0.044, color_grey, 0, 0)
			SE(lang["state2"], "Flood_HUD", x * 0.01, y * 0.078, color_grey, 0, 0)
			SE(lang["state3"], "Flood_HUD", x * 0.01, y * 0.115, color_grey, 0, 0)
			SE(lang["state4"], "Flood_HUD", x * 0.01, y * 0.151, color_white, 0, 0)
		else
			RBE(6,xPos, yPos + (Spacer * 24), x * 0.175,  x * 0.018, color_grey, false, false, true, true)
			SE(ResetTimer, "Flood_HUD", x * 0.15, y * 0.151, color_grey, 0, 0)
		end
	end

	-- Display Prop's Health
	local tr = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))
	if tr.Entity:IsValid() and not tr.Entity:IsPlayer() then
		if tr.Entity:GetNWInt("CurrentPropHealth") == "" or tr.Entity:GetNWInt("CurrentPropHealth") == nil or tr.Entity:GetNWInt("CurrentPropHealth") == NULL then
			SE("Fetching Health", "Flood_HUD_Small", x * 0.5, y * 0.5 - 25, color_white, 1, 1)
		else
			SE("Health: " .. tr.Entity:GetNWInt("CurrentPropHealth"), "Flood_HUD_Small", x * 0.5, y * 0.5 - 25, color_white, 1, 1)
		end
	end

	-- Display Player's Health and Name
	if tr.Entity:IsValid() and tr.Entity:IsPlayer() then
		SE("Name: " .. tr.Entity:GetName(), "Flood_HUD_Small", x * 0.5, y * 0.5 - 75, color_white, 1, 1)
		SE("Health: " .. tr.Entity:Health(), "Flood_HUD_Small", x * 0.5, y * 0.5 - 60, color_white, 1, 1)
	end

	-- Bottom left HUD Stuff
	if LocalPlayer():Alive() and IsValid(LocalPlayer()) then
		RB(6, 4, y - ySize - Spacer - (bHeight * 2), bWidth, bHeight * 2 + ySize, Color(24, 24, 24, 255))
		
		-- Health
		local pHealth = LocalPlayer():Health()
		local pHealthClamp = math.Clamp(pHealth / 100, 0, 1)
		local pHealthWidth = (xSize - Spacer) * pHealthClamp

		RBE(6, Spacer * 2, y - (Spacer * 4) - (ySize * 3), Spacer + pHealthWidth, ySize, Color(128, 28, 28, 255), true, true, false, false)
		SE(math.Max(pHealth, 0).." HP","Flood_HUD_B", xSize * 0.5 + (Spacer * 2), y - (ySize * 2.5) - (Spacer * 4), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
		-- Ammo
		if IsValid(LocalPlayer():GetActiveWeapon()) then
			if LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) > 0 or LocalPlayer():GetActiveWeapon():Clip1() > 0 then
				local wBulletCount = (LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) + LocalPlayer():GetActiveWeapon():Clip1()) + 1
				local wBulletClamp = math.Clamp(wBulletCount / 100, 0, 1)
				local wBulletWidth = (xSize - bWidth) * wBulletClamp

				RB(0, Spacer * 2, y - (ySize * 2) - (Spacer * 3), bWidth + wBulletWidth, ySize, Color(30, 105, 105, 255))
				SE(wBulletCount.." Bullets", "Flood_HUD_B", xSize * 0.5 + (Spacer * 2), y - ySize - (ySize * 0.5) - (Spacer * 3), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				RB(0, Spacer * 2, y - (ySize * 2) - (Spacer * 3), xSize, ySize, Color(30, 105, 105, 255))
				SE("Doesn't Use Ammo", "Flood_HUD_B", xSize * 0.5 + (Spacer * 2), y - ySize - (ySize * 0.5) - (Spacer * 3), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		else
			RB(0, Spacer * 2, y - (ySize * 2) - (Spacer * 3), xSize, ySize, Color(30, 105, 105, 255))
			SE("No Ammo", "Flood_HUD_B", xSize * 0.5 + (Spacer * 2), y - ySize - (ySize * 0.5) - (Spacer * 3), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		-- Cash
		local pCash = LocalPlayer():GetNWInt("flood_cash") or 0
		local pCashClamp = math.Clamp(pCash / 5000, 0, xSize)

		RBE(6, Spacer * 2, y - ySize - (Spacer * 2), xSize, ySize, Color(63, 140, 64, 255), false, false, true, true)
		SE("$"..pCash, "Flood_HUD_B", (xSize * 0.5) + (Spacer * 2), y - (ySize * 0.5) - (Spacer * 2), WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function hidehud(name)
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do 
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "hidehud", hidehud) 