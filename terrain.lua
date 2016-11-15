game.terrain = {}

-- Terrain types

local function newTerrain(name, imagePath)
  local image = love.graphics.newImage(imagePath)
  local width = image:getWidth()
  local height = image:getHeight()
  local fullWidth = width * 3
  local fullHeight = height * 3
  local canvas = love.graphics.newCanvas(fullWidth, fullHeight)
  love.graphics.setCanvas(canvas)
  for y=0,2 do
    for x=0,2 do
      love.graphics.draw(image, width * x, height * y)
    end
  end
  love.graphics.setCanvas()
  local imageData = canvas:newImageData()
  for y=0,fullHeight - 1 do
    for x=0,fullWidth - 1 do
      local r, g, b, a = imageData:getPixel(x, y)
      local dist = math.sqrt((x - fullWidth / 2) ^ 2 + (y - fullHeight / 2) ^ 2)
      dist = dist - math.sqrt((width / 2) ^ 2 + (height / 2) ^ 2)
      a = math.max(0, math.min(255, 255 - dist * 10))
      imageData:setPixel(x, y, r, g, b, a)
    end
  end
  local image = love.graphics.newImage(imageData)
  local originX = width
  local originY = height
  local terrain = {}
  terrain.name = name
  terrain.image = image
  terrain.width = width
  terrain.height = height
  terrain.originX = originX
  terrain.originY = originY
  return terrain
end

local terrains = {
  newTerrain("Sand", "terrain-sprites/sand.png"),
  newTerrain("Rocky Sand", "terrain-sprites/rocky-sand.png"),
  newTerrain("Rock", "terrain-sprites/rock.png"),
  newTerrain("Mud", "terrain-sprites/mud.png")
}

local function getTerrain(i)
  return terrains[i + 1]
end

-- Tile coordinates

local tileSize = 2

local function worldToTile(x, y)
  return x / tileSize, y / tileSize
end

local function tileToWorld(x, y)
  return x * tileSize, y * tileSize
end

-- Layers

local baseTerrain = nil
local width = nil
local height = nil
local layers = nil

local function outOfBounds(x, y)
  return x < 0 or x >= width or y < 0 or y >= height
end

local function getLayerTerrain(layer)
  if layer == 0 then return baseTerrain end
  return layers[layer].terrain
end

local function setLayerTerrain(layer, terrain)
  if layer == 0 then
    baseTerrain = terrain
  else
    layers[layer].terrain = terrain
  end
end

local function getLayerTile(layer, x, y)
  if layer == 0 then return true end
  if outOfBounds(x, y) then return false end
  return layers[layer].map[x + y * width]
end

local function clearLayerTile(layer, x, y)
  if layer == 0 or outOfBounds(x, y) then return end
  layers[layer].map[x + y * width] = false
end

local function setLayerTile(layer, x, y)
  if layer == 0 or outOfBounds(x, y) then return end
  layers[layer].map[x + y * width] = true
end

function game.terrain.moveLayer(layer, i)
  if layer == 0 or i == 0 or i > #layers then return end
  table.insert(layers, i, table.remove(layers, layer))
end

-- terrain persistence

function game.terrain.reset()
  baseTerrain = 0
  width = 255
  height = 255
  layers = {}
end

function game.terrain.read(f)
  game.terrain.reset()
  baseTerrain = game.files.readNum(f)
  width = game.files.readNum(f)
  height = game.files.readNum(f)
  local numLayers = game.files.readNum(f)
  assert(#layers == 0)
  for layer=1,numLayers do
    local terrain = game.files.readNum(f)
    table.insert(layers, {terrain=terrain, map={}})
    for y=0,height-1 do
      for x=0,width-1 do
        if f:read(1):byte() == 1 then
          setLayerTile(layer, x, y)
        else
          clearLayerTile(layer, x, y)
        end
      end
    end
  end
end

function game.terrain.write(f)
  game.files.writeNum(f, baseTerrain)
  game.files.writeNum(f, width)
  game.files.writeNum(f, height)
  game.files.writeNum(f, #layers)
  for layer=1,#layers do
    game.files.writeNum(f, layers[layer].terrain)
    for y=0,height-1 do
      for x=0,width-1 do
        if getLayerTile(layer, x, y) then
          f:write(string.char(1))
        else
          f:write(string.char(0))
        end
      end
    end
  end
end

-- editor stuff

function game.terrain.addLayer()
  table.insert(layers, {terrain=0, map={}})
  for y=0,height-1 do
    for x=0,width-1 do
      clearLayerTile(#layers, x, y)
    end
  end
end

function game.terrain.removeLayer()
  table.remove(layers)
end

function game.terrain.getLayerTerrainName(layer)
  return getTerrain(getLayerTerrain(layer)).name
end

function game.terrain.cycleLayerTerrain(layer)
  local terrain = getLayerTerrain(layer)
  setLayerTerrain(layer, (terrain + 1) % #terrains)
end

function game.terrain.paint(layer, x, y)
  local tileX, tileY = worldToTile(x, y)
  tileX = math.floor(tileX)
  tileY = math.floor(tileY)
  setLayerTile(layer, tileX, tileY)
end

function game.terrain.erase(layer, x, y)
  local tileX, tileY = worldToTile(x, y)
  tileX = math.floor(tileX)
  tileY = math.floor(tileY)
  clearLayerTile(layer, tileX, tileY)
end

function game.terrain.layerCount()
  return #layers + 1 -- count base layer
end

-- graphics

function game.terrain.draw()
  local minX, minY = worldToTile(game.camera.screenToWorld(0, 0))
  local maxX, maxY = worldToTile(game.camera.screenToWorld(game.ui.width, game.ui.height))
  minX = math.floor(minX) - 1
  minY = math.floor(minY) - 1
  maxX = math.floor(maxX) + 1
  maxY = math.floor(maxY) + 1
  love.graphics.setColor(255, 255, 255)
  for layer=0,game.terrain.layerCount()-1 do
    local terrain = getTerrain(getLayerTerrain(layer))
    local scaleX = tileSize / terrain.width
    local scaleY = tileSize / terrain.height
    for y=minY,maxY do
      for x=minX,maxX do
        if getLayerTile(layer, x, y) then
          local worldX, worldY = tileToWorld(x, y)
          love.graphics.draw(terrain.image,
            worldX, worldY, -- pos
            0, -- angle
            scaleX, scaleY, -- scale
            terrain.originX, terrain.originY -- origin
          )
        end
      end
    end
  end
end
