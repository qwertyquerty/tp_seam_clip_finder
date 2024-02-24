require "Scripts/lua/class"
require "Scripts/lua/globals"
require "Scripts/lua/list"
require "Scripts/lua/object"


Action = Object()
ActionFactory = Object()
ActionList = List()
ActionQueue = List()

--[[
--------------ACTION-----------------------
Contains the logic executed at runtime
Contains the logic the determines if the action has been completed

]]
function Action:init(o)
  self.StartFrame = nil
  self.Name = o.Name
  self.runFunc = o.Run
  self.isFinishedFunc = o.IsFinished
  self.StartFrame = nil
end
function Action:Run()
    if(self.StartFrame == nil) then
        self.StartFrame = Globals.CurrentFrame
    end
    return self.runFunc(self)
end
function Action:IsFinished()
  return self.isFinishedFunc(self)
end
function Action:Copy()
  WriteLineToText("ACTION COPYING!")
  return self:new({
    Name = self.Name,
    Run = self.runFunc,
    IsFinished = self.isFinishedFunc
  })
end
--------------END ACTION-------------------

--[[
-----------------ACTION LIST--------------------------
A series of actions that will be performed one after the other.
  - Only the first element of the list will be ran
  - Once the first element is finished, it is removed from the list

Allows for 2-dimensional processes in the action queue
]]

--param 'actions' -> Must be a list of actions or action factory objects ie. { action1, action2 }
function ActionList:init(actions)
  self.elements = actions
end
function ActionList:Run()   -- only runs first action in list, removes if action is finished
  if(self.elements[1] ~= nil) then
    self.elements[1]:Run()
    if(self.elements[1]:IsFinished()) then
      self:Remove(self.elements[1])
    end
  end
end
function ActionList:IsFinished()
  return self:Count() == 0
end
function ActionList:Copy()
  local elementsCopy = {}
  for index, action in ipairs(self.elements) do
    elementsCopy[#elementsCopy + 1] = action:Copy()
  end
  return self:new(elementsCopy, self.loop)
end
--------------------END ACTIONLIST----------------------------

--[[
------------------ACTION QUEUE------------------
  The queue in which actions are ran from in the loop
  Objects must have the following functions to run properly in the queue:
    - Run()
    - IsFinished() ***must return true or false

  Each cycle, the queue will run each object in the queue
  Once an object has been flagged as finished, it will be removed from the queue
]]

function ActionQueue:init()
end
function ActionQueue:InQueue(id)
  for index, actionList in ipairs(self.elements) do
    if(actionList.id == id) then
      return true
    end
  end
  return false
end
function ActionQueue:Run()
  local itemsToKeep = {}
  local elementsCopy = {}
  for index, action in ipairs(self.elements) do
    action:Run()
    if(action:IsFinished() == false) then
      itemsToKeep[#itemsToKeep + 1] = action
    end
  end
  self.elements = itemsToKeep
end
------------------END ACTION QUEUE---------------

-----------------START ACTION FACTORY-------------
--Generates and executes actions at run-time 
--useful for actions that include global values that should not be referenced until execution

function ActionFactory:init()
  self.action = nil
end

ActionFactory:set {
  _ActionGenerator = nil,
  get = function(self, value)
    if(self._ActionGenerator == nil) then
      self._ActionGenerator = {}
    end
    return self._ActionGenerator
  end,
  set = function(self, newVal, oldVal)
    self._ActionGenerator = newVal
    return self._ActionGenerator
  end
}

function ActionFactory:Generate()
  return self.ActionGenerator()
end
function ActionFactory:Copy()
  WriteLineToText("ACTION FACTORY COPYING!")
  if(self.action == nil) then
    self.action = self:Generate()
  end
  return self.action:Copy()
end
function ActionFactory:Run()
  if(self.action == nil) then
    self.action = self:Generate()
  end
  return self.action:Run()
end
function ActionFactory:IsFinished()
  if(self.action == nil) then
    self.action = self:Generate()
  end
  return self.action:IsFinished()
end
-----------------END ACTION FACTORY-------------