require "Scripts/lua/globals"
function FloatsAreEqual(f1,f2)
	local threshold = 0.001
	diff = math.abs(f1 - f2) -- Absolute value of difference
	return diff < threshold-- True if difference is less than threshold
end
function RadiansToDegrees(rad)
  return rad * (180.0 / math.pi)
end
function HalfwordToDegrees(val)
    return -((val/180) - 90)%360
end
function DegreesToHalfword(val)
    return -(180 * val) + 16384
end
function RandomFloat(lower, greater)
	math.randomseed(os.time())
    return lower + math.random()  * (greater - lower);
end
function WriteLineToText(line)
	local file = io.open(Globals.TEXT_FILE_PATH, "a")
	io.output(file)
	io.write(line,"\n")
end
