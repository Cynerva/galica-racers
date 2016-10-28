game.waypoint = {}

game.waypoint.finishedLap = game.event.new()

local waypoints = nil
local nextId = nil

function game.waypoint.init()
  waypoints = {}
  nextId = 1
end

function game.waypoint.add(x, y, width, height)
  local waypoint = {}
  waypoint.body = love.physics.newBody(game.track.world, x, y)
  local shape = love.physics.newRectangleShape(width, height)
  local fixture = love.physics.newFixture(waypoint.body, shape, 1)
  fixture:setSensor(true)
  fixture:setUserData{isWaypoint = true, id = #waypoints + 1}
  table.insert(waypoints, waypoint)
end

-- TODO: waypoints should have nothing to draw
-- this should be part of the tiles instead
function game.waypoint.draw()
  for i,waypoint in ipairs(waypoints) do
    if i == nextId then
      love.graphics.setColor(0, 255, 0)
    else
      love.graphics.setColor(255, 0, 0)
    end
    game.debug.drawPhysicsBody(waypoint.body)
  end
end

local function watchCollisions()
  while true do
    local a, b = game.track.beginCollision:wait()
    if a.isWaypoint and a.id == nextId or b.isWaypoint and b.id == nextId then
      nextId = nextId + 1
      if nextId > #waypoints then
        nextId = 1
        game.waypoint.finishedLap:send()
      end
    end
  end
end

game.event.fork(watchCollisions)
