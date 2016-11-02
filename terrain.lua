game.terrain = {}

local tileSize = 2

local function worldToTile(x, y)
  return x / tileSize, y / tileSize
end

local function tileToWorld(x, y)
  return x * tileSize, y * tileSize
end

function game.terrain.read(f)
end

function game.terrain.write(f)
end

function game.terrain.draw()
  local minX, minY = worldToTile(game.camera.screenToWorld(0, 0))
  local maxX, maxY = worldToTile(game.camera.screenToWorld(love.graphics.getDimensions()))
  minX = math.floor(minX)
  minY = math.floor(minY)
  maxX = math.floor(maxX)
  maxY = math.floor(maxY)
  game.debug.wireBrush()
  for y=minY,maxY do
    for x=minX,maxX do
      love.graphics.push()
      love.graphics.translate(tileToWorld(x, y))
      love.graphics.setColor(64, 128, 64)
      love.graphics.rectangle("fill", 0, 0, tileSize, tileSize)
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", 0, 0, tileSize, tileSize)
      love.graphics.pop()
    end
  end
end
