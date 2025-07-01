local extension = Package:new("panda2")
extension.extensionName = "panda"

extension:loadSkillSkelsByPath("./packages/panda/pkg/panda2/skills")

Fk:loadTranslationTable{
  ["panda2"] = "游戏胖"
}

local ouliege = General:new(extension, "pang_ouliege", "shu", 4)
ouliege:addSkill("pang_binghai")
ouliege:addSkill("pang_tanta")
Fk:loadTranslationTable{
["pang_ouliege"] = "欧列格",
["#pang_ouliege"] = "红军突进",
["designer:pang_ouliege"] = "胖即是胖",
["cv:pang_ouliege"] = "红色警戒3",
["illustrator:pang_ouliege"] = "红色警戒3",
}

local meilanni = General:new(extension, "pang_meilanni", "shu", 4, 4, General.Female)
meilanni:addSkill("pang_qiaoshou")
meilanni:addSkill("pang_chengxi")
Fk:loadTranslationTable{
["pang_meilanni"] = "梅兰妮",
["#pang_meilanni"] = "狡猾的绒兽",
["designer:pang_meilanni"] = "胖即是胖",
["cv:pang_meilanni"] = "无",
["illustrator:pang_meilanni"] = "深蓝",
}