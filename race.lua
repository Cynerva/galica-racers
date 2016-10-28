game.race = {}

local car = nil
local waypoint = nil

local function init()
  game.track.init()
  car = game.car.new()
  waypoint = game.waypoint.new(20, 200, 40, 4)
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
  game.waypoint.hitWaypoint:wait()
end
