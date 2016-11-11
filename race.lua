game.race = {}

local function update()
  game.track.update()
  game.cars.update()
end

local function draw()
  game.camera.transform()
  game.track.draw()
  game.cars.draw()
end

function game.race.run()
  love.update = update
  love.draw = draw
  game.track.load()
  game.track.addPhysics()
  game.cars.withCars(function()
    game.camera.followCar()
    game.waypoints.finishedLap:wait()
  end)
end
