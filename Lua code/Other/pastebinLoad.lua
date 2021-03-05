local component = require("component")
local fs = require("filesystem")
local internet = require("internet")
local shell = require("shell")
local event = require("event")
pasteURL = "xWfyMf90"
filename = "test"
autorun = true
eventRun = false
url = "http://pastebin.com/raw/"..pasteURL 
os.remove(filename)

f, reason = io.open(filename, "w")
result, response = pcall(internet.request, url)
print("Downloading from pastebin.com...\n")
print("success. \n") 
if result == true then
	for chunk in response do
		f:write(chunk)
	end	
else
	print("Error")
	os.remove("/home/"..filename)
end		
f:close()
print("Saved data to "..filename)
if autorun == true then
	os.execute(filename)	
end

--{{trade={{},copperInSystem=4299,copperOre=0,goldMultiplier=0,leadInSystem=4225,copperIngots=0,uranItem=0,uranInSystem=400,ironOre=256,copperMultiplier=0,goldOre=0,leadIngots=0,leadMultiplier=0,tinInsystem=4225,tinMultiplie=0,uranOre=0,leadOre=0,ironIngots=563,goldInSystem=3968,ironMultiplier=2.2,tinIngots=0,goldIngots=0,tinOre=0,cellType="appliedenergistics2:item.ItemBasicStorageCell.64k",ironInSystem=2697},name="ReiVanSTR",date="12-7  21:04:40"}