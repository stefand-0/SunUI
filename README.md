# SunUI ☀️
A simple UI framework for the Lua language.

# Features ☀️

• Pure Lua, utilising FFI for best performance with SDL2.

• Simple hierarchical GUIs, with no overhead bloat.

○ No need for external window managers, SDL handles it! 

# Quick Start ☀️

* Requirements

LuaJIT

SDL2 Runtime Binary (.dll):

  1. Windows: Place `sdl2.dll` in your root folder
  2. macOS / Linux: Ensure `SDL2` is installed globally. 

# Getting Started

• Make a file called `main.lua`:
```lua
local SunUI = require("sunui")
local Background = require("sunui.widgets.bg")

-- Initialize a window via the SunUI framework engine
SunUI:init("SunUI Application Workspace", 800, 600)

-- Create an interactive panel element
local interactive_panel = Background:new({
    x = 300, y = 220, w = 200, h = 160,
    color = {70, 130, 180, 255} -- Slate Blue
})

-- Handle Hover & Mouse Interact States
function interactive_panel:on_mouseenter()
    self.color = {100, 149, 237, 255} -- Light Cornflower Blue
end

function interactive_panel:on_mouseleave()
    self.color = {70, 130, 180, 255} -- Back to Blue
end

function interactive_panel:on_click()
    print("UI Element Clicked!")
    self.color = {220, 20, 60, 255} -- Flash Crimson
end

-- Start the application lifecycle main thread loop
SunUI:run(interactive_panel)
```

• Run the app:
Execute in the terminal using `LuaJIT`:
```bash
luajit main.lua
```

# License ☀️ 
This project is open-source and available under the Apache License Version 2.0