game.race = {}

local car = nil

local function init()
  game.track.init()
  car = game.car.new()
end

local function update()
  game.track.update()
  game.car.update(car)
end

local function draw()
  love.graphics.push()
  game.camera.lookAtBody(car.body)
  game.track.draw()
  game.car.draw(car)
  love.graphics.pop()
end

function game.race.run()
  init()
  love.update = update
  love.draw = draw
  game.event.new():wait() -- block forever
end
