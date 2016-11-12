game.track = {}

game.track.world = nil
game.track.beginCollision = game.event.new()
game.track.endCollision = game.event.new()
game.track.postSolveCollision = game.event.new()

local spawnX = nil
local spawnY = nil

function game.track.reset()
  game.track.world = nil
  spawnX = 0
  spawnY = 0
  game.terrain.reset()
  game.waypoints.reset()
  game.props.reset()
end

function game.track.load()
  game.track.reset()
  if love.filesystem.exists("track") then
    local f = love.filesystem.newFile("track")
    f:open("r")
    spawnX = f:read(1):byte()
    spawnY = f:read(1):byte()
    game.terrain.read(f)
    game.waypoints.read(f)
    game.props.read(f)
    f:close()
  end
end

function game.track.save()
  local f = love.filesystem.newFile("track")
  f:open("w")
  f:write(string.char(spawnX))
  f:write(string.char(spawnY))
  game.terrain.write(f)
  game.waypoints.write(f)
  game.props.write(f)
  f:close()
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
    end,
    function() end,
    function(a, b, contact, ...)
      a = a:getUserData()
      b = b:getUserData()
      game.track.postSolveCollision:send(a, b, ...)
    end
  )
  game.waypoints.addPhysics(game.track.world)
  game.props.addPhysics(game.track.world)
end

function game.track.update()
  local dt = love.timer.getDelta()
  game.track.world:update(dt)
end

function game.track.draw()
  game.terrain.draw()
  game.props.draw()
  --game.debug.drawPhysicsWorld(game.track.world)
end

function game.track.drawSpawn()
  game.debug.wireBrush()
  love.graphics.circle("line", spawnX, spawnY, 2)
end
