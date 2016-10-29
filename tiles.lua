game.tiles = {}

game.tiles.dirt = love.graphics.newImage("tiles/dirt.png")
game.tiles.mud = love.graphics.newImage("tiles/mud.png")
game.tiles.rock = love.graphics.newImage("tiles/rock.png")

local width = nil
local height = nil
local tileMap = nil

function game.tiles.getTile(x, y)
  if x < 1 or x > width or y < 1 or y > height then
    return game.tiles.rock
  end
  return tileMap[y * width + x]
end

function game.tiles.setTile(x, y, tile)
  tileMap[y * width + x] = tile
end

function game.tiles.loadTestMap()
  width = 100
  height = 100
  tileMap = {}
  for y=1,height do
    for x=1,width do
      if x > 5 then
        game.tiles.setTile(x, y, game.tiles.mud)
      else
        game.tiles.setTile(x, y, game.tiles.dirt)
      end
    end
  end
  game.tiles.setTile(20, 20, game.tiles.rock)
end

function game.tiles.addPhysics(world)
  for y=0,height+1 do
    for x=0,width+1 do
      if game.tiles.getTile(x, y) == game.tiles.rock then
        local body = love.physics.newBody(world, (x - 0.5) * 4, (y - 0.5) * 4)
        local shape = love.physics.newRectangleShape(4, 4)
        local fixture = love.physics.newFixture(body, shape, 1)
      end
    end
  end
end

local function drawTile(x, y)
  local tile = game.tiles.getTile(x, y)
  love.graphics.push()
  love.graphics.translate(4 * (x - 1), 4 * (y - 1))
  love.graphics.scale(4 / 64, 4 / 64)
  love.graphics.draw(tile)
  love.graphics.pop()
end

function game.tiles.draw()
  local xmin, ymin = game.camera.screenToWorld(0, 0)
  local xmax, ymax = game.camera.screenToWorld(love.graphics.getWidth(), love.graphics.getHeight())
  xmin = math.floor(xmin / 4)
  ymin = math.floor(ymin / 4)
  xmax = math.floor(xmax / 4) + 1
  ymax = math.floor(ymax / 4) + 1
  love.graphics.setColor(255, 255, 255)
  for y=ymin,ymax do
    for x=xmin,xmax do
      drawTile(x, y)
    end
  end
end
