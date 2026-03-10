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

local weihuacun = General:new(extension, "pang__weihuacun", "jin", 3, 3, General.Female)
weihuacun:addSkill("pang__lianxiu")
weihuacun:addSkill("pang__jiangdao")
weihuacun.endnote = "“魏华存，你到底干了什么？没有张让赵忠大人，我们如何抗衡萌包？”张修跺脚，瞪着魏华存。" ..
                    "<br>魏华存淡笑一声：“很简单，我成尊不就是了？”" ..
                    "<br>说完，她的气息终于不再掩饰，显露出九转修为！" ..
                    "<br>早岁己知扶摇艰，仍许茶水荡云间。" ..
                    "<br>一路过牌身如絮，命海沉浮客独行。" ..
                    "<br>千磨万击心铸铁，殚精竭虑铸阴间。" ..
                    "<br>今朝剑指疊云处，炼修炼人还炼天!"
Fk:loadTranslationTable{
["pang__weihuacun"] = "魏华存一号",
["#pang__weihuacun"] = "紫虚胖胖",
["designer:pang__weihuacun"] = "胖即是胖",
["cv:pang__weihuacun"] = "茶社",
["illustrator:pang__weihuacun"] = "豆包&木美人",

["~pang__weihuacun"] = "早知造化钟难逆，当初该留引路灯...",
}

local zhijianyuan = General:new(extension, "pang__zhijianyuan", "qun", 6, 6, General.Male)
zhijianyuan:addSkill("pang_renji")
zhijianyuan.endnote = "用于在单机环境下测试新将强度的（会还手的）沙包。" ..
"<br>推荐在游戏模式选择身份模式并将游戏人数调整为2人，再通过谋徐盛将此武将变出来；更多人数的模式人机依然不会用它的技能。"
Fk:loadTranslationTable{
["pang__zhijianyuan"] = "质检员",
["#pang__zhijianyuan"] = "打不过人机，你自裁罢",
["designer:pang__zhijianyuan"] = "胖即是胖",
["cv:pang__zhijianyuan"] = "官方",
["illustrator:pang__zhijianyuan"] = "豆包",

}

local super_zhijianyuan = General:new(extension, "pang__super_zhijianyuan", "qun", 20, 20, General.Male)
super_zhijianyuan:addSkill("pang_super_renji")
super_zhijianyuan.endnote = "用于在单机环境下测试新将强度的（会还手的）沙包。" ..
"<br>推荐在游戏模式选择身份模式并将游戏人数调整为2人，再通过谋徐盛将此武将变出来；更多人数的模式人机依然不会用它的技能。"
Fk:loadTranslationTable{
["pang__super_zhijianyuan"] = "超级质检员",
["#pang__super_zhijianyuan"] = "仙界守门员",
["designer:pang__super_zhijianyuan"] = "胖即是胖",
["cv:pang__super_zhijianyuan"] = "官方",
["illustrator:pang__super_zhijianyuan"] = "豆包",

}

local pang = General:new(extension, "pang__pangpanda", "god", 4, 4, General.Female)
pang.endnote = "这是一只胖。"
Fk:loadTranslationTable{
["pang__pangpanda"] = "胖胖",
["#pang__pangpanda"] = "胖即是胖",
["designer:pang__pangpanda"] = "胖即是胖",
["cv:pang__pangpanda"] = "和花",
["illustrator:pang__pangpanda"] = "和花",

["~pang__pangpanda"] = "胖悲",
}
pang.hidden = true



return extension