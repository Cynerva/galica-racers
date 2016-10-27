game.track = {}

game.track.width = nil
game.track.height = nil
game.track.tiles = nil
game.track.world = nil

local dirtImage = love.graphics.newImage("tiles/dirt.png")
local mudImage = love.graphics.newImage("tiles/mud.png")

local function setTile(x, y, value)
  game.track.tiles[y * game.track.width + x] = value
end

local function getTile(x, y)
  if x < 1 or x > game.track.width or y < 1 or y > game.track.height then
    return nil
  end
  return game.track.tiles[y * game.track.width + x]
end

local function generateTestTrack()
  game.track.width = 100
  game.track.height = 100
  game.track.tiles = {}
  for y=1,game.track.height do
    for x=1,game.track.width do
      local tile = dirtImage
      if x > 50 then tile = mudImage end
      setTile(x, y, tile)
    end
  end
end

function game.track.init()
  generateTestTrack()
  love.physics.setMeter(1)
  game.track.world = love.physics.newWorld()
end

function game.track.update()
  local dt = love.timer.getDelta()
  game.track.world:update(dt)
end

local function drawTile(x, y)
  local tile = getTile(x, y)
  if tile == nil then return end
  love.graphics.push()
  love.graphics.translate(4 * (x - 1), 4 * (y - 1))
  love.graphics.scale(4 / 64, 4 / 64)
  love.graphics.draw(tile)
  love.graphics.pop()
end

function game.track.draw()
  local xmin, ymin = game.camera.screenToWorld(0, 0)
  local xmax, ymax = game.camera.screenToWorld(love.graphics.getWidth(), love.graphics.getHeight())
  xmin = math.floor(xmin / 4)
  ymin = math.floor(ymin / 4)
  xmax = math.floor(xmax / 4) + 1
  ymax = math.floor(ymax / 4) + 1
  for y=ymin,ymax do
    for x=xmin,xmax do
      drawTile(x, y)
    end
  end
end
