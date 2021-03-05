local component = require("component")
local gpu = component.gpu
local event = require("event")
local computer = require("computer")
local red = component.redstone
local unicode = require("unicode")
local serial = require("serialization")
local fs = require("filesystem")
local text = require("text")
local chat = component.chat_box
local port = component.tileioport
chat.setName("§r§6Терминал №5§7§l")
chat.setDistance(40)
componentList = component.list("me_interface")
cl = {}
for k in pairs(componentList) do table.insert(cl, k) end
buff = ""	
logs = {}
for line in io.lines("/home/tradeLogs") do
	logs = buff..line
end	
logs = serial.unserialize(logs)
width = 60
height = 31
mainColor = 0xffffff
gpu.setResolution(width,height)
gpu.fill(1,1,160,50," ")
isAuthorized = false
isMainPage = false
isRulesPage = false
isOreTrade = false
isTradeable = true
isCellTaked = false
isHelpPage = false
isInfoPage = false
isDeveloperMode = false
autoExitCounter = 61
multiplier = 2.2
cellPushSide = "NORTH"
blackList = {"Taranax"}
function box(x,y,height,width,name,border,color)
	gpu.fill(x,y,width,1,"═")
	gpu.fill(x,y+height,width,1,"═")
	gpu.fill(x,y,1,height,"║")
	gpu.fill(x+width,y,1,height,"║")
	gpu.set(x,y,"╔")
	gpu.set(x,y+height,"╚")
	gpu.set(x+width,y+height,"╝")
	gpu.set(x+width,y,"╗"	)
	if color == nil then
		textColor = 0xffffff
	else
		textColor = color
	end	
	gpu.setForeground(textColor)
	if name ~= nil then
		if border == nil then
			gpu.set(x+math.ceil((width-unicode.len(name))/2),y,name)
		end
		if border ~= nil then
			gpu.set(x+math.ceil((width-unicode.len(name..border..border))/2),y,border..name..border)
		end
	end
	gpu.setForeground(0xffffff)
end
function setChar(mass1, mass2) -- {{x,y},{x,y}}, {char}
	for k=1, #mass1 do
		gpu.set(mass1[k][1],mass1[k][2],mass2[k])
	end	
end
function button(x,y,height,text)
	gpu.fill(x,y,unicode.len(text)+3,1,"═")
	gpu.fill(x,y+height,unicode.len(text)+3,1,"═")
	gpu.fill(x,y,1,height,"║")
	gpu.fill(x+unicode.len(text)+3,y,1,height,"║")
	gpu.set(x,y,"╔")
	gpu.set(x,y+height,"╚")
	gpu.set(x+unicode.len(text)+3,y,"╗")
	gpu.set(x+unicode.len(text)+3,y+height,"╝")
	gpu.set(x+2,y+math.floor(height/2),text)
	mass={x,x+unicode.len(text)+3,y,y+height}
	return mass
end
function pressButton(w,h,mass)
	local x,x1,y,y1 = mass[1], mass[2], mass[3], mass[4]
	if w >= x and w <= x1 and h >= y and h <= y1 then
		return true
	end	
	return false
end
function GetHostTime(timezone) --Получить текущее реальное время компьютера, хостящего сервер майна
    timezone = timezone or 2
    local file = io.open("/HostTime.tmp", "w")
    file:write("123")
    file:close()
    local timeCorrection = timezone * 3600
    local lastModified = tonumber(string.sub(fs.lastModified("/HostTime.tmp"), 1, -4)) + timeCorrection
    fs.remove("HostTime.tmp")
    local year, month, day, hour, minute, second = os.date("%Y", lastModified), os.date("%m", lastModified), os.date("%d", lastModified), os.date("%H", lastModified), os.date("%M", lastModified), os.date("%S", lastModified)
    return tonumber(day), tonumber(month), tonumber(year), tonumber(hour), tonumber(minute), tonumber(second)
end
function time(timezone) --Получет настоящее время, стоящее на Хост-машине
    local time = {getHostTime(timezone)}
    local text = string.format("%d-%d  %02d:%02d:%02d",time[1], time[2], time[4], time[5], time[6])
    return text
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
function authGui()--Отрисовка кнопки автиоризации
	authButton = button(23,20,2,"Авторизация")
end
function mainGui() -- Основное меню
	rulesButton = button(10,25,2,"Правила")
	exitButton = button(40,25,2,"Выход")
	oreTrade = button(23,10,4,"Обмен 3к7 ")
	developerMode = button(53,28,2,"DM")
	infoButton = button(23,16,4,"Мои обмены")
end
function rules() -- Правила
	gpu.set(26,7,"Правила.")
    gpu.set(4,9,"1.Администрация оставляет за собой полное право")
    gpu.set(6,10,"изменять коэффициенты и соотношения для обмена")
    gpu.set(4,12,"2.Администрация имеет право менять правила на своё")
    gpu.set(6,13,"усмотрение и в любое время")
    gpu.set(4,15,"3.Откатить обмен невозможно")
    gpu.set(4,17,"4.Запрещено препятствовать обменам")
    gpu.set(4,19,"5.Всe, что не поместилось в ячейку-остается в обменнике")
    gpu.set(16,21,"Советуем использовать ячейки на 64к")
end
function getSlot(interface, target, dmg)
	if dmg == nil then
		for k=1,9 do
			if interface.getInterfaceConfiguration(k).name == target then
				return k
			end
		end
	else
		for k=1,9 do
			if interface.getInterfaceConfiguration(k).name == target and interface.getInterfaceConfiguration(k).damage == dmg then
				return k
			end
		end
	end	
	return nil	
end
function getInterfaces()
	for i=1,#cl do
		if component.proxy(cl[i]).getInterfaceConfiguration(1).name == "minecraft:iron_ingot" then
			ingotsInterface = component.proxy(cl[i])
		end
		if component.proxy(cl[i]).getInterfaceConfiguration(1).name == "minecraft:iron_ore" then
			oresInterface = component.proxy(cl[i])
		end
	end		
end
function notResourses()
	red.setOutput(4,0)
	gpu.setForeground(0xff0000)
	gpu.set(15,22,"Недостаточно ресурсов в системе!")
	gpu.setForeground(0x99ffff)
end
function colorString(x,y,color, text)
	local back = gpu.getForeground()
	gpu.setForeground(color)
	gpu.set(x,y,text)
	gpu.setForeground(back)
	nextPos=x+unicode.len(text)
	return nextPos
end
function checkOre(mass)
	if mass.size > 1000 then
		return mass.size, math.floor(mass.size*2.22), 2.22
	elseif mass.size > 310 then
		return mass.size, math.floor(mass.size*2.26), 2.26
	elseif mass.size > 5000 then
		return mass.size, math.floor(mass.size*2.28), 2.28
	elseif mass.size > 10000 then
		return mass.size, math.floor(mass.size*2.30), 2.30
	elseif mass.size > 15000 then
		return mass.size, math.floor(mass.size*2.33), 2.33
	end	
	return mass.size, math.floor(mass.size*2.2), 2.2
end
function getOut(interface, mass,stack,slot)
	if mass ~= nil then
		for i=1, math.floor(mass/stack) do
			interface.pushItem("UP",slot,stack)
		end 
		interface.pushItem("UP",slot,mass%stack)
	end	
end
function checkInBase(nick)
	for k in pairs(logs) do
		if k == nick then
			return true
		end
	end
	return false
end
function saveLog(nick, mass)
	if checkInBase(nick) then
		lable=time(2).." "..tostring(logs.transactions+1)
		logs.transactions=logs.transactions+1
		logs[nick][lable] = {}
		table.insert(logs[nick][lable], {trade=mass})
		tableSave(logs, "tradeLogs")
		return true
	else
		logs[nick] = {}
		lable=time(2).." "..tostring(logs.transactions+1)
		logs.transactions=logs.transactions+1
		logs[nick][lable] = {}
		table.insert(logs[nick][lable], {trade=mass})
		tableSave(logs, "tradeLogs")
		return true
	end	
end
function requistLog(nick)
	if checkInBase(nick) then
		logTrades = {}
		for k in pairs(logs[nick]) do
			-- local logData = text.tokenize(k)
			-- if logData[1] == date then
				table.insert(logTrades, k)
				return true, logTrades
		end	
	end
	return false	
end
function exit()
	isOreTrade = false
	isRulesPage = false
	isAuthorized = false
	isMainPage = false
	isCellTaked = false
	red.setOutput(4,0)
	autoExitCounter = 61
	computer.removeUser(authorNick)
	gpu.fill(3,3,56,28," ")
	authGui()
end
authGui()
box(1,1,30,59)
getInterfaces()

while true do
	event.shouldInterrupt = function() return false end
	e,_,w,h,_,nick = event.pull(1,"touch")
	if nick ~= nil then
		if isAuthorized == false then
			if pressButton(w,h,authButton) then
				isAuthorized = true
				authorNick = nick
				computer.addUser(authorNick)
				gpu.fill(3,3,56,28," ")
				isMainPage = true
			end
		end
	end
	if isAuthorized == true then
		while isDeveloperMode do
			_, add, msgNick, msg = event.pull(1,"chat_message")
			if msg ~= nil and msgNick == "ReiVanSTR" then
				command = text.tokenize(msg)
				if command[1] == "#checkTrade" then
					local response, logTrades = requistLog(command[2], command[3])
					if response == true then
						chat.say("Обмены игрока "..command[2])
						for _,k in pairs(logTrades) do
							chat.say(tostring(k))
						end	
					else
						chat.say("Player not found")
					end	
				end		
				if msg == "#exit" then
					isDeveloperMode = false
					mainGui()
					break
				end
				if msg == "test" then
					chat.say(tostring(#logs[1].trade))
				end	
			end
		end	
		autoExitCounter = autoExitCounter - 1	
		gpu.set(20, 4, "Автовыход через: "..autoExitCounter.."   ")	
		if isMainPage == true then
			gpu.set(16,3,"Добро пожаловать, "..authorNick.."!")
			mainGui()
			if nick ~= nil then
				if pressButton(w,h,rulesButton) then -- rulesButton
					isMainPage = false
					isRulesPage = true
					gpu.fill(3,3,56,28," ")
					rules()
					exitRulesButton = button(25,25,2,"Выход")
					autoExitCounter = 31
				end
				if pressButton(w,h,oreTrade) then -- oreTradeButton
					isOreTrade = true
					isMainPage = false
					gpu.fill(3,3,56,28," ")
				end	
				if pressButton(w,h,exitButton) then	-- exitButton
					exit()
				end
				if pressButton(w,h, developerMode) and authorNick == "ReiVanSTR" then
					isDeveloperMode = true
					gpu.fill(3,3,56,28," ")
				end	
				autoExitCounter = 61
			end		
		end
		if isInfoPage == true then
			isMainPage = false
			gpu.fill(3,3,56,28," ")
			gpu.set(10,10,tostring(requistLog("ReiVanSTR")))
		end	
		if isRulesPage == true then
			if nick ~= nil then
				if pressButton(w,h,exitRulesButton) then	--rulesExitButton
					gpu.fill(3,3,56,28," ")
					isMainPage = true
					autoExitCounter = 61
					mainGui()
				end
				autoExitCounter = 61	
			end	
		end
		if isOreTrade == true then
			DB = {
				ironOre=0, ironIngots=0, ironMultiplier=0, 
				copperOre=0, copperIngots=0, copperMultiplier=0,
				tinOre=0,tinIngots=0,tinMultiplie=0,
				goldOre=0, goldIngots=0, goldMultiplier=0,
				leadOre=0, leadIngots=0, leadMultiplier=0,
				uranOre=0, uranItem=0,
				ironInSystem=0,copperInSystem=0,tinInsystem=0,leadInSystem=0,goldInSystem=0,uranInSystem=0
			}
			tradeButton = button(24,26,2,"Обменять!")
			mainButton = button(49,26,2,"Назад")
			helpButton = button(4,26,2,"Помощь")	
			red.setOutput(4,1)
			if isCellTaked == false then
				gpu.setForeground(0xff0000)
				gpu.set(22,24,"Положите ячейку!")
				gpu.setForeground(0x99ffff)
			elseif isCellTaked == true then
				gpu.fill(22,24,15,1," ")	
			end	
			isTradeable = true
			inv=ingotsInterface.getItemsInNetwork()
			colorString(5,10,0xcc9200,"Железной руды: 0    ")
			colorString(5,12,0xcc6d00,"Медной руды: 0     ")
			colorString(5,14,0xffffC0,"Оловянной руды: 0    ")
			colorString(5,16,0xffDB00,"Золотой руды: 0    ")
			colorString(5,18,0xa5a5a5,"Свинцовой руды: 0    ")
			colorString(5,20,0x99db00,"Урановой руды: 0    ")
			for k=1,#inv do
				if inv[k].name == "minecraft:iron_ore" then
					size, output, multiplier = checkOre(inv[k])
					setChar({{colorString(5,10,0xcc9200,"Железной руды: "),10},{32,10}},{tostring(size),tostring(output).."     "})
					DB.ironOre = size
					DB.ironIngots = output
					DB.ironMultiplier = multiplier
				end
				if inv[k].name == "IC2:blockOreCopper" then
					size, output, multiplier = checkOre(inv[k])
					setChar({{colorString(5,12,0xcc6d00,"Медной руды: "),12},{32,12}},{tostring(size),tostring(output).."     "})
					DB.copperOre = size
					DB.copperIngots = output
					DB.copperMultiplier = multiplier
				end
				if inv[k].name == "IC2:blockOreTin" then
					size, output, multiplier = checkOre(inv[k])
					setChar({{colorString(5,14,0xffffC0,"Оловянной руды: "),14},{32,14}},{tostring(size),tostring(output).."     "})
					DB.tinOre = size
					DB.tinIngots = output
					DB.tinMultiplier = multiplier
				end	
				if inv[k].name == "minecraft:gold_ore" then
					size, output, multiplier = checkOre(inv[k])
					setChar({{colorString(5,16,0xffDB00,"Золотой руды: "),16},{32,16}},{tostring(size),tostring(output).."     "})
					DB.goldOre = size
					DB.goldIngots = output
					DB.goldMultiplier = multiplier
				end	
				if inv[k].name == "IC2:blockOreLead" then
					size, output, multiplier = checkOre(inv[k])
					setChar({{colorString(5,18,0xa5a5a5,"Свинцовой руды: "),18},{32,18}},{tostring(size),tostring(output).."     "})
					DB.leadOre = size
					DB.leadIngots = output
					DB.leadMultiplier = multiplier
				end
				if inv[k].name == "IC2:blockOreUran" then
					size, output = inv[k].size, inv[k].size
					setChar({{colorString(5,20,0x99db00,"Урановой руды: "),20},{32,20}},{tostring(size),tostring(output).."     "})
					DB.uranOre = size
					DB.uranItem = output
				end	
			end
			for k=1, #inv do
				if inv[k].name == "minecraft:iron_ingot" then
					DB.ironInSystem = inv[k].size
				end
				if inv[k].name == "IC2:itemIngot" and inv[k].damage == 0 then
					DB.copperInSystem = inv[k].size
				end
				if inv[k].name == "IC2:itemIngot" and inv[k].damage == 1 then
					DB.tinInsystem = inv[k].size
				end	
				if inv[k].name == "IC2:itemIngot" and inv[k].damage == 5 then
					DB.leadInSystem = inv[k].size
				end	
				if inv[k].name == "minecraft:gold_ingot" then
					DB.goldInSystem = inv[k].size
				end	
				if inv[k].name == "IC2:itemUran" then
					DB.uranInSystem = inv[k].size
				end		
			end
			if port.getStackInSlot(1) ~= nil then isCellTaked = true end
			setChar({{48,10},{48,12},{48,14},{48,16},{48,18},{48,20}},{tostring(DB.ironInSystem),tostring(DB.copperInSystem),tostring(DB.tinInsystem),tostring(DB.goldInSystem),tostring(DB.leadInSystem),tostring(DB.uranInSystem)})
			-------------------------------------------------------
			colorString(10,7,0xff9200,"Ваши ресурсы")
			colorString(30,7,0xff9200,"После обмена")
			colorString(48,7,0xff9200,"Баланс")
			box(28,6,16,16)
			box(3,6,16,55)
			gpu.fill(3,8,55,1,"═")
			setChar({{28,6},{44,6},{3,8},{28,8},{44,8},{58,8},{28,22},{44,22}},{"╦","╦","╠","╬","╬","╣","╩","╩"})
			-------------------------------------------------------
			table.insert(DB, {ironOre=ironOreInput, ironIngots=ironIngotsOutput, copperOre=copperOreInput, copperIngots=copperIngotsOutput, tinOre=tinOreInput, tinIngots = tinIngotsOutput, goldOre=goldOreInput, goldIngots=goldIngotsOutput, leadOre=leadOreInput, leadIngots = leadIngotsOutput, uranOre=uranOreInput, uranItem=uranOutput})
			countInv=ingotsInterface.getAvailableItems()
			if nick ~= nil then
				autoExitCounter = 61
			end
			if nick ~= nil then
				if pressButton(w,h,tradeButton) and isCellTaked == true then	
					gpu.fill(3,3,56,28," ")
					colorString(18,15,0xff9200,"Выполняется обмен...")
					red.setOutput(4,0)
					getOut(oresInterface, DB.ironOre,64,getSlot(oresInterface, "minecraft:iron_ore"))
					getOut(oresInterface, DB.copperOre,64,getSlot(oresInterface, "IC2:blockOreCopper"))
					getOut(oresInterface, DB.tinOre,64,getSlot(oresInterface, "IC2:blockOreTin"))
					getOut(oresInterface, DB.goldOre,64,getSlot(oresInterface, "minecraft:gold_ore"))
					getOut(oresInterface, DB.leadOre,64,getSlot(oresInterface, "IC2:blockOreLead"))
					getOut(oresInterface, DB.uranOre,1,getSlot(oresInterface, "IC2:blockOreUran"))
					getOut(ingotsInterface, DB.ironIngots,64,getSlot(ingotsInterface, "minecraft:iron_ingot"))
					getOut(ingotsInterface, DB.copperIngots,64,getSlot(ingotsInterface, "IC2:itemIngot",0))
					getOut(ingotsInterface, DB.tinIngots,64,getSlot(ingotsInterface, "IC2:itemIngot",1))
					getOut(ingotsInterface, DB.goldIngots,64,getSlot(ingotsInterface, "minecraft:gold_ingot"))
					getOut(ingotsInterface, DB.leadIngots,64,getSlot(ingotsInterface, "IC2:itemIngot",5))
					getOut(ingotsInterface, DB.uranItem,1,getSlot(ingotsInterface,"IC2:itemUran"))
					red.setOutput(0,1)
					gpu.fill(17,15,15,1," ")
					colorString(17,15,0xff9200,"Загружаю ресурсы в ячейку...")
					os.sleep(5)
					red.setOutput(0,0)
					gpu.fill(3,3,56,28," ")
					isCellTaked = false
					isOreTrade = false
					isMainPage = true
					saveLog(authorNick, DB)
				end
				autoExitCounter = 61	
			end
			if nick ~= nil then
				if pressButton(w,h,mainButton) then
					gpu.fill(3,3,56,28," ")
					isOreTrade = false
					isMainPage = true
					mainGui()
					isCellTaked = false
				end
				if pressButton(w,h,helpButton) then
					isOreTrade = false
					isHelpPage = true
				end	
			end
		end
		if isHelpPage == true then
			gpu.fill(3,3,56,28," ")
			colorString(6,8,0x99ffff,"Тут хелпа")
			colorString(18,20,0x99ffff,"OB1CHAM, миленький, напиши это дерьмо :D")
			backButton = button(26,25,2,"Назад")
			if nick ~= nil then
				if pressButton(w,h,backButton) then
					isHelpPage = false
					isOreTrade = true
					gpu.fill(3,3,56,28," ")
				end	
			end
		end
	end
	if autoExitCounter == 0 then
		exit()
	end
end
