game.race = {}

local done = game.event.new()

local countdownBeepSound = love.audio.newSource("sounds/countdown-0.wav")
local countdownEndSound = love.audio.newSource("sounds/countdown-1.wav")
local music = love.audio.newSource("music/race.ogg")
music:setLooping(true)

local function update()
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
    game.cars.disableControls()
    game.transitions.fadeFromBlack()
    local counter = 3
    while counter > 0 do
      countdownBeepSound:seek(0)
      countdownBeepSound:play()
      game.transitions.sleep(1)
      counter = counter - 1
    end
    countdownEndSound:play()
    game.cars.enableControls()
    music:play()
  end)
end

local function raceFinish(lapTimes, totalTime)
  game.cars.disableControls()
  function love.draw()
    love.graphics.push()
    draw()
    love.graphics.pop()
    love.graphics.setColor(0, 0, 0, 192)
    love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
    love.graphics.setColor(255, 255, 255)
    for lap=1,#lapTimes do
      love.graphics.printf("Lap " .. lap .. ": " .. lapTimes[lap], 0, lap * 50, game.ui.width, "center")
    end
    love.graphics.printf("Total: " .. totalTime, 0, 200, game.ui.width, "center")
  end
  function love.keypressed()
    done:send()
  end
  function love.gamepadpressed()
    done:send()
  end
end

function game.race.run()
  love.update = update
  love.keypressed = keypressed
  love.gamepadpressed = gamepadpressed
  love.draw = draw
  game.track.load()
  game.track.addPhysics()
  game.cars.withCars(function()
    game.camera.followCar()
    game.event.fork(function()
      transitionIn()
      local lapTimes = {}
      local startTime = love.timer.getTime()
      for lap=1,3 do
        local lapStartTime = love.timer.getTime()
        game.waypoints.finishedLap:wait()
        table.insert(lapTimes, love.timer.getTime() - lapStartTime)
      end
      local totalTime = love.timer.getTime() - startTime
      raceFinish(lapTimes, totalTime)
    end)
    done:wait()
  end)
  music:stop()
end
