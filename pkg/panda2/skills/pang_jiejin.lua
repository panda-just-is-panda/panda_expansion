local jiejin = fk.CreateSkill {
  name = "pang_jiejin",
  tags = {},
}

Fk:loadTranslationTable {["pang_jiejin"] = "阶进",
[":pang_jiejin"] = "锁定技，当一名角色死亡时，你视为使用一张无距离限制的雷【杀】；若此技能已升级，此【杀】可以额外指定任意名角色为目标。",
}

return jiejin