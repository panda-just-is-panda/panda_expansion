local shenghua = fk.CreateSkill {
  name = "pang_shenghua",
  tags = {Skill.Compulsory},
}

shenghua:addEffect(fk.DamageCaused, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(shenghua.name)
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1)
  end,
})

Fk:loadTranslationTable {["pang_shenghua"] = "升华",
[":pang_shenghua"] = "锁定技，当你造成伤害时，此伤害+1。",
}

return shenghua