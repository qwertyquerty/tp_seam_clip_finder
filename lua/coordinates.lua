require "Scripts/lua/object"
require "Scripts/lua/helpers"
--------------Coordinates-------------
Coordinates = Object()
function Coordinates:init(X,Y)
    self.X = X
    self.Y = Y
end
function Coordinates:Magnitude()
return math.sqrt(self.X^2 + self.Y^2)
end
function Coordinates:CrossProduct(coord2)
    return (self.X * self.Y) + (coord2.X * coord2.Y)
end
function Coordinates:AngleBetweenCoords(coord2)
    --return RadiansToDegrees(math.acos(self:CrossProduct(coord2) / (self:Magnitude() * coord2:Magnitude())))
    return math.deg(math.atan(coord2.Y - self.Y, coord2.X - self.X)) % 360
end
function Coordinates:DistanceBetween(coord2)
    local dx = coord2.X - self.X
    local dy = coord2.Y - self.Y
    return math.sqrt(dx^2 + dy^2)
end
function Coordinates:Compare(coord2)
    if(FloatsAreEqual(self.X, coord2.X) and FloatsAreEqual(self.Y, coord2.Y)) then
        return true
    else
        return false
    end
end
function Coordinates:Copy()
    return self:new(self.X, self.Y)
end
function Coordinates:ToString()
    return self.X .. ", " .. self.Y
end
function Coordinates:CalculateEndPosition(distance, angle)
    local radAngle = angle * math.pi / 180
    local newX = self.X + (distance * math.cos(radAngle))
    local newY = self.Y + (distance * math.sin(radAngle))
    --WriteLineToText(self:ToString() .. " distance: " .. distance .. " angle: " .. angle .. " final: " .. newX .. " " .. newY)
    return self:new(newX, newY)
end