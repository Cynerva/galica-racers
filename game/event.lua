game.event = {}

local function runCoroutine(co, ...)
  local success,errorMessage = coroutine.resume(co, ...)
  if not success then
    error(errorMessage)
  end
end

function game.event.fork(f)
  local co = coroutine.create(f)
  runCoroutine(co)
end

local function clear(event)
  event.waiters = {}
end

local function wait(event)
  table.insert(event.waiters, coroutine.running())
  return coroutine.yield()
end

local function send(event, ...)
  local waiters = event.waiters
  event:clear()
  for i,co in ipairs(waiters) do
    runCoroutine(co, ...)
  end
end

function game.event.new()
  local event = {}
  event.waiters = {}
  event.clear = clear
  event.wait = wait
  event.send = send
  return event
end
