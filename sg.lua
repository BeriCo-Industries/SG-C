local sgS = require"sgS"
local sgMech = require"sgMech"
local comp = require"component"
local term = require"term"
local event = require"event"
local gpu = comp.gpu

local run = true

--addresses
local gates = {{
	{"G1", "VV95-R37-DB"},
	{"G2", "TV94-Q38-3S"},
	{"G3", "71FB-X31-YM"},
	{"G4", "51FA-W32-O2"},
	{"G5", "J1FH-33P-47"},
	{"G6", "H1FG-23Q-VN"},
	{"G7", "V1FN-93J-QH"},
	{"G8", "T1FM-83K-GX"}
},{
	{"G9", "T1FM-83K-GF"}
}
}

--event init
event.listen("key_down", sgMech.keyListener)
event.listen("touch", sgMech.touchListener)

function listenerStop()

	event.ignore("key_down", sgMech.keyListener)
	event.ignore("touch", sgMech.touchListener)

end

gpu.setResolution(96,30)

term.clear()
sgS.addList(gates,sgS.addMarked,sgS.page)--address list
sgS.control()--control panel

--main loop
while run do

	sgMech.markerChange()
	sgS.status(gates)--status updates


	if sgMech.change then
		sgS.addList(gates,sgS.addMarked,sgS.page)--address list
		sgMech.change = false
	end

	os.sleep(0.125)

	if sgMech.stop then
		run = false
		term.clear()
		print("Shutting down")
		listenerStop()
		--event.ignore("key_down", sgMech.keyListener)--stops listener
		sgMech.stop = false
		os.sleep(0.5)
		term.clear()
	end

end
