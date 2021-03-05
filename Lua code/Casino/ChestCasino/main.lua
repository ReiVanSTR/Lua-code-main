local component = require("component")
local event = require("event")
local computer = require("computer")
local unicode = require("unicode")
local serial = require("serialization")
local fs = require("filesystem")
local text = require("text")
local selector = component.openperipheral_selector
local chat = component.chat_box
items = {}
stepCounter = 0
multyplier = 1
uses = 0
use = false
function clear()
	for k=1,9 do
		selector.setSlot(k,{id="minecraft:chest"})
	end	
end	
function split(str, symb)
    local parts = {}
    for m in string.gmatch(str, "([^"..symb.."]+)") do
 	   if m ~= "" then
    		table.insert(parts, m)
    	end
   	end
	return parts
end
function loadItems(tbl, mlt)
	file = io.open("items2.txt","r")
	for line in file:lines() do
		chanse = 0
		part = split(line, " ")
		if #part > 1 then 
			chanse = tonumber(part[2])*mlt
			itemPart = split(part[1],":")
			if #itemPart < 2 then 
				print("Item "..itemPart[1].." has a bad format!")
			else	
				if #itemPart > 2 then
					table.insert(tbl, {chanse = chanse, step=stepCounter, item={name=itemPart[1]..":"..itemPart[2], damage=tonumber(itemPart[3])}})
				else
					table.insert(tbl, {chanse = chanse, step=stepCounter, item={name=itemPart[1]..":"..itemPart[2]}})
				end
				stepCounter = stepCounter + chanse
			end
		end	
	end
	file:close()
end
function genItem()
	val = stepCounter*math.random()
	prevItem = items[1].item
	for k=2,#items do
		if items[k].step < val then
			prevItem = items[k].item
		else
			break
		end			
	end	
	return prevItem
end
function genTable()
	dropTable = {}
	for k=1,9 do
		table.insert(dropTable,genItem())
	end		
end
function setTable()
	for k=1,#dropTable do
		selector.setSlot(k,{id=dropTable[k].name})
	end
end
function close()
	for k=1,#dropTable do
		selector.setSlot(k,{id="AdvancedSolarPanel:BlockAdvSolarPanel", dmg = 4})
	end
end
loadItems(items, multyplier)
clear()
genTable()
while true do
	_, add, msgNick, msg = event.pull(0.01,"chat_message")
	e,slot,side = event.pull(0.01,"slot_click")
	if msg ~= nil then
		if msg == "#open" then
			use = true
			clear()
		end	
	end	
	if use == true then
		if slot ~= nil then
			uses = uses + 1
			selector.setSlot(slot,{id=dropTable[slot].name})
		end
		if uses == 3 then
			uses = 0
			os.sleep(2)
			setTable()
			os.sleep(2)
			genTable(dropTable)
			use = false
		end
	else
		close()
	end	
end	