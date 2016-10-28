game.mainMenu = {}

local options = {"Play", "Quit"}
local cursor = 0
local select = game.event.new()

local function draw()
  for i,text in ipairs(options) do
    if i == cursor + 1 then
      love.graphics.setColor(255, 255, 255)
    else
      love.graphics.setColor(128, 128, 128)
    end
    love.graphics.printf(text, 0, 200 + 50 * i, love.graphics.getWidth(), "center")
  end
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
    select:send()
  end
end

function game.mainMenu.run()
  while true do
    love.draw = draw
    love.keypressed = keypressed
    cursor = 0
    select:wait()
    local selection = options[cursor + 1]
    if selection == "Play" then
      game.race.run()
    elseif selection == "Quit" then
      return
    else
      error("Unrecognized selection: " .. selection)
    end
  end
end
