local c = require("component")
local r = c.redstone
local reac = c.reactor_chamber
local me = c.me_interface
local lznC = 0
local wtfC = 0
local gpu = c.gpu
local event = require("event")
local r_signal = true

local itemLZN = me.getInterfaceConfiguration(1)
local itemWTF = me.getInterfaceConfiguration(2)
itemLZN = {id=itemLZN.name, dmg=itemLZN.damage}
itemWTF = {id=itemWTF.name, dmg=itemWTF.damage}
LZN = {
	2, 7, 9, 14, 21, 26, 28, 33, 40, 45, 47, 52
}
WTF = {
	4, 10, 50
}
gpu.fill(1, 1, 160, 50," ")
function stat()
	gpu.set(1, 1, "Кондетсаторов потрачено: "..lznC)
	gpu.set(1, 2, "Отражателей потрачено: "..wtfC)
	gpu.set(1, 3, "Нагрев ядра: "..(reac.getHeat()/reac.getMaxHeat()*100).."%  ")
	gpu.set(1, 5, "Выход энергии: "..(reac.getEUOutput()*5).."EU/t  ")
end
function redstone(enable)
	if r_signal == enable then return end
	r.setOutput(1, enable and 15 or 0) -- тернарный оператор 
	r_signal = enable
	if not enable then
		while reac.isActive() do end
	end	
end
r.setOutput(1, r_signal and 15 or 0)
while true do
	name,_,_,code=event.pull(0.01,"key_down")
	if code == 59 then
		r.setOutput(1, 0) print("Реактор отключён!")
		break
	end	
	items = reac.getAllStacks(false)
	for _,i  in pairs(LZN) do -- _, пропуск индекса массива i - что внутри массива
		if not items[i] or items[i].dmg >= 9200 then
			redstone(false)
			reac.pushItem("DOWN", i)
			me.exportItem(itemLZN, "UP", nil, i)
			lznC = lznC + 1
		end	
	end	
	for _,i  in pairs(WTF) do -- _, пропуск индекса массива i - что внутри массива
		if not items[i] or items[i].dmg >= 9990 then
			redstone(false)
			reac.pushItem("DOWN", i)
			me.exportItem(itemWTF, "UP", nil, i)
			wtfC = wtfC + 1
		end	
	end	
	redstone(true)
	stat()
end

