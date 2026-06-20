local Element = {}
Element.__index = Element
-- New: Element

function Element:new(properties)
  props = props or {}
  local instance = {
    x = props.x or 0, -- x pos
    y = props.y or 0, -- y pos
    w = props.w or 150, -- 150 default width
    h = props.h or 50, -- 50 default height
    children = {}, -- no base children
    parent = nil -- no base parent
  }
  return setmetatable(instance, self)
end

-- Child for: Element

function Element:add(child)
  child.parent = self
  table.insert(self.children, child) 
end

function Element:is_point_inside(px, py)
  -- absolute coords
  return px >= self.x and px <= self.x + self.w and py >= self.y and py <= self.y + self.h
end

function Element:handle_click(mx, my)
  for i = #self.children, 1, -1 do
        local child = self.children[i]
        if child:is_point_inside(mx, my) then
            return child:handle_click(mx, my) -- The child handles it
        end
  end
  if self.on_click then
        self:on_click() -- If not child took the click, it handles it
        return true
  end
  return false
end

-- To be overwritten by other widgets (specific)

function Element:update(dt) end
function Element:draw() end

return Element
