local component = require("component")
local chamber = component.reactor_chamber
local r = component.redstone
local dsu = component.deep_storage_unit --.deep_storage_unit --deep_storage_unit для одиночки: __________________ 
local event = require("event")
local crystal = component.crystal
local gpu = component.gpu
local computer = require("computer")
local version = "1.9.2 Beta"
local args = {...}
dvmode = false
r_signal = true
tempControl = true
maxHeat = 100
sides = {SOUTH='NORTH',NORTH='SOUTH',EAST='WEST',WEST='EAST'}
pushSide = "SOUTH" --Сторона выталкивания
buffSide = "NORTH" --Противоположная сторона от pushSide
ebal_ya_w_rot_nizky_tps = 0.1 --Время до и после загрузки злн теплоотвода
counter = 0
reactorType=0
reactorTypeString='default'
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
lithium = {
	6,12,16,17,21,23,29,31,35,38,41,43,53
}
function redstone(enable)
	if r_signal == enable then return end
	r.setOutput(1, enable and 15 or 0) -- тернарный оператор 
	r_signal = enable
	if not enable then
		while chamber.isActive() do end
	end	
end
function find(arg, size, startPos)
	for k=startPos or 1,size or 10 do
		if crystal.getStackInSlot(k) ~= nil then
			if crystal.getStackInSlot(k).name == arg then
				return k
			end
		end		
	end
	return false	
end

function changeType(reactorType)
	local items = chamber.getAllStacks(false)
	local pos = 37
	if reactorType == 1 then
		for _, lithiumPos in ipairs(lithium) do
			if items[lithiumPos] and items[lithiumPos].id == "IC2:reactorUraniumQuad" or not items[lithiumPos] then
				while chamber.pushItem(buffSide, lithiumPos, 1, pos) == 0 do pos = pos + 1 end
				local slot = find("reactorLithiumCell") or find("reactorLithiumCell",108,37)
				if slot ~= false then
					crystal.pushItem(pushSide, slot, 1, lithiumPos)
				end
				if dvmode then print(slot) end
			end
		end
		for k,v in ipairs(rod) do
			for l,m in ipairs(lithium) do
				if v==m then
					table.remove(rod, k)
				end
			end
		end
	else
		for _, lithiumPos in ipairs(lithium) do
			if items[lithiumPos] and items[lithiumPos].id == "IC2:reactorLithiumCell" or not items[lithiumPos] then
				while chamber.pushItem(buffSide, lithiumPos, 1, pos) == 0 do pos = pos + 1 end
				local slot = find("reactorUraniumQuad") or find("reactorUraniumQuad",108,37)
				if slot ~= false then
					crystal.pushItem(pushSide, slot, 1, lithiumPos)
				end
				if dvmode then print(slot) end
			end
		end
		for k,v in ipairs(lithium) do
			local isHave = false
			for l,m in ipairs(rod) do
				if v==m then
					isHave = true
				end
			end
			if not isHave then table.insert(rod, v) end
		end
	end
end

if dvmode == true then gpu.setResolution(70,30) else gpu.setResolution(35,11) end -- DeveloperResolution
if #args > 0 then
	gpu.fill(1,1,160,50," ")
	for k,v in ipairs(args) do if v=='-dev' then dvmode = true gpu.setResolution(70,30) print('Включен режим разработчика') os.sleep(3) end end
	for pos,parm in ipairs(args) do
		if dvmode then print(pos, parm) end
		if parm == "temp" then maxHeat = tonumber(args[pos+1]) print("Предельная темпиратура установлена в значение: "..args[pos+1].."!") os.sleep(3) end
		if parm == "side" then pushSide = args[pos+1] buffSide=sides[pushSide] print('Сторона выталкивания: '..pushSide..'\nСторона буфера: '..buffSide) os.sleep(3) end
		if parm == "type" then 
			if args[pos+1] == "lithium" then 
				reactorType=1 
				changeType(1)
				print("Тип реактора установлен на литиевый")
				reactorTypeString='lithium'
			elseif args[pos+1] == "default" then 
				changeType(0)
				print("Тип реактора установлен на стандартный") reactorType=0
				reactorTypeString='default'
			else 
				changeType(0) 
				print("Неверный тип реактора: "..args[pos+1].."\nустановлено значение default") 
				reactorTypeString='default'
			end 
			os.sleep(3) 
		end
	end
end
r.setOutput(1, r_signal and 15 or 0)
gpu.fill(1,1,160,50," ")
event.shouldInterrupt = function() return false end
startTime = math.floor(computer.uptime())
while true do
	name,_,_,code=event.pull(0.01,"key_down")
	if code == 74 then
		gpu.fill(1,1,160,50," ")
		r.setOutput(1, 0) print("Реактор отключён!")
		break
	end	
	time = math.floor(computer.uptime() - startTime)
	if chamber.getHeat() > maxHeat and tempControl == true then
		redstone(false)
		chamber.pushItem(buffSide,46,_,35)
		while chamber.getHeat() > maxHeat do
			gpu.fill(1,1,35,11," ")
			gpu.set(8,4,"Охлаждение реактора!")
			gpu.set(8,6,"Temp: "..tostring(chamber.getHeat()).."/"..tostring(maxHeat))
			slot = find("reactorVentGold")
			os.sleep(1)
			if slot then
				crystal.pushItem(pushSide,slot,1,46)
			else
				print('Нечем охлаждать!')
				crystal.pushItem(pushSide,35,1,46)
				os.exit()
			end
		end
		chamber.pushItem(buffSide,46)
		crystal.pushItem(pushSide,35,1,46)
	end	
	if dsu.getStoredItems().qty < 10 then
		print("Недостаточно кондеров!")
		redstone(false)
		os.exit()
	end	
	items = chamber.getAllStacks(false)
	for _, i  in pairs(LZN) do
		if not items[i] or items[i].dmg >= 9000 then
			redstone(false)
			os.sleep(ebal_ya_w_rot_nizky_tps)
			chamber.pushItem(pushSide, i)
			dsu.pushItem("UP", 3, 1, i)
			counter = counter + 1
			os.sleep(ebal_ya_w_rot_nizky_tps)
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
			slot = find("reactorUraniumQuad") or find("reactorMOXQuad") or find("reactorUraniumQuad",108,37) or find("reactorMOXQuad",108,37)
			if slot ~= false then
				crystal.pushItem(pushSide,slot,1,i)
			end	
		end	
	end
	if reactorType == 1 then
		for _,i in pairs(lithium) do
			if not items[i] then
				slot = find("reactorLithiumCell") or find("reactorLithiumCell",108,37)
				if slot ~= false then
					crystal.pushItem(pushSide,slot,1,i)
				end	
			end	
		end
	end
	redstone(true)
	gpu.set(3,2, "Лазурита потрачено: "..(counter*9).."       ")
	gpu.set(3,4, "Выход: "..math.floor(chamber.getEUOutput()*5).." EU/t")
	gpu.set(3,6, "Время работы: "..time.." секунд(ы)")
	gpu.set(3,8, "Temp: "..tostring(chamber.getHeat()).."/"..tostring(maxHeat))
	gpu.set(3,9, "Reactor type: "..reactorTypeString)
	gpu.set(7,11, "Reactor Version: "..version)
end	

--1 цикл 21800 лазурита // 1,09 лазурита в секунду // 20000 секунд в 1 цикле