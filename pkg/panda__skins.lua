local extension = Package:new("panda__skins", Package.SkinPack)
extension.extensionName = "panda__skins"

extension:addSkinPackage {
  path = "packages/panda/image/generals",
  content = {
  {
  skins={"pang__pangpanda.jpg"}, 
  enable_generals = {"pang__panda"},
  }
}
}

return extension