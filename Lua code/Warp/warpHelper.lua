local com = require("component")
local event = require("event")
local chat = com.chat_box
local serial = require("serialization")
local text = require("text")
local gpu = com.gpu
timer = 299
chat.setDistance(40)
chat.setName("§r§6Помощник Артём§7§l")
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
randomMessagses = {
	"§3На варпе работает §5анти-мут§3. Для его работы пишите §3перед сообщением '§4*§3'",
	"§3У нас всегда самые лучшие цены!",
	"§3Если у Вас появились вопросы обратитесь к §7sonya12005 §7Collapss §7HenYyy §7OB1CHAM",
	"§3Хотите узнать минимальную цену? Напиши в чат §5#cost §6id §3предмета.",
	"§3§l#§6§lФедяЛучший§6§lГМ!",
	"§3Скоро будет КаЗыНо",
	"§3Интересны мои программы? Напиши мне и закажи похожее! §7§lReiVanSTR#4727"
}
function checkPex(admNick)
	for k in pairs(pexList) do
		if admNick == pexList[k].nick then
			modNick = pexList[k].nick
			modLvl = pexList[k].lvl
			return true
		end	
	end
	return false
end
function checkItem(id)
	for k in pairs(costs) do
		if id == costs[k].id then
			chat.say("§3Цена этого предмета: ".."§2"..costs[k].price.." §3эм(a/ов)")
			return true
		end
	end	
	chat.say("§3Впервые слышу о таком предмете :(")
	return false
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
while true do
	_, add, msgNick, msg = event.pull(1,"chat_message")
	timer = timer + 1
	if timer == 300 then
		timer = 0
		chat.say(randomMessagses[math.random(1, #randomMessagses)])
	end	
	if msg ~= nil then
		if string.find(msg, "*") ~= nil	then
			chat.setName("§r§6"..msgNick.."§7§l")
			chat.say("§3"..string.sub(msg,2))
			chat.setName("§r§6Помощник Артём§7§l")
		end	
		command = text.tokenize(msg) 
		if msg == "Help" or msg == "help" then
			chat.say("§3Привет, §9"..msgNick.."§3! Тебе тут рады :D")
		end
		if command[1] == "#cost" then
			if command[2] == nil then
				chat.say("§3Неверные агрументы! §3Попробуй §6#cost §3id предмета. §6#cost 12")
			else
				checkItem(command[2])
			end		
		end	
		if msg == "#test" and checkPex(msgNick) and modLvl >=1 then 	
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
		end
		if msg == "#showAll" and checkPex(msgNick) then
			if modLvl < 3 then
				chat.say("§4Низкий уровень доступа! §3Требуется §4высокий §3или §9Админь§3!")
			else
				chat.say("§3======[§9 Доступные минималки§3 ]======")
				for k in pairs(costs) do
					chat.say("§3Id §6"..costs[k].id.."§3. Price §2"..costs[k].price.."§3.")
				end	
				chat.say("§3======[§9 Всего позиций: §6"..#costs.." §3 ]======")
			end	
		end
		if command[1] == "#add" and checkPex(msgNick) and modLvl >=1 then
			if command[2] == nil or command[3] == nil then 
				chat.say("§4Неверные агрументы!")
			else
				for k in pairs(costs) do
					if costs[k].id == command[2] then
						chat.say("§3Предмет с id §6"..command[2].."§3. Уже существует!")
					end	
				end
				table.insert(costs, {id=command[2],price=command[3]})
				print(modNick.." succesfull added item with id "..command[2])
				tableSave(costs, "pricesList")
				chat.say("§3Добавлен предмет с id §6"..command[2].."§3. Стоимость: §2"..command[3].."§3 эмов")
			end
		end
		if command[1] == "#edit" and checkPex(msgNick) then
			if modLvl < 2  then
				chat.say("§4Низкий уровень доступа! §3Требуется §6cредний §3и выше!")
			else
				if command[2] == nil or command[3] == nil then 
					chat.say("§4Неверные агрументы!")
				else
					for k in pairs(costs) do
						if costs[k].id == command[2] then
							table.remove(costs, k)
							table.insert(costs, {id=command[2],price=command[3]})
							print(modNick.." succesfull changed item with id "..command[2])
							tableSave(costs, "pricesList")
							chat.say("§3Предмет с id §6"..command[2].."§3. Успешно изменен!")
						end	
					end
				end	
			end	
		end
		if command[1] == "#rm" and msgNick == modNick then
			if modLvl < 3  then
				chat.say("§4Низкий уровень доступа! §3Требуется §4высокий §3и выше!")
			else
				if command[2] == nil then 
					chat.say("§4Неверные агрументы!")
				else
					for k in pairs(costs) do
						if costs[k].id == command[2] then
							table.remove(costs, k)
							print(modNick.." succesfull removed item with id "..command[2])
							tableSave(costs, "pricesList")
							chat.say("§3Предмет с id §6"..command[2].."§3. Успешно удалён!")
						end	
					end
				end
			end		
		end
		if command[1] == "#addAccess" and checkPex(msgNick) then
			if modLvl < 4 then
				chat.say("§4Низкий уровень доступа! §3Требуется §5Админь§3!")
			else
				if command[2] == nil or command[3] == nil then 
					chat.say("§4Неверные агрументы!")
				else
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
					else
						if isMod == false then
							action = " §3выдал доступ"
							table.insert(pexList, {nick=command[2],lvl=buffLvl})	
							print(modNick.." added moder with nick "..command[2])
							tableSave(pexList, "accessList")
							chat.say("§3Админь §5"..modNick.." §3выдал доступ"..color..pexTier.."§3 игроку §9"..command[2])	
						end	
						if buffLvlMod ~= nil and buffLvl > buffLvlMod then
							action = " §3повысил доступ до"
							table.remove(pexList, k)
							table.insert(pexList, {nick=command[2],lvl=buffLvl})	
							print(modNick.." raised moder with nick "..command[2])
							tableSave(pexList, "accessList")
							chat.say("§3Админь §5"..modNick..action..color..pexTier.."§3 игроку §9"..command[2])
						elseif  buffLvlMod ~= nil and buffLvl < buffLvlMod then
							action = " §3понизил доступ до"
							table.remove(pexList, k)
							table.insert(pexList, {nick=command[2],lvl=buffLvl})	
							print(modNick.." lowered moder with nick "..command[2])
							tableSave(pexList, "accessList")
							chat.say("§3Админь §5"..modNick..action..color..pexTier.."§3 игроку §9"..command[2])
						end
					end
				end
			end			
		end
		if command[1] == "#rmAccess" and msgNick == modNick then
			if modLvl < 4 then
				chat.say("§4Низкий уровень доступа! §3Требуется §5Админь§3!")
			else
				if command[2] == nil then 
					chat.say("§4Неверные агрументы!")
				else
					isRemoved = false
					for k in pairs(pexList) do
						if pexList[k].nick == command[2] then	
							table.remove(pexList, k)
							tableSave(pexList, "accessList")
							print(modNick.." removed access from moder "..command[2])
							chat.say("§3Админь §5"..modNick.." §3 отжал права у§9 "..command[2])
							isRemoved = true
						end	
					end
					if not isRemoved then
						chat.say("§3Модератор с ником §9"..command[2].." §3не найден в списке =(")
					end
				end
			end			
		end	
	end
end	