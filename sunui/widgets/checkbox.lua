local ffi = require("ffi")
local Element = require("sunui.core.element")
local sdl = require("sunui.core.sdl")
local SDL = sdl.lib

local Checkbox = setmetatable({}, {__index = Element})
Checkbox.__index = Checkbox

function Checkbox:new(props)
    props.w = props.size or 24
    props.h = props.size or 24
    local instance = Element.new(self, props)
    instance.checked = props.checked or false
    instance.on_toggle = props.on_toggle
    return instance
end

function Checkbox:_draw_self(renderer, abs_x, abs_y)
    -- Frame
    SDL.SDL_SetRenderDrawColor(renderer, 127, 140, 141, 255)
    local outer = ffi.new("SDL_Rect", { x = abs_x, y = abs_y, w = self.w, h = self.h })
    SDL.SDL_RenderFillRect(renderer, outer)
    
    -- Inner indicator
    if self.checked then
        SDL.SDL_SetRenderDrawColor(renderer, 46, 204, 113, 255)
        local inner = ffi.new("SDL_Rect", { x = abs_x + 4, y = abs_y + 4, w = self.w - 8, h = self.h - 8 })
        SDL.SDL_RenderFillRect(renderer, inner)
    else
        SDL.SDL_SetRenderDrawColor(renderer, 44, 62, 80, 255)
        local inner = ffi.new("SDL_Rect", { x = abs_x + 2, y = abs_y + 2, w = self.w - 4, h = self.h - 4 })
        SDL.SDL_RenderFillRect(renderer, inner)
    end
end

return Checkbox
