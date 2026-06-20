-- sunui/widgets/button.lua
local ffi = require("ffi")
local Element = require("sunui.core.element")
local sdl = require("sunui.core.sdl")
local SDL = sdl.lib

local Button = setmetatable({}, {__index = Element})
Button.__index = Button

function Button:new(props)
    local instance = Element.new(self, props)
    
    instance.normal_color = props.normal_color or {0, 122, 255, 255}
    instance.hover_color  = props.hover_color  or {40, 150, 255, 255}
    instance.active_color = props.active_color or {0, 90, 200, 255}
    
    instance.is_active = false
    instance.action = props.on_click
    
    return instance
end

function Button:on_mouseenter()
    self.is_hovered = true
end

function Button:on_mouseleave()
    self.is_hovered = false
    self.is_active = false
end

function Button:on_click()
    self.is_active = true
    if self.action then self.action() end
end

function Button:_draw_self(renderer, abs_x, abs_y)
    local current_color = self.normal_color
    if self.is_active then
        current_color = self.active_color
    elseif self.is_hovered then
        current_color = self.hover_color
    end

    SDL.SDL_SetRenderDrawColor(renderer, current_color[1], current_color[2], current_color[3], current_color[4])
    local rect = ffi.new("SDL_Rect", { x = abs_x, y = abs_y, w = self.w, h = self.h })
    SDL.SDL_RenderFillRect(renderer, rect)
end

return Button