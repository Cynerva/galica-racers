game.race = {}

local done = game.event.new()
local updateTransitions = game.event.new()

local countdownBeepSound = love.audio.newSource("sounds/countdown-0.wav")
local countdownEndSound = love.audio.newSource("sounds/countdown-1.wav")
local music = love.audio.newSource("music/race.ogg")
music:setLooping(true)

local function update()
  updateTransitions:send()
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
  game.event.fork(function()
    local counter = 3
    game.cars.disableControls()
    updateTransitions:clear()

    local startFade = love.timer.getTime()
    local fadeDuration = 1/4
    local endFade = startFade + fadeDuration

    local drawParent = love.draw
    function love.draw()
      drawParent()
      love.graphics.origin()
      love.graphics.setColor(0, 0, 0, 255 - (love.timer.getTime() - startFade) / fadeDuration * 255)
      love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
    end

    while love.timer.getTime() < endFade do updateTransitions:wait() end
    love.draw = drawParent

    while counter > 0 do
      countdownBeepSound:seek(0)
      countdownBeepSound:play()
      local deadline = love.timer.getTime() + 1
      while love.timer.getTime() < deadline do
        updateTransitions:wait()
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
