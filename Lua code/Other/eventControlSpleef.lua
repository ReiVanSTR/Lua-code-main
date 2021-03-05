local com = require("component")
local gpu = com.gpu
local sens = com.openperipheral_sensor
local red = com.redstone
local event = require("event")
local chat = com.chat_box
local serial = require("serialization")
--Main variable
chat.setName("§r§6Cплифер Артём§7§l")
lable = "[ Event Control ]"
bio = "[ by ReiVanSTR ]"
mainWidth = 80
mainHeight = 22
guiColor = 0xa5a5a5
bioColor = 0xff9200
doorStatus = false
playersForStart = 6
red.setOutput(0, 1)
round = 5
roundCounter = 1
--Colors
modColor = 0xff0000
helperColor = 0x00DB00
builderColor = 0x00ffff
function getTables()
	-- Load ModList
	buff = ""
	modList = {}
	for line in io.lines("/home/modList") do
		buff = buff..line
	end	
	modList = serial.unserialize(buff)

	-- Load AccessList
	buff = ""
	accessList = {}
	for line in io.lines("/home/accessList") do
		buff = buff..line
	end	
	accessList = serial.unserialize(buff)

	-- Load TopList
	buff = ""
	TopList = {}
	for line in io.lines("/home/topList") do
		buff = buff..line
	end	
	topList = serial.unserialize(buff)
end

function gui()
	-- Отрисовываем окантовку
	gpu.setForeground(bioColor)
	gpu.set(mainWidth/10, 3, "Игроки:")
	gpu.setForeground(guiColor)
	gpu.setResolution(mainWidth, mainHeight)
	ls = string.len(lable) -- lable size
	w = mainWidth/2 - (ls/2)
	gpu.fill(1, 1, w, 1, "=")
	gpu.setForeground(bioColor)
	gpu.set(w, 1, lable)
	gpu.setForeground(guiColor)
	x=w+ls
	w = mainWidth - w
	gpu.fill(x, 1, w, 1, "=")

	bs = string.len(bio)
	w = mainWidth/4 - (bs/2)
	gpu.fill(1, mainHeight, w, 1, "=")
	gpu.setForeground(bioColor)
	gpu.set(w, mainHeight, bio)
	gpu.setForeground(guiColor)
	x=w+bs
	w = mainWidth - w
	gpu.fill(x, mainHeight, w, 1, "=")
	y=2
	for i=1, mainHeight-2 do
		gpu.set(1, y, "|")
		gpu.set(mainWidth, y, "|")
		y=y+1
	end

	--Отрисовываем таблицу лидеров
	topX = mainWidth*0.6
	gpu.set(topX, 8,"=====")
	gpu.setForeground(bioColor)
	gpu.set(topX+5, 8, "[Таблица лидеров]")
	gpu.setForeground(guiColor)
	gpu.set(topX+22, 8, "=====")
	gpu.set(topX+1, 9, "=====")
	gpu.setForeground(0x6649ff)
	gpu.set(topX+6, 9, "[Ник]")
	gpu.setForeground(guiColor)
	gpu.set(topX+11, 9, "=====|=")
	gpu.setForeground(0x6649ff)
	gpu.set(topX+18, 9, "[Побед]")
	gpu.setForeground(guiColor)
	gpu.set(topX+25, 9, "=")
	yT = 10
	for i=1, 11 do
		gpu.set(topX+16, yT, "|")
		yT = yT + 1
	end	
	yT = 9
	for i=1, 12 do
		gpu.set(topX, yT, "|")
		gpu.set(topX+26, yT, "|")
		yT = yT + 1
	gpu.set(topX, 21, "===========================")	
	end	
	yT = 10
	for k in pairs(topList) do
		topName = topList[k].nick
		topWins = topList[k].wins
		sl = string.len(topName)
		sl = (15-sl)/2
		gpu.setForeground(0xccb600)
		gpu.set(topX+1+sl, yT, ""..topName)
		gpu.set(topX+18, yT, ""..topWins)
		gpu.setForeground(guiColor)
		yT = yT + 1
	end	

	--Отрисовываем инфу об ивенте
	gpu.setForeground(bioColor)
	gpu.set(topX, 3, "Информация об ивенте:")
	gpu.setForeground(guiColor)
	gpu.setForeground(0x6649ff)
	gpu.set(topX, 4, "Состояние ивента: ")
	if doorStatus == true then
		gpu.setForeground(0x00DB00)
		gpu.set(topX+18, 4, "Запущен!   ")
		gpu.setForeground(guiColor)
	else
		gpu.setForeground(0xccb600)
		gpu.set(topX+18, 4, "Ожидание...")
		gpu.setForeground(guiColor)	
	end

	--Получаем/красим игроков
	name = sens.getPlayers()
	y = 4
	playersLeftCounter = 1
	for i=1, #name do
		isMod = false
		for k in pairs(modList) do
			if name[i].name == modList[k].nick then
				isMod = true
				gpu.setForeground(modList[k].color)
				gpu.set(mainWidth/10, y, modList[k].nick.."          ")
				y=y+1	
			end
		end	
		if isMod ~= true then
			gpu.setForeground(0xffffff)
			gpu.set(4, y, name[i].name.."          ")
			y=y+1
			playersLeftCounter = playersLeftCounter + 1
		end		
	end	
	a = y + 1
	for i=a, 18 do
		gpu.fill(4, y, 15, 1, " ")
		y = y + 1
	end	

	--Считаем кол-во игроков для старта
	playersLeft = playersForStart + 1 - playersLeftCounter 
	gpu.setForeground(0x6649ff)
	gpu.set(topX, 6, "Необходимо игроков: ")
	gpu.setForeground(0xccb600)
	gpu.set(topX+20, 6, ""..playersLeft.." ")
	if doorStatus == true then 
		gpu.set(topX+20, 6, "Начинаем!")
	end	
	if doorStatus ~= true and  playersLeft <= 0 then
		gpu.setForeground(0x00DB00)
		gpu.set(topX+20, 6, "Начинаем!")
	end
end
function events()
	_, add, msgNick, msg = event.pull(1,"chat_message")
	for k in pairs(accessList) do 
		if msgNick == accessList[k].nick then
			pexNick = accessList[k].nick
			pexLvl = accessList[k].lvl
		end
	end
	if msg == "#open" and msgNick == pexNick and pexLvl >=2 then 	
		chat.say("§9Вниз! Вниз! Вниз!")
		red.setOutput(0, 0)
	end	
	if msg == "#test" and msgNick == pexNick and pexLvl >=1 then 	
		chat.say("§3Привет, §9"..msgNick.."§3! Тебе тут рады :D")
		if pexLvl == 1 then
			color = "§2"
			pexTier = " Низкий"
		elseif pexLvl == 2 then
			color = "§6"	
			pexTier = " Средний"
		elseif pexLvl == 3 then
			color = "§4"	
			pexTier = " Высокий"
		end	
		chat.say("§3Твой уровень доступа: "..color..pexTier)
	end	
	if msg == "#close" and msgNick == pexNick and pexLvl >=1 then 	
		red.setOutput(0, 1)
	end	
	if msg == "#start" and msgNick == pexNick and pexLvl >=2 then 	
		t = 5
		chat.say("§3Начало через:")
		os.sleep(2)
		for i=1, 5 do
			chat.say("§4"..t)
			t = t-1
			os.sleep(2)
		end	
		chat.say("§2Go!")
		os.sleep(1)
		chat.say("§31-й раунд начался!")
		doorStatus = true
	end	
	if msg == "#round" and msgNick == pexNick and pexLvl >=2 then 	
		chat.say("§3"..roundCounter.."-й раунд ивента окончен! §3Начало следующего через §61 §3минуту")
		roundCounter = roundCounter + 1
		if roundCounter == 5 then
			chat.say("§3 Это §4последний §3раунд ивента!")
			roundCounter = roundCounter + 1
		end	
	end
	if msg == "#stop" and msgNick == pexNick and pexLvl >=2 then 	
		chat.say("§3Ивент окончен. Спасибо за участие!")
		doorStatus = false
	end	
	if msg == "#count" and msgNick == pexNick and pexLvl >=2 then 	
		t = 5
		chat.say("§3Начало через:")
		os.sleep(2)
		for i=1, 5 do
			chat.say("§4"..t)
			t = t-1
			os.sleep(2)
		end	
		chat.say("§2Go!")
		os.sleep(1)
		chat.say("§3§3Раунд начался!")
	end
	if msg == "#addTop" and msgNick == pexNick then 	
		chat.say("§3Ивент окончен. Спасибо за участие!")
		doorStatus = false
	end
end		 
gpu.fill(1, 1, mainWidth, mainHeight, " ")
getTables()
while true do
	gui()
	events()
	os.sleep(0.1)
end	