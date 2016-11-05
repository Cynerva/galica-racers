game.trackEditor = {}

local finished = game.event.new()

local function update()
end

local function keypressed(key)
  if key == "escape" then
    finished:send()
    return
  end
end

local function inUI(args)
  local track = args.track or function() end
  local sidePanel = args.sidePanel or function() end
  local button = args.button or function() end
  game.ui.split(2/3,
    track,
    function()
      sidePanel()
      game.ui.margin(10, button)
    end
  )
end

local function mousepressed(x, y)
  inUI({
    button=function()
      if game.ui.inBounds(x, y) then
        game.terrain.cycleBase()
      end
    end
  })
end

local function draw()
  inUI({
    track=function()
      game.camera.transform()
      game.track.draw()
    end,
    sidePanel=function()
      love.graphics.setColor(192, 192, 192)
      love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
    end,
    button=function()
      love.graphics.setColor(0, 0, 0)
      love.graphics.print("Cycle terrain")
    end
  })
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
