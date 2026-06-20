local ffi = require("ffi")
local sdl = require("sunui.core.sdl")
local SDL = sdl.lib

local SunUI = {}

function SunUI:init(title, w, h)
    if SDL.SDL_Init(sdl.constants.INIT_VIDEO) < 0 then
        error("SDL Init Failed")
    end
    
    if SDL.TTF_Init() < 0 then
        error("TTF Init Failed")
    end
    
    self.window = SDL.SDL_CreateWindow(title, 0x2FFF0000, 0x2FFF0000, w, h, sdl.constants.WINDOW_SHOWN)
    if self.window == nil then error("Window creation failed") end
    
    self.renderer = SDL.SDL_CreateRenderer(self.window, -1, sdl.constants.RENDERER_ACCELERATED)
    if self.renderer == nil then error("Renderer creation failed") end
    
    self.running = true
end

function SunUI:run(root_element)
    local event = ffi.new("SDL_Event")
    
    while self.running do
        while SDL.SDL_PollEvent(event) ~= 0 do
            if event.type == sdl.constants.QUIT then
                self.running = false
            else
                root_element:handle_event(event, sdl.constants)
            end
        end
        
        SDL.SDL_SetRenderDrawColor(self.renderer, 0, 0, 0, 255)
        SDL.SDL_RenderClear(self.renderer)
        
        root_element:draw(self.renderer, 0, 0)
        
        SDL.SDL_RenderPresent(self.renderer)
    end
    
    SDL.SDL_DestroyRenderer(self.renderer)
    SDL.SDL_DestroyWindow(self.window)
    SDL.TTF_Quit()
    SDL.SDL_Quit()
end

return SunUI
