-- sunui/widgets/slider.lua
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
    instance.value = props.value or instance.min
    
    instance.track_color = props.track_color or {60, 64, 72, 255}
    instance.handle_color = props.handle_color or {0, 122, 255, 255}
    instance.handle_width = props.handle_width or 16
    
    instance.is_dragging = false
    instance.on_change = props.on_change
    
    return instance
end

function Slider:update_value_from_mouse(mx)
    local ax, _ = self:get_absolute_position()
    local percentage = (mx - ax) / self.w
    percentage = math.max(0, math.min(1, percentage))
    
    local old_value = self.value
    self.value = self.min + percentage * (self.max - self.min)
    
    if self.value ~= old_value and self.on_change then
        self.on_change(self.value)
    end
end

function Slider:handle_event(event, sdl_constants)
    if event.type == sdl_constants.MOUSEBUTTONUP then
        self.is_dragging = false
    end

    if event.type == sdl_constants.MOUSEBUTTONDOWN then
        if self:is_point_inside(event.button.x, event.button.y) then
            self.is_dragging = true
            self:update_value_from_mouse(event.button.x)
            return true
        end
    elseif event.type == sdl_constants.MOUSEMOTION and self.is_dragging then
        self:update_value_from_mouse(event.motion.x)
        return true
    end
    
    return Element.handle_event(self, event, sdl_constants)
end

function Slider:_draw_self(renderer, abs_x, abs_y)
    SDL.SDL_SetRenderDrawColor(renderer, self.track_color[1], self.track_color[2], self.track_color[3], self.track_color[4])
    local track_h = 6
    local track_y = abs_y + (self.h / 2) - (track_h / 2)
    local track_rect = ffi.new("SDL_Rect", { x = abs_x, y = track_y, w = self.w, h = track_h })
    SDL.SDL_RenderFillRect(renderer, track_rect)

    SDL.SDL_SetRenderDrawColor(renderer, self.handle_color[1], self.handle_color[2], self.handle_color[3], self.handle_color[4])
    local percentage = (self.value - self.min) / (self.max - self.min)
    local handle_x = abs_x + (percentage * (self.w - self.handle_width))
    local handle_y = abs_y + (self.h / 2) - (self.h / 2)
    local handle_rect = ffi.new("SDL_Rect", { x = handle_x, y = handle_y, w = self.handle_width, h = self.h })
    SDL.SDL_RenderFillRect(renderer, handle_rect)
end

return Slider