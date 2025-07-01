local prefix = "packages.panda.pkg."
local panda1 = require (prefix.."panda1")
local panda2 = require (prefix.."panda2")

Fk:loadTranslationTable{
  ["panda"] = "胖胖身份",
}

return{
   panda1,
   panda2
}
