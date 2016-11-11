game.props = {}

-- prop types

local function newProp(imagePath, getShape)
  local image = love.graphics.newImage(imagePath)
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

-- active props

local props = nil

local function addProp(x, y, propType)
  local prop = {}
  prop.x = x
  prop.y = y
  prop.type = propType
  table.insert(props, prop)
end

function game.props.reset()
  props = {}
  -- boulders
  addProp(10, 10, 0)
  addProp(15, 10, 0)
  addProp(10, 15, 0)
  -- h wall
  addProp(10, 30, 1)
  addProp(15, 30, 2)
  addProp(20, 30, 3)
  -- v wall
  addProp(30, 10, 4)
  addProp(30, 15, 5)
  addProp(30, 20, 6)
  -- checkpoint
  addProp(40, 10, 7)
  addProp(40, 15, 8)
  addProp(40, 20, 9)
end

function game.props.read(f)
  -- TODO
end

function game.props.write(f)
  -- TODO
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

function game.props.draw()
  love.graphics.setColor(255, 255, 255)
  for _,prop in ipairs(props) do
    local image = getPropType(prop.type).image
    love.graphics.draw(image,
      prop.x, prop.y, -- pos
      0, -- angle
      propScale / 64, propScale / 64, -- scale
      image:getWidth() / 2, image:getHeight() / 2 -- origin
    )
  end
end
