local sgS = require"sgS"
local sgMech = require"sgMech"
local comp = require"component"
local term = require"term"
local gpu = comp.gpu

local run = true
stop = false

--addresses
local gates = {
{"Test-B", "71FB-X31-YM"},
{"Test-R", "L1FJ-Y3O-EQ"}
}

function start()


--check if everything is ready
local checkT = {}--result for component checks

--sg_s.check(checkT)

sgMech.crtlListener()

end


gpu.setResolution(96,30)

term.clear()
start()
term.clear()
sgS.addList(gates)--address list

--main loop
while run do

	sgS.status(sgMech.targetAdd())--status updates

	os.sleep(0.25)

	if stop == true then
		run = false
		term.clear()
		print("Shutting down")
		os.sleep(0.5)
	end

end
