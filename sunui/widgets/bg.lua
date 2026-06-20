local Element = require("sunui.core.element")
local sdl = require("sunui.core.sdl")

local Background = setmetatable({}, {__index = Element})
Background.__index = Background

function Background:new(props)
    props = props or {}
    local instance = Element.new(self, props)  
    -- Default to a dark gray background if no color is provided
    instance.color = props.color or {0.15, 0.16, 0.18, 1.0} 
    instance.border_color = props.border_color or nil
    instance.border_width = props.border_width or 1 
    return instance
end

function Background:_draw_self(renderer, abs_x, abs_y)
    -- Tell the GPU what color to paint with
    SDL.SDL_SetRenderDrawColor(renderer, self.color[1], self.color[2], self.color[3], self.color[4])
    
    -- Allocate a temp C struct for the rect coordinates
    local rect = ffi.new("SDL_Rect", { x = abs_x, y = abs_y, w = self.w, h = self.h })
    
    -- Draw it
    SDL.SDL_RenderFillRect(renderer, rect)
end

return background
