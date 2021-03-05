local component = require("component")
local gpu = component.gpu
local event = require("event")
local chat = component.chat_box
local redstone = component.redstone
chat.setName("§r§6Cплифер Артём§7§l")
canStart = {"ReiVanSTR","OB1CHAM","wot1230815","feod0r","Black_Vizor"}
print("Я загрузился")
while true do 
	_, add, msgNick, msg = event.pull(1,"chat_message")
	if msg ~= nil then
		for _,k in pairs(canStart) do
			if msgNick == k then
				if msg == "#open" then
					chat.say("§r§3Opened")
					redstone.setOutput(1,1)
				end	
				if msg == "#close" then
					chat.say("§r§4Closed")
					redstone.setOutput(1,0)
				end	
			end	
		end	
	end	
end