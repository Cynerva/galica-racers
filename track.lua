game.track = {}

game.track.world = nil

function game.track.init()
  love.physics.setMeter(1)
  game.track.world = love.physics.newWorld()
end

function game.track.update()
  local dt = love.timer.getDelta()
  game.track.world:update(dt)
end

function game.track.draw()
  game.debug.drawUnitGrid()
end
