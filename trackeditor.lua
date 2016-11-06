game.trackEditor = {}

local finished = game.event.new()
local selectedLayer = 0

local buttons = {
  {text="Add layer",
    click=function()
      game.terrain.addLayer()
      selectedLayer = game.terrain.layerCount() - 1
    end
  },
  {text="Remove layer",
    click=function()
      game.terrain.removeLayer()
      if selectedLayer >= game.terrain.layerCount() then
        selectedLayer = game.terrain.layerCount() - 1
      end
    end
  }
}

local function uiLayer(select, terrain)
  return function()
    game.ui.splitHorizontal(2/3, select, terrain)
  end
end

local function inUI(args)
  local track = args.track or function() end
  local sidePanel = args.sidePanel or function() end
  local layers = args.layers or {}
  local buttons = args.buttons or {}
  game.ui.split(2/3,
    track,
    function()
      sidePanel()
      game.ui.margin(10, function()
        game.ui.split(2/3,
          function()
            game.ui.stackVertical(unpack(layers))
          end,
          function()
            game.ui.stackVertical(unpack(buttons))
          end
        )
      end)
    end
  )
end

local function update()
  local x, y = love.mouse.getPosition()
  inUI {
    track=function()
      if not game.ui.inBounds(x, y) then return end
      if love.mouse.isDown(1) then
        game.terrain.paint(selectedLayer, game.camera.screenToWorld(x, y))
      elseif love.mouse.isDown(2) then
        game.terrain.erase(selectedLayer, game.camera.screenToWorld(x, y))
      end
    end
  }
end

local function keypressed(key)
  if key == "escape" then
    finished:send()
    return
  end
end

local function mousepressed(x, y)
  local layerFs = {}

  local function ifInBounds(f)
    return function()
      if game.ui.inBounds(x, y) then f() end
    end
  end

  for i=0,game.terrain.layerCount()-1 do
    table.insert(layerFs, uiLayer(
      ifInBounds(function()
        selectedLayer = i
      end),
      ifInBounds(function()
        game.terrain.cycleLayerTerrain(i)
      end)
    ))
  end

  local buttonFs = {}
  for _,button in ipairs(buttons) do
    table.insert(buttonFs, ifInBounds(button.click))
  end

  inUI {
    layers=layerFs,
    buttons=buttonFs
  }
end

local function draw()
  local function drawBox(r, g, b)
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", 0, 0, game.ui.width, game.ui.height)
  end

  local function drawButton(text, r, g, b)
    drawBox(r, g, b)
    love.graphics.setColor(255, 255, 255)
    love.graphics.scale(2, 2)
    love.graphics.printf(text, 0, game.ui.height / 6, game.ui.width / 2, "center")
  end

  local layerFs = {}
  for i=0,game.terrain.layerCount()-1 do
    table.insert(layerFs, uiLayer(
      function()
        if i == selectedLayer then
          drawButton("Select", 192, 192, 192)
        else
          drawButton("Select", 128, 128, 128)
        end
      end,
      function()
        drawButton(game.terrain.getLayerTerrainName(i), 96, 96, 96)
      end
    ))
  end

  local buttonFs = {}
  for _,button in ipairs(buttons) do
    table.insert(buttonFs, function()
      drawButton(button.text, 64, 32, 64)
    end)
  end

  inUI {
    track=function()
      game.camera.transform()
      game.track.draw()
    end,
    sidePanel=function()
      drawBox(32, 32, 32)
    end,
    layerPanel=function()
      drawBox(0, 0, 0)
    end,
    layers=layerFs,
    buttons=buttonFs
  }
end

function game.trackEditor.run()
  love.update = update
  love.keypressed = keypressed
  love.mousepressed = mousepressed
  love.draw = draw
  game.track.load()
  finished:wait()
  game.track.save()
end
