game.car = {}

function game.car.update(car)
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
end

function game.car.draw(car)
  game.debug.wireBrush()
  game.debug.drawPhysicsBody(car.body)
end

function game.car.new()
  local car = {}
  local x, y = game.track.getWorldSpawn()
  car.body = love.physics.newBody(game.track.world, x, y, "dynamic")
  local shape = love.physics.newRectangleShape(2, 1)
  local fixture = love.physics.newFixture(car.body, shape, 1)
  car.body:setLinearDamping(0.5)
  return car
end
