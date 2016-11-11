game.propEditor = {}

local currentType = 0

local function update()
  game.trackEditor.update()
  if love.mouse.isDown(2) then
    local x, y = love.mouse.getPosition()
    game.trackEditor.inUI {
      track=function()
        if not game.ui.inBounds(x, y) then return end
        game.props.eraseProps(game.camera.screenToWorld(x, y))
      end
    }
  end
end

local function mousepressed(x, y, button)
  if button ~= 1 then return end
  game.trackEditor.inUI {
    track=function()
      if not game.ui.inBounds(x, y) then return end
      local x, y = game.camera.screenToWorld(x, y)
      game.props.addProp(x, y, currentType)
    end,
    panelHeader=function()
      if not game.ui.inBounds(x, y) then return end
      game.spawnEditor.start()
    end
  }
end

local function keypressed(key)
  game.trackEditor.keypressed(key)
  if key == "tab" then
    currentType = (currentType + 1) % game.props.numTypes()
  end
end

local function draw()
  game.trackEditor.draw("Props", function() end)
  game.trackEditor.inUI {
    track=function()
      game.camera.transform()
      local x, y = game.camera.screenToWorld(love.mouse.getPosition())
      game.props.drawProp(x, y, currentType)
    end
  }
end

function game.propEditor.start()
  love.update = update
  love.mousepressed = mousepressed
  love.keypressed = keypressed
  love.draw = draw
end
