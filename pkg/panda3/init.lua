local extension = Package:new("panda3")
extension.extensionName = "panda"

extension:loadSkillSkelsByPath("./packages/panda/pkg/panda3/skills")

Fk:loadTranslationTable{
  ["panda3"] = "历史胖",
  ["pang"] = "胖"
}

local huzhi = General:new(extension, "pang__huzhi", "wei", 3, 3, General.Male)
huzhi:addSkill("pang_qietian")
huzhi:addSkill("pang_qieshou")
Fk:loadTranslationTable{
["pang__huzhi"] = "胡质",
["#pang__huzhi"] = "素业贞粹",
["designer:pang__huzhi"] = "胖即是胖",
["cv:pang__huzhi"] = "无",
["illustrator:pang__huzhi"] = "率土之滨",
}

local fuxuan = General:new(extension, "xiaobai_fuxuan", "jin", 3, 3, General.Male)
fuxuan:addSkill("xiaobai_shujian")
fuxuan:addSkill("xiaobai_gangzao")
Fk:loadTranslationTable{
["xiaobai_fuxuan"] = "傅玄",
["#xiaobai_fuxuan"] = "素业贞粹",
["designer:xiaobai_fuxuan"] = "小汤不圆",
["cv:xiaobai_fuxuan"] = "无",
["illustrator:xiaobai_fuxuan"] = "",
}
fuxuan.hidden = true

return extension