game.ui = {}

game.ui.x = 0
game.ui.y = 0
game.ui.width = love.graphics.getWidth()
game.ui.height = love.graphics.getHeight()

function love.resize(w, h)
  game.ui.width = w
  game.ui.height = h
end

function game.ui.run(ui, callbacks)
  local id = ui.id
  local f = callbacks[id]
  if f ~= nil then
    f()
  end
  ui.runChildren(callbacks)
end

local function runChild(ui, callbacks, x, y, w, h)
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
  game.ui.run(ui, callbacks)
  love.graphics.pop()
  game.ui.x = originalX
  game.ui.y = originalY
  game.ui.width = originalWidth
  game.ui.height = originalHeight
end

function game.ui.contains(ui, id, x, y)
  local result = false
  game.ui.run(ui, {[id] = function()
    if x >= game.ui.x and x < game.ui.x + game.ui.width and y >= game.ui.y and y < game.ui.y + game.ui.height then
      result = true
    end
  end})
  return result
end

function game.ui.pane(id)
  return {id=id, runChildren=function(callbacks) end}
end

function game.ui.splitHorizontal(id, weight, left, right)
  return {id=id, runChildren=function(callbacks)
    local w = game.ui.width
    local h = game.ui.height
    runChild(left, callbacks, 0, 0, w * weight, h)
    runChild(right, callbacks, w * weight, 0, w * (1 - weight), h)
  end}
end

function game.ui.splitVertical(id, weight, top, bottom)
  return {id=id, runChildren=function(callbacks)
    local w = game.ui.width
    local h = game.ui.height
    runChild(top, callbacks, 0, 0, w, h * weight)
    runChild(bottom, callbacks, 0, h * weight, w, h * (1 - weight))
  end}
end

function game.ui.split(id, weight, a, b)
  return {id=id, runChildren=function(callbacks)
    local w = game.ui.width
    local h = game.ui.height
    if w > h then
      runChild(a, callbacks, 0, 0, w * weight, h)
      runChild(b, callbacks, w * weight, 0, w * (1 - weight), h)
    else
      runChild(a, callbacks, 0, 0, w, h * weight)
      runChild(b, callbacks, 0, h * weight, w, h * (1 - weight))
    end
  end}
end

function game.ui.margin(id, size, child)
  return {id=id, runChildren=function(callbacks)
    local w = game.ui.width
    local h = game.ui.height
    runChild(child, callbacks, size, size, w - size * 2, h - size * 2)
  end}
end
