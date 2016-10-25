game.debug = {}

local function drawPhysicsShape(shape)
  if shape:typeOf("CircleShape") then
    love.graphics.circle("line", 0, 0, shape:getRadius())
  elseif shape:typeOf("PolygonShape") then
    points = {shape:getPoints()}
    love.graphics.polygon("line", points)
  else
    print("Don't know how to draw " .. shape:type())
  end
end

function game.debug.drawPhysicsBody(body)
  love.graphics.push()
  love.graphics.translate(body:getPosition())
  love.graphics.rotate(body:getAngle())
  for i,fixture in ipairs(body:getFixtureList()) do
    local shape = fixture:getShape()
    drawPhysicsShape(shape)
  end
  love.graphics.pop()
end
