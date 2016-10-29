game.race = {}

local car = nil

local function init()
  game.track.init()
  car = game.car.new()
  game.camera.followCar(car)
end

local function update()
  game.track.update()
  game.car.update(car)
end

local function draw()
  game.camera.transform()
  game.track.draw()
  game.car.draw(car)
end

function game.race.run()
  init()
  love.update = update
  love.draw = draw
  game.waypoint.finishedLap:wait()
end
