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

-- To be overwritten by other widgets (specific)

function Element:update(dt) end
function Element:draw() end

return Element
