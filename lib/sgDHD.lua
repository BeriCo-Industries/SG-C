local comp = require"component"
local term = require"term"
local os = require"os"
local gpu = comp.gpu
local sg = comp.stargate

local sgDHD = {}

local colors = {
["red"] = 0xFF0000,
["green"] = 0x00FF00,
["blue"] = 0x0000FF,
["black"] = 0x000000,
["white"] = 0xFFFFFF
}

sgDHD.show = true
sgDHD.updateScreen = true

sgDHD.dialLight = false

sgDHD.addPart1 = ""
sgDHD.addPart2 = ""
sgDHD.addPart3 = ""

function sgDHD.dhd()

  gpu.setResolution(34,12)--just for the DHD gets reset when exiting DHD
  gpu.setForeground(colors["white"])
  gpu.setBackground(colors["black"])

  gpu.set(9,3,"MANUAL ADDRESS MODE")

  gpu.setForeground(colors["black"])
  gpu.setBackground(0xA5A5A5)--sets a gray shade for the Address input
  gpu.fill(13,5,4,1," ")--draws the line where the address is shown - part 1/3
  gpu.fill(18,5,3,1," ")--draws the line where the address is shown - part 2/3
  gpu.fill(22,5,2,1," ")--draws the line where the address is shown - part 3/3

  gpu.setForeground(colors["white"])
  gpu.setBackground(colors["black"])
  gpu.set(17,5, "-")--draws the - for the Address
  gpu.set(21,5, "-")--draws the - for the Address

  gpu.set(13,7,"01234 56789")--numbers
  gpu.set(12,8,"ABCDEFGHIJKLM")--alphabet part 1
  gpu.set(12,9,"NOPQRSTUVWXYZ")--alphabet part 2

  gpu.setBackground(0xA5A5A5)
  gpu.set(13,5,sgDHD.addPart1)--prints the first part of the Address
  gpu.set(18,5,sgDHD.addPart2)--prints the first part of the Address
  gpu.set(22,5,sgDHD.addPart3)--prints the first part of the Address
  gpu.setBackground(colors["black"])

  gpu.set(10,11,"BACK")--the exit manual mode button

  if sgDHD.dialLight then
    gpu.setBackground(colors["green"])
    gpu.set(17,11,"DIAL")--the dial button
    gpu.setBackground(colors["black"])
  else
    gpu.set(17,11,"DIAL")--the dial button
  end

  gpu.set(24,11,"DEL")--the delete button

end

return sgDHD
