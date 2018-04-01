local component = require("component")
local GUI = require("GUI")
local MineOSInterface = require("MineOSInterface")
local buffer = require("doubleBuffering")
local fs = require("filesystem")
local defaultPath = "/EFIFlash/"
local dumpFileName = "Dump" .. math.random(1, 1000) .. ".efi"
----------Image----------

---------------------------------------------
fs.makeDirectory(defaultPath)
-------------mainWindow--------------------
local mainContainer, window = MineOSInterface.addWindow(MineOSInterface.filledWindow(1, 1, 88, 26, 0xF0F0F0))
local container = window:addChild(GUI.container(1, 1, window.width, window.height))
layout = container:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))
layout:setGridSize(3,1)
----------------------------------------------drawingInterface-----------------
local filesystemChooser = layout:addChild(GUI.filesystemChooser(2, 2, 25, 3, 0xE1E1E1, 0x888888, 0x3C3C3C, 0x888888, nil, "Open", "Cancel", "Choose", "/"))
filesystemChooser.onSubmit = function(path)
	local file = io.open(path, "r")
	flashFile = file:read("*a")
end
local button1 = layout:setCellPosition(2, 1, layout:addChild(GUI.button(2, 2, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Dump")))
button1.onTouch = function()
	local dumpFile = io.open(defaultPath .. dumpFileName, "w")
	dumpFile:write(component.eeprom.get())
	dumpFile:close()
	dumpFileName = "Dump" .. math.random(1, 1000) .. ".efi"
	GUI.error("Dumped File, filename is: " .. dumpFileName)
end
local button2 = layout:setCellPosition(3, 1, layout:addChild(GUI.button(2, 2, 25, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Flash")))
button2.onTouch = function()
	component.eeprom.set(flashFile)
	GUI.error("Flashed EEPROM")
end
layout:setCellFitting(3, 1, true, false, 1)
layout:setCellFitting(2, 1, true, false, 1)
layout:setCellFitting(1, 1, true, false, 1)
---------------------------
window.onResize = function(width, height)
	window.backgroundPanel.width = width
	window.backgroundPanel.height = height - 3
	container.width = width
	container.height = height - 3
	layout.width = width
	layout.height = height - 3
end
mainContainer:draw()
container:draw()
buffer.draw(true)
mainContainer:startEventHandling()