
-- A script that allows you to randomly choose a player (or thing)
-- based on a weight assigned to each. Feel free to copy this code for yourself if needed :)

local wRandom = {}
wRandom.__index = wRandom

-- Gets the table so you can run functions on it
function GetWRandomTable()

	local tab = {}
	tab.values = {}
	setmetatable(tab, wRandom)
	return tab

end

-- Adds values with their given weight to the table
function wRandom:Add(value, weight)

	local t = {}
	t.value = value
	t.weight = weight
	table.insert(self.values, t)

end

-- Rolls a random value in the range of the total weight of all values in play, returns the one it lands on after passing the random value
function wRandom:Roll()

	-- In case there's only 1 entry in the table
	if table.Count(self.values) == 1 then return self.values[1].value end

	local total = 0
	for k,v in pairs(self.values) do
		total = total + v.weight
	end
	
	local ran = math.random(total - 1)
	local cur = 0
	
	for k,v in pairs(self.values) do
		cur = cur + v.weight
		if ran < cur then
			return v.value
		end
	end

end