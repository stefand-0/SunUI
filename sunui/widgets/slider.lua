local ffi = require("ffi")
local Element = require("sunui.core.element")
local sdl = require("sunui.core.sdl")
local SDL = sdl.lib

local Slider = setmetatable({}, {__index = Element})
Slider.__index = Slider

function Slider:new(props)
    local instance = Element.new(self, props)
    instance.min = props.min or 0
    instance.max = props.max or 100
    instance.value = props.value or 50
    instance.on_change = props.on_change
    return instance
end

function Slider:_draw_self(renderer, abs_x, abs_y)
    -- Track background
    SDL.SDL_SetRenderDrawColor(renderer, 50, 55, 65, 255)
    local track = ffi.new("SDL_Rect", { x = abs_x, y = abs_y + (self.h/2) - 2, w = self.w, h = 4 })
    SDL.SDL_RenderFillRect(renderer, track)
    
    -- Handle
    local pct = (self.value - self.min) / (self.max - self.min)
    local handle_x = abs_x + (pct * (self.w - 16))
    SDL.SDL_SetRenderDrawColor(renderer, 52, 152, 219, 255)
    local handle = ffi.new("SDL_Rect", { x = handle_x, y = abs_y, w = 16, h = self.h })
    SDL.SDL_RenderFillRect(renderer, handle)
end

return Slider
