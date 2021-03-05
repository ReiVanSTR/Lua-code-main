local component = require("component")
local gpu = component.gpu
local cardWriter = component.os_cardwriter
local cardReader = component.os_magreader
local keyPad = component.os_keypad
local event = require("event")
local unicode = require("unicode")

--Resolution
gpu.setResolution(70,30)
width, height = gpu.getResolution()

-- Variables
isAuthPage = true
isMainPage = false
isCardPage = false
-- Event's names
cardReader.setEventName("isSwipped")
keyPad.setEventName("isKlicked")

function buyCard()
	
end
function auth()
	e,_,w,h,_,nick = event.pull(1,"touch")
	authButton = button(30,15,2,"Авторизация")
	if nick ~= nil then	
		if pressButton(w,h,authButton) then
			isAuthPage = false
			isMainPage = true
			gpu.fill(1,1,70,30," ")
		end
	end	
end
-- GUI / Button's functions
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
	-- if name ~= nil then
	-- 	if border == nil then
	-- 		gpu.set(x+math.ceil((width-unicode.len(name))/2),y,name)
	-- 	end
	-- 	if border ~= nil then
	-- 		gpu.set(x+math.ceil((width-unicode.len(name..border..border))/2),y,border..name..border)
	-- 	end
	-- end
	gpu.setForeground(0xffffff)
end
---------------------------------------------------
while isAuthPage do
	auth()
end
while isMainPage do
	e,_,w,h,_,nick = event.pull(1,"touch")
	gpu.set(25,2," You are authorized!")
	buyCardButton = button(25,10,2,"Купить карту")
	if nick ~= nil then
		if pressButton(w,h,buyCardButton) then
			isMainPage = false
			isCardPage = true
			gpu.fill(1,1,70,30," ")
		end
	end	
end
while isCardPage do
	e,_,w,h,_,nick = event.pull(,"touch")
	gpu.set(20,5,"Выберите карту")
	silverCard = button(8,8,2,"Серебро")
	goldCard = button(25,8,2,"Золото")
	if isSilver == true then
		box(8,8,2,10,_,_,0xff0000)
	elseif isGold == true then
		box(25,8,2,9,_,_,0xff0000)
	end	
	if nick ~= nil then
		if pressButton(w,h,silverCard) then
			isGold = false
			isSilver = true
		end
		if pressButton(w,h,goldCard) then
			isSilver = false
			isGold = true
		end	
	end	
end	