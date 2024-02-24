require "Scripts/lua/class"
require "Scripts/lua/object"

List = Object()
function List:init(elements)
    self.elements = elements
end
List:set{
  _elements = nil,
  elements = {
    get = function(self, value)
      if(self._elements == nil) then
        self._elements = {}
      end
      return self._elements
    end,
    set = function(self, newVal, oldVal)
        self._elements = newVal
        return self._elements
    end
  }
}
function List:GetIndex(element)
    if(element ~= nil) then
        for index, value in ipairs(self.elements) do
            if(value.id == element.id) then
            return index
            end
        end
    end
    return -1
end
function List:Add(element)
    local idx = self:GetIndex(element)
    if(idx == -1) then
      self.elements[self:Count() + 1] = element
    end
  end
  function List:Remove(element)
    local idx = self:GetIndex(element)
    if(idx ~= -1) then
      table.remove(self.elements, idx)
    end
  end
  function List:Count()
    return #self.elements
  end
  