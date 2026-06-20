local Element = {}
Element.__index = Element

function Element:new(props)
    local instance = setmetatable({}, self)
    instance.x = props.x or 0
    instance.y = props.y or 0
    instance.w = props.w or 0
    instance.h = props.h or 0
    instance.children = {}
    return instance
end

function Element:add(child)
    table.insert(self.children, child)
end

function Element:is_mouse_over(mx, my, abs_x, abs_y)
    return mx >= abs_x and mx <= abs_x + self.w and my >= abs_y and my <= abs_y + self.h
end

function Element:handle_event(event, constants, abs_x, abs_y)
    abs_x = (abs_x or 0) + self.x
    abs_y = (abs_y or 0) + self.y

    -- Route events down to children layout nodes first
    for _, child in ipairs(self.children) do
        child:handle_event(event, constants, abs_x, abs_y)
    end

    -- Process self-interaction layers
    local mx, my = 0, 0
    local is_click = event.type == constants.MOUSEBUTTONDOWN or event.type == constants.MOUSEBUTTONUP
    local is_motion = event.type == constants.MOUSEMOTION

    if is_click then
        mx, my = event.button.x, event.button.y
    elseif is_motion then
        mx, my = event.motion.x, event.motion.y
    end

    if is_click or is_motion then
        local over = self:is_mouse_over(mx, my, abs_x, abs_y)
        
        -- State updating hooks for buttons/sliders
        if self.state then
            if over then
                if event.type == constants.MOUSEBUTTONDOWN then self.state = "active"
                elseif event.type == constants.MOUSEBUTTONUP then self.state = "hover"
                else self.state = "hover" end
            else
                self.state = "normal"
            end
        end

        -- Checkbox click trigger toggle action
        if over and event.type == constants.MOUSEBUTTONDOWN and self.checked ~= nil then
            self.checked = not self.checked
            if self.on_toggle then self.on_toggle(self.checked) end
        end

        -- Slider dragging adjustment interaction
        if (over or self.dragging) and self.min and self.max then
            if event.type == constants.MOUSEBUTTONDOWN then
                self.dragging = true
            end
            if event.type == constants.MOUSEBUTTONUP then
                self.dragging = false
            end
            if self.dragging and is_motion then
                local pct = (mx - abs_x) / self.w
                pct = math.max(0, math.min(1, pct))
                self.value = self.min + (pct * (self.max - self.min))
                if self.on_change then self.on_change(self.value) end
            end
        end

        -- General click action execution
        if over and event.type == constants.MOUSEBUTTONDOWN and self.on_click then
            self.on_click()
        end
    end
end

function Element:draw(renderer, parent_x, parent_y)
    local abs_x = parent_x + self.x
    local abs_y = parent_y + self.y
    
    self:_draw_self(renderer, abs_x, abs_y)
    
    for _, child in ipairs(self.children) do
        child:draw(renderer, abs_x, abs_y)
    end
end

function Element:_draw_self(renderer, abs_x, abs_y)
    -- Virtual baseline
end

return Element
