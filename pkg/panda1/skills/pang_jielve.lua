local beilve = fk.CreateSkill({
  name = "pang_beilve", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

beilve:addEffect(fk.EventPhaseStart, { --

})


Fk:loadTranslationTable {["pang_beilve"] = "备掠",
[":pang_beilve"] = "准备阶段，你可以将手牌数摸至四张；若你未因此摸牌，你可以获得1点护甲；若你有护甲，你可以改为令另一名角色将手牌数摸至四张。",
["#k"] = "你需使用一张【杀】，否则失去1点体力",
}
return jielve  --不要忘记返回做好的技能对象哦