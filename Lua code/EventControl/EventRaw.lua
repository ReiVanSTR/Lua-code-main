local component = require("component")
local gpu = component.gpu
local sensor = component.openperipheral_sensor
local serial = require("serialization")
local event = require("event")
local chat = component.chat_box
local text = require("text")
function Variables()
	lable = "[ Event Control ]"
	bio = "[ by ReiVanSTR ]"
	chatColors = {{id="modColor",color="§4"},{id="helperColor",color="§2"},{id="adminColor",color="§6"},{id="builderColor",color="§3"}}
	colorsRGB = {{id="modColor",color=0xff0000},{id="helperColor",color=0x00DB00},{id="adminColor",color=0x336Dff},{id="builderColor",color=0x00ffff}}
	playersPos = {x=(mWidth/20)*2, y=(mHeight/10)} -- players Pos
	topsPos = {x=(mWidth/2)-3, y=15}
	chat.setName("§r§6Ведущий Артём§7§l")
end
function Resolution(width, height)
	mWidth = width*20
	mHeight = height*10
	gpu.setResolution(mWidth, mHeight)
	gpu.fill(1,1,160,50," ")
end
function getTables()
	-- Load ModList
	buff = ""
	modList = {}
	for line in io.lines("/home/modList") do
		buff = buff..line
	end	
	modList = serial.unserialize(buff)
	-- Load TopList
	buff = ""
	TopList = {}
	for line in io.lines("/home/topList") do
		buff = buff..line
	end	
	topList = serial.unserialize(buff)
end	
function Colors()
	guiColor = 0xa5a5a5
	bioColor = 0xff9200
end	
function Gui()
	local y = 2 -- Start Y position
	local lableSize = string.len(lable) -- Lable width
	local lableX = (mWidth-lableSize)/2 -- Lable X position
	local bioSize = string.len(bio) -- bio width
	local bioX = (mWidth-bioSize)/5	-- bio X position
	gpu.setForeground(guiColor)
	gpu.fill(1,1,mWidth,1,"=") -- Gui border
	gpu.fill(1,mHeight,mWidth,1,"=")
	for i=1, mHeight-2 do
		gpu.set(1, y, "|")
		gpu.set(mWidth, y, "|")
		y=y+1
	end	
	gpu.setForeground(bioColor) -- Lable & bio
	gpu.set(lableX, 1, lable)
	gpu.set(bioX, mHeight, bio)
	gpu.set(playersPos.x, playersPos.y, "Игроки: ")
	gpu.setForeground(guiColor)
	gpu.fill(topsPos.x, topsPos.y+12, 31, 1, "=")
	gpu.fill(topsPos.x, topsPos.y+1, 31, 1, "=")
	gpu.fill(topsPos.x+15, topsPos.y+1, 1, 11, "|")
	gpu.setForeground(0x6649ff)
	gpu.set(topsPos.x+5, topsPos.y+1, "[ Ник ]")
	gpu.set(topsPos.x+19, topsPos.y+1, "[ Побед ]")
	gpu.setForeground(guiColor)	
	y=topsPos.y
	for i=1, 12 do
		gpu.set(topsPos.x, y, "|")
		gpu.set(topsPos.x+30, y, "|")
		y=y+1
	end
	gpu.fill(topsPos.x, topsPos.y, 31, 1, "=")
	gpu.setForeground(bioColor)
	gpu.set(topsPos.x+6, topsPos.y, "[ Таблица лидеров ]")
	gpu.setForeground(guiColor)	
end
function Players()
	names = sensor.getPlayers()
	local y = playersPos.y + 1
	for i=1, #names do
		local isMod = false
		for k in pairs(modList) do
			if names[i].name == modList[k].nick then
				gpu.setForeground(modList[k].color)
				gpu.set(playersPos.x, y, modList[k].nick.."          ")
				y=y+1
				isMod = true
				gpu.setForeground(guiColor)
			end	
		end	
		if isMod == false then
			gpu.setForeground(0xffffff)
			gpu.set(playersPos.x, y, names[i].name.."          ")
			y=y+1
			gpu.setForeground(guiColor)
		end	
	end
	a = y
	for i=a, mHeight-playersPos.y-1 do
		gpu.fill(playersPos.x, y, 15, 1, " ")
		y = y + 1
	end
end
function Events()
	local _, _, msgNick, msg = event.pull(1,"chat_message")
	local y = playersPos.y + 1
	for k in pairs(modList) do
		if msgNick == modList[k].nick then
			modNick = modList[k].nick
			modClr = modList[k].color
			modLvl = modList[k].lvl
		end	
	end
	if msg == nil then
		start()
	end	
	if msg ~= nil then
		command = text.tokenize(msg)
		--Access add
		if command[1] == "#addAccess" and msgNick == modNick  then
			local isMod = false
			if modLvl < 4 then
				chat.say("§3"..msgNick.."§9 Тебе тут не рады")
				start()
			end	
			if command[2] == nil or command[3] == nil or command[4] == nil then
				chat.say("§9Cлишком мало аргументов!")
				start()
			end	
			for k in pairs(modList) do
				if command[2] == modList[k].nick then
					buffNick = modList[k].nick
					buffLvl = modList[k].lvl
					isMod = true
				end	
			end
			for c in pairs(colorsRGB) do
				if command[4] == colorsRGB[c].id then
					buffColor = colorsRGB[c].color
				end	
			end
			if buffColor == nil then
				buffColor = 0xffffff
			end	
			buff = tonumber(command[3])
			if isMod == true and buff == buffLvl then
				chat.say("§3Игрок §9"..buffNick.." §3уже имеет этот уровень доступа!")
				start()
			end	
			if isMod == false then
				table.insert(modList, {nick=command[2],lvl=buff,color=buffColor})	
				tableSave(modList, "modList")
				chat.say("§9Администратор §6"..msgNick.." §9выдал права §2"..command[2])
				start()	
			end	
			if buff > buffLvl then
				table.remove(modList, k)
				table.insert(modList, {nick=command[2],lvl=buff,color=buffColor})	
				tableSave(modList, "modList")
				chat.say("§9Администратор §6"..msgNick.." §9повысил §2"..command[2])
				start()
			elseif buff < buffLvl then
				table.remove(modList, k)
				table.insert(modList, {nick=command[2],lvl=buff,color=buffColor})	
				tableSave(modList, "modList")
				chat.say("§9Администратор §6"..msgNick.." §9понизил §2"..command[2])
				start()
			end
		end	
		--Access Remove
		if command[1] == "#rmAccess" and msgNick == modNick then
			if modLvl < 4 then
				chat.say("§9Низкий уровень доступа!")
				start()
			end
			if command[2] == nil then 
				chat.say("§4Неверные агрументы!")
				start()
			end
			for k in pairs(modList) do
				if modList[k].nick == command[2] then	
					table.remove(modList, k)
					tableSave(modList, "accessList")
					chat.say("§9Администратор §6"..msgNick.." §9забрал права у §2"..command[2])
					start()
				end	
			end	
			chat.say("§9Игроу с ником §2"..command[2].." §9не найден в списке модерации =(")
			start()
		end
		--Add top	
		if command[1] == "#addTop" and msgNick == modNick then
			if modLvl < 2 then
				chat.say("§9Низкий уровень доступа!")
				start()
			end
			if command[2] == nil or command[3] == nil then 
				chat.say("§4Неверные агрументы!")
				start()
			end
			for k in pairs(modList) do
				if modList[k].nick == command[2] then	
					table.remove(modList, k)
					tableSave(modList, "accessList")
					chat.say("§9Администратор §6"..msgNick.." §9забрал права у §2"..command[2])
					start()
				end	
			end	
			chat.say("§9Игрок с ником §2"..command[2].." §9не найден в списке модерации =(")
			start()
		end
	else
		start()
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
function start()
	Players()
	Events()
end
Resolution(3,3)
getTables()
Colors()
Variables()
Gui()
start()

