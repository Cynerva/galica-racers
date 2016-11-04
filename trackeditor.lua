game.trackEditor = {}

local finished = game.event.new()

local view = game.ui.split(2/3,
  game.ui.pane({draw=function()
    game.camera.transform()
    game.track.draw()
  end}),
  game.ui.overlay(
    game.ui.pane({draw=function()
      love.graphics.setColor(192, 192, 192)
      love.graphics.rectangle("fill", 0, 0, game.ui.width, game.ui.height)
      love.graphics.setColor(32, 32, 32)
      love.graphics.rectangle("line", 0, 0, game.ui.width, game.ui.height)
    end}),
    game.ui.margin(16,
      game.ui.pane({
        draw=function()
          love.graphics.setColor(0, 0, 0)
          love.graphics.print("cycle tile")
        end,
        click=function()
          game.terrain.cycleBase()
        end
      })
    )
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

function game.trackEditor.run()
  love.update = update
  game.ui.setView(view)
  love.keypressed = keypressed
  game.track.load()
  finished:wait()
  game.track.save()
end
