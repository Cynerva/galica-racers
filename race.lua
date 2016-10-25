game.race = {}

local world = nil
local car = nil

local function init()
  love.physics.setMeter(1)
  world = love.physics.newWorld()
  car = game.car.new(world)
end

local function update()
  car:update()
  local dt = love.timer.getDelta()
  world:update(dt)
end

local function draw()
  love.graphics.push()
  love.graphics.scale(20, 20)
  car:draw()
  love.graphics.pop()
end

function game.race.run()
  init()
  love.update = update
  love.draw = draw
  game.event.new():wait() -- block forever
end
