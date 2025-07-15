local hedao = fk.CreateSkill {
  name = "pang_hedao",
  tags = {},
}

Fk:loadTranslationTable {["pang_hedao"] = "质速",
[":pang_hedao"] = "锁定技，你每回合首次使用普通锦囊牌时摸一张牌；<br>\
  若此技能已升级，改为摸两张牌。",
}

return hedao