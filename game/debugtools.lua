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

function game.debug.wireBrush()
  love.graphics.setLineWidth(0.1)
  love.graphics.setColor(255, 255, 255)
end

function game.debug.drawUnitGrid()
  for y=-10,10 do
    for x=-10,10 do
      love.graphics.rectangle("line", x, y, 1, 1)
    end
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

function game.debug.drawPhysicsWorld(world)
  if world == nil then
    return
  end
  for i,body in ipairs(world:getBodyList()) do
    game.debug.drawPhysicsBody(body)
  end
end

function game.debug.profile(f)
  local ProFi = require("ProFi")
  ProFi:start()
  f()
  ProFi:stop()
  ProFi:writeReport("profile.txt")
end
