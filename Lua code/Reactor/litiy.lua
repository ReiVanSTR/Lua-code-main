local component = require("component")
local gpu = component.gpu
local red = component.redstone
local reac = component.reactor_chamber
local crystal = component.crystal
local r_signal = true
local slot = 1
LZN = {14, 30, 34, 50}
function redstone(enable)
	if r_signal == enable then return end
	red.setOutput(1, enable and 15 or 0) -- тернарный оператор 
	r_signal = enable
	if not enable then
		while reac.isActive() do end
	end	
end
red.setOutput(1, r_signal and 15 or 0)
while true do 
	items = reac.getAllStacks(false)
	for _, i in pairs(LZN) do
		if not items[i] or items[i].dmg >= 6000 then 
			redstone(false)
			reac.pushItem("DOWN", i)
			crystal.pushItem("UP", slot, 1, i)
			slot = slot + 1
		end	
	end	
	if slot == 4 then slot = 1 end 
	os.sleep(1)
	redstone(true)
end	