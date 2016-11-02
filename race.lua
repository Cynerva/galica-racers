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
  game.cars.reset()
  game.camera.followCar()
  game.event.new():wait()
end
