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

["~pang__zoglin"] = "僵尸疣猪兽阵亡",
}

local zombified_piglin = General:new(extension, "pang__zombified_piglin", "shu", 4, 4, General.Male)
zombified_piglin:addSkill("pang_chouqi")
zombified_piglin:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang__zombified_piglin"] = "僵尸猪灵",
["#pang__zombified_piglin"] = "猪志成城",
["designer:pang__zombified_piglin"] = "胖即是胖",
["cv:pang__zombified_piglin"] = "我的世界",
["illustrator:pang__zombified_piglin"] = "我的世界",

["~pang__zombified_piglin"] = "僵尸猪灵阵亡",
}


local drowned = General:new(extension, "pang__drowned", "wei", 4, 4, General.Male)
drowned:addSkill("pang_chaoyong")
drowned:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang__drowned"] = "溺尸",
["#pang__drowned"] = "残尸剩水",
["designer:pang__drowned"] = "胖即是胖",
["cv:pang__drowned"] = "我的世界",
["illustrator:pang__drowned"] = "我的世界",

["~pang__drowned"] = "溺尸阵亡",
}

local re_husk = General:new(extension, "pang__re_husk", "wu", 4, 4, General.Male)
re_husk:addSkill("pang_jigao")
re_husk:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang__re_husk"] = "尸壳",
["#pang__re_husk"] = "餧饿干躯",
["designer:pang__re_husk"] = "胖即是胖",
["cv:pang__re_husk"] = "我的世界",
["illustrator:pang__re_husk"] = "我的世界",

["~pang__re_husk"] = "尸壳阵亡",
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

["~pang__zombie"] = "僵尸阵亡",
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

["~pang__stray"] = "流髑阵亡",
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

["~pang__skeleton"] = "骷髅阵亡",
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

["~pang__evoker"] = "唤魔者阵亡",
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

["~pang__pillager"] = "掠夺者阵亡",
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

["~pang__vindicator"] = "卫道士阵亡",
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

["~pang__ravager"] = "劫掠兽阵亡",
}

local witch = General:new(extension, "pang__witch", "wu", 3, 3, General.Female)
witch:addSkill("pang_moyao")
witch:addSkill("pang_lianniang")
Fk:loadTranslationTable{
["pang__witch"] = "女巫",
["#pang__witch"] = "酝药滋害",
["designer:pang__witch"] = "胖即是胖",
["cv:pang__witch"] = "我的世界",
["illustrator:pang__witch"] = "我的世界",
}

local iron_golem = General:new(extension, "pang__iron_golem", "wu", 8, 8, General.Male)
iron_golem:addSkill("pang_tiewei")
iron_golem:addSkill("pang_gangli")
Fk:loadTranslationTable{
["pang__iron_golem"] = "铁傀儡",
["#pang__iron_golem"] = "钢墙铁壁",
["designer:pang__iron_golem"] = "胖即是胖",
["cv:pang__iron_golem"] = "我的世界",
["illustrator:pang__iron_golem"] = "我的世界",

["~pang__iron_golem"] = "铁傀儡阵亡",
}


local archillager = General:new(extension, "pang__archillager", "wu", 2, 2, General.Male)
archillager.subkingdom = "jin"
archillager.shield = 2
archillager:addSkill("pang_mozong")
archillager:addSkill("pang_yingyu")
archillager:addSkill("pang_introtheme")
Fk:loadTranslationTable{
["pang__archillager"] = "奇厄教主",
["#pang__archillager"] = "影心溺欲",
["designer:pang__archillager"] = "胖即是胖",
["cv:pang__archillager"] = "我的世界",
["illustrator:pang__archillager"] = "我的世界",

["~pang__archillager"] = "奇厄教主被击败",
}

local steve = General:new(extension, "pang__steve", "wu", 4, 4, General.Male)
steve:addSkill("pang_wajue")
steve:addSkill("pang_chuangzao")
Fk:loadTranslationTable{
["pang__steve"] = "史蒂夫",
["#pang__steve"] = "孑然独创",
["designer:pang__steve"] = "胖即是胖",
["cv:pang__steve"] = "我的世界",
["illustrator:pang__steve"] = "我的世界",

["~pang__steve"] = "史蒂夫死亡声",
}

local panda = General:new(extension, "pang__panda", "god", 4, 4, General.Male)
panda:addSkill("pang_taipang")
panda:addSkill("pang_pangnu")
Fk:loadTranslationTable{
["pang__panda"] = "熊猫胖",
["#pang__panda"] = "太胖太胖",
["designer:pang__panda"] = "胖即是胖",
["cv:pang__panda"] = "我的世界",
["illustrator:pang__panda"] = "我的世界",

["~pang__panda"] = "胖悲",
}




return extension