game.waypoint = {}

game.waypoint.hitWaypoint = game.event.new()

function game.waypoint.draw(waypoint)
  game.debug.drawPhysicsBody(waypoint.body)
end

function game.waypoint.new(x, y, width, height)
  local waypoint = {}
  waypoint.body = love.physics.newBody(game.track.world, x, y)
  local shape = love.physics.newRectangleShape(width, height)
  local fixture = love.physics.newFixture(waypoint.body, shape, 1)
  fixture:setUserData{isWaypoint = true}
  return waypoint
end

local function watchCollisions()
  while true do
    local a, b = game.track.beginCollision:wait()
    if a.isWaypoint then
      game.waypoint.hitWaypoint:send(b)
    elseif b.isWaypoint then
      game.waypoint.hitWaypoint:send(a)
    end
  end
end

game.event.fork(watchCollisions)
