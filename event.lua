game.event = {}

local function runCoroutine(co)
  local success,errorMessage = coroutine.resume(co)
  if not success then
    error(errorMessage)
  end
end

function game.event.fork(f)
  local co = coroutine.create(f)
  runCoroutine(co)
end

local function wait(event)
  table.insert(event.waiters, coroutine.running())
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
