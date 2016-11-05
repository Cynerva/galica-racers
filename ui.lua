game.ui = {}

game.ui.x = 0
game.ui.y = 0
game.ui.width = love.graphics.getWidth()
game.ui.height = love.graphics.getHeight()

function love.resize(w, h)
  game.ui.width = w
  game.ui.height = h
end

local function inSubregion(x, y, w, h, f)
  local originalX = game.ui.x
  local originalY = game.ui.y
  local originalWidth = game.ui.width
  local originalHeight = game.ui.height
  game.ui.x = game.ui.x + x
  game.ui.y = game.ui.y + y
  game.ui.width = w
  game.ui.height = h
  love.graphics.push()
  love.graphics.translate(x, y)
  f()
  love.graphics.pop()
  game.ui.x = originalX
  game.ui.y = originalY
  game.ui.width = originalWidth
  game.ui.height = originalHeight
end

function game.ui.inBounds(x, y)
  return (
    x >= game.ui.x and x < game.ui.x + game.ui.width and
    y >= game.ui.y and y < game.ui.y + game.ui.height
  )
end

function game.ui.splitHorizontal(weight, left, right)
  local w = game.ui.width
  local h = game.ui.height
  inSubregion(0, 0, w * weight, h, left)
  inSubregion(w * weight, 0, w * (1 - weight), h, right)
end

function game.ui.splitVertical(weight, top, bottom)
  local w = game.ui.width
  local h = game.ui.height
  inSubregion(0, 0, w, h * weight, top)
  inSubregion(0, h * weight, w, h * (1 - weight), bottom)
end

function game.ui.split(weight, a, b)
  local w = game.ui.width
  local h = game.ui.height
  if w > h then
    inSubregion(0, 0, w * weight, h, a)
    inSubregion(w * weight, 0, w * (1 - weight), h, b)
  else
    inSubregion(0, 0, w, h * weight, a)
    inSubregion(0, h * weight, w, h * (1 - weight), b)
  end
end

function game.ui.margin(size, f)
  local w = game.ui.width
  local h = game.ui.height
  inSubregion(size, size, w - size * 2, h - size * 2, f)
end
