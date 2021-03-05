local component = require("component")
local chamber = component.reactor_chamber
local r = component.redstone
local dsu = component.deep_storage_unit --deep_storage_unit для одиночки: __________________ 
local event = require("event")
local crystal = component.crystal
local gpu = component.gpu
local computer = require("computer")
r_signal = true
tempControl = false
maxHeat = 1000
pushSide = "NORTH" --Сторона выталкивания
counter = 0
cycles = 0
cycleTime = 0
--Require slots
LZN = {
	2, 7, 9, 14, 21, 26, 28, 33, 40, 45, 47, 52
}
WTF = {
	4, 10, 50
}
rod = {
	1,3,5,6,8,11,12,13,15,16,17,18,19,20,22,23,24,25,27,29,30,31,32,34,35,36,37,38,39,41,42,43,44,46,48,49,51,53,54
}
function redstone(enable)
	if r_signal == enable then return end
	r.setOutput(1, enable and 15 or 0) -- тернарный оператор 
	r_signal = enable
	if not enable then
		while chamber.isActive() do end
	end	
end
function find(arg)
	for k=1,4 do
		if crystal.getStackInSlot(k) ~= nil then
			if crystal.getStackInSlot(k).name == arg then
				return k
			end
		end		
	end
	return false	
end
gpu.setResolution(35,11)
-- gpu.setResolution(70,30) -- DeveloperResolution
r.setOutput(1, r_signal and 15 or 0)
gpu.fill(1,1,160,50," ")
event.shouldInterrupt = function() return false end
startTime = math.floor(computer.uptime())
while true do
	name,_,_,code=event.pull(0.01,"key_down")
	if code == 74 then
		r.setOutput(1, 0) print("Реактор отключён!")
		break
	end	
	time = math.floor(computer.uptime() - startTime)
	if chamber.getHeat() > maxHeat and tempControl == true then
		print("Пизда рулю")
		redstone(false)
		os.exit()
	end	
	if dsu.getStoredItems().qty < 10 then
		print("Недостаточно кондеров!")
		redstone(false)
		os.exit()
	end	
	items = chamber.getAllStacks(false)
	for k, i  in pairs(LZN) do
		if not items[i] or items[i].dmg >= 9000 then
			redstone(false)
			os.sleep(1)
			chamber.pushItem(pushSide, i)
			dsu.pushItem("UP", 3, 1, i)
			counter = counter + 1
			os.sleep(1)
		end	
	end
	for _,i  in pairs(WTF) do -- _, пропуск индекса массива i - что внутри массива
		if not items[i] then
			slot=find("reactorReflectorThick")
			if slot ~= false then
				crystal.pushItem(pushSide,slot,1,i)
			end
		end	
	end
	for _,i in pairs(rod) do
		if not items[i] then
			slot = find("reactorUraniumQuad") or find("reactorMOXQuad")
			if slot ~= false then
				crystal.pushItem(pushSide,slot,1,i)
			end	
		end	
	end	
	redstone(true)
	gpu.set(3,2, "Лазурита потрачено: "..(counter*9).."       ")
	gpu.set(3,4, "Выход: "..math.floor(chamber.getEUOutput()*5).." EU/t")
	gpu.set(3,6, "Время работы: "..time.." секунд(ы)")
	gpu.set(3,8, "Циклов отработано: "..cycles)
end	

--1 цикл 21800 лазурита // 1,09 лазурита в секунду // 20000 секунд в 1 цикле