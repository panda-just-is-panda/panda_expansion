local extension = Package:new("panda4")
extension.extensionName = "panda"

extension:loadSkillSkelsByPath("./packages/panda/pkg/panda4/skills")

Fk:loadTranslationTable{
  ["panda4"] = "三国胖",
  ["pang"] = "胖"
}


return extension