game = {}

require("debugtools")
require("event")
require("camera")
require("track")
require("cars")
require("race")
require("trackeditor")
require("mainmenu")

function main()
  game.mainMenu.run()
  love.event.quit()
end

game.event.fork(main)
