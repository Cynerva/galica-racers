game = {}

require("debugtools")
require("event")
require("car")
require("race")
require("mainmenu")

function main()
  game.mainMenu.run()
  love.event.quit()
end

game.event.fork(main)
