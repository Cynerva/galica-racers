game.camera = {}

local body = nil
local zoom = 20

function game.camera.followCar(car)
  body = car.body
end

local function cameraPos()
  local x, y = body:getPosition()
  local dx, dy = body:getLinearVelocity()
  x = x + dx / 4
  y = y + dy / 4
  return x, y
end

function game.camera.transform()
  local x, y = cameraPos()
  love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  love.graphics.scale(zoom, zoom)
  love.graphics.translate(-x, -y)
end

function game.camera.screenToWorld(x, y)
  local camX, camY = cameraPos()
  x = camX + (x - love.graphics.getWidth() / 2) / zoom
  y = camY + (y - love.graphics.getHeight() / 2) / zoom
  return x, y
end
