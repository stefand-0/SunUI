local ffi = require("ffi")
local Element = require("sunui.core.element")
local sdl = require("sunui.core.sdl")
local SDL = sdl.lib

local Button = setmetatable({}, {__index = Element})
Button.__index = Button

function Button:new(props)
    local instance = Element.new(self, props)
    instance.normal_color = props.normal_color or {46, 204, 113, 255}
    instance.hover_color  = props.hover_color or {88, 214, 141, 255}
    instance.active_color = props.active_color or {39, 174, 96, 255}
    instance.on_click     = props.on_click
    instance.state        = "normal"
    return instance
end

function Button:_draw_self(renderer, abs_x, abs_y)
    local c = self.normal_color
    if self.state == "hover" then c = self.hover_color
    elseif self.state == "active" then c = self.active_color end
    
    SDL.SDL_SetRenderDrawColor(renderer, c[1], c[2], c[3], c[4])
    local rect = ffi.new("SDL_Rect", { x = abs_x, y = abs_y, w = self.w, h = self.h })
    SDL.SDL_RenderFillRect(renderer, rect)
end

return Button
