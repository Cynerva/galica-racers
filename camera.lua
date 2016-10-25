game.camera = {}

function game.camera.lookAtBody(body)
  local x, y = body:getPosition()
  local dx, dy = body:getLinearVelocity()
  x = x + dx / 4
  y = y + dy / 4
  love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  love.graphics.scale(20, 20)
  love.graphics.translate(-x, -y)
end
