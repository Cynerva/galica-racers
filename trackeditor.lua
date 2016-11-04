game.trackEditor = {}

local finished = game.event.new()

local function update()
end

local function keypressed(key)
  if key == "escape" then
    finished:send()
    return
  end
end

local function draw()
  game.camera.transform()
  game.track.draw()
end

function game.trackEditor.run()
  love.update = update
  love.draw = draw
  love.keypressed = keypressed
  game.track.load()
  finished:wait()
  game.track.save()
end
