game.event = {}
game.event.coroutine = nil

local function runCoroutine(co)
  game.event.coroutine = co
  coroutine.resume(co)
end

function game.event.fork(f)
  local co = coroutine.create(f)
  runCoroutine(co)
end

local function wait(event)
  table.insert(event.waiters, game.event.coroutine)
  coroutine.yield()
end

local function trigger(event)
  local waiters = event.waiters
  event.waiters = {}
  for i,co in ipairs(waiters) do
    runCoroutine(co)
  end
end

function game.event.new()
  local event = {}
  event.waiters = {}
  event.wait = wait
  event.trigger = trigger
  return event
end
