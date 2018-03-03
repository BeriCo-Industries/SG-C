local comp = require"component"
local term = require"term"
local os = require"os"
local event = require"event"

local sgMech = {}

sgMech.stop = false

function sgMech.targetAdd()

end

--for user input via keyboard
function sgMech.keyListener(_,_,_,key,_)

	if key == 16 then--16 -> key 'q'
		sgMech.stop = true--set stopbool to true for shutdown
	end

end

function sgMech.touchListener(a,b,c,d,e,f)

	print(a.." - "..b.." - "..c.." - "..d.." - "..e.." - "..f)
	--sgMech.addMarker()

end

function sgMech.addMarker()

end

return sgMech
