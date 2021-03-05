local component = require("component")
local fs = require("filesystem")
local internet = require("internet")
local shell = require("shell")
local computer = require("computer")
mainUser = "ReiVanSTR"
computer.adduser(mainUser)
mainURL = "16RWbPUH" 
pricesURL = "khLJDPCf"

function loadMain(urlRaw)
	filename = "main.lua"
	url = "http://pastebin.com/raw/"..urlRaw
	io.remove(filename)
	f, reason = io.open(filename, "w")
	result, response = pcall(internet.request, url)
	if result == true then
		for chunk in response do
			f:write(chunk)
		end	
	else
		print("Error in url")
		io.remove("/home/"..filename)
	end	
end

function loadPrices(urlRaw)
	filename = "pricesList.lua"
	url = "http://pastebin.com/raw/"..urlRaw
	io.remove(filename)
	f, reason = io.open(filename, "w")
	result, response = pcall(internet.request, url)
	if result == true then
		for chunk in response do
			f:write(chunk)
		end	
	else
		print("Error in url")
		io.remove("/home/"..filename)
	end	
end