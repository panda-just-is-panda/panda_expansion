local extension = Package:new("panda__skins", Package.SkinPack)
extension.extensionName = "panda"

local content1 = {
  {
  skins={"pang__classicpanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__speechlesspanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__flowerpanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__tangpanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
  {
  skins={"pang__moviepanda.jpg"}, 
  enabled_generals = {"pang__panda"},
  },
}
extension:addSkinPackage {
  path = "/image/skins",
  content = content1
}
Fk:loadTranslationTable{
  ["pang__classicpanda"] = "经典胖胖",
  ["pang__speechlesspanda"] = "无语胖胖",
  ["pang__flowerpanda"] = "送花胖胖",
  ["pang__tangpanda"] = "唐胖",
  ["pang__moviepanda"] = "大电影胖胖",
}

return extension