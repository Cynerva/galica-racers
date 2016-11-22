game.files = {}

function game.files.writeNum(f, value)
  local s = tostring(value)
  f:write(string.char(#s))
  f:write(s)
end

function game.files.readNum(f)
  local length = f:read(1):byte()
  local s = f:read(length)
  return tonumber(s)
end
