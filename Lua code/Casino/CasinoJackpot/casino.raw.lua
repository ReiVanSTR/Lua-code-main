local com = require("component")
local key = require("keyboard")
local event = require("event")
local gpu = com.gpu
local coml = com.list("me_interface")
local cl = {}
local me = com.me_interface
local win = 0
local lose = 0
local bet = 1
local allBet = 0
local xy = {
{"2","2"},{"5","2"},{"8","2"},{"11","2"},{"14","2"},{"17","2"},{"20","2"},{"23","2"},{"26","2"},
{"2","4"},{"5","4"},{"8","4"},{"11","4"},{"14","4"},{"17","4"},{"20","4"},{"23","4"},{"26","4"},
{"2","6"},{"5","6"},{"8","6"},{"11","6"},{"14","6"},{"17","6"},{"20","6"},{"23","6"},{"26","6"},
{"2","8"},{"5","8"},{"8","8"},{"11","8"},{"14","8"},{"17","8"},{"20","8"},{"23","8"},{"26","8"},
{"2","10"},{"5","10"},{"8","10"},{"11","10"},{"14","10"},{"17","10"},{"20","10"},{"23","10"},{"26","10"},
{"2","12"},{"5","12"},{"8","12"},{"11","12"},{"14","12"},{"17","12"},{"20","12"},{"23","12"},{"26","12"},
}
for k in pairs(coml) do table.insert(cl, k) end
meSuck = com.proxy(cl[1])
meDrop = com.proxy(cl[2])
mNameSuck = meSuck.getInterfaceConfiguration(1)
mNameSuck = {id=mNameSuck.name}
mNameDrop = meSuck.getInterfaceConfiguration(1)
mNameDrop = {id=mNameDrop.name}
function gui()
	 gpu.setResolution(50,23)
	 gpu.setBackground(0x332440)
     gpu.setForeground(0xFFFFFF)
     gpu.set(1,1,"┌JP─x0─x2─x0─x3─x0─x4─x0─x5┐")
     gpu.setBackground(0x662400)
     gpu.set(1,2,"J  │  │  │  │  │  │  │  │  L")
     gpu.setBackground(0x332440)
     gpu.set(1,3,"│──────────────────────────│")
     gpu.setBackground(0x662400)
     gpu.set(1,4,"L  │  │  │  │  │  │  │  │  L")
     gpu.setBackground(0x332440)
     gpu.set(1,5,"│──────────────────────────│")
     gpu.setBackground(0x996D00)
     gpu.set(1,6,"W  │  │  │  │  │  │  │  │  W")
     gpu.setBackground(0x332440)
     gpu.set(1,7,"│──────────────────────────│")
     gpu.setBackground(0x996D00)
     gpu.set(1,8,"W  │  │  │  │  │  │  │  │  W")
     gpu.setBackground(0x332440)
     gpu.set(1,9,"│──────────────────────────│")
     gpu.setBackground(0x662400)
    gpu.set(1,10,"L  │  │  │  │  │  │  │  │  L")
    gpu.setBackground(0x332440)
    gpu.set(1,11,"│──────────────────────────│")
    gpu.setBackground(0x662400)
    gpu.set(1,12,"L  │  │  │  │  │  │  │  │  L")
    gpu.setBackground(0x332440)
    gpu.set(1,13,"└──────────────────────────┘")
end
function stat()
	gpu.set(1, 17,"Ваша ставка: ")
	gpu.set(1, 18,"Результат последней игры: ")
	gpu.set(1, 19,"Всего побед: ")
	gpu.set(1, 20,"Всего поражений: ")
	gpu.set(1, 22,"Баланс: ")
	gpu.set(1, 23,"Суммарный выигрыш: ")
end
    


function check()
	size = meSuck.getAvailableItems()
	if size[1]==nil then
		gpu.set(1, 15, "Недостаточно средств!              ")
		money = 0
		gpu.set(1, 22,"Баланс: "..money.."  ")
		os.sleep()
		check()
	else	
		gpu.set(1, 15, "                             ")
		money = size[1].size
		gpu.set(1, 22,"Баланс: "..money.."  ")
		events()
	end
end
function events()
	gpu.set(1, 22,"Баланс: "..money.."  ")
	name,_,_,code=event.pull("key_down")
		if code==200  then
			bet = math.min(bet + 1, 10)
			wBet = bet
			gpu.set(1, 17,"Ваша ставка: "..bet.." ")
		end
		if code==208 then
			bet = math.max(bet - 1, 1)
			gpu.set(1, 17,"Ваша ставка: "..bet.." ")
		end	
		if code==57 and bet>0 and bet<= money then
			random()
		end	
		if code==78  then
			check()
		end	
		if code==74 then
			meSuck.exportItem(mNameSuck, "NORTH", money)
			gpu.set(1, 15, "Вы вывели "..money.."Эмов!         ")        
			gpu.set(1, 16, "Спасибо за игру!                   ")
			check()
		end
		if bet > money then
			gpu.set(1, 15, "Недостаточно средств!              ")             
			gpu.set(1, 16, "                                   ")
			check()
		end
	check()	
end

function random()
		rNumber=math.random(1, 54)
		Status = ""
		money = money - bet
		gpu.set(1, 22,"Баланс: "..money.."  ")
		for b=1, 24 do
			rFalseNumber={math.random(1, 54)}
			gpu.setForeground(0xFFFFFF)
			gpu.set(tonumber(xy[rFalseNumber[1]][1]),tonumber(xy[rFalseNumber[1]][2]),"██")
			os.sleep(0.2)
			gpu.set(tonumber(xy[rFalseNumber[1]][1]),tonumber(xy[rFalseNumber[1]][2]),"  ")
		end	
		if rNumber==1 or rNumber==19 or rNumber==28 or rNumber== 21 or rNumber==30 or rNumber==23 or rNumber==32 or rNumber==25 or rNumber==34 or rNumber== 27 or rNumber==36 then
			gpu.setForeground(0xFFFF00)
			gpu.set(tonumber(xy[rNumber][1]),tonumber(xy[rNumber][2]),"██")
			gpu.setForeground(0xFFFFFF)
		else
			gpu.setForeground(0xFF00FF)
			gpu.set(tonumber(xy[rNumber][1]),tonumber(xy[rNumber][2]),"██")
			gpu.setForeground(0xFFFFFF)
		end	
		if rNumber==1 then 
			gpu.set(1, 15, "JackPot!                             ")
			gpu.set(1, 16, "Ваша ставка умножена на 10!")
			Status = "Победа!  "
			win = win + 1
			wBet=bet*10
			allBet=allBet + wBet
			meDrop.exportItem(mNameDrop,"DOWN", wBet)
			os.sleep(1)
		elseif rNumber==19 or rNumber==28 then
			Status = "Победа!  "
			win = win + 1
			gpu.set(1, 15, "Поле номер "..rNumber.." сыграло!    ")
			gpu.set(1, 16, "Ваша ставка умножена на 1")
			allBet=allBet + wBet 
			meDrop.exportItem(mNameDrop,"DOWN", wBet)
			os.sleep(1)
		elseif rNumber== 21 or rNumber==30 then
			Status = "Победа!  "
			win = win + 1
			gpu.set(1, 15, "Поле номер "..rNumber.." сыграло!    ")
			gpu.set(1, 16, "Ваша ставка умножена на 2")
			wBet=bet*2
			allBet=allBet + wBet
			meDrop.exportItem(mNameDrop,"DOWN", wBet)
			os.sleep(1)
		elseif rNumber==23 or rNumber==32 then
			Status = "Победа!  "
			win = win + 1
			gpu.set(1, 15, "Поле номер "..rNumber.." сыграло!    ")
			gpu.set(1, 16, "Ваша ставка умножена на 3")
			wBet=bet*3
			allBet=allBet + wBet
			meDrop.exportItem(mNameDrop,"DOWN", wBet)
			os.sleep(1)
		elseif rNumber==25 or rNumber==34 then
			Status = "Победа!  "
			win = win + 1
			gpu.set(1, 15, "Поле номер "..rNumber.." сыграло!    ")
			gpu.set(1, 16, "Ваша ставка умножена на 4")
			wBet=bet*4
			allBet=allBet + wBet
			meDrop.exportItem(mNameDrop,"DOWN", wBet)
			os.sleep(1)
		elseif rNumber== 27 or rNumber==36 then
			Status = "Победа!  "
			win = win + 1
			gpu.set(1, 15, "Поле номер "..rNumber.." сыграло!    ")
			gpu.set(1, 16, "Ваша ставка умножена на 5")
			wBet=bet*5
			allBet = allBet + wBet
			meDrop.exportItem(mNameDrop,"DOWN", wBet)
			os.sleep(1)
		else
			Status = "Поражение"
			lose = lose + 1
			meSuck.exportItem(mNameSuck, "SOUTH", bet)
			gpu.set(1, 15, "Поле номер "..rNumber.." проиграло :( ")
			gpu.set(1, 16, "                                      ")
			os.sleep(1)
		end	
	gpu.set(1, 18,"Результат последней игры: "..Status.." ")
	gpu.set(1, 19,"Всего побед: "..win.." ")
	gpu.set(1, 20,"Всего поражений: "..lose.." ")
	gpu.set(1, 22,"Баланс: "..money.." ")
	gpu.set(1, 23,"Суммарный выигрыш: "..allBet)
	os.sleep(2)
	gpu.set(tonumber(xy[rNumber][1]),tonumber(xy[rNumber][2]),"  ")
	gui()
end
gpu.fill(1,1,50,23," ")
gui()
stat()
check()

