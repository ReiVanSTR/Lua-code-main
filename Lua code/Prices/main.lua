local com = require("component")
local event = require("event")
local chat = com.chat_box
local serial = require("serialization")
local text = require("text")
local gpu = com.gpu
chat.setName("§r§6Барыга Артём§7§l")
chat.setDistance(5)
itemCounter = 0
buff = ""
costs = {}
for line in io.lines("/home/pricesList") do
	buff = buff..line
end	
costs = serial.unserialize(buff)
buff = ""
pexList = {}
for line in io.lines("/home/accessList") do
	buff = buff..line
end	
pexList=serial.unserialize(buff)
buff = ""
-- logs = {}
-- for line in io.lines("/home/accessList") do
-- 	buff = buff..line
-- end	
-- logs=serial.unserialize(buff)
function costScrypt()
	gpu.set(45, 1, "Items added: "..itemCounter)
	_, add, msgNick, msg = event.pull(1,"chat_message")
	for k in pairs(pexList) do
		if msgNick == pexList[k].nick then
			modNick = pexList[k].nick
			modLvl = pexList[k].lvl
		end	
	end	

	--Access Test
	if msg == "#test" and msgNick == modNick and modLvl >=1 then 	
		chat.say("§3Привет, §9"..msgNick.."§3! Тебе тут рады :D")
		if modLvl == 1 then
			color = "§2"
			pexTier = " Низкий"
		elseif modLvl == 2 then
			color = "§6"	
			pexTier = " Средний"
		elseif modLvl == 3 then
			color = "§4"	 
			pexTier = " Высокий"
		elseif modLvl == 4 then
			color = "§5"	
			pexTier = " Админь"
		end	
		chat.say("§3Твой уровень доступа: "..color..pexTier)
		costScrypt()
	end	

	--Show all
	if msg == "#showAll" and msgNick == modNick then
		if modLvl < 3 then
			chat.say("§4Низкий уровень доступа! §3Требуется §4высокий §3или §9Админь§3!")
			costScrypt()
		end
		chat.say("§3======[§9 Доступные минималки§3 ]======")
		for k in pairs(costs) do
			chat.say("§3Id §6"..costs[k].id.."§3. Price §2"..costs[k].price.."§3.")
		end	
		chat.say("§3======[§9 Всего позиций: §6"..#costs.." §3 ]======")
		costScrypt()
	end
	--Add item
	if msg ~= nil then
		command = text.tokenize(msg)
		if command[1] == "#add" and msgNick == modNick and modLvl >=1 then
			if command[2] == nil or command[3] == nil then 
				chat.say("§4Неверные агрументы!")
				costScrypt()
			end
				for k in pairs(costs) do
					if costs[k].id == command[2] then
						chat.say("§3Предмет с id §6"..command[2].."§3. Уже существует!")
						costScrypt()
					end	
				end
			itemCounter = itemCounter + 1
			table.insert(costs, {id=command[2],price=command[3]})
			print(modNick.." succesfull added item with id "..command[2])
			tableSave(costs, "pricesList")
			chat.say("§3Добавлен предмет с id §6"..command[2].."§3. Стоимость: §2"..command[3].."§3 эмов")
			costScrypt()
		end	 

	--Edit item
	if command[1] == "#edit" and msgNick == modNick then
		if modLvl < 2  then
			chat.say("§4Низкий уровень доступа! §3Требуется §6cредний §3и выше!")
			costScrypt()
		end
		if command[2] == nil or command[3] == nil then 
			chat.say("§4Неверные агрументы!")
			costScrypt()
		end
			for k in pairs(costs) do
				if costs[k].id == command[2] then
					table.remove(costs, k)
					table.insert(costs, {id=command[2],price=command[3]})
					print(modNick.." succesfull changed item with id "..command[2])
					tableSave(costs, "pricesList")
					chat.say("§3Предмет с id §6"..command[2].."§3. Успешно изменен!")
					costScrypt()
				end	
			end
			chat.say("§3Предмет с id §6"..command[2].."§3. Не найден")
			costScrypt()
		end	
	end	

	--Remove item
	if msg ~= nil then
		command = text.tokenize(msg)
		if command[1] == "#rm" and msgNick == modNick then
			if modLvl < 3  then
				chat.say("§4Низкий уровень доступа! §3Требуется §4высокий §3и выше!")
				costScrypt()
			end
			if command[2] == nil then 
				chat.say("§4Неверные агрументы!")
				costScrypt()
			end
			for k in pairs(costs) do
				if costs[k].id == command[2] then
					table.remove(costs, k)
					print(modNick.." succesfull removed item with id "..command[2])
					tableSave(costs, "pricesList")
					chat.say("§3Предмет с id §6"..command[2].."§3. Успешно удалён!")
					costScrypt()
				end	
			end
			chat.say("§3Предмет с id §6"..command[2].."§3. Не найден")
			costScrypt()
		end	
	end	

	--Add Access
	if msg ~= nil then
		command = text.tokenize(msg)
		if command[1] == "#addAccess" and msgNick == modNick then
			if modLvl < 4 then
				chat.say("§4Низкий уровень доступа! §3Требуется §5Админь§3!")
				costScrypt()
			end
			if command[2] == nil or command[3] == nil then 
				chat.say("§4Неверные агрументы!")
				costScrypt()
			end
			isMod = false
			for k in pairs(pexList) do
				if command[2] == pexList[k].nick then
					buffLvlMod = pexList[k].lvl
					buffNickMod = pexList[k].nick
					isMod = true
				end	
			end
			buffLvl = tonumber(command[3])
			if buffLvl == 1 then
				color = "§2"
				pexTier = " Низкий"
			elseif buffLvl == 2 then
				color = "§6"	
				pexTier = " Средний"
			elseif buffLvl == 3 then
				color = "§4"	
				pexTier = " Высокий"
			elseif buffLvl == 4 then
				color = "§5"	
				pexTier = " Админь"
			end
			if buffLvl == buffLvlMod and isMod == true then
				chat.say("§3Модератор §9"..buffNickMod.." §3уже имеет этот уровень доступа!")
				costScrypt()
			end	
			if isMod == false then
				action = " §3выдал доступ"
				table.insert(pexList, {nick=command[2],lvl=buffLvl})	
				print(modNick.." added moder with nick "..command[2])
				tableSave(pexList, "accessList")
				chat.say("§3Админь §5"..modNick.." §3выдал доступ"..color..pexTier.."§3 игроку §9"..command[2])
				costScrypt()	
			end	
			if buffLvl > buffLvlMod then
				action = " §3повысил доступ до"
				table.remove(pexList, k)
				table.insert(pexList, {nick=command[2],lvl=buffLvl})	
				print(modNick.." raised moder with nick "..command[2])
				tableSave(pexList, "accessList")
				chat.say("§3Админь §5"..modNick..action..color..pexTier.."§3 игроку §9"..command[2])
				costScrypt()
			elseif buffLvl < buffLvlMod then
				action = " §3понизил доступ до"
				table.remove(pexList, k)
				table.insert(pexList, {nick=command[2],lvl=buffLvl})	
				print(modNick.." lowered moder with nick "..command[2])
				tableSave(pexList, "accessList")
				chat.say("§3Админь §5"..modNick..action..color..pexTier.."§3 игроку §9"..command[2])
				costScrypt()
			end
		end
	end	

	--Remove Access
	if msg ~= nil then
		command = text.tokenize(msg)
		if command[1] == "#rmAccess" and msgNick == modNick then
			if modLvl < 4 then
				chat.say("§4Низкий уровень доступа! §3Требуется §5Админь§3!")
				costScrypt()
			end
			if command[2] == nil then 
				chat.say("§4Неверные агрументы!")
				costScrypt()
			end
			for k in pairs(pexList) do
				if pexList[k].nick == command[2] then	
					table.remove(pexList, k)
					tableSave(pexList, "accessList")
					print(modNick.." removed access from moder "..command[2])
					chat.say("§3Админь §5"..modNick.." §3 отжал права у§9 "..command[2])
					costScrypt()
				end	
			end	
			chat.say("§3Модератор с ником §9"..command[2].." §3не найден в списке =(")
			costScrypt()
		end
	end	

	--Calc
	if msg ~= nil then
		command = text.tokenize(msg)
		if command[1] == "#count help" then	
			chat.say("§3Для расчёта цены из эмов в ресурс используйте команду §6#count")
			chat.say("§3Где ")
			costScrypt()
		end
	end	

	--Time out	
	if msg == nil then
		costScrypt()
	end

	--I dont know
	if msg ~= nil then
		for k in pairs(costs) do
			if msg == costs[k].id then
				chat.say("§3Цена этого предмета: ".."§2"..costs[k].price.." §3эм(a/ов)")
				costScrypt()
			end
		end	
		chat.say("§3Впервые слышу о таком предмете :(")	
		costScrypt()	
	end	
end
function tableSave(tbl, filename)
	local  f, err = io.open(filename, "w")
	if not f then
		return nil, err
	end
	tbl = serial.serialize(tbl) 
	f:write(tbl)	
	f:close()
	return true
end
costScrypt()
