game.track = {}

game.track.world = nil
game.track.beginCollision = game.event.new()
game.track.endCollision = game.event.new()

local function initWorld()
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
end

function game.track.save()
  local f = love.filesystem.newFile("track")
  f:open("w")
  game.tiles.write(f)
  f:close()
end

function game.track.load()
  local f = love.filesystem.newFile("track")
  f:open("r")
  game.tiles.read(f)
  f:close()
  initWorld()
  game.waypoint.init()
  game.waypoint.add(8, 96, 20, 4)
  game.waypoint.add(8, 196, 20, 4)
  game.waypoint.add(8, 296, 20, 4)
  game.waypoint.add(8, 396, 20, 4)
end

function game.track.update()
  local dt = love.timer.getDelta()
  game.track.world:update(dt)
end

function game.track.draw()
  game.tiles.draw()
  game.debug.wireBrush()
  game.debug.drawPhysicsWorld(game.track.world)
  game.waypoint.draw(waypoint)
end
