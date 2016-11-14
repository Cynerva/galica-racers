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

function game.transitions.withTransition(duration, f)
  local startTime = love.timer.getTime()
  local endTime = startTime + duration

  withUpdates(function()
    while love.timer.getTime() < endTime do
      local progress = (love.timer.getTime() - startTime) / duration
      f(progress)
      update:wait()
    end
    f(1)
  end)
end

function game.transitions.sleep(duration)
  local endTime = love.timer.getTime() + duration
  withUpdates(function()
    while love.timer.getTime() < endTime do update:wait() end
  end)
end

function game.transitions.fadeToBlack()
  local drawParent = love.draw
  local progress = 0
  function love.draw()
    drawParent()
    love.graphics.origin()
    love.graphics.setColor(0, 0, 0, progress * 255)
    love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
  end

  game.transitions.withTransition(1/4, function(p)
    progress = p
  end)

  draw = drawParent
end

function game.transitions.fadeFromBlack()
  local drawParent = love.draw
  local progress = 0
  function love.draw()
    drawParent()
    love.graphics.origin()
    love.graphics.setColor(0, 0, 0, (1 - progress) * 255)
    love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
  end

  game.transitions.withTransition(1/4, function(p)
    progress = p
  end)

  draw = drawParent
end
