local extension = Package:new("panda3")
extension.extensionName = "panda"

extension:loadSkillSkelsByPath("./packages/panda/pkg/panda3/skills")

Fk:loadTranslationTable{
  ["panda3"] = "神人胖",
  ["pang"] = "胖"
}

local dizhu = General:new(extension, "pang__dizhu", "qun", 4, 4, General.Male)
dizhu:addSkill("pang_dizhu")
dizhu:addSkill("pang_paixing")
Fk:loadTranslationTable{
["pang__dizhu"] = "地主",
["#pang__dizhu"] = "超级加倍",
["designer:pang__quniang"] = "胖即是胖",
["cv:pang__quniang"] = "欢乐斗地主",
["illustrator:pang__quniang"] = "欢乐斗地主",
}
dizhu.hidden = true

return extension