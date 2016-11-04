game.trackEditor = {}

local finished = game.event.new()

local ui = game.ui.split("root", 2/3,
  game.ui.pane("track"),
  game.ui.margin("sidePanel", 10,
    game.ui.pane("button")
  )
)

local function update()
end

local function keypressed(key)
  if key == "escape" then
    finished:send()
    return
  end
end

local function mousepressed(x, y)
  if game.ui.contains(ui, "button", x, y) then
    game.terrain.cycleBase()
  end
end

local function draw()
  game.ui.run(ui, {
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
