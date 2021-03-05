local component = require("component")
local gpu = component.gpu
local event = require("event")
local computer = require("computer")
local redstone = component.redstone
local unicode = require("unicode")
local serial = require("serialization")
local fs = require("filesystem")
local text = require("text")
local chat = component.chat_box
local interface = component.me_interface
local db = component.database
local chest = component.chest
local intSide = "WEST"
local redstoneSide = 2
local casinoType = true -- false = эмы, true = железо
local ironBlocksPerBet = 10
chat.setName("§r§6Волшебник Артем§7§l")
chat.setDistance(10)
items = {}
emLost = 0
stepCounter = 0
multyplier = 1
isActive = true
adm = {"ReiVanSTR","OB1CHAM","wot1230815","feod0r","Black_Vizor","HenYyy","Collapss","sonya12005","A1EKSANDR","CoRTeZz64"}
-- target = "minecraft:iron_block" -- для железа: "minecraft:iron_block" "customnpcs:npcMoney"
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
	file = io.open("items.txt","r")
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
function dropItem(item)
	if interface.getItemsInNetwork(item) ~= nil then
		db.clear(1)
		interface.store(item,db.address,1,1)
		interface.setInterfaceConfiguration(1,db.address,1)
		interface.pushItem(intSide,1,1)
		print(item.name)
		redstone.setOutput(redstoneSide,1)
		redstone.setOutput(redstoneSide,0)
		return true
	end
	return false
end
function use()
	for k=1,27 do
		if casinoType and chest.getStackInSlot(k) ~= nil and chest.getStackInSlot(k).id == target and chest.getStackInSlot(k).qty >= ironBlocksPerBet then
			chest.pushItem("DOWN",k,ironBlocksPerBet)
			emLost = emLost + 10
			return true
		end
		if not casinoType and chest.getStackInSlot(k) ~= nil and chest.getStackInSlot(k).id == target then
			chest.pushItem("DOWN",k,1)
			emLost = emLost + 1
			return true
		end
	end	
	return false
end
function check()
	isOk = true
	for k=1,#items do
		if interface.getItemsInNetwork(items[k].item).n == 0 then
			chat.say(tostring(items[k].item.name))
			isOk = false
			chat.say("§r§3Казино закрыто на тех. работы §4(ಠ╭╮ಠ)")
			return false
		end	
	end
	if isOk == true then
		isActive = true
		return true
	end	
end
loadItems(items, multyplier)
gpu.fill(1,1,70,30," ")
if casinoType then counterPrefix = "ЖБ потрачено: " target = "minecraft:iron_block" else counterPrefix = "Эмов потрачено: " target = "customnpcs:npcMoney" end
while true do
	_, add, msgNick, msg = event.pull(0.05,"chat_message")
	gpu.set(45,1,counterPrefix..tostring(emLost).."                                            ")
	if isActive == true then
		if use() then
			if dropItem(genItem()) == false then
				print("BREAK")
				chat.setDistance(40)
				chat.say("§r§3Казино закрыто на тех. работы §4(ಠ╭╮ಠ)")
				chat.setDistance(5)
				isActive = false
			end	
		end
	end
	if msg == "#info" then
		for k=1,#items do
			chat.say("§r§3"..items[k].item.name.."§r§5    "..tostring(items[k].chanse))
		end
		chat.say("§r§2Множитель казино: §r§8x§4  "..tostring(multyplier))
		chat.say("§r§3Всего предметов: §r§5"..tostring(#items))
	end
	if msg ~= nil then
		for _,k in pairs(adm) do
			if msgNick == k then
				if msg == "#stop" then
					isActive = false
					chat.say("§r§3Казино закрыто на тех. работы §4(ಠ╭╮ಠ)")
				end
				if msg == "#start" then
					isActive = true
					chat.say("§r§3Казино снова в строю! §5 (づ｡◕‿‿◕｡)づ")
				end	
			end	
		end
		if msg == "#check" then
			isOk = true
			chat.say("Проверяю...")
			for k=1,#items do
				if interface.getItemsInNetwork(items[k].item).n == 0 then
					chat.say(tostring(items[k].item.name))
					isOk = false
				end	
			end
			if isOk == true then
				isActive = true
				chat.say("Всего хватает!")
			end	
		end	
		com = text.tokenize(msg)
		if com[1] == "#setMlp" and msgNick == "ReiVanSTR" then
			multyplier = com[2]
			stepCounter = 0
			items = {}
			loadItems(items, multyplier)
			print("Sucessfull! New multyplier: "..tostring(multyplier))
			chat.say("§r§3Новый множитель казино: §r§5"..tostring(multyplier))
		end
		if com[1] == "#dropTest" and com[2] ~= nil then	
			local count = com[2] or 1000
		  	local drops = {}
		  	local dropped = 0
		  	for i=1,count do
		   		local item = genItem()
		   		local id = item.name
		    	if item.damage then id=id..":"..item.damage end
		    	if drops[id] then drops[id] = drops[id]+1 dropped = dropped + 1
		    else drops[id] = 1  dropped = dropped + 1 end
		 	end
			for k,v in pairs(drops) do chat.say("§r§3"..tostring(k).." §r§4"..tostring(v)) end
			chat.say("§r§3"..tostring(dropped))
		end	
	end
end	
