local touxiang = fk.CreateSkill({
  name = "pang_touxiang", ---技能内部名称，要求唯一性
  tags = {}, -- 技能标签，Skill.Compulsory代表锁定技，支持存放多个标签
})

Fk:loadTranslationTable {["pang_touxiang"] = "头像",
[":pang_touxiang"] = "这是一个头像。",
}
return touxiang