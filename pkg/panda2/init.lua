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

local bolinyidong = General:new(extension, "pang__bolinyidong", "wu", 3, 3, General.Female)
bolinyidong:addSkill("pang_niliu")
bolinyidong:addSkill("pang_jianmi")
Fk:loadTranslationTable{
["pang__bolinyidong"] = "柏林以东",
["#pang__bolinyidong"] = "野菊的低语",
["designer:pang__bolinyidong"] = "胖即是胖",
["cv:pang__bolinyidong"] = "深蓝",
["illustrator:pang__bolinyidong"] = "深蓝",
}

local barcarola = General:new(extension, "pang__barcarola", "wei", 3, 3, General.Female)
barcarola:addSkill("pang_yinzhui")
barcarola:addSkill("pang_haishi")
barcarola.endnote = "是的，启示队就是数值怪"
Fk:loadTranslationTable{
["pang__barcarola"] = "芭卡洛儿",
["#pang__barcarola"] = "自由的音符",
["designer:pang__barcarola"] = "胖即是胖",
["cv:pang__barcarola"] = "深蓝",
["illustrator:pang__barcarola"] = "深蓝",
}


return extension