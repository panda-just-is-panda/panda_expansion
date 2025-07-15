local zhisu = fk.CreateSkill {
  name = "pang_zhisu",
  tags = {},
}

Fk:loadTranslationTable {["pang_zhisu"] = "质速",
[":pang_zhisu"] = "锁定技，你每回合首次使用的基本牌造成的伤害+1；<br>\
  若此技能已升级，改为此牌额外结算一次。",
}

return zhisu