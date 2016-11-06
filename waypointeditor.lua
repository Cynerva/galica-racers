game.waypointEditor = {}

local waypointStart = game.event.new()
local waypointEnd = game.event.new()

local function update()
  game.trackEditor.update()
end

local function mousepressed(x, y)
  game.trackEditor.inUI {
    track=function()
      if not game.ui.inBounds(x, y) then return end
      waypointStart:send(game.camera.screenToWorld(x, y))
    end,
    panelHeader=function()
      if not game.ui.inBounds(x, y) then return end
      game.terrainEditor.start()
    end,
    panel=function()
      if not game.ui.inBounds(x, y) then return end
      game.waypoints.reset()
    end
  }
end

local function mousereleased(x, y)
  game.trackEditor.inUI {
    track=function()
      waypointEnd:send(game.camera.screenToWorld(x, y))
    end
  }
end

local function draw()
  game.trackEditor.draw("Waypoints", function()
    game.trackEditor.drawButton("Reset", 192, 128, 128)
  end)
end

function game.waypointEditor.start()
  love.update = update
  love.mousepressed = mousepressed
  love.mousereleased = mousereleased
  love.draw = draw
end

local function watchWaypointEvents()
  while true do
    local startX, startY = waypointStart:wait()
    local endX, endY = waypointEnd:wait()
    game.waypoints.add(startX, startY, endX, endY)
  end
end

game.event.fork(watchWaypointEvents)
