local zhiguang = fk.CreateSkill {
  name = "pang_zhiguang",
  tags = {},
}

Fk:loadTranslationTable {["pang_zhiguang"] = "织光",
[":pang_zhiguang"] = "出牌阶段限一次，你可以失去1点体力并选择一项：令所有角色各失去1点体力；令至多两名角色各获得1点护甲。",
}

return zhiguang