local extension = Package:new("panda4")
extension.extensionName = "panda"

extension:loadSkillSkelsByPath("./packages/panda/pkg/panda4/skills")

Fk:loadTranslationTable{
  ["panda4"] = "三国胖",
  ["pang"] = "胖"
}

local liushan = General:new(extension, "pang__liushan", "shu", 3, 3, General.Male)
liushan:addSkill("pang_xiangle")
liushan:addSkill("pang_fangquan")
liushan:addSkill("pang_xunli")
Fk:loadTranslationTable{
["pang__liushan"] = "刘禅",
["#pang__liushan"] = "胖胖的天命主",
["designer:pang__liushan"] = "胖即是胖",
["cv:pang__liushan"] = "官方",
["illustrator:pang__liushan"] = "官方",

["~pang__liushan"] = "别打脸，我投降还不行吗？",
}

return extension