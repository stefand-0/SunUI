--
local Element = {}
Element.__index = Element

function Element:new(props)
    props = props or {}
    local instance = {
        x = props.x or 0, y = props.y or 0,
        w = props.w or 100, h = props.h or 50,
        is_hovered = false,
        children = {}, parent = nil
    }
    return setmetatable(instance, self)
end

function Element:add(child)
    child.parent = self
    table.insert(self.children, child)
end

-- absolute layout for collisions
function Element:get_absolute_position()
    local abs_x, abs_y = self.x, self.y
    local current = self.parent
    while current do
        abs_x = abs_x + current.x
        abs_y = abs_y + current.y
        current = current.parent
    end
    return abs_x, abs_y
end

function Element:is_point_inside(px, py)
    local ax, ay = self:get_absolute_position()
    return px >= ax and px <= ax + self.w and py >= ay and py <= ay + self.h
end

-- Route event down to elements matching coordinates
function Element:handle_event(event, sdl_constants)
    -- Pass down to children first (highest drawn layered objects intercept first)
    for i = #self.children, 1, -1 do
        if self.children[i]:handle_event(event, sdl_constants) then
            return true -- Event consumed by a child widget!
        end
    end

    -- Process self if the mouse is interacting with  boundary box
    if event.type == sdl_constants.MOUSEMOTION then
        local inside = self:is_point_inside(event.motion.x, event.motion.y)
        if inside and not self.is_hovered then
            self.is_hovered = true
            if self.on_mouseenter then self:on_mouseenter() end
        elseif not inside and self.is_hovered then
            self.is_hovered = false
            if self.on_mouseleave then self:on_mouseleave() end
        end
    elseif event.type == sdl_constants.MOUSEBUTTONDOWN then
        if self:is_point_inside(event.button.x, event.button.y) then
            if self.on_click then self:on_click() return true end
        end
    end
    return false
end

function Element:draw(renderer, parent_abs_x, parent_abs_y)
    local abs_x = (parent_abs_x or 0) + self.x
    local abs_y = (parent_abs_y or 0) + self.y
    if self._draw_self then self:_draw_self(renderer, abs_x, abs_y) end
    for _, child in ipairs(self.children) do child:draw(renderer, abs_x, abs_y) end
end

return Element
