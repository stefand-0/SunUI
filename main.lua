package.path = package.path .. ";./?/init.lua;./?.lua"

local SunUI = require("sunui")
local Background = require("sunui.widgets.bg")
local Button = require("sunui.widgets.button")
local Slider = require("sunui.widgets.slider")
local Checkbox = require("sunui.widgets.checkbox")
local ProgressBar = require("sunui.widgets.progressbar")
local Divider = require("sunui.widgets.divider")

-- Initialize framework window canvas context
SunUI:init("SunUI Suite Sandbox", 800, 600)

-- Core interface panel layer
local panel = Background:new({ x = 50, y = 50, w = 400, h = 500, color = {30, 32, 40, 255} })

-- Configure component widgets with silent action handlers
local btn = Button:new({ x = 30, y = 40, w = 150, h = 40, on_click = function() end })

local progress = ProgressBar:new({ x = 30, y = 110, w = 340, h = 20, value = 40, max = 100 })

local slide = Slider:new({ 
    x = 30, 
    y = 160, 
    w = 340, 
    h = 30, 
    min = 0, 
    max = 100, 
    value = 40, 
    on_change = function(val) 
        progress:set_value(val)
    end 
})

local check = Checkbox:new({ x = 30, y = 220, size = 26, checked = true, on_toggle = function(state) end })

local separator = Divider:new({ x = 30, y = 280, w = 340, thickness = 2, color = {70, 75, 85, 255} })

-- Construct tree layout hierarchies
panel:add(btn)
panel:add(progress)
panel:add(slide)
panel:add(check)
panel:add(separator)

-- Spin up UI processing loop
SunUI:run(panel)
