game.camera = {}

local followedBody = nil
local posX = 0
local posY = 0
local zoom = 20

function game.camera.followCar()
  followedBody = game.cars.getBody()
end

function game.camera.setPosition(x, y)
  followedBody = nil
  posX = x
  posY = y
end

local function cameraPos()
  if followedBody then
    local x, y = followedBody:getPosition()
    local dx, dy = followedBody:getLinearVelocity()
    x = x + dx / 4
    y = y + dy / 4
    return x, y
  end
  return posX, posY
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
