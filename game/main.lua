game = {}

require("debugtools")
require("event")
require("files")
require("ui")
require("transitions")
require("camera")
require("terrain")
require("props")
require("track")
require("waypoints")
require("cars")
require("pause")
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
