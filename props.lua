game.props = {}

-- prop types

local function newProp(imagePath, getShape)
  local image = love.graphics.newImage(imagePath)
  image:setFilter("nearest")
  if getShape == nil then getShape = function() end end
  return {image=image, getShape=getShape}
end

local propScale = 4

local propTypes = {
  newProp("props/boulder.png", function()
    return love.physics.newRectangleShape(propScale, propScale)
  end),
  newProp("props/wall-left.png", function()
    return love.physics.newRectangleShape(propScale, propScale)
  end),
  newProp("props/wall-mid-h.png", function()
    return love.physics.newRectangleShape(propScale, propScale)
  end),
  newProp("props/wall-right.png", function()
    return love.physics.newRectangleShape(propScale, propScale)
  end),
  newProp("props/wall-top.png", function()
    return love.physics.newRectangleShape(propScale, propScale)
  end),
  newProp("props/wall-mid-v.png", function()
    return love.physics.newRectangleShape(propScale, propScale)
  end),
  newProp("props/wall-bottom.png", function()
    return love.physics.newRectangleShape(propScale, propScale)
  end),
  newProp("props/checkpoint-h.png"),
  newProp("props/checkpoint-v.png"),
  newProp("props/checkpoint-post.png", function()
    return love.physics.newRectangleShape(propScale / 8, propScale / 4)
  end)
}

local function getPropType(i)
  return propTypes[i + 1]
end

function game.props.numTypes()
  return #propTypes
end

-- active props

local props = nil

function game.props.addProp(x, y, propType)
  local prop = {}
  prop.x = x
  prop.y = y
  prop.type = propType
  table.insert(props, prop)
end

function game.props.eraseProps(x, y)
  for i=#props,1,-1 do
    local prop = props[i]
    local image = getPropType(prop.type).image
    local width = image:getWidth() * propScale / 64
    local height = image:getHeight() * propScale / 64
    local x0 = prop.x - width / 2
    local y0 = prop.y - height / 2
    local x1 = prop.x + width / 2
    local y1 = prop.y + height / 2
    if x >= x0 and x < x1 and y >= y0 and y < y1 then
      table.remove(props, i)
    end
  end
end

function game.props.reset()
  props = {}
  --[[ boulders
  game.props.addProp(10, 10, 0)
  game.props.addProp(15, 10, 0)
  game.props.addProp(10, 15, 0)
  -- h wall
  game.props.addProp(10, 30, 1)
  game.props.addProp(15, 30, 2)
  game.props.addProp(20, 30, 3)
  -- v wall
  game.props.addProp(30, 10, 4)
  game.props.addProp(30, 15, 5)
  game.props.addProp(30, 20, 6)
  -- checkpoint
  game.props.addProp(40, 10, 7)
  game.props.addProp(40, 15, 8)
  game.props.addProp(40, 20, 9)
  --]]
end

function game.props.read(f)
  local count = f:read(1):byte()
  for i=1,count do
    local type = f:read(1):byte()
    local x = f:read(1):byte()
    local y = f:read(1):byte()
    game.props.addProp(x, y, type)
  end
end

function game.props.write(f)
  f:write(string.char(#props))
  for _,prop in ipairs(props) do
    f:write(string.char(prop.type))
    f:write(string.char(prop.x))
    f:write(string.char(prop.y))
  end
end

function game.props.addPhysics(world)
  for _,prop in ipairs(props) do
    local type = getPropType(prop.type)
    local shape = type.getShape()
    if shape ~= nil then
      local body = love.physics.newBody(world, prop.x, prop.y)
      local fixture = love.physics.newFixture(body, shape, 1)
    end
  end
end

function game.props.drawProp(x, y, type)
  local image = getPropType(type).image
  love.graphics.draw(image,
    x, y, -- pos
    0, -- angle
    propScale / 64, propScale / 64, -- scale
    image:getWidth() / 2, image:getHeight() / 2 -- origin
  )
end

function game.props.draw()
  love.graphics.setColor(255, 255, 255)
  for _,prop in ipairs(props) do
    game.props.drawProp(prop.x, prop.y, prop.type)
  end
end
