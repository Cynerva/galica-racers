game.car = {}

local function update(car)
  local dt = love.timer.getDelta()
  local angle = car.body:getAngle()
  if love.keyboard.isDown("left") then
    angle = angle - 2 * dt
  elseif love.keyboard.isDown("right") then
    angle = angle + 2 * dt
  end
  car.body:setAngle(angle)
  local accel = 0
  if love.keyboard.isDown("up") then
    accel = 20 * dt
  elseif love.keyboard.isDown("down") then
    accel = -20 * dt
  end
  local dx, dy = car.body:getLinearVelocity()
  local speed = math.sqrt(dx * dx + dy * dy) + accel
  dx = speed * math.cos(angle)
  dy = speed * math.sin(angle)
  car.body:setLinearVelocity(dx, dy)
end

local function draw(car)
  game.debug.drawPhysicsBody(car.body)
end

function game.car.new(world)
  local car = {}
  car.update = update
  car.draw = draw
  car.body = love.physics.newBody(world, 0, 0, "dynamic")
  local shape = love.physics.newRectangleShape(1, 1)
  local fixture = love.physics.newFixture(car.body, shape, 1)
  car.body:setLinearDamping(1)
  return car
end
