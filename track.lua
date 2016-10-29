game.track = {}

game.track.world = nil
game.track.beginCollision = game.event.new()
game.track.endCollision = game.event.new()

function game.track.init()
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
  game.tiles.loadTestMap()
  game.tiles.addPhysics(game.track.world)
  game.waypoint.init()
  game.waypoint.add(10, 98, 20, 4)
  game.waypoint.add(10, 198, 20, 4)
  game.waypoint.add(10, 298, 20, 4)
  game.waypoint.add(10, 398, 20, 4)
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
