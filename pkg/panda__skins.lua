local extension = Package:new("panda__skins", Package.SkinPack)
extension.extensionName = "panda__skins"

local content1 = {
  {
  skins={"pang__classicpanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  }
}
extension:addSkinPackage {
  path = ".image.skins",
  content = content1
}
Fk:loadTranslationTable{
  ["pang__classicpanda"] = "经典胖胖",
}

return extension