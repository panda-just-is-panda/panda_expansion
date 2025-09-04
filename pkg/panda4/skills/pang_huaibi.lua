local huaibi = fk.CreateSkill {
  name = "pang_huaibi",
  tags = { Skill.Compulsory, Skill.Lord },
}

Fk:loadTranslationTable{
  ["pang_huaibi"] = "怀璧",
  [":pang_huaibi"] = "主公技，锁定技，游戏开始时，你获得2点护甲；有护甲的群势力角色受到伤害时，伤害来源获得1点护甲。",

  ["$pang_huaibi1"] = "哎！匹夫无罪，怀璧其罪啊。",
  ["$pang_huaibi2"] = "粮草尽皆在此，宗兄可自取之。",
}

huaibi:addEffect(fk.GameStart, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(huaibi.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:changeShield(player, 2, {cancelable = false})
  end,
})

huaibi:addEffect(fk.DamageInflicted, {
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(huaibi.name) and target.kingdom == "qun" and target.shield > 0 and data.from
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = data.from
    room:changeShield(to, 1, {cancelable = false})
  end,
})


return huaibi