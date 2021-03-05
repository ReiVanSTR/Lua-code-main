local Drawer = {}
local gui = require("guiLibrary")
local component = require("component")
local unicode = require("unicode")
local gpu = component.gpu
local event = require("event")
local term = require("term")
local string = require("string")
mainColor = 0x6600ff--0xcc6Dff
tierColors = {
	tier1=0xffDB00,
	tier2=0x006Dff,
	tier3=0xff00ff,
	tier4=0xcc0040,
	tier5=0xff6D00
}

	function Drawer.headerRaw(user, userMoney)
		gpu.setResolution(130,55)
		gpu.setBackground(0x000000)
		gpu.setForeground(mainColor)
		gui.frame(1,1,26,3,0x000000,true,mainColor)
		gui.frame(28,1,102,3,0x000000,true,mainColor)
		gpu.setForeground(0xffffff)
		gpu.set(3,2,"Игрок: ")
		gpu.setForeground(0xffffcc)
		gpu.set(10,2,user)
		gpu.setForeground(0xffffff)
		gpu.set(3,3,"Баланс: ")
		gpu.setForeground(0xffff00)
		gpu.set(11,3,tostring(userMoney))
	end

	function Drawer.categoriesRaw()
		gui.frame(1,5,26,50,0x000000,true,mainColor)
		gpu.setBackground(0x000000)
		gpu.setForeground(mainColor)
	end

	function Drawer.createButtons(mass)
		y=6
		for k=1,#mass do
			mass[k].cords=gui.button(3,y,2,mass[k].buttonName,0xffffff)
			y=y+3
		end
	end

	function Drawer.checkButtons(w,h,mass)
		for k=1, #mass do
			if gui.pressButton(w,h,mass[k].cords) then
				print(mass[k].req)
				return mass[k].req
			end	
		end
	end

	function Drawer.updatePos(data)
		for k=1, #data do
			data[k].pos = k
		end	
	end

	function Drawer.createPage(data, pos)
		gpu.fill(28,5,102,50," ")
		gui.frame(28,5,102,50,0x000000,true,mainColor)
		y=8
		local size
		if #data > 15 then size = 15 else size = #data end
		for k=1, size do
			gpu.fill(30,y,98,1,"─")
			gpu.fill(30,y+2,98,1,"─") --66b600
			y=y+3
		end
		local result = {}
		y=9
		for k=1, size do
			table.insert(result, Drawer.createArticle(32,y,data[k], data[k].pos))
			y=y+3
		end
		return result
	end

	function Drawer.createPageSlider(data)
		local pages = {}
		local x=43
		gpu.set(33,54,"Cтраницы: ")
		for k=1, math.floor(#data/15) do
			table.insert(pages, {
				pos=k*15+1,
				button=gui.textButton(x,54,tostring(k)),				
			})
			x=x+3
		end
		if #data%15 ~= 0 then 
			table.insert(pages, {
				pos=(#pages+1)*15+1,
				button=gui.textButton(x,54,tostring(#pages+1)),				
			})
			x=x+3
		end
		return pages
	end

	function Drawer.slidePage(data,pos)
		local result = {}
		for k=pos-15, pos do
			table.insert(result, data[k])
		end
		return result
	end

	function Drawer.createArticle(x,y,mass,pos)
		local oldFg = gpu.getForeground()
		local displayColor
		if mass.color ~= nil then gpu.setForeground(mass.color) else gpu.setForeground(0xffffff) end
		gpu.set(x,y,mass.display_name)
		gpu.setForeground(0xffffff)
		gpu.set(61,y,"Цена: ")
		gpu.setForeground(0x66b600)
		gpu.set(67,y,tostring(mass.cost))
		gpu.setForeground(0xffffff)
		if mass.stored > 10 then displayColor = 0x0b640 elseif mass.stored < 10 and mass.stored >= 5 then displayColor = 0xffDB00 else displayColor = 0xff0000 end
		gpu.set(74,y,"На складе: ")
		gpu.setForeground(displayColor)
		gpu.set(85,y,tostring(mass.stored))
		gpu.setForeground(0xffffff)
		local articleButtons = {
			id=pos, 
			quantity={
				l1=gui.lessMoreButton(95,y,"<<"),
				l2=gui.lessMoreButton(98,y,"<"),
				m1=gui.lessMoreButton(104,y,">"),
				m2=gui.lessMoreButton(106,y,">>")
			}, 
			qty=0,
			stored = mass.stored,
			cart=gui.textButton(110,y," >> В корзину << "),
			yPos=y
		}
		gpu.set(100,y,"0")
		gpu.setForeground(oldFg)
		return articleButtons
	end

	function Drawer.finderRaw()
		gpu.setForeground(mainColor)
		buttonPos=gui.textButton(95,6,"Поиск: __________________")
		gpu.setForeground(0xffffff)
		gpu.set(92,6,">>")
		return buttonPos
	end

	function Drawer.fiderFind(data, args)
		local result = {}
		for k=1, #data do
			if string.match(data[k].display_name, args) ~= nil then table.insert(result, data[k]) end
		end
		return result
	end

	function Drawer.checkQuantity(w,h,mass,mainMass,cart)
		for k=1, #mass do
			if gui.pressButton(w,h,mass[k].quantity.l1) then mainMass[k].qty=mainMass[k].qty-10 if mainMass[k].qty < 0 then mainMass[k].qty=0 end gpu.set(100,mass[k].yPos,tostring(mainMass[k].qty).." ") end
			if gui.pressButton(w,h,mass[k].quantity.l2) then mainMass[k].qty=mainMass[k].qty-1 if mainMass[k].qty < 0 then mainMass[k].qty=0 end gpu.set(100,mass[k].yPos,tostring(mainMass[k].qty).." ") end
			if gui.pressButton(w,h,mass[k].quantity.m1) then mainMass[k].qty=mainMass[k].qty+1  if mainMass[k].qty > mainMass[k].stored then mainMass[k].qty = mainMass[k].stored or 999 end gpu.set(100,mass[k].yPos,tostring(mainMass[k].qty).." ") end
			if gui.pressButton(w,h,mass[k].quantity.m2) then mainMass[k].qty=mainMass[k].qty+10  if mainMass[k].qty > mainMass[k].stored then mainMass[k].qty = mainMass[k].stored or 999 end gpu.set(100,mass[k].yPos,tostring(mainMass[k].qty).." ") end
			if gui.pressButton(w,h,mass[k].cart) then if mainMass[k].qty > 0 then table.insert(cart, mainMass[k]) Drawer.cartRaw(mainColor, cart) end end
		end
	end

	function Drawer.cartRaw(mainColor, cart)
		gpu.setForeground(0xffffff)
		gpu.set(92,2,">>")
		gpu.set(103,2,"<<")
		gpu.setForeground(mainColor)
		local mass = gui.textButton(95,2,"Корзина ")
		lable = "Корзина "
		if #cart == 0 then
			gui.setColorChar({{95,3},{96,3},{101,3}},{{"(",0xffffff},{"Пусто",mainColor},{")",0xffffff}})
		else
			gpu.fill(92,3,25,1," ")
			for k=1, #cart do
				local credit = 0
				local qty = 0 
				credit = credit + cart[k].cost * cart[k].qty
				qty = qty + cart[k].qty
			end
			gui.setColorChar({{92,3},{92+unicode.len(tostring(qty))+1,3},{92+unicode.len(tostring(qty))+7,3},{92+unicode.len(tostring(qty))+7+unicode.len(tostring(credit))+1,3}},{{tostring(qty),0x006dff},{"пред.",0xffffff},{tostring(credit),0x66b600},{"бамбуков",0xffffff}})
		end
		return mass
	end


return Drawer


-- "\\    / __ |__| ||"
-- " \\/\\/  ▔▔ |▔▔| ||"

