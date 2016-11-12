game.mainMenu = {}

local titleArt = love.graphics.newImage("menu-sprites/title.png")
titleArt:setFilter("nearest")

local music = love.audio.newSource("music/menu.ogg")
music:setLooping(true)

local options = {"Play", "Track Editor", "Quit"}
local cursor = 0
local select = game.event.new()

local function update()
  local dt = love.timer.getDelta()
  local x, y = game.camera.getPosition()
  x = x + dt
  y = y + dt
  game.camera.setPosition(x, y)
end

local function draw()
  love.graphics.push()
  game.camera.transform()
  game.track.draw()
  love.graphics.pop()
  --love.graphics.setColor(255, 255, 255, 128)
  --love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
  game.ui.split(1/3,
    function()
      love.graphics.setColor(0, 0, 0, 192)
      love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
      for i,text in ipairs(options) do
        if i == cursor + 1 then
          love.graphics.setColor(255, 255, 255)
        else
          love.graphics.setColor(128, 128, 128)
        end
        love.graphics.printf(text, 0, (i + 4) * game.ui.height / 12, game.ui.width, "center")
      end
    end,
    function()
      love.graphics.setColor(255, 255, 255, 128)
      love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
      game.ui.margin(64, function()
        love.graphics.setColor(255, 255, 255)
        local scale = math.min(
          game.ui.width / titleArt:getWidth(),
          game.ui.height / titleArt:getHeight()
        )
        love.graphics.draw(titleArt,
          game.ui.width / 2, game.ui.height / 2, -- pos
          0, -- angle
          scale, scale, -- scale
          titleArt:getWidth() / 2, titleArt:getHeight() / 2 -- origin
        )
      end)
    end
  )
end

local function moveUp()
  cursor = (cursor - 1) % #options
end

local function moveDown()
  cursor = (cursor + 1) % #options
end

local function keypressed(key)
  if key == "up" then
    moveUp()
  elseif key == "down" then
    moveDown()
  elseif key == "return" then
    select:send(options[cursor + 1])
  end
end

local function gamepadpressed(joystick, button)
  if button == "dpup" then
    moveUp()
  elseif button == "dpdown" then
    moveDown()
  elseif button == "a" then
    select:send(options[cursor + 1])
  end
end

function game.mainMenu.run()
  while true do
    love.update = update
    love.keypressed = keypressed
    love.draw = draw
    love.gamepadpressed = gamepadpressed
    cursor = 0
    game.track.reset()
    game.camera.setPosition(0, 0)
    music:play()
    local selection = select:wait()
    if selection == "Play" then
      music:stop()
      game.race.run()
    elseif selection == "Track Editor" then
      game.trackEditor.run()
    elseif selection == "Quit" then
      return
    else
      error("Unrecognized selection: " .. selection)
    end
  end
end
