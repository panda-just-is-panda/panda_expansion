local ranyan = fk.CreateSkill {
  name = "pang_ranyan",
  tags = {Skill.Compulsory},
}

ranyan:addEffect(fk.DamageInflicted, {
anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(ranyan.name) and data.damageType == fk.FireDamage
  end,
  on_use = function(self, event, target, player, data)
    data:preventDamage()
  end,
})

ranyan:addEffect(fk.DamageCaused, {
anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(ranyan.name) and data.damageType == fk.FireDamage
    
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, ranyan.name)
  end,
})


Fk:loadTranslationTable {["pang_ranyan"] = "燃焰",
[":pang_ranyan"] = "锁定技，当你造成火焰伤害时，你摸一张牌；当你受到火焰伤害时，防止此伤害。",

["$pang_ranyan1"] = "",
["$pang_ranyan2"] = "",
}
return ranyan