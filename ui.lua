game.ui = {}

game.ui.width = nil
game.ui.height = nil
game.ui.clickX = nil
game.ui.clickY = nil

local view = nil

function game.ui.setView(v)
  view = v
end

function game.ui.pane(args)
  return {draw=args.draw, click=args.click or function() end}
end

function love.draw()
  game.ui.width = love.graphics.getWidth()
  game.ui.height = love.graphics.getHeight()
  view.draw()
end

function love.mousepressed(x, y)
  game.ui.width = love.graphics.getWidth()
  game.ui.height = love.graphics.getHeight()
  game.ui.clickX = x
  game.ui.clickY = y
  view.click()
end

local function drawHorizontalSplit(weight, left, right)
  local width = game.ui.width
  game.ui.width = width * weight
  love.graphics.push()
  left.draw()
  love.graphics.pop()
  love.graphics.push()
  love.graphics.translate(game.ui.width, 0)
  game.ui.width = width - game.ui.width
  right.draw()
  love.graphics.pop()
  game.ui.width = width
end

local function clickHorizontalSplit(weight, left, right)
  local width = game.ui.width
  local clickX = game.ui.clickX
  game.ui.width = width * weight
  if clickX < game.ui.width then
    left.click()
  else
    game.ui.clickX = clickX - game.ui.width
    game.ui.width = width - game.ui.width
    right.click()
    game.ui.clickX = clickX
  end
  game.ui.width = width
end

function game.ui.splitHorizontal(weight, left, right)
  return game.ui.pane({
    draw=function()
      drawHorizontalSplit(weight, left, right)
    end,
    click=function()
      clickHorizontalSplit(weight, left, right)
    end
  })
end

local function drawVerticalSplit(weight, top, bottom)
  local height = game.ui.height
  game.ui.height = height * weight
  love.graphics.push()
  top.draw()
  love.graphics.pop()
  love.graphics.push()
  love.graphics.translate(0, game.ui.height)
  game.ui.height = height - game.ui.height
  bottom.draw()
  love.graphics.pop()
  game.ui.height = height
end

local function clickVerticalSplit(weight, top, bottom)
  local height = game.ui.height
  local clickY = game.ui.clickY
  game.ui.height = height * weight
  if clickY < game.ui.height then
    top.click()
  else
    game.ui.clickY = clickY - game.ui.height
    game.ui.height = height - game.ui.height
    bottom.click()
    game.ui.clickY = clickY
  end
  game.ui.height = height
end

function game.ui.splitVertical(weight, top, bottom)
  return game.ui.pane({
    draw=function()
      drawVerticalSplit(weight, top, bottom)
    end,
    click=function()
      clickVerticalSplit(weight, top, bottom)
    end
  })
end

function game.ui.split(weight, a, b)
  return game.ui.pane({
    draw=function()
      if game.ui.height > game.ui.width then
        drawVerticalSplit(weight, a, b)
      else
        drawHorizontalSplit(weight, a, b)
      end
    end,
    click=function()
      if game.ui.height > game.ui.width then
        clickVerticalSplit(weight, a, b)
      else
        clickHorizontalSplit(weight, a, b)
      end
    end
  })
end

function game.ui.margin(px, pane)
  return game.ui.pane({
    draw=function()
      game.ui.width = game.ui.width - px * 2
      game.ui.height = game.ui.height - px * 2
      love.graphics.push()
      love.graphics.translate(px, px)
      pane.draw()
      love.graphics.pop()
      game.ui.width = game.ui.width + px * 2
      game.ui.height = game.ui.height + px * 2
    end,
    click=function()
      game.ui.width = game.ui.width - px * 2
      game.ui.height = game.ui.height - px * 2
      game.ui.clickX = game.ui.clickX - px
      game.ui.clickY = game.ui.clickY - px
      if game.ui.clickX > 0 and game.ui.clickX <= game.ui.width and game.ui.clickY > 0 and game.ui.clickY < game.ui.height then
        pane.click()
      end
      game.ui.clickX = game.ui.clickX + px
      game.ui.clickY = game.ui.clickY + px
      game.ui.width = game.ui.width + px * 2
      game.ui.height = game.ui.height + px * 2
    end
  })
end

function game.ui.overlay(a, b)
  return game.ui.pane({
    draw=function()
      love.graphics.push()
      a.draw()
      love.graphics.pop()
      love.graphics.push()
      b.draw()
      love.graphics.pop()
    end,
    click=function()
      a.click()
      b.click()
    end
  })
end

local function tileRowsAndCols(n)
  local width = game.ui.width
  local height = game.ui.height
  local rows = 1
  local cols = 1
  while rows * cols < n do
    if width / cols > height / rows then
      cols = cols + 1
    else
      rows = rows + 1
    end
  end
  rows = math.ceil(n / cols)
  cols = math.ceil(n / rows)
  return {rows, cols}
end

function game.ui.tile(...)
  local panes = {...}
  return {
    draw=function()
      local rows, cols = unpack(tileRowsAndCols(#panes))
      local width = game.ui.width
      local height = game.ui.height
      game.ui.width = game.ui.width / cols
      game.ui.height = game.ui.height / rows
      for i,pane in ipairs(panes) do
        love.graphics.push()
        love.graphics.translate(
          game.ui.width * ((i - 1) % cols),
          game.ui.height * math.floor((i - 1) / cols)
        )
        pane.draw()
        love.graphics.pop()
      end
      game.ui.width = width
      game.ui.height = height
    end,
    click=function()
      local rows, cols = unpack(tileRowsAndCols(#panes))
      local width = game.ui.width
      local height = game.ui.height
      game.ui.width = game.ui.width / cols
      game.ui.height = game.ui.height / rows
      local clickX = game.ui.clickX
      local clickY = game.ui.clickY
      for i,pane in ipairs(panes) do
        game.ui.clickX = clickX - game.ui.width * ((i - 1) % cols)
        game.ui.clickY = clickY - game.ui.height * math.floor((i - 1) / cols)
        if game.ui.clickX >= 0 and game.ui.clickX < game.ui.width and game.ui.clickY >= 0 and game.ui.clickY < game.ui.height then
          pane.click()
        end
      end
      game.ui.clickX = clickX
      game.ui.clickY = clickY
      game.ui.width = width
      game.ui.height = height
    end
  }
end
