game.terrainEditor = {}

local selectedLayer = nil
local deleteTarget = nil
local brushSize = nil

local buttonDefs = {
  {text="Add layer",
    click=function()
      game.terrain.addLayer()
      selectedLayer = game.terrain.layerCount() - 1
    end
  }
}

local function panelLayer(select, terrain, moveUp, moveDown, delete)
  return function()
    game.ui.split(7/8,
      function()
        game.ui.split(2/3, select, terrain)
      end,
      function()
        game.ui.stackVertical(delete, moveUp, moveDown)
      end
    )
  end
end

local function panelUI(layers, buttons)
  return function()
    game.ui.split(3/4,
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
        game.terrain.paint(selectedLayer, brushSize, game.camera.screenToWorld(x, y))
      elseif love.mouse.isDown(2) then
        game.terrain.erase(selectedLayer, brushSize, game.camera.screenToWorld(x, y))
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
      ifInBounds(function() -- select
        selectedLayer = i
      end),
      ifInBounds(function() -- terrain
        game.terrain.cycleLayerTerrain(i)
      end),
      ifInBounds(function() -- moveUp
        game.terrain.moveLayer(i, i - 1)
      end),
      ifInBounds(function() -- moveDown
        game.terrain.moveLayer(i, i + 1)
      end),
      ifInBounds(function() -- delete
        if deleteTarget == i then
          game.terrain.removeLayer(i)
          deleteTarget = nil
        else
          deleteTarget = i
          game.event.fork(function()
            game.transitions.sleep(1)
            deleteTarget = nil
          end)
        end
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

local function wheelmoved(x, y)
  brushSize = math.max(1, brushSize + y)
end

local function draw()
  local layers = {}
  for i=0,game.terrain.layerCount()-1 do
    table.insert(layers, panelLayer(
      function() -- select
        if i == selectedLayer then
          game.trackEditor.drawButton("Select", 192, 192, 192)
        else
          game.trackEditor.drawButton("Select", 128, 128, 128)
        end
      end,
      function() -- terrain
        game.trackEditor.drawButton(game.terrain.getLayerTerrainName(i), 96, 96, 96)
      end,
      function() -- moveUp
        game.trackEditor.drawButton("Up", 128, 128, 128)
      end,
      function() -- moveDown
        game.trackEditor.drawButton("Down", 128, 128, 128)
      end,
      function() -- delete
        if deleteTarget == i then
          game.trackEditor.drawButton("!", 255, 0, 0)
        else
          game.trackEditor.drawButton("X", 192, 128, 128)
        end
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
  game.trackEditor.inUI {
    track=function()
      game.camera.transform()
      local x, y = game.camera.screenToWorld(love.mouse.getPosition())
      game.debug.wireBrush()
      love.graphics.circle("line", x, y, brushSize)
    end
  }
end

function game.terrainEditor.start()
  selectedLayer = 0
  deleteTarget = nil
  brushSize = 1
  love.keypressed = game.trackEditor.keypressed
  love.update = update
  love.draw = draw
  love.mousepressed = mousepressed
  love.wheelmoved = wheelmoved
end
