local Element = require("sunui.core.element")
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
