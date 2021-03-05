local component = require("component")
local brige = component.openperipheral_bridge
local sensor = component.openperipheral_sensor
local averageCounter = component.average_counter
local aemultipart = component.aemultipart
local gpu = component.gpu
bio = "Gui by ReiVanSTR v.1.2"
height = string.len(bio)*6
teammates = {
	{nick="Collapss",color=0x00dbff}, 
	{nick="CoRTeZz64",color=0xff24ff},
	{nick="sonya12005",color=0xcc92ff},
	{nick="ReiVanSTR",color=0xff6D00},
	{nick="OB1CHAM",color=0x336Dff},
	{nick="wot1230815",color=0x00DB00}
}

function checkInMass(nick,mass)
	for k=1,#mass do
		if nick == mass[k].nick then	
			return true, mass[k].color
		end	
	end	
	return false
end

function getInfo(delay)
	brige.addBox(10, 10, height, 65, 0x000000, 0.8)
	brige.addText(12, 12, bio, 0xffffff)
	names = sensor.getPlayers()
	width = 10 + (#names*14)
	brige.addBox(10, 81, height, width, 0x000000, 0.8)
	average = averageCounter.getAverage()
	brige.addText(18, 85, "|| Игроки рядом: ||", 0xffff00)
	y = 98
	step = 12
	for k=1,#names do
		response, color = checkInMass(names[k].name, teammates)
		if response then
			brige.addText(12, y, tostring(names[k].name), color)
			y=y+step
		else
			brige.addText(12, y, tostring(names[k].name), 0xffffff)
			y=y+step
		end	
	end
	averageQTY = averageCounter.getAverage()
	if averageQTY == nil then
		averageQTY = 0
	end
	matterQTY = aemultipart.getItemDetail({id="dwcity:Materia"},false).qty
	if matterQTY == nil then
		matterQTY = 0
	else
	
	end	
	materia = "Материи дома: "..matterQTY.." ("..string.sub(tostring(60000000/(averageQTY*18)),1,3)..")"
	brige.addText(12, 35, materia, 0xCC00C0)
	eu = "Выход: "..averageCounter.getAverage().." Eu/t"
	brige.addText(12, 49, eu, 0x00B6ff)
	os.sleep(delay)
end
while true do	
	brige.clear()
	getInfo(5)
	brige.sync()
end