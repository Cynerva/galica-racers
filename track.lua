game.track = {}

local function update(track)
  local dt = love.timer.getDelta()
  track.world:update(dt)
end

local function draw(track)
  game.debug.drawUnitGrid()
end

function game.track.new()
  local track = {}
  track.update = update
  track.draw = draw
  love.physics.setMeter(1)
  track.world = love.physics.newWorld()
  return track
end
