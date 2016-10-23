game.event = {}

local function wait(event)
  table.insert(event.waiters, game.coroutine.current)
  game.coroutine.yield()
end

local function trigger(event)
  local waiters = event.waiters
  event.waiters = {}
  for i,co in ipairs(waiters) do
    game.coroutine.run(co)
  end
end

function game.event.new()
  local event = {}
  event.waiters = {}
  event.wait = wait
  event.trigger = trigger
  return event
end
