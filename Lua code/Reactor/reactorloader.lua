local component = require("component")
local interface = component.me_interface
local gpu = component.gpu
local event = require("event")
local unicode = require("unicode")
local fs = require("filesystem")
local serial = require("serialization")
pushSide = "UP"
eu420 = { --обшивка/разогнанный теплоотвод/компонентный теплоотвод/компонентный теплообменник/стрежни
	5,3,2,4,2,2,3,2,1,1,3,2,2,3,2,2,5,2,1,2,5,2,2,5,2,2,3,3,2,2,3,2,2,3,2,1,2,5,2,2,5,2,2,5,2,1,2,3,1,2,3,1,2,3
}
names = {plates={id="IC2:reactorPlating"},heatSwitch={id="IC2:reactorHeatSwitchSpread",dmg=1,_},reactorVent={id="IC2:reactorVentSpread"},reactorVentGold={id="IC2:reactorVentGold",dmg=1,_},quad={id="IC2:reactorUraniumQuad",dmg=1,_}}
loadCount = 1
gpu.setResolution(30,11)
-- gpu.setResolution(70,30)
gpu.fill(1,1,30,9," ")
function openLog(filename)
    buff = ""	
	buffMass = {}
	for line in io.lines(filename) do
		buffMass = buff..line
	end
	buffMass = serial.unserialize(buffMass)
	return buffMass
end

function load(count)
	allItems = count*28+count*7+count*7+count*11+count
	itemCounter = 0
	for i = 1, count do
		timer = logs.timer -- Установить в значение 20 {timer=20, reac = 0}
		for _,k in pairs(eu420) do
			interface.pushItem(pushSide,k,1)
			os.sleep(0.55)
			itemCounter=itemCounter+1
			procCounter = (itemCounter*100)/allItems
			gpu.set(13,6,tostring(math.floor(procCounter)).." %")
		end
		if i == count then
			logs.timer = logs.timer + 20
			return 
		else
			os.sleep(timer)
			logs.timer = logs.timer + 20
		end
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
function box(x,y,height,width,name,border,color)
	if color == nil then
		textColor = 0xffffff
	else
		textColor = color
	end
	gpu.setForeground(textColor)
	gpu.setForeground(textColor)
	gpu.fill(x,y,width,1,"═")
	gpu.fill(x,y+height,width,1,"═")
	gpu.fill(x,y,1,height,"║")
	gpu.fill(x+width,y,1,height,"║")
	gpu.set(x,y,"╔")
	gpu.set(x,y+height,"╚")
	gpu.set(x+width,y+height,"╝")
	gpu.set(x+width,y,"╗"	)
	gpu.setForeground(textColor)
	gpu.setForeground(0xffffff)
end
function getHostTime(timezone) --Получить текущее реальное время компьютера, хостящего сервер майна
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
logs = openLog("/home/log.txt")

while true do
	timer = logs.timer -- Установить в значение 20 {timer=20, reac = 0}
	reac = logs.reac
	event.shouldInterrupt = function() return false end
	e,_,w,h,_,nick = event.pull(0.05,"touch")
	isLoaded = true
	if interface.getItemDetail(names.plates,false).qty < loadCount*7 then isLoaded = false end
	if interface.getItemDetail(names.heatSwitch,false).qty < loadCount*1 then isLoaded = false end
	if interface.getItemDetail(names.reactorVent,false).qty < loadCount*11 then isLoaded = false end
	if interface.getItemDetail(names.reactorVentGold,false).qty < loadCount*28 then isLoaded = false end
	if interface.getItemDetail(names.quad,false).qty < loadCount*7 then isLoaded = false end
	minusButton = button(8,1,2,"-")
	plusButton = button(18,1,2,"+")
	loadButton = button(9,4,2,"Загрузить")
	gpu.set(4,10,"Delay: "..tostring(timer).." s")
	gpu.set(18,10,"Loaded: "..tostring(reac))
	if isLoaded == false then
		box(9,4,2,12,_,_,0xff0000)
		gpu.set(10,8,"Нету ресов!")
	else
		gpu.set(10,8,"           ")	
	end
	counterButton = button(13,1,2,tostring(loadCount))
	if nick ~= nil then
		if pressButton(w,h,minusButton) then
			loadCount = loadCount - 1
			if loadCount < 1 then 
				loadCount = 1 
			end
		end
		if pressButton(w,h,plusButton) then
			loadCount = loadCount + 1
			if loadCount > 9 then
				loadCount = 9
			end	
		end
		if pressButton(w,h,loadButton) and isLoaded == true then
			x={whoLoad=nick, time=time(2), howMuch=loadCount}
			table.insert(logs, x)
			tableSave(logs, "log.txt")
			loadCounter = 0
			gpu.fill(1,1,30,9," ")
			gpu.set(10,4,"Загружаю...")
			load(loadCount)
			gpu.set(7,4,"Успешно загружено!")
			os.sleep(5)
			gpu.fill(1,1,30,9," ")
		end	
	end
end