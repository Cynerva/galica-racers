game.propEditor = {}

local currentType = 0
local anchorX = nil
local anchorY = nil

local buttons = {
  {text="Next",
    click=function()
      currentType = (currentType + 1) % game.props.numTypes()
    end
  },
  {text="Previous",
    click=function()
      currentType = (currentType - 1) % game.props.numTypes()
    end
  }
}

local function update()
  game.trackEditor.update()
  if love.mouse.isDown(1) and anchorX ~= nil and anchorY ~= nil then
    game.trackEditor.inUI {
      track=function()
        local x, y = game.camera.screenToWorld(love.mouse.getPosition())
        local w, h = game.props.getPropSize(currentType)
        x = math.floor((x - anchorX) / w + 0.5) * w + anchorX
        y = math.floor((y - anchorY) / h + 0.5) * h + anchorY
        game.props.addProp(x, y, currentType)
      end
    }
  elseif love.mouse.isDown(2) then
    local x, y = love.mouse.getPosition()
    game.trackEditor.inUI {
      track=function()
        if not game.ui.inBounds(x, y) then return end
        game.props.eraseProps(game.camera.screenToWorld(x, y))
      end
    }
  end
end

local function forEachButtonInUI(f)
  local buttonProcs = {}
  for _,button in ipairs(buttons) do
    local function buttonProc()
      f(button)
    end
    table.insert(buttonProcs, buttonProc)
  end
  game.ui.stackVertical(unpack(buttonProcs))
end

local function mousepressed(x, y, button)
  if button ~= 1 then return end
  game.trackEditor.inUI {
    track=function()
      if not game.ui.inBounds(x, y) then return end
      anchorX, anchorY = game.camera.screenToWorld(x, y)
    end,
    panelHeader=function()
      if not game.ui.inBounds(x, y) then return end
      game.spawnEditor.start()
    end,
    panel=function()
      forEachButtonInUI(function(button)
        if not game.ui.inBounds(x, y) then return end
        button.click()
      end)
    end
  }
end

local function mousereleased()
  anchorX = nil
  anchorY = nil
end

local function draw()
  game.trackEditor.draw("Props", function() end)
  game.trackEditor.inUI {
    panel=function()
      forEachButtonInUI(function(button)
        game.trackEditor.drawButton(button.text, 128, 128, 192)
      end)
    end
  }
  game.trackEditor.inUI {
    track=function()
      game.camera.transform()
      local x, y = game.camera.screenToWorld(love.mouse.getPosition())
      game.props.drawProp(x, y, currentType)
    end
  }
end

function game.propEditor.start()
  currentType = 0
  anchorX = nil
  anchorY = nil
  love.update = update
  love.mousepressed = mousepressed
  love.mousereleased = mousereleased
  love.keypressed = game.trackEditor.keypressed
  love.draw = draw
end
