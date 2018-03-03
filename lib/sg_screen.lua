local comp = require"component"
local term = require"term"
local os = require"os"
local gpu = comp.gpu
local sg = comp.stargate

local sgS = {}

local colors = {
["red"] = 0xff0000,
["green"] = 0x00ff00,
["blue"] = 0x0000ff,
["black"] = 0x000000,
["white"] = 0xffffff,
["orange"] = 0xcc4900,--for control background
["strongBlue"] = 0x0049c0--for status background
}

local destAdd = ""


--on program start
function sgS.check(list)

	gpu.setBackground(colors["black"])
	gpu.setForeground(colors["white"])

	local val = 3
	term.clear()

	for k,v in pairs(list) do 

		if v == "not found" then
			gpu.setForeground(colors["red"])
		end
		gpu.set(3,val+1, k ..": ".. v)
		gpu.setForeground(colors["white"])
	end

	os.sleep(0.5)
	term.clear()

end


--status display top right
function sgS.status(targetAdd)

	local x = 1
	local y = 1

	if targetAdd then
		destAdd = targetAdd
	else
		destAdd = sg.remoteAddress()
	end

	local localAdd = sg.localAddress()
	local storedRF = math.floor(sg.energyAvailable()*80) .." kF"
	local neededRF = math.floor(sg.energyToDial("L1FJ-Y3O-EQ")*80) .." RF"
	local irisState = sg.irisState()
	local gateState = sg.stargateState()
	local idcUser = "NONE"--TODO: change this just for testing

	gpu.setBackground(colors["strongBlue"])
	gpu.setForeground(colors["black"])

	gpu.fill(1, 1, 52, 14, " ")--status panel

	gpu.set(4, 2, "Local Address:")
	gpu.set(33, 2, localAdd)
	gpu.set(4, 3, "Dest. Address:")
	gpu.set(33, 3, destAdd)

	gpu.set(4, 5, "Stored Power:")
	gpu.set(33, 5, storedRF)
	gpu.set(4, 6, "Needed Power:")
	gpu.set(33, 6, neededRF)

	gpu.set(4, 8, "Iris:")
	gpu.set(33, 8, irisState)
	gpu.set(4, 9, "Gate Status:")
	gpu.set(33, 9, gateState)
	gpu.set(4, 10, "IDC:")
	gpu.set(33, 10, idcUser)

	--reset to default
	gpu.setBackground(colors["black"])
	gpu.setForeground(colors["white"])

end


--address list left top to bottom max 8
function sgS.addList(gateList)

	local addPos = 1

	gpu.setBackground(colors["white"])
	gpu.setForeground(colors["black"])

	gpu.fill(54, 1, 43, 30, " ")--status panel

	gpu.set(69, 2, "Address List")

	for k,v in pairs(gateList) do
		gpu.set(58, addPos+3, "Name: ".. gateList[k][1])--max name length 11
		gpu.set(75, addPos+3, "Address: ".. gateList[k][2])
		gpu.set(58, addPos+4, "Energy req: ".. math.floor(sg.energyToDial(gateList[k][2])*80) .." RF")
		addPos = addPos + 3
	end


	--reset to default
	gpu.setBackground(colors["black"])
	gpu.setForeground(colors["white"])

end



return sgS
