game = {}

require("debugtools")
require("event")
require("ui")
require("camera")
require("terrain")
require("track")
require("waypoints")
require("cars")
require("race")
require("terraineditor")
require("waypointeditor")
require("trackeditor")
require("mainmenu")

function main()
  game.mainMenu.run()
  love.event.quit()
end

game.event.fork(main)
