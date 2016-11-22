game.spawnEditor = {}

local function update()
  game.trackEditor.update()
end

local function mousepressed(x, y)
  game.trackEditor.inUI {
    track=function()
      if not game.ui.inBounds(x, y) then return end
      game.track.setSpawn(game.camera.screenToWorld(x, y))
    end,
    panelHeader=function()
      if not game.ui.inBounds(x, y) then return end
      game.waypointEditor.start()
    end
  }
end

local function draw()
  game.trackEditor.draw("Spawn", function() end)
end

function game.spawnEditor.start()
  love.keypressed = game.trackEditor.keypressed
  love.update = update
  love.mousepressed = mousepressed
  love.draw = draw
end
