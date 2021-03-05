ironFingerPrint = interface.getInterfaceConfiguration(1)
copperFingerPrint = interface.getInterfaceConfiguration(3)
ironOreId = ironFingerPrint.name
copperOreId = copperFingerPrint.name
ironIngotId = "minecraft:iron_ingot"
copperIngotId = "IC3:itemIngot"

function getItemSize()
Ores = {}
Ingots = {}
inv = interface.getAvailableItems()
slot = 0
	for i=1, #inv do 
		if inv[i].fingerprint.id == ironOreId then
			table.insert(Ores, {ironSlot = i})
		end	
	end	
	for i=1, #inv do 
		if inv[i].fingerprint.id == copperOreId then
			table.insert(Ores, {coppperSlot = i})
		end	
	end
	for i=1, #inv do 
		if inv[i].fingerprint.id == ironIngotId then
			table.insert(Ingots, {ironSlot = i})
		end	
	end
	for i=1, #inv do 
		if inv[i].fingerprint.id == copperIngotId then
			table.insert(Ingots, {copperSlot = i})
		end	
	end	
	gpu.set(1, 1, "IronOre: "..inv[Ores[1].ironSlot].size.."   ===>   "..math.floor(inv[Ores[1].ironSlot].size*3.3).." iron ingots")	
	gpu.set(1, 3, "CopperOre: "..inv[Ores[3].coppperSlot].size.."   ===>   "..math.floor(inv[Ores[3].coppperSlot].size*3.3).." copper ingots")
	gpu.set(1, 10, "Iron ingots in ME: "..inv[Ingots[1].ironSlot].size)
	gpu.set(1, 11, "Copper ingots in ME: "..inv[Ingots[3].copperSlot].size)
end
function getOut()
	status = false
	if inv[Ingots[1].ironSlot].size >= math.floor(inv[Ores[1].ironSlot].size*3.3) and inv[Ingots[3].copperSlot].size >= math.floor(inv[Ores[3].coppperSlot].size*3.3) then
		status = true
		if status == true then
			if math.floor(inv[Ores[1].ironSlot].size*3.3) <= 64 then
				interface.exportItem({id = ironIngotId}, "NORTH", math.floor(inv[Ores[1].ironSlot].size*3.3))
			else
				piece = math.floor(math.floor(inv[Ores[1].ironSlot].size*3.3)/64)
				pieceP = math.floor(inv[Ores[1].ironSlot].size*3.3)%64
				for i=1, piece do
					interface.exportItem({id = ironIngotId}, "NORTH", 64)
				end
				interface.exportItem({id = ironIngotId}, "NORTH", pieceP)
			end	
		end			
	else
		gpu.set(1, 5, "Bad =(   ")	
	end	
	getItemSize()
end
function gui()
	gpu.fill(1,1,160,50, " ")
	gpu.setForeground(0xff00ff)
	gpu.fill(35,35,35,5, " ")
	gpu.setForeground(0xffffff)
	gpu.set(30, 38, "Обменять!")
end
function events()	
	gpu.set(5, 38, "x: "..w.."  ")
	gpu.set(10, 38, "y: "..h.."  ")
	gpu.setForeground(0xff00ff)
	gpu.set(w,h, "██")
	os.sleep(1)
	gpu.setForeground(0x000000)
	gpu.set(w,h, "██")
	gpu.setForeground(0xffffff)
end
gui()
while true do
	e,_,w,h = event.pull("touch")
	events()
	getItemSize()
	getOut()
	os.sleep(0.01)
end	




local component = require("component")
local gpu = component.gpu
local unicode = require("unicode")

function box(x,y,height,width,name,border,color)
	gpu.fill(x,y,width,1,"─")
	gpu.fill(x,y+height,width,1,"─")
	gpu.fill(x,y,1,height,"│")
	gpu.fill(x+width,y,1,height,"│")
	gpu.set(x,y,"┌")
	gpu.set(x,y+height,"└")
	gpu.set(x+width,y+height,"┘")
	gpu.set(x+width,y,"┐"	)
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

box(12,4,5,6,"Text",_,_)
while true do
	os.sleep(0.5)
end	


			colorString(8,7,0x3324ff,"Ваши ресурсы")
			colorString(30,7,0x3324ff,"После обмена")
			colorString(49,7,0x3324ff,"Баланс")

			colorString(4,10,0xcc9200,"Железной руды: ")
			colorString(4,12,0xcc6d00,"Медной руды: ")
			colorString(4,14,0xffffff,"Оловянной руды: ")
			colorString(4,16,0xffDB00,"Золотой руды: ")
			colorString(4,18,0xd2d2d2,"Свинцовой руды: " )
			colorString(4,20,0x99db00,"Урановой руды: ")


			for k=1,#inv do
				if inv[k].fingerprint.id == "minecraft:iron_ore" then
					if lastSize ~= inv[k].size then
						autoExitCounter = 31
					end	
					lastSize=inv[k].size
					gpu.set(4,8,"Железной руды: "..inv[k].size.."  ====>  "..math.floor(inv[k].size*multiplier).."   ")
					ironOreInput = inv[k].size
					ironIngotsOutput = math.floor(inv[k].size*multiplier)
				end
				if inv[k].fingerprint.id == "IC2:blockOreCopper" then
					gpu.set(4,10,"Медной руды: "..inv[k].size.."  ====>  "..math.floor(inv[k].size*multiplier).."   ")
					copperOreInput = inv[k].size
					copperIngotsOutput = math.floor(inv[k].size*multiplier)
				end	
				if inv[k].fingerprint.id == "IC2:blockOreTin" then
					gpu.set(4,12,"Оловянной руды: "..inv[k].size.."  ====>  "..math.floor(inv[k].size*multiplier).."   ")
					tinOreInput = inv[k].size
					tinIngotsOutput = math.floor(inv[k].size*multiplier)
				end
				if inv[k].fingerprint.id == "minecraft:gold_ore" then
					gpu.set(4,14,"Золотой руды: "..inv[k].size.."  ====>  "..math.floor(inv[k].size*multiplier).."   ")
					goldOreInput = inv[k].size
					goldIngotsOutput = math.floor(inv[k].size*multiplier)
				end
				if inv[k].fingerprint.id == "IC2:blockOreLead" then
					gpu.set(4,16,"Свинцовой руды: "..inv[k].size.."  ====>  "..math.floor(inv[k].size*multiplier).."   ")
					leadOreInput = inv[k].size
					leadIngotsOutput = math.floor(inv[k].size*multiplier)
				end
				if inv[k].fingerprint.id == "IC2:blockOreUran" then
					gpu.set(4,18,"Урановой руды: "..inv[k].size.."  ====>  "..inv[k].size.."   ")
					uranOreInput = inv[k].size
					uranOutput = inv[k].size
				end
				if inv[k].fingerprint.id == "appliedenergistics2:item.ItemBasicStorageCell.1k" or inv[k].fingerprint.id == "appliedenergistics2:item.ItemBasicStorageCell.4k" or inv[k].fingerprint.id == "appliedenergistics2:item.ItemBasicStorageCell.16k" or inv[k].fingerprint.id == "appliedenergistics2:item.ItemBasicStorageCell.64k" then
					isCellTaked = true
					gpu.fill(15,24,1,20, " ")
				end	
			end


			for k=1, #countInv do
				if countInv[k].fingerprint.id == "minecraft:iron_ingot" then
					if DB[1].ironIngots+100 >= countInv[k].size then
						isTradeable = false
					end
					gpu.set(41,8,"Ж. слит. = "..countInv[k].size)
				end
				if countInv[k].fingerprint.id == "IC2:itemIngot" and countInv[k].fingerprint.dmg == 0 then
					if DB[1].copperIngots+100 >= countInv[k].size then
						isTradeable = false
					end
					gpu.set(41,10,"М. слит. = "..countInv[k].size)
				end
				if countInv[k].fingerprint.id == "IC2:itemIngot" and countInv[k].fingerprint.dmg == 1 then
					if DB[1].tinIngots+100 >= countInv[k].size then
						isTradeable = false
					end
					gpu.set(41,12,"О. слит. = "..countInv[k].size)
				end	
				if countInv[k].fingerprint.id == "minecraft:gold_ingot" then
					if DB[1].goldIngots+100 >= countInv[k].size then
						isTradeable = false
					end
					gpu.set(41,14,"З. слит: "..countInv[k].size)
				end
				if countInv[k].fingerprint.id == "IC2:itemIngot" and countInv[k].fingerprint.dmg == 5 then
					if DB[1].leadIngots+100 >= countInv[k].size then
						isTradeable = false
					end
					gpu.set(41,16,"С. слит. = "..countInv[k].size)
				end
				if countInv[k].fingerprint.id == "IC2:itemUran" then
					if DB[1].uranItem+100 >= countInv[k].size then
						isTradeable = false
					end
					gpu.set(41,18,"Уран = "..countInv[k].size)
				end	
			end
			if isHelpPage == true then
				gpu.fill(3,3,56,26," ")
				colorString(6,8,0x99ffff,"Тут хелпа")
				colorString(20,20,0x99ffff,"OB1CHAM, миленький, напиши это дерьмо :D")
				helpButton = button(25,25,2,"Назад")
				if nick ~= nil then
					if pressButton(w,h,helpButton) then
						gpu.fill(3,3,56,26," ")
						isHelpPage = false
						isOreTrade = true
					end	
				end
			end
			for ...
			logs[1][1][k].jhjhj