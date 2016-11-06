game.waypoints = {}

game.waypoints.finishedLap = game.event.new()

local depth = 2
local waypoints = nil
local nextWaypoint = nil

function game.waypoints.add(x1, y1, x2, y2)
  table.insert(waypoints, {x1=x1, y1=y1, x2=x2, y2=y2})
end

function game.waypoints.reset()
  waypoints = {}
  nextWaypoint = 1
  --[[ debug stuffs
  game.waypoints.add(4, 4, 8, 4)
  game.waypoints.add(4, 8, 4, 12)
  game.waypoints.add(12, 12, 16, 16)
  --]]
end

function game.waypoints.read(f)
  game.waypoints.reset()
  local numWaypoints = f:read(1):byte()
  for i=1,numWaypoints do
    local x1 = f:read(1):byte()
    local y1 = f:read(1):byte()
    local x2 = f:read(1):byte()
    local y2 = f:read(1):byte()
    game.waypoints.add(x1, y1, x2, y2)
  end
end

function game.waypoints.write(f)
  f:write(string.char(#waypoints))
  for _,wp in ipairs(waypoints) do
    f:write(string.char(wp.x1))
    f:write(string.char(wp.y1))
    f:write(string.char(wp.x2))
    f:write(string.char(wp.y2))
  end
end

function game.waypoints.addPhysics(world)
  for i,wp in ipairs(waypoints) do
    local midX = (wp.x1 + wp.x2) / 2
    local midY = (wp.y1 + wp.y2) / 2
    local width = math.sqrt((wp.x2 - wp.x1) ^ 2 + (wp.y2 - wp.y1) ^ 2)
    local theta = math.atan2(wp.y2 - wp.y1, wp.x2 - wp.x1)
    local body = love.physics.newBody(world, midX, midY)
    body:setAngle(theta)
    local shape = love.physics.newRectangleShape(width, depth)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setSensor(true)
    fixture:setUserData { isWaypoint=true, id=i }
  end
end

local function watchCollisions()
  while true do
    local a, b = game.track.beginCollision:wait()
    if a.isWaypoint and a.id == nextWaypoint then
      nextWaypoint = nextWaypoint + 1
    elseif b.isWayoint and b.id == nextWaypoint then
      nextWaypoint = nextWaypoint + 1
    end
    if nextWaypoint > #waypoints then
      nextWaypoint = 1
      game.waypoints.finishedLap:send()
    end
  end
end

game.event.fork(watchCollisions)
