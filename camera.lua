game.camera = {}

local followedBody = nil
local posX = 0
local posY = 0
local zoom = 20

local function pos()
  if followedBody then
    local x, y = followedBody:getPosition()
    local dx, dy = followedBody:getLinearVelocity()
    x = x + dx / 4
    y = y + dy / 4
    return x, y
  end
  return posX, posY
end

function game.camera.followCar()
  followedBody = game.cars.getBody()
end

function game.camera.setPosition(x, y)
  followedBody = nil
  posX = x
  posY = y
end

function game.camera.getPosition()
  return pos()
end

function game.camera.transform()
  local x, y = pos()
  love.graphics.translate(game.ui.width / 2, game.ui.height / 2)
  love.graphics.scale(zoom, zoom)
  love.graphics.translate(-x, -y)
end

function game.camera.screenToWorld(x, y)
  local camX, camY = pos()
  x = camX + (x - game.ui.width / 2) / zoom
  y = camY + (y - game.ui.height / 2) / zoom
  return x, y
end
