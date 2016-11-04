game.ui = {}

game.ui.width = love.graphics.getWidth()
game.ui.height = love.graphics.getHeight()

function love.resize(w, h)
  game.ui.width = w
  game.ui.height = h
end
