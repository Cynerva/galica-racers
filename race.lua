game.race = {}

local track = nil
local car = nil

local function init()
  track = game.track.new()
  car = game.car.new(track.world)
end

local function update()
  car:update()
  track:update()
end

local function draw()
  love.graphics.push()
  game.camera.lookAtBody(car.body)
  track:draw()
  car:draw()
  love.graphics.pop()
end

function game.race.run()
  init()
  love.update = update
  love.draw = draw
  game.event.new():wait() -- block forever
end
