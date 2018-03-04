--custom librarys
local sgS = require"sgS"
local sgMech = require"sgMech"
local sgDHD = require"sgDHD"

local comp = require"component"
local term = require"term"
local event = require"event"
local gpu = comp.gpu

local run = true

local width, height = gpu.maxResolution()

--addresses
local gates = {{
	{"G1", "59MK-MJM-WJ"},
	{"G2", "99MI-RJO-DF"},
	{"G3", "X9MC-LJU-R5"}
}
}

--event init
event.listen("key_down", sgMech.keyListener)
event.listen("touch", sgMech.touchListener)

local function listenerStop()

	event.ignore("key_down", sgMech.keyListener)
	event.ignore("touch", sgMech.touchListener)

end

local function exit()

	--remove global vars
	sgS.destAdd = nil
	sgS.addListPos = nil
	sgS.pageButtonPos = nil
	sgS.page = nil
	sgS.addMarked = nil
	sgS.dialling = nil
	sgMech.stop = nil
	sgMech.change = nil
	sgDHD.addPart1 = nil
	sgDHD.addPart2 = nil
	sgDHD.addPart3 = nil
	sgDHD.updateScreen = nil
	sgBP.buttonRow = nil
	sgBP.numbers = nil
	sgBP.alphabet = nil

	--final shutdown
	run = false
	term.clear()
	gpu.setResolution(width, height)--reset to default res
	print("Shutting down")
	listenerStop()
	sgMech.stop = false
	os.sleep(0.5)
	term.clear()

end

gpu.setResolution(96,30)

term.clear()
if sgDHD.show == false then
	sgS.addList(gates,sgS.addMarked,sgS.page)--address list
	sgS.control()--control panel
end

--main loop
while run do

	if sgDHD.show then
		sgDHD.dhd()--shows the DHD Screen
	else
		if sgDHD.updateScreen then
			term.clear()
			gpu.setResolution(96,30)--reset to default res
			sgS.control()--control panel
			sgS.status(gates)--status updates
			sgS.addList(gates,sgS.addMarked,sgS.page)--address list
			sgDHD.updateScreen = false
		end
		sgMech.markerChange()--addList marker updates
		sgS.status(gates)--status updates
	end


	if sgMech.change then
		sgS.addList(gates,sgS.addMarked,sgS.page)--address list
		sgMech.change = false
	end

	os.sleep(0.125)

	if sgMech.stop then
		exit()
	end

end
