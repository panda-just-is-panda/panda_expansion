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

local artanis = General:new(extension, "pang__artanis", "wei", 4)
artanis:addSkill("pang_jijiebudui")
artanis:addSkill("pang_zhandourongyao")
artanis:addRelatedSkill("pang_jiang")
Fk:loadTranslationTable{
["pang__artanis"] = "阿塔尼斯",
["#pang__artanis"] = "大主教",
["designer:pang__artanis"] = "胖即是胖",
["cv:pang__artanis"] = "星际争霸2",
["illustrator:pang__artanis"] = "星际争霸2",
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

local xugouji = General:new(extension, "pang__xugouji", "qun", 4, 4, General.Female)
xugouji:addSkill("pang_cuiyu")
xugouji:addSkill("pang_biyi")
xugouji.endnote = "仪式队拐力低，电能队才是数值怪"
Fk:loadTranslationTable{
["pang__xugouji"] = "虚构集",
["#pang__xugouji"] = "往日的幽灵",
["designer:pang__xugouji"] = "胖即是胖",
["cv:pang__xugouji"] = "深蓝",
["illustrator:pang__xugouji"] = "深蓝",
}

local luxi = General:new(extension, "pang__luxi", "god", 4, 4, General.Female)
luxi:addSkill("pang_diedai")
luxi:addRelatedSkill("pang_zhisu")
luxi:addRelatedSkill("pang_hedao")
luxi:addRelatedSkill("pang_jiejin")
luxi:addRelatedSkill("pang_shenghua")
luxi.endnote = "电能队要暖机，烧血队才是数值怪"
Fk:loadTranslationTable{
["pang__luxi"] = "露西",
["#pang__luxi"] = "金属的智识",
["designer:pang__luxi"] = "胖即是胖",
["cv:pang__luxi"] = "深蓝",
["illustrator:pang__luxi"] = "深蓝",
}

local nuodika = General:new(extension, "pang__nuodika", "jin", 4, 4, General.Female)
nuodika:addSkill("pang_zhiguang")
nuodika:addSkill("pang_shengji")
nuodika.endnote = "烧血队梅子煲，启示队才是数值怪"
Fk:loadTranslationTable{
["pang__nuodika"] = "诺谛卡",
["#pang__nuodika"] = "地母的荧芒",
["designer:pang__nuodika"] = "胖即是胖",
["cv:pang__nuodika"] = "深蓝",
["illustrator:pang__nuodika"] = "深蓝",
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