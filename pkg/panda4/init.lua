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

local lejiu = General:new(extension, "hua_lejiu", "qun", 4, 4, General.Male)
lejiu:addSkill("hua_cuijin")
Fk:loadTranslationTable{
["hua_lejiu"] = "乐就",
["#hua_lejiu"] = "急急国王",
["designer:hua_lejiu"] = "花研",
["cv:hua_lejiu"] = "官方",
["illustrator:hua_lejiu"] = "官方",

["~pang__menghuo"] = "七纵之恩，来世再报了……",
}

local feishi = General:new(extension, "xiaobai_feishi", "shu", 3, 3, General.Male)
feishi:addSkill("bai_cuanhe")
feishi:addSkill("bai_anzuo")
Fk:loadTranslationTable{
["xiaobai_feishi"] = "费诗",
["#xiaobai_feishi"] = "率意而言",
["designer:xiaobai_feishi"] = "食马者",
["illustrator:xiaobai_feishi"] = "NOVART",
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