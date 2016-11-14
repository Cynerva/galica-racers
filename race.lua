game.race = {}

local done = game.event.new()
local updateCountdown = game.event.new()

local countdownBeepSound = love.audio.newSource("sounds/countdown-0.wav")
local countdownEndSound = love.audio.newSource("sounds/countdown-1.wav")
local music = love.audio.newSource("music/race.ogg")
music:setLooping(true)

local function update()
  updateCountdown:send()
  game.track.update()
  game.cars.update()
end

local function pauseRace()
  game.event.fork(function()
    music:pause()
    game.cars.setVolume(0)
    local result = game.pause.run()
    if result == "Return to Menu" then
      done:send()
    else
      game.cars.setVolume(1)
       music:resume()
    end
  end)
end

local function keypressed(key)
  if key == "escape" then
    pauseRace()
  end
end

local function gamepadpressed(joystick, button)
  if button == "start" then
    pauseRace()
  end
end

local function draw()
  game.camera.transform()
  game.track.draw()
  game.cars.draw()
end

local function transitionIn()
  updateCountdown:clear()
  game.event.fork(function()
    game.cars.disableControls()
    game.transitions.fadeFromBlack()
    local counter = 3
    while counter > 0 do
      countdownBeepSound:seek(0)
      countdownBeepSound:play()
      local deadline = love.timer.getTime() + 1
      while love.timer.getTime() < deadline do
        updateCountdown:wait()
      end
      counter = counter - 1
    end
    countdownEndSound:play()
    game.cars.enableControls()
    music:play()
  end)
end

function game.race.run()
  love.update = update
  love.keypressed = keypressed
  love.gamepadpressed = gamepadpressed
  love.draw = draw
  game.track.load()
  game.track.addPhysics()
  game.event.fork(function()
    game.waypoints.finishedLap:wait()
    done:send()
  end)
  game.cars.withCars(function()
    game.camera.followCar()
    transitionIn()
    done:wait()
  end)
  music:stop()
end
