local extension = Package:new("panda1")
extension.extensionName = "panda"

extension:loadSkillSkelsByPath("./packages/panda/pkg/panda1/skills")

Fk:loadTranslationTable{
  ["panda1"] = "方块胖",
  ["pang"] = "胖",
}

local zoglin = General:new(extension, "pang__zoglin", "shu", 6, 6, General.Male)
zoglin:addSkill("pang_kuangluan")
zoglin:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang__zoglin"] = "僵尸疣猪兽",
["#pang__zoglin"] = "污染疯躯",
["designer:pang__zoglin"] = "胖即是胖",
["cv:pang__zoglin"] = "我的世界",
["illustrator:pang__zoglin"] = "我的世界",
}

local drowned = General:new(extension, "pang__drowned", "wu", 4, 4, General.Male)
drowned:addSkill("pang_chaoyong")
drowned:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang__drowned"] = "溺尸",
["#pang__drowned"] = "残尸剩水",
["designer:pang__drowned"] = "胖即是胖",
["cv:pang__drowned"] = "我的世界",
["illustrator:pang__drowned"] = "我的世界",
}

local husk = General:new(extension, "pang__husk", "wu", 4, 4, General.Male)
husk:addSkill("pang_jigao")
husk:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang__husk"] = "尸壳",
["#pang__husk"] = "餧饿干躯",
["designer:pang__husk"] = "胖即是胖",
["cv:pang__husk"] = "我的世界",
["illustrator:pang__husk"] = "我的世界",
}

local zombie = General:new(extension, "pang__zombie", "wu", 3, 3, General.Male)
zombie:addSkill("pang_shifu")
zombie:addSkill("pang_shichao")
zombie:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang__zombie"] = "僵尸",
["#pang__zombie"] = "行尸走肉",
["designer:pang__zombie"] = "胖即是胖",
["cv:pang__zombie"] = "我的世界",
["illustrator:pang__zombie"] = "我的世界",
}

local stray = General:new(extension, "pang__stray", "wu", 3, 3, General.Male)
stray:addSkill("pang_binshi")
stray:addSkill("pang_hanliu")
stray:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang__stray"] = "流髑",
["#pang__stray"] = "彻骨之寒",
["designer:pang__stray"] = "胖即是胖",
["cv:pang__stray"] = "我的世界",
["illustrator:pang__stray"] = "我的世界",
}

local skeleton = General:new(extension, "pang__skeleton", "wu", 3, 3, General.Male)
skeleton:addSkill("pang_guju")
skeleton:addSkill("pang_haibi")
skeleton:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang__skeleton"] = "骷髅",
["#pang__skeleton"] = "白骨狰狰",
["designer:pang__skeleton"] = "胖即是胖",
["cv:pang__skeleton"] = "我的世界",
["illustrator:pang__skeleton"] = "我的世界",
}

local evoker = General:new(extension, "pang__evoker", "wu", 3, 3, General.Male)
evoker:addSkill("pang_moya")
evoker:addSkill("pang_eying")
Fk:loadTranslationTable{
["pang__evoker"] = "唤魔者",
["#pang__evoker"] = "魔涌忌灵",
["designer:pang__evoker"] = "胖即是胖",
["cv:pang__evoker"] = "我的世界",
["illustrator:pang__evoker"] = "我的世界",
}

local pillager = General:new(extension, "pang__pillager", "wu", 3, 3, General.Male)
pillager:addSkill("pang_beilve")
pillager:addSkill("pang_chuijiao")
Fk:loadTranslationTable{
["pang__pillager"] = "掠夺者",
["#pang__pillager"] = "号鸣角震",
["designer:pang__pillager"] = "胖即是胖",
["cv:pang__pillager"] = "我的世界",
["illustrator:pang__pillager"] = "我的世界",
}

local vindicator = General:new(extension, "pang__vindicator", "wu", 3, 3, General.Male)
vindicator.shield = 1
vindicator:addSkill("pang_huifu")
vindicator:addSkill("pang_weidao")
Fk:loadTranslationTable{
["pang__vindicator"] = "卫道士",
["#pang__vindicator"] = "斧钺正道",
["designer:pang__vindicator"] = "胖即是胖",
["cv:pang__vindicator"] = "我的世界",
["illustrator:pang__vindicator"] = "我的世界",
}

local ravager = General:new(extension, "pang__ravager", "wu", 8, 8, General.Male)
ravager:addSkill("pang_haoshou")
ravager:addSkill("pang_dangli")
Fk:loadTranslationTable{
["pang__ravager"] = "劫掠兽",
["#pang__ravager"] = "千钧之兽",
["designer:pang__ravager"] = "胖即是胖",
["cv:pang__ravager"] = "我的世界",
["illustrator:pang__ravager"] = "我的世界",
}




return extension