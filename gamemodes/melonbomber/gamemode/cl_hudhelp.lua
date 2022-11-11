local helpKeysProps = {
	{"attack", "Coloca una bomba"},
	{"attack2", "Usa una accion especial"},
}

local function keyName(str)
	str = input.LookupBinding(str) or ""
	if str == "MOUSE1" then
		str = "Click Izquierdo"
	elseif str == "MOUSE2" then
		str = "Click Derecho"
	elseif str == "CTRL" then
		str = "CTRL Izquierdo"
	end
	return str:upper()
end

function GM:DrawBindsHelp()
	local shouldDraw = false 
	if LocalPlayer():Alive() then
		if self:GetGameState() == 1 || self:GetGameState() == 0 then
			shouldDraw = true
		end
	end


	if shouldDraw then
		local x = ScrW() / 2
		local y = ScrH() * 0.7
		local f24, f16 = draw.GetFontHeight("RobotoHUD-24"), draw.GetFontHeight("RobotoHUD-16")
		draw.ShadowText("Place bomb", "RobotoHUD-24", x, y, color_white, 1)
		draw.ShadowText(keyName("attack") .. " / " .. keyName("jump"), "RobotoHUD-L16", x, y + f24, color_white, 1)

		draw.ShadowText("Special action", "RobotoHUD-24", x, y + f24 + f16 + 20, color_white, 1)
		draw.ShadowText(keyName("attack2") .. " / " .. keyName("duck"), "RobotoHUD-L16", x, y + f24 + f16 + 20 + f24, color_white, 1)
	end
end