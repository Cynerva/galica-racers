game.waypoint = {}

game.waypoint.finishedLap = game.event.new()

local waypoints = nil
local nextId = nil
local maxId = nil

function game.waypoint.reset()
  waypoints = {}
  nextId = 1
  maxId = -1
end

function game.waypoint.add(id, x, y)
  local waypoint = {id=id, x=x, y=y}
  table.insert(waypoints, waypoint)
  if id > maxId then maxId = id end
end

function game.waypoint.read(f)
  local count = f:read(1):byte()
  for i=1,count do
    local id = f:read(1):byte()
    local x = f:read(1):byte()
    local y = f:read(1):byte()
    game.waypoint.add(id, x, y)
  end
end

function game.waypoint.write(f)
  f:write(string.char(#waypoints))
  for i,waypoint in ipairs(waypoints) do
    f:write(string.char(waypoint.id))
    f:write(string.char(waypoint.x))
    f:write(string.char(waypoint.y))
  end
end

function game.waypoint.addPhysics(world)
  local shape = love.physics.newRectangleShape(game.tiles.tileSize, game.tiles.tileSize)
  for i,waypoint in ipairs(waypoints) do
    local body = love.physics.newBody(world, game.tiles.worldPos(waypoint.x, waypoint.y))
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setSensor(true)
    fixture:setUserData{isWaypoint=true, id=waypoint.id}
  end
end

function game.waypoint.draw()
  for i,waypoint in ipairs(waypoints) do
    if waypoint.id == nextId then
      love.graphics.setColor(0, 255, 0)
    else
      love.graphics.setColor(255, 0, 0)
    end
    love.graphics.push()
    love.graphics.translate(game.tiles.worldPos(waypoint.x, waypoint.y))
    love.graphics.translate(-game.tiles.tileSize / 2, -game.tiles.tileSize / 2)
    love.graphics.rectangle("line", 0, 0, 4, 4)
    love.graphics.scale(0.2, 0.2)
    love.graphics.print(tostring(waypoint.id), 0, 0)
    love.graphics.pop()
  end
end

local function watchCollisions()
  while true do
    local a, b = game.track.beginCollision:wait()
    if a.isWaypoint and a.id == nextId or b.isWaypoint and b.id == nextId then
      nextId = nextId + 1
      if nextId > maxId then
        nextId = 1
        game.waypoint.finishedLap:send()
      end
    end
  end
end

game.event.fork(watchCollisions)
