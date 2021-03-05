local com = require("component")
local br = com.openperipheral_bridge
local sens = com.openperipheral_sensor
local av = com.average_counter
local ae = com.aemultipart
local gpu = com.gpu
id = "dwcity:Materia"
bio = "Gui by ReiVanSTR v.1.2"
height = string.len(bio)*6
sec = 0
--com.gpu.setResolution(75,50)

function addBox()
	br.addBox(10, 10, height, 65, 0x000000, 0.8)
	br.addText(12, 12, bio, 0xffffff)
end

function getInfo()
	--Players
	name = sens.getPlayers()
	width = 10 + (#name*14)
	br.addBox(10, 81, height, width, 0x000000, 0.8)
	br.addText(12, 84, "Игроки на варпе:", 0xffff00)
	y = 95
	step = 12
	for i=1, #name do
		if name[i].name == "ReiVanSTR"  then
			br.addText(12, y, tostring(name[i].name), 0xff0000)
			y=y+step
		elseif	name[i].name == "Raidy1Y"  then
			br.addText(12, y, tostring(name[i].name), 0xff6D00)
			y = y+step
		elseif	name[i].name == "Black_Vizor"  then
			br.addText(12, y, tostring(name[i].name), 0x00DB00)
			y = y+step
		elseif	name[i].name == "wot1230815"  then
			br.addText(12, y, tostring(name[i].name), 0x00DB00)
			y = y+step
		elseif	name[i].name == "feod0r"  then
			br.addText(12, y, tostring(name[i].name), 0x336Dff)
			y = y+step	
		else
			br.addText(12, y, tostring(name[i].name), 0xffffff)
			y=y+step
		end		
	end	

	--Matter
	inv = 0
	inv = ae.getAvailableItems()
	slot = 0
	for i=1, #inv do 
		if inv[i].fingerprint.id == id then
			slot = i
		end	
	end	
	if inv ~= nil and slot > 0  then		
		mSize = inv[slot].size
		materia = "Материи дома: "..mSize.." ("..string.sub(tostring(60000000/(av.getAverage()*18)),1,3)..")"
		br.addText(12, 36, materia, 0xCC00C0)
	end

	--CPUs
	cpu=ae.getCraftingCPUs()
	freeCounter = 0
	for i=1, #cpu do
		if cpu[i].busy == false then
			freeCounter = freeCounter + 1 
		end	
	end	
	freeInfo = "Доступно CPU: "..freeCounter
	br.addText(12, 60, freeInfo, 0x00B6ff)

	
	--Average
	average = av.getAverage()
	eu = "Выход: "..average.." Eu/t"
	br.addText(12, 48, eu, 0x00B6ff)
end

gpu.fill(1,1,150,70," ")
while true do
	br.clear()
	addBox()
	getInfo()
	br.sync()
	os.sleep(7)
end

