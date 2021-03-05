local com = require("component")
local gpu = com.gpu
local sens = com.openperipheral_sensor
local red = com.redstone
local event = require("event")
local chat = com.chat_box
--Main variable
chat.setName("§r§6Трактирщик Артём§7§l")
lable = "[Event Control]"
bio = "[by ReiVanSTR]"
mainWidth = 60
mainHeight = 22
guiColor = 0xa5a5a5
bioColor = 0xff9200
doorStatus = false
playersForStart = 10

-- Rules & Lore
rulesList = {
	"§4Запрещено §3брать любые вещи §3на ивент. §6Наказание - §3кик с ивента",
	"§4Запрещено §3использовать эксплойты и недоработки §3карты. §6Наказание - §3бан на время проведения ивента",
	"§4Запрещено §3препятствовать прохождению ивента §3(Воровать вещи можно). §6Наказание - §3кик с ивента",
	"§4Запрещены §3любые действия направленные на §3дистабилизацию экономики ивента. §6Наказание - §3бан на вермя проведения ивента"
} 
loreList={

}

--Permissions & colors
modColor = 0xff0000
helperColor = 0x00DB00
builderColor = 0x00ffff
modList= {
	{nick = "ReiVanSTR", color = modColor},
	{nick = "feod0r", color = 0x336Dff},
	{nick = "Raidy1Y", color = 0xff6D00},
	{nick = "Black_Vizor", color = helperColor},
	{nick = "Nithmare", color = builderColor},
	{nick = "Molwin_", color = builderColor},
	{nick = "NecroXi", color = modColor},
	{nick = "oGoOgO", color = builderColor}
}
+
topList = {
	{nick="Nithmare",atch="МногА"}
}

function gui()
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
	
	gpu.set(30, 8,"=====")
	gpu.setForeground(bioColor)
	gpu.set(35, 8, "[Таблица лидеров]")
	gpu.setForeground(guiColor)
	gpu.set(52, 8, "=====")
	gpu.set(31, 9, "=====")
	gpu.setForeground(0x6649ff)
	gpu.set(36, 9, "[Ник]")
	gpu.setForeground(guiColor)
	gpu.set(41, 9, "=====|=")
	gpu.setForeground(0x6649ff)
	gpu.set(48, 9, "[Побед]")
	gpu.setForeground(guiColor)
	gpu.set(55, 9, "=")
	yT = 10
	for i=1, 11 do
		gpu.set(46, yT, "|")
		yT = yT + 1
	end	
	yT = 9
	for i=1, 12 do
		gpu.set(30, yT, "|")
		gpu.set(56, yT, "|")
		yT = yT + 1
	gpu.set(30, 21, "===========================")	
	end	
	yT = 10
	for k in pairs(topList) do
		topName = topList[k].nick
		topAtch = topList[k].atch
		sl = string.len(topName)
		sl = (15-sl)/2
		gpu.setForeground(0xccb600)
		gpu.set(31+sl, yT, ""..topName)
		gpu.set(48, yT, ""..topAtch)
		gpu.setForeground(guiColor)
		yT = yT + 1
	end		
end

function info()
	gpu.setForeground(bioColor)
	gpu.set(4, 3, "Игроки:")
	gpu.setForeground(guiColor)
	name = sens.getPlayers()
	y = 4
	playersLeftCounter = 1
	for i=1, #name do
		isMod = false
		for k in pairs(modList) do
			if name[i].name == modList[k].nick then
				isMod = true
				gpu.setForeground(modList[k].color)
				gpu.set(4, y, modList[k].nick.."          ")
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
	playersLeft = playersForStart + 1 - playersLeftCounter 
	gpu.setForeground(0x6649ff)
	gpu.set(30, 6, "Необходимо игроков: ")
	gpu.setForeground(0xccb600)
	gpu.set(50, 6, ""..playersLeft.." ")
	if playersLeft <= 0 then
		gpu.setForeground(0x00DB00)
		gpu.set(50, 6, "Начинаем!")
	end	
end

function status()
	gpu.setForeground(bioColor)
	gpu.set(30, 3, "Информация об ивенте:")
	gpu.setForeground(guiColor)
	gpu.setForeground(0x6649ff)
	gpu.set(30, 4, "Состояние ивента: ")
	if doorStatus == true then
		gpu.setForeground(0x00DB00)
		gpu.set(48, 4, "Запущен!   ")
		gpu.setForeground(guiColor)
	else
		gpu.setForeground(0xccb600)
		gpu.set(48, 4, "Ожидание...")
		gpu.setForeground(guiColor)	
	end	
end
function events()
	_, add, msgNick, msg = event.pull(1,"chat_message")
	cl = com.list("redstone")
	comListRedstone = {}
	for k in pairs(cl) do table.insert(comListRedstone, k) end
	rs1 = com.proxy(comListRedstone[1])
	rs2 = com.proxy(comListRedstone[2])
	for k in pairs(pexList) do 
		if msgNick == pexList[k].nick then
			pexNick = pexList[k].nick
			pexLvl = pexList[k].lvl
		end
	end
	if msg == "#start" and msgNick == pexNick and pexLvl >=2 then 	
		t = 9
		chat.say("§3Начало через: §4 10")
		os.sleep(2)
		for i=1, 9 do
			chat.say("§4"..t)
			t = t-1
			os.sleep(2)
		end	
		chat.say("§2Go! Go! Go!")
		rs1.setOutput(1, 15)
		rs2.setOutput(1, 15)
		doorStatus = true
	end	
	if msg == "#close" and msgNick == pexNick and pexLvl >=1 then 	
		rs1.setOutput(1, 0)
		rs2.setOutput(1, 0)
		doorStatus = false
	end	
end		 
	--if msg == "#lore" and msgNick == pexNick and pexLvl >= 1 then lore() end
	--if msg == "#start" and msgNick == pexNick and pexLvl >=1 then end
gpu.fill(1, 1, mainWidth, mainHeight, " ")

while true do
	gui()
	info()
	status()
	events()
	os.sleep(0.1)
end	


chat.say("§9Администратор §6"..msgNick.." §9выдал права §2"..command[2])
chat.say("§9Администратор §6"..msgNick.." §9повысил §2"..command[2])
chat.say("§9Администратор §6"..msgNick.." §9понизил §2"..command[2])
