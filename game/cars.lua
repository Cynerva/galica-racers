game.cars = {}

local function newCarImage(path)
  local image = love.graphics.newImage(path)
  image:setFilter("nearest")
  return image
end

local car = nil
local controlsEnabled = true
local images = {
  newCarImage("car-sprites/car4.png"),
  newCarImage("car-sprites/car3.png"),
  newCarImage("car-sprites/car2.png"),
  newCarImage("car-sprites/car1.png")
}
local speedIntegral = nil -- used for animation

local engineSound = love.audio.newSource("sounds/engine2.ogg")
engineSound:setLooping(true)
local collisionSound = love.audio.newSource("sounds/collision.ogg")

function game.cars.getBody()
  return car.body
end

function game.cars.withCars(f)
  car = {}
  local x, y = game.track.getSpawn()
  car.body = love.physics.newBody(game.track.world, x, y, "dynamic")
  local shape = love.physics.newRectangleShape(-0.9, 0, 1, 2.5)
  local fixture = love.physics.newFixture(car.body, shape, 1)
  local shape = love.physics.newRectangleShape(3, 1)
  local fixture = love.physics.newFixture(car.body, shape, 1)
  car.body:setLinearDamping(0.5)
  controlsEnabled = true
  speedIntegral = 0
  engineSound:setVolume(1)
  engineSound:play()
  f()
  engineSound:stop()
end

function game.cars.disableControls()
  controlsEnabled = false
end

function game.cars.enableControls()
  controlsEnabled = true
end

local function getControls()
  local controls = {}
  local accel = 0
  local turn = 0
  if controlsEnabled then
    for i,joystick in ipairs(love.joystick.getJoysticks()) do
      accel = accel + (joystick:getAxis(6) + 1) / 2
      accel = accel - (joystick:getAxis(3) + 1) / 2
      turn = turn + joystick:getAxis(1)
      if joystick:isGamepadDown("dpleft") then
        turn = turn - 1
      end
      if joystick:isGamepadDown("dpright") then
        turn = turn + 1
      end
    end
    if love.keyboard.isDown("up") then
      accel = accel + 1
    end
    if love.keyboard.isDown("down") then
      accel = accel - 1
    end
    if love.keyboard.isDown("left") then
      turn = turn - 1
    end
    if love.keyboard.isDown("right") then
      turn = turn + 1
    end
    accel = math.min(1, math.max(-1, accel))
    turn = math.min(1, math.max(-1, turn))
  end
  controls.accel = accel
  controls.turn = turn
  return controls
end

function game.cars.update()
  local controls = getControls()
  local angle = car.body:getAngle()
  local dx, dy = car.body:getLinearVelocity()
  local ux = math.cos(angle)
  local uy = math.sin(angle)
  local forwardSpeed = dx * ux + dy * uy
  -- forward/backward calculations
  local accelForce = controls.accel * 120
  if accelForce < 0 then accelForce = accelForce / 2 end
  car.body:applyForce(accelForce * ux, accelForce * uy)
  -- left/right calculations
  local sideAngle = angle + math.pi / 2
  local sideUx = math.cos(sideAngle)
  local sideUy = math.sin(sideAngle)
  local sideSpeed = dx * sideUx + dy * sideUy
  local sideForce = -sideSpeed * 64
  car.body:applyForce(sideForce * sideUx, sideForce * sideUy)
  -- angular calculations
  car.body:setAngularVelocity(controls.turn * math.max(math.min(forwardSpeed / 2, 3), -3))
  -- animations and sound
  local dt = love.timer.getDelta()
  speedIntegral = speedIntegral + forwardSpeed * dt
  engineSound:setPitch(1 + math.abs(forwardSpeed) * 0.05)
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
  --game.debug.wireBrush()
  --game.debug.drawPhysicsBody(car.body)
end

function game.cars.setVolume(volume)
  engineSound:setVolume(volume)
end

local function watchCollisions()
  while true do
    local a, b, impulse = game.track.postSolveCollision:wait()
    if not collisionSound:isPlaying() then
      collisionSound:setVolume(0)
      collisionSound:play()
    end
    local volume = math.max(collisionSound:getVolume(), math.min(1.0, impulse / 100))
    collisionSound:setVolume(volume)
  end
end

game.event.fork(watchCollisions)
