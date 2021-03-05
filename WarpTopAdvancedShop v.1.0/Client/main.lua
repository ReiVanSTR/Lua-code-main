local Drawer = require("guiDrawer")
local gui = require("guiLibrary")
local component = require("component")
local event = require("event")
local term = require("term")
local gpu = component.gpu
local articlePos, pagesPos
local findResult = {}
local cart = {}
local mainColor = 0x6600ff--0xcc6Dff
buttons = {{req="Main",buttonName="      Главная      "},{req="IC2",buttonName='  Industrial Craft '},{req="AE2",buttonName='Applied Energistics'},{req="Forestry",buttonName='     Forestry      '},{req="OC",buttonName='  Open Computers   '},{req="TE",buttonName=' Thermal Expansion '},{req="DE",buttonName=' Draconic Evolution'},{req="MFR",buttonName='MineFactoryReloaded'}}
articles = {
	{
		id="5586:1",
		display_name="Драконий нагрудник",
		cost=700,
		qty=1,
		stored=3,
		color=tierColors.tier5
	},
	{
		id="5586:1",
		display_name="Гравитационный нагрудник",
		cost=2500,
		qty=1,
		stored=5,
		color=tierColors.tier3
	},
	{
		id="5586:1",
		display_name="Нано-кираса",
		cost=35,
		qty=1,
		stored=15,
		color=tierColors.tier1
	},
	{
		id="5586:1",
		display_name="Гравитационный двигатель",
		cost=700,
		qty=1,
		stored=100,
		color=tierColors.tier2
	},
	{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},
	{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},
	{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},
	{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},
	{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},
	{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},
	{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},
	{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4},{id="5586:1",display_name="Ядро ваджры",cost=200,qty=2,stored=12,color=tierColors.tier4}
}

gui.clear()
Drawer.headerRaw("ReiVanSTR",1000)
Drawer.categoriesRaw()
Drawer.updatePos(articles)
Drawer.createButtons(buttons)
Drawer.cartRaw(mainColor,cart)
articlePos = Drawer.createPage(articles, 16)
pagesPos = Drawer.createPageSlider(articles)
gpu.setForeground(0xffffff)
Drawer.finderRaw()
while true do
	e,_,w,h,_,nick = event.pull(1,"touch")
	if nick ~= nil then	
		Drawer.checkButtons(w,h,buttons)
		Drawer.checkQuantity(w,h,articlePos,articles,cart)
		if gui.pressButton(w,h,Drawer.finderRaw()) then
			term.setCursor(102, 6)
			findResult = Drawer.fiderFind(articles, io.read())
			if #findResult ~= 0 then	
				articlePos=Drawer.createPage(findResult, 16)
				pagesPos = Drawer.createPageSlider(findResult)
			else
				articlePos = Drawer.createPageSlider(articles, 16)
				pagesPos = Drawer.createPageSlider(articles)
			end
			Drawer.finderRaw()
		end
		for k=1, #pagesPos do
			if gui.pressButton(w,h,pagesPos[k].button) then 
				if #findResult ~= 0 then
					articlePos = Drawer.createPage(Drawer.slidePage(findResult, pagesPos[k].pos), pagesPos[k].pos) 
					Drawer.createPageSlider(findResult) 
				else
					articlePos = Drawer.createPage(Drawer.slidePage(articles, pagesPos[k].pos), pagesPos[k].pos) 
					Drawer.createPageSlider(articles) 
				end
				Drawer.finderRaw()
			end
		end
	end
end
