-- 
local ffi = require("ffi")
local sdl = require("sunui.core.sdl")
local SDL = sdl.lib

local SunUI = {}

function SunUI:init(title, width, height)
    if SDL.SDL_Init(sdl.INIT_VIDEO) < 0 then
        error("Failed to initialize SDL video subsystem.")
    end

    -- 0x2FFF0000 tells SDL to center the window automatically on screen
    self.window = SDL.SDL_CreateWindow(title, 0x2FFF0000, 0x2FFF0000, width, height, sdl.WINDOW_SHOWN)
    self.renderer = SDL.SDL_CreateRenderer(self.window, -1, sdl.RENDERER_ACCELERATED)
    self.running = true
    self.event = ffi.new("SDL_Event")
end

function SunUI:run(root_element)
    while self.running do
        -- Handle Events
        while SDL.SDL_PollEvent(self.event) ~= 0 do
            if self.event.type == sdl.QUIT then
                self.running = false
            end
            -- root_element:handle_event(self.event)
        end

        -- Clear Canvas
        SDL.SDL_SetRenderDrawColor(self.renderer, 20, 22, 26, 255) -- canvas background
        SDL.SDL_RenderClear(self.renderer)

        -- Draw SunUI Tree (passing absolute offset 0,0 for the root wrapper)
        if root_element then
            root_element:draw(self.renderer, 0, 0)
        end
        -- Flip backbuffer
        SDL.SDL_RenderPresent(self.renderer)
    end

    -- Cleanup when loop breaks
    SDL.SDL_DestroyRenderer(self.renderer)
    SDL.SDL_DestroyWindow(self.window)
    SDL.SDL_Quit()
end

return SunUI

