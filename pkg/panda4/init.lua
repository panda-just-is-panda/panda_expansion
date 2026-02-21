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

local menghuo = General:new(extension, "pang__menghuo", "shu", 4, 4, General.Male)
menghuo:addSkill("pang_zaiqi")
menghuo:addSkill("pang_huoshou")
Fk:loadTranslationTable{
["pang__menghuo"] = "孟获",
["#pang__menghuo"] = "胖蛮王",
["designer:pang__menghuo"] = "胖即是胖",
["cv:pang__menghuo"] = "官方",
["illustrator:pang__menghuo"] = "官方",

["~pang__menghuo"] = "七纵之恩，来世再报了……",
}

local yuanshao = General:new(extension, "pang__yuanshao", "qun", 4, 4, General.Male)
yuanshao:addSkill("pang_luanji")
yuanshao:addSkill("pang_xueyi")
Fk:loadTranslationTable{
["pang__yuanshao"] = "袁绍",
["#pang__yuanshao"] = "胖胖的名门",
["designer:pang__yuanshao"] = "胖即是胖",
["cv:pang__yuanshao"] = "官方",
["illustrator:pang__yuanshao"] = "官方",

["~pang__yuanshao"] = "老天不助我袁家啊！",
}

local liubei = General:new(extension, "pang__liubei", "shu", 4, 4, General.Male)
liubei:addSkill("pang_rende")
liubei:addSkill("pang_zhangwu")
Fk:loadTranslationTable{
["pang__liubei"] = "刘备",
["#pang__liubei"] = "胖才盖世",
["designer:pang__liubei"] = "胖即是胖",
["cv:pang__liubei"] = "官方",
["illustrator:pang__liubei"] = "官方",

["~pang__liubei"] = "汉室之兴，皆仰望丞相了……",
}

local sunliang = General:new(extension, "pang__sunliang", "wu", 3, 3, General.Male)
sunliang:addSkill("pang_kuizhu")
sunliang:addSkill("pang_chezheng")
sunliang:addSkill("pang_lijun")
Fk:loadTranslationTable{
["pang__sunliang"] = "孙亮",
["#pang__sunliang"] = "胖江枯木",
["designer:pang__sunliang"] = "胖即是胖",
["cv:pang__sunliang"] = "官方",
["illustrator:pang__sunliang"] = "官方",

["~pang_sunliang"] = "今日欲诛逆臣而不得，方知机事不密则害成......",
}

local liuyan = General:new(extension, "pang__liuyan", "qun", 3, 3, General.Male)
liuyan:addSkill("pang_limu")
liuyan:addSkill("pang_tushe")
liuyan:addSkill("pang_tongjue")
Fk:loadTranslationTable{
["pang__liuyan"] = "刘焉",
["#pang__liuyan"] = "裂土之胖",
["designer:pang__liuyan"] = "胖即是胖",
["cv:pang__liuyan"] = "官方",
["illustrator:pang__liuyan"] = "官方",

["~pang__liuyan"] = "季玉，望你能守好这益州疆土……",
}

local liuzhang = General:new(extension, "pang__liuzhang", "qun", 3, 3, General.Male)
liuzhang:addSkill("pang_jutu")
liuzhang:addSkill("pang_yaohu")
liuzhang:addSkill("pang_huaibi")
Fk:loadTranslationTable{
["pang__liuzhang"] = "刘璋",
["#pang__liuzhang"] = "半胖黯暗",
["designer:pang__liuzhang"] = "胖即是胖",
["cv:pang__liuzhang"] = "官方",
["illustrator:pang__liuzhang"] = "官方",

["~pang__liuzhang"] = "引狼入室，噬脐莫及啊！",
}

local sunziliufang = General:new(extension, "pang__sunziliufang", "wei", 3, 3, General.Male)
sunziliufang:addSkill("pang_zhangshe")
sunziliufang:addSkill("pang_jimi")
Fk:loadTranslationTable{
["pang__sunziliufang"] = "孙资刘放",
["#pang__sunziliufang"] = "服谗搜慝",
["designer:pang__sunziliufang"] = "胖即是胖",
["cv:pang__sunziliufang"] = "官方",
["illustrator:pang__sunziliufang"] = "官方",

["~pang__sunziliufang"] = "唉，树倒猢狲散，鼓破众人捶呀。",
}

local lejiu = General:new(extension, "hua_lejiu", "qun", 4, 4, General.Male)
lejiu:addSkill("hua_cuijin")
Fk:loadTranslationTable{
["hua_lejiu"] = "乐就",
["#hua_lejiu"] = "仲家军督",
["designer:hua_lejiu"] = "花姸",
["cv:hua_lejiu"] = "官方",
["illustrator:hua_lejiu"] = "官方",
}

local jiangwei = General:new(extension, "mo_jiangwei", "shu", 4, 4, General.Male)
jiangwei:addSkill("mo_zhuri")
jiangwei:addSkill("mo_ranji")
Fk:loadTranslationTable{
["mo_jiangwei"] = "姜维",
["#mo_jiangwei"] = "尽途天涯",
["designer:mo_jiangwei"] = "墨客",
["cv:mo_jiangwei"] = "官方",
["illustrator:mo_jiangwei"] = "官方",

["~mo_jiangwei"] = "姜维姜维，又将何为？",
}

local caocao = General:new(extension, "mo_caocao", "wei", 4, 4, General.Male)
caocao:addSkill("mo_jianxiong")
caocao:addSkill("mo_hujia")
Fk:loadTranslationTable{
["mo_caocao"] = "曹操",
["#mo_caocao"] = "魏武帝",
["designer:mo_caocao"] = "墨客",
["cv:mo_caocao"] = "官方",
["illustrator:mo_caocao"] = "官方",

}

local gaoyang = General:new(extension, "bai_gaoyang", "qun", 4, 4, General.Male)
gaoyang:addSkill("bai_zhanma")
gaoyang:addSkill("bai_nihun")
gaoyang.endnote = "这给我干哪来了，这还是三国吗？<br>\
本来是齐的，但是废物胖不会引用非三国的势力图标，所以跑到三国来了。"
Fk:loadTranslationTable{
["bai_gaoyang"] = "高洋",
["#bai_gaoyang"] = "英雄天子",
["designer:bai_gaoyang"] = "白小贝",
["cv:bai_gaoyang"] = "官方",
["illustrator:bai_gaoyang"] = "帝成2",

}

local zaodirenjun = General:new(extension, "feng_zaodirenjun", "wei", 4, 4, General.Male)
zaodirenjun:addSkill("feng_muken")
Fk:loadTranslationTable{
["feng_zaodirenjun"] = "枣祗任峻",
["#feng_zaodirenjun"] = "屯田供辎",
["designer:feng_zaodirenjun"] = "凤栖梧桐",
["cv:feng_zaodirenjun"] = "官方",
["illustrator:feng_zaodirenjun"] = "DH",

}

local dengzhi = General:new(extension, "sheng_dengzhi", "shu", 3, 3, General.Male)
dengzhi:addSkill("sheng_shuaiyan")
dengzhi:addSkill("sheng_jimeng")
Fk:loadTranslationTable{
["sheng_dengzhi"] = "邓芝",
["#sheng_dengzhi"] = "坚贞简亮",
["designer:sheng_dengzhi"] = "新自由圣安",
["cv:sheng_dengzhi"] = "官方",
["illustrator:sheng_dengzhi"] = "monkey",

}

local zhuran = General:new(extension, "ying_zhuran", "wu", 4, 4, General.Male)
zhuran:addSkill("ying_danding")
zhuran:addSkill("ying_gucheng")
Fk:loadTranslationTable{
["ying_zhuran"] = "朱然",
["#ying_zhuran"] = "不动之督",
["designer:ying_zhuran"] = "英历",
["cv:ying_zhuran"] = "官方",
["illustrator:ying_zhuran"] = "Ccat",

}

local sunquan = General:new(extension, "mo_sunquan", "wu", 4, 4, General.Male)
sunquan:addSkill("mo_chengheng")
sunquan:addSkill("mo_pingshi")
Fk:loadTranslationTable{
["mo_sunquan"] = "孙权",
["#mo_sunquan"] = "东吴大帝",
["designer:mo_sunquan"] = "墨客",
["cv:mo_sunquan"] = "官方",
["illustrator:mo_sunquan"] = "官方",

}

local luxun = General:new(extension, "ye_luxun", "wu", 3, 3, General.Male)
luxun:addSkill("ye_lianying")
luxun:addSkill("ye_qianxun")
Fk:loadTranslationTable{
["ye_luxun"] = "陆逊",
["#ye_luxun"] = "释武怀儒",
["designer:ye_luxun"] = "夜已央",
["cv:ye_luxun"] = "官方",
["illustrator:ye_luxun"] = "官方",

["~ye_luxun"] = "此生清白，不为浊泥所染。",
}

local shamoke = General:new(extension, "yu_shamoke", "shu", 4, 4, General.Male)
shamoke:addSkill("yu_jili")
Fk:loadTranslationTable{
["yu_shamoke"] = "沙摩柯",
["#yu_shamoke"] = "五溪蛮夷",
["designer:yu_shamoke"] = "雨幕江南",
["cv:yu_shamoke"] = "官方",
["illustrator:yu_shamoke"] = "官方",

["~yu_shamoke"] = "五溪蛮夷，不可能输！",
}


local xuchu = General:new(extension, "mo_xuchu", "wei", 4, 4, General.Male)
xuchu:addSkill("mo_luoyi")
xuchu:addSkill("mo_xiachan")
Fk:loadTranslationTable{
["mo_xuchu"] = "许褚",
["#mo_xuchu"] = "力擒双虎",
["designer:mo_xuchu"] = "墨客",
["cv:mo_xuchu"] = "官方",
["illustrator:mo_xuchu"] = "官方",

["~mo_xuchu"] = "丞相，末将尽力了…",
}




return extension