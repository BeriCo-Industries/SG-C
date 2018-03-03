local comp = require"component"
local term = require"term"
local os = require"os"
local gpu = comp.gpu
local sg = comp.stargate

local sgS = {}

local colors = {
["red"] = 0xFF0000,
["green"] = 0x00FF00,
["blue"] = 0x0000FF,
["black"] = 0x000000,
["white"] = 0xFFFFFF,
["orange"] = 0xcc4900,--for control background
["strongBlue"] = 0x0049C0,--for status background
["strongGreen"] = 0x006D00
}

sgS.destAdd = ""

sgS.addListPos = {}--for add highlighting
sgS.pageButtonPos = {}--for the buttons down there
sgS.page = 1
sgS.addMarked = {0,0}

--control panel vars
sgS.dialling = false

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
function sgS.status(gates)

	if sgS.addMarked[1] ~= 0 then
		sgS.destAdd = gates[sgS.addMarked[2]][sgS.addMarked[1]][2]
	else
		sgS.destAdd = sg.remoteAddress()
	end

	local localAdd = sg.localAddress()
	local storedRF = math.floor(sg.energyAvailable()*80) .." kF"
	local neededRF = "0 RF"
	local gateState,chev,direction = sg.stargateState()
	local irisState = sg.irisState()

	local idcUser = "NONE"--TODO: change this just for testing

	if gateState == "Dialling" and sgS.dialling == false and sgS.addMarked[3] ~= "done" then
		sgS.addMarked = {0,0,"Incoming"}
		sgS.destAdd = sg.remoteAddress()
	end

	if sg.energyToDial(sgS.destAdd) then
		neededRF = math.floor(sg.energyToDial(sgS.destAdd)*80) .." RF"
	else
		neededRF = "0 RF"
	end

	gpu.setBackground(colors["strongBlue"])
	gpu.setForeground(colors["black"])

	gpu.fill(1, 1, 52, 14, " ")--status panel

	gpu.set(4, 2, "STATUS PANEL")

	gpu.set(4, 4, "Local Address:")
	gpu.set(33, 4, localAdd)
	gpu.set(4, 5, "Dest. Address:")
	gpu.set(33, 5, sgS.destAdd)

	gpu.set(4, 7, "Stored Power:")
	gpu.set(33, 7, storedRF)
	gpu.set(4, 8, "Needed Power:")
	gpu.set(33, 8, neededRF)

	gpu.set(4, 10, "Iris:")
	gpu.set(33, 10, irisState)
	gpu.set(4, 11, "Gate Status:")
	gpu.set(33, 11, gateState)
	gpu.set(4, 12, "IDC:")
	gpu.set(33, 12, idcUser)

	--reset to default
	gpu.setBackground(colors["black"])
	gpu.setForeground(colors["white"])

end

--gets the size aof the defined table
function sgS.tableLength(table)
	local count = 0
	for _,_ in pairs(table) do
		count = count + 1
	end
	return count
end


--address list right top to bottom max 8
function sgS.addList(gateList, marked, page)

	local addPos = 1
	local inDex = 1
	local energyReq = "0 RF"

	gpu.setBackground(colors["strongGreen"])
	gpu.setForeground(colors["black"])

	gpu.fill(54, 1, 43, 30, " ")--status panel

	gpu.set(69, 2, "ADDRESS LIST")

	for k, v in pairs(gateList[page]) do
		sgS.addListPos[inDex] = {57,addPos+3,39,2}
		inDex = inDex+1

		if sg.energyToDial(gateList[page][k][2]) then
			energyReq = math.floor(sg.energyToDial(gateList[page][k][2])*80) .." RF"
		else
			energyReq = "No Gate at Address"
		end

		if marked[1] == k and marked[2] == sgS.page then
			gpu.setBackground(colors["black"])
			gpu.setForeground(colors["white"])
			gpu.fill(sgS.addListPos[k][1],sgS.addListPos[k][2],sgS.addListPos[k][3],sgS.addListPos[k][4], " ")
			gpu.set(58, addPos+3, "Name: ".. gateList[page][k][1])--max name length 11
			gpu.set(75, addPos+3, "Address: ".. gateList[page][k][2])
			gpu.set(58, addPos+4, "Energy req: ".. energyReq)
			gpu.setBackground(colors["strongGreen"])
			gpu.setForeground(colors["black"])
		else
			gpu.set(58, addPos+3, "Name: ".. gateList[page][k][1])--max name length 11
			gpu.set(75, addPos+3, "Address: ".. gateList[page][k][2])
			gpu.set(58, addPos+4, "Energy req: ".. energyReq)
		end
		addPos = addPos + 3
	end

	local counter = 0
	local row = 1
	local xButton = 51
	local yButton = 28

	while counter < sgS.tableLength(gateList) do
		if counter == 8 and row < 2 then --max pages for panel max row 2
			yButton = yButton + 1
			xButton = 51
			row = 2
		else
			counter = counter + 1
			xButton = xButton + 5
			if counter > 9 then
				gpu.set(xButton, yButton, "<".. counter ..">")
			else
				gpu.set(xButton, yButton, "<0".. counter ..">")
			end
			sgS.pageButtonPos[counter] = {xButton, yButton}
		end
	end


	--reset to default
	gpu.setBackground(colors["black"])
	gpu.setForeground(colors["white"])

end

--status display top right
function sgS.control()

	gpu.setBackground(colors["orange"])
	gpu.setForeground(colors["black"])

	gpu.fill(1, 17, 52, 15, " ")--control panel

	gpu.set(4, 18, "CONTROL PANEL")

	--reset to default
	gpu.setBackground(colors["black"])
	gpu.setForeground(colors["white"])

end

return sgS
