require "Scripts/lua/globals"
require "Scripts/lua/object"
------------------Save State Class Start-------------
SaveStateObject = Object()
function SaveStateObject:Create(o)
    self.PreviousCoordinates = o.PreviousCoordinates
    self.CurrentCoordinates = o.CurrentCoordinates
    self.PreviousFrame = o.PreviousFrame
    self.CurrentFrame = o.CurrentFrame
    self.Number = o.Number
    self.Loading = false
    self.Saving = false
end
function SaveStateObject:Save()
    if(self.Saving == false) then
        self.CurrentFrame = Globals.CurrentFrame
    end
    if(Globals.CurrentFrame == self.CurrentFrame and self.Saving == false) then
        SaveState(true, self.Number)
        self.Saving = true
        self.PreviousCoordinates = Globals.PreviousCoordinates
        self.CurrentCoordinates = Globals.CurrentCoordinates
        self.PreviousFrame = Globals.PreviousFrame
        self.CurrentFrame = Globals.CurrentFrame
        return false
    else
        if(self.Saving == true) then
            if(Globals.CurrentFrame ~= self.CurrentFrame) then
                self.Saving = false
            end
        end
        return self.Saving == false
    end
end
function SaveStateObject:Load()
    if(self.Loading == false) then
        LoadState(true, self.Number)
        self.Loading = true
        return false
    else
        if(self.CurrentFrame + 2 == Globals.CurrentFrame) then
            Globals.PreviousCoordinates = self.PreviousCoordinates
            Globals.CurrentCoordinates = self.CurrentCoordinates
            Globals.PreviousFrame = self.PreviousFrame
            Globals.CurrentCoordinates = self.CurrentCoordinates
            self.Loading = false
            return true
        else
            return false
        end
    end
end