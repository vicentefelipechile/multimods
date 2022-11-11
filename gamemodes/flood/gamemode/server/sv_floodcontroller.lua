function GetWaterControllers()
	local controllers = {}
	for k,v in pairs(ents.GetAll()) do
		print(k, v)
		if v:GetClass() == "func_water_analog" then
			table.insert(controllers, v)
		end
	end

	return controllers
end

function GM:CheckForWaterControllers()
	if #GetWaterControllers() <= 0 then 
		self.ShouldHaltGamemode = true
		error("Flood was unable to find a valid water controller on "..game.GetMap()..", gamemode halting.", 2)
	end
end

function GM:RiseAllWaterControllers()
	for k,v in pairs(GetWaterControllers()) do
		v:Fire("open")
	end
end

function GM:LowerAllWaterControllers()
	for k,v in pairs(GetWaterControllers()) do
		v:Fire("close")
	end
end
