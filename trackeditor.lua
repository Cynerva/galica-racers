game.trackEditor = {}

local function init()
  game.track.init()
  game.camera.setPosition(0, 0)
end

local function update()
end

local function draw()
  game.camera.transform()
  game.track.draw()
end

local function keypressed(key)
end

function game.trackEditor.run()
  init()
  love.update = update
  love.draw = draw
  love.keypressed = keypressed
  game.event.new():wait()
end
