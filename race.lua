game.race = {}

local car = nil

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
  love.update = update
  love.draw = draw
  game.track.load()
  game.track.addPhysics()
  car = game.car.new()
  game.camera.followCar(car)
  game.waypoint.finishedLap:wait()
end
