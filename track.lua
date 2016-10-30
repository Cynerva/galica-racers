game.track = {}

game.track.world = nil
game.track.beginCollision = game.event.new()
game.track.endCollision = game.event.new()

function game.track.reset()
  game.track.world = nil
end

function game.track.save()
  local f = love.filesystem.newFile("track")
  f:open("w")
  game.tiles.write(f)
  f:close()
end

function game.track.load()
  if love.filesystem.exists("track") then
    local f = love.filesystem.newFile("track")
    f:open("r")
    game.tiles.read(f)
    f:close()
  else
    game.tiles.newEmptyMap()
  end
  game.waypoint.reset()
  game.waypoint.add(1, 5, 5)
  game.waypoint.add(2, 10, 10)
  game.waypoint.add(3, 15, 15)
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

function game.track.draw()
  game.tiles.draw()
  game.debug.wireBrush()
  --game.debug.drawPhysicsWorld(game.track.world)
  game.waypoint.draw(waypoint)
end
