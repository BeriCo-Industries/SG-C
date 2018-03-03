local comp = require"component"
local term = require"term"
local os = require"os"
local event = require"event"
local sgS = require"sgS"

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

	--for the address List entrys
	for k,_ in pairs(addEntry) do

		local xb = addEntry[k][1]
		local xe = addEntry[k][1]+addEntry[k][3]
		local yb = addEntry[k][2]
		local ye = addEntry[k][2] + addEntry[k][4]

		if xPos >= xb and xPos <= xe and yPos >= yb and yPos <= ye then
			sgS.addMarked = {k, sgS.page}
			sgMech.change = true
		end
	--sgMech.addMarker()
	end

end

function sgMech.markerChange()
	if sgS.addMarked[3] == "Incoming" then
		sgMech.change = true
		sgS.addMarked[3] = "done"
	end
end

return sgMech
