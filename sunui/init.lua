-- sunui/init.lua
local ffi = require("ffi")
local sdl = require("sunui.core.sdl")
local SDL = sdl.lib

local SunUI = {}

--- Initializes the underlying SDL subsystems, creates the OS window, and binds a GPU renderer.
-- @param title string The application title displayed on the window frame.
-- @param width number The window width in pixels.
-- @param height number The window height in pixels.
function SunUI:init(title, width, height)
    -- Initialize SDL's Video subsystem
    if SDL.SDL_Init(sdl.INIT_VIDEO) < 0 then
        error("Failed to initialize SDL video subsystem.")
    end

    -- Create the OS Window (0x2FFF0000 tells SDL to center the window automatically)
    self.window = SDL.SDL_CreateWindow(
        title, 
        0x2FFF0000, 0x2FFF0000, 
        width, height, 
        sdl.WINDOW_SHOWN
    )
    if self.window == nil then
        error("Failed to create native SDL window context.")
    end

    -- Create a Hardware accelerated Renderer 
    -- RENDERER_ACCELERATED pushes drawings to the GPU.
    self.renderer = SDL.SDL_CreateRenderer(self.window, -1, sdl.RENDERER_ACCELERATED)
    if self.renderer == nil then
        error("Failed to initialize hardware-accelerated renderer.")
    end

    -- Allocate single, reusable C memory block for processing OS inputs
    self.event = ffi.new("SDL_Event")
    self.running = true
end

--- Starts the foundational application framework execution thread.
-- @param root_element Element The top-level master UI component tree node.
function SunUI:run(root_element)
    if not self.renderer then
        error("SunUI engine must be initialized via SunUI:init() before calling run().")
    end

    while self.running do
        -- ==========================================
        -- 1. input polling...
        -- ==========================================
        while SDL.SDL_PollEvent(self.event) ~= 0 do
            -- Hardcoded global intercepts (like clicking the window 'X' close button)
            if self.event.type == sdl.QUIT then
                self.running = false
            end
            
            -- Route mouse coordinates/clicks down into the interactive SunUI tree
            if root_element then
                root_element:handle_event(self.event, sdl)
            end
        end

        -- ==========================================
        -- 2. drawing...
        -- ==========================================
        -- Clear backbuffer using a crisp dark-slate engine default workspace color
        SDL.SDL_SetRenderDrawColor(self.renderer, 20, 22, 26, 255)
        SDL.SDL_RenderClear(self.renderer)

        -- Trigger cascading relative layout rendering tree execution pass
        if root_element then
            root_element:draw(self.renderer, 0, 0)
        end

        -- Swap buffers to display newly compiled layout graphics onto the computer monitor
        SDL.SDL_RenderPresent(self.renderer)
    end

    -- ==========================================
    -- 3. destriction...
    -- ==========================================
    self:cleanup()
end

--- Safely tears down engine subsystems and releases hardware memory pointers back to the OS.
function SunUI:cleanup()
    if self.renderer then
        SDL.SDL_DestroyRenderer(self.renderer)
        self.renderer = nil
    end
    if self.window then
        SDL.SDL_DestroyWindow(self.window)
        self.window = nil
    end
    SDL.SDL_Quit()
end

return SunUI
