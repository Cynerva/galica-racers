game.transitions = {}

local update = game.event.new()

local duration = 1/4

local function withUpdates(f)
  update:clear()
  local updateParent = love.update
  function love.update()
    updateParent()
    update:send()
  end
  f()
  love.update = updateParent
end

function game.transitions.fadeToBlack()
  local startTime = love.timer.getTime()
  local endTime = startTime + duration

  withUpdates(function()
    local drawParent = love.draw
    function love.draw()
      drawParent()
      love.graphics.origin()
      love.graphics.setColor(0, 0, 0, (love.timer.getTime() - startTime) / duration * 255)
      love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
    end

    while love.timer.getTime() < endTime do update:wait() end
    love.draw = drawParent
  end)
end

function game.transitions.fadeFromBlack()
  local startTime = love.timer.getTime()
  local endTime = startTime + duration

  withUpdates(function()
    local drawParent = love.draw
    function love.draw()
      drawParent()
      love.graphics.origin()
      love.graphics.setColor(0, 0, 0, 255 - (love.timer.getTime() - startTime) / duration * 255)
      love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
    end

    while love.timer.getTime() < endTime do update:wait() end
    love.draw = drawParent
  end)
end
