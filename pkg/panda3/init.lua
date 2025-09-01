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
dizhu:addRelatedSkill("pang_duizi")
dizhu:addRelatedSkill("pang_feiji")
dizhu:addRelatedSkill("pang_zhadan")
Fk:loadTranslationTable{
["pang__dizhu"] = "地主",
["#pang__dizhu"] = "超级加倍",
["designer:pang__dizhu"] = "胖即是胖",
["cv:pang__dizhu"] = "欢乐斗地主",
["illustrator:pang__dizhu"] = "欢乐斗地主",

["~pang__dizhu"] = "豆子-600",
}

local wild_dog = General:new(extension, "pang__wild_dog", "qun", 4, 4, General.Male)
wild_dog:addSkill("pang_gouyao")
wild_dog:addSkill("pang_gouyun")
wild_dog.endnote = "嘻嘻，被我咬住了吧？"
Fk:loadTranslationTable{
["pang__wild_dog"] = "野狗",
["#pang__wild_dog"] = "路边一条",
["designer:pang__wild_dog"] = "胖即是胖",
["cv:pang__wild_dog"] = "官方",
["illustrator:pang__wild_dog"] = "豆包",

["~pang__wild_dog"] = "虓虎失落尽，日暮无归途。"
}

local wither = General:new(extension, "pang__wither", "god", 4, 4, General.Male)
wither:addSkill("pang_qingshen")
wither:addRelatedSkill("fushi")
wither:addRelatedSkill("guan_lieqiong")
wither:addRelatedSkill("mobile__hanzhan")
wither.endnote = "我东道呢？我战烈和振锋呢？我斩决呢？<br>\
这些技能都给你不如直接判你赢得了。"
Fk:loadTranslationTable{
["pang__wither"] = "凋灵",
["#pang__wither"] = "三仙合体",
["designer:pang__wither"] = "胖即是胖",
["cv:pang__wither"] = "官方",
["illustrator:pang__wither"] = "我的世界&官方",

["~pang__wither"] = "隐藏语音",
}

local luxi = General:new(extension, "pang__laoluxi", "god", 4, 4, General.Female)
luxi:addSkill("pang_diedaier")
luxi:addRelatedSkill("pang_zhisu")
luxi:addRelatedSkill("pang_hedao")
luxi:addRelatedSkill("pang_jiejin")
luxi:addRelatedSkill("pang_shenghua")
luxi.endnote = "每当场上出现能频繁造成雷电伤害的角色时，人们总是会想：“要是牢露在这局里该多好啊！”"
Fk:loadTranslationTable{
["pang__laoluxi"] = "牢露",
["#pang__laoluxi"] = "想你了牢露",
["designer:pang__laoluxi"] = "胖即是胖",
["cv:pang__laoluxi"] = "深蓝",
["illustrator:pang__laoluxi"] = "深蓝",

["~pang__luxi"] = "Shell, damaged.",
}

local pang = General:new(extension, "pang__pangpanda", "god", 4, 4, General.Female)
pang.endnote = "这是一只胖。"
Fk:loadTranslationTable{
["pang__pangpanda"] = "胖胖",
["#pang__pangpanda"] = "胖即是胖",
["designer:pang__pangpanda"] = "胖即是胖",
["cv:pang__pangpanda"] = "和花",
["illustrator:pang__pangpanda"] = "和花",

}
pang.hidden = true



return extension