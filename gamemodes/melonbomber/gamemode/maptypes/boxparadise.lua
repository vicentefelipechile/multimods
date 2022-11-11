map.name = "Paraiso de Cajas"
map.description = "Demasiadas cajas con pocas paredes"

function map:generateMap(grid)
	for x = grid.minx, grid.maxx do
		for y = grid.miny, grid.maxy do
			if x % 2 == 0 && y % 2 == 0 then
				if (math.random(2) != 1) then
					grid:setBox(x, y)
				else
					grid:setWall(x, y)
				end
			else
				if math.random(5) != 1 then
					grid:setBox(x, y)
				end
			end
		end 
	end
end