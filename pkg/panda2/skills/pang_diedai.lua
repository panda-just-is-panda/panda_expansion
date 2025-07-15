local diedai = fk.CreateSkill {
  name = "pang_diedai",
  tags = {},
}

Fk:loadTranslationTable {["pang_diedai"] = "迭代",
[":pang_diedai"] = "使命技，游戏开始时，你获得“质速”、“荷导”和“阶进”；你造成的伤害均视为雷电伤害；场上所有角色每造成共计5点雷电伤害后，你升级其中一个技能。<br>\
  ⬤　成功：若这些技能均已升级，你造成的伤害+1。<br>\
  ⬤　失败：你受到共计5点伤害后，你减1点体力上限。",
}

return diedai