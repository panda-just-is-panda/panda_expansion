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
wither:addRelatedSkill("guan_fushi")
wither:addRelatedSkill("guan_dongdao")
wither:addRelatedSkill("guan_zhanjue")
wither:addRelatedSkill("guan_lieqiong")
wither:addRelatedSkill("mobile__hanzhan")
wither:addRelatedSkill("mobile__zhenfeng")
wither:addRelatedSkill("zhanlie")
wither.endnote = "“势太史慈是来干嘛的？”<br>\
“别尬黑，没有人家手杀的持恒技，你们如何对抗神皇甫嵩大人？”"
Fk:loadTranslationTable{
["pang__wither"] = "凋灵",
["#pang__wither"] = "三仙合体",
["designer:pang__wither"] = "胖即是胖",
["cv:pang__wither"] = "官方",
["illustrator:pang__wither"] = "我的世界&官方",
}

local xiahoudun = General:new(extension, "pang__xiahoudun", "wei", 4, 4, General.Male)
xiahoudun:addSkill("pang_ganglie")
xiahoudun:addSkill("pang_duntu")
xiahoudun.endnote = "有的武将的台词是可怜兮兮的“向隅而泣，困于隅角。”，效果为每轮摸80张牌；<br>\
有的武将的台词是狠辣的“鼠辈，尽敢伤我？”，效果为亮出牌堆顶一张红桃然后无事发生。"
Fk:loadTranslationTable{
["pang__xiahoudun"] = "夏侯惇",
["#pang__xiahoudun"] = "红桃蹲",
["designer:pang__xiahoudun"] = "胖即是胖",
["cv:pang__xiahoudun"] = "官方",
["illustrator:pang__xiahoudun"] = "官方",
}

local exxiahoudun = General:new(extension, "pang__exxiahoudun", "wei", 4, 4, General.Male)
exxiahoudun:addSkill("pang_ganglieex")
exxiahoudun:addSkill("pang_dunnu")
exxiahoudun.endnote = "我不能受二三屈辱！"
Fk:loadTranslationTable{
["pang__exxiahoudun"] = "界夏侯惇",
["#pang__exxiahoudun"] = "惇怒！",
["designer:pang__exxiahoudun"] = "胖即是胖",
["cv:pang__exxiahoudun"] = "官方",
["illustrator:pang__exxiahoudun"] = "官方",
}
exxiahoudun.hidden = true

return extension