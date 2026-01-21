local panda1 = require "packages.panda.pkg.panda1"
local panda2 = require "packages.panda.pkg.panda2"
local panda3 = require "packages.panda.pkg.panda3"
local panda4 = require "packages.panda.pkg.panda4"
local panda_skin = require "packages.panda.pkg.panda__skins"

Fk:loadTranslationTable{
  ["panda"] = "胖胖身份",
}

return{
   panda1,
   panda2,
   panda3,
   panda4,
   panda_skin,
}
