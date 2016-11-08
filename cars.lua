game.cars = {}

local car = nil
local images = {
  love.graphics.newImage("car-sprites/car4.png"),
  love.graphics.newImage("car-sprites/car3.png"),
  love.graphics.newImage("car-sprites/car2.png"),
  love.graphics.newImage("car-sprites/car1.png")
}
local speedIntegral = nil -- used for animation

function game.cars.getBody()
  return car.body
end

function game.cars.reset()
  car = {}
  local x, y = game.track.getSpawn()
  car.body = love.physics.newBody(game.track.world, x, y, "dynamic")
  local shape = love.physics.newRectangleShape(3, 2.5)
  local fixture = love.physics.newFixture(car.body, shape, 1)
  car.body:setLinearDamping(0.5)
  speedIntegral = 0
end

function game.cars.update()
  local dt = love.timer.getDelta()
  local angle = car.body:getAngle()
  local dx, dy = car.body:getLinearVelocity()
  local ux = math.cos(angle)
  local uy = math.sin(angle)
  local speed = dx * ux + dy * uy
  local accel = 0
  if love.keyboard.isDown("up") then
    accel = 20 * dt
  elseif love.keyboard.isDown("down") then
    accel = -10 * dt
  end
  if love.keyboard.isDown("left") then
    car.body:setAngularVelocity(-math.max(math.min(speed / 2, 3), -3))
  elseif love.keyboard.isDown("right") then
    car.body:setAngularVelocity(math.max(math.min(speed / 2, 3), -3))
  else
    car.body:setAngularVelocity(0)
  end
  speed = speed + accel
  dx = speed * ux
  dy = speed * uy
  car.body:setLinearVelocity(dx, dy)
  speedIntegral = speedIntegral + speed * dt
end

function game.cars.draw()
  local image = images[math.floor(speedIntegral * 2) % #images + 1]
  local x, y = car.body:getPosition()
  love.graphics.draw(image,
    x, y, -- pos
    car.body:getAngle() + math.pi / 2, -- rotation
    0.075, 0.075, -- scale
    image:getWidth() / 2, image:getHeight() / 2 -- origin
  )
  game.debug.wireBrush()
  --game.debug.drawPhysicsBody(car.body)
end
