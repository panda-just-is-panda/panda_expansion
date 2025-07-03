local haizaishuzhi = fk.CreateSkill {
  name = "pang_haizaishuzhi",
  tags = {Skill.Permanent, Skill.Compulsory},
}

haizaishuzhi:addEffect(fk.TurnStart, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(haizaishuzhi.name)
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(64, haizaishuzhi.name)
  end,
})

haizaishuzhi:addEffect(fk.DamageCaused, {
anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(haizaishuzhi.name)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data:changeDamage(64)
  end,
})

Fk:loadTranslationTable {["pang_haizaishuzhi"] = "还在数值",
[":pang_haizaishuzhi"] = "持恒技，回合开始时，你摸64张牌；当你造成伤害时，此伤害+64。",
}
return haizaishuzhi