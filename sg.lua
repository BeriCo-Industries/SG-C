local sgS = require"sgS"
local sgMech = require"sgMech"
local comp = require"component"
local term = require"term"
local event = require"event"
local gpu = comp.gpu

local run = true

--addresses
local gates = {
{"Test-B", "71FB-X31-YM"},
{"Test-R", "L1FJ-Y3O-EQ"}
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
sgS.addList(gates)--address list

--main loop
while run do

	sgS.status(sgMech.targetAdd())--status updates

	os.sleep(0.25)

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
