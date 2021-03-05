local component = require("component")
local modem = component.modem
local fs = require("filesystem")
local gui = require("gui")
local event = require("event")
local gpu = component.gpu
isAuthorization = true

items = {
	{id="dwcity:Materia", dmg = nil, cost = 100},
	{id="minecraft:stone", dmg = nil, cost = 1},
	{id="dwcity:Materia2", dmg = nil, cost = 130},
	{id="dwcity:Materia3", dmg = nil, cost = 210},
	{id="minecraft:stoneszfc", dmg = nil, cost = 1},
	{id="minecraft:cobblestone", dmg = nil, cost = 1},
	{id="dwcity:Materia", dmg = nil, cost = 100},
	{id="minecraft:stone", dmg = nil, cost = 1},
	{id="dwcity:Materia2", dmg = nil, cost = 130},
	{id="dwcity:Materia3", dmg = nil, cost = 210},
	{id="minecraft:stoneszfc", dmg = nil, cost = 1},
	{id="minecraft:cobblestone", dmg = nil, cost = 1},
	{id="dwcity:Materia", dmg = nil, cost = 100},
	{id="minecraft:stone", dmg = nil, cost = 1},
	{id="dwcity:Materia2", dmg = nil, cost = 130},
	{id="dwcity:Materia3", dmg = nil, cost = 210},
	{id="minecraft:stoneszfc", dmg = nil, cost = 1},
	{id="minecraft:cobblestonelast", dmg = nil, cost = 1}
}

pos = 1
onPage = 4
gui.clear()
buttons = {}
isDrawed = false
while true  do
	y=5
	_,_,_,_,direct,nick = event.pull(0.001,"scroll")
	while isDrawed do
		_,_,_,_,direct,nick = event.pull(0.001,"scroll")
		e,_,w,h,_,nick = event.pull(0.5,"touch")
		if e ~= nil then
			for k=1,#buttons do
				if gui.pressButton(w,h,buttons[k].mass) then
					gpu.set(3,26,tostring(items[buttons[k].pos].id.." "..items[buttons[k].pos].cost.."        "))
				end	
			end	
		end
		if direct ~= nil then
			direct = direct*(-1)
			pos = pos + direct
			if pos < 1 then pos = 1 end
			if pos + onPage > #items then pos = pos - 1 end
		end
		if lastPos ~= pos then
		buttons = {}
		isDrawed = false
	end
	end	
	if not isDrawed then
		for k=pos, pos+onPage do
			gpu.set(3,y, tostring(items[k].id.."  "..items[k].cost).."      ")
			mass = {mass = gui.button(30,y-2,2,"Купить"), pos = k}
			table.insert(buttons, mass)
			y=y+4
			isDrawed = true
		end
	end	
	lastPos = pos
	gpu.set(3,27,tostring(#buttons))
	e,_,w,h,_,nick = event.pull(0.5,"touch")
	y=5
	nextButton=gui.button(65,26,2,"=>")
	backButton=gui.button(58,26,2,"<=")
	if e ~= nil then
		if gui.pressButton(w,h,nextButton) then pos = pos + 5 if pos + onPage > #items then pos = #items-onPage end end
		if gui.pressButton(w,h,backButton) then pos = pos - 5 if pos<1 then pos = 1 end end
	end	
	if not isDrawed then
		for k=pos, pos+onPage do
			gpu.set(3,y, tostring(items[k].id.."  "..items[k].cost).."      ")
			mass = {mass = gui.button(30,y-2,2,"Купить"), pos = k}
			table.insert(buttons, mass)
			y=y+4
			isDrawed = true
		end
	end
	if e ~= nil then
		for k=1,#buttons do
			if gui.pressButton(w,h,buttons[k].mass) then
				gpu.set(3,26,tostring(items[buttons[k].pos].id.." "..items[buttons[k].pos].cost.."        "))
			end	
		end	
	end
	if lastPos ~= pos then
		buttons = {}
		isDrawed = false
	end
	lastPos = pos
end