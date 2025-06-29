local extension = Package:new("panda1")
extension.extensionName = "panda"

extension:loadSkillSkelsByPath("./packages/panda/pkg/panda1/skills")

Fk:loadTranslationTable{
  ["panda1"] = "胖"
}

local zhouyu = General:new(extension, "pang_zhouyu", "wu", 3)
zhouyu:addSkill("pang_yingzi")
zhouyu:addSkill("pang_fanjian")
Fk:loadTranslationTable{
["pang_zhouyu"] = "周瑜",
["#pang_zhouyu"] = "大都督",
["designer:pang_zhouyu"] = "胖即是胖",
["cv:pang_zhouyu"] = "官方",
["illustrator:pang_zhouyu"] = "官方",
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

return extension