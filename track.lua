game.track = {}

game.track.world = nil
game.track.beginCollision = game.event.new()
game.track.endCollision = game.event.new()

local spawnX = 0
local spawnY = 0

function game.track.reset()
  game.track.world = nil
  game.tiles.reset()
  game.waypoint.reset()
  spawnX = 0
  spawnY = 0
end

function game.track.save()
  local f = love.filesystem.newFile("track")
  f:open("w")
  game.tiles.write(f)
  game.waypoint.write(f)
  f:write(string.char(spawnX))
  f:write(string.char(spawnY))
  f:close()
end

function game.track.load()
  game.track.reset()
  if love.filesystem.exists("track") then
    local f = love.filesystem.newFile("track")
    f:open("r")
    game.tiles.read(f)
    game.waypoint.read(f)
    spawnX = f:read(1):byte()
    spawnY = f:read(1):byte()
    f:close()
  end
end

function game.track.getSpawn()
  return spawnX, spawnY
end

function game.track.setSpawn(x, y)
  spawnX = x
  spawnY = y
end

function game.track.addPhysics()
  love.physics.setMeter(1)
  game.track.world = love.physics.newWorld()
  game.track.world:setCallbacks(
    function(a, b)
      a = a:getUserData() or {}
      b = b:getUserData() or {}
      game.track.beginCollision:send(a, b)
    end,
    function(a, b)
      a = a:getUserData()
      b = b:getUserData()
      game.track.endCollision:send(a, b)
    end
  )
  game.tiles.addPhysics(game.track.world)
  game.waypoint.addPhysics(game.track.world)
end

function game.track.update()
  local dt = love.timer.getDelta()
  game.track.world:update(dt)
end

local function drawSpawn()
  love.graphics.push()
  love.graphics.translate(game.tiles.worldPos(spawnX, spawnY))
  love.graphics.translate(-game.tiles.tileSize / 2, -game.tiles.tileSize / 2)
  love.graphics.rectangle("line", 0, 0, game.tiles.tileSize, game.tiles.tileSize)
  love.graphics.scale(0.2, 0.2)
  love.graphics.print("S")
  love.graphics.pop()
end

function game.track.draw()
  game.tiles.draw()
  game.debug.wireBrush()
  --game.debug.drawPhysicsWorld(game.track.world)
  drawSpawn()
  game.waypoint.draw(waypoint)
end
