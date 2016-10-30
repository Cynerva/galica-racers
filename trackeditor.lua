game.trackEditor = {}

-- tile coordinates
local posX = 0
local posY = 0
local finished = game.event.new()

local function update()
  if love.keyboard.isDown("q") then
    game.tiles.setTile(posX, posY, game.tiles.dirt)
  elseif love.keyboard.isDown("w") then
    game.tiles.setTile(posX, posY, game.tiles.mud)
  elseif love.keyboard.isDown("e") then
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
  elseif key == "c" then
    game.waypoint.reset()
  else
    local num = tonumber(key)
    if num ~= nil then
      game.waypoint.add(num, posX, posY)
    end
  end
  game.camera.setPosition(game.tiles.worldPos(posX, posY))
end

function game.trackEditor.run()
  love.update = update
  love.draw = draw
  love.keypressed = keypressed
  game.track.load()
  game.camera.setPosition(game.tiles.worldPos(posX, posY))
  finished:wait()
  game.track.save()
end
