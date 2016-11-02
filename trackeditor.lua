game.trackEditor = {}

local finished = game.event.new()

local function update()
end

local function draw()
  game.camera.transform()
  game.track.draw()
end

local function keypressed(key)
  if key == "escape" then
    finished:send()
    return
  end
end

function game.trackEditor.run()
  love.update = update
  love.draw = draw
  love.keypressed = keypressed
  game.track.load()
  --game.camera.setPosition(0, 0)
  finished:wait()
  game.track.save()
end
