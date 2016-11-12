game.pause = {}

local selection = game.event.new()
local oldDraw = nil
local cursor = 0
local options = {"Continue", "Return to Menu"}

local function keypressed(key)
  if key == "return" then
    selection:send(options[cursor + 1])
  elseif key == "up" then
    cursor = (cursor - 1) % #options
  elseif key == "down" then
    cursor = (cursor + 1) % #options
  elseif key == "escape" then
    selection:send(options[1])
  end
end

local function draw()
  oldDraw()
  love.graphics.origin()
  love.graphics.setColor(0, 0, 0, 128)
  love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
  for i,text in ipairs(options) do
    if i == cursor + 1 then
      love.graphics.setColor(255, 255, 255)
    else
      love.graphics.setColor(128, 128, 128)
    end
    love.graphics.printf(text, 0, (i + 2) * game.ui.height / 7, game.ui.width, "center")
  end
end

function game.pause.run()
  cursor = 0
  local oldUpdate = love.update
  local oldKeypressed = love.keypressed
  local oldMousepressed = love.mousepressed
  local oldMousereleased = love.mousereleased
  oldDraw = love.draw
  love.update = nil
  love.keypressed = keypressed
  love.mousepressed = nil
  love.mousereleased = nil
  love.draw = draw
  local selection = selection:wait()
  love.update = oldUpdate
  love.keypressed = oldKeypressed
  love.mousepressed = oldMousepressed
  love.mousereleased = oldMousereleased
  love.draw = oldDraw
  return selection
end
