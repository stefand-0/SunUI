local ffi = require("ffi")
local Element = require("sunui.core.element")
local sdl = require("sunui.core.sdl")
local SDL = sdl.lib

local ProgressBar = setmetatable({}, {__index = Element})
ProgressBar.__index = ProgressBar

function ProgressBar:new(props)
    local instance = Element.new(self, props)
    instance.value = props.value or 0
    instance.max = props.max or 100
    instance.bg_color = props.bg_color or {40, 44, 52, 255}
    instance.fill_color = props.fill_color or {0, 122, 255, 255}
    return instance
end

function ProgressBar:set_value(val)
    self.value = math.max(0, math.min(self.max, val))
end

function ProgressBar:_draw_self(renderer, abs_x, abs_y)
    SDL.SDL_SetRenderDrawColor(renderer, self.bg_color[1], self.bg_color[2], self.bg_color[3], self.bg_color[4])
    local bg_rect = ffi.new("SDL_Rect", { x = abs_x, y = abs_y, w = self.w, h = self.h })
    SDL.SDL_RenderFillRect(renderer, bg_rect)

    local pct = self.value / self.max
    if pct > 0 then
        SDL.SDL_SetRenderDrawColor(renderer, self.fill_color[1], self.fill_color[2], self.fill_color[3], self.fill_color[4])
        local fill_w = math.floor(self.w * pct)
        local fill_rect = ffi.new("SDL_Rect", { x = abs_x, y = abs_y, w = fill_w, h = self.h })
        SDL.SDL_RenderFillRect(renderer, fill_rect)
    end
end

return ProgressBar
