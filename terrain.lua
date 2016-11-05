game.terrain = {}

local tileSize = 2

local terrainTypes = {
  {name="Grass", color={64, 128, 64}},
  {name="Dirt", color={128, 92, 64}},
  {name="Mud", color={64, 48, 32}}
}

local baseTerrain = nil
local width = nil
local height = nil
local layers = nil

local function worldToTile(x, y)
  return x / tileSize, y / tileSize
end

local function tileToWorld(x, y)
  return x * tileSize, y * tileSize
end

local function outOfBounds(x, y)
  return x < 0 or x >= width or y < 0 or y >= height
end

local function getLayerTile(layer, x, y)
  if outOfBounds(x, y) then return false end
  return layers[layer].map[x + y * width]
end

local function clearLayerTile(layer, x, y)
  if outOfBounds(x, y) then return end
  layers[layer].map[x + y * width] = false
end

local function setLayerTile(layer, x, y)
  if outOfBounds(x, y) then return end
  layers[layer].map[x + y * width] = true
end

local function getTile(x, y)
  if #layers == 0 then return baseTerrain end
  for layer=#layers,1 do
    if getLayerTile(layer, x, y) then
      return layers[layer].terrain
    end
  end
  return baseTerrain
end

function game.terrain.getLayerTerrainType(layer)
  return terrainTypes[layers[layer].terrain]
end

function game.terrain.layerCount()
  return #layers
end

function game.terrain.addLayer()
  table.insert(layers, {terrain=1, map={}})
  for y=0,height-1 do
    for x=0,width-1 do
      clearLayerTile(#layers, x, y)
    end
  end
end

function game.terrain.removeLayer()
  table.remove(layers)
end

function game.terrain.reset()
  baseTerrain = 1
  width = 100
  height = 100
  layers = {}
end

function game.terrain.read(f)
  game.terrain.reset()
  baseTerrain = f:read(1):byte()
  width = f:read(1):byte()
  height = f:read(1):byte()
  local layerCount = f:read(1):byte()
  assert(#layers == 0)
  for layer=1,layerCount do
    local terrain = f:read(1):byte()
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
  f:write(string.char(baseTerrain))
  f:write(string.char(width))
  f:write(string.char(height))
  f:write(string.char(#layers))
  for layer=1,#layers do
    f:write(string.char(layers[layer].terrain))
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

function game.terrain.cycleBaseTerrain()
  baseTerrain = (baseTerrain % #terrainTypes) + 1
end

function game.terrain.cycleLayerTerrain(layer)
  layers[layer].terrain = (layers[layer].terrain % #terrainTypes) + 1
end

function game.terrain.draw()
  local minX, minY = worldToTile(game.camera.screenToWorld(0, 0))
  local maxX, maxY = worldToTile(game.camera.screenToWorld(game.ui.width, game.ui.height))
  minX = math.floor(minX)
  minY = math.floor(minY)
  maxX = math.floor(maxX)
  maxY = math.floor(maxY)
  game.debug.wireBrush()
  for y=minY,maxY do
    for x=minX,maxX do
      love.graphics.push()
      love.graphics.translate(tileToWorld(x, y))
      love.graphics.setColor(unpack(terrainTypes[getTile(x, y)].color))
      love.graphics.rectangle("fill", 0, 0, tileSize, tileSize)
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", 0, 0, tileSize, tileSize)
      love.graphics.pop()
    end
  end
end
