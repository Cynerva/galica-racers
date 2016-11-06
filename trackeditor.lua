game.trackEditor = {}

local finished = game.event.new()

function game.trackEditor.inUI(args)
  local track = args.track or function() end
  local panelBackground = args.panelBackground or function() end
  local panelHeader = args.panelHeader or function() end
  local panel = args.panel or function() end
  game.ui.split(2/3,
    track,
    function()
      panelBackground()
      game.ui.margin(10, function()
        game.ui.split(1/8,
          panelHeader,
          panel
        )
      end)
    end
  )
end

function game.trackEditor.update()
  local dt = love.timer.getDelta()
  local x, y = game.camera.getPosition()
  if love.keyboard.isDown("left") then x = x - dt * 16 end
  if love.keyboard.isDown("right") then x = x + dt * 16 end
  if love.keyboard.isDown("up") then y = y - dt * 16 end
  if love.keyboard.isDown("down") then y = y + dt * 16 end
  game.camera.setPosition(x, y)
end

local function drawBox(r, g, b)
  love.graphics.setColor(r, g, b)
  love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", 0, 0, game.ui.width, game.ui.height)
end

function game.trackEditor.drawButton(text, r, g, b)
  drawBox(r, g, b)
  love.graphics.setColor(255, 255, 255)
  love.graphics.scale(2, 2)
  love.graphics.printf(text, 0, game.ui.height / 6, game.ui.width / 2, "center")
end

function game.trackEditor.draw(mode, drawPanel)
  game.trackEditor.inUI {
    track=function()
      game.camera.transform()
      game.track.draw()
      game.waypoints.draw()
    end,
    panelBackground=function()
      drawBox(32, 32, 32)
    end,
    panelHeader=function()
      game.trackEditor.drawButton(mode, 128, 192, 128)
    end,
    panel=drawPanel
  }
end

local function keypressed(key)
  if key == "escape" then
    finished:send()
    return
  end
end

function game.trackEditor.run()
  love.keypressed = keypressed
  game.track.load()
  game.terrainEditor.start()
  finished:wait()
  game.track.save()
end
