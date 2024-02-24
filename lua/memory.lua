MEMORY = {
  LINK_POINTER   = 0x8040BF6C,
  X_POS_OFFSET   = 0x4D0,
  Y_POS_OFFSET   = 0x4D4,
  Z_POS_OFFSET   = 0x4D8,
  SPEED_F_OFFSET = 0x03398,
  ANGLE_OFFSET_3 = 0x4CA,
  ANGLE_OFFSET_2 = 0x4DE,
  ANGLE_OFFSET_1 = 0x4E6
}

function GetX()
  local pointer = GetPointerNormal(MEMORY.LINK_POINTER)
  local address = pointer + MEMORY.X_POS_OFFSET;
  return ReadValueFloat(address)
end

function GetY()
  local pointer = GetPointerNormal(MEMORY.LINK_POINTER)
  local address = pointer + MEMORY.Y_POS_OFFSET;
  return ReadValueFloat(address)
end

function GetZ()
  local pointer = GetPointerNormal(MEMORY.LINK_POINTER)
  local address = pointer + MEMORY.Z_POS_OFFSET;
  return ReadValueFloat(address)
end

function WriteX(value)
  local pointer = GetPointerNormal(MEMORY.LINK_POINTER)
  local address = pointer + MEMORY.X_POS_OFFSET;
  WriteValueFloat(address, value)
end

function WriteZ(value)
  local pointer = GetPointerNormal(MEMORY.LINK_POINTER)
  local address = pointer + MEMORY.Z_POS_OFFSET;
  WriteValueFloat(address, value)
end

function ReadActualSpeed()
  local pointer = GetPointerNormal(MEMORY.LINK_POINTER)
  local address = pointer + MEMORY.SPEED_F_OFFSET;
  return ReadValueFloat(address)
end

function WriteActualSpeed(value)
  local pointer = GetPointerNormal(MEMORY.LINK_POINTER)
  local address = pointer + MEMORY.SPEED_F_OFFSET;
  return WriteValueFloat(address, value)
end

function ReadAngle()
  local pointer = GetPointerNormal(MEMORY.LINK_POINTER)
  local address = pointer + MEMORY.ANGLE_OFFSET;
  return ReadValue16(address)
end

function WriteAngle(value)
  local pointer = GetPointerNormal(MEMORY.LINK_POINTER)
  WriteValue16(pointer + MEMORY.ANGLE_OFFSET_1, value);
  --WriteValue16(pointer + MEMORY.ANGLE_OFFSET_2, value);
  --WriteValue16(pointer + MEMORY.ANGLE_OFFSET_3, value);
  --WriteValue16(pointer + MEMORY.ANGLE_OFFSET_2, value);
end
