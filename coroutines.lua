game.coroutine = {}

game.coroutine.new = coroutine.create
game.coroutine.yield = coroutine.yield

function game.coroutine.run(co)
  game.coroutine.current = co
  coroutine.resume(co)
end
