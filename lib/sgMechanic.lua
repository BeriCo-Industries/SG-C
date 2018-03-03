local comp = require"component"
local term = require"term"
local os = require"os"
local event = require"event"

local sgMech = {}


function sgMech.targetAdd()

	return targetAdd

end

function sgMech.crtlListener()

	event.listen("key_down", function() stop = false end)--closes program on press

end


return sgMech
