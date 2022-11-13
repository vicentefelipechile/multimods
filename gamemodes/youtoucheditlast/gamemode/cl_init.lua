Msg("Cl_init.lua loads!")

include( "gametypes.lua" )
include( "shared.lua" )
include("player.lua")
include("cl_scoreboard.lua")
include("ytil_playerclass.lua")
include( "customizeserver.lua" )

game.AddParticles("particles/ball_explosion.pcf")
game.AddParticles("particles/blackholeball_explosion.pcf")

local ManualBombTexture = Material("youtoucheditlast/manualbomb.png")
local ManualBombEnable = false

function CheckGametype(mode, bomb)
	if mode then 
		ytil_Variables.gametype = mode 
		print("Gametype set to "..ytil_Variables.gametype)
	else
		ytil_Variables.gametype = GetGlobalInt("ytil_Gametype", false) or 1
		print("Gametype set to "..ytil_Variables.gametype)
	end
	
	if bomb then 
		ManualBombEnable = tobool(bomb)
	else
		ManualBombEnable = GetGlobalBool("ytil_ManualBombEnable", false)
	end
end



surface.CreateFont( "BombTime", {
	font = "Coolvetica",
	size = 50,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "GTitle", {
	font = "Coolvetica",
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "Promo", {
	font = "Coolvetica",
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "Promo2", {
	font = "Trebuchet MS",
	size = 18,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "Promo3", {
	font = "Trebuchet MS",
	size = 18,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )




function hidehud(name)
	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudWeaponSelection"}) do
		if name == "CHudCrosshair" then return true end
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "HideTheHud", hidehud)


net.Receive("BombTime", function() 
	ytil_Variables.bombTime = CurTime() + net.ReadInt(10)
end)

local voted = 0
local nextVote = 0

ytil_ballTeleCharge = 0

function ShowGametypePopup(admin)

		for k,v in pairs(player.GetAll()) do
			if !v.datatablesup then player_manager.RunClass( v, "SetupDataTables" ) end
		end

	local selected = voted
	
	local Frame = vgui.Create("DFrame")
	Frame:SetPos(5,5)
	Frame:SetSize( #ytil_GametypeRules * 110 + 200, admin and 370 or 330 )
	Frame:SetTitle( admin and "Admin Panel" or "Control Panel" )
	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:ShowCloseButton( true )
	Frame:MakePopup()
	
	local gTitle = vgui.Create( "DLabel", Frame )
	gTitle:SetPos( 50, 170 )
	gTitle:SetFont( "GTitle" )
	gTitle:SetText( ytil_GametypeRules[selected].name )
	gTitle:SetWrap( false )
	gTitle:SizeToContents()
	
	local gDesc = vgui.Create( "DLabel", Frame )
	gDesc:SetPos( 50, 190 )
	gDesc:SetSize( Frame:GetWide() - 250, 1)
	gDesc:SetText( ytil_GametypeRules[selected].desc )
	gDesc:SetWrap( true )
	gDesc:SetAutoStretchVertical(true)
	
	for k,v in pairs(ytil_GametypeRules) do
		if k != 0 then
			local Button = vgui.Create( "DButton", Frame )
			Button:SetTextColor( Color( 255, 255, 255 ) )
			Button:SetPos( 10 + 110 * (k-1), 50 )
			Button:SetSize( 100, 100 )
			Button:SetText("")
			Button.Paint = function( self, w, h )
				if selected == k then
					draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) )
				else
					draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200, 250 ) )
				end
				surface.SetDrawColor( 200, 200, 200 )
				self:DrawOutlinedRect() 
			end
			Button.DoClick = function()
				if selected == k then
					selected = 0
				else
					selected = k
				end
				gTitle:SetText( ytil_GametypeRules[selected].name )
				gDesc:SetText( ytil_GametypeRules[selected].desc )
			end
			
			local Texture = vgui.Create( "DImage", Button )
			Texture:SetImage( v.texture:GetName()..".png" )
			Texture:SetSize(100, 100)
		end
	end
	
	if admin then
		local Restart = vgui.Create( "DButton", Frame )
		Restart:SetText("Restart Round")
		Restart:SetSize(200, 30)
		Restart:SetPos(cvars.Bool("ytil_voteallowed", false) and Frame:GetWide()/2 - 170 or Frame:GetWide()/2 - 70, Frame:GetTall() - 40)
		Restart.DoClick = function()
			print("Sent request to restart round with mode "..selected)
			if selected == 0 or selected > #ytil_GametypeRules or selected == ytil_Variables.gametype then
				net.Start("RoundRestart")
					net.WriteInt(0, 4)
				net.SendToServer()
			else
				net.Start("RoundRestart")
					net.WriteInt(selected, 4)
				net.SendToServer()
			end
			selected = 0
		end
		
		local tShowBombTime = vgui.Create("DLabel", Frame)
		tShowBombTime:SetPos(50, Frame:GetTall() - 110)
		tShowBombTime:SetText("Show Bomb Time on HUD?")
		tShowBombTime:SizeToContents()
		local cShowBombTime = vgui.Create("DCheckBox", Frame)
		cShowBombTime:SetPos(30, Frame:GetTall() - 110)
		cShowBombTime:SetValue(cvars.Bool("ytil_bombshowtime"))
		function cShowBombTime:OnChange(bool)
			net.Start("ShowBombTime")
				net.WriteBit(bool)
			net.SendToServer()
		end
		
		local tRunnerMagic = vgui.Create("DLabel", Frame)
		tRunnerMagic:SetPos(220, Frame:GetTall() - 110)
		tRunnerMagic:SetText("Allow Runners to use Magic?")
		tRunnerMagic:SizeToContents()
		local cRunnerMagic = vgui.Create("DCheckBox", Frame)
		cRunnerMagic:SetPos(200, Frame:GetTall() - 110)
		cRunnerMagic:SetValue(cvars.Bool("ytil_runnermagic"))
		function cRunnerMagic:OnChange(bool)
			net.Start("RunnerMagic")
				net.WriteBit(bool)
			net.SendToServer()
		end
		
		local tMaxTime = vgui.Create("DLabel", Frame)
		tMaxTime:SetPos(430, Frame:GetTall() - 110)
		tMaxTime:SetText("Max Bomb Time")
		tMaxTime:SizeToContents()
		local nMaxTime = vgui.Create("DNumberWang", Frame)
		nMaxTime:SetPos(380, Frame:GetTall() - 113)
		nMaxTime:SetSize(40, 20)
		nMaxTime:SetToolTip("In seconds. Press Enter to apply changes")
		nMaxTime:SetMinMax( 0, 511 )
		function nMaxTime:OnKeyCodeTyped(key)
			if key == KEY_ENTER then
				net.Start("MaxTime")
					net.WriteInt(self:GetValue(), 10)
				net.SendToServer()
			end
		end
		
		local tMinTime = vgui.Create("DLabel", Frame)
		tMinTime:SetPos(580, Frame:GetTall() - 110)
		tMinTime:SetText("Min Bomb Time")
		tMinTime:SizeToContents()
		local nMinTime = vgui.Create("DNumberWang", Frame)
		nMinTime:SetPos(530, Frame:GetTall() - 113)
		nMinTime:SetSize(40, 20)
		nMinTime:SetToolTip("In seconds. Press Enter to apply changes")
		nMinTime:SetMinMax( 0, 511 )
		function nMinTime:OnKeyCodeTyped(key)
			if key == KEY_ENTER then
				net.Start("MinTime")
					net.WriteInt(self:GetValue(), 10)
				net.SendToServer()
			end
		end
		
		local tManualBomb = vgui.Create("DLabel", Frame)
		tManualBomb:SetPos(470, Frame:GetTall() - 130)
		tManualBomb:SetText("Manually Enable Bomb")
		tManualBomb:SizeToContents()
		local cManualBomb = vgui.Create("DCheckBox", Frame)
		cManualBomb:SetPos(450, Frame:GetTall() - 130)
		cManualBomb:SetValue(cvars.Bool("ytil_bombmanualenable"))
		cManualBomb:SetToolTip("Enables bomb in any non-bomb gametype")
		function cManualBomb:OnChange(bool)
			net.Start("ManualBomb")
				net.WriteBit(bool)
			net.SendToServer()
		end
		
		local sBallSize = vgui.Create( "Slider", Frame )
		sBallSize:SetPos(120, Frame:GetTall() - 140)
		sBallSize:SetWide( 200 )
		sBallSize:SetMin( 0 )
		sBallSize:SetMax( 100 )
		sBallSize:SetValue( math.Round(GetConVar("ytil_ballsize"):GetInt()) )
		sBallSize:SetDecimals( 0 )
		sBallSize.OnValueChanged = function( panel, value )
		end
		local tBallSize = vgui.Create("DLabel", Frame)
		tBallSize:SetPos(80, Frame:GetTall() - 130)
		tBallSize:SetText("Ball size")
		tBallSize:SizeToContents()
		
		bBallSize = vgui.Create("DButton", Frame)
		bBallSize:SetPos(310, Frame:GetTall() - 130)
		bBallSize:SetText("Apply")
		bBallSize:SetSize(50, 15)
		bBallSize.DoClick = function()
			print("Sent request to change the ball size to "..math.Round(sBallSize:GetValue()))
			net.Start("BallSize")
				net.WriteInt(math.Round(sBallSize:GetValue()), 10)
			net.SendToServer()
		end
		
	end
	
	if cvars.Bool("ytil_voteallowed", false) then
		local Vote = vgui.Create( "DButton", Frame )
		if voted != 0 then
			Vote:SetText("Cancel "..ytil_GametypeRules[voted].name.." Vote")
		else
			Vote:SetText("Vote on Mode")
		end
		Vote:SetSize(200, 30)
		Vote:SetPos(admin and Frame:GetWide()/2 + 30 or Frame:GetWide()/2 - 70, Frame:GetTall() - 40)
		Vote.DoClick = function()
			print("Sent request to vote on mode "..selected)
			if selected == 0 then chat.AddText("You need to select a mode to vote.") return end
			if voted != 0 then
				Vote:SetText("Vote on Mode")
				voted = 0
				net.Start("Vote")
					net.WriteInt(voted, 4)
				net.SendToServer()
			else
				if CurTime() < nextVote then
					chat.AddText("Can't vote again yet. Wait "..math.Round(nextVote - CurTime()).." seconds.")
				else
					voted = selected
					Vote:SetText("Cancel "..ytil_GametypeRules[voted].name.." Vote")
					nextVote = CurTime() + 20
					net.Start("Vote")
						net.WriteInt(voted, 4)
					net.SendToServer()
				end
			end
		end
	end
		
		local Players = vgui.Create( "DScrollPanel", Frame )
		Players:SetSize(170, Frame:GetTall() - 100)
		Players:SetPos(#ytil_GametypeRules*110 + 25, 50)
		
		for k,v in pairs(player.GetAll()) do
			local pframe = vgui.Create("DPanel", Players)
			pframe:SetBackgroundColor( Color(v:GetYTILColor()[1]*100 + 155, v:GetYTILColor()[2]*100 + 155, v:GetYTILColor()[3]*100 + 155) )
			pframe:SetSize(150, 30)
			pframe:SetPos( 0, 0 + ((k-1)*35))
			
			if admin then
				local pbut = vgui.Create("DButton", pframe)
				pbut:SetSize(150, 30)
				pbut:SetPos(0,0)
				pbut:SetText("")
				pbut.Paint = function() return end
				pbut.DoRightClick = function()
					pmenu = vgui.Create("DMenu", Frame)
					pmenu:SetPos(Frame:LocalCursorPos())
					pmenu:AddOption("Force Runner", function()
						net.Start("Force")
							net.WriteEntity(v)
							net.WriteInt(1, 4)
						net.SendToServer()
					end)
					pmenu:AddOption("Force Ball Owner", function()
						net.Start("Force")
							net.WriteEntity(v)
							net.WriteInt(2, 4)
						net.SendToServer()
					end)
					pmenu:AddOption("Force Spectator", function()
						net.Start("Force")
							net.WriteEntity(v)
							net.WriteInt(3, 4)
						net.SendToServer()
					end)
					pmenu:AddOption("Force Ball Regain", function()
						net.Start("Force")
							net.WriteEntity(v)
							net.WriteInt(4, 4)
						net.SendToServer()
					end)
				end
			end
			
			local pavatar = vgui.Create("AvatarImage", pframe)
			pavatar:SetSize(24, 24)
			pavatar:SetPos(3, 3)
			pavatar:SetPlayer(v)
			
			local pname = vgui.Create("DLabel", pframe)
			pname:SetText( v:Nick() )
			pname:SetDark(true)
			pname:SetPos(30, 9)
			pname:SetSize(100, 15)
			
			if admin then
				local pcolor = vgui.Create("DImageButton", pframe)
				pcolor:SetPos( 132, 7 )
				pcolor:SetSize( 16, 16 )
				pcolor:SetImage( "icon16/color_wheel.png" )
				pcolor:SetToolTip("Click to reroll color")
				pcolor.DoClick = function()
					net.Start("RerollC")
						net.WriteEntity(v)
					net.SendToServer()
					timer.Simple(0.05, function() pframe:SetBackgroundColor( Color(v:GetYTILColor()[1]*100 + 155, v:GetYTILColor()[2]*100 + 155, v:GetYTILColor()[3]*100 + 155) ) end)
				end
			end
		end
		
	local Spectator = vgui.Create( "DButton", Frame )
	Spectator:SetText(LocalPlayer():Team() == 3 and LocalPlayer():Alive() and "Join Back" or "Spectate")
	Spectator:SetSize(170, 30)
	Spectator:SetPos(#ytil_GametypeRules*110 + 20, Frame:GetTall() - 40)
	Spectator.DoClick = function()
		net.Start("Spectate")
		net.SendToServer()
		timer.Simple(0.1, function() Spectator:SetText(LocalPlayer():Team() == 3 and "Join Back" or "Spectate" ) end)
	end
	
	local workshop = vgui.Create("DLabelURL", Frame)
	workshop:SetURL( "http://steamcommunity.com/sharedfiles/filedetails/?id=447829341" )
	workshop:SetText( "For more information visit the Workshop page!" )
	workshop:SizeToContents()
	workshop:SetPos( Frame:GetWide()/2 - 75, Frame:GetTall() - 70 )
	workshop:SetColor( Color( 255, 255, 255, 255 ) )
	
	local alwaysopen = vgui.Create("DLabel", Frame)
	alwaysopen:SetText( "You can always open this menu with F1" )
	alwaysopen:SizeToContents()
	alwaysopen:SetPos( Frame:GetWide()/2 - 65, Frame:GetTall() - 85 )
	alwaysopen:SetColor( Color( 100, 255, 255, 255 ) )
	
	local promobackground = vgui.Create( "DImage", Frame )
	promobackground:SetImage("youtoucheditlast/zetbackground.png")
	promobackground:SetSize(280,100)
	promobackground:SetPos(-10, Frame:GetTall() - 85)
	
	local promoicon = vgui.Create( "DImage", Frame )
	promoicon:SetImage("youtoucheditlast/zeticon.png")
	promoicon:SetSize(80,80)
	promoicon:SetPos(5, Frame:GetTall() - 85)
	
	local promotitle = vgui.Create( "DLabel", Frame )
	promotitle:SetFont("Promo")
	promotitle:SetText(" Like the gamemode?")
	promotitle:SetPos(87, Frame:GetTall() - 52)					-- Server owners: I ask of you that you do not remove this promotional content, thank you :)
	promotitle:SetSize(200, 20)
	
	local promodesc = vgui.Create( "DLabel", Frame )
	promodesc:SetFont("Promo2")
	promodesc:SetText(" Visit the creators channel!")
	promodesc:SetPos(87, Frame:GetTall() - 40)
	promodesc:SetSize(200, 20)
	
	local promonote = vgui.Create( "DLabel", Frame )
	promonote:SetFont("Promo3")
	promonote:SetText(" (youtube.com/Zet0r)")
	promonote:SetPos(87, Frame:GetTall() - 30)
	promonote:SetSize(200, 20)
	
	local promobut = vgui.Create("DButton", Frame)
	promobut:SetSize(270, 100)
	promobut:SetPos(0, Frame:GetTall() - 85)
	promobut:SetText("")
	promobut:SetToolTip("Opens in Steam Overlay")
	promobut.Paint = function() return end
	promobut.DoClick = function()
		gui.OpenURL("https://youtube.com/Zet0r")
	end
	
	Frame:SizeToContents()
	
	Frame:SetPos( ScrW()/2 - (Frame:GetWide()/2), ScrH()/2 - (Frame:GetTall()/2) )

end
net.Receive("Popup", function()
	ShowGametypePopup(net.ReadBool())
end)

hook.Add("InitPostEntity", "OpenF1Menu", function()
	ShowGametypePopup(LocalPlayer():ytil_HasAdminPriviledges())
	LocalPlayer().beginTele = 0
	LocalPlayer().charge = 0
end)

function GM:PrePlayerDraw( ply )
	if !ply.datatablesup then player_manager.RunClass( ply, "SetupDataTables" ) end
end

function GM:PostPlayerDraw( ply )

	if ply:GetHasBall() then
		local pos, ang = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_R_Hand" ) )

		--print("drawing")
		local id = ply:GetBallID()
		render.SetMaterial( ytil_BallList[id].texture )
		if ytil_Variables.gametype == 7 then
			if ply:Team() == 2 then
				render.DrawSprite( pos + ang:Forward() * 4 + ang:Right()*3, GetConVar("ytil_ballsize"):GetInt(), GetConVar("ytil_ballsize"):GetInt(), Color( 50, 50, 50, 255 ) )
			else
				render.DrawSprite( pos + ang:Forward() * 4 + ang:Right()*3, GetConVar("ytil_ballsize"):GetInt(), GetConVar("ytil_ballsize"):GetInt(), Color( 255, 255, 255, 255 ) )
			end
		else
			local lcolor = render.ComputeLighting( pos, Vector( 0, 0, 1 ) )
			local c = ply:GetYTILColor()
		
			lcolor.x = c.x * ( math.Clamp( lcolor.x, 0, 1 ) + 0.5 ) * 255
			lcolor.y = c.y * ( math.Clamp( lcolor.y, 0, 1 ) + 0.5 ) * 255
			lcolor.z = c.z * ( math.Clamp( lcolor.z, 0, 1 ) + 0.5 ) * 255
		
			render.DrawSprite( pos + ang:Forward() * 4 + ang:Right()*3, GetConVar("ytil_ballsize"):GetInt(), GetConVar("ytil_ballsize"):GetInt(), Color( lcolor.x, lcolor.y, lcolor.z, 255 ) )
		end
	end

end

hook.Add("InitPostEntity", "FullyLoaded", function()
	net.Start("PlayerLoaded")
	net.SendToServer()
	steamworks.FileInfo( 447829341, function( result )
		if result.updated then
		
		else
		
		end
	end )
	chat.AddText(Color(255,100,100), "Welcome to ", Color(100,255,100), "You Touched it Last! ", Color(255,100,100), "Press F1 for information about the gamemode and the various gametypes!")
end)

net.Receive("YTILThanks", function()
	chat.AddText(Color(255,255,255), "Thank you for being a contributor to the gamemode! As a reward you have unlocked ", Color(255,0,255), "The Black Hole Ball", Color(255,255,255), "!")
end)

function GM:HUDPaint()

	--if LocalPlayer():Team() == 3 then return end

	local pColor = LocalPlayer():GetYTILColor()

	surface.SetMaterial( ytil_BallList[LocalPlayer():GetBallID()].texture )
	if LocalPlayer():Team() == 3 then
		surface.SetDrawColor( 255, 255, 255, 255)
		surface.DrawTexturedRect( ((ScrW() / 75) + 380) * (ScrH()/1080), ((ScrH() / 10) * 8) * (ScrH()/1080), 174, 174)
	else
		if ytil_Variables.gametype == 7 then
			if LocalPlayer():Team() == 1 then
				surface.SetDrawColor( 50, 50, 50, 255)
				surface.DrawTexturedRect( ((ScrW() / 75) + 380) * (ScrH()/1080), ((ScrH() / 10) * 8), 174 * (ScrH()/1080), 174 * (ScrH()/1080))
				if LocalPlayer():GetHasBall() then
					surface.SetDrawColor( 255, 255, 255, 255)
					surface.DrawTexturedRectUV( ((ScrW() / 75) + 380) * (ScrH()/1080), ((ScrH() / 10) * 8 + ((174* (ScrH()/1080)) - (174* (ScrH()/1080)) * (LocalPlayer():Health()/100))), 174 * (ScrH()/1080), (174 * (LocalPlayer():Health()/100)) * (ScrH()/1080), 0,1 - (LocalPlayer():Health()/100), 1,1 )
				else
					surface.SetDrawColor( 150, 150, 150, 255)
					surface.DrawTexturedRectUV( ((ScrW() / 75) + 380) * (ScrH()/1080), ((ScrH() / 10) * 8 + ((174* (ScrH()/1080)) - (174* (ScrH()/1080)) * (LocalPlayer():Health()/100))), 174 * (ScrH()/1080), (174 * (LocalPlayer():Health()/100)) * (ScrH()/1080), 0,1 - (LocalPlayer():Health()/100), 1,1 )
				end
			elseif LocalPlayer():Team() == 2 then
				surface.SetDrawColor( 20, 20, 20, 255)
				surface.DrawTexturedRect( ((ScrW() / 75) + 380) * (ScrH()/1080), ((ScrH() / 10) * 8), 174 * (ScrH()/1080), 174 * (ScrH()/1080))
				if LocalPlayer():GetHasBall() then
					surface.SetDrawColor( 75, 75, 75, 255)
					surface.DrawTexturedRectUV( ((ScrW() / 75) + 380) * (ScrH()/1080), ((ScrH() / 10) * 8 + ((174* (ScrH()/1080)) - (174* (ScrH()/1080)) * (LocalPlayer():Health()/100))), 174 * (ScrH()/1080), (174 * (LocalPlayer():Health()/100)) * (ScrH()/1080), 0,1 - (LocalPlayer():Health()/100), 1,1 )
				else
					surface.SetDrawColor( 35, 35, 35, 255)
					surface.DrawTexturedRectUV( ((ScrW() / 75) + 380) * (ScrH()/1080), ((ScrH() / 10) * 8 + ((174* (ScrH()/1080)) - (174* (ScrH()/1080)) * (LocalPlayer():Health()/100))), 174 * (ScrH()/1080), (174 * (LocalPlayer():Health()/100)) * (ScrH()/1080), 0,1 - (LocalPlayer():Health()/100), 1,1 )
				end
			else
				surface.SetDrawColor( pColor.x * 100, pColor.y * 100, pColor.z * 100, 255)
				surface.DrawTexturedRectUV( ((ScrW() / 75) + 380) * (ScrH()/1080), ((ScrH() / 10) * 8 + ((174* (ScrH()/1080)) - (174* (ScrH()/1080)) * (LocalPlayer():Health()/100))), 174 * (ScrH()/1080), (174 * (LocalPlayer():Health()/100)) * (ScrH()/1080), 0,1 - (LocalPlayer():Health()/100), 1,1 )
			end
		else
			surface.SetDrawColor( pColor.x * 50, pColor.y * 50, pColor.z * 50, 255)
			surface.DrawTexturedRect( ((ScrW() / 75) + 380) * (ScrH()/1080), ((ScrH() / 10) * 8), 174 * (ScrH()/1080), 174 * (ScrH()/1080))
			if LocalPlayer():GetHasBall() or LocalPlayer():Team() == 1 then
				surface.SetDrawColor( pColor.x * 255, pColor.y * 255, pColor.z * 255, 255)
				surface.DrawTexturedRectUV( ((ScrW() / 75) + 380) * (ScrH()/1080), ((ScrH() / 10) * 8 + ((174* (ScrH()/1080)) - (174* (ScrH()/1080)) * (LocalPlayer():Health()/100))), 174 * (ScrH()/1080), (174 * (LocalPlayer():Health()/100)) * (ScrH()/1080), 0,1 - (LocalPlayer():Health()/100), 1,1 )
			else
				surface.SetDrawColor( pColor.x * 100, pColor.y * 100, pColor.z * 100, 255)
				surface.DrawTexturedRectUV( ((ScrW() / 75) + 380) * (ScrH()/1080), ((ScrH() / 10) * 8 + ((174* (ScrH()/1080)) - (174* (ScrH()/1080)) * (LocalPlayer():Health()/100))), 174 * (ScrH()/1080), (174 * (LocalPlayer():Health()/100)) * (ScrH()/1080), 0,1 - (LocalPlayer():Health()/100), 1,1 )
			end
		end
	end
	
	surface.SetMaterial( Material("youtoucheditlast/gameshower.png") )
	if LocalPlayer():Team() == 3 then
		surface.SetDrawColor( 255, 255, 255, 255)
	else
		surface.SetDrawColor( pColor.x * 255, pColor.y * 255, pColor.z * 255, 255)
	end
	surface.DrawTexturedRect( (ScrW() / 75 - 20) * (ScrH()/1080), ((ScrH() / 10) * 8 - 12), 395 * (ScrH()/1080), 207 * (ScrH()/1080))
	
	if ManualBombEnable and !(ytil_Variables.gametype == 2 or ytil_Variables.gametype == 4) then
		surface.SetMaterial( ManualBombTexture )
		surface.SetDrawColor( 255, 255, 255, 255)
		surface.DrawTexturedRect( (ScrW() / 75 - 30) * (ScrH()/1080), ((ScrH() / 10) * 8 - 75), 220 * (ScrH()/1080), 220 * (ScrH()/1080))
	end
	
	surface.SetMaterial( ytil_GametypeRules[ytil_Variables.gametype].texture )
	surface.SetDrawColor( 255, 255, 255, 255)
	surface.DrawTexturedRect( (ScrW() / 75) * (ScrH()/1080), ((ScrH() / 10) * 8 - 40), 150 * (ScrH()/1080), 150 * (ScrH()/1080))
	
	if (ytil_Variables.gametype == 2 or ytil_Variables.gametype == 4 or ManualBombEnable) and cvars.Bool("ytil_bombshowtime") then
		if ytil_Variables.bombTime >= CurTime() then
			draw.SimpleTextOutlined(string.ToMinutesSeconds(ytil_Variables.bombTime - CurTime()), "BombTime", ytil_Variables.gametype == 2 and (ScrW() / 75 + 40) * (ScrH()/1080) or (ScrW() / 75 + 32) * (ScrH()/1080), ((ScrH() / 10) * 8  + 0) + (50*(ScrH()/1080)), Color(255,255,255),
			TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 4, Color(0,0,0))
		else
			draw.SimpleTextOutlined("00:00", "BombTime", ytil_Variables.gametype == 2 and (ScrW() / 75 + 40) * (ScrH()/1080) or (ScrW() / 75 + 32) * (ScrH()/1080), ((ScrH() / 10) * 8  - 20) + (70*(ScrH()/1080)), Color(255,255,255),
			TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 4, Color(0,0,0))
		end
	end

	if (LocalPlayer():Team() == 1 or LocalPlayer():Team() == 3) and !LocalPlayer():GetHasBall() then
		surface.SetMaterial( Material("youtoucheditlast/powerbarblue.png") )
		if ytil_ballTeleCharge > 0 then
			surface.SetDrawColor(150, 150, 150, 255)
		else
			surface.SetDrawColor(255, 255, 255, 255)
		end
		surface.DrawTexturedRect( (ScrW() / 75) * (ScrH()/1080), ((ScrH() / 10) * 8) , 367 * (ScrH()/1080), 175 * (ScrH()/1080))
	end
	
	if LocalPlayer():Team() == 2 or LocalPlayer():GetHasBall() then
		surface.SetMaterial( Material("youtoucheditlast/powerbar.png") )
		surface.SetDrawColor(75, 75, 75, 255)
		surface.DrawTexturedRect( (ScrW() / 75) * (ScrH()/1080), ((ScrH() / 10) * 8), 367 * (ScrH()/1080), 175 * (ScrH()/1080))
		
		if LocalPlayer().charge then
			surface.SetMaterial( Material("youtoucheditlast/powerbarcharger.png") )
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRectUV( (ScrW() / 75 + 14) * (ScrH()/1080), ((ScrH() / 10) * 8 + (14* (ScrH()/1080))), (340 * (LocalPlayer().charge/100)) * (ScrH()/1080), 148 * (ScrH()/1080), 0,0, LocalPlayer().charge/100,1 )
		end
	end
	if ytil_ballTeleCharge > 0 then
		surface.SetMaterial( Material("youtoucheditlast/powerbarblue.png") )
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRectUV( (ScrW() / 75) * (ScrH()/1080), ((ScrH() / 10) * 8), (367 * ytil_ballTeleCharge) * (ScrH()/1080), 175 * (ScrH()/1080), 0,0, ytil_ballTeleCharge,1 )
	end
	
	hook.Run( "HUDDrawTargetID" )

end

local targetply = nil
local targettime = 0
function GM:HUDDrawTargetID()
	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then targetply = nil return end
	if (!trace.HitNonWorld) then targetply = nil return end
	
	local ent = trace.Entity
	if !ent:IsPlayer() or ent:Team() == 3 then targetply = nil return end
	
	if !targetply then
		targetply = ent
		targettime = CurTime() + 0.25 -- The delay for the text to show up
	end
	
	local text = ent:Nick()
	
	surface.SetFont( "BombTime" )
	local w, h = surface.GetTextSize( text )
	local MouseX, MouseY = gui.MousePos()
	
	if ( MouseX == 0 && MouseY == 0 ) then
	
		MouseX = ScrW() / 2
		MouseY = ScrH() / 2
	
	end
	
	local x = MouseX
	local y = MouseY
	x = x - w / 2
	y = y + 30
	
	local pColor = ent:GetYTILColor()
	
	if CurTime() >= targettime then
		draw.SimpleTextOutlined( text, "BombTime", x, y, Color(pColor.x * 255, pColor.y * 255, pColor.z * 255, 255), 0, 0, 3, Color(0,0,0) )
	end
	
end

function GM:PostDrawViewModel( vm, ply, weapon )

	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end
		
		-- Draw the ball over the grenade
		if LocalPlayer():GetHasBall() then
			local ballColor = Color(255,255,255,255)
			render.SetMaterial( ytil_BallList[LocalPlayer():GetBallID()].texture )
			if ytil_Variables.gametype == 7 then
				if LocalPlayer():Team() == 2 then
					ballColor = Color(50, 50, 50, 255)
				else
					ballColor = Color(255, 255, 255, 255)
				end
			else
				ballColor = Color(LocalPlayer():GetYTILColor().x * 255, LocalPlayer():GetYTILColor().y * 255, LocalPlayer():GetYTILColor().z * 255)
			end
			
			render.DrawSprite(
				LocalPlayer():GetViewModel():GetBonePosition( LocalPlayer():GetViewModel():LookupBone( "ValveBiped.Grenade_body" ) )
				+ LocalPlayer():EyeAngles():Forward()*-1 + LocalPlayer():EyeAngles():Right()*ytil_BallList[LocalPlayer():GetBallID()].offsetX 
				+ LocalPlayer():EyeAngles():Up()*ytil_BallList[LocalPlayer():GetBallID()].offsetY,
				10, 10,
				ballColor
			)
		end
		
		-- Hide the grenade bone
		LocalPlayer():GetViewModel():ManipulateBoneScale(  LocalPlayer():GetViewModel():LookupBone( "ValveBiped.Grenade_body" ), Vector(0,0,0) )
		LocalPlayer():GetViewModel():ManipulateBoneScale(  LocalPlayer():GetViewModel():LookupBone( "ValveBiped.Pin" ), Vector(0,0,0) )

	end

end

function GM:ShouldDrawLocalPlayer( ply )

	if input.IsMouseDown(MOUSE_RIGHT) and !LocalPlayer():GetHasBall() and !vgui.CursorVisible() and LocalPlayer():Team() != 3 then
		return true
	else
		return nil
	end

end

local magicView = {
 [ "$pp_colour_addr" ] = 0,
 [ "$pp_colour_addg" ] = 0,
 [ "$pp_colour_addb" ] = 0,
 [ "$pp_colour_brightness" ] = -0.4,
 [ "$pp_colour_contrast" ] = 0.8,
 [ "$pp_colour_colour" ] = 0.1,
 [ "$pp_colour_mulr" ] = 0.5,
 [ "$pp_colour_mulg" ] = 0.5,
 [ "$pp_colour_mulb" ] = 0.5,
 fadetime = 1
}
local faded = false
local fadeTime = 0

function GM:RenderScreenspaceEffects()

	if !GetConVar("ytil_runnermagic"):GetBool() and LocalPlayer():Team() == 1 and ytil_Variables.gametype != 7 then return end
	if LocalPlayer():Team() == 3 then return end
	if vgui.CursorVisible() then return end
	-- Prevents effect when chatting, but sub-sequentially also disables it when on a menu

	if input.IsMouseDown(MOUSE_RIGHT) and !LocalPlayer():GetHasBall() then
		if faded == false then
			fadeTime = CurTime() + magicView.fadetime
			faded = true
		end
		if fadeTime >= CurTime() then
			DrawColorModify( {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = 0,
			[ "$pp_colour_brightness" ] = -0.4 + (0.4 * (fadeTime - CurTime())),
			[ "$pp_colour_contrast" ] = 0.8 + (0.2 * (fadeTime - CurTime())),
			[ "$pp_colour_colour" ] = 0.1 + (0.9 * (fadeTime - CurTime())),
			[ "$pp_colour_mulr" ] = 0.5 + (0.5 * (fadeTime - CurTime())),
			[ "$pp_colour_mulg" ] = 0.5 + (0.5 * (fadeTime - CurTime())),
			[ "$pp_colour_mulb" ] = 0.5 + (0.5 * (fadeTime - CurTime()))
			} )
			for k,v in pairs(ents.FindByClass("ytil_ball")) do
				if ytil_Variables.gametype != 7 or v:GetAngelic() then
					halo.Add({v}, Color(v:GetBallColor()[1]*255, v:GetBallColor()[2]*255, v:GetBallColor()[3]*255, 255 - (255 * (fadeTime - CurTime()))), 2, 2, 1, true, true )
				end
			end
		else
			DrawColorModify( magicView )
			for k,v in pairs(ents.FindByClass("ytil_ball")) do
				if ytil_Variables.gametype != 7 or v:GetAngelic() then
					halo.Add({v}, Color(v:GetBallColor()[1]*255, v:GetBallColor()[2]*255, v:GetBallColor()[3]*255, 255), 2, 2, 1, true, true )
				end
			end
		end
	else
		if faded == true then
			fadeTime = CurTime() + magicView.fadetime
			faded = false
		end
		if fadeTime >= CurTime() then
			DrawColorModify( {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = 0,
			[ "$pp_colour_brightness" ] = 0 - (0.4 * (fadeTime - CurTime())),
			[ "$pp_colour_contrast" ] = 1 - (0.2 * (fadeTime - CurTime())),
			[ "$pp_colour_colour" ] = 1 - (0.9 * (fadeTime - CurTime())),
			[ "$pp_colour_mulr" ] = 1 - (0.5 * (fadeTime - CurTime())),
			[ "$pp_colour_mulg" ] = 1 - (0.5 * (fadeTime - CurTime())),
			[ "$pp_colour_mulb" ] = 1 - (0.5 * (fadeTime - CurTime()))
			} )
			for k,v in pairs(ents.FindByClass("ytil_ball")) do
				if ytil_Variables.gametype != 7 or v:GetAngelic() then
					halo.Add({v}, Color(v:GetBallColor()[1]*255, v:GetBallColor()[2]*255, v:GetBallColor()[3]*255, 0 + (255 * (fadeTime - CurTime()))), 2, 2, 1, true, true )
				end
			end
		end
	end

end

function GM:PreDrawHalos()

	if !GetConVar("ytil_runnermagic"):GetBool() and LocalPlayer():Team() == 1 then return end

	if input.IsMouseDown(MOUSE_RIGHT) and !LocalPlayer():GetHasBall() then
		if fadeTime >= CurTime() then
			for k,v in pairs(ents.FindByClass("ytil_ball")) do
				halo.Add({v}, Color(v:GetBallColor()[1]*255, v:GetBallColor()[2]*255, v:GetBallColor()[3]*255, 255 - (255 * (fadeTime - CurTime()))), 2, 2, 1, true, true )
			end
		else
			for k,v in pairs(ents.FindByClass("ytil_ball")) do
				halo.Add({v}, Color(v:GetBallColor()[1]*255, v:GetBallColor()[2]*255, v:GetBallColor()[3]*255, 255), 2, 2, 1, true, true )
			end
		end
	else
		if fadeTime >= CurTime() then
			for k,v in pairs(ents.FindByClass("ytil_ball")) do
				halo.Add({v}, Color(v:GetBallColor()[1]*255, v:GetBallColor()[2]*255, v:GetBallColor()[3]*255, 0 + (255 * (fadeTime - CurTime()))), 2, 2, 1, true, true )
			end
		end
	end

end

function GM:CalcView( ply, pos, angles, fov, nearZ, farZ )

	if LocalPlayer():Team() == 3 then return end
	if vgui.CursorVisible() then return end

	if input.IsMouseDown(MOUSE_RIGHT) and !LocalPlayer():GetHasBall() then
		local view = {}

		--view.origin = pos + ( angles:Forward()*5 )
		view.origin = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
		view.angles = angles
		view.fov = fov

		return view
	else
		return false
	end
end