local extension = Package:new("panda3")
extension.extensionName = "panda"

extension:loadSkillSkelsByPath("./packages/panda/pkg/panda2/skills")

Fk:loadTranslationTable{
  ["panda3"] = "历史胖",
  ["pang"] = "胖"
}

local huzhi = General:new(extension, "pang__huzhi", "wei", 3, 3, General.Male)
huzhi:addSkill("pang_qietian")
huzhi:addSkill("pang_qieshou")
Fk:loadTranslationTable{
["pang__huzhi"] = "胡质",
["#pang__huzhi"] = "素业贞粹",
["designer:pang__huzhi"] = "胖即是胖",
["cv:pang__huzhi"] = "无",
["illustrator:pang__huzhi"] = "",
}
huzhi.hidden = true

return extension