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

["~pang__ouliege"] = "I guess that's it.",
}

local moskvin = General:new(extension, "pang__moskvin", "shu", 4)
moskvin:addSkill("pang_ciyong")
Fk:loadTranslationTable{
["pang__moskvin"] = "摩斯克芬",
["#pang__moskvin"] = "震波专家",
["designer:pang__moskvin"] = "胖即是胖",
["cv:pang__moskvin"] = "红色警戒3",
["illustrator:pang__moskvin"] = "红色警戒3",

["~pang__moskvin"] = "Yes sir. But one day, I will be giving orders.",
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

["~pang__artanis"] = "战局对我们的战士太不利了。",
}

local mengsk = General:new(extension, "pang__mengsk", "shu", 4)
mengsk:addSkill("pang_tiewantongzhi")
mengsk:addSkill("pang_zhaozhaotailun")
mengsk.endnote = "“你们这群家伙别老是把声优和角色关联到一起啊！”"
Fk:loadTranslationTable{
["pang__mengsk"] = "蒙斯克",
["#pang__mengsk"] = "泰伦帝皇",
["designer:pang__mengsk"] = "胖即是胖",
["cv:pang__mengsk"] = "星际争霸2",
["illustrator:pang__mengsk"] = "星际争霸2",

["~pang__mengsk"] = "我们的人正在成群的倒下。我必须回撤休整。",
}

local beastfly = General:new(extension, "pang__savage_beastfly", "qun", 6)
beastfly:addSkill("pang_cannu")
beastfly:addSkill("pang_yingbao")
beastfly.endnote = "吓哭了，残暴兽蝇大人。"
Fk:loadTranslationTable{
["pang__savage_beastfly"] = "残暴的兽蝇",
["#pang__savage_beastfly"] = "丝之歌啊能不能放过我这一次",
["designer:pang__savage_beastfly"] = "胖即是胖",
["cv:pang__savage_beastfly"] = "空洞骑士：丝之歌",
["illustrator:pang__savage_beastfly"] = "空洞骑士：丝之歌",

["~pang__savage_beastfly"] = "",
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

["~pang__meilanni"] = "The plan failed……",
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

["~pang__quniang"] = "It's wrong!",
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

["~pang__bolinyidong"] = "Retreat! What? I can't make the call?",
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

["~pang__luxi"] = "Shell, damaged.",
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

["~pang__barcarola"] = "This is a breach of “Free breeze” passenger etiquette!",
}

local guirenzhengxie = General:new(extension, "pang__guirenzhengxie", "qun", 4, 4, General.Female)
guirenzhengxie:addSkill("pang_aoni")
guirenzhengxie:addRelatedSkill("pang_kuanggu")
guirenzhengxie:addRelatedSkill("pang_gukuang")
Fk:loadTranslationTable{
["pang__guirenzhengxie"] = "鬼人正邪",
["#pang__guirenzhengxie"] = "悖逆的天邪鬼",
["designer:pang__guirenzhengxie"] = "胖即是胖",
["cv:pang__guirenzhengxie"] = "官方",
["illustrator:pang__guirenzhengxie"] = "东方",
}

local dasitin = General:new(extension, "ying_dasitin", "shu", 4, 4, General.Male)
dasitin:addSkill("ying_jingzhezhi")
dasitin:addSkill("ying_guyusheng")
Fk:loadTranslationTable{
["ying_dasitin"] = "达斯廷",
["#ying_dasitin"] = "引领者",
["designer:ying_dasitin"] = "英历",
["cv:ying_dasitin"] = "雷索纳斯",
["illustrator:ying_dasitin"] = "雷索纳斯",

["~ying_dasitin"] = "你们快逃，我还能阻挡他们一会儿……",
}


return extension