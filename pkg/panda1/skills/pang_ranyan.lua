local ranyan = fk.CreateSkill {
  name = "pang_ranyan",
  tags = {Skill.Compulsory},
}

ranyan:addEffect(fk.DamageInflicted, {
mute = true,
anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(ranyan.name) and data.damageType == fk.FireDamage
  end,
  on_use = function(self, event, target, player, data)
    data:preventDamage()
    player:broadcastSkillInvoke(ranyan.name, 2)
  end,
})

ranyan:addEffect(fk.DamageCaused, {
mute = true,
anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(ranyan.name) and data.damageType == fk.FireDamage
    
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, ranyan.name)
    player:broadcastSkillInvoke(ranyan.name, 1)
  end,
})


Fk:loadTranslationTable {["pang_ranyan"] = "燃焰",
[":pang_ranyan"] = "锁定技，当你造成火焰伤害时，你摸一张牌；当你受到火焰伤害时，防止此伤害。",

["$pang_ranyan1"] = "嗡——呼——",
["$pang_ranyan2"] = "噼里噼里啪啦——",
}
return ranyan