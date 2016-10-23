game = {}

require("coroutines")
require("event")
require("race")
require("mainmenu")

function main()
  game.mainMenu.run()
  love.event.quit()
end

game.coroutine.run(game.coroutine.new(main))
