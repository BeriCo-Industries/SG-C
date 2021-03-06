
local sgBP = {}


--sgDHD
sgBP.buttonRow = {
  ["BACK"] = {10,11, 4},--x,y,length
  ["DIAL"] = {17,11,4},
  ["DEL"] = {24,11,3}
}

sgBP.numbers = {
  ["0"] = {13,7},--x,y
  ["1"] = {14,7},
  ["2"] = {15,7},
  ["3"] = {16,7},
  ["4"] = {17,7},
  ["5"] = {19,7},
  ["6"] = {20,7},
  ["7"] = {21,7},
  ["8"] = {22,7},
  ["9"] = {23,7}
}

sgBP.alphabet = {
  ["A"] = {12,8},
  ["B"] = {13,8},
  ["C"] = {14,8},
  ["D"] = {15,8},
  ["E"] = {16,8},
  ["F"] = {17,8},
  ["G"] = {18,8},
  ["H"] = {19,8},
  ["I"] = {20,8},
  ["J"] = {21,8},
  ["K"] = {22,8},
  ["L"] = {23,8},
  ["M"] = {24,8},
  ["N"] = {12,9},
  ["O"] = {13,9},
  ["P"] = {14,9},
  ["Q"] = {15,9},
  ["R"] = {16,9},
  ["S"] = {17,9},
  ["T"] = {18,9},
  ["U"] = {19,9},
  ["V"] = {20,9},
  ["W"] = {21,9},
  ["X"] = {22,9},
  ["Y"] = {23,9},
  ["Z"] = {24,9}
}


--sgControl
sgBP.buttons = {
  ["dial"] = {4,20,4},--x,y,length
  ["close"] = {4,20, 5},
}

return sgBP
