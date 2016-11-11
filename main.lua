game = {}

require("debugtools")
require("event")
require("ui")
require("camera")
require("terrain")
require("props")
require("track")
require("waypoints")
require("cars")
require("race")
require("terraineditor")
require("propeditor")
require("waypointeditor")
require("spawneditor")
require("trackeditor")
require("mainmenu")

function main()
  game.mainMenu.run()
  love.event.quit()
end

game.event.fork(main)
