game = {}

require("debugtools")
require("event")
require("camera")
require("track")
require("car")
require("waypoint")
require("race")
require("mainmenu")

function main()
  game.mainMenu.run()
  love.event.quit()
end

game.event.fork(main)
