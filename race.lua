game.race = {}

local done = game.event.new()

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

function game.race.run()
  love.update = update
  love.keypressed = keypressed
  love.gamepadpressed = gamepadpressed
  love.draw = draw
  game.track.load()
  game.track.addPhysics()
  music:play()
  game.event.fork(function()
    game.waypoints.finishedLap:wait()
    done:send()
  end)
  game.cars.withCars(function()
    game.camera.followCar()
    done:wait()
  end)
  music:stop()
end
