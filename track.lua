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
  -- TODO: write stuff
  f:close()
end

function game.track.load()
  game.track.reset()
  if love.filesystem.exists("track") then
    local f = love.filesystem.newFile("track")
    f:open("r")
    -- TODO: read stuff
    f:close()
  end
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
end

function game.track.update()
  local dt = love.timer.getDelta()
  game.track.world:update(dt)
end

function game.track.draw()
  game.debug.wireBrush()
  game.debug.drawUnitGrid()
  --game.debug.drawPhysicsWorld(game.track.world)
end
