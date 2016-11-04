game.mainMenu = {}

local options = {"Play", "Track Editor", "Quit"}
local cursor = 0
local select = game.event.new()

local function draw()
  for i,text in ipairs(options) do
    if i == cursor + 1 then
      love.graphics.setColor(255, 255, 255)
    else
      love.graphics.setColor(128, 128, 128)
    end
    love.graphics.printf(text, 0, 200 + 50 * i, game.ui.width, "center")
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
    select:send(options[cursor + 1])
  end
end

function game.mainMenu.run()
  while true do
    love.keypressed = keypressed
    love.draw = draw
    cursor = 0
    local selection = select:wait()
    if selection == "Play" then
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
