local com = require("component") -- Zmienna do podłączenia componentów
local key = require("keyboard") -- Zmienna do podłączenia klawiatury
local event = require("event") -- Zmienna do podłączenia eventów
local gpu = com.gpu -- Zmienna do podłączenia gpu (kartę graficzną)
local coml = com.list("me_interface") -- Zmienna do podłączenia interfejsa dla interakcji ze światem
local cl = {} -- Tablica dla interfejsów (mam 2 i trzeba włącyć ich różno)
local me = com.me_interface -- Interfejs dla interakcji ze światem
local note = com.iron_noteblock -- Block dla muzyki
local chat = com.chat_box -- Block dla wiadomości w chat
chat.setDistance(20) -- Ilość bloków, w które będą widoćne wiadomość 
chat.setName("§r§6Бармен Артём§7§l") -- Imię chat boxu
local win = 0 -- Ilość zwycięstw
local lose = 0 -- Ilość porażek
local bet = 1 -- Zakład początkowy
local allBet = 0 -- Łączna wygrana
local jp = 0 -- Ilość Jackpotów
local x1 = 0 -- Ilość zwycięstw RM
local x2 = 0 -- Ilość zwycięstw x2
local x3 = 0 -- Ilość zwycięstw x3
local x4 = 0 -- Ilość zwycięstw x4
local x5 = 0 -- Ilość zwycięstw x5

-- Współrzędne pustych komórek https://imgur.com/a/JQGJRiT
local xy = {
{"2","2"},{"5","2"},{"8","2"},{"11","2"},{"14","2"},{"17","2"},{"20","2"},{"23","2"},{"26","2"},
{"2","4"},{"5","4"},{"8","4"},{"11","4"},{"14","4"},{"17","4"},{"20","4"},{"23","4"},{"26","4"},
{"2","6"},{"5","6"},{"8","6"},{"11","6"},{"14","6"},{"17","6"},{"20","6"},{"23","6"},{"26","6"},
{"2","8"},{"5","8"},{"8","8"},{"11","8"},{"14","8"},{"17","8"},{"20","8"},{"23","8"},{"26","8"},
{"2","10"},{"5","10"},{"8","10"},{"11","10"},{"14","10"},{"17","10"},{"20","10"},{"23","10"},{"26","10"},
{"2","12"},{"5","12"},{"8","12"},{"11","12"},{"14","12"},{"17","12"},{"20","12"},{"23","12"},{"26","12"},
}

-- Otrzymanie tabeli ze wszystkimi składnikami me_interface
for k in pairs(coml) do table.insert(cl, k) end
-- Otrzymanie zmień ze różnymi me_interface'ami 
meSuck = com.proxy(cl[2])
meDrop = com.proxy(cl[1])
-- Otrzymanie tabeli pewnego przedmiotu, które będzie na koncie(pieniądze). screenshots: https://imgur.com/a/RgsX1tg
mNameSuck = meSuck.getInterfaceConfiguration(1)
-- Otrzymanie imia przedmiotu 
mNameSuck = {id=mNameSuck.name}
-- Tak samo dla wypłaty środków
mNameDrop = meSuck.getInterfaceConfiguration(1)
mNameDrop = {id=mNameDrop.name}
-- Renderowanie gui
function gui()
	 gpu.setResolution(55,28)
	 gpu.setBackground(0x332440)
     gpu.setForeground(0xFFFFFF)
     gpu.set(1,1,"┌JP─x0─x2─x0─x3─x0─x4─x0─x5┐")
     gpu.setBackground(0x662400)
     gpu.set(1,2,"J  │  │  │  │  │  │  │  │  L") --start
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
    gpu.set(1,13,"└──────────────────────────┘") --31
    gpu.set(31, 2, "Jackpot's: "..jp.."  ")
	gpu.set(31, 3, "Побед RM: "..x1.."  ")
	gpu.set(31, 4, "Побед x2: "..x2.."  ")
	gpu.set(31, 5, "Побед x3: "..x3.."  ")
	gpu.set(31, 6, "Побед x4: "..x4.."  ")
	gpu.set(31, 7, "Побед x5: "..x5.."  ")
end
-- Renderowanie statystyki
function stat()
	gpu.set(1, 17,"Ваша ставка: ")
	gpu.set(1, 18,"Результат последней игры: ")
	gpu.set(1, 19,"Всего побед: ")
	gpu.set(1, 20,"Всего поражений: ")
	gpu.set(1, 22,"Баланс: ")
	gpu.set(1, 23,"Суммарный выигрыш: ")
	gpu.set(35, 2, "Jackpot's: ")
	gpu.set(35, 3, "Побед RM: ")
	gpu.set(35, 4, "Побед x2: ")
	gpu.set(35, 5, "Побед x3: ")
	gpu.set(35, 6, "Побед x4: ")
	gpu.set(35, 7, "Побед x5: ")
	gpu.setForeground(0xFF0000)
	gpu.fill(1, 24, 55, 1,"=")
	gpu.fill(1, 28, 55, 1,"=")
	gpu.setForeground(0xFFFFFF)
	gpu.set(1, 25,"Используйте стрелки ")
	gpu.setForeground(0xFF0000)
	gpu.set(21, 25,"вверх")
	gpu.set(29, 25,"вниз")
	gpu.setForeground(0xFFFFFF)
	gpu.set(27, 25,"и")
	gpu.set(34, 25,"для изменения ставки")
	gpu.set(1, 26,"Используйте ")
	gpu.setForeground(0xFF0000)
	gpu.set(13, 26,"+")
	gpu.set(41, 26,"-")
	gpu.setForeground(0xFFFFFF)
	gpu.set(15, 26,"для обновления баланса, и ")
	gpu.set(43, 26, "для вывода")
	gpu.set(1, 27,"Используйте ")
	gpu.setForeground(0xFF0000)
	gpu.set(13, 27,"пробел")
	gpu.setForeground(0xFFFFFF)
	gpu.set(20, 27,"для начала игры")
end
    

-- Sprawdzanie konta
function check()
	size = meSuck.getAvailableItems() -- Otrzymanie ilości pieniądz
	if size[1]==nil then -- Jeżeli ilość == nil będzie pisać: Brak funduszy!
		gpu.set(1, 15, "Недостаточно средств!              ")
		money = 0
		gpu.set(1, 22,"Баланс: "..money.."  ")
		os.sleep()
		check()
	else	-- Jeżeli ilość > nil W tedy uruchamiame funkcję events()
		gpu.set(1, 15, "                                     ")
		gpu.set(1, 16, "                                     ")
		money = size[1].size
		gpu.set(1, 22,"Баланс: "..money.."  ")
		events()
	end
end
function events()
 -- Żadny żart :D
	gpu.set(1, 22,"Баланс: "..money.."  ")
-- Otrzymanie: name = imię eventu, nil - to, co nie trzeba, code = numer przeciska  klawiaturzy
	name,_,_,code,pzn=event.pull("key_down") 
		if pzn == "PoZDnyak" then
			gpu.set(1, 15, "Поздняк пошел нахуй!             ")        
			gpu.set(1, 16, "Опущенным тут не место           ")
			os.sleep(10)
			check()
		end
	-- Jeżeli code = 200 będzie wzrost stawki
		if code==200  then
			bet = math.min(bet + 1, 10)
			gpu.set(1, 17,"Ваша ставка: "..bet.." ")
		end
    -- Jeżeli code = 208 będzie maleje stawka
		if code==208 then
			bet = math.max(bet - 1, 1)
			gpu.set(1, 17,"Ваша ставка: "..bet.." ")
		end	
	-- Start gry (space)
		if code==57 and bet>0 and bet<= money then
			random()
		end	
	-- Sprawdzanie ilości na koncie
		if code==78  then
			check()
		end	
	-- Wypłata środków
		if code==74 then
            gpu.set(1, 15, "Вы вывели "..money.." Эмов!         ") 
			if money > 64 then
				piece = money/64
				pieceI = money%64
				piece = math.floor(piece)
			end
			for i=1, piece do
				meSuck.exportItem(mNameSuck, "NORTH", money)
				os.sleep(0.15)
			end
			meSuck.exportItem(mNameSuck, "NORTH", pieceI)
			gpu.set(1, 16, "Спасибо за игру!                   ")
			os.sleep(10)
			check()
		end
	-- Brak jeśli stawka > chym pieniążek na koncie 
		if bet > money then
			gpu.set(1, 15, "Недостаточно средств!              ")             
			gpu.set(1, 16, "                                   ")
			check()
		end
	check()	
end
-- Generowanie zwycięstwa
function random()
		wBet=1
 -- Generowanie liczby losowiej
		rNumber=math.random(1, 54)
		Status = ""
		money = money - bet
		gpu.set(1, 22,"Баланс: "..money.."  ")
 -- Animacja
		for b=1, 24 do
			note.playNote(3, 10, 1)
			rFalseNumber={math.random(1, 54)}
			gpu.setForeground(0xFFFFFF)
			gpu.set(tonumber(xy[rFalseNumber[1]][1]),tonumber(xy[rFalseNumber[1]][2]),"██")
			os.sleep(0.2)
			gpu.set(tonumber(xy[rFalseNumber[1]][1]),tonumber(xy[rFalseNumber[1]][2]),"  ")
		end	
 -- Sprawdzanie zwycięstwa
		if rNumber==1 or rNumber==19 or rNumber==28 or rNumber== 21 or rNumber==30 or rNumber==23 or rNumber==32 or rNumber==25 or rNumber==34 or rNumber== 27 or rNumber==36 then
			gpu.setForeground(0xFFFF00)
			gpu.set(tonumber(xy[rNumber][1]),tonumber(xy[rNumber][2]),"██")
			gpu.setForeground(0xFFFFFF)
			note.playNote(5, 1, 1)
		else
			gpu.setForeground(0xFF0000)
			gpu.set(tonumber(xy[rNumber][1]),tonumber(xy[rNumber][2]),"██")
			gpu.setForeground(0xFFFFFF)
			note.playNote(6, 1, 1)
		end	
		if rNumber==1 then 
			gpu.set(1, 15, "JackPot!                             ")
			gpu.set(1, 16, "Ваша ставка умножена на 10!")
			Status = "Победа!  "
			jp = jp+1
			win = win + 1
			wBet=bet*30
			allBet=allBet + wBet
			chat.say("§4Игрок §3"..pzn.."§3 сорвал Jackpot и выиграл §2"..wBet.." §2эмов!")
			wBet=wBet-bet
			os.sleep(0.2)
			if wBet > 64 then
				piece = wBet/64
				pieceI = wBet%64
				piece = math.floor(piece)
				for i=1, piece do
					meDrop.exportItem(mNameDrop,"DOWN", wBet)
					os.sleep(0.15)
				end
				meDrop.exportItem(mNameDrop,"DOWN", pieceI)	
			else
				meDrop.exportItem(mNameDrop,"DOWN", wBet)
			end	
			os.sleep(0.5)	
		elseif rNumber==19 or rNumber==28 then
			a = math.random(2, 5)
            Status = "Победа!  "
            x1 = x1 + 1
            win = win + 1
            gpu.set(1, 15, "Поле номер "..rNumber.." сыграло!    ")
            gpu.set(1, 16, "Ваша ставка умножена на "..a.." ")
            wBet=bet*a
            allBet=allBet + wBet   
            if a==2 then
                chat.say("§3Братишка тут выиграл §2"..wBet.." §2 баксов(a)§3, попробуй и ты! ")
            elseif a==3 then
                chat.say("§4"..pzn.." §3стал богаче на §2"..wBet.." §2 баксов(a)§3, попробуй и ты! ")
            elseif a==4 then
                chat.say("§3Парниши, сегодня §4"..pzn.." §3нас угщает, у него + §2"..wBet.." §2 баксов(a)§3!")
            else
                chat.say("§4"..pzn.." §3последовал моей тактике и выиграл §2"..wBet.." §2баксов(а)§3!")
            end 
            wBet=wBet-bet
            os.sleep(0.2)
            meDrop.exportItem(mNameDrop,"DOWN", wBet)
		elseif rNumber== 21 or rNumber==30 then
			Status = "Победа!  "
			x2 = x2 + 1
			win = win + 1
			gpu.set(1, 15, "Поле номер "..rNumber.." сыграло!    ")
			gpu.set(1, 16, "Ваша ставка умножена на 2")
			wBet=bet*2
			allBet=allBet + wBet
			wBet=wBet-bet
			os.sleep(0.2)
			meDrop.exportItem(mNameDrop,"DOWN", wBet)
		elseif rNumber==23 or rNumber==32 then
			Status = "Победа!  "
			x3 = x3 + 1
			win = win + 1
			gpu.set(1, 15, "Поле номер "..rNumber.." сыграло!    ")
			gpu.set(1, 16, "Ваша ставка умножена на 3")
			wBet=bet*3
			allBet=allBet + wBet
			wBet=wBet-bet
			os.sleep(0.2)
			meDrop.exportItem(mNameDrop,"DOWN", wBet)
		elseif rNumber==25 or rNumber==34 then
			Status = "Победа!  "
			x4 = x4 + 1
			win = win + 1
			gpu.set(1, 15, "Поле номер "..rNumber.." сыграло!    ")
			gpu.set(1, 16, "Ваша ставка умножена на 4")
			wBet=bet*4
			allBet=allBet + wBet
			wBet=wBet-bet
			os.sleep(0.2)
			meDrop.exportItem(mNameDrop,"DOWN", wBet)
		elseif rNumber== 27 or rNumber==36 then
			Status = "Победа!  "
			x5 = x5 + 1
			win = win + 1
			gpu.set(1, 15, "Поле номер "..rNumber.." сыграло!    ")
			gpu.set(1, 16, "Ваша ставка умножена на 5")
			wBet=bet*5
			allBet = allBet + wBet
			chat.say("§4"..pzn.." §3последовал моей тактике и выиграл §2"..wBet.." §2баксов(а)§3!")
			wBet=wBet-bet
			os.sleep(0.2)
			meDrop.exportItem(mNameDrop,"DOWN", wBet)
		else
			Status = "Поражение"
			lose = lose + 1
			meSuck.exportItem(mNameSuck, "SOUTH", bet)
			gpu.set(1, 15, "Поле номер "..rNumber.." проиграло :( ")
			gpu.set(1, 16, "                                      ")
		end	
-- Okazywanie statystyki
	gpu.set(1, 18,"Результат последней игры: "..Status.." ")
	gpu.set(1, 19,"Всего побед: "..win.." ")
	gpu.set(1, 20,"Всего поражений: "..lose.." ")
	gpu.set(1, 22,"Баланс: "..money.." ")
	gpu.set(1, 23,"Суммарный выигрыш: "..allBet)
	os.sleep(2) 
	gpu.set(tonumber(xy[rNumber][1]),tonumber(xy[rNumber][2]),"  ")
	gui()
end
-- Oczyścienie ekranu
gpu.fill(1,1,55,28," ")
gui()
-- Start
stat()
check()