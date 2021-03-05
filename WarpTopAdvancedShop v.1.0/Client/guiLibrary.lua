local gui = {}
local component = require("component")
local computer=require("computer")
local serial = require("serialization")
local term = require("term")
local text = require("text")
local event = require("event")
local unicode = require("unicode")
local fs = require("filesystem")
local internet = require("internet")
local gpu = component.gpu

function gui.box(x,y,height,width,name,border,color)
	gpu.fill(x,y,width,1,"═")
	gpu.fill(x,y+height,width,1,"═")
	gpu.fill(x,y,1,height,"║")
	gpu.fill(x+width,y,1,height,"║")
	gpu.set(x,y,"╔")
	gpu.set(x,y+height,"╚")
	gpu.set(x+width,y+height,"╝")
	gpu.set(x+width,y,"╗")
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
	gpu.setForeground(gpu.getForeground())
end

function gui.clear(step)
	if step == nil then	step = 0 end
	local width,height = gpu.getResolution()
	gpu.fill(1+step,1+step,width-step*2,height-step*2," ")
end



function gui.frame(x,y,w,h,color,isBox,boxColor)
	gpu.setBackground(color)
	gpu.fill(x,y,w,h," ")
	if isBox == true then
		gpu.setForeground(boxColor)
		gpu.fill(x,y,1,h,"▌")
		gpu.fill(x+w,y,1,h,"▐")
		gpu.fill(x,y,w,1,"▔")
		gpu.fill(x,y+h,w,1,"▂")
		gui.setChar({{x,y},{x,y+h},{x+w,y},{x+w,y+h}},{"▛","▙","▜","▟"}) 
	end 
	-- gpu.setBackground(0x000000)
	-- gpu.setForeground(0xffffff)
end

function gui.setChar(mass1, mass2) -- {{x,y},{x,y}}, {char}
	for k=1, #mass1 do
		gpu.set(mass1[k][1],mass1[k][2],mass2[k])
	end	
end

function gui.button(x,y,height,text,color)
	local oldFg = gpu.getForeground()
	gpu.fill(x,y,unicode.len(text)+3,1,"═")
	gpu.fill(x,y+height,unicode.len(text)+3,1,"═")
	gpu.fill(x,y,1,height,"║")
	gpu.fill(x+unicode.len(text)+3,y,1,height,"║")
	gpu.set(x,y,"╔")
	gpu.set(x,y+height,"╚")
	gpu.set(x+unicode.len(text)+3,y,"╗")
	gpu.set(x+unicode.len(text)+3,y+height,"╝")
	if color == nil then color = 0xffffff end
	gpu.setForeground(color)
	gpu.set(x+2,y+math.floor(height/2),text)
	gpu.setForeground(oldFg)
	mass={x,x+unicode.len(text)+3,y,y+height}
	return mass
end

function gui.textButton(x,y,text)
	gpu.set(x,y,text)
	mass={x,x+unicode.len(text),y,y}
	return mass
end

function gui.lessMoreButton(x,y,char)
	local oldFg = gpu.getForeground()
	gpu.setForeground(0x99ffff)
	if char == "<" then
		mass={x,x,y,y}
		gpu.set(x,y,char)
	elseif char == ">" then
		mass={x,x,y,y}
		gpu.set(x,y,char)
	elseif char == "<<" then
		mass={x,x+1,y,y}
		gpu.set(x,y,char)
	else
		mass={x,x+1,y,y}
		gpu.set(x,y,char)
	end
	gpu.setForeground(oldFg)
	return mass
end

function gui.pressButton(w,h,mass)
	local x,x1,y,y1 = mass[1], mass[2], mass[3], mass[4]
	if w >= x and w <= x1 and h >= y and h <= y1 then
		return true
	end	
	return false
end

function gui.getHostTime(timezone) --Получить текущее реальное время компьютера, хостящего сервер майна
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

function gui.time(timezone) --Получет настоящее время, стоящее на Хост-машине
    local time = {gui.getHostTime(timezone)}
    local text = string.format("%d-%d  %02d:%02d:%02d",time[1], time[2], time[4], time[5], time[6])
    return text
end

function gui.resolution(w,h,isCustom)
	if isCustom ~= nil and isCustom == true then
		if w < 70 then	
			w=70
		end	
		if h < 30 then
			h=30
		end
	end	
	gpu.setResolution(w,h)
end

function gui.setColorChar(mass1, mass2) --{{x,y},{x,y}},{{char,color}}
	local back = gpu.getForeground()
	for k=1, #mass1 do
		gpu.setForeground(mass2[k][2])
		gpu.set(mass1[k][1],mass1[k][2],mass2[k][1])
	end
	gpu.setForeground(back)	
end

function gui.colorString(x,y,color, text)
	local back = gpu.getForeground()
	gpu.setForeground(color)
	gpu.set(x,y,text)
	gpu.setForeground(back)
	nextPos=x+unicode.len(text)
	return nextPos
end

function gui.untokenize(mass)
	line = ""
	for k in pairs(mass) do
		line = line..mass[k].." "
	end
	return text.trim(line) 
end

function splitLine(line, maxLeight)
	local isRemoved = false
	local startSize = #line
	local startLine = line
	local result = {}
	line = text.tokenize(startLine)
	if unicode.len(line[1]) > maxLeight then return error("First part is too long") end
	for k=1,startSize do
		if unicode.len(gui.untokenize(line)) > maxLeight then
			table.remove(line, #line)
		else
			lastSize = #line
			result.first=gui.untokenize(line)
			break
		end	
	end
	if startSize - lastSize == 1 then
 		result.second=gui.untokenize(startLine[#startLine]) 
 	else	
		line = text.tokenize(startLine)
		for k=1,lastSize do
			table.remove(line, 1)
		end	
		for k=lastSize, startSize do
			if unicode.len(gui.untokenize(line)) > maxLeight then
				table.remove(line, #line)
				isRemoved = true
			else
				lastSize = #line
				result.second=gui.untokenize(line)
				break
			end
		end
		if isRemoved then
			for k=1,lastSize do
				table.remove(line, 1)
			end
			result.second=gui.untokenize(line)
		end	
	end	
	return true, result
end

function gui.setText(x,y,w,h,mass) -- {"Some text on 1-st line","Some text again"} 
	local maxLeight = x+w 
	for k=1,#mass do
		if unicode.len(mass[k]) < maxLeight then
			gpu.set(x,y,mass[k])
			y=y+1
		else
			flag, result = splitLine(mass[k],maxLeight) 
			if flag then
				gpu.set(x,y,result.first)
				y=y+1
				gpu.set(x+3,y,result.second)
				y=y+1
				if result.third ~= nil	then
					gpu.set(x+3,y,result.third)
					y=y+1
				end
			else
				return error("Error on line "..tostring(k))
			end	
		end	
	end	
	return true 
end

return gui
width = 15


-- {
-- "Вы давно просили заснять катание на BMX от первого лица,",
-- "и в честь замена рамы… я решил в заключительный", 
-- "раз прокатиться на старом БМХ.",
-- "Канал ТАТУ мастера",
-- "- https://www.youtube.com/channel/UCvln...",
-- "Наш магазин - https://vk.com/gordeybikestore",
-- "Спасибо всем за лайки и репосты!) Если вам понравился такой формат,",
-- "то пишите об этом в комментариях.",
-- "После того, как поставлю новую раму ещё прокачусь куда нибудь."
-- }




--  "После того, как поставлю новую раму ещё прокачусь куда нибудь."
-- --text = {"Hello im Peter","I live in Canada and love lua","Thx for u my brother"}
-- -- gui.setText(3,5,30,12,text)