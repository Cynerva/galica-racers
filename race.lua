game.race = {}

local car = nil

local function init()
  game.track.init()
  game.waypoint.init()
  game.waypoint.add(10, 50, 20, 4)
  game.waypoint.add(10, 100, 20, 4)
  game.waypoint.add(10, 150, 20, 4)
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
  game.waypoint.draw(waypoint)
  game.car.draw(car)
end

function game.race.run()
  init()
  love.update = update
  love.draw = draw
  game.waypoint.finishedLap:wait()
end
