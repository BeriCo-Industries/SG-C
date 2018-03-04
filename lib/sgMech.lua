local comp = require"component"
local term = require"term"
local os = require"os"
local event = require"event"
local sg = comp.stargate

--custom librarys
local sgS = require"sgS"
local sgDHD = require"sgDHD"
local sgBP = require"sgBP"

local sgMech = {}

sgMech.stop = false
sgMech.change = false

--for user input via keyboard
function sgMech.keyListener(_,_,_,key,_)

	if key == 16 then--16 -> key 'q'
		sgMech.stop = true--set stopbool to true for shutdown
	end

end

function sgMech.touchListener(_,_,xPos,yPos,button,_)

	--for the Page Buttons
	local pageButtons = sgS.pageButtonPos
	local addEntry = sgS.addListPos
	for k,_ in pairs(pageButtons) do
		if xPos >= pageButtons[k][1] and xPos <= pageButtons[k][1]+4 and yPos == pageButtons[k][2] then
			sgS.page = k
			sgMech.change = true
		end
	end

	if sgDHD.show then
		local DHD = {
			["buttonRow"] = sgBP.buttonRow,
			["numbers"] = sgBP.numbers,
			["alphabet"] = sgBP.alphabet
		}
		for k1,_ in pairs(DHD) do
			if k1 == "buttonRow" then
				--for the back button
				for k2,_ in pairs(DHD[k1]) do
					if xPos >= DHD[k1][k2][1] and xPos <= DHD[k1][k2][1] + DHD[k1][k2][3] and yPos == DHD[k1][k2][2] then
						if k2 == "BACK" then
							sgDHD.show = false
						elseif k2 == "DIAL" then
							sgS.destAdd = sgDHD.addPart1.."-"..sgDHD.addPart2.."-"..sgDHD.addPart3
							sgMech.dial(sgS.destAdd)--dials the address
							sgDHD.show = false
						elseif k2 == "DEL" then
							sgDHD.addPart1 = ""
							sgDHD.addPart2 = ""
							sgDHD.addPart3 = ""
						end
					end
				end
			else
				-- for the numbers and alphabet
				for k2,_ in pairs(DHD[k1]) do
					if xPos == DHD[k1][k2][1] and yPos == DHD[k1][k2][2] then
						if string.len(sgDHD.addPart1) < 4 then
							sgDHD.addPart1 = sgDHD.addPart1..k2
						elseif string.len(sgDHD.addPart2) < 3 then
							sgDHD.addPart2 = sgDHD.addPart2..k2
						elseif string.len(sgDHD.addPart3) < 2 then
							sgDHD.addPart3 = sgDHD.addPart3..k2
						end
						if string.len(sgDHD.addPart1) == 4 and string.len(sgDHD.addPart2) == 3 then
							sgDHD.dialLight = true
						end
					end
				end
			end
		end
	end

	--for the address List entrys
	for k,_ in pairs(addEntry) do

		local xb = addEntry[k][1]
		local xe = addEntry[k][1] + addEntry[k][3]
		local yb = addEntry[k][2]
		local ye = addEntry[k][2] + addEntry[k][4]

		if xPos >= xb and xPos <= xe and yPos >= yb and yPos <= ye then
			if sgS.addMarked[1] == k and sgS.addMarked[2] == sgS.page then
				sgS.addMarked = {0,0}
			else
				sgS.addMarked = {k, sgS.page}
			end
			sgMech.change = true
		end

	--sgMech.addMarker()
	end

end

function sgMech.markerChange()
	local state,chev,direction = sg.stargateState()
	if state == "Dialling" or state == "Connected" or state == "Opening" and sgS.dialling == false then
		if sgS.addMarked[1] >= 1 and sgS.addMarked[2] >= 1 then
			sgS.destAdd = sg.remoteAddress()
			sgS.addMarked = {0,0}
			sgMech.change = true
		end
	end
end

function sgMech.dial(destAdd)

	if sg.energyAvailable()*3 > sg.energyToDial(destAdd) then
		sg.dial(destAdd)
	end

end

return sgMech
