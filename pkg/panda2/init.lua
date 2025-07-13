local extension = Package:new("panda2")
extension.extensionName = "panda"

extension:loadSkillSkelsByPath("./packages/panda/pkg/panda2/skills")

Fk:loadTranslationTable{
  ["panda2"] = "游戏胖",
  ["pang"] = "胖"
}

local ouliege = General:new(extension, "pang__ouliege", "shu", 4)
ouliege:addSkill("pang_binghai")
ouliege:addSkill("pang_tanta")
Fk:loadTranslationTable{
["pang__ouliege"] = "欧列格",
["#pang__ouliege"] = "红军突进",
["designer:pang__ouliege"] = "胖即是胖",
["cv:pang__ouliege"] = "红色警戒3",
["illustrator:pang__ouliege"] = "红色警戒3",
}

local meilanni = General:new(extension, "pang__meilanni", "shu", 4, 4, General.Female)
meilanni:addSkill("pang_qiaoshou")
meilanni:addSkill("pang_chengxi")
Fk:loadTranslationTable{
["pang__meilanni"] = "梅兰妮",
["#pang__meilanni"] = "狡猾的绒兽",
["designer:pang__meilanni"] = "胖即是胖",
["cv:pang__meilanni"] = "深蓝",
["illustrator:pang__meilanni"] = "深蓝",
}

local quniang = General:new(extension, "pang__quniang", "qun", 3, 3, General.Female)
quniang:addSkill("pang_cunxiang")
quniang:addSkill("pang_jinxing")
Fk:loadTranslationTable{
["pang__quniang"] = "曲娘",
["#pang__quniang"] = "石子的顽然",
["designer:pang__quniang"] = "胖即是胖",
["cv:pang__quniang"] = "深蓝",
["illustrator:pang__quniang"] = "深蓝",
}

return extension