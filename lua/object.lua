require "Scripts/lua/class"
math.randomseed(os.time())
local random = math.random
function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

Object = class()
Object:set{
    _id = nil,
    id = {
        get = function(self, value)
          if(self._id == nil) then
            self._id = uuid()
          end
          return self._id
        end
      }
}
