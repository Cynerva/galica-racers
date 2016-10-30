game.trackEditor = {}

-- tile coordinates
local posX = 1
local posY = 1
local finished = game.event.new()

local function init()
  game.track.load()
  game.camera.setPosition(game.tiles.worldPos(posX, posY))
end

local function update()
  if love.keyboard.isDown("1") then
    game.tiles.setTile(posX, posY, game.tiles.dirt)
  elseif love.keyboard.isDown("2") then
    game.tiles.setTile(posX, posY, game.tiles.mud)
  elseif love.keyboard.isDown("3") then
    game.tiles.setTile(posX, posY, game.tiles.rock)
  end
end

local function draw()
  game.camera.transform()
  game.track.draw()
end

local function keypressed(key)
  if key == "up" then
    posY = posY - 1
  elseif key == "down" then
    posY = posY + 1
  elseif key == "left" then
    posX = posX - 1
  elseif key == "right" then
    posX = posX + 1
  elseif key == "escape" then
    finished:send()
    return
  end
  game.camera.setPosition(game.tiles.worldPos(posX, posY))
end

function game.trackEditor.run()
  init()
  love.update = update
  love.draw = draw
  love.keypressed = keypressed
  finished:wait()
  game.track.save()
end
