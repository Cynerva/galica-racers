game.race = {}

local done = game.event.new()

local startTime = nil
local endTime = nil

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

local function formatTime(time)
  local minutes = math.floor(time / 60)
  local seconds = math.floor(time % 60)
  local milliseconds = math.floor(time % 1 * 1000)
  local formattedTime = string.format("%02d:%02d.%03d", minutes, seconds, milliseconds)
  return formattedTime
end

local function drawTimer()
  local endTime = endTime or love.timer.getTime()
  local startTime = startTime or endTime
  local raceTime = endTime - startTime
  local formattedTime = formatTime(raceTime)
  love.graphics.print(formattedTime, game.ui.width - 80, 16)
end

local function draw()
  love.graphics.push()
  game.camera.transform()
  game.track.draw()
  game.cars.draw()
  love.graphics.pop()
  drawTimer()
end

local function transitionIn()
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
end

local function transitionToFinish()
  local drawParent = draw
  game.transitions.withTransition(1, function(progress)
    function love.draw()
      drawParent()
      love.graphics.setColor(255, 255, 255)
      progress = ((progress * 2 - 1) ^ 3 + 1) / 2
      love.graphics.print("Finish!", (1 - progress) * game.ui.width, game.ui.height / 2)
    end
  end)
  game.transitions.fadeToBlack(192)
  love.draw = drawParent
end

local function raceFinish(lapTimes)
  game.cars.disableControls()
  transitionToFinish()
  function love.draw()
    draw()
    love.graphics.setColor(0, 0, 0, 192)
    love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
    love.graphics.setColor(255, 255, 255)
    for lap=1,#lapTimes do
      local formattedTime = formatTime(lapTimes[lap])
      love.graphics.printf("Lap " .. lap .. ": " .. formattedTime, 0, lap * 50, game.ui.width, "center")
    end
    local formattedTotalTime = formatTime(endTime - startTime)
    love.graphics.printf("Total: " .. formattedTotalTime, 0, 200, game.ui.width, "center")
  end
  function love.keypressed()
    done:send()
  end
  function love.gamepadpressed()
    done:send()
  end
end

function game.race.run()
  startTime = nil
  endTime = nil
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
      startTime = love.timer.getTime()
      local lapTimes = {}
      for lap=1,3 do
        local lapStartTime = love.timer.getTime()
        game.waypoints.finishedLap:wait()
        table.insert(lapTimes, love.timer.getTime() - lapStartTime)
      end
      endTime = love.timer.getTime()
      raceFinish(lapTimes)
    end)
    done:wait()
  end)
  music:stop()
end
