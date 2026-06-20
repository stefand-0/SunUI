local ffi = require("ffi")
local Element = require("sunui.core.element")
local sdl = require("sunui.core.sdl")
local SDL = sdl.lib

local Divider = setmetatable({}, {__index = Element})
Divider.__index = Divider

function Divider:new(props)
    local instance = Element.new(self, props)
    instance.vertical = props.vertical or false
    instance.w = instance.vertical and (props.thickness or 2) or (props.w or 100)
    instance.h = not instance.vertical and (props.thickness or 2) or (props.h or 100)
    instance.color = props.color or {70, 75, 85, 255}
    return instance
end

function Divider:_draw_self(renderer, abs_x, abs_y)
    SDL.SDL_SetRenderDrawColor(renderer, self.color[1], self.color[2], self.color[3], self.color[4])
    local rect = ffi.new("SDL_Rect", { x = abs_x, y = abs_y, w = self.w, h = self.h })
    SDL.SDL_RenderFillRect(renderer, rect)
end

return Divider
