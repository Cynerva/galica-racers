game.terrainEditor = {}

local selectedLayer = 0

local buttonDefs = {
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

local function panelLayer(select, terrain)
  return function()
    game.ui.splitHorizontal(2/3, select, terrain)
  end
end

local function panelUI(layers, buttons)
  return function()
    game.ui.split(2/3,
      function()
        game.ui.stackVertical(unpack(layers))
      end,
      function()
        game.ui.stackVertical(unpack(buttons))
      end
    )
  end
end

local function update()
  game.trackEditor.update()
  local x, y = love.mouse.getPosition()
  game.trackEditor.inUI {
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

local function mousepressed(x, y)
  local function ifInBounds(f)
    return function()
      if game.ui.inBounds(x, y) then f() end
    end
  end

  local layers = {}
  for i=0,game.terrain.layerCount()-1 do
    table.insert(layers, panelLayer(
      ifInBounds(function()
        selectedLayer = i
      end),
      ifInBounds(function()
        game.terrain.cycleLayerTerrain(i)
      end)
    ))
  end

  local buttons = {}
  for _,button in ipairs(buttonDefs) do
    table.insert(buttons, ifInBounds(button.click))
  end

  game.trackEditor.inUI {
    panelHeader=ifInBounds(game.propEditor.start),
    panel=panelUI(layers, buttons)
  }
end

local function draw()
  local layers = {}
  for i=0,game.terrain.layerCount()-1 do
    table.insert(layers, panelLayer(
      function()
        if i == selectedLayer then
          game.trackEditor.drawButton("Select", 192, 192, 192)
        else
          game.trackEditor.drawButton("Select", 128, 128, 128)
        end
      end,
      function()
        game.trackEditor.drawButton(game.terrain.getLayerTerrainName(i), 96, 96, 96)
      end
    ))
  end

  local buttons = {}
  for _,button in ipairs(buttonDefs) do
    table.insert(buttons, function()
      game.trackEditor.drawButton(button.text, 64, 32, 64)
    end)
  end

  game.trackEditor.draw("Terrain", panelUI(layers, buttons))
end

function game.terrainEditor.start()
  love.keypressed = game.trackEditor.keypressed
  love.update = update
  love.draw = draw
  love.mousepressed = mousepressed
  selectedLayer = 0
end
