local ffi = require("ffi")
local Element = require("sunui.core.element")
local sdl = require("sunui.core.sdl")
local SDL = sdl.lib

local Checkbox = setmetatable({}, {__index = Element})
Checkbox.__index = Checkbox

function Checkbox:new(props)
    local instance = Element.new(self, props)
    instance.w = props.size or 20
    instance.h = props.size or 20
    instance.checked = props.checked or false
    instance.bg_color = props.bg_color or {46, 51, 61, 255}
    instance.check_color = props.check_color or {46, 204, 113, 255}
    instance.on_toggle = props.on_toggle
    return instance
end

function Checkbox:on_click()
    self.checked = not self.checked
    if self.on_toggle then self.on_toggle(self.checked) end
end

function Checkbox:_draw_self(renderer, abs_x, abs_y)
    SDL.SDL_SetRenderDrawColor(renderer, self.bg_color[1], self.bg_color[2], self.bg_color[3], self.bg_color[4])
    local rect = ffi.new("SDL_Rect", { x = abs_x, y = abs_y, w = self.w, h = self.h })
    SDL.SDL_RenderFillRect(renderer, rect)

    if self.checked then
        SDL.SDL_SetRenderDrawColor(renderer, self.check_color[1], self.check_color[2], self.check_color[3], self.check_color[4])
        local pad = 4
        local check_rect = ffi.new("SDL_Rect", { x = abs_x + pad, y = abs_y + pad, w = self.w - (pad * 2), h = self.h - (pad * 2) })
        SDL.SDL_RenderFillRect(renderer, check_rect)
    end
end

return Checkbox
