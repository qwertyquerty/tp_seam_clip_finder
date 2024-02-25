require "Scripts/lua/action"
require "Scripts/lua/globals"
require "Scripts/lua/object"
require "Scripts/lua/savestate"
require "Scripts/lua/memory"
require "Scripts/lua/helpers"
require "Scripts/lua/coordinates"

LOCAL = {
  SEAM_LOCATION = Coordinates:new(6985.00146, -3650.08081),
  START_COORDINATE_RANGE_MIN = Coordinates:new(6959.3237, -3629.9773),
  START_COORDINATE_RANGE_MAX = Coordinates:new(6949.3711, -3628.1484),
  SPEED_MIN = 60.0,
  SPEED_MAX = 61.0
}

function RandomCoordinates(minCoord, maxCoord)
  local newX = RandomFloat(minCoord.X, maxCoord.X)
  local newY = RandomFloat(minCoord.Y, maxCoord.Y)
  return Coordinates:new(newX,newY)
end
function GetCurrentCoordinates()
  return Coordinates:new(GetX(),GetZ())
end
local RunActionOnce = ActionFactory()
function RunActionOnce:init(func)
  self.ActionGenerator = function()
    return Action:new({
      Name = "RunActionOnce",
      Run = function()
        func()
      end,
      IsFinished = function()
        return true
      end
    })
  end
end
local Wait = ActionFactory()
function Wait:init(val)
  self.ActionGenerator = function()
    return Action:new({
      Name = "Wait",
      Run = function()
        --do nothing
      end,
      IsFinished = function(this)
        return Globals.CurrentFrame == this.StartFrame + val
      end
    })
  end
end
local RecordSolution = ActionFactory()
function RecordSolution:init(minCoord, maxCoord)
  self.ActionGenerator = function()
    return Action:new({
      Name = "RecordSolution",
      Run = function()  
        WriteLineToText("SOLUTION FOUND: \n\tStart Position: " .. LOCAL.START_POS:ToString() .. "\n\tEnd Position: " .. GetCurrentCoordinates():ToString() .. "\n\tDistance: ".. LOCAL.START_POS:DistanceBetween(GetCurrentCoordinates()))
      end,
      IsFinished = function()
        return true
      end
    })
  end
end

local RecordIfClip = ActionFactory()
function RecordIfClip:init()
  self.ActionGenerator = function()
    return Action:new({
      Name = "RecordIfClip",
      Run = function()  
        if(LOCAL.START_POS:DistanceBetween(Globals.CurrentCoordinates) >= LOCAL.SPEED_MIN) then
          Globals.Queue:Add(RecordSolution:new())
        end
      end,
      IsFinished = function()
        return true
      end
    })
  end
end

local SetEndPosition = ActionFactory()
function SetEndPosition:init()
  self.ActionGenerator = function()
    return Action:new({
      Name = "SetEndPosition",
      Run = function()
        local speed = RandomFloat(LOCAL.SPEED_MIN, LOCAL.SPEED_MAX)
        WriteActualSpeed(speed)
      end,
      IsFinished = function()
        return true
      end
    })
  end
end

local SetRandomPosition = ActionFactory()
function SetRandomPosition:init(minCoord, maxCoord)
  self.ActionGenerator = function()
    local randomStart = RandomCoordinates(minCoord,maxCoord)
    return Action:new({
      Name = "SetRandomPosition",
      Run = function()   
        if((FloatsAreEqual(GetX(), randomStart.X) and FloatsAreEqual(GetZ(), randomStart.Y)) == false) then
          WriteActualSpeed(0)
          WriteX(randomStart.X)
          WriteZ(randomStart.Y)

          local angle_rads = GetCurrentCoordinates():AngleBetweenCoords(LOCAL.SEAM_LOCATION)
          WriteAngle(math.floor(DegreesToHalfword(angle_rads)))

        end   
 
      end,
      IsFinished = function(this)
        if(Globals.CurrentFrame == this.StartFrame + 1) then
          return true
        else
          return false
        end
      end
    })
  end
end


local SearchForSeam = ActionFactory()
function SearchForSeam:init()
  self.ActionGenerator = function()
    return Action:new({
      Name = "SearchForSeam",
      Run = function()  
        Globals.Queue:Add(ActionList:new({
          RunActionOnce:new(function() LOCAL.SEARCHING = true end),
          SetRandomPosition:new(LOCAL.START_COORDINATE_RANGE_MIN, LOCAL.START_COORDINATE_RANGE_MAX),
          RunActionOnce:new(function() LOCAL.START_POS = GetCurrentCoordinates() end),
          Wait:new(20),
          SetEndPosition:new(),
          Wait:new(10),
          RecordIfClip:new(),    
          RunActionOnce:new(function() LOCAL.SEARCHING = false end)
        }))
      end,
      IsFinished = function()
        return true
      end
    })
  end
end





function onScriptStart()
  Globals.TEXT_FILE_PATH = Globals.TEXT_FILE_PATH .. "SEAM_FINDER" .. os.time() .. ".txt"
  Globals.CurrentFrame = GetFrameCount()
  Globals.PreviousFrame = Globals.CurrentFrame
  Globals.CurrentCoordinates = Coordinates:new(GetX(),GetZ())
  Globals.PreviousCoordinates = Coordinates:new(Globals.CurrentCoordinates.X, Globals.CurrentCoordinates.Y)

  Globals.Queue = ActionQueue:new()
  Globals.Queue:Add(SearchForSeam:new())
  
end

function onScriptCancel()
end

function onStateLoaded()
end

function onStateSaved()
end

function CheckNewFrame()
check_frame = GetFrameCount() 
if check_frame ~= Globals.CurrentFrame  then
    Globals.PreviousFrame = Globals.CurrentFrame
    Globals.CurrentFrame = check_frame
    Globals.PreviousCoordinates.X = Globals.CurrentCoordinates.X
    Globals.PreviousCoordinates.Y = Globals.CurrentCoordinates.Y
    Globals.CurrentCoordinates.X = GetX()
    Globals.CurrentCoordinates.Y = GetZ()
    return true
else
  return false
end
end

function onScriptUpdate()
  CheckNewFrame()
  Globals.Queue:Run()
  if(LOCAL.SEARCHING == false) then
    Globals.Queue:Add(SearchForSeam:new())
  end

end