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

local feishi = General:new(extension, "feishi", "shu", 3, 3, General.Male)
feishi:addSkill("bai_cuanhe")
feishi:addSkill("bai_anzuo")
Fk:loadTranslationTable{
["feishi"] = "费诗",
["#feishi"] = "率意而言",
["designer:feishi"] = "食马者",
["illustrator:pang__liushan"] = "NOVART",
}

local jiangwei = General:new(extension, "mo_jiangwei", "shu", 4, 4, General.Male)
jiangwei:addSkill("mo_zhuri")
Fk:loadTranslationTable{
["mo_jiangwei"] = "姜维",
["#mo_jiangwei"] = "尽途天涯",
["designer:mo_jiangwei"] = "墨客",
["cv:mo_jiangwei"] = "官方",
["illustrator:mo_jiangwei"] = "官方",

["~mo_jiangwei"] = "姜维姜维，又将何为？",
}


return extension