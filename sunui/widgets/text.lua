local ffi = require("ffi")
local Element = require("sunui.core.element")
local sdl = require("sunui.core.sdl")
local SDL = sdl.lib

local Text = setmetatable({}, {__index = Element})
Text.__index = Text

local font_cache = {}

function Text:new(props)
    local instance = Element.new(self, props)
    instance.text = props.text or ""
    -- Default path targets standard Android TTF font stack locations inside Termux
    instance.font_path = props.font_path or "/system/fonts/Roboto-Regular.ttf"
    instance.font_size = props.font_size or 16
    instance.color = props.color or {255, 255, 255, 255}
    
    local cache_key = instance.font_path .. ":" .. tostring(instance.font_size)
    if not font_cache[cache_key] then
        font_cache[cache_key] = SDL.TTF_OpenFont(instance.font_path, instance.font_size)
        if font_cache[cache_key] == nil then
            io.stderr:write("Warning: Could not open font file " .. instance.font_path .. "\n")
        end
    end
    instance.font = font_cache[cache_key]
    
    return instance
end

function Text:_draw_self(renderer, abs_x, abs_y)
    if not self.font or self.text == "" then return end

    local color = ffi.new("SDL_Color", { r = self.color[1], g = self.color[2], b = self.color[3], a = self.color[4] })
    local surface = SDL.TTF_RenderText_Blended(self.font, self.text, color)
    if surface == nil then return end
    
    local texture = SDL.SDL_CreateTextureFromSurface(renderer, surface)
    if texture ~= nil then
        local rect = ffi.new("SDL_Rect", { x = abs_x, y = abs_y, w = surface.w, h = surface.h })
        SDL.SDL_RenderCopy(renderer, texture, nil, rect)
        
        self.w = surface.w
        self.h = surface.h
        
        SDL.SDL_DestroyTexture(texture)
    end
    
    SDL.SDL_FreeSurface(surface)
end

return Text
