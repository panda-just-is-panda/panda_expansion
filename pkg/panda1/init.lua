local extension = Package:new("panda1")
extension.extensionName = "panda"

extension:loadSkillSkelsByPath("./packages/panda/pkg/panda1/skills")

Fk:loadTranslationTable{
  ["panda1"] = "方块胖"
}

local zoglin = General:new(extension, "pang_zoglin", "shu", 6, 6, General.Male)
zoglin:addSkill("pang_kuangluan")
zoglin:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang_zoglin"] = "僵尸疣猪兽",
["#pang_zoglin"] = "污染疯躯",
["designer:pang_zoglin"] = "胖即是胖",
["cv:pang_zoglin"] = "我的世界",
["illustrator:pang_zoglin"] = "我的世界",
}

local drowned = General:new(extension, "pang_drowned", "wu", 4, 4, General.Male)
drowned:addSkill("pang_chaoyong")
drowned:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang_drowned"] = "溺尸",
["#pang_drowned"] = "残尸剩水",
["designer:pang_drowned"] = "胖即是胖",
["cv:pang_drowned"] = "我的世界",
["illustrator:pang_drowned"] = "我的世界",
}

local husk = General:new(extension, "pang_husk", "wu", 4, 4, General.Male)
husk:addSkill("pang_jigao")
husk:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang_husk"] = "尸壳",
["#pang_husk"] = "餧饿干躯",
["designer:pang_husk"] = "胖即是胖",
["cv:pang_husk"] = "我的世界",
["illustrator:pang_husk"] = "我的世界",
}

local zombie = General:new(extension, "pang_zombie", "wu", 3, 3, General.Male)
zombie:addSkill("pang_shifu")
zombie:addSkill("pang_shichao")
zombie:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang_zombie"] = "僵尸",
["#pang_zombie"] = "行尸走肉",
["designer:pang_zombie"] = "胖即是胖",
["cv:pang_zombie"] = "我的世界",
["illustrator:pang_zombie"] = "我的世界",
}

local stray = General:new(extension, "pang_stray", "wu", 3, 3, General.Male)
stray:addSkill("pang_binshi")
stray:addSkill("pang_hanliu")
stray:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang_stray"] = "流髑",
["#pang_stray"] = "彻骨之寒",
["designer:pang_stray"] = "胖即是胖",
["cv:pang_stray"] = "我的世界",
["illustrator:pang_stray"] = "我的世界",
}

local skeleton = General:new(extension, "pang_skeleton", "wu", 3, 3, General.Male)
skeleton:addSkill("pang_guju")
skeleton:addSkill("pang_haibi")
skeleton:addSkill("pang_wangling")
Fk:loadTranslationTable{
["pang_skeleton"] = "骷髅",
["#pang_skeleton"] = "白骨狰狰",
["designer:pang_skeleton"] = "胖即是胖",
["cv:pang_skeleton"] = "我的世界",
["illustrator:pang_skeleton"] = "我的世界",
}


return extension